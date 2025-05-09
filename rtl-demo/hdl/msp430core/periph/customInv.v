//----------------------------------------------------------------------------
//
// *File Name: rocell.v 
// 
// *Module Description:
//                       customInv module
//
//
// *Author(s):
//              - Zhenyuan Charlotte Liu,    zliu12@wpi.edu
//
//----------------------------------------------------------------------------

`timescale 1ns / 1ps

module customInv
  (input wire  a,
  output wire q 

   );

assign #0.1 q = ~a;

//   (* keep = "true" *) assign #0.1 q = ~a;
endmodule // inv_cell
