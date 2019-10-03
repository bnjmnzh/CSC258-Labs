vlib Work

vlog -timescale 1ns/1ns four.v

vsim mux4

log {/*}

add wave {/*}

# First test case
# Set input values using the force command, signal names need to be in {} brackets.
force {SW[0]} 0
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
force {SW[8]} 0
force {SW[9]} 0
# Run simulation for a few ns.
run 100ns

# Second test case: change input values and run for another 100ns.
# SW[1] should control LED[0]
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[8]} 0
force {SW[9]} 1
run 100ns

# ...
# SW[2] should control LED[0]
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 0
force {SW[8]} 1
force {SW[9]} 0
run 100ns

# SW[3] should control LED[0]
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[8]} 1
force {SW[9]} 1
run 100ns

# SW[1] should control LED[0]
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[8]} 0
force {SW[9]} 1
run 100ns

# SW[1] should control LED[0]
force {SW[0]} 0
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[8]} 0
force {SW[9]} 1
run 100ns

# SW[3] should control LED[0]
force {SW[0]} 1
force {SW[1]} 0
force {SW[2]} 0
force {SW[3]} 1
force {SW[8]} 1
force {SW[9]} 1
run 100ns

# SW[1] should control LED[0]
force {SW[0]} 1
force {SW[1]} 1
force {SW[2]} 0
force {SW[3]} 0
force {SW[8]} 0
force {SW[9]} 0
run 100ns


