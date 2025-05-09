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

`timescale 1ns / 1ns
`default_nettype none 

`include "../../hdl/tb/cw305interface/cw305_defines.v"


module tb();

	parameter pADDR_WIDTH = 21;
	parameter pBYTECNT_SIZE = 7;
	parameter pUSB_CLOCK_PERIOD = 10;
	parameter pPLL_CLOCK_PERIOD = 20;
	parameter pNCORES = 1;

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
	
	integer prescale;
	
	wire clk = pll_clk1;
	
	reg [7:0] byteback;
	reg [15:0] wordback;

	reg read_select;

	assign usb_data = read_select? 8'bz : usb_wdata;
	assign tio_clkin = pll_clk1;

	always @(*) begin
		if (usb_wrn == 1'b0)
			read_select = 1'b0;
		else if (usb_rdn == 1'b0)
			read_select = 1'b1;
	end

	`include "../../hdl/tb/tb_cw305_reg_tasks.v"
	always #(pUSB_CLOCK_PERIOD/2) usb_clk = !usb_clk;
	always #(pPLL_CLOCK_PERIOD/2) pll_clk1 = !pll_clk1;

	wire #1 usb_rdn_out = usb_rdn;
	wire #1 usb_wrn_out = usb_wrn;
	wire #1 usb_cen_out = usb_cen;
	wire #1 usb_trigger_out = usb_trigger;

	tb_single_core_msp430 #(
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
	        .pll_clk1                 (pll_clk1),
	        .tio_trigger              (tio_trigger),
	        .tio_clkout               (),          
	        .tio_clkin                (tio_clkin),
	        .io6                      (i2c_scl),
	        .io8                      (i2c_sda)
	);

        integer cycle_counter;
        integer pc_doc,cycle_start_end_time;
        reg ready_to_dump;
        integer i;

        integer value_file_Q;
        integer scan_file;

	`include "document_scan/valuetree_decl.v"

    // Main Testbench
    initial begin
        $timeformat(-9, 2, "ns", 20);
        usb_clk = 1'b1;
        usb_clk_enable = 1'b1;
        pll_clk1 = 1'b1;

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


        ready_to_dump = 1'b0;

        pc_doc = $fopen("pc.txt","w");
        $fwrite(pc_doc,"Time,ClockCycle,PC\n");

        cycle_start_end_time = $fopen("cycle_start_end_time.txt","w");
        $fwrite(cycle_start_end_time,"Cycle,StartTime,EndTime\n");

        cycle_counter = 0;

        value_file_Q = $fopen("valuedata_Q.json","w");
        $fwrite(value_file_Q,"{\n");
        $fwrite(value_file_Q,"\"id\" : {\n");

        `include "document_scan/valuetree_Q_id.v"

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

       // enable I2C core
        write_bytes(0, 1, `REG_I2C_CONTROL, 8'h80);

        halt_cpu(I2C_ADDRESS_CORE_0);      

        read_cpu_status(I2C_ADDRESS_CORE_0, byteback);
        $display("status CPU %d = %d", I2C_ADDRESS_CORE_0, byteback);

        reset_cpu(I2C_ADDRESS_CORE_0);

        $display("start loading app.ver at time:%t",$time);
	// load hex file
        loadhexfile(I2C_ADDRESS_CORE_0, {"../../software/app.ver"});
        $display("end loading app.ver at time:%t",$time);

        $display("run cpu time:%t",$time);
        reset_cpu(I2C_ADDRESS_BCAST);      

	// dump vcd
        $dumpfile("tb.vcd");
        $dumpvars(0, tb.U_dut.genblk1[0].U_msp430);

	// ready to document scan data
	ready_to_dump = 1'b1;

	// run cpu
        run_cpu(I2C_ADDRESS_BCAST);      

	// run time
        #(pPLL_CLOCK_PERIOD*600);

	// dump scan data off
	ready_to_dump = 1'b0;

	$dumpoff;

	// close scan data file
        $fwrite(value_file_Q,"] }\n");
        $fclose(value_file_Q);

	// close scan data file 
        $fwrite(scan_file,"] }\n");
        $fclose(scan_file);

        $display("end cpu run time:%t",$time);

        $finish;
      
    end

// document
always@(negedge tb.clk) begin
        if (ready_to_dump==1'b1) begin

                if (cycle_counter == 0) begin
                        $fwrite(value_file_Q,"{\n");
                end
                else begin
                        $fwrite(value_file_Q,",{\n");
                end

                $fwrite(value_file_Q,"   \"cycle\" : \"%0d\",\n", cycle_counter);
                $fwrite(value_file_Q,"   \"value\"  : {\n");

		// document word-level register in hex
                `include "document_scan/valuetree_Q.v"

                $fwrite(value_file_Q,"}}\n");

		// document pc log
                $fwrite(pc_doc,"%0.0f %0d %4x\n", $time*1000, cycle_counter, tb.U_dut.genblk1[0].U_msp430.openmsp430_0.frontend_0.pc[15:0]);

                $fwrite(cycle_start_end_time,"%0d %0.0f %0.0f\n", cycle_counter, (($time - (pPLL_CLOCK_PERIOD / 2) + 1.060) * 1000), (($time + (pPLL_CLOCK_PERIOD / 2) + 1.060) * 1000));

                $fwrite(scan_file,",{\n");

                $fwrite(scan_file,"   \"cycle\" : \"%0d\",\n", cycle_counter);
                $fwrite(scan_file,"   \"core\"  : {\n");

		// document scan state in binary
                `include "document_scan/fwritescan.v"

                $fwrite(scan_file,"}}\n");


                cycle_counter = cycle_counter + 1;
        end
end


// ----------------------------------------------------------------
// TASKS AND FUNCTIONS 

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

  $timeformat(-9, 2, "ns", 20);

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


endmodule

`default_nettype wire

