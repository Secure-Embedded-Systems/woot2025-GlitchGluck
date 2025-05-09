//----------------------------------------------------------------------------
//
// *File Name: omsp_gpio_16bit.v
// 
// *Module Description:
//                       16-bit Digital I/O interface
//
// *Author(s):
//              - Zhenyuan (Charlotte) Liu,    zliu12@wpi.edu
//
//----------------------------------------------------------------------------

module  omsp_gpio_16bit (

// OUTPUTs
    irq_port1,                      // Port 1 interrupt
    irq_port2,                      // Port 2 interrupt
    p1_dout,                        // Port 1 data output
    p1_dout_en,                     // Port 1 data output enable
    p1_sel,                         // Port 1 function select
    p2_dout,                        // Port 2 data output
    p2_dout_en,                     // Port 2 data output enable
    p2_sel,                         // Port 2 function select
    p3_dout,                        // Port 3 data output
    p3_dout_en,                     // Port 3 data output enable
    p3_sel,                         // Port 3 function select
    p4_dout,                        // Port 4 data output
    p4_dout_en,                     // Port 4 data output enable
    p4_sel,                         // Port 4 function select
    p5_dout,                        // Port 5 data output
    p5_dout_en,                     // Port 5 data output enable
    p5_sel,                         // Port 5 function select
    p6_dout,                        // Port 6 data output
    p6_dout_en,                     // Port 6 data output enable
    p6_sel,                         // Port 6 function select
    per_dout,                       // Peripheral data output

// INPUTs
    mclk,                           // Main system clock
    p1_din,                         // Port 1 data input
    p2_din,                         // Port 2 data input
    p3_din,                         // Port 3 data input
    p4_din,                         // Port 4 data input
    p5_din,                         // Port 5 data input
    p6_din,                         // Port 6 data input
    per_addr,                       // Peripheral address
    per_din,                        // Peripheral data input
    per_en,                         // Peripheral enable (high active)
    per_we,                         // Peripheral write enable (high active)
    puc_rst                         // Main system reset
);

// PARAMETERs
//============
parameter           P1_EN = 1'b1;   // Enable Port 1
parameter           P2_EN = 1'b1;   // Enable Port 2
parameter           P3_EN = 1'b1;   // Enable Port 3
parameter           P4_EN = 1'b0;   // Enable Port 4
parameter           P5_EN = 1'b0;   // Enable Port 5
parameter           P6_EN = 1'b0;   // Enable Port 6


// OUTPUTs
//=========
output wire             irq_port1;      // Port 1 interrupt
output wire             irq_port2;      // Port 2 interrupt
output wire      [15:0] p1_dout;        // Port 1 data output
output wire      [15:0] p1_dout_en;     // Port 1 data output enable
output wire      [15:0] p1_sel;         // Port 1 function select
output wire      [15:0] p2_dout;        // Port 2 data output
output wire      [15:0] p2_dout_en;     // Port 2 data output enable
output wire      [15:0] p2_sel;         // Port 2 function select
output wire      [15:0] p3_dout;        // Port 3 data output
output wire      [15:0] p3_dout_en;     // Port 3 data output enable
output wire      [15:0] p3_sel;         // Port 3 function select
output wire      [15:0] p4_dout;        // Port 4 data output
output wire      [15:0] p4_dout_en;     // Port 4 data output enable
output wire      [15:0] p4_sel;         // Port 4 function select
output wire      [15:0] p5_dout;        // Port 5 data output
output wire      [15:0] p5_dout_en;     // Port 5 data output enable
output wire      [15:0] p5_sel;         // Port 5 function select
output wire      [15:0] p6_dout;        // Port 6 data output
output wire      [15:0] p6_dout_en;     // Port 6 data output enable
output wire      [15:0] p6_sel;         // Port 6 function select
output wire      [15:0] per_dout;       // Peripheral data output

// INPUTs
//=========
input wire              mclk;           // Main system clock
input wire       [15:0] p1_din;         // Port 1 data input
input wire       [15:0] p2_din;         // Port 2 data input
input wire       [15:0] p3_din;         // Port 3 data input
input wire       [15:0] p4_din;         // Port 4 data input
input wire       [15:0] p5_din;         // Port 5 data input
input wire       [15:0] p6_din;         // Port 6 data input
input wire       [13:0] per_addr;       // Peripheral address
input wire       [15:0] per_din;        // Peripheral data input
input wire              per_en;         // Peripheral enable (high active)
input wire       [1:0]  per_we;         // Peripheral write enable (high active)
input wire              puc_rst;        // Main system reset


//=============================================================================
// 1)  PARAMETER DECLARATION
//=============================================================================

// Masks
parameter              P1_EN_MSK   = {16{P1_EN[0]}};
parameter              P2_EN_MSK   = {16{P2_EN[0]}};
parameter              P3_EN_MSK   = {16{P3_EN[0]}};
parameter              P4_EN_MSK   = {16{P4_EN[0]}};
parameter              P5_EN_MSK   = {16{P5_EN[0]}};
parameter              P6_EN_MSK   = {16{P6_EN[0]}};

// Register base address (must be aligned to decoder bit width)
parameter       [14:0] BASE_ADDR   = 15'h0000;

// Decoder bit width (defines how many bits are considered for address decoding)
parameter              DEC_WD      =  7;

// Register addresses offset
parameter [DEC_WD-1:0] P1IN        = 'h18,                    // Port 1
                       P1OUT       = 'h1A,
                       P1DIR       = 'h1C,
                       P1IFG       = 'h1E,
                       P1IES       = 'h20,
                       P1IE        = 'h22,
                       P1SEL       = 'h24,
                       P2IN        = 'h26,                    // Port 2
                       P2OUT       = 'h28,
                       P2DIR       = 'h2A,
                       P2IFG       = 'h2C,
                       P2IES       = 'h2E,
                       P2IE        = 'h30,
                       P2SEL       = 'h32,
                       P3IN        = 'h34,                    // Port 3
                       P3OUT       = 'h36,
                       P3DIR       = 'h38,
                       P3SEL       = 'h3A,
                       P4IN        = 'h3C,                    // Port 4
                       P4OUT       = 'h3E,
                       P4DIR       = 'h40,
                       P4SEL       = 'h42,
                       P5IN        = 'h44,                    // Port 5
                       P5OUT       = 'h46,
                       P5DIR       = 'h48,
                       P5SEL       = 'h4A,
                       P6IN        = 'h4C,                    // Port 6
                       P6OUT       = 'h4E,
                       P6DIR       = 'h50,
                       P6SEL       = 'h52;

