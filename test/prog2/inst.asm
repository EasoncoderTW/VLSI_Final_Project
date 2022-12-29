addi a6, x0, 0x0400
addi a0, x0, 1
addi a1, x0, 1
addi x5, x0, 30
sw a0, 0(a6)
addi a6, a6, 4
addi x4, x0, 2
sw a1, 0(a6)
beq x4, x5, exit
jal x1, fib_loop
jal x1, test_lb_lh_sb_sh_blt
jal x1, test_lbu_lhu_bge
jal x1, test_sub_sll_srl_sra_bltu
jal x1, test_xori_slli_srli_srai
jal x1, test_or_and_xor_slt_sltu
jal x1, test_andi_ori_slti_sltiu_bgeu
jal x1, test_lui_auipc
jal x0, exit
addi a6, a6, 4
addi x4, x4, 1
add a2, a1, a0
sw a2, 0(a6)
beq x4, x5, go_back
addi a6, a6, 4
addi x4, x4, 1
add a0, a2, a1
sw a0, 0(a6)
beq x4, x5, go_back
addi a6, a6, 4
addi x4, x4, 1
add a1, a0, a2
sw a1, 0(a6)
beq x4, x5, go_back
jal x0, fib_loop
addi a6, a6, 4
sw x0, 0(a6)
jalr x0, 0(x1)
addi a7, x0, 0x00000400
lb a1, 44(a7)
addi a6, a6, 4
sw a1, 0(a6)
addi a6, a6, 4
sb a1, 0(a6)
lh a2, 108(a7)
addi a6, a6, 4
sw a2, 0(a6)
addi a6, a6, 4
sh a2, 0(a6)
blt a2, a1, go_back
lbu a1, 44(a7)
addi a6, a6, 4
sw a1, 0(a6)
lhu a2, 108(a7)
addi a6, a6, 4
sw a2, 0(a6)
bge a2, a1, go_back
lw a1, 48(a7)
lw a2, 52(a7)
lw a4, 12(a7)
sub a3, a2, a1
addi a6, a6, 4
sw a3, 0(a6)
sll a3, a1, a4
addi a6, a6, 4
sw a3, 0(a6)
srl a3, a1, a4
addi a6, a6, 4
sw a3, 0(a6)
sra a3, a1, a4
addi a6, a6, 4
sw a3, 0(a6)
bltu a1, a2, go_back
lw a1, 48(a7)
xori a2, a1, 777
addi a6, a6, 4
sw a2, 0(a6)
slli a2, a1, 4
addi a6, a6, 4
sw a2, 0(a6)
srli a2, a1, 4
addi a6, a6, 4
sw a2, 0(a6)
srai a2, a1, 4
addi a6, a6, 4
sw a2, 0(a6)
bltu a2, a1, go_back
lw a1, 48(a7)
lw a2, 52(a7)
or a3, a2, a1
addi a6, a6, 4
sw a3, 0(a6)
and a3, a2, a1
addi a6, a6, 4
sw a3, 0(a6)
xor a3, a2, a1
addi a6, a6, 4
sw a3, 0(a6)
slt a3, a2, a1
addi a6, a6, 4
sw a3, 0(a6)
sltiu a3, a2, 777
addi a6, a6, 4
sw a3, 0(a6)
bltu a3, a1, go_back
lw a1, 48(a7)
andi a2, a1, 777
addi a6, a6, 4
sw a2, 0(a6)
ori a2, a1, 777
addi a6, a6, 4
sw a2, 0(a6)
slti a2, a1, 777
addi a6, a6, 4
sw a2, 0(a6)
sltiu a2, a1, 777
addi a6, a6, 4
sw a2, 0(a6)
bgeu a1, a2, go_back
lw a1, 48(a7)
lui a1, 777
addi a6, a6, 4
sw a1, 0(a6)
auipc a2, 777
addi a6, a6, 4
sw a2, 0(a6)
bgeu a2, a1, go_back
hcf