#
# Input clocks (free running)
#
#
#create_clock -name {input_clock_50} -period 20 [get_ports {OSC_50_BANK6}]
create_clock -name {external_clock_40} -period 25.000 -waveform { 0.000 12.500 } [get_ports {SMA_clkout_p}]

# Note: input_clock_125 generated by pll
set clock_125_driver {pll125MHz0|altpll_component|auto_generated|pll1|clk[0]}


create_generated_clock -name {input_clock_125} -multiply_by 5 -divide_by 8 -source [get_pins {pll125MHz0|altpll_component|auto_generated|pll1|inclk[0]}] [get_pins $clock_125_driver]


#
# Set false paths to remove irrelevant setup and hold analysis 
#

#
#
# RGMII tx output
#
#
#
# Create tx clock (125MHz, 1000Mbps)
#
create_generated_clock -name {tx_output_clock[0]} -source [get_pins $clock_125_driver] -master_clock {input_clock_125} [get_ports {ENET_GTX_CLK[0]}]
create_generated_clock -name {tx_output_clock[1]} -source [get_pins $clock_125_driver] -master_clock {input_clock_125} [get_ports {ENET_GTX_CLK[1]}]
create_generated_clock -name {tx_output_clock[2]} -source [get_pins $clock_125_driver] -master_clock {input_clock_125} [get_ports {ENET_GTX_CLK[2]}]
create_generated_clock -name {tx_output_clock[3]} -source [get_pins $clock_125_driver] -master_clock {input_clock_125} [get_ports {ENET_GTX_CLK[3]}]
# ??? forse l'opzione '-master_clock' si puo' eliminare...

##
## Create tx clock (25MHz, 100Mbps)
##
#create_generated_clock -name {tx_input_clock} -source [get_ports {clkin_50}] -divide_by 2 -master_clock {input_clock_50} [get_keepers {top1:top1_inst|allregs.dout.clk50.div2}]
#create_generated_clock -name {tx_output_clock} -source [get_keepers {top1:top1_inst|allregs.dout.clk50.div2}] -master_clock tx_input_clock [get_ports {ENET_GTX_CLK}]

set tx_input_clock {input_clock_125}

set tx_output_clock_0 {tx_output_clock[0]}
set tx_output_clock_1 {tx_output_clock[1]}
set tx_output_clock_2 {tx_output_clock[2]}
set tx_output_clock_3 {tx_output_clock[3]}

#
# Set output delay 
#
# tco max = TTT  -->  'set_output_delay -max (Ttime - TTT)'  
# tco min = TTT  -->  'set_output_delay -min (-1 * TTT)' 
#
# Note: Single data rate --> Ttime = Tclk = 8ns 
#       Double data rate --> Ttime = Tclk / 2 = 4ns
#
# Marvell PHY RGMII interface : 1.0ns setup min, 0.8ns hold min
#
# --> max delay = 1.0  (positive value means setup time before latch edge) 
# --> min delay = -0.8 (negative value means hold time after latch edge) 
#
# Marvell PHY RGMII-ID interface : -0.9ns setup min, 2.7ns hold min
# 
# --> max delay = -0.9 (negative value means signal can change after latch edge)
# --> min delay = -2.7 (negative value means hold time after latch edge) 
#
#
# Note: standard RGMII tx interface requires edge-aligned output signals (gtx_clk is
# generated by a toggling ddout output so output skews are minimized) and assumes
# external additional delay using gtx_clk PCB routing. 
# Some interfaces does not have this PCB routing delay (example: Terasic HSMC-NET) so   
# standard RGMII logic is adjusted to meet timing requirements: output clock is inverted 
# (clock negedge generates 1st nibble, clock posedge generates 2nd nibble) to gain additional 
# setup time --> Marvell PHY needs tsu = 1.0ns min, th = 0.8ns min:   
# using inverted clock and applying the output maximum delay to all data/ctrl lines
# ('Assignment Editor', D5(15) + D6(6) = 1ns for StratixIV), the new setup/hold time 
# intervals are:
# tsu = 4ns - 1ns = 3ns (slack typ = 3 - 1.0 = 2ns), th = 1ns (slack typ = 1 - 0.8 = 0.2ns)
#
# tco max = 4(Ttime) - 1.0(out dly) - 1.0(PHY tsu) - 1.0(slack) = 1.0 --> max delay = 4 - 1.0 = 3.0
#          
# tco min = 0.8(PHY th) + 0.2(slack) = 1.0 --> min delay = -1.0
#

