# Makefile

# defaults
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += $(PWD)/hazard.v
VERILOG_SOURCES += $(PWD)/controller.v
VERILOG_SOURCES += $(PWD)/dpath.v
VERILOG_SOURCES += $(PWD)/HazardUnitv.v
VERILOG_SOURCES += $(PWD)/Mux_2to1.v
VERILOG_SOURCES += $(PWD)/Memory.v
VERILOG_SOURCES += $(PWD)/ALU.v
VERILOG_SOURCES += $(PWD)/Register_file.v
VERILOG_SOURCES += $(PWD)/Adder.v
VERILOG_SOURCES += $(PWD)/Register_simple.v
VERILOG_SOURCES += $(PWD)/Instruction_Memory.v
VERILOG_SOURCES += $(PWD)/better_extender.v
VERILOG_SOURCES += $(PWD)/Extender.v
VERILOG_SOURCES += $(PWD)/Decoder_4to16.v
VERILOG_SOURCES += $(PWD)/Mux_16to1.v
VERILOG_SOURCES += $(PWD)/Mux_4to1.v
VERILOG_SOURCES += $(PWD)/Register_sync_rw.v

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = hazard

# MODULE is the basename of the Python test file
MODULE = test_hazard

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
