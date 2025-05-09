//----------------------------------------------------------------------------
//
// *File Name: ro_top.v 
// 
// *Module Description:
//                       ro short and long stage top
//			 CNTRL1: RO_SHORT_STAGE_CONTROL_REG
//			 CNTRL2: RO_SHORT_STAGE_COUNTER_REG
//			 CNTRL3: RO_LONG_STAGE_CONTROL_REG
//			 CNTRL4: RO_LONG_STAGE_COUNTER_REG
//			 CNTRL5: RO_SHORT_STAGE_PREVIOUS_COUNTER_REG (after
//			 read, store into this reg)
//			 CNTRL6: RO_LONG_STAGE_PREVIOUS_COUNTER_REG (after
//			 read, store into this reg)
//
// *Author(s):
//              - Zhenyuan Charlotte Liu,    zliu12@wpi.edu
//
//----------------------------------------------------------------------------


module  ro_top_0 (

// OUTPUTs
    per_dout,                       // Peripheral data output

// INPUTs
    mclk,                           // Main system clock
    per_addr,                       // Peripheral address
    per_din,                        // Peripheral data input
    per_en,                         // Peripheral enable (high active)
    per_we,                         // Peripheral write enable (high active)
    puc_rst,                        // Main system reset
    PWM_out
);

// OUTPUTs
//=========
output           [15:0] per_dout;       // Peripheral data output

// INPUTs
//=========
input wire              mclk;           // Main system clock
input            [13:0] per_addr;       // Peripheral address
input            [15:0] per_din;        // Peripheral data input
input wire              per_en;         // Peripheral enable (high active)
input            [1:0]  per_we;         // Peripheral write enable (high active)
input wire              puc_rst;        // Main system reset
input wire 		PWM_out;

//=============================================================================
// 1)  PARAMETER DECLARATION
//=============================================================================

// Register base address (must be aligned to decoder bit width)
parameter       [14:0] BASE_ADDR   = 15'h0190;

// Decoder bit width (defines how many bits are considered for address decoding)
parameter              DEC_WD      =  4;

// Register addresses offset
parameter [DEC_WD-1:0] CNTRL1      = 'h0,
                       CNTRL2      = 'h2,
                       CNTRL3      = 'h4,
                       CNTRL4      = 'h6,
		       CNTRL5      = 'h8,
                       CNTRL6      = 'hA;


