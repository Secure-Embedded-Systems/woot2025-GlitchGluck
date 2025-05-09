`timescale 1 ns / 1 ps

module testbench;

   parameter HALFCLOCKPERIOD = 6.25;
   parameter TRIGGERBIT = 2;
   parameter DUMPVCD = 0;
   
   reg clk;
   reg clock_glitch;
   wire glitched_clk = clk ^ clock_glitch;

   initial begin
	  clock_glitch = 0;
	  clk = 0;
   end
   
   always #HALFCLOCKPERIOD clk = ~clk;
   
   reg resetn;
   initial begin
	  resetn = 1'b0;
	  repeat (10) @(negedge clk);
	  
	  $readmemh("ram_bank00.mem", testbench.chip.picosocInst_genblk1_ocram_controller_RAM_blk00.uut.mem_core_array);
	  $readmemh("ram_bank01.mem", testbench.chip.picosocInst_genblk1_ocram_controller_RAM_blk01.uut.mem_core_array);
	  $readmemh("ram_bank02.mem", testbench.chip.picosocInst_genblk1_ocram_controller_RAM_blk02.uut.mem_core_array);
	  $readmemh("ram_bank03.mem", testbench.chip.picosocInst_genblk1_ocram_controller_RAM_blk03.uut.mem_core_array);	  
	  resetn = 1'b1;
   end
   
   localparam ser_half_period = 53;
   event ser_sample;
   
   wire [15:0] gpio;
   
   initial begin
	  repeat (100) begin
		 repeat (50000) @(posedge clk);
	  end
	  wait(gpio==16'hff);
	  $finish;
   end
   
   integer cycle_cnt = 0;
   
   always @(posedge clk) begin
	  cycle_cnt <= cycle_cnt + 1;
   end
   
   wire ser_rx;
   wire ser_tx;
   
   wire flash_csb;
   wire flash_clk;
   wire flash_io0;
   wire flash_io1;
   wire flash_io2;
   wire flash_io3;
   
   wire o_SPI_Clk0; 
   wire o_SPI_Clk1; 
   wire o_SPI_Clk2; 
   wire o_SPI_Clk3; 
   wire i_SPI_MISO_0;
   wire i_SPI_MISO_1;
   wire i_SPI_MISO_2;
   wire i_SPI_MISO_3;
   wire o_SPI_MOSI0; 
   wire o_SPI_MOSI1; 
   wire o_SPI_MOSI2; 
   wire o_SPI_MOSI3; 
   wire o_SPI_CS_n_0;
   wire o_SPI_CS_n_1;
   wire o_SPI_CS_n_2;
   wire o_SPI_CS_n_3; 
   
   // RO Countermeasure Interface
   wire ro_countermeasure_mux_spi_clk;
   wire ro_countermeasure_mux_spi_miso;
   wire ro_countermeasure_mux_spi_mosi;
   wire ro_countermeasure_mux_spi_csn;
   wire ro_countermeasure_tri_spi_clk;
   wire ro_countermeasure_tri_spi_miso;
   wire ro_countermeasure_tri_spi_mosi;
   wire ro_countermeasure_tri_spi_csn;
   wire ro_countermeasure_out_single_mux;
   wire ro_countermeasure_out_single_tri;
   
   // RO TRNG External Ports
   wire ro_trng_trng;
   wire ro_trng_ro_stream; // new
   
   picochip  
	 chip (
		   .clk (glitched_clk),
		   .resetn (resetn),
		   
		   .ser_tx (ser_tx),
		   .ser_rx (ser_rx),
		   
		   .flash_csb (flash_csb),
		   .flash_clk (flash_clk),
		   .flash_io0 (flash_io0),
		   .flash_io1 (flash_io1),
		   .flash_io2 (flash_io2),
		   .flash_io3 (flash_io3),
		   
		   .gpio (gpio),
		   
		   .o_SPI_Clk0 (o_SPI_Clk0),
		   .o_SPI_Clk1 (o_SPI_Clk1),
		   .o_SPI_Clk2 (o_SPI_Clk2),
		   .o_SPI_Clk3 (o_SPI_Clk3),
		   .i_SPI_MISO_0 (i_SPI_MISO_0),
		   .i_SPI_MISO_1 (i_SPI_MISO_1),
		   .i_SPI_MISO_2 (i_SPI_MISO_2),
		   .i_SPI_MISO_3 (i_SPI_MISO_3),
		   .o_SPI_MOSI0 (o_SPI_MOSI0),
		   .o_SPI_MOSI1 (o_SPI_MOSI1),
		   .o_SPI_MOSI2 (o_SPI_MOSI2),
		   .o_SPI_MOSI3 (o_SPI_MOSI3),
		   .o_SPI_CS_n_0 (o_SPI_CS_n_0),
		   .o_SPI_CS_n_1 (o_SPI_CS_n_1),
		   .o_SPI_CS_n_2 (o_SPI_CS_n_2),
		   .o_SPI_CS_n_3 (o_SPI_CS_n_3), 
		   
		   // RO Countermeasure Interface
           .ro_countermeasure_mux_spi_clk (ro_countermeasure_mux_spi_clk),
           .ro_countermeasure_mux_spi_miso (ro_countermeasure_mux_spi_miso),
           .ro_countermeasure_mux_spi_mosi (ro_countermeasure_mux_spi_mosi),
           .ro_countermeasure_mux_spi_csn (ro_countermeasure_mux_spi_csn),    
           .ro_countermeasure_tri_spi_clk (ro_countermeasure_tri_spi_clk),
           .ro_countermeasure_tri_spi_miso (ro_countermeasure_tri_spi_miso),
           .ro_countermeasure_tri_spi_mosi (ro_countermeasure_tri_spi_mosi),
           .ro_countermeasure_tri_spi_csn (ro_countermeasure_tri_spi_csn),    
           .ro_countermeasure_out_single_mux (ro_countermeasure_out_single_mux),    
           .ro_countermeasure_out_single_tri (ro_countermeasure_out_single_tri),    
		   
           // RO TRNG External Ports
           .ro_trng_trng (ro_trng_trng),
           .ro_trng_ro_stream (ro_trng_ro_stream) // new
		   );
   
   spiflash spiflash (
					  .csb(flash_csb),
					  .clk(flash_clk),
					  .io0(flash_io0),
					  .io1(flash_io1),
					  .io2(flash_io2),
					  .io3(flash_io3)
					  );
   
   reg [7:0] buffer;
   
   always begin
	  @(negedge ser_tx);
	  
	  repeat (ser_half_period) @(posedge clk);
	  -> ser_sample; // start bit
	  
	  repeat (8) begin
		 repeat (ser_half_period) @(posedge clk);
		 repeat (ser_half_period) @(posedge clk);
		 buffer = {ser_tx, buffer[7:1]};
		 -> ser_sample; // data bit
	  end
	  
	  repeat (ser_half_period) @(posedge clk);
	  repeat (ser_half_period) @(posedge clk);
	  -> ser_sample; // stop bit
	  
	  if (buffer < 32 || buffer >= 127)
		$display("Serial data: %d", buffer);
	  else
		$display("Serial data: '%c'", buffer);
   end

   integer value_file_Q;
   
   initial begin
        value_file_Q = $fopen("valuedata_Q.json","w");
        $fwrite(value_file_Q,"{\n");
        $fwrite(value_file_Q,"\"id\" : {\n");

        `include "../../shared/pico/valuetree/valuetree_Q_id.v"

        $fwrite(value_file_Q,"},\n");

        $fwrite(value_file_Q,"\"digest\" : [\n");

   end

   integer f;
   integer cycles;
   integer fcycles,cycle_start_end_time;
   reg ready_to_glitch;  
 
   initial begin
		ready_to_glitch = 1'b0;
		$display("DUT runs on triggerbit %d", TRIGGERBIT);
		f = $fopen("dut_start_end_time.txt","w");
		$display("DUT: start %t",$time);
		wait(resetn==1'b1);
		$display("DUT: reset %t",$time);
		wait(gpio[TRIGGERBIT]==1'b1);
		ready_to_glitch = 1'b1;
		$display("DUT test start: %t",$time);
		$fwrite(f,"%t\n",$time);
		$dumpfile("./tb.vcd");

		if (DUMPVCD == 1)
			//$dumpvars(0, testbench.chip.picosocInst_cpu);
			$dumpvars(0, testbench);

		wait(gpio[TRIGGERBIT]==1'b0);
		ready_to_glitch = 1'b0;
		$display("DUT test end: %t",$time);
		$fwrite(f,"%t\n",$time);
		$dumpoff;
		
	        $fwrite(value_file_Q,"] }\n");
        	$fclose(value_file_Q);

		$finish;
   end

   always @(negedge testbench.chip.picosocInst_cpu.clk)
	 begin
		if (gpio[TRIGGERBIT]==1'b1)
		  begin

                if (cycles == 0) begin
                        $fwrite(value_file_Q,"{\n");
                end
                else begin
                        $fwrite(value_file_Q,",{\n");
                end

                $fwrite(value_file_Q,"   \"cycle\" : \"%0d\",\n", cycles);
                $fwrite(value_file_Q,"   \"value\"  : {\n");

                `include "../../shared/pico/valuetree/valuetree_Q.v"

                $fwrite(value_file_Q,"}}\n");

	 end
    end


   initial begin
	  fcycles = $fopen("pc_reg.txt","w");
          cycle_start_end_time = $fopen("cycle_start_end_time.txt","w");
          $fwrite(cycle_start_end_time,"Cycle,StartTime,EndTime\n");
	  cycles = 0;
	  wait(gpio[TRIGGERBIT]==1'b1);
 	  while (gpio[TRIGGERBIT]==1'b1)
		begin
		   @(negedge testbench.chip.picosocInst_cpu.clk);
		   $fwrite(fcycles,"%t %d %h\n", $time, cycles, testbench.chip.picosocInst_cpu.reg_pc);
                   $fwrite(cycle_start_end_time,"%0d %0.0f %0.0f\n", cycles, ($time-HALFCLOCKPERIOD)*1000, ($time+HALFCLOCKPERIOD)*1000);
		   cycles = cycles + 1;
		end
	  $fclose(fcycles);
   end


always@(posedge testbench.chip.picosocInst_cpu.clk) begin
        if (ready_to_glitch==1'b1) begin
	
		if (cycles == 613) begin
			#4
			$deposit(testbench.chip.picosocInst_cpu.reg_op1_reg_2_.D, ~testbench.chip.picosocInst_cpu.reg_op1_reg_2_.D);
			$deposit(testbench.chip.picosocInst_cpu.reg_op1_reg_1_.D, ~testbench.chip.picosocInst_cpu.reg_op1_reg_1_.D);
			$deposit(testbench.chip.picosocInst_cpu.reg_op1_reg_0_.D, ~testbench.chip.picosocInst_cpu.reg_op1_reg_0_.D);
			$deposit(testbench.chip.picosocInst_cpu.decoded_imm_reg_16_.D, ~testbench.chip.picosocInst_cpu.decoded_imm_reg_16_.D);
			$deposit(testbench.chip.picosocInst_cpu.decoded_imm_reg_30_.D, ~testbench.chip.picosocInst_cpu.decoded_imm_reg_30_.D);
			$deposit(testbench.chip.picosocInst_cpu.irq_mask_reg_11_.D, ~testbench.chip.picosocInst_cpu.irq_mask_reg_11_.D);


	end

                if (cycles == 1256) begin
                        #4
                        $deposit(testbench.chip.picosocInst_cpu.reg_op1_reg_2_.D, ~testbench.chip.picosocInst_cpu.reg_op1_reg_2_.D);
                        $deposit(testbench.chip.picosocInst_cpu.reg_op1_reg_1_.D, ~testbench.chip.picosocInst_cpu.reg_op1_reg_1_.D);
                        $deposit(testbench.chip.picosocInst_cpu.reg_op1_reg_0_.D, ~testbench.chip.picosocInst_cpu.reg_op1_reg_0_.D);
                        $deposit(testbench.chip.picosocInst_cpu.decoded_imm_reg_16_.D, ~testbench.chip.picosocInst_cpu.decoded_imm_reg_16_.D);
                        $deposit(testbench.chip.picosocInst_cpu.decoded_imm_reg_30_.D, ~testbench.chip.picosocInst_cpu.decoded_imm_reg_30_.D);
                        $deposit(testbench.chip.picosocInst_cpu.irq_mask_reg_11_.D, ~testbench.chip.picosocInst_cpu.irq_mask_reg_11_.D);


        end
        end
end



 
endmodule
