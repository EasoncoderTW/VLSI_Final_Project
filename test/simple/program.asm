# In Lab07/src/main/resource/program.asm
# This program accumulates from 10 to 6,
# then subtract 6 from sum, and store the result to t4
# t4 = 34
.text
main:
    la t0, bound
    lw t1, 0(t0)
    lw t2, 4(t0)
    la t0, six
    lw t3, 0(t0)
    add t4, zero, zero

loop:
    add t4, t4, t1
    addi t1, t1, -1
    bne t1, t2, loop
    sub t4, t4, t3
    hcf

.data
bound:
.word 10 5
six:
.word 6