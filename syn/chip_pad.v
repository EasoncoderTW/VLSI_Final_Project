module chip(
//inputs
    PI_clk,
    PI_rst,
    PI_Inst_Cahe_readAddr_ready,
    PI_Inst_Cahe_readData_data,
    PI_Inst_Cahe_readData_valid,
    PI_Inst_Cahe_writeAddr_ready,
    PI_Inst_Cahe_writeData_ready,
    PI_Inst_Cahe_writeResp_msg,
    PI_Inst_Cahe_writeResp_valid,
    PI_Data_Cahe_readAddr_ready,
    PI_Data_Cahe_readData_data,
    PI_Data_Cahe_readData_valid,
    PI_Data_Cahe_writeAddr_ready,
    PI_Data_Cahe_writeData_ready,
    PI_Data_Cahe_writeResp_msg,
    PI_Data_Cahe_writeResp_valid,
//outputs
    PO_Inst_Cahe_readAddr_addr,
    PO_Inst_Cahe_readAddr_valid,
    PO_Inst_Cahe_readData_ready,
    PO_Inst_Cahe_writeAddr_addr,
    PO_Inst_Cahe_writeAddr_valid,
    PO_Inst_Cahe_writeData_data,
    PO_Inst_Cahe_writeData_strb,
    PO_Inst_Cahe_writeData_valid,
    PO_Inst_Cahe_writeResp_ready,
    PO_Data_Cahe_readAddr_addr,
    PO_Data_Cahe_readAddr_valid,
    PO_Data_Cahe_readData_ready,
    PO_Data_Cahe_writeAddr_addr,
    PO_Data_Cahe_writeAddr_valid,
    PO_Data_Cahe_writeData_data,
    PO_Data_Cahe_writeData_strb,
    PO_Data_Cahe_writeData_valid,
    PO_Data_Cahe_writeResp_ready,
    PO_halt
);
    input            PI_clk;                       //0
    input            PI_rst;                       //0
    input            PI_Inst_Cahe_readAddr_ready;  //0
    input   [127:0]  PI_Inst_Cahe_readData_data;   //0
    input            PI_Inst_Cahe_readData_valid;  //0
    input            PI_Inst_Cahe_writeAddr_ready; //0
    input            PI_Inst_Cahe_writeData_ready; //0
    input   [31:0]   PI_Inst_Cahe_writeResp_msg;   //0
    input            PI_Inst_Cahe_writeResp_valid; //0
    input            PI_Data_Cahe_readAddr_ready;  //2
    input   [127:0]  PI_Data_Cahe_readData_data;   //2
    input            PI_Data_Cahe_readData_valid;  //2
    input            PI_Data_Cahe_writeAddr_ready; //2
    input            PI_Data_Cahe_writeData_ready; //2
    input   [31:0]   PI_Data_Cahe_writeResp_msg;   //2
    input            PI_Data_Cahe_writeResp_valid; //2
    
    output  [31:0]   PO_Inst_Cahe_readAddr_addr;   //1
    output           PO_Inst_Cahe_readAddr_valid;  //1
    output           PO_Inst_Cahe_readData_ready;  //1
    output  [31:0]   PO_Inst_Cahe_writeAddr_addr;  //1
    output           PO_Inst_Cahe_writeAddr_valid; //1
    output  [127:0]  PO_Inst_Cahe_writeData_data;  //1 
    output  [15:0]   PO_Inst_Cahe_writeData_strb;  //1
    output           PO_Inst_Cahe_writeData_valid; //1
    output           PO_Inst_Cahe_writeResp_ready; //1
    output  [31:0]   PO_Data_Cahe_readAddr_addr;   //3
    output           PO_Data_Cahe_readAddr_valid;  //3
    output           PO_Data_Cahe_readData_ready;  //3
    output  [31:0]   PO_Data_Cahe_writeAddr_addr;  //3
    output           PO_Data_Cahe_writeAddr_valid; //3
    output  [127:0]  PO_Data_Cahe_writeData_data;  //3  
    output  [15:0]   PO_Data_Cahe_writeData_strb;  //3
    output           PO_Data_Cahe_writeData_valid; //3
    output           PO_Data_Cahe_writeResp_ready; //3
    output           PO_halt;                      //0

    wire             WIRE_clk;
    wire             WIRE_rst;
    wire             WIRE_Inst_Cahe_readAddr_ready;
    wire   [127:0]   WIRE_Inst_Cahe_readData_data;
    wire             WIRE_Inst_Cahe_readData_valid;
    wire             WIRE_Inst_Cahe_writeAddr_ready;
    wire             WIRE_Inst_Cahe_writeData_ready;
    wire   [31:0]    WIRE_Inst_Cahe_writeResp_msg;
    wire             WIRE_Inst_Cahe_writeResp_valid;
    wire             WIRE_Data_Cahe_readAddr_ready;
    wire   [127:0]   WIRE_Data_Cahe_readData_data;
    wire             WIRE_Data_Cahe_readData_valid;
    wire             WIRE_Data_Cahe_writeAddr_ready;
    wire             WIRE_Data_Cahe_writeData_ready;
    wire   [31:0]    WIRE_Data_Cahe_writeResp_msg;
    wire             WIRE_Data_Cahe_writeResp_valid;
    wire  [31:0]     WIRE_Inst_Cahe_readAddr_addr;
    wire             WIRE_Inst_Cahe_readAddr_valid;
    wire             WIRE_Inst_Cahe_readData_ready;
    wire  [31:0]     WIRE_Inst_Cahe_writeAddr_addr;
    wire             WIRE_Inst_Cahe_writeAddr_valid;
    wire  [127:0]    WIRE_Inst_Cahe_writeData_data;
    wire  [15:0]     WIRE_Inst_Cahe_writeData_strb;
    wire             WIRE_Inst_Cahe_writeData_valid;
    wire             WIRE_Inst_Cahe_writeResp_ready;
    wire  [31:0]     WIRE_Data_Cahe_readAddr_addr;
    wire             WIRE_Data_Cahe_readAddr_valid;
    wire             WIRE_Data_Cahe_readData_ready;
    wire  [31:0]     WIRE_Data_Cahe_writeAddr_addr;
    wire             WIRE_Data_Cahe_writeAddr_valid;
    wire  [127:0]    WIRE_Data_Cahe_writeData_data;
    wire  [15:0]     WIRE_Data_Cahe_writeData_strb;
    wire             WIRE_Data_Cahe_writeData_valid;
    wire             WIRE_Data_Cahe_writeResp_ready;
    wire             WIRE_halt;

