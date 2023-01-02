module Cache_Controller(clk, rst, p_w_en, p_r_en, hit, //input
                        readAddr_ready, readData_valid, writeAddr_ready, writeData_ready, writeResp_valid, writeResp_msg,
                        readAddr_valid, readData_ready, writeAddr_valid, writeData_valid, writeResp_ready, //output
                        dataram_sel, p_valid, w_tagram, w_validram, w_dataram, validin);
input clk, rst;
input [3:0] p_w_en; // w_en from the processor
input p_r_en;       // r_en from the processor
input hit;        // high when cache hit 

// system bus ready & valid signals
input readAddr_ready, 
      readData_valid, 
      writeAddr_ready, 
      writeData_ready, 
      writeResp_valid;
      
input [31:0] writeResp_msg;

output reg readAddr_valid, 
           readData_ready, 
           writeAddr_valid, 
           writeData_valid, 
           writeResp_ready;

output reg dataram_sel;         // signal to select the data to update the DataRam
output reg p_valid;             // ready to the processor.
output reg w_tagram,            // signal to enable RAMs write operation.
           w_validram,
           w_dataram;
output reg validin;             // valid signal to update validram 

parameter S_IDLE                = 0, 
          S_READ_HIT            = 1,
          S_READ_MISS           = 2, 
          S_READ_SYS_UPD_CACHE  = 3,
          S_WRITE_HIT           = 4,
          S_WRITE_MISS          = 5,
          S_WRITE_SYS           = 6,
          S_WRITE_SYS_UPD_CACHE = 7;

// declare reg
reg [2:0] StateReg, 
          NextState;

//declare wire
wire write = |p_w_en;
wire read  = p_r_en;

// Update StateReg
always@(posedge clk or posedge rst) begin
    if(rst) StateReg <= S_IDLE;
    else    StateReg <= NextState;
end

