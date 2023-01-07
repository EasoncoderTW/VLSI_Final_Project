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
    output             readData_valid, // sender data is valid
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
    output             writeResp_valid,
    input              writeResp_ready

);
reg read_ps;
reg [2:0] write_ps;
reg [7:0] mem [0:65535]; // 1 byte per addr mem
reg [15:0] write_addr;
reg [15:0] write_strb;
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
        default: readData_data <= 128'b0;
    endcase
end

always @(posedge clk or posedge rst) begin : fsm_trasition_read
    if(rst) read_ps <= RIDLE;
    else begin
        case(read_ps)
            RIDLE: read_ps <= (readAddr_valid == 1) ? READ : RIDLE;
            READ: read_ps <= (readData_ready == 1) ? RIDLE : READ;
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
            write_addr <= (writeAddr_valid == 1) ? writeAddr_addr[15:0] : write_addr;
            write_data <= (writeData_valid == 1) ? writeData_data : write_data;
            write_strb <= (writeData_valid == 1) ? writeData_strb : write_strb;
        end
        WAITWADDR: begin
            write_addr <= (writeAddr_valid == 1) ? writeAddr_addr[15:0] : write_addr;
            write_data <= write_data;
            write_strb <= write_strb;
        end
        WAITWDATA: begin
            write_addr <= write_addr;
            write_data <= (writeData_valid == 1) ? writeData_data : write_data;
            write_strb <= (writeData_valid == 1) ? writeData_strb : write_strb;
        end
        default: begin
            write_addr <= 16'b0;
            write_data <= 128'b0;
            write_strb <= 16'b0;
        end
    endcase
end

// Something like write_data[7+8*i:0+8*i] will cause err.
// Because the index range with semicolon must be const based on verilog's std.
always @(posedge clk) begin
    if(write_ps == WRITE) begin
        mem[write_addr + 16'd15] <= (write_strb[15] == 1) ? write_data[127:120] : mem[write_addr + 16'd15];
        mem[write_addr + 16'd14] <= (write_strb[14] == 1) ? write_data[119:112] : mem[write_addr + 16'd14];
        mem[write_addr + 16'd13] <= (write_strb[13] == 1) ? write_data[111:104] : mem[write_addr + 16'd13];
        mem[write_addr + 16'd12] <= (write_strb[12] == 1) ? write_data[103:96]  : mem[write_addr + 16'd12];
        mem[write_addr + 16'd11] <= (write_strb[11] == 1) ? write_data[95:88]   : mem[write_addr + 16'd11];
        mem[write_addr + 16'd10] <= (write_strb[10] == 1) ? write_data[87:80]   : mem[write_addr + 16'd10];
        mem[write_addr + 16'd9]  <= (write_strb[9] == 1)  ? write_data[79:72]   : mem[write_addr + 16'd9];
        mem[write_addr + 16'd8]  <= (write_strb[8] == 1)  ? write_data[71:64]   : mem[write_addr + 16'd8];
        mem[write_addr + 16'd7]  <= (write_strb[7] == 1)  ? write_data[63:56]   : mem[write_addr + 16'd7];
        mem[write_addr + 16'd6]  <= (write_strb[6] == 1)  ? write_data[55:48]   : mem[write_addr + 16'd6];
        mem[write_addr + 16'd5]  <= (write_strb[5] == 1)  ? write_data[47:40]   : mem[write_addr + 16'd5];
        mem[write_addr + 16'd4]  <= (write_strb[4] == 1)  ? write_data[39:32]   : mem[write_addr + 16'd4];
        mem[write_addr + 16'd3]  <= (write_strb[3] == 1)  ? write_data[31:24]   : mem[write_addr + 16'd3];
        mem[write_addr + 16'd2]  <= (write_strb[2] == 1)  ? write_data[23:16]   : mem[write_addr + 16'd2];
        mem[write_addr + 16'd1]  <= (write_strb[1] == 1)  ? write_data[15:8]    : mem[write_addr + 16'd1];
        mem[write_addr + 16'd0]  <= (write_strb[0] == 1)  ? write_data[7:0]     : mem[write_addr + 16'd0];
    end
end

always @(posedge clk or posedge rst) begin : fsm_trasition_write
    if(rst) write_ps <= WIDLE;
    else begin
        case(write_ps)
            WIDLE: begin
                case({writeData_valid == 1, writeAddr_valid == 1})
                    2'b00: write_ps <= WIDLE;
                    2'b01: write_ps <= WAITWDATA;
                    2'b10: write_ps <= WAITWADDR;
                    2'b11: write_ps <= WRITE;
                    default: write_ps <= WIDLE;
                endcase
            end
            WAITWDATA: write_ps <= (writeData_valid == 1) ? WRITE : WAITWDATA;
            WAITWADDR: write_ps <= (writeAddr_valid == 1) ? WRITE : WAITWADDR;
            WRITE: write_ps <= WRITERESP;
            WRITERESP: write_ps <= (writeResp_ready == 1) ? WIDLE : WRITERESP;
            default: write_ps <= WIDLE;
        endcase
    end
end

endmodule
