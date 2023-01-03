// opcode
`define LOAD    7'b0000011
`define STORE   7'b0100011
`define BRANCH  7'b1100011
`define JALR    7'b1100111
`define JAL     7'b1101111
`define OP_IMM  7'b0010011
`define OP      7'b0110011
`define AUIPC   7'b0010111
`define LUI     7'b0110111
`define HCF     7'b0001011 

// condition
`define EQ    3'b000
`define NE    3'b001
`define LT    3'b100
`define GE    3'b101
`define LTU   3'b110
`define GEU   3'b111

// inst_type 
`define R_type 3'd0
`define I_type 3'd1
`define S_type 3'd2
`define B_type 3'd3
`define J_type 3'd4
`define U_type 3'd5

// alu_op_map
`define ADD    15'b000000011111000
`define SLL    15'b000000011111001
`define SLT    15'b000000011111010
`define SLTU   15'b000000011111011
`define XOR    15'b000000011111100
`define SRL    15'b000000011111101
`define OR     15'b000000011111110
`define AND    15'b000000011111111
`define SUB    15'b010000011111000
`define SRA    15'b010000011111101

// pc_sel_map
`define IF_PC_PLUS_4   2'd0
`define IF_P_T_PC      2'd1
`define EXE_PC_PLUS_4  2'd2
`define EXE_T_PC       2'd3

// wb_sel_map
`define PC_PLUS_4   2'd0
`define ALUOUT      2'd1
`define LD_DATA     2'd2

// forwarding_sel_map
`define EXE_STAGE   2'd0
`define MEM_STAGE   2'd1
`define WB_STAGE    2'd2
`define WBD_STAGE   2'd3

// wide
`define Byte     3'b000
`define Half     3'b001
`define Word     3'b010
`define UByte    3'b100
`define UHalf    3'b101
