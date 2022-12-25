/*
    The Master and Slave module here are just AXI Lite 4 interface examples.
    DO NOT include this file for any simulation or synthesis.
*/

module AXILite4_Master (
    // read port
    output  [31:0]  readAddr_addr,
    output          readAddr_valid,
    input           readAddr_ready,
    input   [127:0] readData_data,
    input           readData_valid,
    output          readData_ready,
    // write port
    output  [31:0]  writeAddr_addr,
    output          writeAddr_valid,
    input           writeAddr_ready,
    output  [127:0] writeData_data,
    output  [15:0]  writeData_strb,
    output          writeData_valid,
    input           writeData_ready,
    input   [31:0]  writeResp_msg,
    input           writeResp_valid,
    output          writeResp_ready
);

endmodule

module AXILite4_Slave (
    // read port
    input   [31:0]  readAddr_addr,
    input           readAddr_valid,
    output          readAddr_ready,
    output  [127:0] readData_data,
    output          readData_valid,
    input           readData_ready,
    // write port
    input   [31:0]  writeAddr_addr,
    input           writeAddr_valid,
    output          writeAddr_ready,
    input   [127:0] writeData_data,
    input   [15:0]  writeData_strb,
    input           writeData_valid,
    output          writeData_ready,
    output  [31:0]  writeResp_msg,
    output          writeResp_valid,
    input           writeResp_ready
);

endmodule
