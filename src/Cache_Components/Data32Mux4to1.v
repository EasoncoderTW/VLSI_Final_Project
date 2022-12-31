`include "./Cache_Components/Cache_define_macro.v"
module Data32Mux4to1(sel, A, B, C, D, out);
input [1:0] sel; //Select Line
input [`WORD-1:0] A, B, C, D;
output reg [`WORD-1:0] out;

always@(*)begin
    case(sel)
    2'b00: out = A;
    2'b01: out = B;
    2'b10: out = C;
    2'b11: out = D;
    endcase
end

endmodule