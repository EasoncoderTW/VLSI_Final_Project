`include "./Cache.v"

`include "./CPU_Components/Controller.v"
`include "./CPU_Components/rv32_define.v"


`include "./CPU_Components/Datapath/ALU.v"
`include "./CPU_Components/Datapath/ImmGen.v"
`include "./CPU_Components/Datapath/BranchComp.v"
`include "./CPU_Components/Datapath/RegFile.v"
`include "./CPU_Components/Datapath/PC.v"
`include "./CPU_Components/Datapath/LD_Filter.v"

`include "./CPU_Components/StageRegister/Reg_ID.v"
`include "./CPU_Components/StageRegister/Reg_EXE.v"
`include "./CPU_Components/StageRegister/Reg_MEM.v"
`include "./CPU_Components/StageRegister/Reg_WB.v"
`include "./CPU_Components/StageRegister/Reg_WB_data.v"

module CPU #(parameter memAddrWidth = 15)(
    input clk,
    input rst,
    // Inst Cache - AXI Lite 4 master IO
        // read port
    output  [31:0]       Inst_Cahe_readAddr_addr,
    output  wire         Inst_Cahe_readAddr_valid,
    input                Inst_Cahe_readAddr_ready,
    input   [127:0]      Inst_Cahe_readData_data,
    input                Inst_Cahe_readData_valid,
    output  wire         Inst_Cahe_readData_ready,
        // write port
    output  [31:0]       Inst_Cahe_writeAddr_addr,
    output  wire         Inst_Cahe_writeAddr_valid,
    input                Inst_Cahe_writeAddr_ready,
    output  [127:0]      Inst_Cahe_writeData_data,
    output  [15:0]       Inst_Cahe_writeData_strb,
    output  wire         Inst_Cahe_writeData_valid,
    input                Inst_Cahe_writeData_ready,
    input   [31:0]       Inst_Cahe_writeResp_msg,
    input                Inst_Cahe_writeResp_valid,
    output  wire         Inst_Cahe_writeResp_ready,

    // Data Cache - AXI Lite 4 master IO
        // read port
    output  [31:0]       Data_Cahe_readAddr_addr,
    output  wire         Data_Cahe_readAddr_valid,
    input                Data_Cahe_readAddr_ready,
    input   [127:0]      Data_Cahe_readData_data,
    input                Data_Cahe_readData_valid,
    output  wire         Data_Cahe_readData_ready,
        // write port
    output  [31:0]       Data_Cahe_writeAddr_addr,
    output  wire         Data_Cahe_writeAddr_valid,
    input                Data_Cahe_writeAddr_ready,
    output  [127:0]      Data_Cahe_writeData_data,
    output  [15:0]       Data_Cahe_writeData_strb,
    output  wire         Data_Cahe_writeData_valid,
    input                Data_Cahe_writeData_ready,
    input   [31:0]       Data_Cahe_writeResp_msg,
    input                Data_Cahe_writeResp_valid,
    output  wire         Data_Cahe_writeResp_ready,
    // halt
    output wire Hcf
);

localparam ture = 1'b1, false = 1'b0;

wire Stall_DH, Stall_MA;
wire [1:0]PCSel;
wire [memAddrWidth-1:0] EXE_Target_pc, EXE_pc, pc, ID_pc, MEM_pc;
wire IM_Mem_R, DM_Mem_R, IM_Valid, DM_Valid;
wire [3:0]IM_Mem_W, DM_Mem_W;
wire [31:0]im_cache_read_data, dm_cache_read_data;
wire E_BrEq, E_BrLT, ID_BP_taken, E_Branch_taken, E_En, EXE_BP_taken;
wire Flush;
wire [31:0] ID_Inst, EXE_Inst, MEM_Inst, WB_Inst;

wire [1:0] E_rs1_data_sel, E_rs2_data_sel, W_wb_data_hazard, WBD_wb_data_hazard;

