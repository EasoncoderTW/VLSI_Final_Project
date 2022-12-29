module Mux (
    input sel,
    input [31:0]operand1,
    input [31:0]operand2,
    output wire [31:0]mux_out
);

assign mux_out = (sel)? operand1:operand2;
    
endmodule