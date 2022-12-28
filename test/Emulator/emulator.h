#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>

#ifndef EMULATOR_H__
#define EMULATOR_H__

// 64 KB
#define MEM_BYTES 0x10000
#define TEXT_OFFSET 0
#define DATA_OFFSET 0x8000

#define MAX_LABEL_COUNT 128
#define MAX_LABEL_LEN 32
#define MAX_SRC_LEN (1024 * 1024)

typedef struct
{
	char *src;
	int offset;
} source;

typedef enum
{
	UNIMPL = 0,
	ADD,
	ADDI,
	AND,
	ANDI,
	AUIPC,
	BEQ,
	BGE,
	BGEU,
	BLT,
	BLTU,
	BNE,
	JAL,
	JALR,
	LB,
	LBU,
	LH,
	LHU,
	LUI,
	LW,
	OR,
	ORI,
	SB,
	SH,
	SLL,
	SLLI,
	SLT,
	SLTI,
	SLTIU,
	SLTU,
	SRA,
	SRAI,
	SRL,
	SRLI,
	SUB,
	SW,
	XOR,
	XORI,
	// add bit manipulation -----------
	ANDN,
	CLMUL,
	CLMULH,
	CLMULR,
	CLZ,
	CPOP,
	CTZ,
	MAX,
	MAXU,
	MIN,
	MINU,
	ORCB,
	ORN,
	REV8,
	ROL,
	ROR,
	RORI,
	BCLR,
	BCLRI,
	BEXT,
	BEXTI,
	BINV,
	BINVI,
	BSET,
	BSETI,
	SEXTB,
	SEXTH,
	SH1ADD,
	SH2ADD,
	SH3ADD,
	XNOR,
	ZEXTH,
	// end add bit manipulation -------
	HCF
} instr_type;

typedef enum
{
	OPTYPE_NONE, // more like "don't care"
	OPTYPE_REG,
	OPTYPE_IMM,
	OPTYPE_LABEL,
} operand_type;
typedef struct
{
	operand_type type = OPTYPE_NONE;
	char label[MAX_LABEL_LEN];
	int reg;
	uint32_t imm;

} operand;
typedef struct
{
	instr_type op;
	operand a1;
	operand a2;
	operand a3;
	char *psrc = NULL;
	int orig_line = -1;
	bool breakpoint = false;
} instr;

typedef struct
{
	char label[MAX_LABEL_LEN];
	int loc = -1;
} label_loc;

uint32_t mem_read(uint8_t *, uint32_t, instr_type);

#endif