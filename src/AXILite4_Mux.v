/*
    This module is the multiplexer connected in front of the slave devices on the AXI Lite 4 bus.
    It is designed to perform arbitrations between requests coming from master devices
    and connect the chosen master with the slave device.
*/

module Arbiter (
    input clk,
    input rst,
    input next,
    input [1:0] candidate_bitmap,
    output chosen
);

assign chosen = (rst) ? 0 :
                (~next) ? chosen :
                (candidate_bitmap[~chosen] == 1) ? ~chosen : chosen;

endmodule

module AXILite4_Mux(
    input clk,
    input rst,
    // read bus
        // master 1
        input  [31:0]   master_1_readAddr_addr,
        input           master_1_readAddr_valid,
        output          master_1_readAddr_ready,
        output [127:0]  master_1_readData_data,
        output          master_1_readData_valid,
        input           master_1_readData_ready,
        // master 2
        input  [31:0]   master_2_readAddr_addr,
        input           master_2_readAddr_valid,
        output          master_2_readAddr_ready,
        output [127:0]  master_2_readData_data,
        output          master_2_readData_valid,
        input           master_2_readData_ready,
        // slave
        output [31:0]   slave_readAddr_addr,
        output          slave_readAddr_valid,
        input           slave_readAddr_ready,
        input  [127:0]  slave_readData_data,
        input           slave_readData_valid,
        output          slave_readData_ready,

    // write bus
        // master 1
        input  [31:0]   master_1_writeAddr_addr,
        input           master_1_writeAddr_valid,
        output          master_1_writeAddr_ready,
        input  [127:0]  master_1_writeData_data,
        input  [15:0]   master_1_writeData_strb,
        input           master_1_writeData_valid,
        output          master_1_writeData_ready,
        output [31:0]   master_1_writeResp_msg,
        output          master_1_writeResp_valid,
        input           master_1_writeResp_ready,
        // master 2
        input  [31:0]   master_2_writeAddr_addr,
        input           master_2_writeAddr_valid,
        output          master_2_writeAddr_ready,
        input  [127:0]  master_2_writeData_data,
        input  [15:0]   master_2_writeData_strb,
        input           master_2_writeData_valid,
        output          master_2_writeData_ready,
        output [31:0]   master_2_writeResp_msg,
        output          master_2_writeResp_valid,
        input           master_2_writeResp_ready,
        // slave
        output [31:0]   slave_writeAddr_addr,
        output          slave_writeAddr_valid,
        input           slave_writeAddr_ready,
        output [127:0]  slave_writeData_data,
        output [15:0]   slave_writeData_strb,
        output          slave_writeData_valid,
        input           slave_writeData_ready,
        input  [31:0]   slave_writeResp_msg,
        input           slave_writeResp_valid,
        output          slave_writeResp_ready
);

parameter MASTER_NUM = 2;
parameter SLAVE_NUM = 1;

localparam sINIT = 0;
localparam sREAD_REQ = 1;
localparam sREAD_RESP = 2;
localparam sWRITE_REQ = 1;
localparam sWRITE_RESP = 2;

localparam TRUE = 1;
localparam FALSE = 0;

// wire rearrangement
wire [31:0] master_readAddr_addr [MASTER_NUM-1:0];
wire [MASTER_NUM-1:0] master_readAddr_valid;
wire [MASTER_NUM-1:0] master_readData_ready;

wire [31:0] master_writeAddr_addr [MASTER_NUM-1:0];
wire [MASTER_NUM-1:0] master_writeAddr_valid;
wire [127:0] master_writeData_data [MASTER_NUM-1:0];
wire [15:0] master_writeData_strb [MASTER_NUM-1:0];
wire [MASTER_NUM-1:0] master_writeData_valid;
wire [MASTER_NUM-1:0] master_writeResp_ready;

assign master_readAddr_addr[0] = master_1_readAddr_addr;
assign master_readAddr_addr[1] = master_2_readAddr_addr;
assign master_readAddr_valid = {master_2_readAddr_valid, master_1_readAddr_valid};
assign master_readData_ready = {master_2_readData_ready, master_1_readData_ready};

