`include "./CPU_Components/rv32_define.v"

`define IF_opcode   IF_Inst[6:0]

`define ID_opcode   ID_Inst[6:0]
`define ID_rs1      ID_Inst[19:15]
`define ID_rs2      ID_Inst[24:20]

`define EXE_opcode  EXE_Inst[6:0]
`define EXE_funct3  EXE_Inst[14:12]
`define EXE_rs1     EXE_Inst[19:15]
`define EXE_rs2     EXE_Inst[24:20]
`define EXE_rd      EXE_Inst[11:7]
`define EXE_funct7  EXE_Inst[31:25]

`define MEM_opcode  MEM_Inst[6:0]
`define MEM_rd      MEM_Inst[11:7]
`define MEM_funct3  MEM_Inst[14:12]

`define WB_opcode  WB_Inst[6:0]
`define WB_rd      WB_Inst[11:7]

module Controller #(parameter memAddrWidth = 16)(
    input clk,
    input rst,

    // Memory control signal interface
    output wire IM_Mem_R,
    output wire [3:0]IM_Mem_W,
    input  IM_Valid,
    output wire DM_Mem_R,
    output wire [3:0]DM_Mem_W,
    input  DM_Valid,

    // branch Comp.
    input E_BrEq,
    input E_BrLT,

    // Branch Prediction
    input BP_taken,
    output wire E_Branch_taken,
    output wire E_En,

    input [(memAddrWidth-1):0] ID_pc,
    input EXE_BP_taken,
    input [(memAddrWidth-1):0] EXE_target_pc,

    // Flush
    output wire Flush,

    // Stall
    output wire Stall_DH,  // Data Hazard (Stall IF/ID/EXE) //TBD
    output wire Stall_MA,  // Memory Access (Stall all)   //TBD

    // inst
    input [31:0] IF_Inst,
    input [31:0] ID_Inst,
    input [31:0] EXE_Inst,
    input [31:0] MEM_Inst,
    input [31:0] WB_Inst,

    // Data Forwarding Mux sel
    output wire [1:0] E_rs1_data_sel, //TBD
    output wire [1:0] E_rs2_data_sel, //TBD

    // WB Data Hazard
    output wire [1:0] W_wb_data_hazard, //TBD
    input [1:0] WBD_wb_data_hazard,  //TBD

    // sel
    output wire [1:0] PCSel,
    output wire [2:0] D_ImmSel,
    output wire W_RegWEn,
    output wire E_BrUn,
    output wire [1:0] E_ASel,
    output wire E_BSel,
    output wire [14:0] E_ALUSel,
    output wire [1:0] W_WBSel,

    output wire Hcf
);  

localparam true = 1, false = 0;

// Control signal - Branch Prediction
assign E_En = (`EXE_opcode == `BRANCH || `EXE_opcode == `JAL || `EXE_opcode == `JALR ); // Branch Tatget Enable
wire E_Branch;
assign E_Branch = (`EXE_opcode == `BRANCH)?(
    (`EXE_funct3 == `EQ)? E_BrEq:
    (`EXE_funct3 == `NE)? ~E_BrEq:
    (`EXE_funct3 == `LT)? E_BrLT:
    (`EXE_funct3 == `GE)? ~E_BrLT:
    (`EXE_funct3 == `LTU)? E_BrLT:
    (`EXE_funct3 == `GEU)? ~E_BrLT:false
):false;

assign E_Branch_taken = (`EXE_opcode == `BRANCH)?E_Branch:
                        (`EXE_opcode == `JALR)?true:
                        (`EXE_opcode == `JAL)?true:false;

// pc predict miss signal
wire Predict_Miss;
wire PC_Miss_Match;
assign PC_Miss_Match = (ID_pc == EXE_target_pc)? 1'b0:1'b1;
assign Predict_Miss = (E_En && ((EXE_BP_taken != E_Branch_taken) || (E_Branch_taken && PC_Miss_Match)))?true:false;

