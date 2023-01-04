module Reg_ID #(parameter addrWidth = 16)( 
    input clk, 
    input rst,
    input Flush,
    input Stall,
    input [addrWidth-1:0]pc_in, 
    input [31:0]inst_in, 
    input BP_taken_in, 
    output wire [addrWidth-1:0]pc_out,
    output wire [31:0]inst,
    output wire BP_taken
);

reg [addrWidth-1:0]pcReg;
reg [31:0]InstReg;
reg BP_taken_Reg;

wire [addrWidth-1:0]pc_next;
wire [31:0]inst_next;
wire BP_taken_next;

/* combinational circuit*/
assign pc_next = (Stall)?pcReg:
                 (Flush)?({addrWidth{1'b0}}):pc_in;
assign inst_next = (Stall)?InstReg:
                 (Flush)?(32'd0):inst_in;
assign BP_taken_next = (Stall)?BP_taken_Reg:
                 (Flush)?(1'd0):BP_taken_in;

/* output */
assign pc_out = pcReg;
assign inst = InstReg;
assign BP_taken = BP_taken_Reg;

/* sequencial ciruit */
always @(posedge clk or posedge rst) begin
    if(rst)begin
        pcReg <= {addrWidth{1'b0}};
        InstReg <= 32'd0;
        BP_taken_Reg <= 1'd0;
    end
    else begin
        pcReg <= pc_next;
        InstReg <= inst_next;
        BP_taken_Reg <= BP_taken_next;
    end
end


endmodule