#set tx_setup_min 1.0
#set tx_hold_min  0.8

#set tx_setup_min 3.0 --> violation setup slack -0.507ns
#set tx_hold_min  1.0

#set tx_setup_min 2.5  --> violation setup slack -0.007ns
#set tx_hold_min  1.0

set tx_setup_min 2.4
set tx_hold_min  1.0


# ........................'ENET_TX_D/en[0]'
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_0]             -max $tx_setup_min            [get_ports {ENET_TX_D0[0]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_0]             -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D0[0]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_0] -clock_fall -max $tx_setup_min            [get_ports {ENET_TX_D0[0]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_0] -clock_fall -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D0[0]}]
#
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_0]             -max $tx_setup_min            [get_ports {ENET_TX_D0[1]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_0]             -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D0[1]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_0] -clock_fall -max $tx_setup_min            [get_ports {ENET_TX_D0[1]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_0] -clock_fall -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D0[1]}]
#
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_0]             -max $tx_setup_min            [get_ports {ENET_TX_D0[2]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_0]             -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D0[2]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_0] -clock_fall -max $tx_setup_min            [get_ports {ENET_TX_D0[2]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_0] -clock_fall -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D0[2]}]
#
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_0]             -max $tx_setup_min            [get_ports {ENET_TX_D0[3]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_0]             -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D0[3]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_0] -clock_fall -max $tx_setup_min            [get_ports {ENET_TX_D0[3]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_0] -clock_fall -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D0[3]}]
#
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_0]             -max $tx_setup_min            [get_ports {ENET_TX_EN[0]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_0]             -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_EN[0]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_0] -clock_fall -max $tx_setup_min            [get_ports {ENET_TX_EN[0]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_0] -clock_fall -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_EN[0]}]

# ........................'ENET_TX_D/en[1]'
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_1]             -max $tx_setup_min            [get_ports {ENET_TX_D1[0]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_1]             -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D1[0]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_1] -clock_fall -max $tx_setup_min            [get_ports {ENET_TX_D1[0]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_1] -clock_fall -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D1[0]}]
#
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_1]             -max $tx_setup_min            [get_ports {ENET_TX_D1[1]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_1]             -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D1[1]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_1] -clock_fall -max $tx_setup_min            [get_ports {ENET_TX_D1[1]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_1] -clock_fall -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D1[1]}]
#
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_1]             -max $tx_setup_min            [get_ports {ENET_TX_D1[2]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_1]             -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D1[2]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_1] -clock_fall -max $tx_setup_min            [get_ports {ENET_TX_D1[2]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_1] -clock_fall -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D1[2]}]
#
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_1]             -max $tx_setup_min            [get_ports {ENET_TX_D1[3]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_1]             -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D1[3]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_1] -clock_fall -max $tx_setup_min            [get_ports {ENET_TX_D1[3]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_1] -clock_fall -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D1[3]}]
#
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_1]             -max $tx_setup_min            [get_ports {ENET_TX_EN[1]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_1]             -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_EN[1]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_1] -clock_fall -max $tx_setup_min            [get_ports {ENET_TX_EN[1]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_1] -clock_fall -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_EN[1]}]

