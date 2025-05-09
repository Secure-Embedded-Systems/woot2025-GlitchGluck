//----------------------------------------------------------------------------
//
// *File Name: single_core_msp430.v 
// 
// *Module Description:
//                       ASIC ONE MSP430 MODULE
//
// *Author(s):
//              - Zhenyuan Charlotte Liu,    zliu12@wpi.edu
//
//----------------------------------------------------------------------------


`timescale 1ns / 1ps
`default_nettype none 

`include "./openMSP430_defines.v"

module single_core_msp430(

    // clk and reset
	input wire clk,
        input wire reset,

    // parameters as inputs
    	input wire [7:0] inst_nr,
	input wire [6:0] i2c_debug_addr,

    // msp430 nmi execute
        input wire msp430_nmi_execute,

    // debug interface
	input wire  i2c_scl,
	input wire  i2c_sda_in,
	output wire i2c_sda_out,

    // data I/O (for trigger, detect_fault, detect_fault_bar, enable_stop,
    // enable_stop_bar)
        output wire [7:0] data_out_1,
	input wire [7:0] data_in_1,
	output wire [7:0] data_out_1_enable,
  
    // data I/O (for GPIO loop)
        output wire [8:0] data_out_2,
	output wire [8:0] data_out_3,
	input wire [8:0] data_in_2,
        input wire [8:0] data_in_3,

    // UART
	input wire user_uart_rx,
	output wire user_uart_tx 
);

//  parameter            INST_NR  = 8'h00;       // Current oMSP instance number     (for multicore systems)
//  parameter            TOTAL_NR = 8'h00;       // Total number of oMSP instances-1 (for multicore systems)
//  parameter            I2C_DEBUG_ADDR = 7'h51;
//  parameter            I2C_DEBUG_BROADCAST_ADDR = 7'h50;


  // openMSP430 Program memory bus
  wire [`PMEM_MSB:0] pmem_addr;
  wire        [15:0] pmem_din;
  wire               pmem_cen;
  wire         [1:0] pmem_wen;
  wire        [15:0] pmem_dout;
  
  // openMSP430 Data memory bus
  wire [`DMEM_MSB:0] dmem_addr;
  wire        [15:0] dmem_din;
  wire               dmem_cen;
  wire         [1:0] dmem_wen;
  wire        [15:0] dmem_dout;
  
  // openMSP430 Peripheral memory bus
  wire        [13:0] per_addr;
  wire        [15:0] per_din;
  wire               per_en;
  wire         [1:0] per_we;
  wire        [15:0] per_dout;

  // openMSP430 IRQs
  wire               nmi;
  wire        [13:0] irq_bus;
  wire        [13:0] irq_acc;
  
  // openMSP430 debug interface
  wire               dbg_freeze;
  wire         [6:0] dbg_i2c_addr;
  wire         [6:0] dbg_i2c_broadcast;
  wire               dbg_i2c_scl;
  wire               dbg_i2c_sda_in;
  wire               dbg_i2c_sda_out;
  wire               dbg_uart_txd;
  wire               dbg_uart_rxd;
  
  // openMSP430 clocks and resets
  wire               dco_clk;
  wire               lfxt_clk;
  wire               aclk_en;
  wire               smclk_en;
  wire               mclk;
  wire               reset_n;
  wire               puc_rst;

  // Timer A
  wire               irq_ta0;
  wire               irq_ta1;
  wire        [15:0] per_dout_tA;
  wire               pwm_out;

  // GPIO
  wire         [15:0] p1_din;
  wire         [15:0] p1_dout;
  wire         [15:0] p1_dout_en;
  wire         [15:0] p1_sel;
  wire                irq_port1;

  wire         [15:0] p2_din;
  wire         [15:0] p2_dout;
  wire         [15:0] p2_dout_en;
  wire         [15:0] p2_sel;
  wire                irq_port2;

  wire         [15:0] p3_din;
  wire         [15:0] p3_dout;
  wire         [15:0] p3_dout_en;
  wire         [15:0] p3_sel;

  wire         [15:0] per_dout_dio;

  // RO
  wire         [15:0] per_dout_ro_0;
  wire         [15:0] per_dout_ro_1;
  wire         [15:0] per_dout_ro_2;


  // UART
  wire                irq_uart_rx;   // UART receive interrupt
  wire                irq_uart_tx;   // UART transmit interrupt
  wire         [15:0] per_dout_uart; // Peripheral data output

  //--------- Clock and Reset

  assign dco_clk    = clk;
  wire   reset_in_n = ~reset;
  
  // Release system reset a few clock cyles after the FPGA power-on-reset
  reg [7:0] reset_dly_chain;
  always @ (posedge dco_clk or negedge reset_in_n)
    if (!reset_in_n) reset_dly_chain <= 8'h00;
    else             reset_dly_chain <= {1'b1, reset_dly_chain[7:1]};
  
  assign reset_n = reset_dly_chain[0];
  
  // Generate a slow reference clock LFXT_CLK
  reg [8:0] lfxt_clk_cnt;
  always @ (posedge dco_clk or negedge reset_n)
    if (!reset_n) lfxt_clk_cnt <= 9'h000;
    else          lfxt_clk_cnt <= lfxt_clk_cnt + 9'h001;
  
  assign lfxt_clk = lfxt_clk_cnt[8];

  //-------------------------------------------------------------------
  // Debug Interface

//  assign  dbg_i2c_addr       =  I2C_DEBUG_ADDR;
//  assign  dbg_i2c_broadcast  =  I2C_DEBUG_BROADCAST_ADDR;
  assign  dbg_i2c_addr       =  i2c_debug_addr;
  assign  dbg_i2c_broadcast  =  7'h50;  

  assign i2c_sda_out         = dbg_i2c_sda_out;
  assign dbg_i2c_sda_in      = i2c_sda_in;
  assign dbg_i2c_scl         = i2c_scl;

  assign  dbg_uart_rxd       =  1'b1;
  //-------------------------------------------------------------------

  //-------------------------------------------------------------------
  // openMSP430 Core


/*
  openMSP430 #(.INST_NR(INST_NR), 
               .TOTAL_NR(TOTAL_NR)) openmsp430_0 (
*/
  openMSP430 openmsp430_0(
  // OUTPUTs
      .aclk              (),                    // ASIC ONLY: ACLK
      .aclk_en           (aclk_en),             // FPGA ONLY: ACLK enable
      .dbg_freeze        (dbg_freeze),          // Freeze peripherals
      .dbg_i2c_sda_out   (dbg_i2c_sda_out),     // Debug interface: I2C SDA OUT
      .dbg_uart_txd      (dbg_uart_txd),        // Debug interface: UART TXD
      .dco_enable        (),                    // ASIC ONLY: Fast oscillator enable
      .dco_wkup          (),                    // ASIC ONLY: Fast oscillator wake-up (asynchronous)
      .dmem_addr         (dmem_addr),           // Data Memory address
      .dmem_cen          (dmem_cen),            // Data Memory chip enable (low active)
      .dmem_din          (dmem_din),            // Data Memory data input
      .dmem_wen          (dmem_wen),            // Data Memory write enable (low active)
      .irq_acc           (irq_acc),             // Interrupt request accepted (one-hot signal)
      .lfxt_enable       (),                    // ASIC ONLY: Low frequency oscillator enable
      .lfxt_wkup         (),                    // ASIC ONLY: Low frequency oscillator wake-up (asynchronous)
      .mclk              (mclk),                // Main system clock
      .dma_dout          (),                    // Direct Memory Access data output
      .dma_ready         (),                    // Direct Memory Access is complete
      .dma_resp          (),                    // Direct Memory Access response (0:Okay / 1:Error)
      .per_addr          (per_addr),            // Peripheral address
      .per_din           (per_din),             // Peripheral data input
      .per_we            (per_we),              // Peripheral write enable (high active)
      .per_en            (per_en),              // Peripheral enable (high active)
      .pmem_addr         (pmem_addr),           // Program Memory address
      .pmem_cen          (pmem_cen),            // Program Memory chip enable (low active)
      .pmem_din          (pmem_din),            // Program Memory data input (optional)
      .pmem_wen          (pmem_wen),            // Program Memory write enable (low active) (optional)
      .puc_rst           (puc_rst),             // Main system reset
      .smclk             (),                    // ASIC ONLY: SMCLK
      .smclk_en          (smclk_en),            // FPGA ONLY: SMCLK enable
  
  // INPUTs
      .cpu_en            (1'b1),                // Enable CPU code execution (asynchronous and non-glitchy)
      .dbg_en            (1'b1),                // Debug interface enable (asynchronous and non-glitchy)
      .dbg_i2c_addr      (dbg_i2c_addr),        // Debug interface: I2C Address
      .dbg_i2c_broadcast (dbg_i2c_broadcast),   // Debug interface: I2C Broadcast Address (for multicore systems)
      .dbg_i2c_scl       (dbg_i2c_scl),         // Debug interface: I2C SCL
      .dbg_i2c_sda_in    (dbg_i2c_sda_in),      // Debug interface: I2C SDA IN
      .dbg_uart_rxd      (dbg_uart_rxd),        // Debug interface: UART RXD (asynchronous)
      .dco_clk           (dco_clk),             // Fast oscillator (fast clock)
      .dmem_dout         (dmem_dout),           // Data Memory data output
      .irq               (irq_bus),             // Maskable interrupts
      .lfxt_clk          (lfxt_clk),            // Low frequency oscillator (typ 32kHz)
      .dma_addr          (15'h0000),            // Direct Memory Access address
      .dma_din           (16'h0000),            // Direct Memory Access data input
      .dma_en            (1'b0),                // Direct Memory Access enable (high active)
      .dma_priority      (1'b0),                // Direct Memory Access priority (0:low / 1:high)
      .dma_we            (2'b00),               // Direct Memory Access write byte enable (high active)
      .dma_wkup          (1'b0),                // ASIC ONLY: DMA Sub-System Wake-up (asynchronous and non-glitchy)
      .nmi               (nmi),                 // Non-maskable interrupt (asynchronous)
      .per_dout          (per_dout),            // Peripheral data output
      .pmem_dout         (pmem_dout),           // Program Memory data output
      .reset_n           (reset_n),             // Reset Pin (low active, asynchronous and non-glitchy)
      .scan_enable       (1'b0),                // ASIC ONLY: Scan enable (active during scan shifting)
      .scan_mode         (1'b0),                // ASIC ONLY: Scan mode
      .wkup              (1'b0),                 // ASIC ONLY: System Wake-up (asynchronous and non-glitchy)
      .inst_nr           (inst_nr),
      .total_nr          (8'd5)
  );

  //-------------------------------------------------------------------
  // Gray Coded Timer

  omsp_timerA timerA_0 (
  
  // OUTPUTs
      .irq_ta0           (irq_ta0),             // Timer A interrupt: TACCR0
      .irq_ta1           (irq_ta1),             // Timer A interrupt: TAIV, TACCR1, TACCR2
      .per_dout          (per_dout_tA),         // Peripheral data output
      .ta_out0           (),                    // Timer A output 0
      .ta_out0_en        (),                    // Timer A output 0 enable
      .ta_out1           (pwm_out),             // Timer A output 1
      .ta_out1_en        (),                    // Timer A output 1 enable
      .ta_out2           (),                    // Timer A output 2
      .ta_out2_en        (),                    // Timer A output 2 enable
 
 
  // INPUTs
      .aclk_en           (aclk_en),             // ACLK enable (from CPU)
      .dbg_freeze        (dbg_freeze),          // Freeze Timer A counter
      .inclk             (1'b0),                // INCLK external timer clock (SLOW)
      .irq_ta0_acc       (irq_acc[9]),          // Interrupt request TACCR0 accepted
      .mclk              (mclk),                // Main system clock
      .per_addr          (per_addr),            // Peripheral address
      .per_din           (per_din),             // Peripheral data input
      .per_en            (per_en),              // Peripheral enable (high active)
      .per_we            (per_we),              // Peripheral write enable (high active)
      .puc_rst           (puc_rst),             // Main system reset
      .smclk_en          (smclk_en),            // SMCLK enable (from CPU)
      .ta_cci0a          (1'b0),                // Timer A capture 0 input A
      .ta_cci0b          (1'b0),                // Timer A capture 0 input B
      .ta_cci1a          (1'b0),                // Timer A capture 1 input A
      .ta_cci1b          (1'b0),                // Timer A capture 1 input B
      .ta_cci2a          (1'b0),                // Timer A capture 2 input A
      .ta_cci2b          (1'b0),                // Timer A capture 2 input B
      .taclk             (1'b0)                 // TACLK external timer clock (SLOW)
  );

  //-------------------------------------------------------------------
  // GPIO Ports

  omsp_gpio_16bit #(.P1_EN(1),
              .P2_EN(1),
              .P3_EN(1),
              .P4_EN(0),
              .P5_EN(0),
              .P6_EN(0)) gpio_0 (
  
  // OUTPUTs
      .irq_port1    (irq_port1),     // Port 1 interrupt
      .irq_port2    (irq_port2),     // Port 2 interrupt
      .p1_dout      (p1_dout),       // Port 1 data output
      .p1_dout_en   (p1_dout_en),    // Port 1 data output enable
      .p1_sel       (p1_sel),        // Port 1 function select
      .p2_dout      (p2_dout),       // Port 2 data output
      .p2_dout_en   (p2_dout_en),    // Port 2 data output enable
      .p2_sel       (p2_sel),        // Port 2 function select
      .p3_dout      (p3_dout),       // Port 3 data output
      .p3_dout_en   (p3_dout_en),    // Port 3 data output enable
      .p3_sel       (p3_sel),        // Port 3 function select
      .p4_dout      (),              // Port 4 data output
      .p4_dout_en   (),              // Port 4 data output enable
      .p4_sel       (),              // Port 4 function select
      .p5_dout      (),              // Port 5 data output
      .p5_dout_en   (),              // Port 5 data output enable
      .p5_sel       (),              // Port 5 function select
      .p6_dout      (),              // Port 6 data output
      .p6_dout_en   (),              // Port 6 data output enable
      .p6_sel       (),              // Port 6 function select
      .per_dout     (per_dout_dio),  // Peripheral data output
  
  // INPUTs
      .mclk         (mclk),          // Main system clock
      .p1_din       (p1_din),        // Port 1 data input
      .p2_din       (p2_din),        // Port 2 data input
      .p3_din       (p3_din),        // Port 3 data input
      .p4_din       (16'h0000),      // Port 4 data input
      .p5_din       (16'h0000),      // Port 5 data input
      .p6_din       (16'h0000),      // Port 6 data input
      .per_addr     (per_addr),      // Peripheral address
      .per_din      (per_din),       // Peripheral data input
      .per_en       (per_en),        // Peripheral enable (high active)
      .per_we       (per_we),        // Peripheral write enable (high active)
      .puc_rst      (puc_rst)        // Main system reset
  );

  assign data_out_1_enable = p1_dout_en[7:0];
  assign data_out_1 = p1_dout[7:0];
  assign data_out_2 = p2_dout[8:0];
  assign data_out_3 = p3_dout[8:0];
  assign p1_din[7:0]     = data_in_1;
  assign p2_din[8:0]     = data_in_2;
  assign p3_din[8:0]     = data_in_3;

  //-------------------------------------------------------------------
  // ROs

  ro_top_0 ro_0(

  // OUTPUTs
      .per_dout     (per_dout_ro_0),   // Peripheral data output

  // INPUTs
      .mclk         (mclk),          // Main system clock
      .per_addr     (per_addr),      // Peripheral address
      .per_din      (per_din),       // Peripheral data input
      .per_en       (per_en),        // Peripheral enable (high active)
      .per_we       (per_we),        // Peripheral write enable (high active)
      .puc_rst      (puc_rst),       // Main system reset
      .PWM_out      (pwm_out)
  );


  ro_top_1 ro_1(

  // OUTPUTs
      .per_dout     (per_dout_ro_1),   // Peripheral data output

  // INPUTs
      .mclk         (mclk),          // Main system clock
      .per_addr     (per_addr),      // Peripheral address
      .per_din      (per_din),       // Peripheral data input
      .per_en       (per_en),        // Peripheral enable (high active)
      .per_we       (per_we),        // Peripheral write enable (high active)
      .puc_rst      (puc_rst),       // Main system reset
      .PWM_out      (pwm_out)
  );


  ro_top_2 ro_2(

  // OUTPUTs
      .per_dout     (per_dout_ro_2),   // Peripheral data output

  // INPUTs
      .mclk         (mclk),          // Main system clock
      .per_addr     (per_addr),      // Peripheral address
      .per_din      (per_din),       // Peripheral data input
      .per_en       (per_en),        // Peripheral enable (high active)
      .per_we       (per_we),        // Peripheral write enable (high active)
      .puc_rst      (puc_rst),       // Main system reset
      .PWM_out      (pwm_out)
  );


  //-------------------------------------------------------------------
  // UART 

   omsp_uart uart_0 (
	   .irq_uart_rx  (irq_uart_rx),   // UART receive interrupt
	   .irq_uart_tx  (irq_uart_tx),   // UART transmit interrupt
	   .per_dout     (per_dout_uart), // Peripheral data output
	   .uart_txd     (user_uart_tx),  // UART Data Transmit (TXD)
	   .mclk         (mclk),          // Main system clock
	   .per_addr     (per_addr),      // Peripheral address
	   .per_din      (per_din),       // Peripheral data input
	   .per_en       (per_en),        // Peripheral enable (high active)
	   .per_we       (per_we),        // Peripheral write enable (high active)
	   .puc_rst      (puc_rst),       // Main system reset
	   .smclk_en     (smclk_en),      // SMCLK enable (from CPU)
	   .uart_rxd     (user_uart_rx)   // UART Data Receive (RXD)
	   );

  //-------------------------------------------------------------------
  // Data Bus and Interrupt

  assign per_dout = per_dout_dio   |
                    per_dout_tA    |
		    per_dout_ro_0  |
                    per_dout_ro_1  |
                    per_dout_ro_2  |
		    per_dout_uart; 

  assign nmi        =  msp430_nmi_execute;

  assign irq_bus    = {reset,        // Vector 13  (0xFFFA)
                       nmi,          // Vector 12  (0xFFF8)
                       1'b0,         // Vector 11  (0xFFF6)
                       1'b0,         // Vector 10  (0xFFF4) - Watchdog -
                       irq_ta0,      // Vector  9  (0xFFF2)
                       irq_ta1,      // Vector  8  (0xFFF0)
                       irq_uart_rx,  // Vector  7  (0xFFEE)
                       irq_uart_tx,  // Vector  6  (0xFFEC)
                       1'b0,         // Vector  5  (0xFFEA)
                       1'b0,         // Vector  4  (0xFFE8)
                       irq_port2,    // Vector  3  (0xFFE6)
                       irq_port1,    // Vector  2  (0xFFE4)
                       1'b0,         // Vector  1  (0xFFE2)
                       1'b0};        // Vector  0  (0xFFE0)

  //-------------------------------------------------------------------
  // Program and Data Memory

   sram_16_2k pmem_0 (
                      .addra   ( pmem_addr),
                      .ena     (~pmem_cen),
                      .clka    ( mclk),
                      .dina    ( pmem_din),
                      .wea     (~pmem_wen),
                      .douta   ( pmem_dout)
                      );

   sram_16_2k dmem_0 (
                      .addra   ( dmem_addr),
                      .ena     (~dmem_cen),
                      .clka    ( mclk),
                      .dina    ( dmem_din),
                      .wea     (~dmem_wen),
                      .douta   ( dmem_dout)
                      );

endmodule
