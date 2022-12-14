module Reg_PC(
    input clk,
    input rst,
    input stall,
    input [31:0] next_pc,
    output reg [31:0] current_pc
);

reg [31:0]pc;
/* combinational circuit */
always @(*) begin
    pc = (stall)?current_pc:next_pc;
end

/* sequentail citcuit */
always @(posedge clk or posedge rst) begin
    if(rst)begin
        current_pc <= 32'd0;
    end
    else begin
        current_pc <= pc;
    end
end

endmodule
