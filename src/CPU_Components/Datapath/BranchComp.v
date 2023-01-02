module BranchComp (
    input BrUn,
    input [31:0] src1,
    input [31:0] src2,
    output wire BrEq,
    output wire BrLT
);

wire lt_wire;
wire ltu_wire;

assign lt_wire   = (src1[31] > src2[31]) | ((src1[31]==src2[31]) & (src1 < src2));
assign ltu_wire  = (src1 < src2);

assign BrEq   = {31'd0,(src1 == src2)};
assign BrLT   = (BrUn)? ltu_wire:lt_wire;

endmodule