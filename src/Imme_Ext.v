`include "rv32_define.v"

module Imm_Ext (
    input [31:0] inst,
    output reg [31:0] imm_ext_out
);

/*
    inst[6:2]
    R type : 01100 ]

    I type : 00100 / 00000 / 11001       
    S type : 01000              
    B type : 11000              
    U type : 00101/ 01101              
    J type : 11011              
*/



wire [31:0]imm_I_tpye;
wire [31:0]imm_S_tpye;
wire [31:0]imm_B_tpye;
wire [31:0]imm_U_tpye;
wire [31:0]imm_J_tpye;

assign imm_I_tpye = {{20{inst[31]}}, inst[31: 20]};
assign imm_S_tpye = {{20{inst[31]}}, inst[31: 25], inst[11: 7]};
assign imm_B_tpye = {{20{inst[31]}}, inst[7],inst[30: 25],inst[11: 8],1'b0};
assign imm_U_tpye = {inst[31:12], 12'd0};
assign imm_J_tpye = {{12{inst[31]}}, inst[19:12], inst[20], inst[31: 21], 1'b0};

always @(*) begin
    case (inst[6:2])
        `I_type_inst_1  :   imm_ext_out = imm_I_tpye;
        `I_type_inst_2  :   imm_ext_out = imm_I_tpye;
        `I_type_inst_3  :   imm_ext_out = imm_I_tpye;
        `S_type_inst    :   imm_ext_out = imm_S_tpye;
        `B_type_inst    :   imm_ext_out = imm_B_tpye;
        `U_type_inst_1  :   imm_ext_out = imm_U_tpye;
        `U_type_inst_2  :   imm_ext_out = imm_U_tpye;
        `J_type_inst    :   imm_ext_out = imm_J_tpye;
        default: imm_ext_out = 32'd0;
    endcase
end
    
endmodule