# ........................'ENET_TX_D/en[2]'
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_2]             -max $tx_setup_min            [get_ports {ENET_TX_D2[0]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_2]             -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D2[0]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_2] -clock_fall -max $tx_setup_min            [get_ports {ENET_TX_D2[0]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_2] -clock_fall -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D2[0]}]
#
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_2]             -max $tx_setup_min            [get_ports {ENET_TX_D2[1]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_2]             -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D2[1]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_2] -clock_fall -max $tx_setup_min            [get_ports {ENET_TX_D2[1]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_2] -clock_fall -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D2[1]}]
#
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_2]             -max $tx_setup_min            [get_ports {ENET_TX_D2[2]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_2]             -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D2[2]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_2] -clock_fall -max $tx_setup_min            [get_ports {ENET_TX_D2[2]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_2] -clock_fall -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D2[2]}]
#
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_2]             -max $tx_setup_min            [get_ports {ENET_TX_D2[3]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_2]             -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D2[3]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_2] -clock_fall -max $tx_setup_min            [get_ports {ENET_TX_D2[3]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_2] -clock_fall -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D2[3]}]
#
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_2]             -max $tx_setup_min            [get_ports {ENET_TX_EN[2]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_2]             -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_EN[2]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_2] -clock_fall -max $tx_setup_min            [get_ports {ENET_TX_EN[2]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_2] -clock_fall -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_EN[2]}]

# ........................'ENET_TX_D/en[3]'
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_3]             -max $tx_setup_min            [get_ports {ENET_TX_D3[0]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_3]             -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D3[0]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_3] -clock_fall -max $tx_setup_min            [get_ports {ENET_TX_D3[0]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_3] -clock_fall -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D3[0]}]
#
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_3]             -max $tx_setup_min            [get_ports {ENET_TX_D3[1]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_3]             -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D3[1]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_3] -clock_fall -max $tx_setup_min            [get_ports {ENET_TX_D3[1]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_3] -clock_fall -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D3[1]}]
#
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_3]             -max $tx_setup_min            [get_ports {ENET_TX_D3[2]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_3]             -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D3[2]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_3] -clock_fall -max $tx_setup_min            [get_ports {ENET_TX_D3[2]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_3] -clock_fall -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D3[2]}]
#
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_3]             -max $tx_setup_min            [get_ports {ENET_TX_D3[3]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_3]             -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D3[3]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_3] -clock_fall -max $tx_setup_min            [get_ports {ENET_TX_D3[3]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_3] -clock_fall -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_D3[3]}]
#
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_3]             -max $tx_setup_min            [get_ports {ENET_TX_EN[3]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_3]             -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_EN[3]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_3] -clock_fall -max $tx_setup_min            [get_ports {ENET_TX_EN[3]}]
set_output_delay -add_delay -clock [get_clocks $tx_output_clock_3] -clock_fall -min [expr -1 * $tx_hold_min] [get_ports {ENET_TX_EN[3]}]

#
# Set multicycle paths to align the launch edge with the latch edge
#

## RGMII with inverted clock
#set_multicycle_path -setup -end -rise_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_0] 1
#set_multicycle_path -setup -end -fall_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_0] 1
#
#set_multicycle_path -setup -end -rise_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_1] 1
#set_multicycle_path -setup -end -fall_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_1] 1
#
#set_multicycle_path -setup -end -rise_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_2] 1
#set_multicycle_path -setup -end -fall_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_2] 1
#
#set_multicycle_path -setup -end -rise_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_3] 1
#set_multicycle_path -setup -end -fall_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_3] 1
## RGMII with inverted clock

## RGMII with inverted clock ???
#set_multicycle_path -hold -end -rise_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_0] 1
#set_multicycle_path -hold -end -fall_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_0] 1
#
#set_multicycle_path -hold -end -rise_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_1] 1
#set_multicycle_path -hold -end -fall_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_1] 1
#
#set_multicycle_path -hold -end -rise_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_2] 1
#set_multicycle_path -hold -end -fall_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_2] 1
#
#set_multicycle_path -hold -end -rise_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_3] 1
#set_multicycle_path -hold -end -fall_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_3] 1
## RGMII with inverted clock ???

#
# Set false paths to remove irrelevant setup and hold analysis 
#