CPU CPU(
    .clk(WIRE_clk)
    .rst(WIRE_rst)
    .Inst_Cahe_readAddr_ready(WIRE_Inst_Cahe_readAddr_ready)
    .Inst_Cahe_readData_data(WIRE_Inst_Cahe_readData_data)
    .Inst_Cahe_readData_valid(WIRE_Inst_Cahe_readData_valid)
    .Inst_Cahe_writeAddr_ready(WIRE_Inst_Cahe_writeAddr_ready)
    .Inst_Cahe_writeData_ready(WIRE_Inst_Cahe_writeData_ready)
    .Inst_Cahe_writeResp_msg(WIRE_Inst_Cahe_writeResp_msg)
    .Inst_Cahe_writeResp_valid(WIRE_Inst_Cahe_writeResp_valid)
    .Data_Cahe_readAddr_ready(WIRE_Data_Cahe_readAddr_ready)
    .Data_Cahe_readData_data(WIRE_Data_Cahe_readData_data)
    .Data_Cahe_readData_valid(WIRE_Data_Cahe_readData_valid)
    .Data_Cahe_writeAddr_ready(WIRE_Data_Cahe_writeAddr_ready)
    .Data_Cahe_writeData_ready(WIRE_Data_Cahe_writeData_ready)
    .Data_Cahe_writeResp_msg(WIRE_Data_Cahe_writeResp_msg)
    .Data_Cahe_writeResp_valid(WIRE_Data_Cahe_writeResp_valid)
    .Inst_Cahe_readAddr_addr(WIRE_Inst_Cahe_readAddr_addr)
    .Inst_Cahe_readAddr_valid(WIRE_Inst_Cahe_readAddr_valid)
    .Inst_Cahe_readData_ready(WIRE_Inst_Cahe_readData_ready)
    .Inst_Cahe_writeAddr_addr(WIRE_Inst_Cahe_writeAddr_addr)
    .Inst_Cahe_writeAddr_valid(WIRE_Inst_Cahe_writeAddr_valid)
    .Inst_Cahe_writeData_data(WIRE_Inst_Cahe_writeData_data)
    .Inst_Cahe_writeData_strb(WIRE_Inst_Cahe_writeData_strb)
    .Inst_Cahe_writeData_valid(WIRE_Inst_Cahe_writeData_valid)
    .Inst_Cahe_writeResp_ready(WIRE_Inst_Cahe_writeResp_ready)
    .Data_Cahe_readAddr_addr(WIRE_Data_Cahe_readAddr_addr)
    .Data_Cahe_readAddr_valid(WIRE_Data_Cahe_readAddr_valid)
    .Data_Cahe_readData_ready(WIRE_Data_Cahe_readData_ready)
    .Data_Cahe_writeAddr_addr(WIRE_Data_Cahe_writeAddr_addr)
    .Data_Cahe_writeAddr_valid(WIRE_Data_Cahe_writeAddr_valid)
    .Data_Cahe_writeData_data(WIRE_Data_Cahe_writeData_data)
    .Data_Cahe_writeData_strb(WIRE_Data_Cahe_writeData_strb)
    .Data_Cahe_writeData_valid(WIRE_Data_Cahe_writeData_valid)
    .Data_Cahe_writeResp_ready(WIRE_Data_Cahe_writeResp_ready)
    .halt(WIRE_halt)
);