// Register one-hot decoder utilities
parameter              DEC_SZ      =  (1 << DEC_WD);
parameter [DEC_SZ-1:0] BASE_REG    =  {{DEC_SZ-1{1'b0}}, 1'b1};

// Register one-hot decoder
parameter [DEC_SZ-1:0] CNTRL1_D    = (BASE_REG << CNTRL1),
                       CNTRL2_D    = (BASE_REG << CNTRL2),
                       CNTRL3_D    = (BASE_REG << CNTRL3),
                       CNTRL4_D    = (BASE_REG << CNTRL4),
                       CNTRL5_D    = (BASE_REG << CNTRL5),
                       CNTRL6_D    = (BASE_REG << CNTRL6);


//============================================================================
// 2)  REGISTER DECODER
//============================================================================

// Local register selection
wire              reg_sel   =  per_en & (per_addr[13:DEC_WD-1]==BASE_ADDR[14:DEC_WD]);

// Register local address
wire [DEC_WD-1:0] reg_addr  =  {per_addr[DEC_WD-2:0], 1'b0};

// Register address decode
wire [DEC_SZ-1:0] reg_dec   =  (CNTRL1_D  &  {DEC_SZ{(reg_addr == CNTRL1 )}})  |
                               (CNTRL2_D  &  {DEC_SZ{(reg_addr == CNTRL2 )}})  |
                               (CNTRL3_D  &  {DEC_SZ{(reg_addr == CNTRL3 )}})  |
                               (CNTRL4_D  &  {DEC_SZ{(reg_addr == CNTRL4 )}})  |
                               (CNTRL5_D  &  {DEC_SZ{(reg_addr == CNTRL5 )}})  |
                               (CNTRL6_D  &  {DEC_SZ{(reg_addr == CNTRL6 )}});

// Read/Write probes
wire              reg_write =  |per_we & reg_sel;
wire              reg_read  = ~|per_we & reg_sel;

// Read/Write vectors
wire [DEC_SZ-1:0] reg_wr    = reg_dec & {DEC_SZ{reg_write}};
wire [DEC_SZ-1:0] reg_rd    = reg_dec & {DEC_SZ{reg_read}};


//============================================================================
// 3) REGISTERS
//============================================================================

// CNTRL1 Register
//-----------------   
reg  [15:0] cntrl1;

wire        cntrl1_wr = reg_wr[CNTRL1];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        cntrl1 <=  16'h0000;
  else if (cntrl1_wr) cntrl1 <=  per_din;


// PWM ro short stage
// ------------------
wire PWM_activate_ro_short;
assign PWM_activate_ro_short = (cntrl1[15]==1'b1) ? 1'b1 : 1'b0;


// ro short stage 
//-----------------
wire activate_ro_short;
reg en_short;
wire q_short;
reg [15:0] count_ro_short;

assign activate_ro_short = (cntrl1[0]==1'b1) ? 1'b1 : 1'b0;

always @(posedge mclk) begin
     if ( (PWM_activate_ro_short && PWM_out) || activate_ro_short) en_short <= 1'b1;
     else en_short <= 1'b0;
end

ro_short_stage_top dut_ro_short (en_short,q_short);

always @(posedge q_short or posedge puc_rst) begin
     if (puc_rst) count_ro_short <= 16'h0000;
     else if (count_ro_short == 16'hffff) count_ro_short <= 16'h0000;
     else count_ro_short <= count_ro_short + 1'b1;
end

wire [15:0] count_ro_short_wire;
assign count_ro_short_wire = count_ro_short;


   
// CNTRL2 Register
//-----------------   
reg  [15:0] cntrl2;

wire        cntrl2_wr = reg_wr[CNTRL2];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        cntrl2 <=  16'h0000;
  else if (cntrl2_wr) cntrl2 <=  per_din;
  else if ((PWM_activate_ro_short && PWM_out) || activate_ro_short) cntrl2 <= count_ro_short_wire;
   
// CNTRL3 Register
//-----------------   
reg  [15:0] cntrl3;

wire        cntrl3_wr = reg_wr[CNTRL3];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        cntrl3 <=  16'h0000;
  else if (cntrl3_wr) cntrl3 <=  per_din;


// PWM ro short stage
// ------------------
wire PWM_activate_ro_long;
assign PWM_activate_ro_long = (cntrl3[15]==1'b1) ? 1'b1 : 1'b0;


// stage 11 ro
//-----------------
wire activate_ro_long;
reg en_long;
wire q_long;
reg [15:0] count_ro_long;

assign activate_ro_long = (cntrl3[0]==1'b1) ? 1'b1 : 1'b0;

always @(posedge mclk) begin
     if ((PWM_activate_ro_long && PWM_out) || activate_ro_long) en_long <= 1'b1;
     else en_long <= 1'b0;
end

ro_long_stage_top dut_ro_long (en_long,q_long);

always @(posedge q_long or posedge puc_rst) begin
     if (puc_rst) count_ro_long <= 16'h0000;
     else if (count_ro_long == 16'hffff) count_ro_long <= 16'h0000;
     else count_ro_long <= count_ro_long + 1'b1;
end

wire [15:0] count_ro_long_wire;
assign count_ro_long_wire = count_ro_long;


   
// CNTRL4 Register
//-----------------   
reg  [15:0] cntrl4;

wire        cntrl4_wr = reg_wr[CNTRL4];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        cntrl4 <=  16'h0000;
  else if (cntrl4_wr) cntrl4 <=  per_din;
  else if ((PWM_activate_ro_long && PWM_out) || activate_ro_long) cntrl4 <= count_ro_long_wire;



reg  [15:0] cntrl5, cntrl6;

//============================================================================
// 4) DATA OUTPUT GENERATION
//============================================================================

// Data output mux
wire [15:0] cntrl1_rd  = cntrl1  & {16{reg_rd[CNTRL1]}};
wire [15:0] cntrl2_rd  = cntrl2  & {16{reg_rd[CNTRL2]}};
wire [15:0] cntrl3_rd  = cntrl3  & {16{reg_rd[CNTRL3]}};
wire [15:0] cntrl4_rd  = cntrl4  & {16{reg_rd[CNTRL4]}};
wire [15:0] cntrl5_rd  = cntrl5  & {16{reg_rd[CNTRL5]}};
wire [15:0] cntrl6_rd  = cntrl6  & {16{reg_rd[CNTRL6]}};


wire [15:0] per_dout   =  cntrl1_rd  |
                          cntrl2_rd  |
                          cntrl3_rd  |
                          cntrl4_rd  |
			  cntrl5_rd  |
			  cntrl6_rd;  


// CNTRL5 Register
//-----------------   
wire        cntrl5_wr = reg_wr[CNTRL5];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        cntrl5 <=  16'h0000;
  else if (cntrl5_wr) cntrl5 <=  per_din;
  else if (( (PWM_activate_ro_short && PWM_out) || activate_ro_short) && cntrl2_rd != 16'h0000) cntrl5 <= cntrl2_rd;


// CNTRL6 Register
//-----------------   
wire        cntrl6_wr = reg_wr[CNTRL6];

always @ (posedge mclk or posedge puc_rst)
  if (puc_rst)        cntrl6 <=  16'h0000;
  else if (cntrl6_wr) cntrl6 <=  per_din;
  else if (( (PWM_activate_ro_long && PWM_out) || activate_ro_long) && cntrl4_rd != 16'h0000) cntrl6 <= cntrl4_rd;


endmodule  
