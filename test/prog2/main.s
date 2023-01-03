.data
test1: .word 16 2 4 16 4 10 12 2 14 8 4 14 6 4 2 10 12 6 10 2 14 14 6 8 16 8 16 6 12 10 8 123
test2: .word 470 405 225 197 126 122 56 33 -81 -275 -379 -409 -416 -496 -500
test3: .word 412 -474 443 171 -23 247 221 7 40 221 -90 61 -9 49 -80 -80 221 -379 -161 -397 -173 276 -197 221 -12 -145 101
TEST1_SIZE: .word 32
TEST2_SIZE: .word 15
TEST3_SIZE: .word 27
IFM: .word 42,5,62,23,20,4,72,57,76,34,42,12,68,76,8,27,38,50,8,65,64,46,57,75,18
WEIGHT: .word 22,38,56,40,25,33,55,40,34
IFM_SIZE: .word 5
IFM_NUM: .word 25
KER_SIZE: .word 3
_answer: .word 0


.text

    li sp 0x10000
main:
    #addi  sp, sp ,-4
    #sw s0, 0(sp)
    la s0, _answer
    
    # Collee save
    addi  sp, sp, -16
    sw    s0, 12(sp)   
    # @s0 -> MEM[@sp-4]
    sw    s1, 8(sp)   
    # @s1 -> MEM[@sp-8]
    sw    s2, 4(sp)   
    # @s2 -> MEM[@sp-12]
    sw    s3, 0(sp)   
    # @s3 -> MEM[@sp-16]
    
    ###
    # s0 : test data address
    # s1 : test data size address
    # s2 : sorted test data address
    # s3 : dataset idex
    ###

    # Load data
load_test_1:
    li    s3, 1
    la    s0, test1
    la    s1, TEST1_SIZE
    li    s2, 0x9000
    j     copy_data
load_test_2:
    li    s3, 2
    la    s0, test2
    la    s1, TEST2_SIZE
    li    s2, 0x9000
    la    t0, TEST1_SIZE
    lw    t1, 0(t0)
    slli  t1, t1 ,2
    add   s2, s2, t1
    j     copy_data
load_test_3:
    li    s3, 3
    la    s0, test3
    la    s1, TEST3_SIZE
    li    s2, 0x9000
    la    t0, TEST1_SIZE
    lw    t1, 0(t0)
    slli  t1, t1 ,2
    add   s2, s2, t1
    la    t0, TEST2_SIZE
    lw    t1, 0(t0)
    slli  t1, t1 ,2
    add   s2, s2, t1
    j     copy_data
    

copy_data:
    li    t0, 0
    lw    t3, 0(s1)
    slli  t3, t3, 2
copy_loop:
    add   t1, t0, s0
    lw    t2,0(t1)
    add   t1, t0, s2
    sw    t2,0(t1)
    addi  t0, t0, 4
    blt   t0, t3, copy_loop

    # set parameters
    add   a0, s2, x0
    li    a1, 0
    lw    a2, 0(s1)
    addi  a2, a2, -1
    
    # Caller save
    addi  sp, sp, -4
    sw    ra, 0(sp)   
    # ra -> MEM[@sp-4]
    
    # Call function
    jal   ra, mergesort
    
    # Caller save pop
    lw    ra, 0(sp)   
    # MEM[@sp-4] -> ra
    addi  sp, sp, 4

    # return to load data
    addi  s3, s3 ,-1
    beq   s3, x0, load_test_2    
    # jump if s3 = 1
    addi  s3, s3 ,-1
    beq   s3, x0, load_test_3    
    # jump if s3 = 2
    
    # Collee save pop
    lw    s0, 12(sp)  
    # MEM[@sp-4] -> @s0
    lw    s1, 8(sp)   
    # MEM[@sp-8] -> @s1
    lw    s2, 4(sp)   
    # MEM[@sp-12] -> @s2
    lw    s3, 0(sp)   
    # MEM[@sp-16] -> @s3
    addi  sp, sp, 16
    jal fib_and_instest
    jal conv2d
    jal x0 main_exit

    
#------------------------#
#   Function mergesort   #
#------------------------#

