## Copyright (C) 2019  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 18.1.1 Build 646 04/11/2019 SJ Standard Edition"

## DATE    "Mon Nov 11 14:40:31 2019"

##
## DEVICE  "EP4SGX230KF40C2"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************
#create_clock -name{clk200} -period 5.000 -waveform { 0.000 2.500 } [get_ports {testbench_ls|u0|clk_200_out_clk}]
create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {OSC_50_BANK6} -period 20.000 -waveform { 0.000 10.000 } [get_ports {OSC_50_BANK6}]
derive_pll_clocks
#create_generated_clock -name {pll_clock_40} -source [get_pins {pll40MHz:pll40MHz0|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -divide_by 5 -master_clock {clk200}  [get_pins {pll40MHz:pll40MHz0|clk[0]}]
#create_generated_clock -name {pll_clock_200} -source [get_pins {pll40MHz:pll40MHz0|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -divide_by 1 -master_clock {clk200}  [get_pins {pll40MHz:pll40MHz0|clk[1]}]

