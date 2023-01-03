# modify ret to 5* hcf

.data

.text
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
beq t4 t5 exit 
# x1 as rd 
jal x1 fib_loop 

jal x0 exit
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

exit:
	lw s0 0(sp)
	lw ra 4(sp)
	addi sp sp 4 
	hcf
	hcf
	hcf
	hcf
	hcf
	
