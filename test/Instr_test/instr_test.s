.data
test: .word 865468 -7623579 185 47443

.text
    	li sp 0xFFFC
	addi sp sp -4
	sw ra 0(sp) 
	# t6  store pointer
	lui  t6 0xC
test_jal:
	addi x1 x0 0 
	jal x1 store_jal_result
	#check x1 != 0
	# _if jal has error ,do following instrs
_error:
	li t0 4095
	addi t6 t6 4
	sw t2 0(t6)
	addi t6 t6 4
	sw t2 0(t6)
	addi t6 t6 4
	sw t2 0(t6)
	addi t6 t6 4
	sw t2 0(t6)
	addi t6 t6 4
	sw t2 0(t6)	
	jal exit
store_jal_result:
	#jal has no error
	#14
	sw x1 0(t6)
	#as ==================
	addi t6 t6 4
	sw x0 0(t6)
start_test:
# x1 as rd
	jal x1 test_lb_lh_sb_sh_blt
	jal x1 test_add_addi_beq 
	jal x1 test_bne
	jal x1 test_blt_equal
	jal x1 test_lbu_lhu_bge
	jal x1 test_bge_equal
	jal x1 test_sub_sll_srl_sra_bltu
	jal x1 test_bgeu_equal
	jal x1 test_xori_slli_srli_srai
	jal x1 test_or_and_xor_slt_sltu
	jal x1 test_andi_ori_slti_sltiu_bgeu
	jal x1 test_lui_auipc
	jal x0 exit

go_back:
	addi t6 t6 4
	#as ==================
	sw x0 0(t6)
	jalr x0 0(x1)

test_lb_lh_sb_sh_blt:
	la t4 test
	lb t1 8(t4)
	addi t6 t6 4
	#B9 FFFFFF
	sw t1 0(t6)
	addi t6 t6 4
	#B9
	sb t1 0(t6)
	lh t2 12(t4)
	addi t6 t6 4
	#53B9 FFFF
	sw t2 0(t6)
	addi t6 t6 4
	#53B9
	sh t2 0(t6)
	#t2 < t1 (because of sign extension) 
	# there are some error
	blt t1 t2 error
	# correct
	blt t2 t1 go_back 
	jal error
test_blt_equal:
	# there are some error 
	blt t1 t1 error
	#there r no err
	jal x0 go_back

test_add_addi_beq:
	li t1 33
	li t2 77
	add t3 t1 t2
	addi t6 t6 4
	#6E
	sw t3 0(t6)
	addi t3 t1 56
	addi t6 t6 4
	#59
	sw t3 0(t6)
	beq t1 t2 error
	li t2 33
	beq t1 t2 go_back
	jal error

test_bne:
	li t1 33
	li t2 33
	li t3 34
	bne t1 t2 error
	# will store 0x0080
	bne t1 t3 pass 
	jal error
pass:
	li t2 2048
	addi t6 t6 4
	sw t2 0(t6)
	jal x0 go_back

test_lbu_lhu_bge:
	la t4 test
	lbu t1 8(t4)
	addi t6 t6 4
	#B9
	sw t1 0(t6)
	lhu t2 12(t4)
	addi t6 t6 4
	#53
	sw t2 0(t6)
	#t2 < t1 (because of sign extension)
	# there are some error 
	bge t1 t2 error
	# correct
	bge t2 t1 go_back 
	jal error
test_bge_equal:
	#check if there are some error 
	bge t1 t1 go_back
	jal error

test_sub_sll_srl_sra_bltu:

	la t4 test
	lw t1 0(t4)
	lw t2 4(t4)
	li t5 8
	#test sub
	sub t3 t2 t1
	addi t6 t6 4
	#FF7E77A9
	sw t3 0(t6)
	#test sll
	sll t3 t1 t5 
	addi t6 t6 4
	#0D34BC00
	sw t3 0(t6)
	#test srl
	srl t3 t1 t5 
	addi t6 t6 4
	#0D34
	sw t3 0(t6)
	#test sra
	sra t3 t1 t5
	addi t6 t6 4
	#0D34
	sw t3 0(t6)
	# there are some error
	bltu t2 t1 error
	#correct
	bltu t1 t2 go_back
	jal error
