lui x02, 0x00000010
addi x02, x02, 0x00000000
addi sp, sp, -4
sw s0, 0(sp)
lui x08, 0x00000008
addi x08, x08, 0x00000148
addi sp, sp, -16
sw s0, 12(sp)
sw s1, 8(sp)
sw s2, 4(sp)
sw s3, 0(sp)
lui x19, 0x00000000
addi x19, x19, 0x00000001
lui x08, 0x00000008
addi x08, x08, 0x00000000
lui x09, 0x00000008
addi x09, x09, 0x00000128
lui x18, 0x00000009
addi x18, x18, 0x00000000
j x0, copy_data
lui x19, 0x00000000
addi x19, x19, 0x00000002
lui x08, 0x00000008
addi x08, x08, 0x00000080
lui x09, 0x00000008
addi x09, x09, 0x0000012c
lui x18, 0x00000009
addi x18, x18, 0x00000000
lui x05, 0x00000008
addi x05, x05, 0x00000128
lw t1, 0(t0)
slli t1, t1, 2
add s2, s2, t1
j x0, copy_data
lui x19, 0x00000000
addi x19, x19, 0x00000003
lui x08, 0x00000008
addi x08, x08, 0x000000bc
lui x09, 0x00000008
addi x09, x09, 0x00000130
lui x18, 0x00000009
addi x18, x18, 0x00000000
lui x05, 0x00000008
addi x05, x05, 0x00000128
lw t1, 0(t0)
slli t1, t1, 2
add s2, s2, t1
lui x05, 0x00000008
addi x05, x05, 0x0000012c
lw t1, 0(t0)
slli t1, t1, 2
add s2, s2, t1
j x0, copy_data
lui x05, 0x00000000
addi x05, x05, 0x00000000
lw t3, 0(s1)
slli t3, t3, 2
add t1, t0, s0
lw t2, 0(t1)
add t1, t0, s2
sw t2, 0(t1)
addi t0, t0, 4
blt t0, t3, copy_loop
add a0, s2, x0
lui x11, 0x00000000
addi x11, x11, 0x00000000
lw a2, 0(s1)
addi a2, a2, -1
addi sp, sp, -4
sw ra, 0(sp)
jal ra, mergesort
lw ra, 0(sp)
addi sp, sp, 4
addi s3, s3, -1
beq s3, x0, load_test_2
addi s3, s3, -1
beq s3, x0, load_test_3
lw s0, 12(sp)
lw s1, 8(sp)
lw s2, 4(sp)
lw s3, 0(sp)
addi sp, sp, 16
jal fib_and_instest
jal conv2d
jal x0, main_exit
bge a1, a2, mergesort_ret
addi sp, sp, -12
sw s0, 8(sp)
sw s1, 4(sp)
sw s2, 0(sp)
add s1, a1, x0
add s2, a2, x0
add s0, a1, a2
srai s0, s0, 1
addi sp, sp, -4
sw ra, 0(sp)
add a1, s1, x0
add a2, s0, x0
jal ra, mergesort
addi a1, s0, 1
add a2, s2, x0
jal ra, mergesort
add a1, s1, x0
add a2, s0, x0
add a3, s2, x0
jal ra, merge
lw ra, 0(sp)
addi sp, sp, 4
lw s0, 8(sp)
lw s1, 4(sp)
lw s2, 0(sp)
addi sp, sp, 12
jalr x0, 0(ra)
sub t0, a3, a1
addi t0, t0, 1
slli t1, t0, 2
sub sp, sp, t1
add t1, sp, x0
lui x07, 0x00000000
addi x07, x07, 0x00000000
bge t2, t0, for_loop_1_end
add t3, t2, a1
slli t3, t3, 2
add t3, t3, a0
lw t4, 0(t3)
slli t3, t2, 2
add t3, t3, t1
sw t4, 0(t3)
addi t2, t2, 1
blt t2, t0, for_loop_1
addi sp, sp, -20
sw s0, 0(sp)
sw s1, 4(sp)
sw s2, 8(sp)
sw s3, 12(sp)
sw s4, 16(sp)
lui x08, 0x00000000
addi x08, x08, 0x00000000
sub s1, a2, a1
addi s2, s1, 1
sub s3, a3, a1
add s4, a1, x0
blt s1, s0, while_loop_1_end
blt s3, s2, while_loop_1_end
slli t2, s0, 2
add t2, t2, t1
lw t3, 0(t2)
slli t2, s2, 2
add t2, t2, t1
lw t4, 0(t2)
slli t2, s4, 2
add t2, t2, a0
blt t4, t3, else_1
sw t3, 0(t2)
addi s4, s4, 1
addi s0, s0, 1
j x0, if_1_end
sw t4, 0(t2)
addi s4, s4, 1
addi s2, s2, 1
j x0, while_loop_1
blt s1, s0, while_loop_2_end
slli t2, s0, 2
add t2, t2, t1
lw t3, 0(t2)
slli t2, s4, 2
add t2, t2, a0
sw t3, 0(t2)
addi s4, s4, 1
addi s0, s0, 1
bge s1, s0, while_loop_2
blt s3, s2, while_loop_3_end
slli t2, s2, 2
add t2, t2, t1
lw t3, 0(t2)
slli t2, s4, 2
add t2, t2, a0
sw t3, 0(t2)
addi s4, s4, 1
addi s2, s2, 1
bge s3, s2, while_loop_3
lw s0, 0(sp)
lw s1, 4(sp)
lw s2, 8(sp)
lw s3, 12(sp)
lw s4, 16(sp)
addi sp, sp, 20
slli t1, t0, 2
add sp, sp, t1
jalr x0, 0(ra)
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
beq t4, t5, test
jal x1, fib_loop
jal x1, test_lb_lh_sb_sh_blt
jal x1, test_lbu_lhu_bge
jal x1, test_sub_sll_srl_sra_bltu
jal x1, test_xori_slli_srli_srai
jal x1, test_or_and_xor_slt_sltu
jal x1, test_andi_ori_slti_sltiu_bgeu
jal x1, test_lui_auipc
jal x1, fib_exit
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
addi sp, sp, 8
jalr x0, x1, x0
addi sp, sp, -44
sw ra, 0(sp)
sw s1, 4(sp)
sw s2, 8(sp)
sw s4, 12(sp)
sw s5, 16(sp)
sw s6, 20(sp)
sw s7, 24(sp)
sw s8, 28(sp)
sw s9, 32(sp)
sw s10, 36(sp)
sw s11, 40(sp)
lui x06, 0x00000008
addi x06, x06, 0x0000013c
lw t1, 0(t1)
add a1, x0, t1
addi t1, t1, -2
lui x12, 0x00000000
addi x12, x12, 0x00000004
jal x1, multi
add s1, x0, a0
lui x11, 0x00000008
addi x11, x11, 0x00000144
lw a1, 0(a1)
lui x12, 0x00000000
addi x12, x12, 0x00000004
jal x1, multi
add s2, x0, a0
lui x28, 0x0000000b
addi x28, x28, 0x00000000
lui x20, 0x00000008
addi x20, x20, 0x00000134
lui x07, 0x00000008
addi x07, x07, 0x0000013c
lw t2, 0(t2)
addi t2, t2, -2
add s5, x0, s4
jal x0, conv2d_loop_ifm_yaxis
addi t1, t1, -1
add s4, s4, s1
bne t1, x0, conv2d_loop_ifm_xaxis
jal x0, exit_conv2d
lui x26, 0x00000008
addi x26, x26, 0x00000144
lw s10, 0(s10)
lui x05, 0x00000008
addi x05, x05, 0x00000134
lui x15, 0x00000000
addi x15, x15, 0x00000000
add s6, x0, s5
lui x24, 0x00000008
addi x24, x24, 0x00000138
jal x0, conv2d_loop_wei_xaxis
addi t2, t2, -1
sw a5, 0(t3)
addi t3, t3, 4
addi s5, s5, 4
bne t2, x0, conv2d_loop_ifm_yaxis
jal x0, ifm_x_keep
lui x27, 0x00000008
addi x27, x27, 0x00000144
lw s11, 0(s11)
add s7, x0, s6
add s9, x0, s8
jal x0, conv2d_loop_wei_yaxis
addi s10, s10, -1
add s6, s6, s1
add s8, s8, s2
bne s10, x0, conv2d_loop_wei_xaxis
jal x0, ifm_y_keep
lw a1, 0(s7)
lw a2, 0(s9)
jal x1, multi
add a5, a5, a0
addi s11, s11, -1
addi s7, s7, 4
addi s9, s9, 4
bne s11, x0, conv2d_loop_wei_yaxis
jal x0, wei_x_keep
lui x14, 0x00000000
addi x14, x14, 0x00000008
lui x10, 0x00000000
addi x10, x10, 0x00000000
andi a6, a2, 128
bne a6, x0, add_to_psum
addi a4, a4, -1
slli a2, a2, 1
slli a0, a0, 1
bne a4, x0, loop_multi
srli a0, a0, 1
jalr x0, x1, x0
add a0, a0, a1
jal x0, keep_mul
lw ra, 0(sp)
lw s1, 4(sp)
lw s2, 8(sp)
lw s4, 12(sp)
lw s5, 16(sp)
lw s6, 20(sp)
lw s7, 24(sp)
lw s8, 28(sp)
lw s9, 32(sp)
lw s10, 36(sp)
lw s11, 40(sp)
addi sp, sp, -44
jalr x0, x1, x0
lw s0, 0(sp)
addi sp, sp, 4
hcf