mergesort:
    ####
    # a0: array address
    # a1: start offset
    # a2: end offset
    ####
    
    bge a1, a2, mergesort_ret    
    # if start >= end, sort finished
    
    ### if(start < end)
    
    # Collee save
    addi  sp, sp, -12
    sw    s0, 8(sp)   
    # @s0 -> MEM[@sp-4]
    sw    s1, 4(sp)    
    # @s1 -> MEM[@sp-8]
    sw    s2, 0(sp)    
    # @s2 -> MEM[@sp-12]

    # set data
    add   s1, a1, x0
    add   s2, a2, x0
    # s0: mid = (end + start)/2
    add   s0, a1, a2
    srai  s0, s0, 1    
    
    # Caller save
    addi  sp, sp, -4
    sw    ra, 0(sp)   
    # @ra -> MEM[@sp-4]
    
    ### code: mergesort(arr, start, mid)
    # set parameters
    # a0: address (fixed)
    add   a1, s1, x0        
    # a1: start
    add   a2, s0, x0        
    # a2: mid
    # Call mergesort
    jal   ra, mergesort
    
    ### code: mergesort(arr, mid+1, end)
    # set parameters
    # a0: address (fixed)
    addi  a1, s0, 1      
    # a1: mid+1
    add    a2, s2, x0         
    # a2: end
    # Call mergesort
    jal   ra, mergesort
    
    ### code: merge(arr, start, mid, end)
    # set parameters
    # a0: address (fixed)
    add    a1, s1 ,x0        
    # a1: start
    add    a2, s0 ,x0       
    # a2: mid
    add    a3, s2 ,x0       
    # a2: end
    # Call merge
    jal   ra, merge
    
    # Caller save pop
    lw    ra, 0(sp)   
    # @ra -> MEM[@sp-4]
    addi  sp, sp, 4
    
    # Collee save pop
    lw    s0, 8(sp)   
    # @s0 -> MEM[@sp-4]
    lw    s1, 4(sp)    
    # @s1 -> MEM[@sp-8]
    lw    s2, 0(sp)    
    # @s2 -> MEM[@sp-12]
    addi  sp, sp, 12
    
mergesort_ret:
    jalr x0, 0(ra)

#--------------------#
#   Function merge   #
#--------------------#
merge:
    ####
    # a0: array address
    # a1: start offset
    # a2: mid offset
    # a3: end offset
    ####
    
    # t0: temp_size = end - start + 1
    sub   t0, a3, a1
    addi  t0, t0, 1
    
    # t1: temp[temp_size] address in stack (@temp[])
    slli  t1, t0, 2
    sub   sp, sp, t1    
    # @sp = @sp - temp_size*4(byte)
    add   t1, sp, x0
    
    ### for(int i = 0; i< temp_size;i++)
    # t2: int i
    li    t2, 0    
    bge   t2, t0, for_loop_1_end
for_loop_1:
    add   t3, t2, a1    
    # t3 = i + start
    slli  t3, t3, 2
    add   t3, t3, a0    
    # t3 = @arr[i + start]
    lw    t4, 0(t3)     
    # arr[i + start] -> t4
    slli  t3, t2, 2
    add   t3, t3, t1    
    # t3 = @temp[i]
    sw    t4, 0(t3)     
    # t4 -> temp[i]
    
    addi  t2, t2, 1     
    # i++
    blt   t2, t0, for_loop_1
for_loop_1_end:    
    
    ### set index
    # Collee save
    addi  sp, sp, -20
    sw    s0, 0(sp)
    sw    s1, 4(sp)
    sw    s2, 8(sp)
    sw    s3, 12(sp)
    sw    s4, 16(sp)
    
    # inde initial
    li    s0, 0         
    # s0: left_index  = 0
    sub   s1, a2, a1    
    # s1: left_max    = mid-start
    addi  s2, s1, 1     
    # s2: right_index = mid-start+1
    sub   s3, a3, a1    
    # s1: right_max   = end-start
    add   s4, a1, x0    
    # s4: arr_index   = start
    
    ### while(left_index <= left_max && right_index <= right_max)
