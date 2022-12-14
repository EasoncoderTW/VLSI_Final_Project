`include "CPU.v"
`include "AXI_Lite_4_Bus.v"
`include "SRAM.v"

module Top (
    input clk,
    input rst
);

CPU cpu(.clk(clk), .rst(rst), /* AXI Lite 4 Bus IO */);
AXI_Lite_4_Bus bus(.clk(clk), .rst(rst),/* IO */);
SRAM memory(.clk(clk), .rst(rst),/* AXI Lite 4 Bus IO */);

endmodule
