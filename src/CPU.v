`include "Adder.v"
`include "ALU.v"
`include "Cache.v"
`include "Controller.v"
`include "Decoder.v"
`include "Imme_Ext.v"
`include "JB_Unit.v"
`include "LD_Filter.v"
`include "Mux.v"
`include "Reg_D.v"
`include "Reg_E.v"
`include "Reg_M.v"
`include "Reg_PC.v"
`include "Reg_W.v"
`include "RegFile.v"

module CPU(
    input clk,
    input rst,
    // Inst Cache - AXI Lite 4 master IO
        // read port
    output  [31:0]       Inst_Cahe_readAddr_addr,
    output               Inst_Cahe_readAddr_valid,
    input                Inst_Cahe_readAddr_ready,
    input   [127:0]      Inst_Cahe_readData_data,
    input                Inst_Cahe_readData_valid,
    output               Inst_Cahe_readData_ready,
        // write port
    output  [31:0]       Inst_Cahe_writeAddr_addr,
    output               Inst_Cahe_writeAddr_valid,
    input                Inst_Cahe_writeAddr_ready,
    output  [127:0]      Inst_Cahe_writeData_data,
    output  [15:0]       Inst_Cahe_writeData_strb,
    output               Inst_Cahe_writeData_valid,
    input                Inst_Cahe_writeData_ready,
    input   [31:0]       Inst_Cahe_writeResp_msg,
    input                Inst_Cahe_writeResp_valid,
    output               Inst_Cahe_writeResp_ready,

    // Data Cache - AXI Lite 4 master IO
        // read port
    output  [31:0]       Data_Cahe_readAddr_addr,
    output               Data_Cahe_readAddr_valid,
    input                Data_Cahe_readAddr_ready,
    input   [127:0]      Data_Cahe_readData_data,
    input                Data_Cahe_readData_valid,
    output               Data_Cahe_readData_ready,
        // write port
    output  [31:0]       Data_Cahe_writeAddr_addr,
    output               Data_Cahe_writeAddr_valid,
    input                Data_Cahe_writeAddr_ready,
    output  [127:0]      Data_Cahe_writeData_data,
    output  [15:0]       Data_Cahe_writeData_strb,
    output               Data_Cahe_writeData_valid,
    input                Data_Cahe_writeData_ready,
    input   [31:0]       Data_Cahe_writeResp_msg,
    input                Data_Cahe_writeResp_valid,
    output               Data_Cahe_writeResp_ready
);

wire [3:0] F_im_w_en;
wire F_im_r_en;
wire [31:0] pc_now;
wire [31:0] pc_next;
wire [31:0] inst;
wire next_pc_sel;
wire [31:0] pc_add_four;
wire [31:0] jb_pc;
wire data_hazar_stall;
wire data_mem_stall;
wire inst_mem_stall;
wire inst_cache_ready;
wire data_cache_ready;

Reg_PC pc(
    .clk(clk),
    .rst(rst),
    .stall(stall|inst_mem_stall|data_mem_stall),
    .next_pc(pc_next),
    .current_pc(pc_now)
);

Mux next_pc(
    .sel(next_pc_sel),
    .operand1(jb_pc),
    .operand2(pc_add_four),
    .mux_out(pc_next)
);

Adder add_four(
    .operand1(pc_now), 
    .operand2(32'd4), 
    .add_out(pc_add_four) 
);

Cache inst_cache(
    .clk(clk),
    .rst(rst),
    // Controller IO
    .w_en(F_im_w_en),
    .r_en(F_im_r_en),
    .address(pc_now[15:0]),
    .write_data(32'd0), // always zero
    .read_data(inst),
    .ready(inst_cache_ready),
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
wire flush;
assign flush = next_pc_sel;
wire [31:0]reg_d_pc;
wire [31:0]reg_d_inst;

Reg_D reg_d( 
    .clk(clk),
    .rst(rst),
    .stall(data_hazar_stall|data_mem_stall),
    .flush(flush|inst_mem_stall),
    .pc_in(pc_now), 
    .inst_in(inst), 
    .pc_out(reg_d_pc),
    .inst_out(reg_d_inst)
);

wire [2:0] func3;
wire func7;
wire [4:0] opcode;
wire [4:0] rs1_index;
wire [4:0] rs2_index;
wire [4:0] rd_index;

Decoder decoder(
    .inst(reg_d_inst),
    .dc_out_opcode(opcode),
    .dc_out_func3(func3),
    .dc_out_func7(func7),
    .dc_out_rs1_index(rs1_index),
    .dc_out_rs2_index(rs2_index),
    .dc_out_rd_index(rd_index)
);

wire [31:0] rs1_data;
wire [31:0] rs2_data;
wire D_rs1_data_sel;
wire D_rs2_data_sel;
wire [1:0]E_rs1_data_sel;
wire [1:0]E_rs2_data_sel;
wire E_jb_op1_sel;
wire E_alu_op1_sel;
wire E_alu_op2_sel;
wire [2:0] E_f3;
wire E_f7;
wire [4:0] E_op;
wire [2:0] W_f3;
wire [3:0] M_dm_w_en;
wire M_dm_r_en;
wire W_wb_en;
wire W_wb_data_sel;
wire [4:0]W_rd_index;
wire [31:0] alu_out;

Controller controller(
    .clk(clk),
    .rst(rst),
    .opcode(opcode), 
    .func3(func3), 
    .func7(func7), 
    .rd_index(rd_index),
    .rs1_index(rs1_index),
    .rs2_index(rs2_index),  
    .alu_result(alu_out[0]),
    .inst_cache_ready(inst_cache_ready),
    .data_cache_ready(data_cache_ready),
    .data_hazar_stall(data_hazar_stall),
    .data_mem_stall(data_mem_stall),
    .inst_mem_stall(inst_mem_stall),
    .next_pc_sel(next_pc_sel),  
    .F_im_w_en(F_im_w_en),
    .D_rs1_data_sel(D_rs1_data_sel),
    .D_rs2_data_sel(D_rs2_data_sel),
    .E_rs1_data_sel(E_rs1_data_sel),
    .E_rs2_data_sel(E_rs2_data_sel),
    .E_jb_op1_sel(E_jb_op1_sel),
    .E_alu_op1_sel(E_alu_op1_sel),
    .E_alu_op2_sel(E_alu_op2_sel),
    .E_op(E_op),
    .E_f3(E_f3),
    .E_f7(E_f7),
    .M_dm_w_en(M_dm_w_en),
    .M_dm_r_en(M_dm_r_en),
    .W_wb_en(W_wb_en),
    .W_rd_index(W_rd_index),
    .W_f3(W_f3),
    .W_wb_data_sel(W_wb_data_sel)
);

wire [31:0] wb_data;

RegFile regfile(
    .clk(clk),
    .wb_en(W_wb_en),
    .wb_data(wb_data),
    .rd_index(W_rd_index),
    .rs1_index(rs1_index),
    .rs2_index(rs2_index),
    .rs1_data_out(rs1_data),
    .rs2_data_out(rs2_data)
);

wire [31:0] sext_imme;

Imm_Ext imm_ext(
    .inst(reg_d_inst),
    .imm_ext_out(sext_imme)
);

wire [31:0] mux_d_rs1_data_out;
wire [31:0] mux_d_rs2_data_out;

Mux mux_d_rs1_data(
    .sel(D_rs1_data_sel),
    .operand1(wb_data),
    .operand2(rs1_data),
    .mux_out(mux_d_rs1_data_out)
);

Mux mux_d_rs2_data(
    .sel(D_rs2_data_sel),
    .operand1(wb_data),
    .operand2(rs2_data),
    .mux_out(mux_d_rs2_data_out)
);

//================================================================================

wire [31:0] reg_e_pc;
wire [31:0] reg_e_rs1_data;
wire [31:0] reg_e_rs2_data;
wire [31:0] reg_e_sext_imme;

Reg_E reg_e( 
    .clk(clk),
    .rst(rst),
    .stall(data_hazar_stall|data_mem_stall),
    .flush(flush),
    .pc_in(reg_d_pc), 
    .rs1_data_in(mux_d_rs1_data_out), 
    .rs2_data_in(mux_d_rs2_data_out), 
    .sext_imme_in(sext_imme), 
    .pc_out(reg_e_pc),
    .rs1_data_out(reg_e_rs1_data),
    .rs2_data_out(reg_e_rs2_data),
    .sext_imme_out(reg_e_sext_imme)
);

wire [31:0] mux_e_rs1_data_out;
wire [31:0] mux_e_rs2_data_out;
wire [31:0] reg_w_alu_out_out;

wire [31:0]reg_m_alu_out_out;

//MUX
assign mux_e_rs1_data_out = (E_rs1_data_sel== 2'd0)? wb_data:
                            (E_rs1_data_sel== 2'd1)? reg_m_alu_out_out:reg_e_rs1_data;

assign mux_e_rs2_data_out = (E_rs2_data_sel== 2'd0)? wb_data:
                            (E_rs2_data_sel== 2'd1)? reg_m_alu_out_out:reg_e_rs2_data;


wire [31:0] alu_op1;
wire [31:0] alu_op2;

Mux mux_alu_op1(
    .sel(E_alu_op1_sel),
    .operand1(mux_e_rs1_data_out),
    .operand2(reg_e_pc),
    .mux_out(alu_op1)
);

Mux mux_alu_op2(
    .sel(E_alu_op2_sel),
    .operand1(mux_e_rs2_data_out),
    .operand2(reg_e_sext_imme),
    .mux_out(alu_op2)
);

wire [31:0] jb_op1;
wire [31:0] jb_op2;
assign jb_op2 = reg_e_sext_imme;

Mux mux_jb_op1(
    .sel(E_jb_op1_sel),
    .operand1(mux_e_rs1_data_out),
    .operand2(reg_e_pc),
    .mux_out(jb_op1)
);

ALU alu(
    .opcode(E_op),
    .func3(E_f3),
    .func7(E_f7),
    .operand1(alu_op1),
    .operand2(alu_op2),
    .alu_out(alu_out)
);

JB_Unit jb_unit(
    .operand1(jb_op1),
    .operand2(jb_op2),
    .jb_out(jb_pc)
);
//===============================================================================

wire [31:0] reg_m_rs2_data_out;

Reg_M reg_m( 
    .clk(clk),
    .rst(rst),
    .stall(data_mem_stall),
    .alu_out_in(alu_out), 
    .rs2_data_in(mux_e_rs2_data_out), 
    .alu_out_out(reg_m_alu_out_out), 
    .rs2_data_out(reg_m_rs2_data_out)
);

wire [31:0] ld_data;

Cache data_cache(
    .clk(clk),
    .rst(rst),
    .r_en(M_dm_r_en),
    .w_en(M_dm_w_en),
    .address(reg_m_alu_out_out[15:0]),
    .write_data(reg_m_rs2_data_out),
    .read_data(ld_data),
    .ready(data_cache_ready),
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
    .writeResp_valid(Data_Cahe_writeResp_valid)
);
//===================================================================================


wire [31:0]reg_w_ld_data_out;

Reg_W reg_w( 
    .clk(clk),
    .rst(rst),
    .stall(data_mem_stall),
    .alu_out_in(reg_m_alu_out_out), 
    .ld_data_in(ld_data), 
    .alu_out_out(reg_w_alu_out_out),
    .ld_data_out(reg_w_ld_data_out)
);

wire [31:0] ld_data_f;

LD_Filter ld_filter(
    .func3(W_f3),
    .ld_data(reg_w_ld_data_out),
    .ld_data_f(ld_data_f)
);

Mux mux_wb(
    .sel(W_wb_data_sel),
    .operand1(ld_data_f),
    .operand2(reg_w_alu_out_out),
    .mux_out(wb_data)
);

endmodule