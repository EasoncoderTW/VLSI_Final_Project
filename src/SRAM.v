module SRAM(
    input clk,
    input rst,
    // Replaced signal:
        // input w_en, -> writeAddr_valid & writeData_valid
        // input [15:0]w_mask, -> writeData_strb
        // input [15:0] address, -> readAddr_addr[15:0]
        // input [127:0] write_data -> writeData_data
        // output reg [127:0] read_data, -> readData_data
        // output reg r_en, -> readData_valid
    
    /* AXI Lite 4, served as slave */
    input   [31:0]     readAddr_addr, // only low 15 bits will be used in here
    input              readAddr_valid,
    output             readAddr_ready,
    output reg [127:0] readData_data,
<<<<<<< HEAD
    output reg         readData_valid, // sender data is valid
=======
    output             readData_valid, // sender data is valid
>>>>>>> 2af0574fe84728aa1e2beb782338bb3c15db22b1
    input              readData_ready, // receiver can deal with "current" request
    // write port
    input  [31:0]      writeAddr_addr,
    input              writeAddr_valid,
    output             writeAddr_ready,
    input  [127:0]     writeData_data,
    input  [15:0]      writeData_strb, // write enable mask for 16 bytes
    input              writeData_valid,
    output             writeData_ready,
    output [31:0]      writeResp_msg,  
<<<<<<< HEAD
    output reg         writeResp_valid,
    input              writeResp_ready

);
reg read_ps, read_ns;
reg [1:0] write_ps, write_ns;
reg [7:0] mem [0:65535]; // 1 byte per addr mem
reg [15:0] read_addr, write_addr;
reg [127:0] write_data;

parameter RIDLE = 1'b0;
parameter READ = 1'b1;
parameter WIDLE = 2'b00;
parameter WAITWDATA = 2'b01;
parameter WAITWADDR = 2'b10;
parameter WRITE = 2'b11;

always @(posedge clk or posedge rst) begin : fsm_trasition
    if(rst) {read_ps, write_ps} <= 3'b0;
    else begin
        read_ps <= read_ns;
        write_ps <= write_ns;
    end
end