// Register one-hot decoder utilities
parameter              DEC_SZ      =  (1 << DEC_WD);
parameter [DEC_SZ-1:0] BASE_REG    =  {{DEC_SZ-1{1'b0}}, 1'b1};

// Register one-hot decoder
parameter [DEC_SZ-1:0] P1IN_D      =  (BASE_REG << P1IN),     // Port 1
                       P1OUT_D     =  (BASE_REG << P1OUT),
                       P1DIR_D     =  (BASE_REG << P1DIR),
                       P1IFG_D     =  (BASE_REG << P1IFG),
                       P1IES_D     =  (BASE_REG << P1IES),
                       P1IE_D      =  (BASE_REG << P1IE),
                       P1SEL_D     =  (BASE_REG << P1SEL),
                       P2IN_D      =  (BASE_REG << P2IN),     // Port 2
                       P2OUT_D     =  (BASE_REG << P2OUT),
                       P2DIR_D     =  (BASE_REG << P2DIR),
                       P2IFG_D     =  (BASE_REG << P2IFG),
                       P2IES_D     =  (BASE_REG << P2IES),
                       P2IE_D      =  (BASE_REG << P2IE),
                       P2SEL_D     =  (BASE_REG << P2SEL),
                       P3IN_D      =  (BASE_REG << P3IN),     // Port 3
                       P3OUT_D     =  (BASE_REG << P3OUT),
                       P3DIR_D     =  (BASE_REG << P3DIR),
                       P3SEL_D     =  (BASE_REG << P3SEL),
                       P4IN_D      =  (BASE_REG << P4IN),     // Port 4
                       P4OUT_D     =  (BASE_REG << P4OUT),
                       P4DIR_D     =  (BASE_REG << P4DIR),
                       P4SEL_D     =  (BASE_REG << P4SEL),
                       P5IN_D      =  (BASE_REG << P5IN),     // Port 5
                       P5OUT_D     =  (BASE_REG << P5OUT),
                       P5DIR_D     =  (BASE_REG << P5DIR),
                       P5SEL_D     =  (BASE_REG << P5SEL),
                       P6IN_D      =  (BASE_REG << P6IN),     // Port 6
                       P6OUT_D     =  (BASE_REG << P6OUT),
                       P6DIR_D     =  (BASE_REG << P6DIR),
                       P6SEL_D     =  (BASE_REG << P6SEL); 


//============================================================================
// 2)  REGISTER DECODER
//============================================================================

// Local register selection
wire              reg_sel      =  per_en & (per_addr[13:DEC_WD-1]==BASE_ADDR[14:DEC_WD]);

// Register local address
wire [DEC_WD-1:0] reg_addr  =  {per_addr[DEC_WD-2:0], 1'b0};

// Register address decode
wire [DEC_SZ-1:0] reg_dec      =  (P1IN_D   &  {DEC_SZ{(reg_addr==(P1IN  ))  &  P1_EN[0]}})  |
                                  (P1OUT_D  &  {DEC_SZ{(reg_addr==(P1OUT ))  &  P1_EN[0]}})  |
                                  (P1DIR_D  &  {DEC_SZ{(reg_addr==(P1DIR ))  &  P1_EN[0]}})  |
                                  (P1IFG_D  &  {DEC_SZ{(reg_addr==(P1IFG ))  &  P1_EN[0]}})  |
                                  (P1IES_D  &  {DEC_SZ{(reg_addr==(P1IES ))  &  P1_EN[0]}})  |
                                  (P1IE_D   &  {DEC_SZ{(reg_addr==(P1IE  ))  &  P1_EN[0]}})  |
                                  (P1SEL_D  &  {DEC_SZ{(reg_addr==(P1SEL ))  &  P1_EN[0]}})  |
                                  (P2IN_D   &  {DEC_SZ{(reg_addr==(P2IN  ))  &  P2_EN[0]}})  |
                                  (P2OUT_D  &  {DEC_SZ{(reg_addr==(P2OUT ))  &  P2_EN[0]}})  |
                                  (P2DIR_D  &  {DEC_SZ{(reg_addr==(P2DIR ))  &  P2_EN[0]}})  |
                                  (P2IFG_D  &  {DEC_SZ{(reg_addr==(P2IFG ))  &  P2_EN[0]}})  |
                                  (P2IES_D  &  {DEC_SZ{(reg_addr==(P2IES ))  &  P2_EN[0]}})  |
                                  (P2IE_D   &  {DEC_SZ{(reg_addr==(P2IE  ))  &  P2_EN[0]}})  |
                                  (P2SEL_D  &  {DEC_SZ{(reg_addr==(P2SEL ))  &  P2_EN[0]}})  |
                                  (P3IN_D   &  {DEC_SZ{(reg_addr==(P3IN  ))  &  P3_EN[0]}})  |
                                  (P3OUT_D  &  {DEC_SZ{(reg_addr==(P3OUT ))  &  P3_EN[0]}})  |
                                  (P3DIR_D  &  {DEC_SZ{(reg_addr==(P3DIR ))  &  P3_EN[0]}})  |
                                  (P3SEL_D  &  {DEC_SZ{(reg_addr==(P3SEL ))  &  P3_EN[0]}})  |
                                  (P4IN_D   &  {DEC_SZ{(reg_addr==(P4IN  ))  &  P4_EN[0]}})  |
                                  (P4OUT_D  &  {DEC_SZ{(reg_addr==(P4OUT ))  &  P4_EN[0]}})  |
                                  (P4DIR_D  &  {DEC_SZ{(reg_addr==(P4DIR ))  &  P4_EN[0]}})  |
                                  (P4SEL_D  &  {DEC_SZ{(reg_addr==(P4SEL ))  &  P4_EN[0]}})  |
                                  (P5IN_D   &  {DEC_SZ{(reg_addr==(P5IN  ))  &  P5_EN[0]}})  |
                                  (P5OUT_D  &  {DEC_SZ{(reg_addr==(P5OUT ))  &  P5_EN[0]}})  |
                                  (P5DIR_D  &  {DEC_SZ{(reg_addr==(P5DIR ))  &  P5_EN[0]}})  |
                                  (P5SEL_D  &  {DEC_SZ{(reg_addr==(P5SEL ))  &  P5_EN[0]}})  |
                                  (P6IN_D   &  {DEC_SZ{(reg_addr==(P6IN  ))  &  P6_EN[0]}})  |
                                  (P6OUT_D  &  {DEC_SZ{(reg_addr==(P6OUT ))  &  P6_EN[0]}})  |
                                  (P6DIR_D  &  {DEC_SZ{(reg_addr==(P6DIR ))  &  P6_EN[0]}})  |
                                  (P6SEL_D  &  {DEC_SZ{(reg_addr==(P6SEL ))  &  P6_EN[0]}});



// Read/Write probes
wire              reg_write =  |per_we & reg_sel;
wire              reg_read  = ~|per_we & reg_sel;


// Read/Write vectors
wire [DEC_SZ-1:0] reg_wr    = reg_dec & {DEC_SZ{reg_write}};
wire [DEC_SZ-1:0] reg_rd    = reg_dec & {DEC_SZ{reg_read}};


//============================================================================
// 3) REGISTERS
//============================================================================

// P1IN Register
//---------------
wire [15:0] p1in;

omsp_sync_cell sync_cell_p1in_0  (.data_out(p1in[0] ), .data_in(p1_din[0]  & P1_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p1in_1  (.data_out(p1in[1] ), .data_in(p1_din[1]  & P1_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p1in_2  (.data_out(p1in[2] ), .data_in(p1_din[2]  & P1_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p1in_3  (.data_out(p1in[3] ), .data_in(p1_din[3]  & P1_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p1in_4  (.data_out(p1in[4] ), .data_in(p1_din[4]  & P1_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p1in_5  (.data_out(p1in[5] ), .data_in(p1_din[5]  & P1_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p1in_6  (.data_out(p1in[6] ), .data_in(p1_din[6]  & P1_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p1in_7  (.data_out(p1in[7] ), .data_in(p1_din[7]  & P1_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p1in_8  (.data_out(p1in[8] ), .data_in(p1_din[8]  & P1_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p1in_9  (.data_out(p1in[9] ), .data_in(p1_din[9]  & P1_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p1in_10 (.data_out(p1in[10]), .data_in(p1_din[10] & P1_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p1in_11 (.data_out(p1in[11]), .data_in(p1_din[11] & P1_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p1in_12 (.data_out(p1in[12]), .data_in(p1_din[12] & P1_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p1in_13 (.data_out(p1in[13]), .data_in(p1_din[13] & P1_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p1in_14 (.data_out(p1in[14]), .data_in(p1_din[14] & P1_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p1in_15 (.data_out(p1in[15]), .data_in(p1_din[15] & P1_EN[0]), .clk(mclk), .rst(puc_rst));

// P1OUT Register
//----------------
/*
reg  [7:0] p1out;

wire       p1out_wr  = P1OUT[0] ? reg_hi_wr[P1OUT] : reg_lo_wr[P1OUT];
wire [7:0] p1out_nxt = P1OUT[0] ? per_din[15:8]    : per_din[7:0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p1out <=  8'h00;
  else if (p1out_wr)  p1out <=  p1out_nxt & P1_EN_MSK;
*/

reg [15:0] p1out;
wire       p1out_wr = reg_wr[P1OUT];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p1out <=  16'h0000;
  else if (p1out_wr)  p1out <=  per_din & P1_EN_MSK;

assign p1_dout = p1out;


// P1DIR Register
//----------------
/*
reg  [7:0] p1dir;

wire       p1dir_wr  = P1DIR[0] ? reg_hi_wr[P1DIR] : reg_lo_wr[P1DIR];
wire [7:0] p1dir_nxt = P1DIR[0] ? per_din[15:8]    : per_din[7:0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p1dir <=  8'h00;
  else if (p1dir_wr)  p1dir <=  p1dir_nxt & P1_EN_MSK;
*/

reg [15:0] p1dir;
wire       p1dir_wr = reg_wr[P1DIR];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p1dir <=  16'h0000;
  else if (p1dir_wr)  p1dir <=  per_din & P1_EN_MSK;

assign p1_dout_en = p1dir;

   
// P1IFG Register
//----------------
/*
reg  [7:0] p1ifg;

wire       p1ifg_wr  = P1IFG[0] ? reg_hi_wr[P1IFG] : reg_lo_wr[P1IFG];
wire [7:0] p1ifg_nxt = P1IFG[0] ? per_din[15:8]    : per_din[7:0];
wire [7:0] p1ifg_set;
       
always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p1ifg <=  8'h00;
  else if (p1ifg_wr)  p1ifg <=  (p1ifg_nxt | p1ifg_set) & P1_EN_MSK;
  else                p1ifg <=  (p1ifg     | p1ifg_set) & P1_EN_MSK;
*/

reg  [15:0] p1ifg;
wire        p1ifg_wr = reg_wr[P1IFG];
wire [15:0] p1ifg_set;

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p1ifg <=  16'h0000;
  else if (p1ifg_wr)  p1ifg <=  (per_din   | p1ifg_set) & P1_EN_MSK;
  else                p1ifg <=  (p1ifg     | p1ifg_set) & P1_EN_MSK;


// P1IES Register
//----------------
/*
reg  [7:0] p1ies;

wire       p1ies_wr  = P1IES[0] ? reg_hi_wr[P1IES] : reg_lo_wr[P1IES];
wire [7:0] p1ies_nxt = P1IES[0] ? per_din[15:8]    : per_din[7:0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p1ies <=  8'h00;
  else if (p1ies_wr)  p1ies <=  p1ies_nxt & P1_EN_MSK;
*/

reg  [15:0] p1ies;
wire        p1ies_wr = reg_wr[P1IES];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p1ies <=  16'h0000;
  else if (p1ies_wr)  p1ies <=  per_din & P1_EN_MSK;

   
// P1IE Register
//----------------
/*
reg  [7:0] p1ie;

wire       p1ie_wr  = P1IE[0] ? reg_hi_wr[P1IE] : reg_lo_wr[P1IE];
wire [7:0] p1ie_nxt = P1IE[0] ? per_din[15:8]   : per_din[7:0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)       p1ie <=  8'h00;
  else if (p1ie_wr)  p1ie <=  p1ie_nxt & P1_EN_MSK;
*/

reg  [15:0] p1ie;
wire        p1ie_wr = reg_wr[P1IE];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)       p1ie <=  16'h0000;
  else if (p1ie_wr)  p1ie <=  per_din & P1_EN_MSK;


// P1SEL Register
//----------------
/*
reg  [7:0] p1sel;

wire       p1sel_wr  = P1SEL[0] ? reg_hi_wr[P1SEL] : reg_lo_wr[P1SEL];
wire [7:0] p1sel_nxt = P1SEL[0] ? per_din[15:8]    : per_din[7:0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)       p1sel <=  8'h00;
  else if (p1sel_wr) p1sel <=  p1sel_nxt & P1_EN_MSK;

assign p1_sel = p1sel;
*/

reg  [15:0] p1sel;
wire        p1sel_wr  = reg_wr[P1SEL];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)       p1sel <=  16'h0000;
  else if (p1sel_wr) p1sel <=  per_din & P1_EN_MSK;

assign p1_sel = p1sel;


   
// P2IN Register
//---------------
wire [15:0] p2in;

omsp_sync_cell sync_cell_p2in_0  (.data_out(p2in[0] ), .data_in(p2_din[0]  & P2_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p2in_1  (.data_out(p2in[1] ), .data_in(p2_din[1]  & P2_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p2in_2  (.data_out(p2in[2] ), .data_in(p2_din[2]  & P2_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p2in_3  (.data_out(p2in[3] ), .data_in(p2_din[3]  & P2_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p2in_4  (.data_out(p2in[4] ), .data_in(p2_din[4]  & P2_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p2in_5  (.data_out(p2in[5] ), .data_in(p2_din[5]  & P2_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p2in_6  (.data_out(p2in[6] ), .data_in(p2_din[6]  & P2_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p2in_7  (.data_out(p2in[7] ), .data_in(p2_din[7]  & P2_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p2in_8  (.data_out(p2in[8] ), .data_in(p2_din[8]  & P2_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p2in_9  (.data_out(p2in[9] ), .data_in(p2_din[9]  & P2_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p2in_10 (.data_out(p2in[10]), .data_in(p2_din[10] & P2_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p2in_11 (.data_out(p2in[11]), .data_in(p2_din[11] & P2_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p2in_12 (.data_out(p2in[12]), .data_in(p2_din[12] & P2_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p2in_13 (.data_out(p2in[13]), .data_in(p2_din[13] & P2_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p2in_14 (.data_out(p2in[14]), .data_in(p2_din[14] & P2_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p2in_15 (.data_out(p2in[15]), .data_in(p2_din[15] & P2_EN[0]), .clk(mclk), .rst(puc_rst));


// P2OUT Register
//----------------
/*
reg  [7:0] p2out;

wire       p2out_wr  = P2OUT[0] ? reg_hi_wr[P2OUT] : reg_lo_wr[P2OUT];
wire [7:0] p2out_nxt = P2OUT[0] ? per_din[15:8]    : per_din[7:0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p2out <=  8'h00;
  else if (p2out_wr)  p2out <=  p2out_nxt & P2_EN_MSK;

assign p2_dout = p2out;
*/

reg  [15:0] p2out;
wire        p2out_wr  = reg_wr[P2OUT];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p2out <=  16'h0000;
  else if (p2out_wr)  p2out <=  per_din & P2_EN_MSK;

assign p2_dout = p2out;



// P2DIR Register
//----------------
/*
reg  [7:0] p2dir;

wire       p2dir_wr  = P2DIR[0] ? reg_hi_wr[P2DIR] : reg_lo_wr[P2DIR];
wire [7:0] p2dir_nxt = P2DIR[0] ? per_din[15:8]    : per_din[7:0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p2dir <=  8'h00;
  else if (p2dir_wr)  p2dir <=  p2dir_nxt & P2_EN_MSK;

assign p2_dout_en = p2dir;
*/

reg  [15:0] p2dir;
wire        p2dir_wr  = reg_wr[P2DIR];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p2dir <=  16'h0000;
  else if (p2dir_wr)  p2dir <=  per_din & P2_EN_MSK;

assign p2_dout_en = p2dir;


   
// P2IFG Register
//----------------
/*
reg  [7:0] p2ifg;

wire       p2ifg_wr  = P2IFG[0] ? reg_hi_wr[P2IFG] : reg_lo_wr[P2IFG];
wire [7:0] p2ifg_nxt = P2IFG[0] ? per_din[15:8]    : per_din[7:0];
wire [7:0] p2ifg_set;

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p2ifg <=  8'h00;
  else if (p2ifg_wr)  p2ifg <=  (p2ifg_nxt | p2ifg_set) & P2_EN_MSK;
  else                p2ifg <=  (p2ifg     | p2ifg_set) & P2_EN_MSK;
*/

reg  [15:0] p2ifg;
wire        p2ifg_wr  = reg_wr[P2IFG];
wire [15:0] p2ifg_set;

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p2ifg <=  16'h0000;
  else if (p2ifg_wr)  p2ifg <=  (per_din   | p2ifg_set) & P2_EN_MSK;
  else                p2ifg <=  (p2ifg     | p2ifg_set) & P2_EN_MSK;

   
// P2IES Register
//----------------
/*
reg  [7:0] p2ies;

wire       p2ies_wr  = P2IES[0] ? reg_hi_wr[P2IES] : reg_lo_wr[P2IES];
wire [7:0] p2ies_nxt = P2IES[0] ? per_din[15:8]    : per_din[7:0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p2ies <=  8'h00;
  else if (p2ies_wr)  p2ies <=  p2ies_nxt & P2_EN_MSK;
*/

reg  [15:0] p2ies;
wire        p2ies_wr  = reg_wr[P2IES];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p2ies <=  16'h0000;
  else if (p2ies_wr)  p2ies <=  per_din & P2_EN_MSK;

   
// P2IE Register
//----------------
/*
reg  [7:0] p2ie;

wire       p2ie_wr  = P2IE[0] ? reg_hi_wr[P2IE] : reg_lo_wr[P2IE];
wire [7:0] p2ie_nxt = P2IE[0] ? per_din[15:8]   : per_din[7:0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)       p2ie <=  8'h00;
  else if (p2ie_wr)  p2ie <=  p2ie_nxt & P2_EN_MSK;
*/

reg  [15:0] p2ie;
wire        p2ie_wr  = reg_wr[P2IE];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)       p2ie <=  16'h0000;
  else if (p2ie_wr)  p2ie <=  per_din & P2_EN_MSK;


   
// P2SEL Register
//----------------
/*
reg  [7:0] p2sel;

wire       p2sel_wr  = P2SEL[0] ? reg_hi_wr[P2SEL] : reg_lo_wr[P2SEL];
wire [7:0] p2sel_nxt = P2SEL[0] ? per_din[15:8]    : per_din[7:0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)       p2sel <=  8'h00;
  else if (p2sel_wr) p2sel <=  p2sel_nxt & P2_EN_MSK;

assign p2_sel = p2sel;
*/

reg  [15:0] p2sel;
wire        p2sel_wr  = reg_wr[P2SEL];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)       p2sel <=  16'h0000;
  else if (p2sel_wr) p2sel <=  per_din & P2_EN_MSK;

assign p2_sel = p2sel;

   
// P3IN Register
//---------------
wire  [15:0] p3in;

omsp_sync_cell sync_cell_p3in_0  (.data_out(p3in[0] ), .data_in(p3_din[0]  & P3_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p3in_1  (.data_out(p3in[1] ), .data_in(p3_din[1]  & P3_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p3in_2  (.data_out(p3in[2] ), .data_in(p3_din[2]  & P3_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p3in_3  (.data_out(p3in[3] ), .data_in(p3_din[3]  & P3_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p3in_4  (.data_out(p3in[4] ), .data_in(p3_din[4]  & P3_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p3in_5  (.data_out(p3in[5] ), .data_in(p3_din[5]  & P3_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p3in_6  (.data_out(p3in[6] ), .data_in(p3_din[6]  & P3_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p3in_7  (.data_out(p3in[7] ), .data_in(p3_din[7]  & P3_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p3in_8  (.data_out(p3in[8] ), .data_in(p3_din[8]  & P3_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p3in_9  (.data_out(p3in[9] ), .data_in(p3_din[9]  & P3_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p3in_10 (.data_out(p3in[10]), .data_in(p3_din[10] & P3_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p3in_11 (.data_out(p3in[11]), .data_in(p3_din[11] & P3_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p3in_12 (.data_out(p3in[12]), .data_in(p3_din[12] & P3_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p3in_13 (.data_out(p3in[13]), .data_in(p3_din[13] & P3_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p3in_14 (.data_out(p3in[14]), .data_in(p3_din[14] & P3_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p3in_15 (.data_out(p3in[15]), .data_in(p3_din[15] & P3_EN[0]), .clk(mclk), .rst(puc_rst));


// P3OUT Register
//----------------
/*
reg  [7:0] p3out;

wire       p3out_wr  = P3OUT[0] ? reg_hi_wr[P3OUT] : reg_lo_wr[P3OUT];
wire [7:0] p3out_nxt = P3OUT[0] ? per_din[15:8]    : per_din[7:0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p3out <=  8'h00;
  else if (p3out_wr)  p3out <=  p3out_nxt & P3_EN_MSK;

assign p3_dout = p3out;
*/

reg  [15:0] p3out;
wire        p3out_wr  = reg_wr[P3OUT];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p3out <=  16'h0000;
  else if (p3out_wr)  p3out <=  per_din & P3_EN_MSK;

assign p3_dout = p3out;



// P3DIR Register
//----------------
/*
reg  [7:0] p3dir;

wire       p3dir_wr  = P3DIR[0] ? reg_hi_wr[P3DIR] : reg_lo_wr[P3DIR];
wire [7:0] p3dir_nxt = P3DIR[0] ? per_din[15:8]    : per_din[7:0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p3dir <=  8'h00;
  else if (p3dir_wr)  p3dir <=  p3dir_nxt & P3_EN_MSK;

assign p3_dout_en = p3dir;
*/

reg  [15:0] p3dir;
wire        p3dir_wr  = reg_wr[P3DIR];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p3dir <=  16'h0000;
  else if (p3dir_wr)  p3dir <=  per_din & P3_EN_MSK;

assign p3_dout_en = p3dir;



// P3SEL Register
//----------------
/*
reg  [7:0] p3sel;

wire       p3sel_wr  = P3SEL[0] ? reg_hi_wr[P3SEL] : reg_lo_wr[P3SEL];
wire [7:0] p3sel_nxt = P3SEL[0] ? per_din[15:8]    : per_din[7:0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)       p3sel <=  8'h00;
  else if (p3sel_wr) p3sel <=  p3sel_nxt & P3_EN_MSK;

assign p3_sel = p3sel;
*/

reg  [15:0] p3sel;
wire        p3sel_wr  = reg_wr[P3SEL];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)       p3sel <=  16'h0000;
  else if (p3sel_wr) p3sel <=  per_din & P3_EN_MSK;

assign p3_sel = p3sel;



   
// P4IN Register
//---------------
wire  [15:0] p4in;

omsp_sync_cell sync_cell_p4in_0  (.data_out(p4in[0] ), .data_in(p4_din[0]  & P4_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p4in_1  (.data_out(p4in[1] ), .data_in(p4_din[1]  & P4_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p4in_2  (.data_out(p4in[2] ), .data_in(p4_din[2]  & P4_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p4in_3  (.data_out(p4in[3] ), .data_in(p4_din[3]  & P4_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p4in_4  (.data_out(p4in[4] ), .data_in(p4_din[4]  & P4_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p4in_5  (.data_out(p4in[5] ), .data_in(p4_din[5]  & P4_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p4in_6  (.data_out(p4in[6] ), .data_in(p4_din[6]  & P4_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p4in_7  (.data_out(p4in[7] ), .data_in(p4_din[7]  & P4_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p4in_8  (.data_out(p4in[8] ), .data_in(p4_din[8]  & P4_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p4in_9  (.data_out(p4in[9] ), .data_in(p4_din[9]  & P4_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p4in_10 (.data_out(p4in[10]), .data_in(p4_din[10] & P4_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p4in_11 (.data_out(p4in[11]), .data_in(p4_din[11] & P4_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p4in_12 (.data_out(p4in[12]), .data_in(p4_din[12] & P4_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p4in_13 (.data_out(p4in[13]), .data_in(p4_din[13] & P4_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p4in_14 (.data_out(p4in[14]), .data_in(p4_din[14] & P4_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p4in_15 (.data_out(p4in[15]), .data_in(p4_din[15] & P4_EN[0]), .clk(mclk), .rst(puc_rst));

// P4OUT Register
//----------------
/*
reg  [7:0] p4out;

wire       p4out_wr  = P4OUT[0] ? reg_hi_wr[P4OUT] : reg_lo_wr[P4OUT];
wire [7:0] p4out_nxt = P4OUT[0] ? per_din[15:8]    : per_din[7:0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p4out <=  8'h00;
  else if (p4out_wr)  p4out <=  p4out_nxt & P4_EN_MSK;

assign p4_dout = p4out;
*/

reg  [15:0] p4out;
wire        p4out_wr  = reg_wr[P4OUT];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p4out <=  16'h0000;
  else if (p4out_wr)  p4out <=  per_din & P4_EN_MSK;

assign p4_dout = p4out;




// P4DIR Register
//----------------
/*
reg  [7:0] p4dir;

wire       p4dir_wr  = P4DIR[0] ? reg_hi_wr[P4DIR] : reg_lo_wr[P4DIR];
wire [7:0] p4dir_nxt = P4DIR[0] ? per_din[15:8]    : per_din[7:0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p4dir <=  8'h00;
  else if (p4dir_wr)  p4dir <=  p4dir_nxt & P4_EN_MSK;

assign p4_dout_en = p4dir;
*/

reg  [15:0] p4dir;
wire        p4dir_wr  = reg_wr[P4DIR];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p4dir <=  16'h0000;
  else if (p4dir_wr)  p4dir <=  per_din & P4_EN_MSK;

assign p4_dout_en = p4dir;


// P4SEL Register
//----------------
/*
reg  [7:0] p4sel;

wire       p4sel_wr  = P4SEL[0] ? reg_hi_wr[P4SEL] : reg_lo_wr[P4SEL];
wire [7:0] p4sel_nxt = P4SEL[0] ? per_din[15:8]    : per_din[7:0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)       p4sel <=  8'h00;
  else if (p4sel_wr) p4sel <=  p4sel_nxt & P4_EN_MSK;

assign p4_sel = p4sel;
*/

reg  [15:0] p4sel;
wire        p4sel_wr  = reg_wr[P4SEL];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)       p4sel <=  16'h0000;
  else if (p4sel_wr) p4sel <=  per_din & P4_EN_MSK;

assign p4_sel = p4sel;

   
// P5IN Register
//---------------
wire  [15:0] p5in;

omsp_sync_cell sync_cell_p5in_0  (.data_out(p5in[0] ), .data_in(p5_din[0]  & P5_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p5in_1  (.data_out(p5in[1] ), .data_in(p5_din[1]  & P5_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p5in_2  (.data_out(p5in[2] ), .data_in(p5_din[2]  & P5_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p5in_3  (.data_out(p5in[3] ), .data_in(p5_din[3]  & P5_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p5in_4  (.data_out(p5in[4] ), .data_in(p5_din[4]  & P5_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p5in_5  (.data_out(p5in[5] ), .data_in(p5_din[5]  & P5_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p5in_6  (.data_out(p5in[6] ), .data_in(p5_din[6]  & P5_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p5in_7  (.data_out(p5in[7] ), .data_in(p5_din[7]  & P5_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p5in_8  (.data_out(p5in[8] ), .data_in(p5_din[8]  & P5_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p5in_9  (.data_out(p5in[9] ), .data_in(p5_din[9]  & P5_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p5in_10 (.data_out(p5in[10]), .data_in(p5_din[10] & P5_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p5in_11 (.data_out(p5in[11]), .data_in(p5_din[11] & P5_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p5in_12 (.data_out(p5in[12]), .data_in(p5_din[12] & P5_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p5in_13 (.data_out(p5in[13]), .data_in(p5_din[13] & P5_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p5in_14 (.data_out(p5in[14]), .data_in(p5_din[14] & P5_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p5in_15 (.data_out(p5in[15]), .data_in(p5_din[15] & P5_EN[0]), .clk(mclk), .rst(puc_rst));


// P5OUT Register
//----------------
/*
reg  [7:0] p5out;

wire       p5out_wr  = P5OUT[0] ? reg_hi_wr[P5OUT] : reg_lo_wr[P5OUT];
wire [7:0] p5out_nxt = P5OUT[0] ? per_din[15:8]    : per_din[7:0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p5out <=  8'h00;
  else if (p5out_wr)  p5out <=  p5out_nxt & P5_EN_MSK;

assign p5_dout = p5out;
*/


reg  [15:0] p5out;
wire        p5out_wr  = reg_wr[P5OUT];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p5out <=  16'h0000;
  else if (p5out_wr)  p5out <=  per_din & P5_EN_MSK;

assign p5_dout = p5out;


// P5DIR Register
//----------------
/*
reg  [7:0] p5dir;

wire       p5dir_wr  = P5DIR[0] ? reg_hi_wr[P5DIR] : reg_lo_wr[P5DIR];
wire [7:0] p5dir_nxt = P5DIR[0] ? per_din[15:8]    : per_din[7:0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p5dir <=  8'h00;
  else if (p5dir_wr)  p5dir <=  p5dir_nxt & P5_EN_MSK;

assign p5_dout_en = p5dir;
*/


reg  [15:0] p5dir;
wire        p5dir_wr  = reg_wr[P5DIR];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p5dir <=  16'h0000;
  else if (p5dir_wr)  p5dir <=  per_din & P5_EN_MSK;

assign p5_dout_en = p5dir;

   
// P5SEL Register
//----------------
/*
reg  [7:0] p5sel;

wire       p5sel_wr  = P5SEL[0] ? reg_hi_wr[P5SEL] : reg_lo_wr[P5SEL];
wire [7:0] p5sel_nxt = P5SEL[0] ? per_din[15:8]    : per_din[7:0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)       p5sel <=  8'h00;
  else if (p5sel_wr) p5sel <=  p5sel_nxt & P5_EN_MSK;

assign p5_sel = p5sel;
*/


reg  [15:0] p5sel;
wire        p5sel_wr  = reg_wr[P5SEL];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)       p5sel <=  16'h0000;
  else if (p5sel_wr) p5sel <=  per_din & P5_EN_MSK;

assign p5_sel = p5sel;

   
// P6IN Register
//---------------
wire  [15:0] p6in;

omsp_sync_cell sync_cell_p6in_0  (.data_out(p6in[0] ), .data_in(p6_din[0]  & P6_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p6in_1  (.data_out(p6in[1] ), .data_in(p6_din[1]  & P6_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p6in_2  (.data_out(p6in[2] ), .data_in(p6_din[2]  & P6_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p6in_3  (.data_out(p6in[3] ), .data_in(p6_din[3]  & P6_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p6in_4  (.data_out(p6in[4] ), .data_in(p6_din[4]  & P6_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p6in_5  (.data_out(p6in[5] ), .data_in(p6_din[5]  & P6_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p6in_6  (.data_out(p6in[6] ), .data_in(p6_din[6]  & P6_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p6in_7  (.data_out(p6in[7] ), .data_in(p6_din[7]  & P6_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p6in_8  (.data_out(p6in[8] ), .data_in(p6_din[8]  & P6_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p6in_9  (.data_out(p6in[9] ), .data_in(p6_din[9]  & P6_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p6in_10 (.data_out(p6in[10]), .data_in(p6_din[10] & P6_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p6in_11 (.data_out(p6in[11]), .data_in(p6_din[11] & P6_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p6in_12 (.data_out(p6in[12]), .data_in(p6_din[12] & P6_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p6in_13 (.data_out(p6in[13]), .data_in(p6_din[13] & P6_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p6in_14 (.data_out(p6in[14]), .data_in(p6_din[14] & P6_EN[0]), .clk(mclk), .rst(puc_rst));
omsp_sync_cell sync_cell_p6in_15 (.data_out(p6in[15]), .data_in(p6_din[15] & P6_EN[0]), .clk(mclk), .rst(puc_rst));


// P6OUT Register
//----------------
/*
reg  [7:0] p6out;

wire       p6out_wr  = P6OUT[0] ? reg_hi_wr[P6OUT] : reg_lo_wr[P6OUT];
wire [7:0] p6out_nxt = P6OUT[0] ? per_din[15:8]    : per_din[7:0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p6out <=  8'h00;
  else if (p6out_wr)  p6out <=  p6out_nxt & P6_EN_MSK;

assign p6_dout = p6out;
*/


reg  [15:0] p6out;
wire        p6out_wr  = reg_wr[P6OUT];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p6out <=  16'h0000;
  else if (p6out_wr)  p6out <=  per_din & P6_EN_MSK;

assign p6_dout = p6out;


// P6DIR Register
//----------------
/*
reg  [7:0] p6dir;

wire       p6dir_wr  = P6DIR[0] ? reg_hi_wr[P6DIR] : reg_lo_wr[P6DIR];
wire [7:0] p6dir_nxt = P6DIR[0] ? per_din[15:8]    : per_din[7:0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p6dir <=  8'h00;
  else if (p6dir_wr)  p6dir <=  p6dir_nxt & P6_EN_MSK;

assign p6_dout_en = p6dir;
*/


reg  [15:0] p6dir;
wire        p6dir_wr  = reg_wr[P6DIR];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        p6dir <=  16'h0000;
  else if (p6dir_wr)  p6dir <=  per_din & P6_EN_MSK;

assign p6_dout_en = p6dir;

   
// P6SEL Register
//----------------
/*
reg  [7:0] p6sel;

wire       p6sel_wr  = P6SEL[0] ? reg_hi_wr[P6SEL] : reg_lo_wr[P6SEL];
wire [7:0] p6sel_nxt = P6SEL[0] ? per_din[15:8]    : per_din[7:0];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)       p6sel <=  8'h00;
  else if (p6sel_wr) p6sel <=  p6sel_nxt & P6_EN_MSK;

assign p6_sel = p6sel;
*/


reg  [15:0] p6sel;
wire        p6sel_wr  = reg_wr[P6SEL];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)       p6sel <=  16'h0000;
  else if (p6sel_wr) p6sel <=  per_din & P6_EN_MSK;

assign p6_sel = p6sel;

   

//============================================================================
// 4) INTERRUPT GENERATION
//============================================================================

// Port 1 interrupt
//------------------

/*
// Delay input
reg    [7:0] p1in_dly;
always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)  p1in_dly <=  8'h00;
  else          p1in_dly <=  p1in & P1_EN_MSK;

// Edge detection
wire   [7:0] p1in_re   =   p1in & ~p1in_dly;
wire   [7:0] p1in_fe   =  ~p1in &  p1in_dly;

// Set interrupt flag
assign       p1ifg_set = {p1ies[7] ? p1in_fe[7] : p1in_re[7],
                          p1ies[6] ? p1in_fe[6] : p1in_re[6],
                          p1ies[5] ? p1in_fe[5] : p1in_re[5],
                          p1ies[4] ? p1in_fe[4] : p1in_re[4],
                          p1ies[3] ? p1in_fe[3] : p1in_re[3],
                          p1ies[2] ? p1in_fe[2] : p1in_re[2],
                          p1ies[1] ? p1in_fe[1] : p1in_re[1],
                          p1ies[0] ? p1in_fe[0] : p1in_re[0]} & P1_EN_MSK;

// Generate CPU interrupt
assign       irq_port1 = |(p1ie & p1ifg) & P1_EN[0];
*/

// Delay input
reg    [15:0] p1in_dly;
always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)  p1in_dly <=  16'h0000;
  else          p1in_dly <=  p1in & P1_EN_MSK;    

// Edge detection
wire   [15:0] p1in_re   =   p1in & ~p1in_dly;
wire   [15:0] p1in_fe   =  ~p1in &  p1in_dly;

// Set interrupt flag
assign       p1ifg_set = {
                          p1ies[15] ? p1in_fe[15] : p1in_re[15],
                          p1ies[14] ? p1in_fe[14] : p1in_re[14],
                          p1ies[13] ? p1in_fe[13] : p1in_re[13],
                          p1ies[12] ? p1in_fe[12] : p1in_re[12],
                          p1ies[11] ? p1in_fe[11] : p1in_re[11],
                          p1ies[10] ? p1in_fe[10] : p1in_re[10],
                          p1ies[9]  ? p1in_fe[9]  : p1in_re[9] ,
                          p1ies[8]  ? p1in_fe[8]  : p1in_re[8] ,			  
			  p1ies[7]  ? p1in_fe[7]  : p1in_re[7] ,
                          p1ies[6]  ? p1in_fe[6]  : p1in_re[6] ,
                          p1ies[5]  ? p1in_fe[5]  : p1in_re[5] ,
                          p1ies[4]  ? p1in_fe[4]  : p1in_re[4] ,
                          p1ies[3]  ? p1in_fe[3]  : p1in_re[3] ,
                          p1ies[2]  ? p1in_fe[2]  : p1in_re[2] ,
                          p1ies[1]  ? p1in_fe[1]  : p1in_re[1] ,
                          p1ies[0]  ? p1in_fe[0]  : p1in_re[0] } & P1_EN_MSK;

// Generate CPU interrupt
assign       irq_port1 = |(p1ie & p1ifg) & P1_EN[0];


// Port 2 interrupt
//------------------

/*
// Delay input
reg    [7:0] p2in_dly;
always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)  p2in_dly <=  8'h00;
  else          p2in_dly <=  p2in & P2_EN_MSK;

// Edge detection
wire   [7:0] p2in_re   =   p2in & ~p2in_dly;
wire   [7:0] p2in_fe   =  ~p2in &  p2in_dly;

// Set interrupt flag
assign       p2ifg_set = {p2ies[7] ? p2in_fe[7] : p2in_re[7],
                          p2ies[6] ? p2in_fe[6] : p2in_re[6],
                          p2ies[5] ? p2in_fe[5] : p2in_re[5],
                          p2ies[4] ? p2in_fe[4] : p2in_re[4],
                          p2ies[3] ? p2in_fe[3] : p2in_re[3],
                          p2ies[2] ? p2in_fe[2] : p2in_re[2],
                          p2ies[1] ? p2in_fe[1] : p2in_re[1],
                          p2ies[0] ? p2in_fe[0] : p2in_re[0]} & P2_EN_MSK;

// Generate CPU interrupt
assign      irq_port2 = |(p2ie & p2ifg) & P2_EN[0];
*/

// Delay input
reg    [15:0] p2in_dly;
always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)  p2in_dly <=  16'h0000;
  else          p2in_dly <=  p2in & P2_EN_MSK;    

// Edge detection
wire   [15:0] p2in_re   =   p2in & ~p2in_dly;
wire   [15:0] p2in_fe   =  ~p2in &  p2in_dly;

// Set interrupt flag
assign       p2ifg_set = {
                          p2ies[15] ? p2in_fe[15] : p2in_re[15],
                          p2ies[14] ? p2in_fe[14] : p2in_re[14],
                          p2ies[13] ? p2in_fe[13] : p2in_re[13],
                          p2ies[12] ? p2in_fe[12] : p2in_re[12],
                          p2ies[11] ? p2in_fe[11] : p2in_re[11],
                          p2ies[10] ? p2in_fe[10] : p2in_re[10],
                          p2ies[9]  ? p2in_fe[9]  : p2in_re[9] ,
                          p2ies[8]  ? p2in_fe[8]  : p2in_re[8] ,
			  p2ies[7]  ? p2in_fe[7]  : p2in_re[7] ,
                          p2ies[6]  ? p2in_fe[6]  : p2in_re[6] ,
                          p2ies[5]  ? p2in_fe[5]  : p2in_re[5] ,
                          p2ies[4]  ? p2in_fe[4]  : p2in_re[4] ,
                          p2ies[3]  ? p2in_fe[3]  : p2in_re[3] ,
                          p2ies[2]  ? p2in_fe[2]  : p2in_re[2] ,
                          p2ies[1]  ? p2in_fe[1]  : p2in_re[1] ,
                          p2ies[0]  ? p2in_fe[0]  : p2in_re[0] } & P2_EN_MSK;

// Generate CPU interrupt
assign      irq_port2 = |(p2ie & p2ifg) & P2_EN[0];


//============================================================================
// 5) DATA OUTPUT GENERATION
//============================================================================

// Data output mux
wire [15:0] p1in_rd   = p1in  & {16{reg_rd[P1IN]}};
wire [15:0] p1out_rd  = p1out & {16{reg_rd[P1OUT]}};
wire [15:0] p1dir_rd  = p1dir & {16{reg_rd[P1DIR]}};
wire [15:0] p1ifg_rd  = p1ifg & {16{reg_rd[P1IFG]}};
wire [15:0] p1ies_rd  = p1ies & {16{reg_rd[P1IES]}};
wire [15:0] p1ie_rd   = p1ie  & {16{reg_rd[P1IE]}};
wire [15:0] p1sel_rd  = p1sel & {16{reg_rd[P1SEL]}};
wire [15:0] p2in_rd   = p2in  & {16{reg_rd[P2IN]}};
wire [15:0] p2out_rd  = p2out & {16{reg_rd[P2OUT]}};
wire [15:0] p2dir_rd  = p2dir & {16{reg_rd[P2DIR]}};
wire [15:0] p2ifg_rd  = p2ifg & {16{reg_rd[P2IFG]}};
wire [15:0] p2ies_rd  = p2ies & {16{reg_rd[P2IES]}};
wire [15:0] p2ie_rd   = p2ie  & {16{reg_rd[P2IE]}};
wire [15:0] p2sel_rd  = p2sel & {16{reg_rd[P2SEL]}};
wire [15:0] p3in_rd   = p3in  & {16{reg_rd[P3IN]}};
wire [15:0] p3out_rd  = p3out & {16{reg_rd[P3OUT]}};
wire [15:0] p3dir_rd  = p3dir & {16{reg_rd[P3DIR]}};
wire [15:0] p3sel_rd  = p3sel & {16{reg_rd[P3SEL]}};
wire [15:0] p4in_rd   = p4in  & {16{reg_rd[P4IN]}};
wire [15:0] p4out_rd  = p4out & {16{reg_rd[P4OUT]}};
wire [15:0] p4dir_rd  = p4dir & {16{reg_rd[P4DIR]}};
wire [15:0] p4sel_rd  = p4sel & {16{reg_rd[P4SEL]}};
wire [15:0] p5in_rd   = p5in  & {16{reg_rd[P5IN]}};
wire [15:0] p5out_rd  = p5out & {16{reg_rd[P5OUT]}};
wire [15:0] p5dir_rd  = p5dir & {16{reg_rd[P5DIR]}};
wire [15:0] p5sel_rd  = p5sel & {16{reg_rd[P5SEL]}};
wire [15:0] p6in_rd   = p6in  & {16{reg_rd[P6IN]}};
wire [15:0] p6out_rd  = p6out & {16{reg_rd[P6OUT]}};
wire [15:0] p6dir_rd  = p6dir & {16{reg_rd[P6DIR]}};
wire [15:0] p6sel_rd  = p6sel & {16{reg_rd[P6SEL]}};

assign per_dout  =  p1in_rd   |
                         p1out_rd  |
                         p1dir_rd  |
                         p1ifg_rd  |
                         p1ies_rd  |
                         p1ie_rd   |
                         p1sel_rd  |
                         p2in_rd   |
                         p2out_rd  |
                         p2dir_rd  |
                         p2ifg_rd  |
                         p2ies_rd  |
                         p2ie_rd   |
                         p2sel_rd  |
                         p3in_rd   |
                         p3out_rd  |
                         p3dir_rd  |
                         p3sel_rd  |
                         p4in_rd   |
                         p4out_rd  |
                         p4dir_rd  |
                         p4sel_rd  |
                         p5in_rd   |
                         p5out_rd  |
                         p5dir_rd  |
                         p5sel_rd  |
                         p6in_rd   |
                         p6out_rd  |
                         p6dir_rd  |
                         p6sel_rd;

endmodule // omsp_gpio