assign master_writeAddr_addr[0] = master_1_writeAddr_addr;
assign master_writeAddr_addr[1] = master_2_writeAddr_addr;
assign master_writeAddr_valid = {master_2_writeAddr_valid, master_1_writeAddr_valid};
assign master_writeData_data[0] = master_1_writeData_data;
assign master_writeData_data[1] = master_2_writeData_data;
assign master_writeData_strb[0] = master_1_writeData_strb;
assign master_writeData_strb[1] = master_2_writeData_strb;
assign master_writeData_valid = {master_2_writeData_valid, master_1_writeData_valid};
assign master_writeResp_ready = {master_2_writeResp_ready, master_1_writeResp_ready};

// controlling signal
reg [1:0] read_state;
reg read_current_master;
wire read_next_arbitrate;       // indicate whether the arbiter should generate new result or not
wire read_arbitrate_result;     // the arbitration result for read port

reg [1:0] write_state;
reg write_current_master;
wire write_next_arbitrate;      // indicate whether the arbiter should generate new result or not
wire write_arbitrate_result;    // the arbitration result for write port

// arbiter declaration and connection
Arbiter read_arbiter(
    .clk(clk),
    .rst(rst),
    .next(read_next_arbitrate),
    .candidate_bitmap(master_readAddr_valid),
    .chosen(read_arbitrate_result)
);

Arbiter write_arbiter(
    .clk(clk),
    .rst(rst),
    .next(write_next_arbitrate),
    .candidate_bitmap(master_writeAddr_valid & master_writeData_valid),
    .chosen(write_arbitrate_result)
);

// next state decoder - read bus
always @(posedge clk or posedge rst) begin
    if (rst)begin
        read_state <= sINIT;
        read_current_master <= 0;
    end
    else begin
        case (read_state)
            sINIT: begin
                read_state <= (master_readAddr_valid[read_arbitrate_result]  == 1) ? sREAD_REQ : sINIT;
                read_current_master <= read_arbitrate_result;
            end
            sREAD_REQ: begin
                read_state <= ((master_readAddr_valid[read_current_master] & slave_readAddr_ready) == 1) ? sREAD_RESP : sREAD_REQ;
                read_current_master <= read_current_master;
            end
            sREAD_RESP: begin
                read_state <= ((slave_readData_valid & master_readData_ready[read_current_master]) == 1) ? sINIT : sREAD_RESP;
                read_current_master <= read_current_master;
            end
            default: begin
                read_state <= sINIT;
                read_current_master <= 0;
            end
        endcase
    end
end

// next state decoder - write bus
always @(posedge clk or posedge rst) begin
    if (rst) begin
        write_state <= sINIT;
        write_current_master <= 0;
    end
    else begin
        case (write_state)
            sINIT: begin
                write_state <= ((master_writeAddr_valid[write_current_master] & master_writeData_valid[write_arbitrate_result] ) == 1) ? sWRITE_REQ : sINIT;
                write_current_master <= write_arbitrate_result;
            end
            sWRITE_REQ: begin
                write_state <= ((master_writeAddr_valid[write_current_master] & master_writeData_valid[write_current_master] & slave_writeAddr_ready  & slave_writeData_ready)  == 1) ? sWRITE_RESP : sWRITE_REQ;
                write_current_master <= write_current_master;
            end
            sWRITE_RESP: begin
                write_state <= ((slave_writeResp_valid & master_writeResp_ready[write_current_master] ) == 1) ? sINIT : sWRITE_RESP;
                write_current_master <= write_current_master;
            end
            default: begin
                write_state <= sINIT;
                write_current_master <= 0;
            end
        endcase
    end
end

// signal generator - controlling
assign read_next_arbitrate = (read_state == sINIT);
assign write_next_arbitrate = (write_state == sINIT);

