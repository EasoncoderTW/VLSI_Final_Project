module ValidRam(clk, rst, w_en, Index, ValidIn, ValidOut);
    input clk, rst, w_en;
    input [`INDEX_LENGTH-1:0] Index;
    input ValidIn;
    output wire ValidOut;
    
    integer i;
    reg [`CACHE_LINE_NUM-1:0] ValidMEM;

    //Read tags
    assign ValidOut = ValidMEM[Index];

    //Update tags
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            ValidMEM <= `CACHE_LINE_NUM'h0000;
        end
        else begin
            if(w_en) ValidMEM[Index] <= ValidIn;
            else     ValidMEM <= ValidMEM;
        end
    end
endmodule