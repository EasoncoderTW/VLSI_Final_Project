# modify ret to 5* hcf
# a6  store pointer
addi a6 x0 0x0400  
addi a0 x0 1 
addi a1 x0 1 
#do 30 times
addi x5 x0 30   
sw a0 0(a6)  
addi a6 a6 4 
#x4 = counter
addi x4 x0 2  
sw a1 0(a6) 
beq x4 x5 exit 
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
	addi a6 a6 4 
	addi x4 x4 1 
	#  a2 = a1 + a2
	add a2 a1 a0  
	sw a2 0(a6) 
	#  x4 ==5a1 then target
	beq x4 x5 go_back  
	addi a6 a6 4 
	addi x4 x4 1 
	#  a1 = a1 + a2
	add a0 a2 a1  
	sw a0 0(a6) 
	beq x4 x5 go_back  
	addi a6 a6 4 
	addi x4 x4 1 
	#  a2 = a1 + a2
	add a1 a0 a2  
	sw a1 0(a6) 
	beq x4 x5 go_back 
	# loop ---
	jal x0 fib_loop  

go_back:
	addi a6 a6 4
	#as ==================
	sw x0 0(a6)
	jalr x0 x1 0 

test_lb_lh_sb_sh_blt:
	#a7 load pointer
	addi a7 x0 0x00000400 
	lb a1 44(a7)
	addi a6 a6 4
	sw a1 0(a6)
	addi a6 a6 4
	sb a1 0(a6)
	lh a2 108(a7)
	addi a6 a6 4
	sw a2 0(a6)
	addi a6 a6 4
	sh a2 0(a6)
	#a2 < a1 (because of sign extension) 
	blt a2 a1 go_back 

test_lbu_lhu_bge:
	lbu a1 44(a7)
	addi a6 a6 4
	sw a1 0(a6)
	lhu a2 108(a7)
	addi a6 a6 4
	sw a2 0(a6)
	#a2 < a1 (because of sign extension) 
	bge a2 a1 go_back 

test_sub_sll_srl_sra_bltu:

	lw a1 48(a7)
	lw a2 52(a7)
	lw a4 12(a7)
	#test sub
	sub a3 a2 a1
	addi a6 a6 4
	sw a3 0(a6)
	#test sll
	sll a3 a1 a4 
	addi a6 a6 4
	sw a3 0(a6)
	#test srl
	srl a3 a1 a4 
	addi a6 a6 4
	sw a3 0(a6)
	#test sra
	sra a3 a1 a4
	addi a6 a6 4
	sw a3 0(a6)
	bltu a1 a2 go_back

test_xori_slli_srli_srai:

	lw a1 48(a7)
	#test xori (777)10= (a34)16 = (101000110100)2
	xori a2 a1 777
	addi a6 a6 4
	sw a2 0(a6)
	#test slli
	slli a2 a1 4
	addi a6 a6 4
	sw a2 0(a6)
	#test srli
	srli a2 a1 4 
	addi a6 a6 4
	sw a2 0(a6)
	#test srai
	srai a2 a1 4 
	addi a6 a6 4
	sw a2 0(a6)
	bltu a2 a1 go_back

test_or_and_xor_slt_sltu:

	lw a1 48(a7)
	lw a2 52(a7)
	#test or
	or a3 a2 a1
	addi a6 a6 4
	sw a3 0(a6)
	#test and
	and a3 a2 a1
	addi a6 a6 4
	sw a3 0(a6)
	#test xor
	xor a3 a2 a1
	addi a6 a6 4
	sw a3 0(a6)
	#test xor
	slt a3 a2 a1
	addi a6 a6 4
	sw a3 0(a6)
	#test xor
	sltiu a3 a2 777
	addi a6 a6 4
	sw a3 0(a6)
	bltu a3 a1 go_back

test_andi_ori_slti_sltiu_bgeu:

	lw a1 48(a7)
	#test andi (2612)10= (a34)16 = (101000110100)2
	andi a2 a1 777
	addi a6 a6 4
	sw a2 0(a6)
	#test ori
	ori a2 a1 777
	addi a6 a6 4
	sw a2 0(a6)
	#test slti
	slti a2 a1 777 
	addi a6 a6 4
	sw a2 0(a6)
	#test sltiu
	sltiu a2 a1 777 
	addi a6 a6 4
	sw a2 0(a6)
	bgeu a1 a2 go_back

test_lui_auipc:

	lw a1 48(a7)
	#test lui (2612)10= (a34)16 = (101000110100)2
	lui a1 777
	addi a6 a6 4
	sw a1 0(a6)
	#test auipc
	auipc a2 777
	addi a6 a6 4
	sw a2 0(a6)
	bgeu a2 a1 go_back


exit:
	hcf
	hcf
	hcf
	hcf
	hcf

