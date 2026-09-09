onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /master_tb/dut/start
add wave -noupdate -radix binary /master_tb/dut/rst_n
add wave -noupdate -radix binary /master_tb/dut/clk
add wave -noupdate -color Cyan -radix binary /master_tb/dut/sclk_out
add wave -noupdate -color {Blue Violet} -radix binary /master_tb/dut/CS_n
add wave -noupdate -color Gold -radix binary /master_tb/dut/MOSI
add wave -noupdate -color {Lime Green} -radix binary /master_tb/dut/tx_data
add wave -noupdate -radix binary /master_tb/dut/tx_shift_reg
add wave -noupdate -radix binary /master_tb/dut/tx_interrupt
add wave -noupdate -color Magenta -radix binary /master_tb/dut/MISO
add wave -noupdate -radix binary /master_tb/dut/rx_data
add wave -noupdate -radix binary /master_tb/dut/rx_shift_reg
add wave -noupdate -radix binary /master_tb/dut/rx_interrupt
add wave -noupdate -radix binary /master_tb/dut/cs
add wave -noupdate -radix binary /master_tb/dut/ns
add wave -noupdate -radix unsigned /master_tb/dut/divider_counter
add wave -noupdate -radix unsigned /master_tb/dut/bits_transfered
add wave -noupdate -radix binary /master_tb/dut/sclk_is_rising
add wave -noupdate -radix binary /master_tb/dut/sclk_is_falling
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1049 ns}
