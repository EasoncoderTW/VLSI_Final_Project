module Reg_MEM #(parameter addrWidth = 15)( 
    input clk, 
    input rst,
    input Stall,
    input [addrWidth-1:0]pc_in, 
    input [31:0]inst_in, 
    input [31:0]alu_out_in,
    input [31:0]rs2_rdata_in,
    output wire [addrWidth-1:0]pc_out,
    output wire [31:0]inst,
    output wire [31:0]alu_out,
    output wire [31:0]rs2_rdata, 
);

reg [addrWidth-1:0]pcReg;
reg [31:0]InstReg;
reg [31:0]alu_out_Reg;
reg [31:0]rs2Reg;

wire [addrWidth-1:0]pc_next;
wire [31:0]inst_next;
wire [31:0]alu_out_next;
wire [31:0]rs2_data_next;

/* combinational circuit*/
assign pc_next = (stall)?pcReg:pc_in;
assign inst_next = (stall)?InstReg:inst_in;
assign alu_out_next = (stall)?alu_out_Reg:alu_out_in;
assign rs2_data_next = (stall)?rs2Reg:rs2_rdata_in;

/* output */
assign pc_out = pcReg;
assign inst = InstReg;
assign alu_out = alu_out_Reg;
assign rs2_rdata = rs2Reg;

/* sequencial ciruit */
always @(posedge clk or posedge rst) begin
    if(rst)begin
        pcReg <= '{addrWidth'('d0)};
        InstReg <= 32'd0;
        alu_out_Reg <= 32'd0;
        rs2Reg <= 32'd0;
    end
    else begin
        pcReg <= pc_next;
        InstReg <= inst_next;
        alu_out_Reg <= alu_out_next;
        rs2Reg <= rs2_data_next;
    end
end

endmodule