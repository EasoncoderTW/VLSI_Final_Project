`timescale 1ns/1ps
`include "Top.v"

`define CYCLE 10
`define RESET_TIME 20

module testbench;

reg clk;
reg rst;
wire halt;

Top top(.clk(clk), .rst(rst), .halt(halt));

//integer i;

initial clk = 1'b0;

always begin
    #10 clk = ~clk;
    $display("clk = %b", clk);
end

initial begin
    /* reset signal */
    rst = 1'b0;
    #100 rst = 1'b1;
    #20 rst = 1'b0;
    #100 ;
end

//initial begin
    /* monitor */
    /*$monitor("[Time] %d [PC] %d [Instmem stall] %b [Datamem stall] %b [DataHazard stall] %b [Bus 1rA / 2rA / 1rD / 2rD] %b %b %b %b",
        $time, top.cpu.pc_now,
        top.cpu.inst_mem_stall,
        top.cpu.data_mem_stall,
        top.cpu.data_hazard_stall,
	top.bus.master_1_readAddr_valid,
	top.bus.master_2_readAddr_valid,
	top.bus.master_1_readData_valid,
	top.bus.master_2_readData_valid);*/
//end

initial begin
    $dumpfile("testbench.fsdb");
    $dumpvars;
    #10000 $stop;
end

initial begin

    /* load SRAM */
    $readmemh("./Mem.hex",top.memory.mem);
    /*$display("+++++++++++++++++ Inst Memory Dump +++++++++++++++++");
 	
    for(i=0;i< 256;i=i+4)begin
        $display("mem[%h] %h %h %h %h",i,
            top.memory.mem[16'h0000+i],
            top.memory.mem[16'h0000+i+1],
            top.memory.mem[16'h0000+i+2],
            top.memory.mem[16'h0000+i+3]);
    end
    $display("+++++++++++++++++ Data Memory Dump +++++++++++++++++");
 	
    for(i=0;i< 256;i=i+4)begin
        $display("mem[%h] %h %h %h %h",i,
            top.memory.mem[16'h8000+i],
            top.memory.mem[16'h8000+i+1],
            top.memory.mem[16'h8000+i+2],
            top.memory.mem[16'h8000+i+3]);
    end

    @(halt) $display("Halt...");*/
    /* Dump memory Data*/
    /*$display("+++++++++++++++++ Memory Dump +++++++++++++++++");

    for(i=0;i< 256;i=i+4)begin
        $display("mem[%h] %h %h %h %h",i,
            top.memory.mem[16'h8000+i],
            top.memory.mem[16'h8000+i+1],
            top.memory.mem[16'h8000+i+2],
            top.memory.mem[16'h8000+i+3]);
     end
     $stop; // halt the cpu
*/

end


endmodule

