`timescale 1ns/100ps
`include "Top.v"

`define CYCLE 10

module testbench;

reg clk;
reg rst;
wire Hcf;

Top top(.clk(clk), .rst(rst), .Hcf(Hcf));

integer i;

always begin
    /* clock signal */
    #(`CYCLE/2) clk = ~clk;
    if(Hcf)begin
        $display("Hcf...");
        /* Dump memory Data*/
        $display("+++++++++++++++++ Memory Dump +++++++++++++++++");

        for(i=0;i<128;i=i+4)begin
            $display("mem[%h] %h %h %h %h",16'h8000+i,
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
    $readmemh("../test/Emulator/Mem.hex",top.memory.mem);
    /* reset signal */
    clk = 0;
    rst = 0;
    #(`CYCLE) rst = 1;
    #(`CYCLE) rst = 0;
end

initial begin
    /* monitor */
    $monitor("[Time] %d [PC] %d [Memory Access stall] %b [DataHazard stall] %b",
        $time, top.cpu.pc,
        top.cpu.Stall_MA,
        top.cpu.Stall_DH);
end

initial begin
    `ifdef iverilog
        $dumpfile("testbench.vcd");
        $dumpvars(0, testbench);
    `else
        $dumpfile("testbench.fsdb");
        $dumpvars;
    `endif
end

endmodule