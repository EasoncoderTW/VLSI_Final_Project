lui x02, 0x00000010
addi x02, x02, 0x00000000
lui x06, 0x00000008
addi x06, x06, 0x00000088
lw t1, 0(t1)
add a1, x0, t1
addi t1, t1, -2
lui x12, 0x00000000
addi x12, x12, 0x00000004
jal x1, multi
add s1, x0, a0
lui x11, 0x00000008
addi x11, x11, 0x00000090
lw a1, 0(a1)
lui x12, 0x00000000
addi x12, x12, 0x00000004
jal x1, multi
add s2, x0, a0
lui x28, 0x0000000b
addi x28, x28, 0x00000000
lui x20, 0x00000008
addi x20, x20, 0x00000000
lui x07, 0x00000008
addi x07, x07, 0x00000088
lw t2, 0(t2)
addi t2, t2, -2
add s5, x0, s4
jal x0, conv2d_loop_ifm_yaxis
addi t1, t1, -1
add s4, s4, s1
bne t1, x0, conv2d_loop_ifm_xaxis
jal x0, exit_conv2d
lui x26, 0x00000008
addi x26, x26, 0x00000090
lw s10, 0(s10)
lui x05, 0x00000008
addi x05, x05, 0x00000000
lui x15, 0x00000000
addi x15, x15, 0x00000000
add s6, x0, s5
lui x24, 0x00000008
addi x24, x24, 0x00000064
jal x0, conv2d_loop_wei_xaxis
addi t2, t2, -1
sw a5, 0(t3)
addi t3, t3, 4
addi s5, s5, 4
bne t2, x0, conv2d_loop_ifm_yaxis
jal x0, ifm_x_keep
lui x27, 0x00000008
addi x27, x27, 0x00000090
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
hcf
hcf
hcf
hcf
hcf
hcf