# RGMII with inverted clock
#set_false_path -setup -rise_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_0] 
#set_false_path -hold  -rise_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_0] 
#set_false_path -setup -fall_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_0] 
#set_false_path -hold  -fall_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_0] 
set_false_path -setup -rise_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_0] 
set_false_path -hold  -rise_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_0] 
set_false_path -setup -fall_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_0] 
set_false_path -hold  -fall_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_0] 
# RGMII with inverted clock

# RGMII with inverted clock
#set_false_path -setup -rise_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_1] 
#set_false_path -hold  -rise_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_1] 
#set_false_path -setup -fall_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_1] 
#set_false_path -hold  -fall_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_1] 
set_false_path -setup -rise_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_1] 
set_false_path -hold  -rise_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_1] 
set_false_path -setup -fall_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_1] 
set_false_path -hold  -fall_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_1] 
# RGMII with inverted clock

# RGMII with inverted clock
#set_false_path -setup -rise_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_2] 
#set_false_path -hold  -rise_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_2] 
#set_false_path -setup -fall_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_2] 
#set_false_path -hold  -fall_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_2] 
set_false_path -setup -rise_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_2] 
set_false_path -hold  -rise_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_2] 
set_false_path -setup -fall_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_2] 
set_false_path -hold  -fall_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_2] 
# RGMII with inverted clock

# RGMII with inverted clock
#set_false_path -setup -rise_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_3] 
#set_false_path -hold  -rise_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_3] 
#set_false_path -setup -fall_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_3] 
#set_false_path -hold  -fall_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_3] 
set_false_path -setup -rise_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_3] 
set_false_path -hold  -rise_from [get_clocks $tx_input_clock] -rise_to [get_clocks $tx_output_clock_3] 
set_false_path -setup -fall_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_3] 
set_false_path -hold  -fall_from [get_clocks $tx_input_clock] -fall_to [get_clocks $tx_output_clock_3] 
# RGMII with inverted clock

#set_false_path -from  [get_clocks {input_clock_50}] -to [get_clocks $tx_input_clock] ???????

#
#
# RGMII rx input
#
#

#
# Create input clock (125MHz, 1000Mbps)
#
create_clock -name {rx_input_clock[0]} -period 8 [get_ports {ENET_RX_CLK[0]}]
create_clock -name {rx_input_clock[1]} -period 8 [get_ports {ENET_RX_CLK[1]}]
create_clock -name {rx_input_clock[2]} -period 8 [get_ports {ENET_RX_CLK[2]}]
create_clock -name {rx_input_clock[3]} -period 8 [get_ports {ENET_RX_CLK[3]}]

##
## Create input clock (25MHz, 100Mbps)
##
#create_clock -name {rx_input_clock} -period 40 [get_ports {ENET_RX_CLK}]

#
# Set input delay 
#
# setup min = TTT  -->  'set_input_delay -max (Ttime - TTT)'  
# hold min  = TTT  -->  'set_input_delay -min (TTT)' 
#
# Note: Single data rate --> Ttime = Tclk = 8ns 
#       Double data rate --> Ttime = Tclk / 2 = 4ns
#
# Marvell PHY RGMII interface: +/-0.5ns rx output Tskew
#
# Marvell PHY RGMII-ID interface: 1.2ns rx output setup/hold time min
# (slack 0.5ns --> setup/hold request (1.2 - 0.5) = 0.7ns)
#
# Note: standard RGMII rx interface assumes external additional delay using 
# rx_clk PCB routing. 
# Some interfaces does not have this PCB routing delay (example: Terasic HSMC-NET) so   
# RGMII logic is adjusted to meet timing requirements: rx input clock is inverted 
# (clock negedge latches 1st nibble, clock posedge latches 2nd nibble) to gain additional 
# setup time --> Marvell PHY generates rx outputs with Tskew = +/-0.5ns so we need
# an additional internal delay to guarantee sampling out of the uncertainty interval.  
# All data/ctrl lines must be delayed (D1,D2,D3 input delay chains for StratixIV) respect 
# to the rx input clock. The setup/hold time requirements to obtain this additional delay are: 
#
# tsu = 4ns(Ttime) - 0.5ns(Tskew) - 0.5ns(slack) = 3.0ns  -->  max = 4 - 3.0 = 1.0ns
# th  = -0.5ns(Tskew) - 0.5ns(slack) = -1.0ns             -->  min = -1.0ns
#
# (for safety, an additional slack of 0.5ns is included so the total skew interval is +/-1.0ns)    
#
# The hold interval request is a negative value: this value takes in account
# the Marvell PHY output Tskew (fitter will adjust internal delay to sample data/ctrl
# lines out of the +/-1.0ns uncertainty region).  
# The setup interval is a positive value related to the maximum internal delay
# applicable.    
#

