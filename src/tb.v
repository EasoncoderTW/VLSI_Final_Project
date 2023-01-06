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
        $display("+++++++++++++++++ Inst Memory Dump +++++++++++++++++");
        for(i=16'h0000 ;i< 16'h0200;i=i+16)begin
            $display("mem[%h - %h] %h %h %h %h  %h %h %h %h  %h %h %h %h  %h %h %h %h",i,i+15,
                top.memory.mem[i],
                top.memory.mem[i+1],
                top.memory.mem[i+2],
                top.memory.mem[i+3],
                top.memory.mem[i+4],
                top.memory.mem[i+5],
                top.memory.mem[i+6],
                top.memory.mem[i+7],
                top.memory.mem[i+8],
                top.memory.mem[i+9],
                top.memory.mem[i+10],
                top.memory.mem[i+11],
                top.memory.mem[i+12],
                top.memory.mem[i+13],
                top.memory.mem[i+14],
                top.memory.mem[i+15]);
        end
        $display("+++++++++++++++++ Data Memory Dump +++++++++++++++++");
        for(i=16'h8000 ;i< 16'h8200;i=i+16)begin
            $display("mem[%h - %h] %h %h %h %h  %h %h %h %h  %h %h %h %h  %h %h %h %h",i,i+15,
                top.memory.mem[i],
                top.memory.mem[i+1],
                top.memory.mem[i+2],
                top.memory.mem[i+3],
                top.memory.mem[i+4],
                top.memory.mem[i+5],
                top.memory.mem[i+6],
                top.memory.mem[i+7],
                top.memory.mem[i+8],
                top.memory.mem[i+9],
                top.memory.mem[i+10],
                top.memory.mem[i+11],
                top.memory.mem[i+12],
                top.memory.mem[i+13],
                top.memory.mem[i+14],
                top.memory.mem[i+15]);
        end
        $display("+++++++++++++++++ Data Memory Dump (Sort Answer)+++++++++++++++++");
        for(i=16'h9000 ;i< 16'h9120;i=i+16)begin
            $display("mem[%h - %h] %h %h %h %h  %h %h %h %h  %h %h %h %h  %h %h %h %h",i,i+15,
                top.memory.mem[i],
                top.memory.mem[i+1],
                top.memory.mem[i+2],
                top.memory.mem[i+3],
                top.memory.mem[i+4],
                top.memory.mem[i+5],
                top.memory.mem[i+6],
                top.memory.mem[i+7],
                top.memory.mem[i+8],
                top.memory.mem[i+9],
                top.memory.mem[i+10],
                top.memory.mem[i+11],
                top.memory.mem[i+12],
                top.memory.mem[i+13],
                top.memory.mem[i+14],
                top.memory.mem[i+15]);
        end
        $display("+++++++++++++++++ Data Memory Dump (fib Answer)+++++++++++++++++");
        for(i=16'hA000 ;i< 16'hA0af;i=i+16)begin            
	    $display("mem[%h - %h] %h %h %h %h  %h %h %h %h  %h %h %h %h  %h %h %h %h",i,i+15,
                top.memory.mem[i],
                top.memory.mem[i+1],
                top.memory.mem[i+2],
                top.memory.mem[i+3],
                top.memory.mem[i+4],
                top.memory.mem[i+5],
                top.memory.mem[i+6],
                top.memory.mem[i+7],
                top.memory.mem[i+8],
                top.memory.mem[i+9],
                top.memory.mem[i+10],
                top.memory.mem[i+11],
                top.memory.mem[i+12],
                top.memory.mem[i+13],
                top.memory.mem[i+14],
                top.memory.mem[i+15]);
        end
        $display("+++++++++++++++++ Data Memory Dump (Conv2d Answer)+++++++++++++++++");
        for(i=16'hB000 ;i< 16'hB040;i=i+16)begin
            $display("mem[%h - %h] %h %h %h %h  %h %h %h %h  %h %h %h %h  %h %h %h %h",i,i+15,
                top.memory.mem[i],
                top.memory.mem[i+1],
                top.memory.mem[i+2],
                top.memory.mem[i+3],
                top.memory.mem[i+4],
                top.memory.mem[i+5],
                top.memory.mem[i+6],
                top.memory.mem[i+7],
                top.memory.mem[i+8],
                top.memory.mem[i+9],
                top.memory.mem[i+10],
                top.memory.mem[i+11],
                top.memory.mem[i+12],
                top.memory.mem[i+13],
                top.memory.mem[i+14],
                top.memory.mem[i+15]);
        end
        $display("+++++++++++++++++ Data Memory Dump (Instr_test Answer)+++++++++++++++++");
        for(i=16'hC000 ;i< 16'hC0cf;i=i+16)begin
            $display("mem[%h - %h] %h %h %h %h  %h %h %h %h  %h %h %h %h  %h %h %h %h",i,i+15,
                top.memory.mem[i],
                top.memory.mem[i+1],
                top.memory.mem[i+2],
                top.memory.mem[i+3],
                top.memory.mem[i+4],
                top.memory.mem[i+5],
                top.memory.mem[i+6],
                top.memory.mem[i+7],
                top.memory.mem[i+8],
                top.memory.mem[i+9],
                top.memory.mem[i+10],
                top.memory.mem[i+11],
                top.memory.mem[i+12],
                top.memory.mem[i+13],
                top.memory.mem[i+14],
                top.memory.mem[i+15]);
        end
        $display("+++++++++++++++++ Stack Memory Dump +++++++++++++++++");
        for(i=16'hfd00 ;i <= 16'hffff;i=i+16)begin
            $display("mem[%h - %h] %h %h %h %h  %h %h %h %h  %h %h %h %h  %h %h %h %h",i,i+15,
                top.memory.mem[i],
                top.memory.mem[i+1],
                top.memory.mem[i+2],
                top.memory.mem[i+3],
                top.memory.mem[i+4],
                top.memory.mem[i+5],
                top.memory.mem[i+6],
                top.memory.mem[i+7],
                top.memory.mem[i+8],
                top.memory.mem[i+9],
                top.memory.mem[i+10],
                top.memory.mem[i+11],
                top.memory.mem[i+12],
                top.memory.mem[i+13],
                top.memory.mem[i+14],
                top.memory.mem[i+15]);
        end
        /* Dump memory Data*/
        $display("+++++++++++++++++ Regfile Dump +++++++++++++++++");

        for(i=0;i<32;i=i+4)begin
            $display("[x%02d] %h [x%02d] %h [x%02d] %h [x%02d] %h",
                i, top.cpu.RegFile_.registers[i],
                i+1, top.cpu.RegFile_.registers[i+1],
                i+2, top.cpu.RegFile_.registers[i+2],
                i+3, top.cpu.RegFile_.registers[i+3]);
      end

        $stop; // halt the cpu
    end
end

initial begin
    /* load SRAM */
    $readmemh("../test/prog2/Mem.hex",top.memory.mem);
    /* reset signal */
    clk = 0;
    rst = 0;
    #(`CYCLE) rst = 1;
    #(`CYCLE) rst = 0;
end

initial begin
    /* monitor */
    $monitor("[Time] %7d [PC] %d [stall MA/DH] %b / %b [I Cache R] %h [D Cache R] %h [D Cache WD/WA/Wen] %h / %h / %b [WR data / En] %8d / %b",
        $time, top.cpu.pc,
        top.cpu.Stall_MA,
        top.cpu.Stall_DH,
        top.cpu.im_cache_read_data,
        top.cpu.dm_cache_read_data,
        top.cpu.MEM_rs2_data,
        top.cpu.MEM_alu_out[15:0],
        top.cpu.DM_Mem_W,
        top.cpu.wb_data,
        top.cpu.W_RegWEn);
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
