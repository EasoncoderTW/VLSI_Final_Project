// opcode
`define lui_    5'b01101
`define auipc_  5'b00101
`define load_   5'b00000
`define store_  5'b01000
`define jal_    5'b11011
`define jalr_   5'b11001
`define branch_   5'b11000
`define I_type_   5'b00100
`define R_type_   5'b01100
`define HCF    5'b00010  // new halt for cpu

//store func3
`define sb_ 3'b000
`define sh_ 3'b001
`define sw_ 3'b010

// load func3
`define lb_     3'b000
`define lh_     3'b001
`define lw_     3'b010
`define lbu_    3'b100
`define lhu_    3'b101

// alu fun3
`define add_sub 3'b000
`define sll_    3'b001
`define slt_    3'b010
`define sltu_   3'b011
`define xor_    3'b100
`define srl_sra 3'b101
`define or_     3'b110
`define and_    3'b111

`define beq_    3'b000
`define bne_    3'b001
`define blt_    3'b100
`define bge_    3'b101
`define bltu_   3'b110
`define bgeu_   3'b111

// Imm ext opcode
`define I_type_inst_1   5'b00100
`define I_type_inst_2   5'b00000
`define I_type_inst_3   5'b11001
`define S_type_inst     5'b01000
`define B_type_inst     5'b11000
`define U_type_inst_1   5'b00101
`define U_type_inst_2   5'b01101
`define J_type_inst     5'b11011
