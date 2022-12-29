`include "rv32_define.v"

module Controller (
    input clk,
    input rst,
    input [4:0] opcode, 
    input [2:0] func3, 
    input [4:0] rd_index, 
    input [4:0] rs1_index, 
    input [4:0] rs2_index, 
    input func7, 
    input alu_result,

    input inst_cache_ready, // new
    input data_cache_ready, // new

    output wire data_hazard_stall, // modified
    output wire data_mem_stall, // new
    output wire inst_mem_stall, // new
    output wire halt, // new

    output wire F_im_r_en, // new, IF stage instruction memory read enable signal
    output wire M_dm_r_en, // new, MEM stage data memory read enable signal

    output wire next_pc_sel, 
    output wire [3:0]F_im_w_en,

    output wire D_rs1_data_sel,
    output wire D_rs2_data_sel,

    output wire [1:0]E_rs1_data_sel,
    output wire [1:0]E_rs2_data_sel,
    output wire E_jb_op1_sel,
    output wire E_alu_op1_sel,
    output wire E_alu_op2_sel,
    output wire [4:0] E_op,
    output wire [2:0] E_f3,
    output wire E_f7,

    output wire [3:0]M_dm_w_en,

    output wire W_wb_en,
    output wire [4:0]W_rd_index,
    output wire [2:0]W_f3,
    output wire W_wb_data_sel
);


//reg
reg [4:0]E_op_reg, M_op_reg, W_op_reg;
reg [2:0]E_f3_reg, M_f3_reg, W_f3_reg;
reg [4:0]E_rd_reg, M_rd_reg, W_rd_reg;
reg [4:0]E_rs1_reg;
reg [4:0]E_rs2_reg;
reg E_f7_reg;

// cache hand-shake FSM
reg [1:0] im_cache_state;
reg [1:0] dm_cache_state;
localparam sIDLE = 2'b00,
        sWait = 2'b01,
        sDone = 2'b10;

// wire
wire im_cache_to_read;
wire dm_cache_to_read;
wire dm_cache_to_write;

//instuction memory write back enable
assign F_im_w_en =  4'b0000;    // never write
assign im_cache_to_read = 1'b1;        // always read
assign F_im_r_en = (im_cache_state == sDone)? 1'b0:im_cache_to_read; // controlled by FSM

//register data sel in D
wire is_D_rs1_W_rd_overlap;
wire is_D_use_rs1;
assign D_rs1_data_sel = is_D_rs1_W_rd_overlap ? 1'd1 : 1'd0;
assign is_D_rs1_W_rd_overlap = is_D_use_rs1 & W_wb_en & (rs1_index == W_rd_reg) & W_rd_reg != 0 ;
assign is_D_use_rs1 = (opcode == `R_type_)? 1'b1:
                            (opcode == `I_type_)? 1'b1:
                            (opcode == `store_)? 1'b1:
                            (opcode == `load_)? 1'b1:
                            (opcode == `branch_)? 1'b1:
                            (opcode == `jalr_)? 1'b1:1'b0;

wire is_D_rs2_W_rd_overlap;
wire is_D_use_rs2;
assign D_rs2_data_sel = is_D_rs2_W_rd_overlap ? 1'd1 : 1'd0;
assign is_D_rs2_W_rd_overlap = is_D_use_rs2 & W_wb_en & (rs2_index == W_rd_reg) & W_rd_reg != 0 ;
assign is_D_use_rs2 = (opcode == `R_type_)? 1'b1:
                            (opcode == `store_)? 1'b1:
                            (opcode == `branch_)? 1'b1:1'b0;


//register data sel in E
wire is_E_rs1_W_rd_overlap;
wire is_E_rs1_M_rd_overlap;
wire is_E_use_rs1;
wire is_M_use_rd;
assign E_rs1_data_sel = is_E_rs1_M_rd_overlap ? 2'd1 : 
                is_E_rs1_W_rd_overlap ? 2'd0 : 2'd2;
assign is_E_rs1_W_rd_overlap = is_E_use_rs1 & W_wb_en & (E_rs1_reg == W_rd_reg) & W_rd_reg != 0 ;
assign is_E_rs1_M_rd_overlap = is_E_use_rs1 & is_M_use_rd & (E_rs1_reg == M_rd_reg) & M_rd_reg != 0;
assign is_E_use_rs1 = (E_op_reg == `R_type_)? 1'b1:
                            (E_op_reg == `I_type_)? 1'b1:
                            (E_op_reg == `store_)? 1'b1:
                            (E_op_reg == `load_)? 1'b1:
                            (E_op_reg == `branch_)? 1'b1:
                            (E_op_reg == `jalr_)? 1'b1:1'b0;

