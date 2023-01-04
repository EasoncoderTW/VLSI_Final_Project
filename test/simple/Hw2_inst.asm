addi x1, x0, 16
slli x2, x1, 3
xori x3, x2, 0x800
slti x4, x2, -3
sltiu x5, x2, -3
srli x6, x3, 2
srai x7, x3, 2
ori x8, x0, 123
andi x9, x5, -1
add x10, x5, x6
sub x11, x3, x7
sll x12, x5, x8
slt x13, x7, x9
sltu x14, x9, x2
xor x15, x11, x3
srl x16, x13, x4
sra x17, x15, x5
or x18, x17, x1
and x19, x13, x10
sb x3, 3(x0)
sw x1, 4(x0)
lb x20, 3(x0)
lw x21, 4(x0)
lbu x22, 3(x0)
lui x24, 0x1238
beq x1, x2, hello
bne x1, x1, hello
blt x1, x0, hello
bge x3, x0, hello
bltu x3, x11, hello
bgeu x11, x3, hello

hello:
jalr x25, 132(x0)
add x10, x5, x6
jal x0, exit
sll x12, x5, x8

exit:
hcf