// Control signal - PC
wire BP_En;
assign BP_En = (`IF_opcode == `BRANCH || `IF_opcode == `JAL || `IF_opcode == `JALR ); // Branch Predict Enable

assign PCSel = (Predict_Miss)?((E_Branch_taken)? `EXE_T_PC:`EXE_PC_PLUS_4):
                            ((BP_taken & BP_En)? `IF_P_T_PC:`IF_PC_PLUS_4);

// Control signal - Branch comparator
assign E_BrUn = (EXE_Inst[13] == 1)?true:false;

// Control signal - Immediate generator
assign D_ImmSel = (`ID_opcode == `OP_IMM)? `I_type:
                  (`ID_opcode == `LOAD)? `I_type:
                  (`ID_opcode == `STORE)? `S_type:
                  (`ID_opcode == `BRANCH)? `B_type:
                  (`ID_opcode == `JALR)? `I_type:
                  (`ID_opcode == `JAL)? `J_type:
                  (`ID_opcode == `LUI)? `U_type:
                  (`ID_opcode == `AUIPC)? `U_type:3'd0;

// Control signal - Scalar ALU
assign E_ASel = (`EXE_opcode == `BRANCH)? 2'd1:
                (`EXE_opcode == `JAL)? 2'd1:
                (`EXE_opcode == `AUIPC)? 2'd1:
                (`EXE_opcode == `LUI)? 2'd2:2'd0;

assign E_BSel = (`EXE_opcode == `OP)? 1'b0:
                (`EXE_opcode == `OP_IMM)? 1'b1:1'b1;