// input pads: PDIDGZ (.PAD(PI), .C(WIRE))
// CORNER0
PDIDGZ PAD_Inst_Cahe_readAddr_addr(.PAD(PI_Inst_Cahe_readAddr_addr), .C(WIRE_Inst_Cahe_readAddr_addr));
PDIDGZ PAD_Inst_Cahe_readAddr_valid(.PAD(PI_Inst_Cahe_readAddr_valid), .C(WIRE_Inst_Cahe_readAddr_valid));
PDIDGZ PAD_Inst_Cahe_readData_ready(.PAD(PI_Inst_Cahe_readData_ready), .C(WIRE_Inst_Cahe_readData_ready));
PDIDGZ PAD_Inst_Cahe_writeAddr_addr(.PAD(PI_Inst_Cahe_writeAddr_addr), .C(WIRE_Inst_Cahe_writeAddr_addr));
PDIDGZ PAD_Inst_Cahe_writeAddr_valid(.PAD(PI_Inst_Cahe_writeAddr_valid), .C(WIRE_Inst_Cahe_writeAddr_valid));
PDIDGZ PAD_Inst_Cahe_writeData_data(.PAD(PI_Inst_Cahe_writeData_data), .C(WIRE_Inst_Cahe_writeData_data));
PDIDGZ PAD_Inst_Cahe_writeData_strb(.PAD(PI_Inst_Cahe_writeData_strb), .C(WIRE_Inst_Cahe_writeData_strb));
PDIDGZ PAD_Inst_Cahe_writeData_valid(.PAD(PI_Inst_Cahe_writeData_valid), .C(WIRE_Inst_Cahe_writeData_valid));
PDIDGZ PAD_Inst_Cahe_writeResp_ready(.PAD(PI_Inst_Cahe_writeResp_ready), .C(WIRE_Inst_Cahe_writeResp_ready));
PDIDGZ PAD_clk(.PAD(PI_clk), .C(WIRE_clk));
PDIDGZ PAD_rst(.PAD(PI_rst), .C(WIRE_rst));

// CORNER2
PDIDGZ PAD_Data_Cahe_readAddr_ready(.PAD(PI_Data_Cahe_readAddr_ready), .C(WIRE_Data_Cahe_readAddr_ready));
PDIDGZ PAD_Data_Cahe_readData_data(.PAD(PI_Data_Cahe_readData_data), .C(WIRE_Data_Cahe_readData_data));
PDIDGZ PAD_Data_Cahe_readData_valid(.PAD(PI_Data_Cahe_readData_valid), .C(WIRE_Data_Cahe_readData_valid));
PDIDGZ PAD_Data_Cahe_writeAddr_ready(.PAD(PI_Data_Cahe_writeAddr_ready), .C(WIRE_Data_Cahe_writeAddr_ready));
PDIDGZ PAD_Data_Cahe_writeData_ready(.PAD(PI_Data_Cahe_writeData_ready), .C(WIRE_Data_Cahe_writeData_ready));
PDIDGZ PAD_Data_Cahe_writeResp_msg(.PAD(PI_Data_Cahe_writeResp_msg), .C(WIRE_Data_Cahe_writeResp_msg));
PDIDGZ PAD_Data_Cahe_writeResp_valid(.PAD(PI_Data_Cahe_writeResp_valid), .C(WIRE_Data_Cahe_writeResp_valid));

