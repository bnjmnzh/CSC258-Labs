# Set the working dir, where all compiled Verilog goes.

vlib work

vlog -timescale 1ns/1ns poly_function.v

# Load simulation using mux as the top level simulation module.
vsim fpga_top

# Log all signals and add some signals to waveform window.
log {/*}

# add wave {/*}would add all items in top level simulation module.
add wave {/*}

# reset, set initial values
force {SW[0]} 0
# should be off
force {KEY[1]} 1
run 1ns

force {CLOCK_50} 0
run 1ns
force {CLOCK_50} 1
run 1ns
force {KEY[0]} 1
run 1ns

# load A
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0
force {SW[8]} 0
run 1ns

force {KEY[1]} 0
run 1ns
force {CLOCK_50} 0
run 1ns
force {CLOCK_50} 1
run 1ns
force {KEY[1]} 1
run 1ns
force {CLOCK_50} 0
run 1ns
force {CLOCK_50} 1
run 1ns

# load B
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0
force {SW[8]} 0
run 1ns

force {KEY[1]} 0
run 1ns
force {CLOCK_50} 0
run 1ns
force {CLOCK_50} 1
run 1ns
force {KEY[1]} 1
run 1ns
force {CLOCK_50} 0
run 1ns
force {CLOCK_50} 1
run 1ns

# load C
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 1
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0
force {SW[8]} 0
run 1ns

force {KEY[1]} 0
run 1ns
force {CLOCK_50} 0
run 1ns
force {CLOCK_50} 1
run 1ns
force {KEY[1]} 1
run 1ns
force {CLOCK_50} 0
run 1ns
force {CLOCK_50} 1
run 1ns

# load X
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[4]} 0
force {SW[5]} 0
force {SW[6]} 0
force {SW[7]} 0
force {SW[8]} 0
run 1ns

force {KEY[1]} 0
run 1ns
force {CLOCK_50} 0
run 1ns
force {CLOCK_50} 1
run 1ns
force {KEY[1]} 1
run 1ns
force {CLOCK_50} 0
run 1ns
force {CLOCK_50} 1
run 1ns

# Compute

force {CLOCK_50} 0
run 1ns
force {CLOCK_50} 1
run 1ns
force {CLOCK_50} 0
run 1ns
force {CLOCK_50} 1
run 1ns
force {CLOCK_50} 0
run 1ns
force {CLOCK_50} 1
run 1ns
force {CLOCK_50} 0
run 1ns
force {CLOCK_50} 1
run 1ns
force {CLOCK_50} 0
run 1ns
force {CLOCK_50} 1
run 1ns
force {CLOCK_50} 0
run 1ns
force {CLOCK_50} 1
run 1ns
force {CLOCK_50} 0
run 1ns
force {CLOCK_50} 1
run 1ns