#set rx_setup_min 0.7 
#set rx_hold_min  0.7

#set rx_setup_min 0
#set rx_hold_min  0

set rx_setup_min 3.0 
set rx_hold_min  -1.0
# 0.5ns slack margin

# ........................'ENET_RX_D/dv[0]'
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[0]}]             -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D0[0]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[0]}]             -min $rx_hold_min             [get_ports {ENET_RX_D0[0]}] 
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[0]}] -clock_fall -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D0[0]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[0]}] -clock_fall -min $rx_hold_min             [get_ports {ENET_RX_D0[0]}]
#
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[0]}]             -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D0[1]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[0]}]             -min $rx_hold_min             [get_ports {ENET_RX_D0[1]}] 
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[0]}] -clock_fall -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D0[1]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[0]}] -clock_fall -min $rx_hold_min             [get_ports {ENET_RX_D0[1]}]
#
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[0]}]             -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D0[2]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[0]}]             -min $rx_hold_min             [get_ports {ENET_RX_D0[2]}] 
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[0]}] -clock_fall -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D0[2]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[0]}] -clock_fall -min $rx_hold_min             [get_ports {ENET_RX_D0[2]}]
#
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[0]}]             -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D0[3]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[0]}]             -min $rx_hold_min             [get_ports {ENET_RX_D0[3]}] 
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[0]}] -clock_fall -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D0[3]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[0]}] -clock_fall -min $rx_hold_min             [get_ports {ENET_RX_D0[3]}]
#
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[0]}]             -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_DV[0]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[0]}]             -min $rx_hold_min             [get_ports {ENET_RX_DV[0]}] 
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[0]}] -clock_fall -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_DV[0]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[0]}] -clock_fall -min $rx_hold_min             [get_ports {ENET_RX_DV[0]}]

# ........................'ENET_RX_D/dv[1]'
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[1]}]             -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D1[0]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[1]}]             -min $rx_hold_min             [get_ports {ENET_RX_D1[0]}] 
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[1]}] -clock_fall -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D1[0]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[1]}] -clock_fall -min $rx_hold_min             [get_ports {ENET_RX_D1[0]}]
#
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[1]}]             -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D1[1]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[1]}]             -min $rx_hold_min             [get_ports {ENET_RX_D1[1]}] 
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[1]}] -clock_fall -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D1[1]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[1]}] -clock_fall -min $rx_hold_min             [get_ports {ENET_RX_D1[1]}]
#
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[1]}]             -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D1[2]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[1]}]             -min $rx_hold_min             [get_ports {ENET_RX_D1[2]}] 
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[1]}] -clock_fall -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D1[2]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[1]}] -clock_fall -min $rx_hold_min             [get_ports {ENET_RX_D1[2]}]
#
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[1]}]             -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D1[3]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[1]}]             -min $rx_hold_min             [get_ports {ENET_RX_D1[3]}] 
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[1]}] -clock_fall -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D1[3]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[1]}] -clock_fall -min $rx_hold_min             [get_ports {ENET_RX_D1[3]}]
#
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[1]}]             -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_DV[1]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[1]}]             -min $rx_hold_min             [get_ports {ENET_RX_DV[1]}] 
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[1]}] -clock_fall -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_DV[1]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[1]}] -clock_fall -min $rx_hold_min             [get_ports {ENET_RX_DV[1]}]