test_bltu_equal:
	# there are some error 
	bltu t1 t1 error
	# no error
	jal go_back

test_xori_slli_srli_srai:

	li t1 666
	#test xori (777)10= (309)16 = (1100001001)2
	xori t2 t1 777
	addi t6 t6 4
	#0193
	sw t2 0(t6)
	#test slli
	slli t2 t1 4
	addi t6 t6 4
	#29A0
	sw t2 0(t6)
	#test srli
	srli t2 t1 4 
	addi t6 t6 4
	#29
	sw t2 0(t6)
	#test srai
	srai t2 t1 4 
	addi t6 t6 4
	#29
	sw t2 0(t6)
	bltu t2 t1 go_back
	jal error

test_or_and_xor_slt_sltu:

	la t3 test
	lw t1 0(t3)
	lw t2 4(t2)
	#test or
	or t3 t2 t1
	addi t6 t6 4
	#230D7FBF
	sw t3 0(t6)
	#test and
	and t3 t2 t1
	addi t6 t6 4
	#048C
	sw t3 0(t6)
	#test xor
	xor t3 t2 t1
	addi t6 t6 4
	#230D7B33
	sw t3 0(t6)
	#test slt
	slt t3 t2 t1
	addi t6 t6 4
	#0
	sw t3 0(t6)
	slt t3 t1 t2
	addi t6 t6 4
	#1
	sw t3 0(t6)
	#test sltu
	sltu t3 t2 t1
	addi t6 t6 4
	#0
	sw t3 0(t6)
	sltu t3 t1 t2
	addi t6 t6 4
	#1
	sw t3 0(t6)
	bltu t3 t1 go_back
	jal error

test_andi_ori_slti_sltiu_bgeu:

	la t3 test
	lw t1 0(t3)
	lw t2 4(t3)			
	#test andi (777)10= (309)16 = (1100001001)2
	andi t3 t1 777
	addi t6 t6 4
	#08
	sw t3 0(t6)
	#test ori
	ori t3 t1 777
	addi t6 t6 4
	#0d37BD
	sw t3 0(t6)
	#test slti
	slti t3 t1 777 
	addi t6 t6 4
	#0
	sw t3 0(t6)
	slti t3 t2 777 
	addi t6 t6 4
	#1
	sw t3 0(t6)
	#test sltiu
	sltiu t3 t1 777 
	addi t6 t6 4
	#0
	sw t3 0(t6)
	sltiu t3 t2 777 
	addi t6 t6 4
	#0
	sw t3 0(t6)
	la t3 test
	lw t2 8(t3)	
	sltiu t3 t2 777 
	addi t6 t6 4
	#1
	sw t3 0(t6)
	# there are some error 
	bgeu t2 t1 error
	#correct
	bgeu t1 t2 go_back
	jal error
test_bgeu_equal:
	# there are some error 
	bgeu t1 t1 go_back
	# no error
	jal error

test_lui_auipc:

	#test lui (777)10= (309)16 = (1100001001)2
	lui t1 777
	addi t6 t6 4
	#309000
	sw t1 0(t6)
	#test auipc
	auipc t2 777
	addi t6 t6 4
	#3092F8
	sw t2 0(t6)
	bgeu t2 t1 go_back
	jal error


error:
	#print 111111111111 5 times
	li t0 4095
	addi t6 t6 4
	sw t2 0(t6)
	addi t6 t6 4
	sw t2 0(t6)
	addi t6 t6 4
	sw t2 0(t6)
	addi t6 t6 4
	sw t2 0(t6)
	addi t6 t6 4
	sw t2 0(t6)
	jal exit

exit:
	lw ra 0(sp)
	addi sp sp 4 
	hcf
	hcf
	hcf
	hcf
	hcf
	
