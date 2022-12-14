`timescale 1ns/1ps
`include "Top.v"

`define CYCLE 10

module testbench;

reg clk;
reg rst;

Top top(.clk(clk), .rst(rst));

always begin
    /* clock signal */
    #CYCLE clk = ~clk;
end

initial begin
    /* load SRAM */
    $readmemb("file to load",top.memory.mem); //TBD
    /* reset signal */
    rst = 1;
    #CYCLE rst = 0;
end

initial begin
    /* monitor */
    ;
end



endmodule