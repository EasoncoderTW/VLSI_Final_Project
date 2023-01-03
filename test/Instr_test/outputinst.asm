addi sp, sp, -4
sw ra, 0(sp)
lui t6, 0xc
addi x1, x0, 0
jal x1, store_jal_result
lui x05, 0x00000000
addi x05, x05, 0x00000fff
addi t6, t6, 4
sw t2, 0(t6)
addi t6, t6, 4
sw t2, 0(t6)
addi t6, t6, 4
sw t2, 0(t6)
addi t6, t6, 4
sw t2, 0(t6)
addi t6, t6, 4
sw t2, 0(t6)
jal exit
sw x1, 0(t6)
addi t6, t6, 4
sw x0, 0(t6)
jal x1, test_lb_lh_sb_sh_blt
jal x1, test_add_addi_beq
jal x1, test_bne
jal x1, test_blt_equal
jal x1, test_lbu_lhu_bge
jal x1, test_bge_equal
jal x1, test_sub_sll_srl_sra_bltu
jal x1, test_bgeu_equal
jal x1, test_xori_slli_srli_srai
jal x1, test_or_and_xor_slt_sltu
jal x1, test_andi_ori_slti_sltiu_bgeu
jal x1, test_lui_auipc
jal x0, exit
addi t6, t6, 4
sw x0, 0(t6)
jalr x0, 0(x1)
lui x29, 0x00000008
addi x29, x29, 0x00000000
lb t1, 8(t4)
addi t6, t6, 4
sw t1, 0(t6)
addi t6, t6, 4
sb t1, 0(t6)
lh t2, 12(t4)
addi t6, t6, 4
sw t2, 0(t6)
addi t6, t6, 4
sh t2, 0(t6)
blt t1, t2, error
blt t2, t1, go_back
jal error
blt t1, t1, error
jal x0, go_back
lui x06, 0x00000000
addi x06, x06, 0x00000021
lui x07, 0x00000000
addi x07, x07, 0x0000004d
add t3, t1, t2
addi t6, t6, 4
sw t3, 0(t6)
addi t3, t1, 56
addi t6, t6, 4
sw t3, 0(t6)
beq t1, t2, error
lui x07, 0x00000000
addi x07, x07, 0x00000021
beq t1, t2, go_back
jal error
lui x06, 0x00000000
addi x06, x06, 0x00000021
lui x07, 0x00000000
addi x07, x07, 0x00000021
lui x28, 0x00000000
addi x28, x28, 0x00000022
bne t1, t2, error
bne t1, t3, pass
jal error
lui x07, 0x00000000
addi x07, x07, 0x00000800
addi t6, t6, 4
sw t2, 0(t6)
jal x0, go_back
lui x29, 0x00000008
addi x29, x29, 0x00000000
lbu t1, 8(t4)
addi t6, t6, 4
sw t1, 0(t6)
lhu t2, 12(t4)
addi t6, t6, 4
sw t2, 0(t6)
bge t1, t2, error
bge t2, t1, go_back
jal error
bge t1, t1, go_back
jal error
lui x29, 0x00000008
addi x29, x29, 0x00000000
lw t1, 0(t4)
lw t2, 4(t4)
lui x30, 0x00000000
addi x30, x30, 0x00000008
sub t3, t2, t1
addi t6, t6, 4
sw t3, 0(t6)
sll t3, t1, t5
addi t6, t6, 4
sw t3, 0(t6)
srl t3, t1, t5
addi t6, t6, 4
sw t3, 0(t6)
sra t3, t1, t5
addi t6, t6, 4
sw t3, 0(t6)
bltu t2, t1, error
bltu t1, t2, go_back
jal error
bltu t1, t1, error
jal go_back
lui x06, 0x00000000
addi x06, x06, 0x0000029a
xori t2, t1, 777
addi t6, t6, 4
sw t2, 0(t6)
slli t2, t1, 4
addi t6, t6, 4
sw t2, 0(t6)
srli t2, t1, 4
addi t6, t6, 4
sw t2, 0(t6)
srai t2, t1, 4
addi t6, t6, 4
sw t2, 0(t6)
bltu t2, t1, go_back
jal error
lui x28, 0x00000008
addi x28, x28, 0x00000000
lw t1, 0(t3)
lw t2, 4(t2)
or t3, t2, t1
addi t6, t6, 4
sw t3, 0(t6)
and t3, t2, t1
addi t6, t6, 4
sw t3, 0(t6)
xor t3, t2, t1
addi t6, t6, 4
sw t3, 0(t6)
slt t3, t2, t1
addi t6, t6, 4
sw t3, 0(t6)
slt t3, t1, t2
addi t6, t6, 4
sw t3, 0(t6)
sltu t3, t2, t1
addi t6, t6, 4
sw t3, 0(t6)
sltu t3, t1, t2
addi t6, t6, 4
sw t3, 0(t6)
bltu t3, t1, go_back
jal error
lui x28, 0x00000008
addi x28, x28, 0x00000000
lw t1, 0(t3)
lw t2, 4(t3)
andi t3, t1, 777
addi t6, t6, 4
sw t3, 0(t6)
ori t3, t1, 777
addi t6, t6, 4
sw t3, 0(t6)
slti t3, t1, 777
addi t6, t6, 4
sw t3, 0(t6)
slti t3, t2, 777
addi t6, t6, 4
sw t3, 0(t6)
sltiu t3, t1, 777
addi t6, t6, 4
sw t3, 0(t6)
sltiu t3, t2, 777
addi t6, t6, 4
sw t3, 0(t6)
lui x28, 0x00000008
addi x28, x28, 0x00000000
lw t2, 8(t3)
sltiu t3, t2, 777
addi t6, t6, 4
sw t3, 0(t6)
bgeu t2, t1, error
bgeu t1, t2, go_back
jal error
bgeu t1, t1, go_back
jal error
lui t1, 777
addi t6, t6, 4
sw t1, 0(t6)
auipc t2, 777
addi t6, t6, 4
sw t2, 0(t6)
bgeu t2, t1, go_back
jal error
lui x05, 0x00000000
addi x05, x05, 0x00000fff
addi t6, t6, 4
sw t2, 0(t6)
addi t6, t6, 4
sw t2, 0(t6)
addi t6, t6, 4
sw t2, 0(t6)
addi t6, t6, 4
sw t2, 0(t6)
addi t6, t6, 4
sw t2, 0(t6)
jal exit
lw ra, 0(sp)
addi sp, sp, 4
hcf