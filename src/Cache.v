//##########################################################
//# Module name : CACHE                                    #
//# Date : 2022.12.22                                      #
//# Spec :                                                 #
//# (1) cache line size : 16 bytes                         #
//# (2) # of cache line : 16                               #
//# (3) tag bits : 8                                       #
//# (4) 256 bytes cache size mapping to 64 KB memory space #
//##########################################################
`include "./Cache_Components/Gen_Cache_Line_Data_Strb.v"
`include "./Cache_Components/ValidRam.v"
`include "./Cache_Components/TagRam.v"
`include "./Cache_Components/Comparator.v"
`include "./Cache_Components/DataRam.v"
`include "./Cache_Components/Cache_Controller.v"
`include "./Cache_Components/Data16Mux.v"
`include "./Cache_Components/Data32Mux4to1.v"
`include "./Cache_Components/Data128Mux.v"
`include "./Cache_Components/Cache_define_macro.v"


module Cache(
    input clk,
    input rst, 
    /* CPU IO */
    input r_en,       //
    input [3:0] w_en, // write enable for 4 bytes
    input [15:0] address,
    input [31:0] write_data,
    output [31:0] read_data,
    output ready,
    /* AXI Lite 4 IO */
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

// declare the wire
wire [`CACHE_LINE_BIT_LENGTH-1:0] cache_line_data;
wire [`CACHE_LINE_SIZE-1:0] cache_line_strb;
wire w_validram, w_tagram, w_dataram;
wire validin;
wire dataram_sel;
wire [`CACHE_LINE_BIT_LENGTH-1:0] dataram_datain;
wire [`CACHE_LINE_BIT_LENGTH-1:0] dataram_dataout;
wire [15:0] dataram_strb;
wire cache_line_valid;
wire [7:0] cache_line_tag;
wire match, hit;

Gen_Cache_Line_Data_Strb Gen_Cache_Line_Data_Strb(
    .p_w_en(w_en), 
    .offset(address[3:2]), 
    .write_data(write_data), 
    .cache_line_data(cache_line_data), 
    .cache_line_strb(cache_line_strb)
    );

// assign value to system bus
assign readAddr_addr = {16'h0000, (address & `WORD'hfff0)};
assign writeAddr_addr = {16'h0000, (address & `WORD'hfff0)};
assign writeData_data = cache_line_data;
assign writeData_strb = cache_line_strb;

ValidRam ValidRam(
    .clk(clk), .rst(rst), .w_en(w_validram), .Index(address[7:4]), 
    .ValidIn(validin), .ValidOut(cache_line_valid)
    );

TagRam TagRam(
    .clk(clk), .rst(rst), .w_en(w_tagram), .Index(address[7:4]), 
    .TagIn(address[15:8]), .TagOut(cache_line_tag));

DataRam DataRam(
    .clk(clk), .rst(rst), .w_en(w_dataram), .Index(address[7:4]), 
    .DataIn(dataram_datain), .DataStrb(dataram_strb), .DataOut(dataram_dataout)
    );

Comparator Comparator(.Tag1(cache_line_tag), .Tag2(address[15:8]), .Match(match));

assign hit = match & cache_line_valid;

Cache_Controller Cache_Controller(
    .clk(clk), .rst(rst), .p_w_en(w_en), .p_r_en(r_en), .hit(hit), //input
    .readAddr_ready(readAddr_ready), .readData_valid(readData_valid), 
    .writeAddr_ready(writeAddr_ready), .writeData_ready(writeData_ready), .writeResp_valid(writeResp_valid),
    .writeResp_msg(writeResp_msg),
    .readAddr_valid(readAddr_valid), .readData_ready(readData_ready), //output
    .writeAddr_valid(writeAddr_valid), .writeData_valid(writeData_valid), .writeResp_ready(writeResp_ready), 
    .dataram_sel(dataram_sel), .p_ready(ready), .w_tagram(w_tagram), .w_validram(w_validram), .w_dataram(w_dataram), .validin(validin)
    );

Data16Mux Data16Mux(.sel(dataram_sel), .A(cache_line_strb), .B(16'hffff), .out(dataram_strb));

// DataRam flow out a cache line in one read
// Thus, we have to choose which word to flow into our processor
Data32Mux4to1 Data32Mux4to1(
    .sel(address[3:2]), 
    .A(dataram_dataout[31:0]), 
    .B(dataram_dataout[63:32]), 
    .C(dataram_dataout[95:64]), 
    .D(dataram_dataout[127:96]),
    .out(read_data)
    );

// select the data from processor or the data from system bus to get into DataRam
Data128Mux Data128Mux(.sel(dataram_sel), .A(cache_line_data), .B(readData_data), .out(dataram_datain));

endmodule