`include "rv32_define.v"

module ImmGen (
    input [24:0] inst_31_7,
    input [2:0] ImmSel,
    output wire [31:0] imm
);

wire [31:0]imm_I_tpye;
wire [31:0]imm_S_tpye;
wire [31:0]imm_B_tpye;
wire [31:0]imm_U_tpye;
wire [31:0]imm_J_tpye;
wire [31:0]inst_shift;

assign inst_shift = {inst_31_7,7'd0};

assign imm_I_tpye = {{20{inst_shift[31]}}, inst_shift[31: 20]};
assign imm_S_tpye = {{20{inst_shift[31]}}, inst_shift[31: 25], inst_shift[11: 7]};
assign imm_B_tpye = {{20{inst_shift[31]}}, inst_shift[7],inst_shift[30: 25],inst_shift[11: 8],1'b0};
assign imm_U_tpye = {inst_shift[31:12], 12'd0};
assign imm_J_tpye = {{12{inst_shift[31]}}, inst_shift[19:12], inst_shift[20], inst_shift[31: 21], 1'b0};


assign imm = (ImmSel == `I_type)? imm_I_tpye:
             (ImmSel == `B_type)? imm_B_tpye:
             (ImmSel == `S_type)? imm_S_tpye:
             (ImmSel == `U_type)? imm_U_tpye:
             (ImmSel == `J_type)? imm_J_tpye:32'd0;
    
endmodule
