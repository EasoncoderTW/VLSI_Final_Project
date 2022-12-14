module Adder (
    input [31:0]operand1, 
    input [31:0]operand2, 
    output wire[31:0]add_out 
);
 
assign add_out = operand1 + operand2;
    
endmodule