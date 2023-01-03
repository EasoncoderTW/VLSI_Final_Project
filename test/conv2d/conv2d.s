#reg use s1,s2,s4~11,ra
.data
IFM: .word 42,5,62,23,20,4,72,57,76,34,42,12,68,76,8,27,38,50,8,65,64,46,57,75,18
WEIGHT: .word 22,38,56,40,25,33,55,40,34
IFM_SIZE: .word 5
IFM_NUM: .word 25
KER_SIZE: .word 3

.text
#conv2d for fixed kernel size and IFM size
#both integer and weight is less than 256
conv2d:
    li sp 0xFFFC
    #a5 p_sum(conv)
    #s1 change of addr when x add 1(IFM)
    #s2 change of addr when x add 1(WEI)
    addi  sp, sp ,-44
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
    la t1 IFM_SIZE
    lw t1 0(t1)
    add a1 x0 t1
    addi t1 t1 -2
    #without padding =>-2
    #input change
    li a2 4
        #a word = 4 bytes
    jal x1 multi
    add s1 x0 a0
    #weight change
    la a1 KER_SIZE
    lw a1 0(a1)
    li a2 4
    jal x1 multi
    add s2 x0 a0
    #store result at B000
    li t3 0xB000
    #s4 base addr for some x(IFM)
    la s4 IFM
conv2d_loop_IFM_xaxis:
    #t1 x_loc of IFM
    #t2 y_loc of_IFM
    #t3 store addr 
    #s5 base addr for some y(IFM)
    la t2 IFM_SIZE
    lw t2 0(t2)
    addi t2 t2 -2
    #without padding =>-2
    add s5 x0 s4
    jal x0 conv2d_loop_IFM_yaxis
IFM_x_keep:
    addi t1 t1 -1
    add s4 s4 s1
    bne t1 x0 conv2d_loop_IFM_xaxis
    jal x0 exit_conv2d

conv2d_loop_IFM_yaxis:
    #s10 WEI x_addr
    #a5 p_sum
    #s6 base addr for some x,y(IFM)
    #s8 base addr for some x(KER)
    la s10 KER_SIZE
    lw s10 0(s10)
    la t0 IFM
    li a5 0
    add s6 x0 s5
    la s8 WEIGHT
    jal x0 conv2d_loop_WEI_xaxis
IFM_y_keep:
    addi t2 t2 -1
    sw a5 0(t3)
    addi t3 t3 4
    addi s5 s5 4
    bne t2 x0 conv2d_loop_IFM_yaxis
    jal x0 IFM_x_keep

conv2d_loop_WEI_xaxis:
    #s11 WEI y_addr
    #s7 base addr for some x,y(IFM) and x(KERNEL) - IFM
    #s9 base addr for some x(KERNEL) - KER
    la s11 KER_SIZE
    lw s11 0(s11)
    add s7 x0 s6
    add s9 x0 s8
    jal x0 conv2d_loop_WEI_yaxis
WEI_x_keep:
    addi s10 s10 -1
    add s6 s6 s1
    add s8 s8 s2
    bne s10 x0 conv2d_loop_WEI_xaxis
    jal x0 IFM_y_keep

conv2d_loop_WEI_yaxis:
    
    lw a1 0(s7)
    lw a2 0(s9)
    jal x1 multi
    add a5 a5 a0
    addi s11 s11 -1
    addi s7 s7 4
    addi s9 s9 4
    bne s11 x0 conv2d_loop_WEI_yaxis
    jal x0 WEI_x_keep

multi:
    #a1 multiplicand
    #a2 multiplier
    #a0 p_sum(mul)
    li a4 8
    li a0 0
loop_multi:
    #do multiply
    #a4 is counter
    andi a6 a2 128
    bne a6 x0 add_to_psum 
keep_mul:
    addi a4 a4 -1  
    slli a2 a2 1 
    slli a0 a0 1  
    bne a4 x0 loop_multi
    srli a0 a0 1
    ret
add_to_psum:
    add a0 a0 a1
    jal x0 keep_mul


exit_conv2d:
    ##restore reg 
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
    addi sp, sp ,-44

    hcf
    hcf
    hcf
    hcf
    hcf
