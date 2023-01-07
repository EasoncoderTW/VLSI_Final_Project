lui sp, 8
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
add x0, x11, x11
sw t2, 0(t6)
beq t4, t5, go_back
addi t6, t6, 4
addi t4, t4, 1
add t0, t2, t1
add x0, x11, x11
sw t0, 0(t6)
beq t4, t5, go_back
addi t6, t6, 4
addi t4, t4, 1
add t1, t0, t2
add x0, x11, x11
sw t1, 0(t6)
beq t4, t5, go_back
jal x0, fib_loop
addi t6, t6, 4
add x0, x11, x11
sw x0, 0(t6)
jalr x0, 0(x1)
hcf
hcf
hcf
hcf
hcf
hcf