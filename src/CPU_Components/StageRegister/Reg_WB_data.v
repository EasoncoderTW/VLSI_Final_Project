module Reg_WB #(parameter addrWidth = 15)( 
    input clk, 
    input rst,
    input Stall,
    input [1:0]WB_Hazard_in, 
    input [31:0]wb_data_in, 
    output wire [1:0]WB_Hazard,
    output wire [31:0]wb_data,
);

reg [1:0]WB_Hazard_Reg;
reg [31:0]wb_data_Reg;

wire [1:0]WB_Hazard_next;
wire [31:0]wb_data_next;

/* combinational circuit*/
assign WB_Hazard_next = (stall)?WB_Hazard_Reg:WB_Hazard_in;
assign wb_data_next = (stall)?wb_data_Reg:wb_data_in;

/* output */
assign WB_Hazard = WB_Hazard_next;
assign wb_data = wb_data_next;

/* sequencial ciruit */
always @(posedge clk or posedge rst) begin
    if(rst)begin
        WB_Hazard_Reg <= 2'd0;
        wb_data_Reg <= 32'd0;
    end
    else begin
        WB_Hazard_Reg <= WB_Hazard_next;
        wb_data_Reg <= wb_data_next;
    end
end

endmodule
