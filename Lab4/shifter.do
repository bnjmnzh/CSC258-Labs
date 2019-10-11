# Set the working dir, where all compiled Verilog goes.
vlib Work

# Compile all Verilog modules in alu.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns shifter.v

# Load simulation using mux as the top level simulation module.
vsim shifter

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force {KEY[0]} 0
force {SW[9]} 0
run 10ns
force {KEY[0]} 1

# reset 
run 10ns

force {SW[9]} 1
force {KEY[0]} 0
run 10ns

force {KEY[2]} 0
force {SW[7:0]} 2#10101011
force {KEY[1]} 0

force {KEY[0]} 1
run 10ns

#second test case
force {KEY[1]} 1
force {KEY[2]} 1
force {KEY[3]} 1

force {KEY[0]} 0
run 10ns

force {KEY[0]} 1
run 10ns

#
force {KEY[0]} 0
run 10ns

force {KEY[0]} 1
run 10ns

force {KEY[3]} 0
force {KEY[0]} 0
run 10ns

force {KEY[0]} 1
run 10ns

# reset 
run 10ns

force {SW[9]} 1
force {KEY[0]} 0
run 10ns

force {KEY[2]} 0
force {KEY[1]} 1
force {SW[7:0]} 2#00000000
force {KEY[0]} 1
run 10ns

force {KEY[0]} 0
run 10ns

# reset 
run 10ns

force {SW[9]} 1
force {KEY[0]} 0
run 10ns

force {KEY[2]} 0
force {KEY[1]} 1
force {SW[7:0]} 2#01010101
force {KEY[0]} 1
run 10ns

force {KEY[0]} 0
run 10ns
