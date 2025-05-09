//----------------------------------------------------------------------------
//
// *File Name: tb_single_core_without_pads_top.v
// 
// *Module Description:
//                       ASIC TOP SINGLE CORE WITHOUT PADS
//
// *Author(s):
//              - Zhenyuan Charlotte Liu,    zliu12@wpi.edu
//
//----------------------------------------------------------------------------

`timescale 1ns / 1ps
`default_nettype none 

`include "cw305interface/cw305_defines.v"


module tb_single_core_msp430 #(
    parameter pBYTECNT_SIZE = 7,
    parameter pADDR_WIDTH = 21,
    parameter pPT_WIDTH = 128,
    parameter pCT_WIDTH = 128,
    parameter pKEY_WIDTH = 128,
    parameter pNCORES = 1
)(
    // USB Interface
    input wire                          usb_clk,        // Clock
    inout wire [7:0]                    usb_data,       // Data for write/read
    input wire [pADDR_WIDTH-1:0]        usb_addr,       // Address
    input wire                          usb_rdn,        // !RD, low when addr valid for read
    input wire                          usb_wrn,        // !WR, low when data+addr valid for write
    input wire                          usb_cen,        // !CE, active low chip enable
    input wire                          usb_trigger,    // High when trigger requested

    // Buttons/LEDs on Board
    input wire                          j16_sel,        // DIP switch J16
    input wire                          k16_sel,        // DIP switch K16
    input wire                          k15_sel,        // DIP switch K15
    input wire                          l14_sel,        // DIP Switch L14
    input wire                          pushbutton,     // Pushbutton SW4, connected to R1, used here as reset

    // PLL
    input wire                          pll_clk1,       //PLL Clock Channel #1
    //input wire                        pll_clk2,       //PLL Clock Channel #2 (unused in this example)

    // 20-Pin Connector Stuff
    output wire                         tio_trigger,
    output wire                         tio_clkout,
    input  wire                         tio_clkin,

    // edge connector
    output wire io6,  // i2c_scl
    output wire io8   // i2c_sda
   
    );

    wire usb_clk_buf;
    wire [7:0] usb_dout;
    wire isout;
    wire [pADDR_WIDTH-pBYTECNT_SIZE-1:0] reg_address;
    wire [pBYTECNT_SIZE-1:0] reg_bytecnt;
    wire reg_addrvalid;
    wire [7:0] write_data;
    wire [7:0] read_data;
    wire reg_read;
    wire reg_write;
    wire [4:0] clk_settings;
    wire crypt_clk;    

    wire resetn = pushbutton;
    wire reset = !resetn;

    // USB CLK Heartbeat
    reg [26:0] usb_timer_heartbeat;
    always @(posedge usb_clk_buf) usb_timer_heartbeat <= usb_timer_heartbeat +  27'd1;

    // CRYPT CLK Heartbeat
    reg [22:0] crypt_clk_heartbeat;
    always @(posedge crypt_clk) crypt_clk_heartbeat <= crypt_clk_heartbeat +  23'd1;

//    assign led1 = crypt_clk_heartbeat[22];

    // Register Programming Interface
    cw305_usb_reg_fe #(
       .pBYTECNT_SIZE           (pBYTECNT_SIZE),
       .pADDR_WIDTH             (pADDR_WIDTH)
    ) U_usb_reg_fe (
       .rst                     (reset),                // input 
       .usb_clk                 (usb_clk_buf),          // input
       .usb_din                 (usb_data),             // input
       .usb_dout                (usb_dout),             // output
       .usb_rdn                 (usb_rdn),              // input
       .usb_wrn                 (usb_wrn),              // input
       .usb_cen                 (usb_cen),              // input
       .usb_alen                (1'b0),                 // unused input
       .usb_addr                (usb_addr),             // input
       .usb_isout               (isout),                // output 
       .reg_address             (reg_address),          // output
       .reg_bytecnt             (reg_bytecnt),          // output
       .reg_datao               (write_data),           // output
       .reg_datai               (read_data),            // input
       .reg_read                (reg_read),             // output
       .reg_write               (reg_write),            // output
       .reg_addrvalid           (reg_addrvalid)         // output
    );

    assign usb_data = isout? usb_dout : 8'bZ;

    clocks U_clocks (
       .usb_clk                 (usb_clk),              // input
       .usb_clk_buf             (usb_clk_buf),          // output
       .I_j16_sel               (j16_sel),              // input
       .I_k16_sel               (k16_sel),              // input
       .I_clock_reg             (clk_settings),         // input
       .I_cw_clkin              (tio_clkin),            // input
       .I_pll_clk1              (pll_clk1),             // input
       .O_cw_clkout             (tio_clkout),           // output
       .O_cryptoclk             (crypt_clk)             // output
    );

    //-------------------------------------------------------------
    // I2C Master Interface

    wire logic_hi;
    assign logic_hi = 1'b1;
    
    reg   [2:0] i2c_addr;
    wire  [7:0] i2c_data_write;
    wire  [7:0] i2c_data_read;
    wire  i2c_we;
    wire  i2c_stb;
    wire  i2c_cyc;
    wire  i2c_ack;

    wire scl_pad_i;
    wire scl_pad_o;
    wire scl_padoen_o;

    wire sda_pad_i;
    wire sda_pad_o;
    wire sda_padoen_o;
            
    i2c_master_top U_i2c_master_top(
	  .wb_clk_i(usb_clk_buf), 
      .wb_rst_i(reset), 
	  .arst_i(logic_hi), 
	  .wb_adr_i(i2c_addr), 
      .wb_dat_i(i2c_data_write), 
	  .wb_dat_o(i2c_data_read),
	  .wb_we_i(i2c_we), 
      .wb_stb_i(i2c_stb), 
	  .wb_cyc_i(i2c_cyc), 
	  .wb_ack_o(i2c_ack), 
	  .wb_inta_o(),	   
	  .scl_pad_i(scl_pad_i), 
	  .scl_pad_o(scl_pad_o), 
	  .scl_padoen_o(scl_padoen_o), 
	  .sda_pad_i(sda_pad_i), 
	  .sda_pad_o(sda_pad_o), 
	  .sda_padoen_o(sda_padoen_o));
	  
    // this decodes the wishbone I2C device addresses
    //
    //   address             write               read
    //
    //      0         REG_I2C_PRESCALE_LO  REG_I2C_PRESCALE_LO
    //      1         REG_I2C_PRESCALE_HI  REG_I2C_PRESCALE_HI
    //      2         REG_I2C_CONTROL      REG_I2C_CONTROL
    //      3         REG_I2C_TX           REG_I2C_RX
    //      4         REG_I2C_COMMAND      REG_I2C_STATUS

    wire i2c_valid_read_address;
    wire i2c_valid_write_address;
    
    assign i2c_valid_read_address =  (reg_address == `REG_I2C_PRESCALE_LO) ||
                                     (reg_address == `REG_I2C_PRESCALE_HI) ||
                                     (reg_address == `REG_I2C_CONTROL) ||
                                     (reg_address == `REG_I2C_RX) ||
                                     (reg_address == `REG_I2C_STATUS);
    assign i2c_valid_write_address = (reg_address == `REG_I2C_PRESCALE_LO) ||
                                     (reg_address == `REG_I2C_PRESCALE_HI) ||
                                     (reg_address == `REG_I2C_CONTROL) ||
                                     (reg_address == `REG_I2C_TX) ||
                                     (reg_address == `REG_I2C_COMMAND);

    // The read cycle from  cw305_usb_reg_fe is a three-cycle pulse on 
    //   reg_read. This signal is transformed into a wishbone simple
    //   read access with the following timing
    //
    //   Cycle         0             1            2
    //
    //   ADDR_O       Valid          X            X
    //   DAT_I          X          Valid          X
    //   WE_O           0            0            0
    //   STB_O          1            0            0
    //   CYC_O          1            1            0
    //   ACK_I          0            1            0

    wire i2c_read_cycle;        
    assign i2c_read_cycle = (reg_addrvalid && reg_read && i2c_valid_read_address);

    reg i2c_prev_read_cycle;
    always @(posedge usb_clk_buf)
      i2c_prev_read_cycle <= i2c_read_cycle;

    // The write cycle from  cw305_usb_reg_fe is a single-cycle pulse on 
    //   reg_write. This signal is transformed into a wishbone simple
    //   read access with the following timing
    //
    //   Cycle         0             1            2
    //
    //   ADDR_O       Valid        Valid          X
    //   DAT_O        Valid        Valid          X
    //   WE_O           1            1            0
    //   STB_O          1            1            0
    //   CYC_O          1            1            0
    //   ACK_I          0            1            0

    wire i2c_write_cycle;
    assign i2c_write_cycle = (reg_addrvalid && reg_write && i2c_valid_write_address);    

    reg i2c_prev_write_cycle;
    always @(posedge usb_clk_buf)
      i2c_prev_write_cycle <= i2c_write_cycle;

    assign i2c_stb = i2c_read_cycle  ? i2c_read_cycle & (i2c_read_cycle ^ i2c_prev_read_cycle) :
                     i2c_write_cycle ? (i2c_write_cycle | i2c_prev_write_cycle) :
                     1'b0;

    assign i2c_data_write = write_data;
    assign i2c_we         = (i2c_write_cycle | i2c_prev_write_cycle);    
    assign i2c_cyc        = i2c_read_cycle  ? (i2c_read_cycle | i2c_prev_read_cycle) :
                            i2c_write_cycle ? (i2c_write_cycle | i2c_prev_write_cycle) :
                            1'b0;

    always @(*) begin
     i2c_addr = 3'd0;
     case(reg_address)
         `REG_I2C_PRESCALE_LO:  i2c_addr = 3'd0;
         `REG_I2C_PRESCALE_HI:  i2c_addr = 3'd1;
         `REG_I2C_CONTROL:      i2c_addr = 3'd2;
         `REG_I2C_TX:           i2c_addr = 3'd3;
         `REG_I2C_RX:           i2c_addr = 3'd3;
         `REG_I2C_COMMAND:      i2c_addr = 3'd4;
         `REG_I2C_STATUS:       i2c_addr = 3'd4;
          default:              i2c_addr = 3'd0;
     endcase
    end

   //-------------------------------------------------------------
   // Application Reset

   wire crypt_reset;

   reg [4:0] crypt_reset_fifo;
   always @(posedge usb_clk_buf) begin
      if (reset)
         crypt_reset_fifo <= 1'b0;
      else
         if (reg_addrvalid && reg_write) begin
            case (reg_address)
               `REG_CRYPT_RESET:   crypt_reset_fifo <= 5'b1;
            endcase 
         end else begin
            crypt_reset_fifo <= {crypt_reset_fifo[3:0], 1'b0};
         end
   end

   assign crypt_reset =| crypt_reset_fifo;

   //-------------------------------------------------------------
   // I2C Interconnect

   wire [pNCORES-1:0] i2c_sda_in_core;
   wire [pNCORES-1:0] i2c_sda_out_core;
   wire [pNCORES-1:0] i2c_scl_core;

   // clock interconnect
   wire i2c_scl;
   assign i2c_scl    = ~scl_padoen_o ?  scl_pad_o : 1'b1;
   assign scl_pad_i  = i2c_scl;

   // data interconnect
   wire i2c_sda;
   assign i2c_sda = ~sda_padoen_o        ? sda_pad_o : 
                    |(~i2c_sda_out_core) ? 1'b0      :
                    1'b1;

   assign sda_pad_i = i2c_sda;


   //-------------------------------------------------------------
   // CORE GENERATION WITH GPIO LOOP WITH ARBITOR
   
   // TRIGGER
   wire [pNCORES-1:0] tio_trigger_core;

   // UART
   wire [pNCORES-1:0] user_uart_rx_core;
   wire [pNCORES-1:0] user_uart_tx_core;

   // ARBITOR WIRES
   wire [7:0] data_out_1_core[8*pNCORES-1:0];  // gpio
   wire [7:0] data_in_1_core[8*pNCORES-1:0];   // gpio
   wire [7:0] data_out_1_enable_core[8*pNCORES-1:0];
   wire [pNCORES-1:0] fault_detect_core;       // gpio
   wire [pNCORES-1:0] fault_detect_bar_core;   // gpio
   wire [pNCORES-1:0] enable_stop_core;        // gpio
   wire [pNCORES-1:0] enable_stop_bar_core;    // gpio
   wire system_fault;
   wire system_fault_bar;
   wire [pNCORES-1:0] nmi_core;
   wire [pNCORES-1:0] nmi_bar_core;
   wire [pNCORES-1:0] msp430_nmi_execute_core;

   // GPIO LOOP
   wire [8:0] data_out_2_core[8*pNCORES-1:0];
   wire [8:0] data_in_2_core[8*pNCORES-1:0];
   wire [8:0] data_out_3_core[8*pNCORES-1:0];
   wire [8:0] data_in_3_core[8*pNCORES-1:0];

   genvar coreid;

   generate
   for (coreid = 0; coreid < pNCORES; coreid = coreid + 1)
      begin

         single_core_msp430 U_msp430(
			 .clk(crypt_clk),
                         .reset(crypt_reset),
			 .inst_nr(8'd0),
			 .i2c_debug_addr(7'h51),
                         .msp430_nmi_execute(msp430_nmi_execute_core[coreid]),
                         .i2c_scl(i2c_scl_core[coreid]),
                         .i2c_sda_in(i2c_sda_in_core[coreid]),
                         .i2c_sda_out(i2c_sda_out_core[coreid]),
			 .data_out_1_enable(data_out_1_enable_core[coreid]),
                         .data_out_1(data_out_1_core[coreid]),
                         .data_out_2(data_out_2_core[coreid]),
                         .data_out_3(data_out_3_core[coreid]),
                         .data_in_1(data_in_1_core[coreid]),
                         .data_in_2(data_in_2_core[coreid]),
                         .data_in_3(data_in_3_core[coreid]),
			 .user_uart_rx(user_uart_rx_core[coreid]),
			 .user_uart_tx(user_uart_tx_core[coreid])
			 );


      // I2C
      assign i2c_scl_core[coreid]     = i2c_scl;
      assign i2c_sda_in_core[coreid]  = i2c_sda;
  
      // TRIGGER
      assign tio_trigger_core[coreid] = data_out_1_core[coreid][7];

      // FAULT DETECT AND ENABLE STOP
      assign fault_detect_core[coreid]     = data_out_1_core[coreid][0];
      assign fault_detect_bar_core[coreid] = data_out_1_core[coreid][1];
      assign enable_stop_core[coreid]      = data_out_1_core[coreid][2];
      assign enable_stop_bar_core[coreid]  = data_out_1_core[coreid][3];

      assign nmi_core[coreid]     = system_fault     & enable_stop_core[coreid];
      assign nmi_bar_core[coreid] = system_fault_bar | enable_stop_bar_core[coreid];

      assign msp430_nmi_execute_core[coreid] = nmi_core[coreid] & (nmi_core[coreid] ^ nmi_bar_core[coreid]); 
/*
      // GPIO LOOP
      if (coreid == pNCORES - 1) begin
            assign data_out_2_core[coreid] = data_in_3_core[pNCORES - 1 - coreid];
            assign data_in_2_core[coreid]  = data_out_3_core[pNCORES - 1 - coreid];
            assign data_out_3_core[coreid] = data_in_2_core[coreid-1];
            assign data_in_3_core[coreid]  = data_out_2_core[coreid-1];
      end

      else if (coreid == 0) begin
            assign data_out_2_core[coreid] = data_in_3_core[coreid + 1];
            assign data_in_2_core[coreid]  = data_out_3_core[coreid + 1];
            assign data_out_3_core[coreid] = data_in_2_core[pNCORES - 1];
            assign data_in_3_core[coreid]  = data_out_2_core[pNCORES - 1];
      end

      else begin
            assign data_out_2_core[coreid] = data_in_3_core[coreid + 1];
            assign data_in_2_core[coreid]  = data_out_3_core[coreid + 1];
            assign data_out_3_core[coreid] = data_in_2_core[coreid - 1];
            assign data_in_3_core[coreid]  = data_out_2_core[coreid - 1];
      end
*/
      end

   endgenerate

   // TRIGGER
   assign tio_trigger = (|tio_trigger_core);

   // I2C
   assign io6 = i2c_scl;
   assign io8 = i2c_sda;

   // ARBITOR 
   assign system_fault     = |fault_detect_core;
   assign system_fault_bar = &fault_detect_bar_core;

   /*
   //-------------------------------------------------------------
   // CORE GENERATION

   wire [pNCORES-1:0] led2_core;
   wire [pNCORES-1:0] led3_core;
   wire [pNCORES-1:0] tio_trigger_core;

   wire [7:0] data_out_core[8*pNCORES-1:0];
   wire [7:0] data_in_core[8*pNCORES-1:0];
   
   genvar coreid;

   generate
   for (coreid = 0; coreid < pNCORES; coreid = coreid + 1)
      begin

      msp430module #(.INST_NR(coreid), 
                     .TOTAL_NR(pNCORES - 1), 
                     .I2C_DEBUG_ADDR(7'h50 + coreid + 1),
                     .I2C_DEBUG_BROADCAST_ADDR(7'h50)) 
                U_mps430(.clk(crypt_clk),
                         .reset(crypt_reset),
                         .i2c_scl(i2c_scl_core[coreid]),
                         .i2c_sda_in(i2c_sda_in_core[coreid]),
                         .i2c_sda_out(i2c_sda_out_core[coreid]),
                         .data_out(data_out_core[coreid]),
                         .data_in(data_in_core[coreid]));
                         
      assign led2_core[coreid]        = |data_out_core[coreid][3:0];
      assign led3_core[coreid]        = |data_out_core[coreid][7:4];
      assign i2c_scl_core[coreid]     = i2c_scl;
      assign i2c_sda_in_core[coreid]  = i2c_sda;
      assign tio_trigger_core[coreid] = data_out_core[coreid][7];
      end

   endgenerate

   assign led2 = (^led2_core);
   assign led3 = (^led3_core);
   assign tio_trigger = (|tio_trigger_core);

   assign io6 = i2c_scl;
   assign io8 = i2c_sda;
*/

    
   //-------------------------------------------------------------
   // REGISTER READ INTERFACE (Merges all slaves)

   reg [7:0] reg_read_data;
   always @(*) begin
      reg_read_data = 0;
      if (reg_addrvalid && reg_read) begin
         case (reg_address)
//            `REG_USER_LED:            reg_read_data = {led3, led2, led1};
            `REG_I2C_PRESCALE_LO:     reg_read_data = i2c_data_read;
            `REG_I2C_PRESCALE_HI:     reg_read_data = i2c_data_read;
            `REG_I2C_CONTROL:         reg_read_data = i2c_data_read;
            `REG_I2C_RX:              reg_read_data = i2c_data_read;
            `REG_I2C_STATUS:          reg_read_data = i2c_data_read;
            default:                  reg_read_data = 0;
         endcase
      end
   end

   // read data must be delayed by one cycle after decoding
   reg [7:0] dly_read_data;
   always @(posedge usb_clk_buf) begin
      if (reset)
         dly_read_data <= 8'b0;
      else
         dly_read_data <= reg_read_data;
   end

   assign read_data = dly_read_data;

endmodule
