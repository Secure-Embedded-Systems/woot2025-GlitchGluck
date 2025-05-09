//----------------------------------------------------------------------------
//
// *File Name: rocell.v 
// 
// *Module Description:
//                       customNand module
//
//
// *Author(s):
//              - Zhenyuan Charlotte Liu,    zliu12@wpi.edu
//
//----------------------------------------------------------------------------


`timescale 1ns / 1ps

module customNand
  (
   input wire  a,
   input wire  b,
   output wire q
   );
   assign q = ~(a & b);
endmodule

