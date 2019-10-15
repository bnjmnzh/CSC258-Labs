vlib work

vlog -timescale 1ns/1ns divider.v

vsim divider

log {/*}

add wave {/*}

# reset, initial values
force {SW[0]} 0
force {SW[1]} 0
force {KEY[0]} 0
run 10ns

# cycle clock
force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

# turn off reset
force {KEY[0]} 1
run 10ns

# clock speed
force {SW[0]} 0
force {SW[1]} 0
force {CLOCK_50} 0 0, 1 1 -repeat 2
run 60ns

# 1/2 clock
force {SW[0]} 1
force {SW[1]} 0
force {CLOCK_50} 0 0, 1 1 -repeat 2
run 60ns
# 1/4 clock
force {SW[0]} 0
force {SW[1]} 1
force {CLOCK_50} 0 0, 1 1 -repeat 2
run 60ns
# 1/8 clock
force {SW[0]} 1
force {SW[1]} 1
force {CLOCK_50} 0 0, 1 1 -repeat 2
run 60ns