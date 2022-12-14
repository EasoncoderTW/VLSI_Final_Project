module SRAM(
    input clk,
    /* To be modified IO*/
    input w_en, 
    input [15:0]w_mask, // write enable for 16 bytes
    input [15:0] address, 
    input [511:0] write_data, // 4 words = 16 bytes = 512 bits
    output reg [511:0] read_data, 
    output reg r_en
);

// memory
reg [7:0] mem [0:65535];

// write
always @(posedge clk ) begin
    integer i;
    for(i=0;i<16;i = i+1) begin
        if(w_en & w_mask[i])begin
            mem[address+i] <= write_data[7+8*i:0+8*i];
        end
    end
end

// read
always @(*) begin
    read_data = {
        mem[address+16'd15],
        mem[address+16'd14],
        mem[address+16'd13],
        mem[address+16'd12],
        mem[address+16'd11],
        mem[address+16'd10],
        mem[address+16'd9],
        mem[address+16'd8],
        mem[address+16'd7],
        mem[address+16'd6],
        mem[address+16'd5],
        mem[address+16'd4],
        mem[address+16'd3],
        mem[address+16'd2],
        mem[address+16'd1],
        mem[address]
    }; 
end

endmodule
