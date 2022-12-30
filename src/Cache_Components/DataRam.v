`include "./Cache_Components/Cache_define_macro.v"
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
assign mask0 = {{8{DataStrb[3]}}, {8{DataStrb[2]}}, {8{DataStrb[1]}}, {8{DataStrb[0]}}};
assign mask1 = {{8{DataStrb[7]}}, {8{DataStrb[6]}}, {8{DataStrb[5]}}, {8{DataStrb[4]}}};
assign mask2 = {{8{DataStrb[11]}}, {8{DataStrb[10]}}, {8{DataStrb[9]}}, {8{DataStrb[8]}}};
assign mask3 = {{8{DataStrb[15]}}, {8{DataStrb[14]}}, {8{DataStrb[13]}}, {8{DataStrb[12]}}};

// generate the value we want to write into cache line
assign DataIn_Word0 = (DataMEM[{Index, 2'b00}] & (~mask0)) | (DataIn[31:0] & mask0);
assign DataIn_Word1 = (DataMEM[{Index, 2'b01}] & (~mask1)) | (DataIn[63:32] & mask1);
assign DataIn_Word2 = (DataMEM[{Index, 2'b10}] & (~mask2)) | (DataIn[95:64] & mask2);
assign DataIn_Word3 = (DataMEM[{Index, 2'b11}] & (~mask3)) | (DataIn[127:96] & mask3);

// Read a cache line (4 words) out
assign DataOut = {DataMEM[{Index, 2'b11}], DataMEM[{Index, 2'b10}], DataMEM[{Index, 2'b01}], DataMEM[{Index, 2'b00}]};

// Write a cache line
always @ (posedge clk or posedge rst) begin
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