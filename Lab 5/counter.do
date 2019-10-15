vlib work

vlog -timescale 1ns/1ns counter.v

vsim counter

log {/*}

add wave {/*}

force {SW[0]} 0
run 10ns

force {SW[0]} 1
run 10ns

force {SW[1]} 1
run 10ns

force {KEY[0]} 1
run 10ns

#######

force {KEY[0]} 0
run 10ns

force {KEY[0]} 1
run 10ns

force {KEY[0]} 0
run 10ns

force{KEY[0]} 1
run 10ns

force {KEY[0]} 0
run 10ns

force{KEY[0]} 1
run 10ns

force {KEY[0]} 0
run 10ns

force{KEY[0]} 1
run 10ns

##
force {KEY[0]} 0, 0, 1 20 -repeat 40
