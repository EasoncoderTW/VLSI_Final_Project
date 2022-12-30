`include "./Cache_Components/Cache_define_macro.v"
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
    always@(posedge clk or posedge rst) begin
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