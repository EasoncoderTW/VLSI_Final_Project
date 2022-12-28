`include "rv32_define.v"

module ALU (
    input [4:0] opcode,
    input [2:0] func3,
    input  func7,
    input [31:0] operand1,
    input [31:0] operand2,
    output reg [31:0] alu_out
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
wire [31:0] beq_wire;
wire [31:0] bne_wire;
wire [31:0] blt_wire;
wire [31:0] bge_wire;
wire [31:0] bltu_wire;
wire [31:0] bgeu_wire;


assign add_wire   = operand1 +  operand2;
assign sub_wire   = operand1 -  operand2;
assign sll_wire   = operand1 << operand2[4:0];
assign slt_wire   = {31'd0,(operand1[31] > operand2[31]) | ((operand1[31]==operand2[31]) & (operand1 < operand2))};
assign sltu_wire  = {31'd0,(operand1 < operand2)};
assign xor_wire   = operand1^operand2;
assign srl_wire   = operand1 >> operand2[4:0];
assign sra_wire   = {{32{operand1[31]}},operand1} >> operand2[4:0];
assign or_wire    = operand1 | operand2;
assign and_wire   = operand1 & operand2;
assign beq_wire   = {31'd0,(operand1 == operand2)};
assign bne_wire   = {31'd0,~beq_wire[0]};
assign blt_wire   = slt_wire;
assign bge_wire   = {31'd0,~slt_wire[0]};
assign bltu_wire  = sltu_wire;
assign bgeu_wire  = {31'd0,~sltu_wire[0]};


always @(*) begin
    case(opcode)
        `lui_:       alu_out = operand2;
        `auipc_:     alu_out = add_wire;
        `load_:      alu_out = add_wire;
        `store_:     alu_out = add_wire;
        `jal_:       alu_out = operand1 + 32'd4;
        `jalr_:      alu_out = operand1 + 32'd4;
        `branch_:begin
            case (func3)
                `beq_    :  alu_out = beq_wire;
                `bne_    :  alu_out = bne_wire;
                `blt_    :  alu_out = blt_wire;
                `bge_    :  alu_out = bge_wire;
                `bltu_   :  alu_out = bltu_wire;
                `bgeu_   :  alu_out = bgeu_wire;
                default  :  alu_out = 32'd0;
            endcase
        end
        `I_type_:begin
            case (func3)
                `add_sub:    alu_out = add_wire;
                `sll_:       alu_out = sll_wire;
                `slt_:       alu_out = slt_wire;
                `sltu_:      alu_out = sltu_wire;
                `xor_:       alu_out = xor_wire;
                `srl_sra:    alu_out = (func7)? sra_wire:srl_wire;
                `or_:        alu_out = or_wire;
                `and_:       alu_out = and_wire;
            endcase
        end    
        `R_type_:begin
            case (func3)
                `add_sub:    alu_out = (func7)? sub_wire:add_wire;
                `sll_:       alu_out = sll_wire;
                `slt_:       alu_out = slt_wire;
                `sltu_:      alu_out = sltu_wire;
                `xor_:       alu_out = xor_wire;
                `srl_sra:    alu_out = (func7)? sra_wire:srl_wire;
                `or_:        alu_out = or_wire;
                `and_:       alu_out = and_wire; 
            endcase
        end
        default: alu_out = 32'd0;
    endcase
end

    
endmodule
