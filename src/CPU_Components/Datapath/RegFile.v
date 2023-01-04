module RegFile(
    input clk,
    input wb_en,
    input [31:0]wb_data,
    input [4:0]rd_index,
    input [4:0]rs1_index,
    input [4:0]rs2_index,
    output reg [31:0]rs1_data_out,
    output reg [31:0]rs2_data_out
);

reg [31:0] registers [0:31];

always @(posedge clk ) begin
    if(wb_en && rd_index != 5'd0)begin
        registers[rd_index] <= wb_data;
    end
end

always@(*)begin
  rs1_data_out = (rs1_index==5'd0)?(32'd0):registers[rs1_index];
end

always@(*)begin
  rs2_data_out = (rs2_index==5'd0)?(32'd0):registers[rs2_index];
end

endmodule