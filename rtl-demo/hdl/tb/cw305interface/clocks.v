/* 
ChipWhisperer Artix Target - Select input clocks and drive output clocks.

Copyright (c) 2020, NewAE Technology Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted without restriction. Note that modules within
the project may have additional restrictions, please carefully inspect
additional licenses.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies,
either expressed or implied, of NewAE Technology Inc.
*/


`default_nettype none
`timescale 1ns / 1ns

module clocks (
    input  wire         usb_clk,
    output wire         usb_clk_buf,
    input  wire         I_j16_sel,
    input  wire         I_k16_sel,
    input  wire [4:0]   I_clock_reg,
    input  wire         I_cw_clkin,
    input  wire         I_pll_clk1,

    output wire         O_cw_clkout,
    output wire         O_cryptoclk
);

    wire cclk_src_is_ext;
    wire cclk_output_ext;              
    wire usb_clk_bufg;

    // Select crypto clock based on registers + DIP switches
    assign cclk_src_is_ext = (I_clock_reg[2:0] == 3'b001) ? 0 : //Registers = PLL1
                             (I_clock_reg[2:0] == 3'b101) ? 1 : //Registers = 20pin
                             ((I_clock_reg[0] == 1'b0) && (I_j16_sel == 1'b1)) ? 1: //DIP = 20pin
                             0; //Default PLL1

    assign cclk_output_ext = ((I_clock_reg[0] == 1'b1) && (I_clock_reg[4:3] == 2'b00)) ? 0 : //Registers = off
                             ((I_clock_reg[0] == 1'b1) && (I_clock_reg[4:3] == 2'b01)) ? 1 : //Registers = on
                             ((I_clock_reg[0] == 1'b0) && (I_k16_sel == 1'b1)) ? 1 : //DIP = on
                             0; //Default off

    assign O_cryptoclk = cclk_src_is_ext? I_cw_clkin : I_pll_clk1;
    assign O_cw_clkout = cclk_output_ext? O_cryptoclk : 1'b0;
    assign usb_clk_bufg = usb_clk;
    assign usb_clk_buf = usb_clk_bufg;

endmodule

`default_nettype wire
