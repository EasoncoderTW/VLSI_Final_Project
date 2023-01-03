.data
test1: .word 16,2,4,16,4,10,12,2,14,8,4,14,6,4,2,10,12,6,10,2,14,14,6,8,16,8,16,6,12,10,8,123
test2: .word 470,405,225,197,126,122,56,33,-81,-275,-379,-409,-416,-496,-500
test3: .word 412,-474,443,171,-23,247,221,7,40,221,-90,61,-9,49,-80,-80,221,-379,-161,-397,-173,276,-197,221,-12,-145,101
TEST1_SIZE: .word 32
TEST2_SIZE: .word 15
TEST3_SIZE: .word 27
_answer: .word 0

.text

main:
    li sp, 0x10000
    addi  sp, sp ,-4
    sw s0, 0(sp)
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
    
main_exit:
    #/* Simulation End */
    lw s0, 0(sp)
    addi sp, sp, 4
    
    # halt the cpu
    hcf
    hcf
    hcf
    hcf
    hcf
    
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
    li    t2, 0    
    # t2: int i
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
    add   t2, t2, a0        
    # word
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

    
    
    
    
 
    
    
    
    
    
    
