.text

_start:

init_stack:
  # set stack pointer
  la sp, _stack

SystemInit:
  # jump to main
  jal main

SystemExit:
  # End simulation
  # Write -1 at _sim_end(0xfffc)
  la t0, _sim_end
  li t1, -1
  sw t1, 0(t0)

dead_loop:
  # infinite loop
  j dead_loop