wire [2:0] D_ImmSel;
wire W_RegWEn;
wire E_BrUn;
wire [1:0] E_ASel;
wire E_BSel;
wire [14:0] E_ALUSel;
wire [1:0] W_WBSel;
wire [memAddrWidth-1:0] WB_pc_plus4;
wire [31:0] ID_rs1_data, ID_rs2_data, wb_data;
wire [31:0] EXE_rs1_data, EXE_rs2_data;
wire [31:0] MEM_alu_out, MEM_rs2_data;
wire [31:0] WB_ld_data, WB_alu_out, WB_ld_data_f;
wire [31:0] WBD_wb_data, ld_data;
wire [31:0] imm, EXE_imm;

//PC
PC #(.addrWidth(memAddrWidth)) PC_ (
    .clk(clk),
    .rst(rst),
    .Hcf(Hcf),
    .Stall(Stall_DH|Stall_MA),
    .PCSel(PCSel),
    .Predict_Target_pc({memAddrWidth{1'b0}}),
    .EXE_Target_pc(EXE_Target_pc),
    .EXE_pc(EXE_pc),
    .pc(pc)
);
// Insruction Memory Cache
Cache inst_cache(
    .clk(clk),
    .rst(rst),
    // Controller IO
    .w_en(IM_Mem_W),
    .r_en(IM_Mem_R),
    .address(pc),
    .write_data(32'd0), // always zero
    .read_data(im_cache_read_data),
    .valid(IM_Valid),
    // AXI Lite 4 Bus master IO
    .readAddr_addr(Inst_Cahe_readAddr_addr),
    .readAddr_valid(Inst_Cahe_readAddr_valid),
    .readAddr_ready(Inst_Cahe_readAddr_ready),
    .readData_data(Inst_Cahe_readData_data),
    .readData_valid(Inst_Cahe_readData_valid),
    .readData_ready(Inst_Cahe_readData_ready),
    .writeAddr_addr(Inst_Cahe_writeAddr_addr),
    .writeAddr_valid(Inst_Cahe_writeAddr_valid),
    .writeAddr_ready(Inst_Cahe_writeAddr_ready),
    .writeData_data(Inst_Cahe_writeData_data),
    .writeData_strb(Inst_Cahe_writeData_strb),
    .writeData_valid(Inst_Cahe_writeData_valid),
    .writeData_ready(Inst_Cahe_writeData_ready),
    .writeResp_msg(Inst_Cahe_writeResp_msg),
    .writeResp_valid(Inst_Cahe_writeResp_valid),
    .writeResp_ready(Inst_Cahe_writeResp_ready)
);
//================================================================================
// ID stage reg
Reg_ID #(.addrWidth(memAddrWidth)) stage_ID ( 
    .clk(clk),
    .rst(rst),
    .Flush(Flush),
    .Stall(Stall_DH|Stall_MA|Hcf),
    .pc_in(pc),
    .inst_in(im_cache_read_data),
    .BP_taken_in(false),
    .pc_out(ID_pc),
    .inst(ID_Inst),
    .BP_taken(ID_BP_taken)
);

// WB Wire
assign wb_data = (W_WBSel == `PC_PLUS_4)? {{(32-memAddrWidth){1'b0}},WB_pc_plus4}:
                      (W_WBSel == `ALUOUT)? WB_alu_out:
                      (W_WBSel == `LD_DATA)? WB_ld_data_f:32'd0;

Controller #(.memAddrWidth(memAddrWidth)) Controller_(
    .clk(clk),
    .rst(rst),
    .IM_Mem_R(IM_Mem_R), 
    .IM_Mem_W(IM_Mem_W), 
    .IM_Valid(IM_Valid), 
    .DM_Mem_R(DM_Mem_R),
    .DM_Mem_W(DM_Mem_W),
    .DM_Valid(DM_Valid),  
    .E_BrEq(E_BrEq),
    .E_BrLT(E_BrLT),
    .BP_taken(false),
    .E_Branch_taken(E_Branch_taken),
    .E_En(E_En),
    .ID_pc(ID_pc),
    .EXE_BP_taken(EXE_BP_taken),
    .EXE_target_pc(EXE_target_pc),  
    .Flush(Flush),
    .Stall_DH(Stall_DH),
    .Stall_MA(Stall_MA),
    .IF_Inst(im_cache_read_data),
    .ID_Inst(ID_Inst),
    .EXE_Inst(EXE_Inst),
    .MEM_Inst(MEM_Inst),
    .WB_Inst(WB_Inst),
    .E_rs1_data_sel(E_rs1_data_sel),
    .E_rs2_data_sel(E_rs2_data_sel),
    .W_wb_data_hazard(W_wb_data_hazard),
    .WBD_wb_data_hazard(WBD_wb_data_hazard),
    .PCSel(PCSel),
    .D_ImmSel(D_ImmSel),
    .W_RegWEn(W_RegWEn),
    .E_BrUn(E_BrUn),
    .E_ASel(E_ASel),
    .E_BSel(E_BSel),
    .E_ALUSel(E_ALUSel),
    .W_WBSel(W_WBSel),
    .Hcf(Hcf)
);

//RegFile
RegFile RegFile_(
    .clk(clk),
    .wb_en(W_RegWEn),
    .wb_data(wb_data),
    .rd_index(WB_Inst),
    .rs1_index(ID_Inst[19:15]),
    .rs2_index(ID_Inst[24:20]),
    .rs1_data_out(ID_rs1_data),
    .rs2_data_out(ID_rs2_data)
);
//ImmGen
ImmGen ImmGen_(
    .inst_31_7(ID_Inst[31:7]),
    .ImmSel(D_ImmSel),
    .imm(imm)
);

//================================================================================
// EXE stage reg
Reg_EXE #(.addrWidth(memAddrWidth)) stage_EXE( 
    .clk(clk),
    .rst(rst),
    .Flush(Flush|Stall_DH),
    .Stall(Stall_MA|Hcf),
    .pc_in(ID_pc), 
    .inst_in(ID_Inst), 
    .imm_in(imm), 
    .rs1_rdata_in(ID_rs1_data), 
    .rs2_rdata_in(ID_rs2_data), 
    .BP_taken_in(ID_BP_taken), 
    .pc_out(EXE_pc), 
    .inst(EXE_Inst), 
    .imm(EXE_imm), 
    .rs1_rdata(EXE_rs1_data), 
    .rs2_rdata(EXE_rs2_data), 
    .BP_taken(EXE_BP_taken) 
);

// Reg Data Forwarding
wire [31:0] E_rs1_rdata;
wire [31:0] E_rs2_rdata;
//MUX
assign E_rs1_rdata = (E_rs1_data_sel ==`EXE_STAGE)? EXE_rs1_data:
                     (E_rs1_data_sel ==`MEM_STAGE)? MEM_alu_out:
                     (E_rs1_data_sel ==`WB_STAGE)? wb_data:
                     (E_rs1_data_sel ==`WBD_STAGE)? WBD_wb_data:EXE_rs1_data;
            

assign E_rs2_rdata = (E_rs2_data_sel ==`EXE_STAGE)? EXE_rs2_data:
                     (E_rs2_data_sel ==`MEM_STAGE)? MEM_alu_out:
                     (E_rs2_data_sel ==`WB_STAGE)? wb_data:
                     (E_rs2_data_sel ==`WBD_STAGE)? WBD_wb_data:EXE_rs2_data;

//Branch Comparator
BranchComp BC_(
    .BrUn(E_BrUn),
    .src1(E_rs1_rdata),
    .src2(E_rs2_rdata),
    .BrEq(E_BrEq),
    .BrLT(E_BrLT)
);

//ALU
wire [31:0] alu_src1;
wire [31:0] alu_src2;

assign alu_src1 = (E_ASel == 2'd0)? E_rs1_rdata:
                  (E_ASel == 2'd1)? {{(32-memAddrWidth){1'b0}},EXE_pc}:
                  (E_ASel == 2'd2)? 32'd0:E_rs1_rdata;
                  
assign alu_src2 = (E_BSel == 1'b1)? EXE_imm:E_rs2_rdata;
                  
wire [31:0] alu_out;

ALU ALU_(
    .src1(alu_src1),
    .src2(alu_src2),
    .ALUSel(E_ALUSel),
    .out(alu_out)
);
//===============================================================================
// MEM stage reg
Reg_MEM #(.addrWidth(memAddrWidth)) stage_MEM( 
    .clk(clk),
    .rst(rst),
    .Stall(Stall_MA|Hcf),
    .pc_in(EXE_pc), 
    .inst_in(EXE_Inst), 
    .rs2_rdata_in(E_rs2_rdata), 
    .alu_out_in(alu_out),
    .pc_out(MEM_pc),
    .inst(MEM_Inst),
    .alu_out(MEM_alu_out),
    .rs2_rdata(MEM_rs2_data)
);
//Data Memory Cache
Cache data_cache(
    .clk(clk),
    .rst(rst),
    .r_en(DM_Mem_R),
    .w_en(DM_Mem_W),
    .address(MEM_alu_out[memAddrWidth-1:0]),
    .write_data(MEM_rs2_data),
    .read_data(ld_data),
    .valid(DM_Valid),
    // AXI Lite 4 Bus master IO
    .readAddr_addr(Data_Cahe_readAddr_addr),
    .readAddr_valid(Data_Cahe_readAddr_valid),
    .readAddr_ready(Data_Cahe_readAddr_ready),
    .readData_data(Data_Cahe_readData_data),
    .readData_valid(Data_Cahe_readData_valid),
    .readData_ready(Data_Cahe_readData_ready),
    .writeAddr_addr(Data_Cahe_writeAddr_addr),
    .writeAddr_valid(Data_Cahe_writeAddr_valid),
    .writeAddr_ready(Data_Cahe_writeAddr_ready),
    .writeData_data(Data_Cahe_writeData_data),
    .writeData_strb(Data_Cahe_writeData_strb),
    .writeData_valid(Data_Cahe_writeData_valid),
    .writeData_ready(Data_Cahe_writeData_ready),
    .writeResp_msg(Data_Cahe_writeResp_msg),
    .writeResp_valid(Data_Cahe_writeResp_valid),
    .writeResp_ready(Data_Cahe_writeResp_ready)	
);
//===================================================================================
// WB stage reg
Reg_WB #(.addrWidth(memAddrWidth)) stage_WB( 
    .clk(clk),
    .rst(rst),
    .Stall(Stall_MA|Hcf),
    .pc_plus4_in(MEM_pc + 4),
    .inst_in(MEM_Inst),
    .alu_out_in(MEM_alu_out), 
    .ld_data_in(ld_data), 
    .pc_plus4(WB_pc_plus4),
    .inst(WB_Inst),
    .alu_out(WB_alu_out),
    .ld_data(WB_ld_data)
);

// Load data Filter
LD_Filter ld_filter(
    .width(WB_Inst[14:12]),  //func3
    .ld_data(WB_ld_data),
    .ld_data_f(WB_ld_data_f)
);

// WB data stage reg
Reg_WB_data #(.addrWidth(memAddrWidth)) stage_WB_data(
    .clk(clk),
    .rst(rst),
    .Stall(Stall_MA|Hcf),
    .WB_Hazard_in(W_wb_data_hazard),
    .wb_data_in(wb_data),
    .WB_Hazard(WBD_wb_data_hazard),
    .wb_data(WBD_wb_data)
);

endmodule
