module Reg_EXE #(parameter addrWidth = 15)( 
    input clk, 
    input rst,
    input Flush,
    input Stall,
    input [addrWidth-1:0]pc_in, 
    input [31:0]inst_in, 
    input [31:0]imm_in, 
    input [31:0]rs1_rdata_in, 
    input [31:0]rs2_rdata_in, 
    input BP_taken_in, 
    
    output wire [addrWidth-1:0]pc_out,
    output wire [31:0]inst,
    output wire [31:0]imm,
    output wire [31:0]rs1_rdata,
    output wire [31:0]rs2_rdata,
    output wire BP_taken
);

reg [addrWidth-1:0]pcReg;
reg [31:0]InstReg;
reg [31:0]immReg;
reg [31:0]rs1Reg;
reg [31:0]rs2Reg;
reg BP_taken_Reg;

wire [addrWidth-1:0]pc_next;
wire [31:0]inst_next;
wire [31:0]imm_next;
wire [31:0]rs1_rdata_next;
wire [31:0]rs2_rdata_next;
wire BP_taken_next;

/* combinational circuit*/
assign pc_next = (Stall)?pcReg:
                 (Flush)?({addrWidth{1'b0}}):pc_in;
assign inst_next = (Stall)?InstReg:
                 (Flush)?(32'd0):inst_in;
assign imm_next = (Stall)?immReg:
                 (Flush)?(32'd0):imm_in;
assign rs1_rdata_next = (Stall)?rs1Reg:
                 (Flush)?(32'd0):rs1_rdata_in;
assign rs2_rdata_next = (Stall)?rs2Reg:
                 (Flush)?(32'd0):rs2_rdata_in;
assign BP_taken_next = (Stall)?BP_taken_Reg:
                 (Flush)?(1'd0):BP_taken_in;

/* output */
assign pc_out = pcReg;
assign inst = InstReg;
assign imm = immReg;
assign rs1_rdata = rs1Reg;
assign rs2_rdata = rs2Reg;
assign BP_taken = BP_taken_Reg;

/* sequencial ciruit */
always @(posedge clk or posedge rst) begin
    if(rst)begin
        pcReg <= {addrWidth{1'b0}};
        InstReg <= 32'd0;
        immReg <= 32'd0;
        rs1Reg <= 32'd0;
        rs2Reg <= 32'd0;
        BP_taken_Reg <= 1'd0;
    end
    else begin
        pcReg <= pc_next;
        InstReg <= inst_next;
        immReg <= imm_next;
        rs1Reg <= rs1_rdata_next;
        rs2Reg <= rs2_rdata_next;
        BP_taken_Reg <= BP_taken_next;
    end
end

endmodule
