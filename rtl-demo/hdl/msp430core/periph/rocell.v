//----------------------------------------------------------------------------
//
// *File Name: rocell.v 
// 
// *Module Description:
//                       ro_short_stage module
//                       ro_long_stage module
//                       ro_short_stage_top module
//                       ro_long_stage_top module
//
//
// *Author(s):
//              - Zhenyuan Charlotte Liu,    zliu12@wpi.edu
//
//----------------------------------------------------------------------------


`timescale 1ns / 1ps

module ro_short_stage
  (input wire en,
   output wire q);
   parameter STAGES = 5;
   (*keep = "true" *) wire [0:(STAGES-2)] ni;
   (*keep = "true" *) wire 	       nandout /* synthesis keep = 1 */;
   (*keep = "true" *) wire [0:(STAGES-2)] no      /* synthesis keep = 1 */;

   customNand nc(en, no[(STAGES-2)], nandout);
   (*keep = "true"*) customInv  ic[0:(STAGES-2)] (ni, no);

   assign #2.5 ni[0]            = nandout;	
   assign ni[1:(STAGES-2)] = no[0:(STAGES-3)];
   assign q                = no[(STAGES-3)];
endmodule

module ro_long_stage
  (input wire en,
   output wire q);
   parameter STAGES = 11;
   (*keep = "true" *) wire [0:(STAGES-2)] ni;
   (*keep = "true" *) wire             nandout /* synthesis keep = 1 */;
   (*keep = "true" *) wire [0:(STAGES-2)] no      /* synthesis keep = 1 */;

   customNand nc(en, no[(STAGES-2)], nandout);
   (*keep = "true"*) customInv  ic[0:(STAGES-2)] (ni, no);

   assign #2.5 ni[0]            = nandout;
   assign ni[1:(STAGES-2)] = no[0:(STAGES-3)];
   assign q                = no[(STAGES-3)];
endmodule


module ro_short_stage_top(input wire en,
	      output wire q);

   (*keep = "true"*) ro_short_stage myro_short(en, q);

endmodule


module ro_long_stage_top(input wire en,
              output wire q);

   (*keep = "true"*) ro_long_stage myro_long(en, q);

endmodule

