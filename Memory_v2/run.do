vlib work
vlog Transaction.sv Driver.sv Sequencer.sv Subscriber.sv Scoreboard.sv interface.sv Memory.sv Monitor.sv Enviroment.sv top.sv  +cover -covercells
vsim -voptargs=+acc work.top -cover
add wave -position insertpoint sim:/top/mem/intf/*
coverage save Mem.ucdb -onexit -du Memory
run -all
vcover report Mem.ucdb -details -annotate -all -output coverage_rpt.txt
