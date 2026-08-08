RTL := rtl/traffic_signal_controller.v
TB := tb/traffic_signal_controller_tb.v
BUILD := build

.PHONY: test clean

test:
	@mkdir -p $(BUILD)
	iverilog -g2012 -Wall -o $(BUILD)/traffic_signal_tb $(RTL) $(TB)
	vvp $(BUILD)/traffic_signal_tb

clean:
	rm -rf $(BUILD)
