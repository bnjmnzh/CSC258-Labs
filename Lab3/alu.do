# Set the working dir, where all compiled Verilog goes.
vlib Work

# Compile all Verilog modules in alu.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns alu.v

# Load simulation using mux as the top level simulation module.
vsim alu

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}


# Test A+1
force {KEY[2:0]} 2#000
force {SW[7:4]} 2#0000  
force {SW[3:0]} 2#0000
run 10ns

force {KEY[2:0]} 2#000
force {SW[7:4]} 2#0101
force {SW[3:0]} 2#1010
run 10ns

force {KEY[2:0]} 2#000
force {SW[7:4]} 2#1111
force {SW[3:0]} 2#1111
run 10ns

# A + B
force {KEY[2:0]} 2#001
force {SW[7:4]} 2#0000
force {SW[3:0]} 2#0000
run 10ns

force {KEY[2:0]} 2#001
force {SW[7:4]} 2#0101
force {SW[3:0]} 2#1010
run 10ns

force {KEY[2:0]} 2#001
force {SW[7:4]} 2#1111
force {SW[3:0]} 2#1111
run 10ns

# A + B verilog
force {KEY[2:0]} 2#010
force {SW[7:4]} 2#0000
force {SW[3:0]} 2#0000
run 10ns

force {KEY[2:0]} 2#010
force {SW[7:4]} 2#0101
force {SW[3:0]} 2#1010
run 10ns

force {KEY[2:0]} 2#010
force {SW[7:4]} 2#1111
force {SW[3:0]} 2#1111
run 10ns

# XOR and or
force {KEY[2:0]} 2#011
force {SW[7:4]} 2#0000
force {SW[3:0]} 2#0000
run 10ns

force {KEY[2:0]} 2#011
force {SW[7:4]} 2#0101
force {SW[3:0]} 2#1010
run 10ns

force {KEY[2:0]} 2#011
force {SW[7:4]} 2#1111
force {SW[3:0]} 2#1111
run 10ns

# Reduction or
force {KEY[2:0]} 2#100
force {SW[7:4]} 2#0000
force {SW[3:0]} 2#0000
run 10ns

force {KEY[2:0]} 2#100
force {SW[7:4]} 2#0101
force {SW[3:0]} 2#1010
run 10ns

force {KEY[2:0]} 2#000
force {SW[7:4]} 2#1111
force {SW[3:0]} 2#1111
run 10ns

# concatenate
force {KEY[2:0]} 2#101
force {SW[7:4]} 2#0000
force {SW[3:0]} 2#0000
run 10ns

force {KEY[2:0]} 2#110
force {SW[7:4]} 2#0101
force {SW[3:0]} 2#1010
run 10ns

force {KEY[2:0]} 2#111
force {SW[7:4]} 2#1111
force {SW[3:0]} 2#1111
run 10ns