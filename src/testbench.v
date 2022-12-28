`timescale 1ns/1ps
`include "Top.v"

`define CYCLE 10

module testbench;

reg clk;
reg rst;
wire halt;

Top top(.clk(clk), .rst(rst), .halt(halt));

integer i;

always begin
    /* clock signal */
    #(`CYCLE) clk = ~clk;
    if(halt)begin
        $display("Halt...");
        /* Dump memory Data*/
        $display("+++++++++++++++++ Memory Dump +++++++++++++++++");

        for(i=0;i<128;i+=4)begin
            $display("mem[%h] %h %h %h %h",i,
                top.memory.mem[16'h8000+i],
                top.memory.mem[16'h8000+i+1],
                top.memory.mem[16'h8000+i+2],
                top.memory.mem[16'h8000+i+3]);
        end
        $stop; // halt the cpu
    end
end

initial begin
    /* load SRAM */
    $readmemh("./../test/prog1/main.hex",top.memory.mem);
    /* reset signal */
    rst = 1;
    #(`CYCLE) rst = 0;
end

initial begin
    /* monitor */
    $monitor("[Time] %d [PC] %d [Instmem stall] %b [Datamem stall] %b [DataHazard stall] %b",
        $time, top.cpu.pc_now,
        top.cpu.inst_mem_stall,
        top.cpu.data_mem_stall,
        top.cpu.data_hazard_stall);
end

endmodule