while_loop_1:
    blt   s1, s0, while_loop_1_end    
    # (left_index <= left_max) = false
    blt   s3, s2, while_loop_1_end    
    # (right_index <= right_max) = false
    
    ### if(temp[left_index] <= temp[right_index])
    slli  t2, s0, 2         
    # temp[left_index] -> t3
    add   t2, t2, t1        
    # word
    lw    t3, 0(t2)
    slli  t2, s2, 2         
    # temp[right_index] -> t4
    add   t2, t2, t1        
    # word
    lw    t4, 0(t2)
    slli  t2, s4, 2         
    # @arr[arr_index] -> t2
    # word
    add   t2, t2, a0        
    blt   t4, t3, else_1
if_1:      
    sw    t3, 0(t2)        
    # arr[arr_index] = temp[left_index]
    addi  s4, s4, 1        
    # arr_index++
    addi  s0, s0, 1        
    # left_index++
    j     if_1_end    
else_1:      
    sw    t4, 0(t2)        
    # arr[arr_index] = temp[right_index]
    addi  s4, s4, 1        
    # arr_index++
    addi  s2, s2, 1        
    # right_index++
if_1_end:    
    j    while_loop_1
while_loop_1_end:

### while(left_index <= left_max)
    blt   s1, s0, while_loop_2_end    
    # (left_index <= left_max) = false
while_loop_2:
    slli  t2, s0, 2         
    # word
    add   t2, t2, t1        
    # temp[left_index] -> t3
    lw    t3, 0(t2)
    slli  t2, s4, 2         
    # word
    add   t2, t2, a0        
    # @arr[arr_index] -> t2
    sw    t3, 0(t2)         
    # arr[arr_index] = temp[left_index]
    addi  s4, s4, 1         
    # arr_index++
    addi  s0, s0, 1         
    # left_index++
    bge   s1, s0, while_loop_2    
    # (left_index <= left_max) = true
while_loop_2_end:
    blt   s3, s2, while_loop_3_end    
    # (right_index <= right_max) = false
while_loop_3:
    slli  t2, s2, 2         
    # word
    add   t2, t2, t1        
    # temp[right_index] -> t3
    lw    t3, 0(t2)
    slli  t2, s4, 2         
    # word
    add   t2, t2, a0        
    # @arr[arr_index] -> t2
    sw    t3, 0(t2)         
    # arr[arr_index] = temp[right_index]
    addi  s4, s4, 1         
    # arr_index++
    addi  s2, s2, 1         
    # right_index++
    bge   s3, s2, while_loop_3    
    # (right_index <= right_max) = true
while_loop_3_end:
    
    # Collee save pop
    lw    s0, 0(sp)
    lw    s1, 4(sp)
    lw    s2, 8(sp)
    lw    s3, 12(sp)
    lw    s4, 16(sp)
    addi  sp, sp, 20
    
    # release temp array in stack
    slli  t1, t0, 2
    add   sp ,sp, t1    
    # @sp = @sp + temp_size
    
    jalr x0, 0(ra)


fib_and_instest:
    addi sp sp -8
    sw ra 4(sp)
    sw s0 0(sp)
    # t6  store pointer
    lui  t6 0xA
    addi t0 x0 1 
    addi t1 x0 1 
    #do 30 times
    addi t5 x0 30   
    sw t0 0(t6)  
    addi t6 t6 4 
    #t4 = counter
    addi t4 x0 2  
    sw t1 0(t6) 
    beq t4 t5 test 
    # x1 as rd 
    jal x1 fib_loop
test:
    jal x1 test_lb_lh_sb_sh_blt
    jal x1 test_lbu_lhu_bge
    jal x1 test_sub_sll_srl_sra_bltu
    jal x1 test_xori_slli_srli_srai
    jal x1 test_or_and_xor_slt_sltu
    jal x1 test_andi_ori_slti_sltiu_bgeu
    jal x1 test_lui_auipc
    jal x1 fib_exit

fib_loop:
	addi t6 t6 4 
	addi t4 t4 1 
	#  t2 = t1 + t2
	add t2 t1 t0  
	sw t2 0(t6) 
	#  t4 ==t5 then target
	beq t4 t5 go_back  
	addi t6 t6 4 
	addi t4 t4 1 
	#  t1 = t1 + t2
	add t0 t2 t1  
	sw t0 0(t6) 
	beq t4 t5 go_back  
	addi t6 t6 4 
	addi t4 t4 1 
	#  t2 = t1 + t2
	add t1 t0 t2  
	sw t1 0(t6) 
	beq t4 t5 go_back 
	# loop ---
	jal x0 fib_loop  