// signal generator - read bus
assign master_1_readAddr_ready = (read_state == sREAD_REQ & read_current_master == 0) ? slave_readAddr_ready : FALSE;
assign master_1_readData_data = (read_state == sREAD_RESP & read_current_master == 0) ? slave_readData_data : 128'b0;
assign master_1_readData_valid = (read_state == sREAD_RESP & read_current_master == 0) ? slave_readData_valid : FALSE;
assign master_2_readAddr_ready = (read_state == sREAD_REQ & read_current_master == 1) ? slave_readAddr_ready : FALSE;
assign master_2_readData_data = (read_state == sREAD_RESP & read_current_master == 1) ? slave_readData_data : 128'b0;
assign master_2_readData_valid = (read_state == sREAD_RESP & read_current_master == 1) ? slave_readData_valid : FALSE;
assign slave_readAddr_addr = (read_state == sREAD_REQ & read_current_master == 0) ? master_1_readAddr_addr :
                             (read_state == sREAD_REQ & read_current_master == 1) ? master_2_readAddr_addr : 32'b0;
assign slave_readAddr_valid = (read_state == sREAD_REQ & read_current_master == 0) ? master_1_readAddr_valid :
                              (read_state == sREAD_REQ & read_current_master == 1) ? master_2_readAddr_valid : FALSE;
assign slave_readData_ready = (read_state == sREAD_RESP & read_current_master == 0) ? master_1_readData_ready :
                              (read_state == sREAD_RESP & read_current_master == 1) ? master_2_readData_ready : FALSE;

// signal generator - write bus
assign master_1_writeAddr_ready = (write_state == sWRITE_REQ & write_current_master == 0) ? slave_writeAddr_ready : FALSE;
assign master_1_writeData_ready = (write_state == sWRITE_REQ & write_current_master == 0) ? slave_writeData_ready : FALSE;
assign master_1_writeResp_msg = (write_state == sWRITE_RESP & write_current_master == 0) ? slave_writeResp_msg : 32'b0;
assign master_1_writeResp_valid = (write_state == sWRITE_RESP & write_current_master == 0) ? slave_writeResp_valid : FALSE;
assign master_2_writeAddr_ready = (write_state == sWRITE_REQ & write_current_master == 1) ? slave_writeAddr_ready : FALSE;
assign master_2_writeData_ready = (write_state == sWRITE_REQ & write_current_master == 1) ? slave_writeData_ready : FALSE;
assign master_2_writeResp_msg = (write_state == sWRITE_RESP & write_current_master == 1) ? slave_writeResp_msg : 32'b0;
assign master_2_writeResp_valid = (write_state == sWRITE_RESP & write_current_master == 1) ? slave_writeResp_valid : FALSE;
assign slave_writeAddr_addr = (write_state == sWRITE_REQ & write_current_master == 0) ? master_1_writeAddr_addr :
                              (write_state == sWRITE_REQ & write_current_master == 1) ? master_2_writeAddr_addr : 32'b0;
assign slave_writeAddr_valid = (write_state == sWRITE_REQ & write_current_master == 0) ? master_1_writeAddr_valid :
                               (write_state == sWRITE_REQ & write_current_master == 1) ? master_2_writeAddr_valid : FALSE;
assign slave_writeData_data = (write_state == sWRITE_REQ & write_current_master == 0) ? master_1_writeData_data :
                              (write_state == sWRITE_REQ & write_current_master == 1) ? master_2_writeData_data : 128'b0;
assign slave_writeData_strb = (write_state == sWRITE_REQ & write_current_master == 0) ? master_1_writeData_strb :
                              (write_state == sWRITE_REQ & write_current_master == 1) ? master_2_writeData_strb : 16'b0;
assign slave_writeData_valid = (write_state == sWRITE_REQ & write_current_master == 0) ? master_1_writeData_valid :
                               (write_state == sWRITE_REQ & write_current_master == 1) ? master_2_writeData_valid : FALSE;
assign slave_writeResp_ready = (write_state == sWRITE_RESP & write_current_master == 0) ? master_1_writeResp_ready :
                               (write_state == sWRITE_RESP & write_current_master == 1) ? master_2_writeResp_ready : FALSE;

endmodule
