module Cache(
    input clk,
    /* CPU IO */
    input [3:0] w_en, // write enable for 4 bytes
    input [15:0] address,
    input [31:0] write_data,
    output reg [31:0] read_data,
    output reg ready
    /* AXI Lite 4 IO */
    // TBD
);

// TBD

endmodule
