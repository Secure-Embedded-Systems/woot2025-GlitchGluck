//----------------------------------------------------------------------------
//
// *File Name: tb_template.v 
// 
// *Module Description:
//                       ASIC RTL TB TEMPLATE
//
// *Author(s):
//              - Zhenyuan Charlotte Liu,    zliu12@wpi.edu
//
//----------------------------------------------------------------------------

`timescale 1ns / 1ps
`default_nettype wire 

`include "../../shared/msp430/rtl/cw305interface/cw305_defines.v"

module tb();

	parameter pADDR_WIDTH = 21;
	parameter pBYTECNT_SIZE = 7;
	parameter pUSB_CLOCK_PERIOD = 10;
	parameter pPLL_CLOCK_PERIOD = 25;
	parameter pNCORES = 6;

        parameter scan_bits = 1702*6;

	// MSP430 command frames
	parameter MSP430_DEBUG_CMD_WR    = 8'h80;   
	parameter MSP430_DEBUG_CMD_RD    = 8'h00;   
	parameter MSP430_DEBUG_CMD_8BIT  = 8'h40;   
	parameter MSP430_DEBUG_CMD_16BIT = 8'h00;   

	// bit definitions for I2C CMD
	parameter I2C_CMD_START = 8'h80;
	parameter I2C_CMD_STOP  = 8'h40;
	parameter I2C_CMD_RD    = 8'h20;
	parameter I2C_CMD_WR    = 8'h10;
	parameter I2C_CMD_ACK   = 8'h8;
	parameter I2C_CMD_IACK  = 8'h1;
	
	// bit definitions for I2C STATUS
	parameter I2C_STATUS_RXACK = 8'h80;
	parameter I2C_STATUS_BUSY  = 8'h40;
	parameter I2C_STATUS_AL    = 8'h20;
	parameter I2C_STATUS_TIP   = 8'h2;
	parameter I2C_STATUS_IF    = 8'h1;

	// I2C addresses
	parameter I2C_ADDRESS_BCAST  = 7'h50;
	parameter I2C_ADDRESS_CORE_0 = 7'h51;
	parameter I2C_ADDRESS_CORE_1 = 7'h52;
	parameter I2C_ADDRESS_CORE_2 = 7'h53;
	parameter I2C_ADDRESS_CORE_3 = 7'h54;
        parameter I2C_ADDRESS_CORE_4 = 7'h55;
        parameter I2C_ADDRESS_CORE_5 = 7'h56;
	
	// CPU CONTROL bits
	parameter CPU_CTL_CPU_RST    = 8'h40;
	parameter CPU_CTL_RST_BRK_EN = 8'h20;
	parameter CPU_CTL_FRZ_BRK_EN = 8'h10;
	parameter CPU_CTL_SW_BRK_EN  = 8'h08;
	parameter CPU_CTL_ISTEP      = 8'h04;
	parameter CPU_CTL_RUN        = 8'h02;
	parameter CPU_CTL_HALT       = 8'h01;
	
	// Debug Unit Register Mapping
	parameter DBG_CPU_ID_LO = 8'h00;
	parameter DBG_CPU_ID_HI = 8'h01;
	parameter DBG_CPU_CTL   = 8'h02;
	parameter DBG_CPU_STAT  = 8'h03;
	parameter DBG_MEM_CTL   = 8'h04;
	parameter DBG_MEM_ADDR  = 8'h05;
	parameter DBG_MEM_DATA  = 8'h06;
	parameter DBG_MEM_CNT   = 8'h07;
	parameter DBG_BRK0_CTL  = 8'h08;
	parameter DBG_BRK0_STAT = 8'h09;
	parameter DBG_BRK0_ADDR0= 8'h0a;
	parameter DBG_BRK0_ADDR1= 8'h0b;
	parameter DBG_BRK1_CTL  = 8'h0c;
	parameter DBG_BRK1_STAT = 8'h0d;
	parameter DBG_BRK1_ADDR0= 8'h0e;
	parameter DBG_BRK1_ADDR1= 8'h0f;
	parameter DBG_BRK2_CTL  = 8'h00;
	parameter DBG_BRK2_STAT = 8'h11;
	parameter DBG_BRK2_ADDR0= 8'h12;
	parameter DBG_BRK2_ADDR1= 8'h13;
	parameter DBG_BRK3_CTL  = 8'h14;
	parameter DBG_BRK3_STAT = 8'h15;
	parameter DBG_BRK3_ADDR0= 8'h16;
	parameter DBG_BRK3_ADDR1= 8'h17;
	parameter DBG_CPU_NR    = 8'h18;
	
	// MEM_CTL bit definitions
	parameter MEM_CTL_START  = 8'h01;
	parameter MEM_CTL_RDWR   = 8'h02;
	parameter MEM_CTL_MEMREG = 8'h04;
	parameter MEM_CTL_BW     = 8'h08;
	
	// Wires and Regs
	reg usb_clk;
	reg usb_clk_enable;
	wire [7:0] usb_data;
	reg [7:0] usb_wdata;
	reg [pADDR_WIDTH-1:0] usb_addr;
	reg usb_rdn;
	reg usb_wrn;
	reg usb_cen;
	reg usb_trigger;
	
	reg j16_sel;
	reg k16_sel;
	reg k15_sel;
	reg l14_sel;
	reg pushbutton;
	reg pll_clk1;
	wire tio_clkin;
	
	wire tio_trigger;
	
	wire i2c_scl;
	wire i2c_sda;

        reg scan_enable, scan_mode, scan_in;
        wire scan_out;

	integer prescale;
	
	wire clk = pll_clk1;
	
	reg set_glitch;
	reg clock_glitch;
	wire clock_glitch_pll_clk1 = pll_clk1 ^ clock_glitch;
	
	reg [7:0] byteback;
	reg [15:0] wordback;

	reg read_select;

	assign usb_data = read_select? 8'bz : usb_wdata;
	assign tio_clkin = clock_glitch_pll_clk1;

	always @(*) begin
		if (usb_wrn == 1'b0)
			read_select = 1'b0;
		else if (usb_rdn == 1'b0)
			read_select = 1'b1;
	end

	`include "../../shared/msp430/rtl/tb_cw305_reg_tasks.v"
	always #(pUSB_CLOCK_PERIOD/2) usb_clk = !usb_clk;
	always #(pPLL_CLOCK_PERIOD/2) pll_clk1 = !pll_clk1;

	wire #1 usb_rdn_out = usb_rdn;
	wire #1 usb_wrn_out = usb_wrn;
	wire #1 usb_cen_out = usb_cen;
	wire #1 usb_trigger_out = usb_trigger;

	tb_six_core_msp430_scan_with_pads #(
        	.pBYTECNT_SIZE            (pBYTECNT_SIZE),
	        .pADDR_WIDTH              (pADDR_WIDTH),
		.pNCORES		  (pNCORES)
    	) U_dut (
        	.usb_clk                  (usb_clk & usb_clk_enable),
	        .usb_data                 (usb_data),
	        .usb_addr                 (usb_addr),
	        .usb_rdn                  (usb_rdn_out),
	        .usb_wrn                  (usb_wrn_out),
        	.usb_cen                  (usb_cen_out),
	        .usb_trigger              (usb_trigger_out),
	        .j16_sel                  (j16_sel),
	        .k16_sel                  (k16_sel),
	        .k15_sel                  (k15_sel),
	        .l14_sel                  (l14_sel),
	        .pushbutton               (pushbutton),
	        .pll_clk1                 (clock_glitch_pll_clk1),
	        .tio_trigger              (tio_trigger),
	        .tio_clkout               (),          
	        .tio_clkin                (tio_clkin),
	        .io6                      (i2c_scl),
	        .io8                      (i2c_sda),
                .scan_enable              (scan_enable),
                .scan_mode                (scan_mode),
                .scan_in                  (scan_in),
                .scan_out                 (scan_out)

	);

	integer cycle_counter;
	integer pc_doc,cycle_start_end_time;
	reg ready_to_dump,ready_to_glitch,pos_executed;
	integer i;

        integer memdump_file,value_file_Q;
	integer scan_file;

	`include "../../shared/msp430/valuetree/core1/valuetree_decl.v"

	initial begin
	$timeformat(-9, 2, "ns", 20);
	
	usb_clk = 1'b1;
	usb_clk_enable = 1'b1;
	pll_clk1 = 1'b1;
	clock_glitch = 1'b0;
	set_glitch = 1'b0;

        usb_wdata = 0;
        usb_addr = 0;
        usb_rdn = 1;
        usb_wrn = 1;
        usb_cen = 1;
        usb_trigger = 0;

        j16_sel = 0;
        k16_sel = 0;
        k15_sel = 0;
        l14_sel = 0;
        pushbutton = 1;
        pll_clk1 = 0;

        scan_enable = 1'b0;
        scan_mode = 1'b0;
        scan_in = 1'b0;
	
	ready_to_dump = 1'b0;
	ready_to_glitch = 1'b0;

	pos_executed = 1'b0;

	pc_doc = $fopen("pc.txt","w");
        $fwrite(pc_doc,"Time,ClockCycle,PC\n");

	cycle_start_end_time = $fopen("cycle_start_end_time.txt","w");
	$fwrite(cycle_start_end_time,"Cycle,StartTime,EndTime\n");

        cycle_counter = 0;

        value_file_Q = $fopen("valuedata_Q.json","w");
        $fwrite(value_file_Q,"{\n");
        $fwrite(value_file_Q,"\"id\" : {\n");

	`include "../../shared/msp430/valuetree/core1/valuetree_Q_id.v"	
	
        $fwrite(value_file_Q,"},\n");

        $fwrite(value_file_Q,"\"digest\" : [\n");

	scan_file = $fopen("scandata.json","w");
	$fwrite(scan_file,"{ \"scan\" : [\n");


        // reset
        #(pUSB_CLOCK_PERIOD*2) pushbutton = 0;
        #(pUSB_CLOCK_PERIOD*2) pushbutton = 1;
        #(pUSB_CLOCK_PERIOD*10);

        // reset MSP430 core
        write_bytes(0, 1, `REG_CRYPT_RESET, 8'h0);
        repeat (20) @(posedge usb_clk);

        prescale = 96000000 / 5 / 4000000 - 1;
        write_bytes(0, 1, `REG_I2C_PRESCALE_LO, prescale & 8'hff);
        write_bytes(0, 1, `REG_I2C_PRESCALE_HI, prescale / 256);

        // enable I2C core
        write_bytes(0, 1, `REG_I2C_CONTROL, 8'h80);

        halt_cpu(I2C_ADDRESS_BCAST);

        read_cpu_status(I2C_ADDRESS_CORE_0, byteback);
        $display("status CPU %d = %d", I2C_ADDRESS_CORE_0, byteback);
        read_cpu_status(I2C_ADDRESS_CORE_1, byteback);
        $display("status CPU %d = %d", I2C_ADDRESS_CORE_1, byteback);
        read_cpu_status(I2C_ADDRESS_CORE_2, byteback);
        $display("status CPU %d = %d", I2C_ADDRESS_CORE_2, byteback);
        read_cpu_status(I2C_ADDRESS_CORE_3, byteback);
        $display("status CPU %d = %d", I2C_ADDRESS_CORE_3, byteback);
        read_cpu_status(I2C_ADDRESS_CORE_4, byteback);
        $display("status CPU %d = %d", I2C_ADDRESS_CORE_4, byteback);
        read_cpu_status(I2C_ADDRESS_CORE_5, byteback);
        $display("status CPU %d = %d", I2C_ADDRESS_CORE_5, byteback);

        reset_cpu(I2C_ADDRESS_BCAST);

        $display("load hex start:%0t",$time);
        $display("Loading firmware : %s", `TARGET);
        loadhexfile(I2C_ADDRESS_BCAST, {"../../../firmware/msp430/",`TARGET,"/app.ver"});
        $display("load hex end:%0t",$time);

        reset_cpu(I2C_ADDRESS_BCAST);

	//run_cpu(I2C_ADDRESS_BCAST);

	$dumpfile("tb.vcd");
	$dumpvars(0, tb.U_dut.six_core_U_msp430_scan_w_pads);

	ready_to_dump = 1'b1;

        run_cpu(I2C_ADDRESS_BCAST);

	ready_to_glitch = 1'b1;

	for (i = 0; i < `CLOCK_TO_RUN; i = i + 1) begin
		#(pPLL_CLOCK_PERIOD);
	end

	ready_to_glitch = 1'b0;
	ready_to_dump = 1'b0;
	
	$dumpoff;

        $fwrite(value_file_Q,"] }\n");
        $fclose(value_file_Q);

        $fwrite(scan_file,"] }\n");
        $fclose(scan_file);

	$display("mem dump starts");

        //memdump_file = $fopen("memdump.txt","w");
        //write_file_debug_data_datamem_core(memdump_file, I2C_ADDRESS_CORE_0);
        //$fclose(memdump_file);

	$finish;

	end

always@(negedge tb.U_dut.crypt_clk) begin
        if (ready_to_dump==1'b1) begin

                if (cycle_counter == 0) begin
                        $fwrite(value_file_Q,"{\n");
                end
                else begin
                        $fwrite(value_file_Q,",{\n");
                end

                $fwrite(value_file_Q,"   \"cycle\" : \"%0d\",\n", cycle_counter);
                $fwrite(value_file_Q,"   \"value\"  : {\n");

                `include "../../shared/msp430/valuetree/core1/valuetree_Q.v"

                $fwrite(value_file_Q,"}}\n");


		$fwrite(pc_doc,"%0.0f %0d %4x\n", $time*1000, cycle_counter, tb.U_dut.six_core_U_msp430_scan_w_pads.chipInst.msp430Inst_1.openmsp430_0.pc);

		$fwrite(cycle_start_end_time,"%0d %0.0f %0.0f\n", cycle_counter, (($time - (pPLL_CLOCK_PERIOD / 2) + 1.060) * 1000), (($time + (pPLL_CLOCK_PERIOD / 2) + 1.060) * 1000));

                $fwrite(scan_file,",{\n");

                $fwrite(scan_file,"   \"cycle\" : \"%0d\",\n", cycle_counter);
                $fwrite(scan_file,"   \"core\"  : {\n");

                `include "../../shared/msp430/valuetree/core1/fwritescan.v"

                $fwrite(scan_file,"}}\n");


		cycle_counter = cycle_counter + 1;
	end
end


// ---------------------
// TASKS AND FUNCTIONS 
// ---------------------
task write_file_debug_data_gpio(input integer f, input reg [6:0] coreid);
     reg [15:0] mem0,mem1,mem2,mem3,
                mem4,mem5,mem6,mem7,
                mem8,mem9,mem10,mem11,
                mem12,mem13,mem14,mem15,
                mem16,mem17;
     begin
        debug_read_memory(coreid, 16'h18, mem0);
        debug_read_memory(coreid, 16'h1A, mem1);
        debug_read_memory(coreid, 16'h1C, mem2);
        debug_read_memory(coreid, 16'h1E, mem3);
        debug_read_memory(coreid, 16'h20, mem4);
        debug_read_memory(coreid, 16'h22, mem5);
        debug_read_memory(coreid, 16'h24, mem6);
//        $fwrite(f, "M0018 %4x %4x %4x %4x %4x %4x %4x\n", mem0, mem1, mem2, mem3, mem4, mem5, mem6);
        debug_read_memory(coreid, 16'h26, mem7);
        debug_read_memory(coreid, 16'h28, mem8);
        debug_read_memory(coreid, 16'h2A, mem9);
        debug_read_memory(coreid, 16'h2C, mem10);
        debug_read_memory(coreid, 16'h2E, mem11);
        debug_read_memory(coreid, 16'h30, mem12);
        debug_read_memory(coreid, 16'h32, mem13);
//        $fwrite(f, "M0026 %4x %4x %4x %4x %4x %4x %4x\n", mem0, mem1, mem2, mem3, mem4, mem5, mem6);
        debug_read_memory(coreid, 16'h34, mem14);
        debug_read_memory(coreid, 16'h36, mem15);
        debug_read_memory(coreid, 16'h38, mem16);
        debug_read_memory(coreid, 16'h3A, mem17);
        $fwrite(f, "M0018 %4x %4x %4x %4x %4x %4x %4x M0026 %4x %4x %4x %4x %4x %4x %4x M0034 %4x %4x %4x %4x\n", mem0, mem1, mem2, mem3, mem4, mem5, mem6, mem7, mem8, mem9, mem10, mem11, mem12, mem13, mem14, mem15, mem16, mem17);
    end
endtask

task write_file_debug_data_reg(input integer f, input reg [6:0] coreid);
     reg [15:0] mem0,mem1,mem2,mem3,
                mem4,mem5,mem6,mem7,
                mem8,mem9,mem10,mem11,
                mem12,mem13,mem14,mem15;
     begin
        $fwrite(f, "Core ID %x Test ID 0000\n", coreid);
        debug_read_reg(coreid, 16'h00, mem0);
        debug_read_reg(coreid, 16'h01, mem1);
        debug_read_reg(coreid, 16'h02, mem2);
        debug_read_reg(coreid, 16'h03, mem3);
        debug_read_reg(coreid, 16'h04, mem4);
        debug_read_reg(coreid, 16'h05, mem5);
        debug_read_reg(coreid, 16'h06, mem6);
        debug_read_reg(coreid, 16'h07, mem7);
        debug_read_reg(coreid, 16'h08, mem8);
        debug_read_reg(coreid, 16'h09, mem9);
        debug_read_reg(coreid, 16'h0A, mem10);
        debug_read_reg(coreid, 16'h0B, mem11);
        debug_read_reg(coreid, 16'h0C, mem12);
        debug_read_reg(coreid, 16'h0D, mem13);
        debug_read_reg(coreid, 16'h0E, mem14);
        debug_read_reg(coreid, 16'h0F, mem15);
        $fwrite(f, "R0 %4x R1 %4x R2 %4x R3 %4x R4 %4x R5 %4x R6 %4x R7 %4x R8 %4x R9 %4x RA %4x RB %4x RC %4x RD %4x RE %4x RF %4x\n", mem0, mem1, mem2, mem3, mem4, mem5, mem6, mem7, mem8, mem9, mem10, mem11, mem12, mem13, mem14, mem15);
    end
endtask

task write_file_debug_data_cpunr(input integer f, input reg [6:0] coreid);
     reg [15:0] mem0;
     begin
        debug_read_memory(coreid, 16'h08, mem0);
        $fwrite(f, "CPU_NR %4x\n", mem0);
    end
endtask

task write_file_debug_data_timerA(input integer f, input reg [6:0] coreid);
     reg [15:0] mem0,mem1,mem2,mem3,
                mem4,mem5,mem6,mem7,
                mem8;
     begin
    debug_read_memory(coreid, 16'h12E, mem0);
        debug_read_memory(coreid, 16'h160, mem1);
        debug_read_memory(coreid, 16'h162, mem2);
        debug_read_memory(coreid, 16'h164, mem3);
        debug_read_memory(coreid, 16'h166, mem4);
        debug_read_memory(coreid, 16'h170, mem5);
        debug_read_memory(coreid, 16'h172, mem6);
        debug_read_memory(coreid, 16'h174, mem7);
        debug_read_memory(coreid, 16'h176, mem8);
        $fwrite(f, "M012E %4x M0160 %4x %4x %4x %4x M0170 %4x %4x %4x %4x\n", mem0, mem1, mem2, mem3, mem4, mem5, mem6, mem7, mem8);
//        $fwrite(f, "M012E %4x\n", mem0);
//        $fwrite(f, "M0160 %4x %4x %4x %4x\n", mem1, mem2, mem3, mem4);
//        $fwrite(f, "M0170 %4x %4x %4x %4x\n", mem5, mem6, mem7, mem8);
    end
endtask

task write_file_debug_data_datamem_core(input integer f, input reg [6:0] coreid);
     reg [15:0] mem0,mem1,mem2,mem3,
                mem4,mem5,mem6,mem7,
                mem8,mem9,mem10,mem11,
                mem12,mem13,mem14,mem15,
                mem16,mem17,mem18,mem19,
                mem20;
     begin
        $fwrite(memdump_file,"ADDR CORE0\n");
        debug_read_memory(coreid, 16'h1200, mem0);
        $fwrite(f, "M1200 %4x \n", mem0);
	debug_read_memory(coreid, 16'h11fe, mem0);
        $fwrite(f, "M11fe %4x \n", mem0);
        debug_read_memory(coreid, 16'h11fc, mem0);
        $fwrite(f, "M11fc %4x \n", mem0);
        debug_read_memory(coreid, 16'h11fa, mem0);
        $fwrite(f, "M11fa %4x \n", mem0);
        debug_read_memory(coreid, 16'h11f8, mem0);
        $fwrite(f, "M11f8 %4x \n", mem0);
        debug_read_memory(coreid, 16'h11f6, mem0);
        $fwrite(f, "M11f6 %4x \n", mem0);
        debug_read_memory(coreid, 16'h11f4, mem0);
        $fwrite(f, "M11f4 %4x \n", mem0);
        debug_read_memory(coreid, 16'h11f2, mem0);
        $fwrite(f, "M11f2 %4x \n", mem0);
        debug_read_memory(coreid, 16'h11f0, mem0);
        $fwrite(f, "M11f0 %4x \n", mem0);
        debug_read_memory(coreid, 16'h11ee, mem0);
        $fwrite(f, "M11ee %4x \n", mem0);
        debug_read_memory(coreid, 16'h11ec, mem0);
        $fwrite(f, "M11ec %4x \n", mem0);
        debug_read_memory(coreid, 16'h11ea, mem0);
        $fwrite(f, "M11ea %4x \n", mem0);
        $fwrite(f, "...\n");
        debug_read_memory(coreid, 16'h212, mem0);
        $fwrite(f, "M0212 %4x \n", mem0);
        debug_read_memory(coreid, 16'h210, mem0);
        $fwrite(f, "M0210 %4x \n", mem0);
        debug_read_memory(coreid, 16'h20e, mem0);
        $fwrite(f, "M020e %4x \n", mem0);
        debug_read_memory(coreid, 16'h20c, mem0);
        $fwrite(f, "M020c %4x \n", mem0);
        debug_read_memory(coreid, 16'h20a, mem0);
        $fwrite(f, "M020a %4x \n", mem0);
        debug_read_memory(coreid, 16'h208, mem0);
        $fwrite(f, "M0208 %4x \n", mem0);
        debug_read_memory(coreid, 16'h206, mem0);
        $fwrite(f, "M0206 %4x \n", mem0);
        debug_read_memory(coreid, 16'h204, mem0);
        $fwrite(f, "M0204 %4x \n", mem0);
        debug_read_memory(coreid, 16'h202, mem0);
        $fwrite(f, "M0202 %4x \n", mem0);
        debug_read_memory(coreid, 16'h200, mem0);
        $fwrite(f, "M0200 %4x \n", mem0);

    end
endtask


task write_file_debug_data_datamem_all(input integer f);
     reg [15:0] mem0,mem1,mem2,mem3,
                mem4,mem5,mem6,mem7,
                mem8,mem9,mem10,mem11,
                mem12,mem13,mem14,mem15,
                mem16,mem17,mem18,mem19,
                mem20;
     begin
	$fwrite(memdump_file,"ADDR   C0   C1   C2   C3   C4   C5\n");
        debug_read_memory(I2C_ADDRESS_CORE_0, 16'h1200, mem0);
        $fwrite(f, "M1200 %4x ", mem0);
	debug_read_memory(I2C_ADDRESS_CORE_1, 16'h1200, mem0);
	$fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_2, 16'h1200, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_3, 16'h1200, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_4, 16'h1200, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_5, 16'h1200, mem0);
        $fwrite(f, "%4x\n", mem0);


	debug_read_memory(I2C_ADDRESS_CORE_0, 16'h11fe, mem0);
        $fwrite(f, "M11fe %4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_1, 16'h11fe, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_2, 16'h11fe, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_3, 16'h11fe, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_4, 16'h11fe, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_5, 16'h11fe, mem0);
        $fwrite(f, "%4x\n", mem0);


        debug_read_memory(I2C_ADDRESS_CORE_0, 16'h11fc, mem0);
        $fwrite(f, "M11fc %4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_1, 16'h11fc, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_2, 16'h11fc, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_3, 16'h11fc, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_4, 16'h11fc, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_5, 16'h11fc, mem0);
        $fwrite(f, "%4x\n", mem0);


        debug_read_memory(I2C_ADDRESS_CORE_0, 16'h11fa, mem0);
        $fwrite(f, "M11fa %4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_1, 16'h11fa, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_2, 16'h11fa, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_3, 16'h11fa, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_4, 16'h11fa, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_5, 16'h11fa, mem0);
        $fwrite(f, "%4x\n", mem0);

        debug_read_memory(I2C_ADDRESS_CORE_0, 16'h11f8, mem0);
        $fwrite(f, "M11f8 %4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_1, 16'h11f8, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_2, 16'h11f8, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_3, 16'h11f8, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_4, 16'h11f8, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_5, 16'h11f8, mem0);
        $fwrite(f, "%4x\n", mem0);


        debug_read_memory(I2C_ADDRESS_CORE_0, 16'h11f6, mem0);
        $fwrite(f, "M11f6 %4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_1, 16'h11f6, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_2, 16'h11f6, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_3, 16'h11f6, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_4, 16'h11f6, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_5, 16'h11f6, mem0);
        $fwrite(f, "%4x\n", mem0);

        debug_read_memory(I2C_ADDRESS_CORE_0, 16'h11f4, mem0);
        $fwrite(f, "M11f4 %4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_1, 16'h11f4, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_2, 16'h11f4, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_3, 16'h11f4, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_4, 16'h11f4, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_5, 16'h11f4, mem0);
        $fwrite(f, "%4x\n", mem0);


        debug_read_memory(I2C_ADDRESS_CORE_0, 16'h11f2, mem0);
        $fwrite(f, "M11f2 %4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_1, 16'h11f2, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_2, 16'h11f2, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_3, 16'h11f2, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_4, 16'h11f2, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_5, 16'h11f2, mem0);
        $fwrite(f, "%4x\n", mem0);

        debug_read_memory(I2C_ADDRESS_CORE_0, 16'h11f0, mem0);
        $fwrite(f, "M11f0 %4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_1, 16'h11f0, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_2, 16'h11f0, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_3, 16'h11f0, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_4, 16'h11f0, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_5, 16'h11f0, mem0);
        $fwrite(f, "%4x\n", mem0);

        debug_read_memory(I2C_ADDRESS_CORE_0, 16'h11ee, mem0);
        $fwrite(f, "M11ee %4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_1, 16'h11ee, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_2, 16'h11ee, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_3, 16'h11ee, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_4, 16'h11ee, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_5, 16'h11ee, mem0);
        $fwrite(f, "%4x\n", mem0);

        debug_read_memory(I2C_ADDRESS_CORE_0, 16'h11ec, mem0);
        $fwrite(f, "M11ec %4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_1, 16'h11ec, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_2, 16'h11ec, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_3, 16'h11ec, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_4, 16'h11ec, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_5, 16'h11ec, mem0);
        $fwrite(f, "%4x\n", mem0);

        debug_read_memory(I2C_ADDRESS_CORE_0, 16'h11ea, mem0);
        $fwrite(f, "M11ea %4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_1, 16'h11ea, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_2, 16'h11ea, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_3, 16'h11ea, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_4, 16'h11ea, mem0);
        $fwrite(f, "%4x ", mem0);     
        debug_read_memory(I2C_ADDRESS_CORE_5, 16'h11ea, mem0);
        $fwrite(f, "%4x\n", mem0);

        $fwrite(f, "...\n");

        debug_read_memory(I2C_ADDRESS_CORE_0, 16'h212, mem0);
        $fwrite(f, "M0212 %4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_1, 16'h212, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_2, 16'h212, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_3, 16'h212, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_4, 16'h212, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_5, 16'h212, mem0);
        $fwrite(f, "%4x\n", mem0);

        debug_read_memory(I2C_ADDRESS_CORE_0, 16'h210, mem0);
        $fwrite(f, "M0210 %4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_1, 16'h210, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_2, 16'h210, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_3, 16'h210, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_4, 16'h210, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_5, 16'h210, mem0);
        $fwrite(f, "%4x\n", mem0);

        debug_read_memory(I2C_ADDRESS_CORE_0, 16'h20e, mem0);
        $fwrite(f, "M020e %4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_1, 16'h20e, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_2, 16'h20e, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_3, 16'h20e, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_4, 16'h20e, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_5, 16'h20e, mem0);
        $fwrite(f, "%4x\n", mem0);

        debug_read_memory(I2C_ADDRESS_CORE_0, 16'h20c, mem0);
        $fwrite(f, "M020c %4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_1, 16'h20c, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_2, 16'h20c, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_3, 16'h20c, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_4, 16'h20c, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_5, 16'h20c, mem0);
        $fwrite(f, "%4x\n", mem0);

        debug_read_memory(I2C_ADDRESS_CORE_0, 16'h20a, mem0);
        $fwrite(f, "M020a %4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_1, 16'h20a, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_2, 16'h20a, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_3, 16'h20a, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_4, 16'h20a, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_5, 16'h20a, mem0);
        $fwrite(f, "%4x\n", mem0);

        debug_read_memory(I2C_ADDRESS_CORE_0, 16'h208, mem0);
        $fwrite(f, "M0208 %4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_1, 16'h208, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_2, 16'h208, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_3, 16'h208, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_4, 16'h208, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_5, 16'h208, mem0);
        $fwrite(f, "%4x\n", mem0);

        debug_read_memory(I2C_ADDRESS_CORE_0, 16'h206, mem0);
        $fwrite(f, "M0206 %4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_1, 16'h206, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_2, 16'h206, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_3, 16'h206, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_4, 16'h206, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_5, 16'h206, mem0);
        $fwrite(f, "%4x\n", mem0);

        debug_read_memory(I2C_ADDRESS_CORE_0, 16'h204, mem0);
        $fwrite(f, "M0204 %4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_1, 16'h204, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_2, 16'h204, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_3, 16'h204, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_4, 16'h204, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_5, 16'h204, mem0);
        $fwrite(f, "%4x\n", mem0);

        debug_read_memory(I2C_ADDRESS_CORE_0, 16'h202, mem0);
        $fwrite(f, "M0202 %4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_1, 16'h202, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_2, 16'h202, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_3, 16'h202, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_4, 16'h202, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_5, 16'h202, mem0);
        $fwrite(f, "%4x\n", mem0);

        debug_read_memory(I2C_ADDRESS_CORE_0, 16'h200, mem0);
        $fwrite(f, "M0200 %4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_1, 16'h200, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_2, 16'h200, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_3, 16'h200, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_4, 16'h200, mem0);
        $fwrite(f, "%4x ", mem0);
        debug_read_memory(I2C_ADDRESS_CORE_5, 16'h200, mem0);
        $fwrite(f, "%4x\n", mem0);
    end
endtask



task write_file_debug_data_progmem(input integer f, input reg [6:0] coreid);
     reg [15:0] mem0,mem1,mem2,mem3,
                mem4,mem5,mem6,mem7,
                mem8,mem9,mem10,mem11,
                mem12,mem13,mem14,mem15,
                mem16,mem17,mem18,mem19,
                mem20,mem21,mem22,mem23,
                mem24,mem25,mem26,mem27,
                mem28,mem29,mem30,mem31;
     begin
        debug_read_memory(coreid, 16'hf000, mem0);
        debug_read_memory(coreid, 16'hf002, mem1);
        debug_read_memory(coreid, 16'hf004, mem2);
        debug_read_memory(coreid, 16'hf006, mem3);
        debug_read_memory(coreid, 16'hf008, mem4);
        debug_read_memory(coreid, 16'hf00A, mem5);
        debug_read_memory(coreid, 16'hf00C, mem6);
        debug_read_memory(coreid, 16'hf00E, mem7);
        debug_read_memory(coreid, 16'hf010, mem8);
        debug_read_memory(coreid, 16'hf012, mem9);
        debug_read_memory(coreid, 16'hf014, mem10);
        debug_read_memory(coreid, 16'hf016, mem11);
        debug_read_memory(coreid, 16'hf018, mem12);
        debug_read_memory(coreid, 16'hf01A, mem13);
        debug_read_memory(coreid, 16'hf01C, mem14);
        debug_read_memory(coreid, 16'hf01E, mem15);
        debug_read_memory(coreid, 16'hf020, mem16);
        debug_read_memory(coreid, 16'hf022, mem17);
        debug_read_memory(coreid, 16'hf024, mem18);
        debug_read_memory(coreid, 16'hf026, mem19);
        debug_read_memory(coreid, 16'hf028, mem20);
        debug_read_memory(coreid, 16'hf02A, mem21);
        debug_read_memory(coreid, 16'hf02C, mem22);
        debug_read_memory(coreid, 16'hf02E, mem23);
        debug_read_memory(coreid, 16'hf030, mem24);
        debug_read_memory(coreid, 16'hf032, mem25);
        debug_read_memory(coreid, 16'hf034, mem26);
        debug_read_memory(coreid, 16'hf036, mem27);
        debug_read_memory(coreid, 16'hf038, mem28);
        debug_read_memory(coreid, 16'hf03A, mem29);
        debug_read_memory(coreid, 16'hf03C, mem30);
        debug_read_memory(coreid, 16'hf03E, mem31);
        $fwrite(f, "MF000 %4x %4x %4x %4x %4x %4x %4x %4x MF010 %4x %4x %4x %4x %4x %4x %4x %4x MF020 %4x %4x %4x %4x %4x %4x %4x %4x MF030 %4x %4x %4x %4x %4x %4x %4x %4x\n", mem0, mem1, mem2, mem3, mem4, mem5, mem6, mem7, mem8, mem9, mem10, mem11, mem12, mem13, mem14, mem15, mem16, mem17, mem18, mem19, mem20, mem21, mem22, mem23, mem24, mem25, mem26, mem27, mem28, mem29, mem30, mem31);
    end
endtask


task loadhexfile(input reg [7:0] coreid, input [2049:0] fname);
  reg [7:0] progmem [0:65535];
  integer i;
  begin
  //$display("memory");
  for (i=0; i<65536; i=i+1)
    begin
      progmem[i] = 8'hxx;
    end
  $readmemh(fname,progmem);
//  $readmemh({"../../../../../firmware/",`TARGET,"/app.ver"},progmem);
  for (i = 0; i < 65536; i = i + 2)
    begin
    if (progmem[i] !== 8'hxx)
      begin
        debug_write_memory(coreid, i, {progmem[i+1], progmem[i]});
      end
    end
  end
endtask

task wait_done;
   reg busy;
   begin
   busy = 1;
   while (busy == 1) begin
      read_byte(0, `REG_CRYPT_GO, 0, busy);
   end
   end
endtask

function [7:0] cmdframe_wr16(input [7:0] msp430_debug_adr);
  cmdframe_wr16 = (MSP430_DEBUG_CMD_WR | MSP430_DEBUG_CMD_16BIT | msp430_debug_adr);
endfunction

function [7:0] cmdframe_wr8(input [7:0] msp430_debug_adr);
  cmdframe_wr8 = (MSP430_DEBUG_CMD_WR | MSP430_DEBUG_CMD_8BIT | msp430_debug_adr);
endfunction

function [7:0] cmdframe_rd16(input [7:0] msp430_debug_adr);
  cmdframe_rd16 = (MSP430_DEBUG_CMD_RD | MSP430_DEBUG_CMD_16BIT | msp430_debug_adr);
endfunction

function [7:0] cmdframe_rd8(input [7:0] msp430_debug_adr);
  cmdframe_rd8 = (MSP430_DEBUG_CMD_RD | MSP430_DEBUG_CMD_8BIT | msp430_debug_adr);
endfunction

function [7:0] i2cwrite(input [6:0] coreid);
  i2cwrite = {coreid, 1'b0};
endfunction

function [7:0] i2cread(input [6:0] coreid);
  i2cread = {coreid, 1'b1};
endfunction

task wait_for_i2c(output reg [7:0] byteback);
   begin
   byteback = I2C_STATUS_TIP;
   while (byteback & I2C_STATUS_TIP)
      begin
        repeat (100) @(posedge usb_clk);
        read_byte(0, `REG_I2C_STATUS, 0, byteback);
      end
   end
endtask

task i2c_rx_cmd(input reg [7:0] memaddr, output reg [7:0] data);
  begin
  write_bytes(0, 1, `REG_I2C_COMMAND, memaddr);
  wait_for_i2c(byteback);
  read_byte(0, `REG_I2C_RX, 0, data);
  end
endtask

task i2c_tx_cmd(input reg [7:0] memaddr, input reg [7:0] data);
  begin
  write_bytes(0, 1, `REG_I2C_TX, memaddr);
  write_bytes(0, 1, `REG_I2C_COMMAND, data);
  wait_for_i2c(byteback);
  end
endtask

task halt_cpu(input reg [7:0] coreid);
  begin
  i2c_tx_cmd(i2cwrite(coreid),          I2C_CMD_START | I2C_CMD_WR);
  i2c_tx_cmd(cmdframe_wr8(DBG_CPU_CTL), I2C_CMD_WR);
  i2c_tx_cmd(CPU_CTL_HALT,              I2C_CMD_STOP | I2C_CMD_WR);
  end
endtask

task reset_cpu(input reg [7:0] coreid);
  begin
  i2c_tx_cmd(i2cwrite(coreid),          I2C_CMD_START | I2C_CMD_WR);
  i2c_tx_cmd(cmdframe_wr8(DBG_CPU_CTL), I2C_CMD_WR);
  i2c_tx_cmd(CPU_CTL_CPU_RST,           I2C_CMD_STOP | I2C_CMD_WR);
  i2c_tx_cmd(i2cwrite(coreid),          I2C_CMD_START | I2C_CMD_WR);
  i2c_tx_cmd(cmdframe_wr8(DBG_CPU_CTL), I2C_CMD_WR);
  i2c_tx_cmd(0,                         I2C_CMD_STOP | I2C_CMD_WR);
  end
endtask

task run_cpu(input reg [7:0] coreid);
  begin
  i2c_tx_cmd(i2cwrite(coreid),          I2C_CMD_START | I2C_CMD_WR);
  i2c_tx_cmd(cmdframe_wr8(DBG_CPU_CTL), I2C_CMD_WR);
  i2c_tx_cmd(CPU_CTL_RUN,               I2C_CMD_STOP | I2C_CMD_WR);
  end
endtask

task read_cpu_status(input reg [7:0] coreid, output reg [7:0] status);
  begin
  i2c_tx_cmd(i2cwrite(coreid), I2C_CMD_START | I2C_CMD_WR);
  i2c_tx_cmd(cmdframe_rd8(DBG_CPU_STAT), I2C_CMD_WR);
  i2c_tx_cmd(i2cread(coreid), I2C_CMD_START | I2C_CMD_WR);
  i2c_rx_cmd(I2C_CMD_RD | I2C_CMD_ACK | I2C_CMD_STOP, status);
  end
endtask

task debug_write_memory;
  input reg [6:0]  coreid;
  input reg [15:0] memaddress;
  input reg [15:0] memdata;
  begin

  //$display($time, " mem[%h] = %h", memaddress, memdata);

  // MEM_CNT = 0 (single memory write)
  i2c_tx_cmd(coreid << 1, I2C_CMD_START | I2C_CMD_WR);
  i2c_tx_cmd(cmdframe_wr16(DBG_MEM_CNT), I2C_CMD_WR);
  i2c_tx_cmd(0, I2C_CMD_WR);
  i2c_tx_cmd(0, I2C_CMD_WR | I2C_CMD_STOP);

  // MEM_ADDR = memaddress
  i2c_tx_cmd(coreid << 1, I2C_CMD_START | I2C_CMD_WR);
  i2c_tx_cmd(cmdframe_wr16(DBG_MEM_ADDR), I2C_CMD_WR);
  i2c_tx_cmd(memaddress[7:0], I2C_CMD_WR);
  i2c_tx_cmd(memaddress[15:8], I2C_CMD_STOP | I2C_CMD_WR);
 
  // MEM_DATA = memdata
  i2c_tx_cmd(coreid << 1, I2C_CMD_START | I2C_CMD_WR);
  i2c_tx_cmd(cmdframe_wr16(DBG_MEM_DATA), I2C_CMD_WR);
  i2c_tx_cmd(memdata[7:0], I2C_CMD_WR);
  i2c_tx_cmd(memdata[15:8], I2C_CMD_STOP | I2C_CMD_WR);

  // MEM_CTL = MEM_CTL_START | MEM_CTL_RDWR
  i2c_tx_cmd(coreid << 1, I2C_CMD_START | I2C_CMD_WR);
  i2c_tx_cmd(cmdframe_wr8(DBG_MEM_CTL), I2C_CMD_WR);
  i2c_tx_cmd(MEM_CTL_START | MEM_CTL_RDWR, I2C_CMD_STOP | I2C_CMD_WR);
  end
endtask

task debug_read_memory;
  input reg [6:0]  coreid;
  input reg [15:0] memaddress;
  output reg [15:0] memdata;
  
  begin

  //$timeformat(-9, 2, "ns", 20);

  // MEM_CNT = 0 (single memory read)
  i2c_tx_cmd(coreid << 1, I2C_CMD_START | I2C_CMD_WR);
  i2c_tx_cmd(cmdframe_wr16(DBG_MEM_CNT), I2C_CMD_WR);
  i2c_tx_cmd(0, I2C_CMD_WR);
  i2c_tx_cmd(0, I2C_CMD_WR | I2C_CMD_STOP);

  // MEM_ADDR = memaddress
  i2c_tx_cmd(coreid << 1, I2C_CMD_START | I2C_CMD_WR);
  i2c_tx_cmd(cmdframe_wr16(DBG_MEM_ADDR), I2C_CMD_WR);
  i2c_tx_cmd(memaddress[7:0], I2C_CMD_WR);
  i2c_tx_cmd(memaddress[15:8], I2C_CMD_STOP | I2C_CMD_WR);

  // MEM_CTL = MEM_CTL_START 
  i2c_tx_cmd(coreid << 1, I2C_CMD_START | I2C_CMD_WR);
  i2c_tx_cmd(cmdframe_wr8(DBG_MEM_CTL), I2C_CMD_WR);
  i2c_tx_cmd(MEM_CTL_START, I2C_CMD_STOP | I2C_CMD_WR);

  // memdata = MEM_DATA
  i2c_tx_cmd(i2cwrite(coreid), I2C_CMD_START | I2C_CMD_WR);
  i2c_tx_cmd(cmdframe_rd16(DBG_MEM_DATA), I2C_CMD_WR);
  i2c_tx_cmd(i2cread(coreid), I2C_CMD_START | I2C_CMD_WR);
  i2c_rx_cmd(I2C_CMD_RD , memdata[7:0]);
  i2c_rx_cmd(I2C_CMD_RD | I2C_CMD_ACK | I2C_CMD_STOP, memdata[15:8]);

  //$display($time, "ns read mem[%h] = %h", memaddress, memdata);
  end
endtask

task debug_read_reg;
  input reg [6:0]  coreid;
  input reg [15:0] memaddress;
  output reg [15:0] memdata;

  begin

  //$timeformat(-9, 2, "ns", 20);

  // MEM_CNT = 0 (single memory read)
  i2c_tx_cmd(coreid << 1, I2C_CMD_START | I2C_CMD_WR);
  i2c_tx_cmd(cmdframe_wr16(DBG_MEM_CNT), I2C_CMD_WR);
  i2c_tx_cmd(0, I2C_CMD_WR);
  i2c_tx_cmd(0, I2C_CMD_WR | I2C_CMD_STOP);

  // MEM_ADDR = memaddress
  i2c_tx_cmd(coreid << 1, I2C_CMD_START | I2C_CMD_WR);
  i2c_tx_cmd(cmdframe_wr16(DBG_MEM_ADDR), I2C_CMD_WR);
  i2c_tx_cmd(memaddress[7:0], I2C_CMD_WR);
  i2c_tx_cmd(memaddress[15:8], I2C_CMD_STOP | I2C_CMD_WR);

  // MEM_CTL = MEM_CTL_START
  i2c_tx_cmd(coreid << 1, I2C_CMD_START | I2C_CMD_WR);
  i2c_tx_cmd(cmdframe_wr8(DBG_MEM_CTL), I2C_CMD_WR);
  i2c_tx_cmd(MEM_CTL_START | MEM_CTL_MEMREG, I2C_CMD_STOP | I2C_CMD_WR);

  // memdata = MEM_DATA
  i2c_tx_cmd(i2cwrite(coreid), I2C_CMD_START | I2C_CMD_WR);
  i2c_tx_cmd(cmdframe_rd16(DBG_MEM_DATA), I2C_CMD_WR);
  i2c_tx_cmd(i2cread(coreid), I2C_CMD_START | I2C_CMD_WR);
  i2c_rx_cmd(I2C_CMD_RD , memdata[7:0]);
  i2c_rx_cmd(I2C_CMD_RD | I2C_CMD_ACK | I2C_CMD_STOP, memdata[15:8]);

  end
endtask

endmodule

`default_nettype wire