assign is_M_use_rd = (M_op_reg == `lui_)?       1'b1:
                        (M_op_reg == `auipc_)?     1'b1:
                        (M_op_reg == `load_)?      1'b1:
                        (M_op_reg == `jal_)?       1'b1:
                        (M_op_reg == `jalr_)?      1'b1:
                        (M_op_reg == `I_type_)?    1'b1:
                        (M_op_reg == `R_type_)?    1'b1:1'b0;

wire is_E_rs2_W_rd_overlap;
wire is_E_rs2_M_rd_overlap;
wire is_E_use_rs2;
assign E_rs2_data_sel = is_E_rs2_M_rd_overlap ? 2'd1 : 
                        is_E_rs2_W_rd_overlap ? 2'd0 : 2'd2;
assign is_E_rs2_W_rd_overlap = is_E_use_rs2 & W_wb_en & (E_rs2_reg == W_rd_reg) & W_rd_reg != 0 ;
assign is_E_rs2_M_rd_overlap = is_E_use_rs2 & is_M_use_rd & (E_rs2_reg == M_rd_reg) & M_rd_reg != 0;
assign is_E_use_rs2 = (E_op_reg == `R_type_)? 1'b1:
                            (E_op_reg == `store_)? 1'b1:
                            (E_op_reg == `branch_)? 1'b1:1'b0;

// data_hazard_stall
wire is_DE_overlap;
wire is_D_rs1_E_rd_overlap;
wire is_D_rs2_E_rd_overlap;

assign data_hazard_stall = (E_op_reg == `load_) & is_DE_overlap;
assign is_DE_overlap = (is_D_rs1_E_rd_overlap | is_D_rs2_E_rd_overlap);
assign is_D_rs1_E_rd_overlap = is_D_use_rs1 & (rs1_index == E_rd_reg) & E_rd_reg != 0;
assign is_D_rs2_E_rd_overlap = is_D_use_rs2 & (rs2_index == E_rd_reg) & E_rd_reg != 0;

// data memory read stall
assign data_mem_stall = ((dm_cache_to_read||dm_cache_to_write) & dm_cache_state != sDone & (~data_cache_ready));

// inst memory read stall
assign inst_mem_stall = (im_cache_to_read & im_cache_state != sDone & (~inst_cache_ready));

// cpu halt
assign halt = (W_op_reg == `HCF);

//next_pc_sel normal (+4) when sel = 0
assign next_pc_sel =   (E_op_reg == `jal_)? 1'b1:
                            (E_op_reg == `jalr_)? 1'b1:
                            (E_op_reg == `branch_)? alu_result:1'b0;

//jb_op1_sel normal (pc) when sel = 0 or (rs1) when = 1 
assign E_jb_op1_sel = (E_op_reg == `jalr_)? 1'b1:1'b0;

//alu_op1_sel normal (pc) when sel = 0 or (rs1) when = 1 
assign E_alu_op1_sel =   (E_op_reg == `lui_)?       1'b0:
                            (E_op_reg == `auipc_)?     1'b0:
                            (E_op_reg == `jalr_)?     1'b0:
                            (E_op_reg == `jal_)?      1'b0:1'b1;

//alu_op2_sel normal (imm) when sel = 0 or (rs2) when = 1 
assign E_alu_op2_sel =   (E_op_reg == `R_type_)?    1'b1:
                            (E_op_reg == `branch_)?    1'b1:1'b0;

//E output
assign E_op = E_op_reg;
assign E_f3 = E_f3_reg;
assign E_f7 = E_f7_reg;

//register write back enable
assign W_wb_en = (W_op_reg == `lui_)?       1'b1:
                    (W_op_reg == `auipc_)?     1'b1:
                    (W_op_reg == `load_)?      1'b1:
                    (W_op_reg == `jal_)?       1'b1:
                    (W_op_reg == `jalr_)?      1'b1:
                    (W_op_reg == `I_type_)?    1'b1:
                    (W_op_reg == `R_type_)?    1'b1:1'b0;

//data memory write back enable
assign dm_cache_to_write =  (M_op_reg != `store_)?       4'b0000:
                            (M_f3_reg == `sb_)?       4'b0001:
                            (M_f3_reg == `sh_)?       4'b0011:
                            (M_f3_reg == `sw_)?       4'b1111:4'b0000;
assign M_dm_w_en = (dm_cache_state == sDone)? 4'b0000:dm_cache_to_write;

assign dm_cache_to_read = (M_op_reg == `load_)? 1'b1:1'b0; 
assign M_dm_r_en = (dm_cache_state == sDone)? 1'b0:dm_cache_to_read;

