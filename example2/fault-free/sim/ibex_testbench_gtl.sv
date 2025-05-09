`timescale 1 ns / 1 ps

module testbench;

   parameter TRIGGERBIT = 0;
   parameter DUMPVCD = 1;
   parameter HALFCLOCKPERIOD = 5;

   reg clk;
   reg rst_n;
   
   parameter gp = 8;
   reg [gp-1:0] gpio_in;
   wire [gp-1:0] gpio_out;

   top_rtl chip(.clk(clk), 
	       .rst_n(rst_n), 
	       .gpio_in(gpio_in), 
	       .gpio_out(gpio_out));

   initial begin
      clk = 1'b0;
   end

   always #HALFCLOCKPERIOD clk = ~clk;

   integer f;

   initial begin
      $timeformat(-9, 3, " ns");
      $display("DUT runs on triggerbit %d", TRIGGERBIT);
      f = $fopen("dut_start_end_time.txt","w");
      $display("DUT: start %t",$time);
      wait(rst_n==1'b1);
      $display("DUT: reset %t",$time);
      wait(gpio_out[TRIGGERBIT]==1'b1);
      $display("DUT test start: %t",$time);
      $fwrite(f,"%t\n",$time);
      $dumpfile("./tb.vcd");

      if (DUMPVCD == 1)
            $dumpvars(0, testbench.chip.u_ibex_demo_system_u_top);

      wait(gpio_out[TRIGGERBIT]==1'b0);
      $display("DUT test end: %t",$time);
      $fwrite(f,"%t\n",$time);
      $dumpoff;

      $fwrite(value_file_Q,"] }\n");
      $fclose(value_file_Q);

      $finish;
   end
   
   initial begin
      rst_n = 1'b0;
      gpio_in = 'd0;
      repeat (10) @(negedge clk);
      $readmemh("ram_bank00.mem", testbench.chip.u_ibex_demo_system_u_ram_u_ram_gen_generic_u_impl_generic.mem);
      rst_n = 1'b1;
   end

   function [13:0] hamming;
      input [8192-1:0]  a;
      input integer   l;
      integer             r;
      integer         i;
      begin
         r = 0;
         for (i=0; i<l; i=i+1)
            begin
               r = r + ((a[i] !== 1'bx) ? a[i] : 1'b0);
            end
         hamming = r;
      end
   endfunction // a

   integer cycles;
   integer filepc,cycle_start_end_time;
   bit [31:0] pc_clean_if, pc_clean_id, pc_clean_wb;
   integer value_file_Q;

   initial begin
    
      filepc = $fopen("pc_reg.txt","w");
      cycle_start_end_time = $fopen("cycle_start_end_time.txt","w");
      $fwrite(cycle_start_end_time,"Cycle,StartTime,EndTime\n");

      cycles = 0;

      value_file_Q = $fopen("valuedata_Q.json","w");
      $fwrite(value_file_Q,"{\n");
      $fwrite(value_file_Q,"\"id\" : {\n");

      `include "../../shared/ibex/valuetree/valuetree_Q_id.v"

      $fwrite(value_file_Q,"},\n");

      $fwrite(value_file_Q,"\"digest\" : [\n");

      wait(gpio_out[TRIGGERBIT]==1'b1);
      while (gpio_out[TRIGGERBIT]==1'b1) begin
         @(negedge testbench.chip.u_ibex_demo_system_u_top.clk);
                if (cycles == 0) begin
                        $fwrite(value_file_Q,"{\n");
                end
                else begin
                        $fwrite(value_file_Q,",{\n");
                end

                $fwrite(value_file_Q,"   \"cycle\" : \"%0d\",\n", cycles);
                $fwrite(value_file_Q,"   \"value\"  : {\n");

                `include "../../shared/ibex/valuetree/valuetree_Q.v"

                $fwrite(value_file_Q,"}}\n");

         pc_clean_if = chip.u_ibex_demo_system_u_top.u_ibex_core_pc_if;
         pc_clean_id = chip.u_ibex_demo_system_u_top.u_ibex_core_pc_id;
         pc_clean_wb = chip.u_ibex_demo_system_u_top.u_ibex_core_pc_wb;
         $fwrite(filepc,"%t %d pc_if: %h, pc_id: %h, pc_wb: %h\n", $time, cycles, pc_clean_if, pc_clean_id, pc_clean_wb);
         $fwrite(cycle_start_end_time,"%0d %0.0f %0.0f\n", cycles, ($time-HALFCLOCKPERIOD)*1000, ($time+HALFCLOCKPERIOD)*1000);

         cycles = cycles + 1;
      end
      $fclose(filepc);
   end


endmodule

