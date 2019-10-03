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

# First test case
force {SW[0]} 0 0, 1 2 -repeat 4 -cancel 2048
force {SW[1]} 0 0 ns, 1 4 ns -repeat 8 -cancel 2048
force {SW[2]} 0 0 ns, 1 8 ns -repeat 16  -cancel 2048
force {SW[3]} 0 0 ns, 1 16 ns -repeat 32 -cancel 2048
force {SW[4]} 0 0 ns, 1 32 ns -repeat 64 -cancel 2048
force {SW[5]} 0 0 ns, 1 64 ns -repeat 128 -cancel 2048
force {SW[6]} 0 0 ns, 1 128 ns -repeat 256 -cancel 2048
force {SW[7]} 0 0 ns, 1 256 ns -repeat 512 -cancel 2048
force {SW[8]} 0 0 ns, 1 512 ns -repeat 1024 -cancel 2048
force {SW[9]} 0 0 ns, 1 1024 ns -cancel 2048
run 2048ns