# Set the working dir, where all compiled Verilog goes.
vlib Work

# Compile all Verilog modules in mux.v to working dir;
# could also have multiple Verilog files.
# The timescale argument defines default time unit
# (used when no unit is specified), while the second number
# defines precision (all times are rounded to this value)
vlog -timescale 1ns/1ns mux.v

# Load simulation using mux as the top level simulation module.
vsim mux

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# force {signal name} <initial value> <initial time>, <new value> <new time> -repeat <repeat time> -cancel <cancel time>


# First
force {SW[9:7]} 2#000
force {SW[6:0]} 2#0000000
run 10ns

force {SW[9:7]} 2#000
force {SW[6:0]} 2#0000001
run 10ns

force {SW[9:7]} 2#001
force {SW[6:0]} 2#0000000
run 10ns

force {SW[9:7]} 2#001
force {SW[6:0]} 2#0000010
run 10ns

force {SW[9:7]} 2#011
force {SW[6:0]} 2#0000000
run 10ns

force {SW[9:7]} 2#011
force {SW[6:0]} 2#0000100
run 10ns

force {SW[9:7]} 2#100
force {SW[6:0]} 2#0000000
run 10ns

force {SW[9:7]} 2#100
force {SW[6:0]} 2#0001000
run 10ns

force {SW[9:7]} 2#101
force {SW[6:0]} 2#0000000
run 10ns

force {SW[9:7]} 2#101
force {SW[6:0]} 2#0010000
run 10ns

force {SW[9:7]} 2#110
force {SW[6:0]} 2#0000000
run 10ns

force {SW[9:7]} 2#110
force {SW[6:0]} 2#0100000
run 10ns

force {SW[9:7]} 2#111
force {SW[6:0]} 2#0000000
run 10ns

force {SW[9:7]} 2#111
force {SW[6:0]} 2#1000000
run 10ns















