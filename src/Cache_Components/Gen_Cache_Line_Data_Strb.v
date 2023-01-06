`include "./Cache_Components/Cache_define_macro.v"
module Gen_Cache_Line_Data_Strb(p_w_en, offset, write_data, cache_line_data, cache_line_strb);
input [3:0] p_w_en; // the write mask from the processor 
input [1:0] offset; // indicate the write_data's location in a cache line
input [`WORD-1:0] write_data; // the data from the processor

output reg [`CACHE_LINE_BIT_LENGTH-1:0] cache_line_data;
output reg [`CACHE_LINE_SIZE-1:0] cache_line_strb;

wire [`WORD-1:0]mask;
assign mask = {{8{p_w_en[3]}}, {8{p_w_en[2]}}, {8{p_w_en[1]}}, {8{p_w_en[0]}}};

// generate cache_line_data & cache_line_strb
always@(*)begin
    case(offset)
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
        cache_line_data = {`WORD'h0, `WORD'h0, `WORD'h0, (mask & write_data)};
        cache_line_strb = {4'h0, 4'h0, 4'h0, p_w_en};
    end
    endcase
end
endmodule
