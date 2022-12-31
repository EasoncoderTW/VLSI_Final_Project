#reg use s0~11,ra
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
    #a5 p_sum(conv)
    addi  sp, sp ,-4
    sw x1, 0(sp)
    la t1 IFM_SIZE
    lw t1 0(t1)
    li t3 0xB000
    #without padding =>-2
    addi t1 t1 -2
conv2d_loop_IFM_xaxis:
    #t1 x_loc of IFM
    #t2 y_loc of_IFM
    #t3 store addr 
    la t2 IFM_SIZE
    lw t2 0(t2)
    addi t2 t2 -2
    jal x0 conv2d_loop_IFM_yaxis
IFM_x_keep:
    addi t1 t1 -1
    bne t1 x0 conv2d_loop_IFM_xaxis
    jal x0 exit

conv2d_loop_IFM_yaxis:
    #s10 WEI x_addr
    la s10 KER_SIZE
    lw s10 0(s10)
    la t0 IFM
    li a5 0
    jal x0 conv2d_loop_WEI_xaxis
IFM_y_keep:
    addi t2 t2 -1
    sw a5 0(t3)
    bne t2 x0 conv2d_loop_IFM_yaxis
    jal x0 IFM_x_keep

conv2d_loop_WEI_xaxis:
    #s11 WEI y_addr
    la s11 KER_SIZE
    lw s11 0(s11)
    jal x0 conv2d_loop_WEI_yaxis
WEI_x_keep:
    addi s10 s10 -1
    bne s10 x0 conv2d_loop_WEI_xaxis
    jal x0 IFM_y_keep

conv2d_loop_WEI_yaxis:
    #s0 addr offset
    li s0 0
    la t0 IFM
    #load input
    jal x0 load_input
load_input_fin:
    #s3 weight    
    add t0 t0 s0 
    lw t0 0(t0)
    #load weight
    la a2 KER_SIZE
    jal x0 load_input
load_weight_fin:    
    add s3 s3 s0
    lw s3 0(t0)
    addi a1 t0 0
    addi a2 s3 0
    jal x1 multi
    addi s11 s11 -1
    add a5 a5 a0
    bne s11 x0 conv2d_loop_WEI_yaxis
    jal x0 WEI_x_keep

load_input:
    #loc_x
    #ini a2 =>size addr
    add a1 x0 t1  
    la a2 IFM_SIZE
    lw a2 0(a2)
    slli a2 a2 2
    jal  x1 multi
    add s0 s0 a0
    #loc_y
    add a1 x0 t2
    li a2 4
    jal x1 multi
    add s0 s0 a0
    jal x0 load_weight_fin


load_weight:
    #loc_x
    #ini a2 =>size addr
    add a1 x0 t1  
    la a2 KER_SIZE
    lw a2 0(a2)
    slli a2 a2 2
    jal  x1 multi
    add s0 s0 a0
    #loc_y
    add a1 x0 t2
    li a2 4
    jal x1 multi
    add s0 s0 a0
    jal x0 load_input_fin

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
    slli a2 a2 1 
    slli a0 a0 1
    addi a4 a4 -1    
    beq a4 x0 loop_multi
    ret
add_to_psum:
    add a0 a0 a1
    jal x0 keep_mul


exit:
    jal halt

halt:
    ret