`include "../AXILite4_Mux.v"

module testbench;

reg clk, rst;

// read bus
    // master 1
    reg  [31:0]   master_1_readAddr_addr;
    reg           master_1_readAddr_valid;
    wire          master_1_readAddr_ready;
    wire [127:0]  master_1_readData_data;
    wire          master_1_readData_valid;
    reg           master_1_readData_ready;
    // master 2
    reg  [31:0]   master_2_readAddr_addr;
    reg           master_2_readAddr_valid;
    wire          master_2_readAddr_ready;
    wire [127:0]  master_2_readData_data;
    wire          master_2_readData_valid;
    reg           master_2_readData_ready;
    // slave
    wire [31:0]   slave_readAddr_addr;
    wire          slave_readAddr_valid;
    reg           slave_readAddr_ready;
    reg  [127:0]  slave_readData_data;
    reg           slave_readData_valid;
    wire          slave_readData_ready;

// write bus
    // master 1
    reg  [31:0]   master_1_writeAddr_addr;
    reg           master_1_writeAddr_valid;
    wire          master_1_writeAddr_ready;
    reg  [127:0]  master_1_writeData_data;
    reg  [15:0]   master_1_writeData_strb;
    reg           master_1_writeData_valid;
    wire          master_1_writeData_ready;
    wire [31:0]   master_1_writeResp_msg;
    wire          master_1_writeResp_valid;
    reg           master_1_writeResp_ready;

    // master 2
    reg  [31:0]   master_2_writeAddr_addr;
    reg           master_2_writeAddr_valid;
    wire          master_2_writeAddr_ready;
    reg  [127:0]  master_2_writeData_data;
    reg  [15:0]   master_2_writeData_strb;
    reg           master_2_writeData_valid;
    wire          master_2_writeData_ready;
    wire [31:0]   master_2_writeResp_msg;
    wire          master_2_writeResp_valid;
    reg           master_2_writeResp_ready;
    // slave
    wire [31:0]   slave_writeAddr_addr;
    wire          slave_writeAddr_valid;
    reg           slave_writeAddr_ready;
    wire [127:0]  slave_writeData_data;
    wire [15:0]   slave_writeData_strb;
    wire          slave_writeData_valid;
    reg           slave_writeData_ready;
    reg  [31:0]   slave_writeResp_msg;
    reg           slave_writeResp_valid;
    wire          slave_writeResp_ready;

AXILite4_Mux bus(
    .clk(clk),
    .rst(rst),
        // read bus
            // master 1 - Inst cache
        .master_1_readAddr_addr(master_1_readAddr_addr),
        .master_1_readAddr_valid(master_1_readAddr_valid),
        .master_1_readAddr_ready(master_1_readAddr_ready),
        .master_1_readData_data(master_1_readData_data),
        .master_1_readData_valid(master_1_readData_valid),
        .master_1_readData_ready(master_1_readData_ready),
            // master 2 - Data cache
        .master_2_readAddr_addr(master_2_readAddr_addr),
        .master_2_readAddr_valid(master_2_readAddr_valid),
        .master_2_readAddr_ready(master_2_readAddr_ready),
        .master_2_readData_data(master_2_readData_data),
        .master_2_readData_valid(master_2_readData_valid),
        .master_2_readData_ready(master_2_readData_ready),
            // slave
        .slave_readAddr_addr(slave_readAddr_addr),
        .slave_readAddr_valid(slave_readAddr_valid),
        .slave_readAddr_ready(slave_readAddr_ready),
        .slave_readData_data(slave_readData_data),
        .slave_readData_valid(slave_readData_valid),
        .slave_readData_ready(slave_readData_ready),

        // write bus
            // master 1
        .master_1_writeAddr_addr(master_1_writeAddr_addr),
        .master_1_writeAddr_valid(master_1_writeAddr_valid),
        .master_1_writeAddr_ready(master_1_writeAddr_ready),
        .master_1_writeData_data(master_1_writeData_data),
        .master_1_writeData_strb(master_1_writeData_strb),
        .master_1_writeData_valid(master_1_writeData_valid),
        .master_1_writeData_ready(master_1_writeData_ready),
        .master_1_writeResp_msg(master_1_writeResp_msg),
        .master_1_writeResp_valid(master_1_writeResp_valid),
        .master_1_writeResp_ready(master_1_writeResp_ready),
            // master 2
        .master_2_writeAddr_addr(master_2_writeAddr_addr),
        .master_2_writeAddr_valid(master_2_writeAddr_valid),
        .master_2_writeAddr_ready(master_2_writeAddr_ready),
        .master_2_writeData_data(master_2_writeData_data),
        .master_2_writeData_strb(master_2_writeData_strb),
        .master_2_writeData_valid(master_2_writeData_valid),
        .master_2_writeData_ready(master_2_writeData_ready),
        .master_2_writeResp_msg(master_2_writeResp_msg),
        .master_2_writeResp_valid(master_2_writeResp_valid),
        .master_2_writeResp_ready(master_2_writeResp_ready),
            // slave
        .slave_writeAddr_addr(slave_writeAddr_addr),
        .slave_writeAddr_valid(slave_writeAddr_valid),
        .slave_writeAddr_ready(slave_writeAddr_ready),
        .slave_writeData_data(slave_writeData_data),
        .slave_writeData_strb(slave_writeData_strb),
        .slave_writeData_valid(slave_writeData_valid),
        .slave_writeData_ready(slave_writeData_ready),
        .slave_writeResp_msg(slave_writeResp_msg),
        .slave_writeResp_valid(slave_writeResp_valid),
        .slave_writeResp_ready(slave_writeResp_readys)
);

always #1 clk = ~clk;

initial begin
    clk = 0;
    rst = 0;

    // read bus
        // master 1
        master_1_readAddr_addr = 16'bx;
        master_1_readAddr_valid = 0;
        master_1_readData_ready = 0;
        // master 2
        master_2_readAddr_addr = 16'bx;
        master_2_readAddr_valid = 0;
        master_2_readData_ready = 0;
        // slave
        slave_readAddr_ready = 0;
        slave_readData_data = 16'bx;
        slave_readData_valid = 0;

    // write bus
        // master 1
        master_1_writeAddr_addr = 16'bx;
        master_1_writeAddr_valid = 0;
        master_1_writeData_data = 16'bx;
        master_1_writeData_strb = 16'bx;
        master_1_writeData_valid = 0;
        master_1_writeResp_ready = 0;

        // master 2
        master_2_writeAddr_addr = 16'bx;
        master_2_writeAddr_valid = 0;
        master_2_writeData_data = 16'bx;
        master_2_writeData_strb = 16'bx;
        master_2_writeData_valid = 0;
        master_2_writeResp_ready = 0;
        // slave
        slave_writeAddr_ready = 0;
        slave_writeData_ready = 0;
        slave_writeResp_msg = 32'bx;
        slave_writeResp_valid = 0;
end

initial begin
    #5 rst = 1;
    #5 rst = 0;

    #10
    master_2_writeAddr_addr = 0;
    master_2_readAddr_valid = 1;

    #10
    slave_readAddr_ready = 1;

    #10
    slave_readData_data = 0;
    slave_readData_valid = 1;

    #10
    master_2_readData_ready = 1;

    #10
    $stop;
end

initial begin
    $dumpfile("testbench.fsdb");
    $dumpvars;
end

endmodule
