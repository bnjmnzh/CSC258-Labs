vlib work

vlog -timescale 1ns/1ns morse.v

vsim morse

log {/*}

add wave {/*}

force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 1

force {KEY[0]} 1
force {KEY[1]} 0
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {KEY[0]} 0
run 10ns

force {CLOCK_50} 0
run 10ns
force {CLOCK_50} 1
run 10ns

force {KEY[0]} 1
run 10ns


force {KEY[1]} 1
run 10ns

force {CLOCK_50} 0
run 10ns

force {CLOCK_50} 1
run 10ns

force {KEY[1]} 0
run 1ns

force {CLOCK_50} 0 0, 1 1 -repeat 2
run 50ns

force {KEY[1]} 1
run 10ns

force {KEY[1]} 0
force {CLOCK_50} 0 0, 1 1 -repeat 2
run 50ns
