`include "./Cache_Components/Cache_define_macro.v"
/*
MUX :
if sel == 1      then A flows out.
else if sel == 0 then B flows out.
*/

module Data16Mux(sel, A, B, out);
input sel; //Select Line
input [15:0] A, B;
output [15:0] out;

assign out = sel ? A : B;

endmodule