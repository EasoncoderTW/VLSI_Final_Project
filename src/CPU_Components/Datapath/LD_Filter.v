`include "./CPU_Components/rv32_define.v"

module LD_Filter (
    input [2:0] width,
    input [31:0] ld_data,
    output wire [31:0] ld_data_f
);


assign ld_data_f = (width == `Byte)? {{24{ld_data[7]}}, ld_data[7:0]}:
                   (width == `Half)? {{16{ld_data[15]}}, ld_data[15:0]}:
                   (width == `Word)? ld_data:
                   (width == `UByte)? {24'd0, ld_data[7:0]}:
                   (width == `UHalf)? {16'd0, ld_data[15:0]}:32'd0;

endmodule
