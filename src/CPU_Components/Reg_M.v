module Reg_M ( 
    input clk, 
    input rst,
    input stall,
    input [31:0]alu_out_in, 
    input [31:0]rs2_data_in, 
    output reg [31:0]alu_out_out,
    output reg [31:0]rs2_data_out
);

always @(posedge clk or posedge rst) begin
    if(rst)begin
        alu_out_out <= 32'd0;
        rs2_data_out <= 32'd0;
    end
    else begin
        alu_out_out <= (stall)? alu_out_out:alu_out_in;
        rs2_data_out <= (stall)? rs2_data_out:rs2_data_in;
    end
end

endmodule