// Read related signals
assign readAddr_ready = (read_ps == RIDLE);
always @(posedge clk) begin : fsm_read
    case(read_ps)
        RIDLE: begin
            read_addr <= (readAddr_valid) ? readAddr_addr[15:0] : 16'bx;
            readData_valid <= 1'b0;
            readData_data <= 128'b0;
        end
        READ: begin
            read_addr <= 16'bx;
            readData_valid <= 1'b1;
            readData_data <= {
                mem[read_addr+16'd15],
                mem[read_addr+16'd14],
                mem[read_addr+16'd13],
                mem[read_addr+16'd12],
                mem[read_addr+16'd11],
                mem[read_addr+16'd10],
                mem[read_addr+16'd9],
                mem[read_addr+16'd8],
                mem[read_addr+16'd7],
                mem[read_addr+16'd6],
                mem[read_addr+16'd5],
                mem[read_addr+16'd4],
                mem[read_addr+16'd3],
                mem[read_addr+16'd2],
                mem[read_addr+16'd1],
                mem[read_addr]
            };
        end
        default: {read_addr, readData_valid, readData_data} <= 145'bx;
    endcase
end

always @(*) begin : fsm_read_ns
    read_ns = RIDLE;
    case(read_ps)
        RIDLE: read_ns = (readAddr_valid) ? READ : RIDLE;
        READ: read_ns = (readData_ready) ? RIDLE : READ;
        default: read_ns = 1'bx;
    endcase
end

// Write related signals
assign writeAddr_ready = (write_ps == WIDLE || write_ps == WAITWADDR);
assign writeData_ready = (write_ps == WIDLE || write_ps == WAITWDATA);
assign writeResp_msg = 32'b0;

always @(posedge clk) begin : fsm_write
    case(write_ps)
        WIDLE: begin
            write_addr <= (writeAddr_valid) ? writeAddr_addr[15:0] : 16'bx;
            write_data <= (writeData_valid) ? writeData_data : 128'bx;
        end
        WAITWADDR: begin
            write_addr <= (writeAddr_valid) ? writeAddr_addr[15:0] : 16'bx;
            write_data <= write_data;
        end
        WAITWDATA: begin
            write_addr <= write_addr;
            write_data <= (writeData_valid) ? writeData_data : 128'bx;
        end
        default: begin
            write_addr <= 16'bx;
            write_data <= 128'bx;
        end
    endcase
end
/*
always @(posedge clk) begin : write_mem
    if(write_ps == WRITE) begin
        for(i = 0; i < 16; i = i + 1) begin
            if(writeData_strb[i]) mem[write_addr + i] <= write_data[7+8*i:0+8*i];
            else mem[write_addr + i] <= mem[write_addr + i];
        end
    end
end
*/

=======
    output             writeResp_valid,
    input              writeResp_ready

);
reg read_ps;
reg [2:0] write_ps;
reg [7:0] mem [0:65535]; // 1 byte per addr mem
reg [15:0] write_addr;
reg [127:0] write_data;

wire [15:0] read_addr;

parameter RIDLE = 1'b0;
parameter READ = 1'b1;
parameter WIDLE = 3'b000;
parameter WAITWDATA = 3'b001;
parameter WAITWADDR = 3'b010;
parameter WRITE = 3'b011;
parameter WRITERESP = 3'b100;   // avoid keep writing, use new state to check hand shaking

// Read related signals
assign readAddr_ready = (read_ps == RIDLE);
assign readData_valid = (read_ps == READ);
assign read_addr = readAddr_addr[15:0];
always @(posedge clk) begin : fsm_read
    case(read_ps)
        RIDLE: begin
            readData_data <= {
                mem[read_addr + 16'd15],
                mem[read_addr + 16'd14],
                mem[read_addr + 16'd13],
                mem[read_addr + 16'd12],
                mem[read_addr + 16'd11],
                mem[read_addr + 16'd10],
                mem[read_addr + 16'd9],
                mem[read_addr + 16'd8],
                mem[read_addr + 16'd7],
                mem[read_addr + 16'd6],
                mem[read_addr + 16'd5],
                mem[read_addr + 16'd4],
                mem[read_addr + 16'd3],
                mem[read_addr + 16'd2],
                mem[read_addr + 16'd1],
                mem[read_addr]
            };
        end
        READ: begin
            readData_data <= readData_data;
        end
        default: readData_data <= 128'bx;
    endcase
end

always @(posedge clk or posedge rst) begin : fsm_trasition_read
    if(rst) read_ps <= RIDLE;
    else begin
        case(read_ps)
            RIDLE: read_ps <= (readAddr_valid) ? READ : RIDLE;
            READ: read_ps <= (readData_ready) ? RIDLE : READ;
            default: read_ps <= RIDLE;
        endcase
    end
end

// Write related signals
assign writeAddr_ready = (write_ps == WIDLE || write_ps == WAITWADDR);
assign writeData_ready = (write_ps == WIDLE || write_ps == WAITWDATA);
assign writeResp_valid = (write_ps == WRITERESP);
assign writeResp_msg = 32'b0; // currently useless

always @(posedge clk) begin : fsm_write
    case(write_ps)
        WIDLE: begin
            write_addr <= (writeAddr_valid) ? writeAddr_addr[15:0] : write_addr;
            write_data <= (writeData_valid) ? writeData_data : write_data;
        end
        WAITWADDR: begin
            write_addr <= (writeAddr_valid) ? writeAddr_addr[15:0] : write_addr;
            write_data <= write_data;
        end
        WAITWDATA: begin
            write_addr <= write_addr;
            write_data <= (writeData_valid) ? writeData_data : write_data;
        end
        default: begin
            write_addr <= 16'b0;
            write_data <= 128'b0;
        end
    endcase
end

>>>>>>> 2af0574fe84728aa1e2beb782338bb3c15db22b1
// Something like write_data[7+8*i:0+8*i] will cause err.
// Because the index range with semicolon must be const based on verilog's std.
always @(posedge clk) begin
    if(write_ps == WRITE) begin
        mem[write_addr + 16'd15] <= (writeData_strb[15]) ? write_data[127:120] : mem[write_addr + 16'd15];
        mem[write_addr + 16'd14] <= (writeData_strb[14]) ? write_data[119:112] : mem[write_addr + 16'd14];
        mem[write_addr + 16'd13] <= (writeData_strb[13]) ? write_data[111:104] : mem[write_addr + 16'd13];
        mem[write_addr + 16'd12] <= (writeData_strb[12]) ? write_data[103:96]  : mem[write_addr + 16'd12];
        mem[write_addr + 16'd11] <= (writeData_strb[11]) ? write_data[95:88]   : mem[write_addr + 16'd11];
        mem[write_addr + 16'd10] <= (writeData_strb[10]) ? write_data[87:80]   : mem[write_addr + 16'd10];
        mem[write_addr + 16'd9]  <= (writeData_strb[9])  ? write_data[79:72]   : mem[write_addr + 16'd9];
        mem[write_addr + 16'd8]  <= (writeData_strb[8])  ? write_data[71:64]   : mem[write_addr + 16'd8];
        mem[write_addr + 16'd7]  <= (writeData_strb[7])  ? write_data[63:56]   : mem[write_addr + 16'd7];
        mem[write_addr + 16'd6]  <= (writeData_strb[6])  ? write_data[55:48]   : mem[write_addr + 16'd6];
        mem[write_addr + 16'd5]  <= (writeData_strb[5])  ? write_data[47:40]   : mem[write_addr + 16'd5];
        mem[write_addr + 16'd4]  <= (writeData_strb[4])  ? write_data[39:32]   : mem[write_addr + 16'd4];
        mem[write_addr + 16'd3]  <= (writeData_strb[3])  ? write_data[31:24]   : mem[write_addr + 16'd3];
        mem[write_addr + 16'd2]  <= (writeData_strb[2])  ? write_data[23:16]   : mem[write_addr + 16'd2];
        mem[write_addr + 16'd1]  <= (writeData_strb[1])  ? write_data[15:8]    : mem[write_addr + 16'd1];
        mem[write_addr + 16'd0]  <= (writeData_strb[0])  ? write_data[7:0]     : mem[write_addr + 16'd0];
    end
end

<<<<<<< HEAD

always @(*) begin : fsm_write_ns
    write_ns = WIDLE;
    case(write_ps)
        WIDLE: begin
            case({writeData_valid, writeAddr_valid})
                2'b00: write_ns = WIDLE;
                2'b01: write_ns = WAITWDATA;
                2'b10: write_ns = WAITWADDR;
                2'b11: write_ns = WRITE;
                default: write_ns = WIDLE;
            endcase
        end
        WAITWDATA: write_ns = (writeData_valid) ? WRITE : WAITWDATA;
        WAITWADDR: write_ns = (writeAddr_valid) ? WRITE : WAITWADDR;
        WRITE: write_ns = WIDLE;
        default: write_ns = WIDLE;
    endcase
end

always @(posedge clk) begin : writeResp_valid_handshake
    if(write_ps == WRITE) writeResp_valid <= 1'b1;
    else begin
        writeResp_valid <= (writeResp_valid & writeResp_ready) ? 1'b0 : writeResp_valid;
=======
always @(posedge clk or posedge rst) begin : fsm_trasition_write
    if(rst) write_ps <= WIDLE;
    else begin
        case(write_ps)
            WIDLE: begin
                case({writeData_valid, writeAddr_valid})
                    2'b00: write_ps <= WIDLE;
                    2'b01: write_ps <= WAITWDATA;
                    2'b10: write_ps <= WAITWADDR;
                    2'b11: write_ps <= WRITE;
                    default: write_ps <= WIDLE;
                endcase
            end
            WAITWDATA: write_ps <= (writeData_valid) ? WRITE : WAITWDATA;
            WAITWADDR: write_ps <= (writeAddr_valid) ? WRITE : WAITWADDR;
            WRITE: write_ps <= WRITERESP;
            WRITERESP: write_ps <= (writeResp_ready) ? WIDLE : WRITERESP;
            default: write_ps <= WIDLE;
        endcase
>>>>>>> 2af0574fe84728aa1e2beb782338bb3c15db22b1
    end
end

endmodule