`include "./CPU_Components/rv32_define.v"

module PC #(parameter addrWidth = 16)(
    input clk,
    input rst,
    input Hcf,
    input Stall,
    input [1:0] PCSel,
    input [addrWidth-1:0] Predict_Target_pc,
    input [addrWidth-1:0] EXE_Target_pc,
    input [addrWidth-1:0] EXE_pc,
    output wire [addrWidth-1:0] pc
);

reg [addrWidth-1:0] pcReg;

wire [addrWidth-1:0] pc_next;
wire [addrWidth-1:0] pc_plus_4;
wire [addrWidth-1:0] EXE_pc_plus_4;
/* combinational circuit */
assign pc_plus_4 = (pcReg + 4);
assign EXE_pc_plus_4 = (EXE_pc + 4);

assign pc_next = (Hcf | Stall)? pcReg:
                 (PCSel == `IF_P_T_PC)? Predict_Target_pc:
                 (PCSel == `EXE_PC_PLUS_4)? EXE_pc_plus_4:
                 (PCSel == `EXE_T_PC)? EXE_Target_pc:pc_plus_4;
assign pc = pcReg;

/* sequentail citcuit */
always @(posedge clk or posedge rst) begin
    if(rst)begin
        pcReg <= 32'd0;
    end
    else begin
        pcReg <= pc_next;
    end
end

endmodule
