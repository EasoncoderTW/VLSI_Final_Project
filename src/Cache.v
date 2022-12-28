//##########################################################
//# Module name : CACHE                                    #
//# Date : 2022.12.22                                      #
//# Spec :                                                 #
//# (1) cache line size : 16 bytes                         #
//# (2) # of cache line : 16                               #
//# (3) tag bits : 8                                       #
//# (4) 256 bytes cache size mapping to 64 KB memory space #
//##########################################################

`define WORD 32
`define OFFSET_LENGTH 4
`define CACHE_LINE_SIZE (1<<`OFFSET_LENGTH)
`define CACHE_LINE_BIT_LENGTH (`CACHE_LINE_SIZE<<3)
`define INDEX_LENGTH 4
`define CACHE_LINE_NUM (1<<`INDEX_LENGTH)
`define REG_NUM (`CACHE_LINE_NUM<<2)
`define TAG_LENGTH 8
module Cache(
    input clk,
    input rst, 
    /* CPU IO */
    input r_en;       //
    input [3:0] w_en; // write enable for 4 bytes
    input [15:0] address;
    input [31:0] write_data;
    output [31:0] read_data;
    output ready;
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
Data32Mux Data32Mux(
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

module Gen_Cache_Line_Data_Strb(p_w_en, offset, write_data, cache_line_data, cache_line_strb);
input [3:0] p_w_en; // the write mask from the processor 
input [1:0] offset; // indicate the write_data's location in a cache line
input [`WORD-1:0] write_data; // the data from the processor

output reg [`CACHE_LINE_BIT_LENGTH-1:0] cache_line_data;
output reg [`CACHE_LINE_SIZE-1:0] cache_line_strb;

wire mask = {8{p_w_en[3]}, 8{p_w_en[2]}, 8{p_w_en[1]}, 8{p_w_en[0]}};

// generate cache_line_data & cache_line_strb
always@(*)begin
    case(offset)
    2'b00: begin
        cache_line_data = {`WORD'h0, `WORD'h0, `WORD'h0, (mask & write_data)};
        cache_line_strb = {4'h0, 4'h0, 4'h0, p_w_en};
    end
    2'b01: begin
        cache_line_data = {`WORD'h0, `WORD'h0, (mask & write_data), `WORD'h0};
        cache_line_strb = {4'h0, 4'h0, p_w_en, 4'h0};
    end
    2'b10: begin
        cache_line_data = {`WORD'h0, (mask & write_data), `WORD'h0, `WORD'h0};
        cache_line_strb = {4'h0, p_w_en, 4'h0, 4'h0};
    end
    2'b11: begin
        cache_line_data = {(mask & write_data), `WORD'h0, `WORD'h0, `WORD'h0};
        cache_line_strb = {p_w_en, 4'h0, 4'h0, 4'h0};
    end
    default: begin
        cache_line_data = `CACHE_LINE_BIT_LENGTH'h0;
        cache_line_strb = 16'h0;
    end
    endcase
end
endmodule

module Cache_Controller(clk, rst, p_w_en, p_r_en, hit, //input
                        readAddr_ready, readData_valid, writeAddr_ready, writeData_ready, writeResp_valid,
                        readAddr_valid, readData_ready, writeAddr_valid, writeData_valid, writeResp_ready, //output
                        dataram_sel, p_ready, w_tagram, w_validram, w_dataram, validin
                        );
input clk, rst;
input [3:0] p_w_en; // w_en from the processor
input p_r_en;       // r_en from the processor
input hit;        // high when cache hit 

// system bus ready & valid signals
input readAddr_ready, 
      readData_valid, 
      writeAddr_ready, 
      writeData_ready, 
      writeResp_valid;
      
input [31:0] writeResp_msg;

output reg readAddr_valid, 
           readData_ready, 
           writeAddr_valid, 
           writeData_valid, 
           writeResp_ready;

output reg dataram_sel;         // signal to select the data to update the DataRam
output reg p_ready;             // ready to the processor.
output reg w_tagram,            // signal to enable RAMs write operation.
           w_validram,
           w_dataram;
output reg validin;             // valid signal to update validram 

parameter S_IDLE                = 0, 
          S_READ_HIT            = 1,
          S_READ_MISS           = 2, 
          S_READ_SYS_UPD_CACHE  = 3,
          S_WRITE_HIT           = 4,
          S_WRITE_MISS          = 5,
          S_WRITE_SYS           = 6,
          S_WRITE_SYS_UPD_CACHE = 7;

// declare reg
reg [2:0] StateReg, 
          NextState;

//declare wire
wire write = |p_w_en;
wire read  = p_r_en;

// Update StateReg
always@(posedge clk) begin
    if(rst) StateReg <= S_IDLE;
    else    StateReg <= NextState;
end

// Next State Equation
always@(*) begin
    case (StateReg)
    S_IDLE       : begin
        case ({read, write, hit})
        3'b101 : NextState <= S_READ_HIT;   // read hit
        3'b100 : NextState <= S_READ_MISS;  // read miss
        3'b011 : NextState <= S_WRITE_HIT;  // write hit
        3'b010 : NextState <= S_WRITE_MISS; // write miss
        default: NextState <= S_IDLE;      // default
        endcase
    end
    S_READ_HIT           : NextState <= S_IDLE;
    S_READ_MISS          : NextState <= (readAddr_ready)? S_READ_SYS_UPD_CACHE : S_READ_MISS;
    S_READ_SYS_UPD_CACHE : NextState <= (readData_valid)? S_IDLE : S_READ_SYS_UPD_CACHE;
    S_WRITE_HIT          : NextState <= (writeAddr_ready & writeData_ready)? S_WRITE_SYS_UPD_CACHE : S_WRITE_HIT;
    S_WRITE_SYS_UPD_CACHE: NextState <= (writeResp_valid)? S_IDLE : S_WRITE_SYS_UPD_CACHE;
    S_WRITE_MISS         : NextState <= (writeAddr_ready & writeData_ready)? S_WRITE_SYS : S_WRITE_MISS;
    S_WRITE_SYS          : NextState <= (writeResp_valid)? S_IDLE : S_WRITE_SYS;
    default              : NextState <= S_IDLE;
    endcase
end

// Output Equation
always@(*) begin
    case(StateReg)
    S_IDLE                : begin
        p_ready = 1'b0;                             // don't care
        readAddr_valid = 1'b0;                      // don't care
        readData_ready = 1'b0;                      // don't care
        {w_validram, w_tagram, w_dataram} = 3'b000; // don't care
        validin = 1'b0;                             // don't care
        dataram_sel    = 1'b0;                      // don't care
        writeAddr_valid = 1'b0;                     // don't care
        writeData_valid = 1'b0;                     // don't care
        writeResp_ready = 1'b0;                     // don't care
    end
    S_READ_HIT            : begin
        p_ready = 1'b1;
        readAddr_valid = 1'b0;                      // don't care
        readData_ready = 1'b0;                      // don't care
        {w_validram, w_tagram, w_dataram} = 3'b000; // don't care
        validin = 1'b0;                             // don't care
        dataram_sel    = 1'b0;                      // don't care
        writeAddr_valid = 1'b0;                     // don't care
        writeData_valid = 1'b0;                     // don't care
        writeResp_ready = 1'b0;                     // don't care
    end
    S_READ_MISS           : begin
        p_ready = 1'b0;                             // don't care
        readAddr_valid = 1'b1;                  
        readData_ready = 1'b0;                      // don't care
        {w_validram, w_tagram, w_dataram} = 3'b000; // don't care
        validin = 1'b0;                             // don't care
        dataram_sel    = 1'b0;                      // don't care
        writeAddr_valid = 1'b0;                     // don't care
        writeData_valid = 1'b0;                     // don't care
        writeResp_ready = 1'b0;                     // don't care
    end
    S_READ_SYS_UPD_CACHE  : begin
        p_ready = (readData_valid)? 1'b1 : 1'b0;
        readAddr_valid = 1'b0;                      // don't care
        readData_ready = 1'b1;
        {w_validram, w_tagram, w_dataram} = (readData_valid)? 3'b111 : 3'b000;
        validin = 1'b1;
        dataram_sel    = 1'b0;
        writeAddr_valid = 1'b0;                     // don't care
        writeData_valid = 1'b0;                     // don't care
        writeResp_ready = 1'b0;                     // don't care
    end
    S_WRITE_HIT           : begin
        p_ready = 1'b0;                             // don't care
        readAddr_valid = 1'b0;                      // don't care
        readData_ready = 1'b0;                      // don't care
        {w_validram, w_tagram, w_dataram} = 3'b000; // don't care
        validin = 1'b0;                             // don't care
        dataram_sel    = 1'b0;                      // don't care
        writeAddr_valid = 1'b1; 
        writeData_valid = 1'b1;
        writeResp_ready = 1'b0;                     // don't care
    end
    S_WRITE_SYS_UPD_CACHE : begin
        p_ready = (writeResp_valid)? 1'b1 : 1'b0;
        readAddr_valid = 1'b0;                      // don't care
        readData_ready = 1'b0;                      // don't care
        {w_validram, w_tagram, w_dataram} = (writeResp_valid)? 3'b001 : 3'b000; 
        validin = 1'b0;                             // don't care
        dataram_sel = 1'b1;
        writeAddr_valid = 1'b0;                     // don't care
        writeData_valid = 1'b0;                     // don't care
        writeResp_ready = 1'b1;
    end
    S_WRITE_MISS          : begin
        p_ready = 1'b0;                             // don't care
        readAddr_valid = 1'b0;                      // don't care
        readData_ready = 1'b0;                      // don't care
        {w_validram, w_tagram, w_dataram} = 3'b000; // don't care
        validin = 1'b0;                             // don't care
        dataram_sel    = 1'b0;                      // don't care
        writeAddr_valid = 1'b1;
        writeData_valid = 1'b1;
        writeResp_ready = 1'b0;                     // don't care
    end
    S_WRITE_SYS           : begin
        p_ready = (writeResp_valid)? 1'b1 : 1'b0;
        readAddr_valid = 1'b0;                      // don't care
        readData_ready = 1'b0;                      // don't care
        {w_validram, w_tagram, w_dataram} = 3'b000; // don't care
        validin = 1'b0;                             // don't care
        dataram_sel    = 1'b0;                      // don't care
        writeAddr_valid = 1'b0;                     // don't care
        writeData_valid = 1'b0;                     // don't care
        writeResp_ready = 1'b1;
    end
    default               : begin
        p_ready = 1'b0;                             // don't care
        readAddr_valid = 1'b0;                      // don't care
        readData_ready = 1'b0;                      // don't care
        {w_validram, w_tagram, w_dataram} = 3'b000; // don't care
        validin = 1'b0;                             // don't care
        dataram_sel    = 1'b0;                      // don't care
        writeAddr_valid = 1'b0;                     // don't care
        writeData_valid = 1'b0;                     // don't care
        writeResp_ready = 1'b0;                     // don't care
    end
    endcase
end
endmodule


/*
MUX :
if sel == 1      then A flows out.
else if sel == 0 then B flows out.
*/

module Data16Mux(sel, A, B, out);
input sel; //Select Line
input [15:0] A, B;
output [15:0] out;

assign out = sel ? A : B;

endmodule

module Data32Mux4to1(sel, A, B, C, D, out);
input [1:0] sel; //Select Line
input [`WORD-1:0] A, B, C, D;
output reg [`WORD-1:0] out;

always@(*)begin
    case(sel)
    2'b00: out = A;
    2'b01: out = B;
    2'b10: out = C;
    2'b11: out = D;
    endcase
end

endmodule

/*
MUX :
if sel == 1      then A flows out.
else if sel == 0 then B flows out.
*/
module Data128Mux(sel, A, B, out);
input sel; //Select Line
input [`CACHE_LINE_BIT_LENGTH-1:0] A, B;
output [`CACHE_LINE_BIT_LENGTH-1:0] out;

assign out = sel ? A : B;

endmodule


module Comparator(Tag1, Tag2, Match);
input [`TAG_LENGTH-1:0] Tag1;
input [`TAG_LENGTH-1:0] Tag2;
output Match;
assign Match = (Tag1 == Tag2);
endmodule


/*Arch.
little endian for each of the cache lines.

| WORD 3 | WORD 2 | WORD 1 | WORD 0 | 
+ ------ + ------ + ------ + ------ +
|        |        |        |        | ---> CACHE LINE #0
+--------+--------+--------+--------+
|        |        |        |        | ---> CACHE LINE #1
+--------+--------+--------+--------+
|        |        |        |        | ---> CACHE LINE #2
+--------+--------+--------+--------+
                ...
                ...
                ...
+--------+--------+--------+--------+
|        |        |        |        | ---> CACHE LINE #15
+--------+--------+--------+--------+

*/

module DataRam(clk, rst, w_en, Index, DataIn, DataStrb, DataOut);
input clk, rst, w_en;
input [`INDEX_LENGTH-1:0] Index;
input [`CACHE_LINE_BIT_LENGTH-1:0] DataIn;
input [`CACHE_LINE_SIZE-1:0] DataStrb;
output [`CACHE_LINE_BIT_LENGTH-1:0] DataOut;

integer i;
reg [`WORD-1:0] DataMEM [0:`REG_NUM-1];
wire [3:0] word_wen;
wire [`WORD-1:0] DataIn_Word0, 
                 DataIn_Word1, 
                 DataIn_Word2, 
                 DataIn_Word3;

wire [`WORD-1:0] mask0, 
                 mask1, 
                 mask2, 
                 mask3;

// compute the word write enable signals
assign word_wen[0] = |DataStrb[3:0];
assign word_wen[1] = |DataStrb[7:4];
assign word_wen[2] = |DataStrb[11:8];
assign word_wen[3] = |DataStrb[15:12];

// generate the mask 
assign mask0 = {8{DataStrb[3]}, 8{DataStrb[2]}, 8{DataStrb[1]}, 8{DataStrb[0]}};
assign mask1 = {8{DataStrb[7]}, 8{DataStrb[6]}, 8{DataStrb[5]}, 8{DataStrb[4]}};
assign mask2 = {8{DataStrb[11]}, 8{DataStrb[10]}, 8{DataStrb[9]}, 8{DataStrb[8]}};
assign mask3 = {8{DataStrb[15]}, 8{DataStrb[14]}, 8{DataStrb[13]}, 8{DataStrb[12]}};

// generate the value we want to write into cache line
assign DataIn_Word0 = (DataMEM[{Index, 2'b00}] & (~mask0)) | (DataIn[31:0] & mask0);
assign DataIn_Word1 = (DataMEM[{Index, 2'b01}] & (~mask1)) | (DataIn[63:32] & mask1);
assign DataIn_Word2 = (DataMEM[{Index, 2'b10}] & (~mask2)) | (DataIn[95:64] & mask2);
assign DataIn_Word3 = (DataMEM[{Index, 2'b11}] & (~mask3)) | (DataIn[127:96] & mask3);

// Read a cache line (4 words) out
assign DataOut = {DataMEM[{Index, 2'b11}], DataMEM[{Index, 2'b10}], DataMEM[{Index, 2'b01}], DataMEM[{Index, 2'b00}]};

// Write a cache line
always @ (posedge clk) begin
    if (rst)
        for(i=0; i<`REG_NUM; i=i+1)
            DataMEM[i] <= `WORD'h0000_0000;
    else begin
        if(w_en) begin
            // # Index cache line's word 0 update
            DataMEM[{Index, 2'b00}] <= (word_wen[0])? DataIn_Word0 : DataMEM[{Index, 2'b00}];
            DataMEM[{Index, 2'b01}] <= (word_wen[1])? DataIn_Word1 : DataMEM[{Index, 2'b01}];
            DataMEM[{Index, 2'b10}] <= (word_wen[2])? DataIn_Word2 : DataMEM[{Index, 2'b10}];
            DataMEM[{Index, 2'b11}] <= (word_wen[3])? DataIn_Word3 : DataMEM[{Index, 2'b11}];
        end
        else begin
            for(i=0; i<`REG_NUM; i=i+1)
                DataMEM[i] <= DataMEM[i];
        end
    end
end


endmodule


module TagRam(clk, rst, w_en, Index, TagIn, TagOut);
    input clk, rst, w_en;
    input [`INDEX_LENGTH-1:0] Index;
    input [`TAG_LENGTH-1:0] TagIn;
    output [`TAG_LENGTH-1:0] TagOut;
    
    integer i;
    reg [`TAG_LENGTH-1:0] TagMEM [0:`CACHE_LINE_NUM-1];

    //Read tags
    assign TagOut = TagMEM[Index];

    //Update tags
    always@(posedge clk) begin
        if(rst) 
            for(i=0; i<`CACHE_LINE_NUM; i=i+1)
                TagMEM[i] <= `TAG_LENGTH'b0;
        else begin
            if(w_en) TagMEM[Index] <= TagIn;
            else
                for(i=0; i<`CACHE_LINE_NUM; i=i+1)
                    TagMEM[i] <= TagMEM[i];
        end
    end
endmodule


module ValidRam(clk, rst, w_en, Index, ValidIn, ValidOut);
    input clk, rst, w_en;
    input [`INDEX_LENGTH-1:0] Index;
    input ValidIn;
    output ValidOut;
    
    integer i;
    reg [`CACHE_LINE_NUM-1:0] ValidMEM;

    //Read tags
    assign ValidOut = ValidMEM[Index];

    //Update tags
    always@(posedge clk) begin
        if(rst) begin
            ValidMEM <= `CACHE_LINE_NUM'h0000;
        end
        else begin
            if(w_en) ValidMEM[Index] <= ValidIn;
            else     ValidMEM <= ValidMEM;
        end
    end
endmodule