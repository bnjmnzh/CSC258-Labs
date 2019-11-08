vlib work
vlog -timescale 1ns/1ns ram32x4.v

vsim -L altera_mf_ver ram32x4

log {/*}

add wave {/*}

force {clock} 0 0, 1 1 -repeat 2
force {wren} 1 0, 0 4
force {address} 00001 0, 00010 2, 00001 4, 00010 6
force {data} 1111 0, 0001 2
run 2ns