// Next State Equation
always@(*) begin
    case (StateReg)
    S_IDLE       : begin
        case ({read, write, hit})
        3'b101 : NextState = S_READ_HIT;   // read hit
        3'b100 : NextState = S_READ_MISS;  // read miss
        3'b011 : NextState = S_WRITE_HIT;  // write hit
        3'b010 : NextState = S_WRITE_MISS; // write miss
        default: NextState = S_IDLE;      // default
        endcase
    end
    S_READ_HIT           : NextState = S_IDLE;
    S_READ_MISS          : NextState = (readAddr_ready == 1'b1)? S_READ_SYS_UPD_CACHE : S_READ_MISS;
    S_READ_SYS_UPD_CACHE : NextState = (readData_valid == 1'b1)? S_IDLE : S_READ_SYS_UPD_CACHE;
    S_WRITE_HIT          : NextState = ((writeAddr_ready & writeData_ready) == 1'b1)? S_WRITE_SYS_UPD_CACHE : S_WRITE_HIT;
    S_WRITE_SYS_UPD_CACHE: NextState = (writeResp_valid == 1'b1)? S_IDLE : S_WRITE_SYS_UPD_CACHE;
    S_WRITE_MISS         : NextState = ((writeAddr_ready & writeData_ready) == 1'b1)? S_WRITE_SYS : S_WRITE_MISS;
    S_WRITE_SYS          : NextState = (writeResp_valid == 1'b1)? S_IDLE : S_WRITE_SYS;
    default              : NextState = S_IDLE;
    endcase
end

// Output Equation
always@(*) begin
    case(StateReg)
    S_IDLE                : begin
        p_valid = 1'b0;                             // don't care
        readAddr_valid = 1'b0;                      // don't care
        readData_ready = 1'b0;                      // don't care
        {w_validram, w_tagram, w_dataram} = 3'b000; // don't care
        validin = 1'b0;                             // don't care
        dataram_sel    = 1'b0;                      // don't care
        writeAddr_valid = 1'b0;                     // don't care
        writeData_valid = 1'b0;                     // don't care
        writeResp_ready = 1'b0;                     // don't care
    end
    S_READ_HIT            : begin
        p_valid = 1'b1;
        readAddr_valid = 1'b0;                      // don't care
        readData_ready = 1'b0;                      // don't care
        {w_validram, w_tagram, w_dataram} = 3'b000; // don't care
        validin = 1'b0;                             // don't care
        dataram_sel    = 1'b0;                      // don't care
        writeAddr_valid = 1'b0;                     // don't care
        writeData_valid = 1'b0;                     // don't care
        writeResp_ready = 1'b0;                     // don't care
    end
    S_READ_MISS           : begin
        p_valid = 1'b0;                             // don't care
        readAddr_valid = 1'b1;                  
        readData_ready = 1'b0;                      // don't care
        {w_validram, w_tagram, w_dataram} = 3'b000; // don't care
        validin = 1'b0;                             // don't care
        dataram_sel    = 1'b0;                      // don't care
        writeAddr_valid = 1'b0;                     // don't care
        writeData_valid = 1'b0;                     // don't care
        writeResp_ready = 1'b0;                     // don't care
    end
    S_READ_SYS_UPD_CACHE  : begin
        p_valid = (readData_valid)? 1'b1 : 1'b0;
        readAddr_valid = 1'b0;                      // don't care
        readData_ready = 1'b1;
        {w_validram, w_tagram, w_dataram} = (readData_valid)? 3'b111 : 3'b000;
        validin = 1'b1;
        dataram_sel    = 1'b0;
        writeAddr_valid = 1'b0;                     // don't care
        writeData_valid = 1'b0;                     // don't care
        writeResp_ready = 1'b0;                     // don't care
    end
    S_WRITE_HIT           : begin
        p_valid = 1'b0;                             // don't care
        readAddr_valid = 1'b0;                      // don't care
        readData_ready = 1'b0;                      // don't care
        {w_validram, w_tagram, w_dataram} = 3'b000; // don't care
        validin = 1'b0;                             // don't care
        dataram_sel    = 1'b0;                      // don't care
        writeAddr_valid = 1'b1; 
        writeData_valid = 1'b1;
        writeResp_ready = 1'b0;                     // don't care
    end
    S_WRITE_SYS_UPD_CACHE : begin
        p_valid = (writeResp_valid)? 1'b1 : 1'b0;
        readAddr_valid = 1'b0;                      // don't care
        readData_ready = 1'b0;                      // don't care
        {w_validram, w_tagram, w_dataram} = (writeResp_valid)? 3'b001 : 3'b000; 
        validin = 1'b0;                             // don't care
        dataram_sel = 1'b1;
        writeAddr_valid = 1'b0;                     // don't care
        writeData_valid = 1'b0;                     // don't care
        writeResp_ready = 1'b1;
    end
    S_WRITE_MISS          : begin
        p_valid = 1'b0;                             // don't care
        readAddr_valid = 1'b0;                      // don't care
        readData_ready = 1'b0;                      // don't care
        {w_validram, w_tagram, w_dataram} = 3'b000; // don't care
        validin = 1'b0;                             // don't care
        dataram_sel    = 1'b0;                      // don't care
        writeAddr_valid = 1'b1;
        writeData_valid = 1'b1;
        writeResp_ready = 1'b0;                     // don't care
    end
    S_WRITE_SYS           : begin
        p_valid = (writeResp_valid)? 1'b1 : 1'b0;
        readAddr_valid = 1'b0;                      // don't care
        readData_ready = 1'b0;                      // don't care
        {w_validram, w_tagram, w_dataram} = 3'b000; // don't care
        validin = 1'b0;                             // don't care
        dataram_sel    = 1'b0;                      // don't care
        writeAddr_valid = 1'b0;                     // don't care
        writeData_valid = 1'b0;                     // don't care
        writeResp_ready = 1'b1;
    end
    default               : begin
        p_valid = 1'b0;                             // don't care
        readAddr_valid = 1'b0;                      // don't care
        readData_ready = 1'b0;                      // don't care
        {w_validram, w_tagram, w_dataram} = 3'b000; // don't care
        validin = 1'b0;                             // don't care
        dataram_sel    = 1'b0;                      // don't care
        writeAddr_valid = 1'b0;                     // don't care
        writeData_valid = 1'b0;                     // don't care
        writeResp_ready = 1'b0;                     // don't care
    end
    endcase
end
endmodule
