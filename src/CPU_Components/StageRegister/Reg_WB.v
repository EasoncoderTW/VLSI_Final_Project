module Reg_WB #(parameter addrWidth = 15)( 
    input clk, 
    input rst,
    input Stall,
    input [addrWidth-1:0]pc_plus4_in, 
    input [31:0]inst_in, 
    input [31:0]alu_out_in,
    input [31:0]ld_data_in,
    output wire [addrWidth-1:0]pc_plus4,
    output wire [31:0]inst,
    output wire [31:0]alu_out,
    output wire [31:0]ld_data 
);

reg [addrWidth-1:0]pc_plus4_Reg;
reg [31:0]InstReg;
reg [31:0]alu_out_Reg;
reg [31:0]ld_data_Reg;

wire [addrWidth-1:0]pc_plus4_next;
wire [31:0]inst_next;
wire [31:0]alu_out_next;
wire [31:0]ld_data_next;

/* combinational circuit*/
assign pc_plus4_next = (Stall)?pc_plus4_Reg:pc_plus4_in;
assign inst_next = (Stall)?InstReg:inst_in;
assign alu_out_next = (Stall)?alu_out_Reg:alu_out_in;
assign ld_data_next = (Stall)?ld_data_Reg:ld_data_in;

/* output */
assign pc_plus4 = pc_plus4_Reg;
assign inst = InstReg;
assign alu_out = alu_out_Reg;
assign ld_data = ld_data_Reg;

/* sequencial ciruit */
always @(posedge clk or posedge rst) begin
    if(rst)begin
        pc_plus4_Reg <= {addrWidth{1'b0}};
        InstReg <= 32'd0;
        alu_out_Reg <= 32'd0;
        ld_data_Reg <= 32'd0;
    end
    else begin
        pc_plus4_Reg <= pc_plus4_next;
        InstReg <= inst_next;
        alu_out_Reg <= alu_out_next;
        ld_data_Reg <= ld_data_next;
    end
end

endmodule
