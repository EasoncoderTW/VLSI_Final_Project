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
jal x1 test_lb_lh_sb_sh_blt
jal x1 test_lbu_lhu_bge
jal x1 test_sub_sll_srl_sra_bltu
jal x1 test_xori_slli_srli_srai
jal x1 test_or_and_xor_slt_sltu
jal x1 test_andi_ori_slti_sltiu_bgeu
jal x1 test_lui_auipc
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
	#test andi (777)10= (309)16 = (101000110100)2
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
	#test lui (2612)10= (A34)16 = (101000110100)2
	lui t1 777
	addi t6 t6 4
	sw t1 0(t6)
	#test auipc
	auipc t2 777
	addi t6 t6 4
	sw t2 0(t6)
	bgeu t2 t1 go_back


exit:
	lw s0 0(sp)
	lw ra 4(sp)
	addi sp sp 4 
	jal halt

halt:
	hcf
	hcf
	hcf
	hcf
	hcf
	