# ........................'ENET_RX_D/dv[2]'
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[2]}]             -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D2[0]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[2]}]             -min $rx_hold_min             [get_ports {ENET_RX_D2[0]}] 
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[2]}] -clock_fall -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D2[0]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[2]}] -clock_fall -min $rx_hold_min             [get_ports {ENET_RX_D2[0]}]
#
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[2]}]             -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D2[1]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[2]}]             -min $rx_hold_min             [get_ports {ENET_RX_D2[1]}] 
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[2]}] -clock_fall -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D2[1]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[2]}] -clock_fall -min $rx_hold_min             [get_ports {ENET_RX_D2[1]}]
#
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[2]}]             -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D2[2]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[2]}]             -min $rx_hold_min             [get_ports {ENET_RX_D2[2]}] 
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[2]}] -clock_fall -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D2[2]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[2]}] -clock_fall -min $rx_hold_min             [get_ports {ENET_RX_D2[2]}]
#
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[2]}]             -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D2[3]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[2]}]             -min $rx_hold_min             [get_ports {ENET_RX_D2[3]}] 
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[2]}] -clock_fall -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D2[3]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[2]}] -clock_fall -min $rx_hold_min             [get_ports {ENET_RX_D2[3]}]
#
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[2]}]             -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_DV[2]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[2]}]             -min $rx_hold_min             [get_ports {ENET_RX_DV[2]}] 
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[2]}] -clock_fall -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_DV[2]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[2]}] -clock_fall -min $rx_hold_min             [get_ports {ENET_RX_DV[2]}]

# ........................'ENET_RX_D/dv[3]'
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[3]}]             -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D3[0]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[3]}]             -min $rx_hold_min             [get_ports {ENET_RX_D3[0]}] 
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[3]}] -clock_fall -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D3[0]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[3]}] -clock_fall -min $rx_hold_min             [get_ports {ENET_RX_D3[0]}]
#
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[3]}]             -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D3[1]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[3]}]             -min $rx_hold_min             [get_ports {ENET_RX_D3[1]}] 
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[3]}] -clock_fall -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D3[1]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[3]}] -clock_fall -min $rx_hold_min             [get_ports {ENET_RX_D3[1]}]
#
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[3]}]             -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D3[2]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[3]}]             -min $rx_hold_min             [get_ports {ENET_RX_D3[2]}] 
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[3]}] -clock_fall -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D3[2]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[3]}] -clock_fall -min $rx_hold_min             [get_ports {ENET_RX_D3[2]}]
#
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[3]}]             -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D3[3]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[3]}]             -min $rx_hold_min             [get_ports {ENET_RX_D3[3]}] 
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[3]}] -clock_fall -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_D3[3]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[3]}] -clock_fall -min $rx_hold_min             [get_ports {ENET_RX_D3[3]}]
#
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[3]}]             -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_DV[3]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[3]}]             -min $rx_hold_min             [get_ports {ENET_RX_DV[3]}] 
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[3]}] -clock_fall -max [expr 4 - $rx_setup_min] [get_ports {ENET_RX_DV[3]}]
set_input_delay -add_delay -clock [get_clocks {rx_input_clock[3]}] -clock_fall -min $rx_hold_min             [get_ports {ENET_RX_DV[3]}]

#
# Set false paths to remove irrelevant setup and hold analysis 
#

#set_false_path -rise_from [get_clocks {rx_input_clock[0]}] -fall_to [get_clocks $tx_output_clock_0] -setup
#set_false_path -rise_from [get_clocks {rx_input_clock[0]}] -fall_to [get_clocks $tx_output_clock_0] -hold
#
#set_false_path -fall_from [get_clocks {rx_input_clock[0]}] -rise_to [get_clocks $tx_output_clock_0] -setup
#set_false_path -fall_from [get_clocks {rx_input_clock[0]}] -rise_to [get_clocks $tx_output_clock_0] -hold
#
#set_false_path -rise_from [get_clocks {rx_input_clock[0]}] -fall_to [get_clocks $tx_input_clock] -setup
#set_false_path -rise_from [get_clocks {rx_input_clock[0]}] -fall_to [get_clocks $tx_input_clock] -hold
#
#set_false_path -fall_from [get_clocks {rx_input_clock[0]}] -rise_to [get_clocks $tx_input_clock] -setup
#set_false_path -fall_from [get_clocks {rx_input_clock[0]}] -rise_to [get_clocks $tx_input_clock] -hold