// output pads: PDO02CDG (.I(WIRE), .PAD(PO))
// CORNER0
PDIDGZ PAD_halt(.I(WIRE_halt), .C(PO_halt));

// CORNER1
PDO02CDG PAD_Inst_Cahe_readAddr_addr(.I(WIRE_Inst_Cahe_readAddr_addr), .PAD(PO_Inst_Cahe_readAddr_addr));
PDO02CDG PAD_Inst_Cahe_readAddr_valid(.I(WIRE_Inst_Cahe_readAddr_valid), .PAD(PO_Inst_Cahe_readAddr_valid));
PDO02CDG PAD_Inst_Cahe_readData_ready(.I(WIRE_Inst_Cahe_readData_ready), .PAD(PO_Inst_Cahe_readData_ready));
PDO02CDG PAD_Inst_Cahe_writeAddr_addr(.I(WIRE_Inst_Cahe_writeAddr_addr), .PAD(PO_Inst_Cahe_writeAddr_addr));
PDO02CDG PAD_Inst_Cahe_writeAddr_valid(.I(WIRE_Inst_Cahe_writeAddr_valid), .PAD(PO_Inst_Cahe_writeAddr_valid));
PDO02CDG PAD_Inst_Cahe_writeData_data(.I(WIRE_Inst_Cahe_writeData_data), .PAD(PO_Inst_Cahe_writeData_data));
PDO02CDG PAD_Inst_Cahe_writeData_strb(.I(WIRE_Inst_Cahe_writeData_strb), .PAD(PO_Inst_Cahe_writeData_strb));
PDO02CDG PAD_Inst_Cahe_writeData_valid(.I(WIRE_Inst_Cahe_writeData_valid), .PAD(PO_Inst_Cahe_writeData_valid));
PDO02CDG PAD_Inst_Cahe_writeResp_ready(.I(WIRE_Inst_Cahe_writeResp_ready), .PAD(PO_Inst_Cahe_writeResp_ready));

// CORNER3
PDO02CDG PAD_Data_Cahe_readAddr_addr(.I(WIRE_Data_Cahe_readAddr_addr), .PAD(PO_Data_Cahe_readAddr_addr));
PDO02CDG PAD_Data_Cahe_readAddr_valid(.I(WIRE_Data_Cahe_readAddr_valid), .PAD(PO_Data_Cahe_readAddr_valid));
PDO02CDG PAD_Data_Cahe_readData_ready(.I(WIRE_Data_Cahe_readData_ready), .PAD(PO_Data_Cahe_readData_ready));
PDO02CDG PAD_Data_Cahe_writeAddr_addr(.I(WIRE_Data_Cahe_writeAddr_addr), .PAD(PO_Data_Cahe_writeAddr_addr));
PDO02CDG PAD_Data_Cahe_writeAddr_valid(.I(WIRE_Data_Cahe_writeAddr_valid), .PAD(PO_Data_Cahe_writeAddr_valid));
PDO02CDG PAD_Data_Cahe_writeData_data(.I(WIRE_Data_Cahe_writeData_data), .PAD(PO_Data_Cahe_writeData_data));
PDO02CDG PAD_Data_Cahe_writeData_strb(.I(WIRE_Data_Cahe_writeData_strb), .PAD(PO_Data_Cahe_writeData_strb));
PDO02CDG PAD_Data_Cahe_writeData_valid(.I(WIRE_Data_Cahe_writeData_valid), .PAD(PO_Data_Cahe_writeData_valid));
PDO02CDG PAD_Data_Cahe_writeResp_ready(.I(WIRE_Data_Cahe_writeResp_ready), .PAD(PO_Data_Cahe_writeResp_ready));





endmodule


