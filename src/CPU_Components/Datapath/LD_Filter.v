`include "./CPU_Components/rv32_define.v"

module LD_Filter (
    input [2:0] width,
    input [31:0] ld_data,
    output reg [31:0] ld_data_f
);

always @(*) begin
    case(width)
    `Byte:    ld_data_f = {{24{ld_data[7]}}, ld_data[7:0]};
    `Half:    ld_data_f = {{16{ld_data[15]}}, ld_data[15:0]};
    `Word:    ld_data_f = ld_data;
    `UByte:   ld_data_f = {24'd0, ld_data[7:0]};
    `UHalf:   ld_data_f = {16'd0, ld_data[15:0]};
    default: ld_data_f = 32'd0;
    endcase
end

endmodule
