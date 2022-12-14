module JB_Unit (
    input [31:0] operand1,
    input [31:0] operand2,
    output reg [31:0] jb_out
);

always @(*) begin
    jb_out = (operand1+operand2)&(~32'd1);
end

    
endmodule