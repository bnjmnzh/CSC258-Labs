vlib work

vlog -timescale 1ns/1ns combination.v

vsim combination

log {/*}

add wave {/*}

force {go} 0 0, 1 40, 0 60
force {resetn} 0 0, 1 20
force {clock} 0 0, 1 10 -r 20
force {load} 0 0, 1 80, 0 0 100
force {location} 2#0000001 0, 2#1100111 40, 2#1101000 80
force {colour_in} 2#111

run 200ns
