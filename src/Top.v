`include "CPU.v"
`include "AXILite4_Mux.v"
`include "SRAM.v"

module Top (
    input clk,
    input rst,
    output wire Hcf
);
    // CPU Instruction Cache - AXI Lite 4 master IO wire
        // read port
    wire  [31:0]    Inst_Cahe_readAddr_addr;
    wire            Inst_Cahe_readAddr_valid;
    wire            Inst_Cahe_readAddr_ready;
    wire  [127:0]   Inst_Cahe_readData_data;
    wire            Inst_Cahe_readData_valid;
    wire            Inst_Cahe_readData_ready;
        // write port
    wire  [31:0]    Inst_Cahe_writeAddr_addr;
    wire            Inst_Cahe_writeAddr_valid;
    wire            Inst_Cahe_writeAddr_ready;
    wire  [127:0]   Inst_Cahe_writeData_data;
    wire  [15:0]    Inst_Cahe_writeData_strb;
    wire            Inst_Cahe_writeData_valid;
    wire            Inst_Cahe_writeData_ready;
    wire  [31:0]    Inst_Cahe_writeResp_msg;
    wire            Inst_Cahe_writeResp_valid;
    wire            Inst_Cahe_writeResp_ready;

    // CPU Data Cache - AXI Lite 4 master IO wire
        // read port
    wire  [31:0]    Data_Cahe_readAddr_addr;
    wire            Data_Cahe_readAddr_valid;
    wire            Data_Cahe_readAddr_ready;
    wire  [127:0]   Data_Cahe_readData_data;
    wire            Data_Cahe_readData_valid;
    wire            Data_Cahe_readData_ready;
        // write port
    wire  [31:0]    Data_Cahe_writeAddr_addr;
    wire            Data_Cahe_writeAddr_valid;
    wire            Data_Cahe_writeAddr_ready;
    wire  [127:0]   Data_Cahe_writeData_data;
    wire  [15:0]    Data_Cahe_writeData_strb;
    wire            Data_Cahe_writeData_valid;
    wire            Data_Cahe_writeData_ready;
    wire  [31:0]    Data_Cahe_writeResp_msg;
    wire            Data_Cahe_writeResp_valid;
    wire            Data_Cahe_writeResp_ready;

    // SRAM - AXI Lite 4 slave IO wire
        // read port
    wire   [31:0]   SRAM_readAddr_addr;
    wire            SRAM_readAddr_valid;
    wire            SRAM_readAddr_ready;
    wire  [127:0]   SRAM_readData_data;
    wire            SRAM_readData_valid;
    wire            SRAM_readData_ready;
        // write port
    wire   [31:0]   SRAM_writeAddr_addr;
    wire            SRAM_writeAddr_valid;
    wire            SRAM_writeAddr_ready;
    wire   [127:0]  SRAM_writeData_data;
    wire   [15:0]   SRAM_writeData_strb;
    wire            SRAM_writeData_valid;
    wire            SRAM_writeData_ready;
    wire  [31:0]    SRAM_writeResp_msg;
    wire            SRAM_writeResp_valid;
    wire            SRAM_writeResp_ready;
    
    AXILite4_Mux bus(.clk(clk), .rst(rst),
        // read bus
            // master 1 - Inst cache
        .master_1_readAddr_addr(Inst_Cahe_readAddr_addr),
        .master_1_readAddr_valid(Inst_Cahe_readAddr_valid),
        .master_1_readAddr_ready(Inst_Cahe_readAddr_ready),
        .master_1_readData_data(Inst_Cahe_readData_data),
        .master_1_readData_valid(Inst_Cahe_readData_valid),
        .master_1_readData_ready(Inst_Cahe_readData_ready),
            // master 2 - Data cache
        .master_2_readAddr_addr(Data_Cahe_readAddr_addr),
        .master_2_readAddr_valid(Data_Cahe_readAddr_valid),
        .master_2_readAddr_ready(Data_Cahe_readAddr_ready),
        .master_2_readData_data(Data_Cahe_readData_data),
        .master_2_readData_valid(Data_Cahe_readData_valid),
        .master_2_readData_ready(Data_Cahe_readData_ready),
            // slave
        .slave_readAddr_addr(SRAM_readAddr_addr),
        .slave_readAddr_valid(SRAM_readAddr_valid),
        .slave_readAddr_ready(SRAM_readAddr_ready),
        .slave_readData_data(SRAM_readData_data),
        .slave_readData_valid(SRAM_readData_valid),
        .slave_readData_ready(SRAM_readData_ready),

        // write bus
            // master 1
        .master_1_writeAddr_addr(Inst_Cahe_writeAddr_addr),
        .master_1_writeAddr_valid(Inst_Cahe_writeAddr_valid),
        .master_1_writeAddr_ready(Inst_Cahe_writeAddr_ready),
        .master_1_writeData_data(Inst_Cahe_writeData_data),
        .master_1_writeData_strb(Inst_Cahe_writeData_strb),
        .master_1_writeData_valid(Inst_Cahe_writeData_valid),
        .master_1_writeData_ready(Inst_Cahe_writeData_ready),
        .master_1_writeResp_msg(Inst_Cahe_writeResp_msg),
        .master_1_writeResp_valid(Inst_Cahe_writeResp_valid),
        .master_1_writeResp_ready(Inst_Cahe_writeResp_ready),
            // master 2
        .master_2_writeAddr_addr(Data_Cahe_writeAddr_addr),
        .master_2_writeAddr_valid(Data_Cahe_writeAddr_valid),
        .master_2_writeAddr_ready(Data_Cahe_writeAddr_ready),
        .master_2_writeData_data(Data_Cahe_writeData_data),
        .master_2_writeData_strb(Data_Cahe_writeData_strb),
        .master_2_writeData_valid(Data_Cahe_writeData_valid),
        .master_2_writeData_ready(Data_Cahe_writeData_ready),
        .master_2_writeResp_msg(Data_Cahe_writeResp_msg),
        .master_2_writeResp_valid(Data_Cahe_writeResp_valid),
        .master_2_writeResp_ready(Data_Cahe_writeResp_ready),
            // slave
        .slave_writeAddr_addr(SRAM_writeAddr_addr),
        .slave_writeAddr_valid(SRAM_writeAddr_valid),
        .slave_writeAddr_ready(SRAM_writeAddr_ready),
        .slave_writeData_data(SRAM_writeData_data),
        .slave_writeData_strb(SRAM_writeData_strb),
        .slave_writeData_valid(SRAM_writeData_valid),
        .slave_writeData_ready(SRAM_writeData_ready),
        .slave_writeResp_msg(SRAM_writeResp_msg),
        .slave_writeResp_valid(SRAM_writeResp_valid),
        .slave_writeResp_ready(SRAM_writeResp_ready)
    );
    CPU #(.memAddrWidth(16))cpu(.clk(clk), .rst(rst), .Hcf(Hcf),
        // Inst Cache - AXI Lite 4 master IO
            // read port
        .Inst_Cahe_readAddr_addr(Inst_Cahe_readAddr_addr),
        .Inst_Cahe_readAddr_valid(Inst_Cahe_readAddr_valid),
        .Inst_Cahe_readAddr_ready(Inst_Cahe_readAddr_ready),
        .Inst_Cahe_readData_data(Inst_Cahe_readData_data),
        .Inst_Cahe_readData_valid(Inst_Cahe_readData_valid),
        .Inst_Cahe_readData_ready(Inst_Cahe_readData_ready),
            // write port
        .Inst_Cahe_writeAddr_addr(Inst_Cahe_writeAddr_addr),
        .Inst_Cahe_writeAddr_valid(Inst_Cahe_writeAddr_valid),
        .Inst_Cahe_writeAddr_ready(Inst_Cahe_writeAddr_ready),
        .Inst_Cahe_writeData_data(Inst_Cahe_writeData_data),
        .Inst_Cahe_writeData_strb(Inst_Cahe_writeData_strb),
        .Inst_Cahe_writeData_valid(Inst_Cahe_writeData_valid),
        .Inst_Cahe_writeData_ready(Inst_Cahe_writeData_ready),
        .Inst_Cahe_writeResp_msg(Inst_Cahe_writeResp_msg),
        .Inst_Cahe_writeResp_valid(Inst_Cahe_writeResp_valid),
        .Inst_Cahe_writeResp_ready(Inst_Cahe_writeResp_ready),

        // Data Cache - AXI Lite 4 master IO
            // read port
        .Data_Cahe_readAddr_addr(Data_Cahe_readAddr_addr),
        .Data_Cahe_readAddr_valid(Data_Cahe_readAddr_valid),
        .Data_Cahe_readAddr_ready(Data_Cahe_readAddr_ready),
        .Data_Cahe_readData_data(Data_Cahe_readData_data),
        .Data_Cahe_readData_valid(Data_Cahe_readData_valid),
        .Data_Cahe_readData_ready(Data_Cahe_readData_ready),
            // write port
        .Data_Cahe_writeAddr_addr(Data_Cahe_writeAddr_addr),
        .Data_Cahe_writeAddr_valid(Data_Cahe_writeAddr_valid),
        .Data_Cahe_writeAddr_ready(Data_Cahe_writeAddr_ready),
        .Data_Cahe_writeData_data(Data_Cahe_writeData_data),
        .Data_Cahe_writeData_strb(Data_Cahe_writeData_strb),
        .Data_Cahe_writeData_valid(Data_Cahe_writeData_valid),
        .Data_Cahe_writeData_ready(Data_Cahe_writeData_ready),
        .Data_Cahe_writeResp_msg(Data_Cahe_writeResp_msg),
        .Data_Cahe_writeResp_valid(Data_Cahe_writeResp_valid),
        .Data_Cahe_writeResp_ready(Data_Cahe_writeResp_ready)
    );
    SRAM memory(.clk(clk), .rst(rst),
        // SRAM -  AXI Lite 4 slave IO
            // read port 
        .readAddr_addr(SRAM_readAddr_addr),
        .readAddr_valid(SRAM_readAddr_valid),
        .readAddr_ready(SRAM_readAddr_ready),
        .readData_data(SRAM_readData_data),
        .readData_valid(SRAM_readData_valid),
        .readData_ready(SRAM_readData_ready),
            // write port
        .writeAddr_addr(SRAM_writeAddr_addr),
        .writeAddr_valid(SRAM_writeAddr_valid),
        .writeAddr_ready(SRAM_writeAddr_ready),
        .writeData_data(SRAM_writeData_data),
        .writeData_strb(SRAM_writeData_strb),
        .writeData_valid(SRAM_writeData_valid),
        .writeData_ready(SRAM_writeData_ready),
        .writeResp_msg(SRAM_writeResp_msg),
        .writeResp_valid(SRAM_writeResp_valid),
        .writeResp_ready(SRAM_writeResp_ready)
    );

endmodule
