`include "./CPU_Components/rv32_define.v"

module ALU (
    input [31:0] src1,
    input [31:0] src2,
    input [14:0] ALUSel,
    output wire [31:0] out
);

wire [31:0] add_wire;
wire [31:0] sub_wire;
wire [31:0] sll_wire;
wire [31:0] slt_wire;
wire [31:0] sltu_wire;
wire [31:0] xor_wire;
wire [31:0] srl_wire;
wire [31:0] sra_wire;
wire [31:0] or_wire;
wire [31:0] and_wire;

assign add_wire   = src1 +  src2;
assign sub_wire   = src1 -  src2;
assign sll_wire   = src1 << src2[4:0];
assign slt_wire   = {31'd0,(src1[31] > src2[31]) | ((src1[31]==src2[31]) & (src1 < src2))};
assign sltu_wire  = {31'd0,(src1 < src2)};
assign xor_wire   = src1^src2;
assign srl_wire   = src1 >> src2[4:0];
assign sra_wire   = {{32{src1[31]}},src1} >> src2[4:0];
assign or_wire    = src1 | src2;
assign and_wire   = src1 & src2;

assign out = (ALUSel == `ADD)? add_wire:
             (ALUSel == `SLL)? sll_wire:
             (ALUSel == `SLT)? slt_wire:
             (ALUSel == `SLTU)? sltu_wire:
             (ALUSel == `XOR)? xor_wire:
             (ALUSel == `SRL)? srl_wire:
             (ALUSel == `OR)? or_wire:
             (ALUSel == `AND)? and_wire:
             (ALUSel == `SUB)? sub_wire:
             (ALUSel == `SRA)? sra_wire:32'd0;

endmodule
