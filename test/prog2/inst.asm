addi sp, sp, -8
sw ra, 4(sp)
sw s0, 0(sp)
lui t6, 0xa
addi t0, x0, 1
addi t1, x0, 1
addi t5, x0, 30
sw t0, 0(t6)
addi t6, t6, 4
addi t4, x0, 2
sw t1, 0(t6)
beq t4, t5, exit
jal x1, fib_loop
jal x1, test_lb_lh_sb_sh_blt
jal x1, test_lbu_lhu_bge
jal x1, test_sub_sll_srl_sra_bltu
jal x1, test_xori_slli_srli_srai
jal x1, test_or_and_xor_slt_sltu
jal x1, test_andi_ori_slti_sltiu_bgeu
jal x1, test_lui_auipc
jal x0, exit
addi t6, t6, 4
addi t4, t4, 1
add t2, t1, t0
sw t2, 0(t6)
beq t4, t5, go_back
addi t6, t6, 4
addi t4, t4, 1
add t0, t2, t1
sw t0, 0(t6)
beq t4, t5, go_back
addi t6, t6, 4
addi t4, t4, 1
add t1, t0, t2
sw t1, 0(t6)
beq t4, t5, go_back
jal x0, fib_loop
addi t6, t6, 4
sw x0, 0(t6)
jalr x0, 0(x1)
lui s0, 0xa
lb t1, 44(s0)
addi t6, t6, 4
sw t1, 0(t6)
addi t6, t6, 4
sb t1, 0(t6)
lh t2, 108(s0)
addi t6, t6, 4
sw t2, 0(t6)
addi t6, t6, 4
sh t2, 0(t6)
blt t2, t1, go_back
lbu t1, 44(s0)
addi t6, t6, 4
sw t1, 0(t6)
lhu t2, 108(s0)
addi t6, t6, 4
sw t2, 0(t6)
bge t2, t1, go_back
lw t1, 48(s0)
lw t2, 52(s0)
lw t4, 12(s0)
sub t3, t2, t1
addi t6, t6, 4
sw t3, 0(t6)
sll t3, t1, t4
addi t6, t6, 4
sw t3, 0(t6)
srl t3, t1, t4
addi t6, t6, 4
sw t3, 0(t6)
sra t3, t1, t4
addi t6, t6, 4
sw t3, 0(t6)
bltu t1, t2, go_back
lw t1, 48(s0)
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
lw t1, 48(s0)
lw t2, 52(s0)
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
sltiu t3, t2, 777
addi t6, t6, 4
sw t3, 0(t6)
bltu t3, t1, go_back
lw t1, 48(s0)
andi t2, t1, 777
addi t6, t6, 4
sw t2, 0(t6)
ori t2, t1, 777
addi t6, t6, 4
sw t2, 0(t6)
slti t2, t1, 777
addi t6, t6, 4
sw t2, 0(t6)
sltiu t2, t1, 777
addi t6, t6, 4
sw t2, 0(t6)
bgeu t1, t2, go_back
lw t1, 48(s0)
lui t1, 777
addi t6, t6, 4
sw t1, 0(t6)
auipc t2, 777
addi t6, t6, 4
sw t2, 0(t6)
bgeu t2, t1, go_back
lw s0, 0(sp)
lw ra, 4(sp)
addi sp, sp, 4
jal halt
hcf