set_false_path -from [get_clocks {rx_input_clock[0]}] -to [get_clocks $tx_output_clock_0]
set_false_path -from [get_clocks {rx_input_clock[0]}] -to [get_clocks $tx_output_clock_1]
set_false_path -from [get_clocks {rx_input_clock[0]}] -to [get_clocks $tx_output_clock_2]
set_false_path -from [get_clocks {rx_input_clock[0]}] -to [get_clocks $tx_output_clock_3]
#
set_false_path -from [get_clocks {rx_input_clock[1]}] -to [get_clocks $tx_output_clock_0]
set_false_path -from [get_clocks {rx_input_clock[1]}] -to [get_clocks $tx_output_clock_1]
set_false_path -from [get_clocks {rx_input_clock[1]}] -to [get_clocks $tx_output_clock_2]
set_false_path -from [get_clocks {rx_input_clock[1]}] -to [get_clocks $tx_output_clock_3]
#
set_false_path -from [get_clocks {rx_input_clock[2]}] -to [get_clocks $tx_output_clock_0]
set_false_path -from [get_clocks {rx_input_clock[2]}] -to [get_clocks $tx_output_clock_1]
set_false_path -from [get_clocks {rx_input_clock[2]}] -to [get_clocks $tx_output_clock_2]
set_false_path -from [get_clocks {rx_input_clock[2]}] -to [get_clocks $tx_output_clock_3]
#
set_false_path -from [get_clocks {rx_input_clock[3]}] -to [get_clocks $tx_output_clock_0]
set_false_path -from [get_clocks {rx_input_clock[3]}] -to [get_clocks $tx_output_clock_1]
set_false_path -from [get_clocks {rx_input_clock[3]}] -to [get_clocks $tx_output_clock_2]
set_false_path -from [get_clocks {rx_input_clock[3]}] -to [get_clocks $tx_output_clock_3]

set_false_path  -from  [get_clocks {input_clock_125}] -to [get_clocks {rx_input_clock[0]}]

set_false_path  -from  [get_clocks {input_clock_125}] -to [get_clocks {rx_input_clock[1]}]

set_false_path  -from  [get_clocks {input_clock_125}] -to [get_clocks {rx_input_clock[2]}]

set_false_path  -from  [get_clocks {input_clock_125}] -to [get_clocks {rx_input_clock[3]}]

##
## Clock uncertainty generated by the 'derive_clock_uncertainty command'
##
###set_clock_uncertainty -rise_from [get_clocks tx_input_clock] -rise_to [get_clocks tx_output_clock] -setup 0.110
###set_clock_uncertainty -rise_from [get_clocks tx_input_clock] -fall_to [get_clocks tx_output_clock] -setup 0.110
###set_clock_uncertainty -fall_from [get_clocks tx_input_clock] -rise_to [get_clocks tx_output_clock] -setup 0.110
###set_clock_uncertainty -fall_from [get_clocks tx_input_clock] -fall_to [get_clocks tx_output_clock] -setup 0.110
###set_clock_uncertainty -rise_from [get_clocks tx_input_clock] -rise_to [get_clocks tx_output_clock] -hold 0.110
###set_clock_uncertainty -rise_from [get_clocks tx_input_clock] -fall_to [get_clocks tx_output_clock] -hold 0.110
###set_clock_uncertainty -fall_from [get_clocks input_clock_40] -rise_to [get_clocks input_clock_125] -hold 0.1
###set_clock_uncertainty -fall_from [get_clocks input_clock_40] -fall_to [get_clocks input_clock_125] -hold 0.1
###