assign W_rd_index = W_rd_reg;
assign W_f3 = W_f3_reg;

//wb_sel normal (alu_out) when sel = 0 or (load_out) when = 1 
assign W_wb_data_sel = (W_op_reg == `load_)? 1'b1:1'b0;


wire [1:0]im_cache_state_next;
assign im_cache_state_next = (im_cache_state == sIDLE)?((inst_mem_stall)? sWait:((data_mem_stall)? sDone:sIDLE)):
                             (im_cache_state == sWait)?((inst_mem_stall)? sWait:((data_mem_stall)? sDone:sIDLE)):
                             (im_cache_state == sDone)?((data_mem_stall)? sDone:sIDLE):sIDLE;
// Cache Read/Wrtie FSM
always@(posedge clk or posedge rst) begin
    if(rst) begin
        im_cache_state <= sIDLE;
    end
    else begin
        im_cache_state <= im_cache_state_next;
    end
end

wire [1:0]dm_cache_state_next;
assign dm_cache_state_next = (dm_cache_state == sIDLE)?((data_mem_stall)? sWait:((inst_mem_stall)? sDone:sIDLE)):
                             (dm_cache_state == sWait)?((data_mem_stall)? sWait:((inst_mem_stall)? sDone:sIDLE)):
                             (dm_cache_state == sDone)?((inst_mem_stall)? sDone:sIDLE):sIDLE;
// Cache Read/Wrtie FSM
always@(posedge clk or posedge rst) begin
    if(rst) begin
        dm_cache_state <= sIDLE;
    end
    else begin
        dm_cache_state <= dm_cache_state_next;
    end
end

// 5 stage pipelined stage register
always @(posedge clk or posedge rst) begin
    if(rst) begin
        E_op_reg <= 5'd0;
        M_op_reg <= 5'd0;
        W_op_reg <= 5'd0;
        E_f3_reg <= 3'd0;
        M_f3_reg <= 3'd0;
        W_f3_reg <= 3'd0;
        E_rd_reg <= 5'd0;
        M_rd_reg <= 5'd0;
        W_rd_reg <= 5'd0;
        E_rs1_reg <= 5'd0;
        E_rs2_reg <= 5'd0;
        E_f7_reg <= 1'd0;
    end
    else begin
        E_op_reg <= (data_hazard_stall)? 5'd0:((data_mem_stall|inst_mem_stall)?E_op_reg:((next_pc_sel)?5'd0:opcode));
        E_f3_reg <= (data_hazard_stall)? 3'd0:((data_mem_stall|inst_mem_stall)?E_f3_reg:((next_pc_sel)?3'd0:func3));
        E_rd_reg <= (data_hazard_stall)? 5'd0:((data_mem_stall|inst_mem_stall)?E_rd_reg:((next_pc_sel)?5'd0:rd_index));
        E_rs1_reg <= (data_hazard_stall)? 5'd0:((data_mem_stall|inst_mem_stall)?E_rs1_reg:((next_pc_sel)?5'd0:rs1_index));
        E_rs2_reg <= (data_hazard_stall)? 5'd0:((data_mem_stall|inst_mem_stall)?E_rs2_reg:((next_pc_sel)?5'd0:rs2_index));
        E_f7_reg <= (data_hazard_stall)? 1'd0:((data_mem_stall|inst_mem_stall)?E_f7_reg:((next_pc_sel)?1'd0:func7));
        
        M_op_reg <= (data_mem_stall|inst_mem_stall)?M_op_reg:E_op_reg;
        M_f3_reg <= (data_mem_stall|inst_mem_stall)?M_f3_reg:E_f3_reg;
        M_rd_reg <= (data_mem_stall|inst_mem_stall)?M_rd_reg:E_rd_reg;

        W_op_reg <= (data_mem_stall|inst_mem_stall)?W_op_reg:M_op_reg;
        W_f3_reg <= (data_mem_stall|inst_mem_stall)?W_f3_reg:M_f3_reg;
        W_rd_reg <= (data_mem_stall|inst_mem_stall)?W_rd_reg:M_rd_reg;
    end
end


endmodule
