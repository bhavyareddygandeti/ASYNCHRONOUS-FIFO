vlib work
vdel -all
vlog design.sv
vlog testbench.sv +acc

#vsim -c -voptargs=+acc=npr top

vopt top -o top_o +acc +cover=sbfec
vsim top_o -coverage +UVM_TESTNAME=asyncf_write_read_parallel_test

vcd file top.vcd
vcd add -r top/*

set NoQuitOnFinish 1
onbreak {resume}
log /* -r

run -all
coverage save fifo.ucdb
vcover report fifo.ucdb
vcover report fifo.ucdb -cvg -details
quit
#coverage report -detail
