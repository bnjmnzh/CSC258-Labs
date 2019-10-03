vlib work

vlog -timescale 1ns/1ns SevenSegmentDecoder.v

vsim decode 

log {/*}

add wave {/*}

#B - 1011
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 1
run 150ns

#A - 1010
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 1
run 150ns

#3 - 0011
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
run 150ns

#1 - 0001
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
run 150ns

#6 - 0110
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 1
force {SW[3]} 0
run 150ns

#5 - 0101
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
run 150ns