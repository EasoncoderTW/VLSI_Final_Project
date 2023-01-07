module BranchComp (
    input BrUn,
    input [31:0] src1,
    input [31:0] src2,
    output wire BrEq,
    output wire BrLT
);

wire lt_wire;
wire ltu_wire;

assign ltu_wire  = (src1 < src2)? 1'b1: 1'b0;
assign lt_wire   = ((src1[31] ^ src2[31])==1'b0)? ltu_wire: ~ltu_wire;

assign BrEq   = (src1 == src2)? 1'b1: 1'b0;
assign BrLT   = (BrUn == 1'b1)? ltu_wire:lt_wire;

endmodule
