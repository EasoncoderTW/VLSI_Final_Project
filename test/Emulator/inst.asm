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