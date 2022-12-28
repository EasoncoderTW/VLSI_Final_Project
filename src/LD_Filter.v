`include "./rv32_define.v"

module LD_Filter (
    input [2:0] func3,
    input [31:0] ld_data,
    output reg [31:0] ld_data_f
);

always @(*) begin
    case(func3)
    `lb_:    ld_data_f = {{24{ld_data[7]}}, ld_data[7:0]};
    `lh_:    ld_data_f = {{16{ld_data[15]}}, ld_data[15:0]};
    `lw_:    ld_data_f = ld_data;
    `lbu_:   ld_data_f = {24'd0, ld_data[7:0]};
    `lhu_:   ld_data_f = {16'd0, ld_data[15:0]};
    default: ld_data_f = 32'd0;
    endcase
end

endmodule
