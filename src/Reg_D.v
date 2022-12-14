module Reg_D ( 
    input clk, 
    input rst,
    input stall,
    input jb,
    input [31:0]pc_in, 
    input [31:0]inst_in, 
    output reg [31:0]pc_out,
    output reg [31:0]inst_out
);

reg [31:0]pc;
reg [31:0]inst;

always @(*) begin
    pc = (stall)? pc_out:((jb)?32'd0:pc_in);
    inst = (stall)? inst_out:((jb)?32'd0:inst_in);
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        pc_out <= 32'd0;
        inst_out <= 32'd0;
    end
    else begin
        pc_out <= pc;
        inst_out <= inst;
    end
end

endmodule
