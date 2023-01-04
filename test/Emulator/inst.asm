lui x02, 0x00000010
addi x02, x02, 0x00000000
addi sp, sp, -4
sw s0, 0(sp)
lui x08, 0x00000008
addi x08, x08, 0x00000134
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
lw s0, 0(sp)
addi sp, sp, 4
hcf
hcf
hcf
hcf
hcf
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
hcf