go_back:
	addi t6 t6 4
	#as ==================
	sw x0 0(t6)
	jalr x0 0(x1)

test_lb_lh_sb_sh_blt:
	#s0 load pointer
	lui s0 0xA 
	lb t1 44(s0)
	addi t6 t6 4
	sw t1 0(t6)
	addi t6 t6 4
	sb t1 0(t6)
	lh t2 108(s0)
	addi t6 t6 4
	sw t2 0(t6)
	addi t6 t6 4
	sh t2 0(t6)
	#t2 < t1 (because of sign extension) 
	blt t2 t1 go_back 

test_lbu_lhu_bge:
	lbu t1 44(s0)
	addi t6 t6 4
	sw t1 0(t6)
	lhu t2 108(s0)
	addi t6 t6 4
	sw t2 0(t6)
	#t2 < t1 (because of sign extension) 
	bge t2 t1 go_back 

test_sub_sll_srl_sra_bltu:

	lw t1 48(s0)
	lw t2 52(s0)
	lw t4 12(s0)
	#test sub
	sub t3 t2 t1
	addi t6 t6 4
	sw t3 0(t6)
	#test sll
	sll t3 t1 t4 
	addi t6 t6 4
	sw t3 0(t6)
	#test srl
	srl t3 t1 t4 
	addi t6 t6 4
	sw t3 0(t6)
	#test sra
	sra t3 t1 t4
	addi t6 t6 4
	sw t3 0(t6)
	bltu t1 t2 go_back

test_xori_slli_srli_srai:

	lw t1 48(s0)
	#test xori (777)10= (t34)16 = (101000110100)2
	xori t2 t1 777
	addi t6 t6 4
	sw t2 0(t6)
	#test slli
	slli t2 t1 4
	addi t6 t6 4
	sw t2 0(t6)
	#test srli
	srli t2 t1 4 
	addi t6 t6 4
	sw t2 0(t6)
	#test srai
	srai t2 t1 4 
	addi t6 t6 4
	sw t2 0(t6)
	bltu t2 t1 go_back

test_or_and_xor_slt_sltu:

	lw t1 48(s0)
	lw t2 52(s0)
	#test or
	or t3 t2 t1
	addi t6 t6 4
	sw t3 0(t6)
	#test and
	and t3 t2 t1
	addi t6 t6 4
	sw t3 0(t6)
	#test xor
	xor t3 t2 t1
	addi t6 t6 4
	sw t3 0(t6)
	#test xor
	slt t3 t2 t1
	addi t6 t6 4
	sw t3 0(t6)
	#test xor
	sltiu t3 t2 777
	addi t6 t6 4
	sw t3 0(t6)
	bltu t3 t1 go_back

test_andi_ori_slti_sltiu_bgeu:

	lw t1 48(s0)
	#test andi (2612)10= (t34)16 = (101000110100)2
	andi t2 t1 777
	addi t6 t6 4
	sw t2 0(t6)
	#test ori
	ori t2 t1 777
	addi t6 t6 4
	sw t2 0(t6)
	#test slti
	slti t2 t1 777 
	addi t6 t6 4
	sw t2 0(t6)
	#test sltiu
	sltiu t2 t1 777 
	addi t6 t6 4
	sw t2 0(t6)
	bgeu t1 t2 go_back

test_lui_auipc:

	lw t1 48(s0)
	#test lui (2612)10= (t34)16 = (101000110100)2
	lui t1 777
	addi t6 t6 4
	sw t1 0(t6)
	#test auipc
	auipc t2 777
	addi t6 t6 4
	sw t2 0(t6)
	bgeu t2 t1 go_back


fib_exit:
	lw s0 0(sp)
    lw ra 4(sp)
	addi sp sp 8 
    ret
	
conv2d:
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
    ret


main_exit:
    #/* Simulation End */
    #lw s0, 0(sp)
    #addi sp, sp, 4
    
    # halt the cpu
    hcf
    hcf
    hcf
    hcf
    hcf
	
