quit -sim
vlog top.sv my_pkg.sv intf.sv dut/dut.sv dut/memory.sv +cover
vsim work.top -coverage
run -all; coverage report -codeall -cvg -verbose -output cvg_report.txt