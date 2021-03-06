# TCL File Generated by Component Editor 18.1
# Mon Nov 25 11:16:40 CET 2019
# DO NOT MODIFY


# 
# ISP1761 "USB OTG" v1.0
#  2019.11.25.11:16:40
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module ISP1761
# 
set_module_property DESCRIPTION ""
set_module_property NAME ISP1761
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "USB OTG"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL ISP1761_IF
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file ISP1761_driver.v VERILOG PATH IP/TERASIC_ISP1761/ISP1761_driver.v TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clk_in
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset rsi_rst_n reset_req Input 1


# 
# connection point avalon_slave_0
# 
add_interface avalon_slave_0 avalon end
set_interface_property avalon_slave_0 addressUnits WORDS
set_interface_property avalon_slave_0 associatedClock clk_in
set_interface_property avalon_slave_0 associatedReset reset
set_interface_property avalon_slave_0 bitsPerSymbol 8
set_interface_property avalon_slave_0 burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_0 burstcountUnits WORDS
set_interface_property avalon_slave_0 explicitAddressSpan 0
set_interface_property avalon_slave_0 holdTime 0
set_interface_property avalon_slave_0 linewrapBursts false
set_interface_property avalon_slave_0 maximumPendingReadTransactions 0
set_interface_property avalon_slave_0 maximumPendingWriteTransactions 0
set_interface_property avalon_slave_0 readLatency 0
set_interface_property avalon_slave_0 readWaitTime 1
set_interface_property avalon_slave_0 setupTime 0
set_interface_property avalon_slave_0 timingUnits Cycles
set_interface_property avalon_slave_0 writeWaitTime 0
set_interface_property avalon_slave_0 ENABLED true
set_interface_property avalon_slave_0 EXPORT_OF ""
set_interface_property avalon_slave_0 PORT_NAME_MAP ""
set_interface_property avalon_slave_0 CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave_0 SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave_0 avs_cs_n chipselect_n Input 1
add_interface_port avalon_slave_0 avs_address address Input 18
add_interface_port avalon_slave_0 avs_write_n write_n Input 1
add_interface_port avalon_slave_0 avs_writedata writedata Input 32
add_interface_port avalon_slave_0 avs_read_n read_n Input 1
add_interface_port avalon_slave_0 avs_readdata readdata Output 32
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave_0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point hc
# 
add_interface hc interrupt end
set_interface_property hc associatedAddressablePoint ""
set_interface_property hc associatedClock clk_in
set_interface_property hc associatedReset reset
set_interface_property hc bridgedReceiverOffset ""
set_interface_property hc bridgesToReceiver ""
set_interface_property hc ENABLED true
set_interface_property hc EXPORT_OF ""
set_interface_property hc PORT_NAME_MAP ""
set_interface_property hc CMSIS_SVD_VARIABLES ""
set_interface_property hc SVD_ADDRESS_GROUP ""

add_interface_port hc ins_hc_irq irq Output 1


# 
# connection point dc
# 
add_interface dc interrupt end
set_interface_property dc associatedAddressablePoint ""
set_interface_property dc associatedClock clk_in
set_interface_property dc associatedReset reset
set_interface_property dc bridgedReceiverOffset ""
set_interface_property dc bridgesToReceiver ""
set_interface_property dc ENABLED true
set_interface_property dc EXPORT_OF ""
set_interface_property dc PORT_NAME_MAP ""
set_interface_property dc CMSIS_SVD_VARIABLES ""
set_interface_property dc SVD_ADDRESS_GROUP ""

add_interface_port dc ins_dc_irq irq Output 1


# 
# connection point clk_in
# 
add_interface clk_in clock end
set_interface_property clk_in clockRate 0
set_interface_property clk_in ENABLED true
set_interface_property clk_in EXPORT_OF ""
set_interface_property clk_in PORT_NAME_MAP ""
set_interface_property clk_in CMSIS_SVD_VARIABLES ""
set_interface_property clk_in SVD_ADDRESS_GROUP ""

add_interface_port clk_in csi_dummy_clk clk Input 1


# 
# connection point to_isp1761
# 
add_interface to_isp1761 conduit end
set_interface_property to_isp1761 associatedClock clk_in
set_interface_property to_isp1761 associatedReset ""
set_interface_property to_isp1761 ENABLED true
set_interface_property to_isp1761 EXPORT_OF ""
set_interface_property to_isp1761 PORT_NAME_MAP ""
set_interface_property to_isp1761 CMSIS_SVD_VARIABLES ""
set_interface_property to_isp1761 SVD_ADDRESS_GROUP ""

add_interface_port to_isp1761 coe_CS_N chipselect_n Output 1
add_interface_port to_isp1761 coe_WR_N write_n Output 1
add_interface_port to_isp1761 coe_RD_N read_n Output 1
add_interface_port to_isp1761 coe_D data Bidir 32
add_interface_port to_isp1761 coe_A address Output 17
add_interface_port to_isp1761 coe_DC_IRQ dc_irq Input 1
add_interface_port to_isp1761 coe_HC_IRQ hc_irq Input 1
add_interface_port to_isp1761 coe_DC_DREQ dc_dreq Input 1
add_interface_port to_isp1761 coe_HC_DREQ hc_dreq Input 1
add_interface_port to_isp1761 coe_DC_DACK dc_dack Output 1
add_interface_port to_isp1761 coe_HC_DACK hc_dack Output 1
add_interface_port to_isp1761 coe_RESET_n reset_n Output 1