assign E_ALUSel = (`EXE_opcode == `OP)? {`EXE_funct7, 5'b11111, `EXE_funct3}:
                  (`EXE_opcode == `OP_IMM)? (
                    (`EXE_funct3 == 3'b001 || `EXE_funct3 == 3'b101)?(
                        {`EXE_funct7, 5'b11111, `EXE_funct3}
                    ):{7'd0, 5'b11111, `EXE_funct3}
                  ):{7'd0, 5'b11111, 3'd0};

// Memory Cache Access FSM
localparam sNormal = 2'b00,
           sWait = 2'b01,
           sIM_Done = 2'b10,
           sDM_Done = 2'b11;

// cache hand-shake FSM
reg [1:0] Mem_state;
wire [1:0] Mem_state_next;
wire [1:0] sNormal_Wait_next;
wire [1:0] sIM_Done_next;
wire [1:0] sDM_Done_next;

// wire
wire IM_to_Read;
wire IM_to_Write;
wire DM_to_Read;
wire DM_to_Write;

wire IM_Done;
wire DM_Done;

// signals
assign IM_to_Read = true;
assign IM_to_Write = false;
assign DM_to_Read = (`MEM_opcode == `LOAD)?true:false;
assign DM_to_Write = (`MEM_opcode == `STORE)?true:false;

assign IM_Done = (~IM_to_Read & ~IM_to_Write) | (IM_Valid);
assign DM_Done = (~DM_to_Read & ~DM_to_Write) | (DM_Valid);

// Memory Access State
assign sNormal_Wait_next = (IM_Done & DM_Done)?sNormal:
                      (IM_Done)?sIM_Done:
                      (DM_Done)?sDM_Done:sWait;
assign sIM_Done_next = (DM_Done)?sNormal:sIM_Done;
assign sDM_Done_next = (IM_Done)?sNormal:sDM_Done;
assign Mem_state_next = (Mem_state == sNormal)?sNormal_Wait_next:
                        (Mem_state == sWait)?sNormal_Wait_next:
                        (Mem_state == sIM_Done)?sIM_Done_next:
                        (Mem_state == sDM_Done)?sDM_Done_next:sNormal;

/* sequential circuit */
always@(posedge clk or posedge rst)begin
  if(rst)begin
    Mem_state <= sNormal;
  end
  else begin
    Mem_state <= Mem_state_next;
  end
end

// Stall -- stall for Memory Access (All Stalled, related to FSM)
wire stall_ma_1, stall_ma_2, stall_ma_3, stall_ma_4;
assign stall_ma_1 = (Mem_state == sNormal && (~IM_Done || ~DM_Done))?true:false;
assign stall_ma_2 = (Mem_state == sWait && (~IM_Done || ~DM_Done))?true:false;
assign stall_ma_3 = (Mem_state == sDM_Done && (~IM_Done))?true:false;
assign stall_ma_4 = (Mem_state == sIM_Done && (~DM_Done))?true:false;
assign Stall_MA = (stall_ma_1 | stall_ma_2 | stall_ma_3| stall_ma_4);

// Control signal - Data Memory
wire [3:0] W_mask;
assign W_mask = (`MEM_funct3 == `Byte)?  4'b0001:
                (`MEM_funct3 == `UByte)? 4'b0001:
                (`MEM_funct3 == `Half)?  4'b0011:
                (`MEM_funct3 == `UHalf)? 4'b0011:
                (`MEM_funct3 == `Word)?  4'b1111:4'd0;

assign DM_Mem_R = (DM_to_Read && Mem_state!=sDM_Done)?true:false;
assign DM_Mem_W = (DM_to_Write && Mem_state!=sDM_Done)?W_mask:4'd0;

// Control signal - Inst Memory
assign IM_Mem_R = (Mem_state!=sIM_Done)?true:false; // always true
assign IM_Mem_W = 4'd0; // always false

// Control signal - Scalar Write Back
wire W_reg_en;
assign W_reg_en = (`WB_opcode == `OP)? true:
                  (`WB_opcode == `OP_IMM)? true:
                  (`WB_opcode == `LOAD)? true:
                  (`WB_opcode == `JALR)? true:
                  (`WB_opcode == `JAL)? true:
                  (`WB_opcode == `AUIPC)? true:
                  (`WB_opcode == `LUI)? true:false;

assign W_RegWEn = (Stall_MA)?false:W_reg_en;

assign W_WBSel = (`WB_opcode == `LOAD)? `LD_DATA:
                 (`WB_opcode == `JALR)? `PC_PLUS_4:
                 (`WB_opcode == `JAL)? `PC_PLUS_4:`ALUOUT;

// Control signal - Others
assign Hcf = (`WB_opcode == `HCF)?true:false;

/****************** Data Hazard ******************/

// Use rs in ID stage 
wire is_D_use_rs1;
wire is_D_use_rs2;
assign is_D_use_rs1 = (`ID_opcode == `OP)? true:
                      (`ID_opcode == `OP_IMM)? true:
                      (`ID_opcode == `STORE)? true:
                      (`ID_opcode == `LOAD)? true:
                      (`ID_opcode == `BRANCH)? true:
                      (`ID_opcode == `JALR)? true:false;

assign is_D_use_rs2 = (`ID_opcode == `OP)? true:
                      (`ID_opcode == `STORE)? true:
                      (`ID_opcode == `BRANCH)? true:false;

// Use rs in EXE stage 
wire is_E_use_rs1;
wire is_E_use_rs2;
assign is_E_use_rs1 = (`EXE_opcode == `OP)? true:
                      (`EXE_opcode == `OP_IMM)? true:
                      (`EXE_opcode == `STORE)? true:
                      (`EXE_opcode == `LOAD)? true:
                      (`EXE_opcode == `BRANCH)? true:
                      (`EXE_opcode == `JALR)? true:false;

assign is_E_use_rs2 = (`EXE_opcode == `OP)? true:
                      (`EXE_opcode == `STORE)? true:
                      (`EXE_opcode == `BRANCH)? true:false;

// Use rd in MEM stage 
wire is_M_use_rd;
assign is_M_use_rd = (`MEM_opcode == `OP)? true:
                      (`MEM_opcode == `OP_IMM)? true:
                      (`MEM_opcode == `LOAD)? true:      // Don't care, the reslut will be flushed
                      (`MEM_opcode == `JALR)? true:
                      (`MEM_opcode == `JAL)? true:
                      (`MEM_opcode == `AUIPC)? true:
                      (`MEM_opcode == `LUI)? true:false;
// Use rd in WB stage 
wire is_W_use_rd;
assign is_W_use_rd = W_reg_en;

// Hazard condition (rd, rs overlap)
wire is_D_rs1_E_rd_overlap_in_load;
wire is_D_rs2_E_rd_overlap_in_load;

wire is_E_rs1_M_rd_overlap;
wire is_E_rs2_M_rd_overlap;

wire is_E_rs1_W_rd_overlap;
wire is_E_rs2_W_rd_overlap;

wire is_D_rs1_W_rd_overlap;
wire is_D_rs2_W_rd_overlap;

assign  is_D_rs1_E_rd_overlap_in_load = (is_D_use_rs1 && (`EXE_opcode == `LOAD) && (`ID_rs1 == `EXE_rd) && (`EXE_rd != 5'd0))?true:false;
assign  is_D_rs2_E_rd_overlap_in_load = (is_D_use_rs2 && (`EXE_opcode == `LOAD) && (`ID_rs2 == `EXE_rd) && (`EXE_rd != 5'd0))?true:false;

assign  is_E_rs1_M_rd_overlap = (is_E_use_rs1 && is_M_use_rd && (`EXE_rs1 == `MEM_rd) && (`MEM_rd != 5'd0))?true:false;
assign  is_E_rs2_M_rd_overlap = (is_E_use_rs2 && is_M_use_rd && (`EXE_rs2 == `MEM_rd) && (`MEM_rd != 5'd0))?true:false;

assign  is_E_rs1_W_rd_overlap = (is_E_use_rs1 && is_W_use_rd && (`EXE_rs1 == `WB_rd) && (`WB_rd != 5'd0))?true:false;
assign  is_E_rs2_W_rd_overlap = (is_E_use_rs2 && is_W_use_rd && (`EXE_rs2 == `WB_rd) && (`WB_rd != 5'd0))?true:false;

assign  is_D_rs1_W_rd_overlap = (is_D_use_rs1 && is_W_use_rd && (`ID_rs1 == `WB_rd) && (`WB_rd != 5'd0))?true:false;
assign  is_D_rs2_W_rd_overlap = (is_D_use_rs2 && is_W_use_rd && (`ID_rs2 == `WB_rd) && (`WB_rd != 5'd0))?true:false;

// WB Hazard (rs2, rs1) - to stage Reg
assign  W_wb_data_hazard = {is_D_rs2_W_rd_overlap,is_D_rs1_W_rd_overlap};

// Stall -- stall for Data Hazard (stall PC, stage ID. Flush stage EXE to make a Bubble early)
assign  Stall_DH = (is_D_rs1_E_rd_overlap_in_load|is_D_rs2_E_rd_overlap_in_load); 

// Control signal - Flush
//-- Flush for Predict_Miss (Flush stage ID, stage EXE, make 2 Bubbles)
assign Flush = Predict_Miss;

// Control signal - Data Forwarding
//-- rs1 - Select the newest data
assign E_rs1_data_sel = (is_E_rs1_M_rd_overlap)?`MEM_STAGE:
                        (is_E_rs1_W_rd_overlap)?`WB_STAGE:
                        (WBD_wb_data_hazard[0])?`WBD_STAGE:`EXE_STAGE;
                        
//-- rs2 - Select the newest data
assign E_rs2_data_sel = (is_E_rs2_M_rd_overlap)?`MEM_STAGE:
                        (is_E_rs2_W_rd_overlap)?`WB_STAGE:
                        (WBD_wb_data_hazard[1])?`WBD_STAGE:`EXE_STAGE;

  /****************** Data Hazard End******************/

endmodule
