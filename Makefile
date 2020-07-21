CFLAGS := --std=08

all:

test:
	@ghdl -a $(CFLAGS)  components.vhdl

	@ghdl -a $(CFLAGS) adder.vhdl
	@ghdl -a $(CFLAGS) adder_tb.vhdl
	@ghdl -e $(CFLAGS) adder_tb
	@ghdl -r $(CFLAGS) adder_tb

	@ghdl -a $(CFLAGS) carry_lookahead_adder.vhdl
	@ghdl -a $(CFLAGS) carry_lookahead_adder_tb.vhdl
	@ghdl -e $(CFLAGS) carry_lookahead_adder_tb
	@ghdl -r $(CFLAGS) carry_lookahead_adder_tb

	@ghdl -a $(CFLAGS) multiplier.vhdl
	@ghdl -a $(CFLAGS) multiplier_tb.vhdl
	@ghdl -e $(CFLAGS) multiplier_tb
	@ghdl -r $(CFLAGS) multiplier_tb

clean:
	@rm *~
	@rm *.cf
