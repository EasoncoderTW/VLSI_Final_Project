lui x02, 0x00000010
addi x02, x02, 0x00000000
addi sp, sp, -8
sw ra, 4(sp)
sw s0, 0(sp)
lui t6, 0xa
addi t0, x0, 1
addi t1, x0, 1
addi t5, x0, 30
sw t0, 0(t6)
addi t6, t6, 4
addi t4, x0, 2
sw t1, 0(t6)
beq t4, t5, exit
jal x1, fib_loop
jal x0, exit
addi t6, t6, 4
addi t4, t4, 1
add t2, t1, t0
sw t2, 0(t6)
beq t4, t5, go_back
addi t6, t6, 4
addi t4, t4, 1
add t0, t2, t1
sw t0, 0(t6)
beq t4, t5, go_back
addi t6, t6, 4
addi t4, t4, 1
add t1, t0, t2
sw t1, 0(t6)
beq t4, t5, go_back
jal x0, fib_loop
addi t6, t6, 4
sw x0, 0(t6)
jalr x0, 0(x1)
lw s0, 0(sp)
lw ra, 4(sp)
addi sp, sp, 4
hcf