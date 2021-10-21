Info: Starting: Create block symbol file (.bsf)
Info: qsys-generate /home/na62torino/Data/TestBench_CLONE/testbench_ls.qsys --block-symbol-file --output-directory=/home/na62torino/Data/TestBench_CLONE/testbench_ls --family="Stratix IV" --part=EP4SGX230KF40C2
Progress: Loading TestBench_CLONE/testbench_ls.qsys
Progress: Reading input file
Progress: Adding clk_200 [altera_clock_bridge 18.1]
Progress: Parameterizing module clk_200
Progress: Adding clk_50 [clock_source 18.1]
Progress: Parameterizing module clk_50
Progress: Adding ctrl_sig [altera_avalon_pio 18.1]
Progress: Parameterizing module ctrl_sig
Progress: Adding ddr2_ram [altera_mem_if_ddr2_emif 18.1]
Progress: Parameterizing module ddr2_ram
Progress: Adding dma_fifo_subsystem_1 [subsystemA 1.0]
Progress: Reading input file
Progress: Adding FIFO_stream [streamFIFO 1.6]
Progress: Parameterizing module FIFO_stream
Progress: Adding dma [altera_msgdma 18.1]
Progress: Parameterizing module dma
Progress: Building connections
Progress: Parameterizing connections
Progress: Validating
Progress: Done reading input file
Progress: Parameterizing module dma_fifo_subsystem_1
Progress: Adding dma_fifo_susbystem [subsystemA 1.0]
Progress: Parameterizing module dma_fifo_susbystem
Progress: Adding from_ETH_to_DDR [subsystemB 1.0]
Progress: Reading input file
Progress: Adding ETH_DMA [altera_msgdma 18.1]
Progress: Parameterizing module ETH_DMA
Progress: Adding clk_0 [clock_source 18.1]
Progress: Parameterizing module clk_0
Progress: Adding data_format_adapter_0 [data_format_adapter 18.1]
Progress: Parameterizing module data_format_adapter_0
Progress: Adding eth_fifo [ethFIFO 1.0]
Progress: Parameterizing module eth_fifo
Progress: Building connections
Progress: Parameterizing connections
Progress: Validating
Progress: Done reading input file
Progress: Parameterizing module from_ETH_to_DDR
Progress: Adding jtag [altera_avalon_jtag_uart 18.1]
Progress: Parameterizing module jtag
Progress: Adding nios_cpu [altera_nios2_gen2 18.1]
Progress: Parameterizing module nios_cpu
Progress: Adding pilot_sig [altera_avalon_pio 18.1]
Progress: Parameterizing module pilot_sig
Progress: Adding sys_timer [altera_avalon_timer 18.1]
Progress: Parameterizing module sys_timer
Progress: Adding system_ram [altera_avalon_onchip_memory2 18.1]
Progress: Parameterizing module system_ram
Progress: Building connections
Progress: Parameterizing connections
Progress: Validating
Progress: Done reading input file
Info: testbench_ls.ddr2_ram: Auto interface leveling mode set to 'Leveling'
Warning: testbench_ls.ddr2_ram: 'Quick' simulation modes are NOT timing accurate. Some simulation memory models may issue warnings or errors
Info: testbench_ls.from_ETH_to_DDR.ETH_DMA: Response information port is disabled. Enable the response port if data transfer information is required by host
Info: testbench_ls.from_ETH_to_DDR.eth_fifo.avalon_streaming_source/data_format_adapter_0.in: The sink has a empty signal of 3 bits, but the source does not. Avalon-ST Adapter will be inserted.
Info: testbench_ls.jtag: JTAG UART IP input clock need to be at least double (2x) the operating frequency of JTAG TCK on board
Info: testbench_ls.pilot_sig: PIO inputs are not hardwired in test bench. Undefined values will be read from PIO inputs during simulation.
Info: qsys-generate succeeded.
Info: Finished: Create block symbol file (.bsf)
Info: 
Info: Starting: Create HDL design files for synthesis
Info: qsys-generate /home/na62torino/Data/TestBench_CLONE/testbench_ls.qsys --synthesis=VERILOG --output-directory=/home/na62torino/Data/TestBench_CLONE/testbench_ls/synthesis --family="Stratix IV" --part=EP4SGX230KF40C2
Progress: Loading TestBench_CLONE/testbench_ls.qsys
Progress: Reading input file
Progress: Adding clk_200 [altera_clock_bridge 18.1]
Progress: Parameterizing module clk_200
Progress: Adding clk_50 [clock_source 18.1]
Progress: Parameterizing module clk_50
Progress: Adding ctrl_sig [altera_avalon_pio 18.1]
Progress: Parameterizing module ctrl_sig
Progress: Adding ddr2_ram [altera_mem_if_ddr2_emif 18.1]
Progress: Parameterizing module ddr2_ram
Progress: Adding dma_fifo_subsystem_1 [subsystemA 1.0]
Progress: Parameterizing module dma_fifo_subsystem_1
Progress: Adding dma_fifo_susbystem [subsystemA 1.0]
Progress: Parameterizing module dma_fifo_susbystem
Progress: Adding from_ETH_to_DDR [subsystemB 1.0]
Progress: Parameterizing module from_ETH_to_DDR
Progress: Adding jtag [altera_avalon_jtag_uart 18.1]
Progress: Parameterizing module jtag
Progress: Adding nios_cpu [altera_nios2_gen2 18.1]
Progress: Parameterizing module nios_cpu
Progress: Adding pilot_sig [altera_avalon_pio 18.1]
Progress: Parameterizing module pilot_sig
Progress: Adding sys_timer [altera_avalon_timer 18.1]
Progress: Parameterizing module sys_timer
Progress: Adding system_ram [altera_avalon_onchip_memory2 18.1]
Progress: Parameterizing module system_ram
Progress: Building connections
Progress: Parameterizing connections
Progress: Validating
Progress: Done reading input file
Info: testbench_ls.ddr2_ram: Auto interface leveling mode set to 'Leveling'
Warning: testbench_ls.ddr2_ram: 'Quick' simulation modes are NOT timing accurate. Some simulation memory models may issue warnings or errors
Info: testbench_ls.from_ETH_to_DDR.ETH_DMA: Response information port is disabled. Enable the response port if data transfer information is required by host
Info: testbench_ls.from_ETH_to_DDR.eth_fifo.avalon_streaming_source/data_format_adapter_0.in: The sink has a empty signal of 3 bits, but the source does not. Avalon-ST Adapter will be inserted.
Info: testbench_ls.jtag: JTAG UART IP input clock need to be at least double (2x) the operating frequency of JTAG TCK on board
Info: testbench_ls.pilot_sig: PIO inputs are not hardwired in test bench. Undefined values will be read from PIO inputs during simulation.
Info: testbench_ls: Generating testbench_ls "testbench_ls" for QUARTUS_SYNTH
Info: ctrl_sig: Starting RTL generation for module 'testbench_ls_ctrl_sig'
Info: ctrl_sig:   Generation command is [exec /home/na62torino/intelFPGA/18.1/quartus/linux64/perl/bin/perl -I /home/na62torino/intelFPGA/18.1/quartus/linux64/perl/lib -I /home/na62torino/intelFPGA/18.1/quartus/sopc_builder/bin/europa -I /home/na62torino/intelFPGA/18.1/quartus/sopc_builder/bin/perl_lib -I /home/na62torino/intelFPGA/18.1/quartus/sopc_builder/bin -I /home/na62torino/intelFPGA/18.1/quartus/../ip/altera/sopc_builder_ip/common -I /home/na62torino/intelFPGA/18.1/quartus/../ip/altera/sopc_builder_ip/altera_avalon_pio -- /home/na62torino/intelFPGA/18.1/quartus/../ip/altera/sopc_builder_ip/altera_avalon_pio/generate_rtl.pl --name=testbench_ls_ctrl_sig --dir=/tmp/alt8305_3593339300196138285.dir/0002_ctrl_sig_gen/ --quartus_dir=/home/na62torino/intelFPGA/18.1/quartus --verilog --config=/tmp/alt8305_3593339300196138285.dir/0002_ctrl_sig_gen//testbench_ls_ctrl_sig_component_configuration.pl  --do_build_sim=0  ]
Info: ctrl_sig: Done RTL generation for module 'testbench_ls_ctrl_sig'
Info: ctrl_sig: "testbench_ls" instantiated altera_avalon_pio "ctrl_sig"
Info: ddr2_ram: "testbench_ls" instantiated altera_mem_if_ddr2_emif "ddr2_ram"
Info: dma_fifo_subsystem_1: "testbench_ls" instantiated subsystemA "dma_fifo_subsystem_1"
Info: dma_fifo_susbystem: "testbench_ls" instantiated subsystemA "dma_fifo_susbystem"
Info: avalon_st_adapter: Inserting data_format_adapter: data_format_adapter_0
Info: from_ETH_to_DDR: "testbench_ls" instantiated subsystemB "from_ETH_to_DDR"
Info: jtag: Starting RTL generation for module 'testbench_ls_jtag'
Info: jtag:   Generation command is [exec /home/na62torino/intelFPGA/18.1/quartus/linux64/perl/bin/perl -I /home/na62torino/intelFPGA/18.1/quartus/linux64/perl/lib -I /home/na62torino/intelFPGA/18.1/quartus/sopc_builder/bin/europa -I /home/na62torino/intelFPGA/18.1/quartus/sopc_builder/bin/perl_lib -I /home/na62torino/intelFPGA/18.1/quartus/sopc_builder/bin -I /home/na62torino/intelFPGA/18.1/quartus/../ip/altera/sopc_builder_ip/common -I /home/na62torino/intelFPGA/18.1/quartus/../ip/altera/sopc_builder_ip/altera_avalon_jtag_uart -- /home/na62torino/intelFPGA/18.1/quartus/../ip/altera/sopc_builder_ip/altera_avalon_jtag_uart/generate_rtl.pl --name=testbench_ls_jtag --dir=/tmp/alt8305_3593339300196138285.dir/0003_jtag_gen/ --quartus_dir=/home/na62torino/intelFPGA/18.1/quartus --verilog --config=/tmp/alt8305_3593339300196138285.dir/0003_jtag_gen//testbench_ls_jtag_component_configuration.pl  --do_build_sim=0  ]
Info: jtag: Done RTL generation for module 'testbench_ls_jtag'
Info: jtag: "testbench_ls" instantiated altera_avalon_jtag_uart "jtag"
Info: nios_cpu: "testbench_ls" instantiated altera_nios2_gen2 "nios_cpu"
Info: pilot_sig: Starting RTL generation for module 'testbench_ls_pilot_sig'
Info: pilot_sig:   Generation command is [exec /home/na62torino/intelFPGA/18.1/quartus/linux64/perl/bin/perl -I /home/na62torino/intelFPGA/18.1/quartus/linux64/perl/lib -I /home/na62torino/intelFPGA/18.1/quartus/sopc_builder/bin/europa -I /home/na62torino/intelFPGA/18.1/quartus/sopc_builder/bin/perl_lib -I /home/na62torino/intelFPGA/18.1/quartus/sopc_builder/bin -I /home/na62torino/intelFPGA/18.1/quartus/../ip/altera/sopc_builder_ip/common -I /home/na62torino/intelFPGA/18.1/quartus/../ip/altera/sopc_builder_ip/altera_avalon_pio -- /home/na62torino/intelFPGA/18.1/quartus/../ip/altera/sopc_builder_ip/altera_avalon_pio/generate_rtl.pl --name=testbench_ls_pilot_sig --dir=/tmp/alt8305_3593339300196138285.dir/0004_pilot_sig_gen/ --quartus_dir=/home/na62torino/intelFPGA/18.1/quartus --verilog --config=/tmp/alt8305_3593339300196138285.dir/0004_pilot_sig_gen//testbench_ls_pilot_sig_component_configuration.pl  --do_build_sim=0  ]
Info: pilot_sig: Done RTL generation for module 'testbench_ls_pilot_sig'
Info: pilot_sig: "testbench_ls" instantiated altera_avalon_pio "pilot_sig"
Info: sys_timer: Starting RTL generation for module 'testbench_ls_sys_timer'
Info: sys_timer:   Generation command is [exec /home/na62torino/intelFPGA/18.1/quartus/linux64//perl/bin/perl -I /home/na62torino/intelFPGA/18.1/quartus/linux64//perl/lib -I /home/na62torino/intelFPGA/18.1/quartus/sopc_builder/bin/europa -I /home/na62torino/intelFPGA/18.1/quartus/sopc_builder/bin/perl_lib -I /home/na62torino/intelFPGA/18.1/quartus/sopc_builder/bin -I /home/na62torino/intelFPGA/18.1/quartus/../ip/altera/sopc_builder_ip/common -I /home/na62torino/intelFPGA/18.1/quartus/../ip/altera/sopc_builder_ip/altera_avalon_timer -- /home/na62torino/intelFPGA/18.1/quartus/../ip/altera/sopc_builder_ip/altera_avalon_timer/generate_rtl.pl --name=testbench_ls_sys_timer --dir=/tmp/alt8305_3593339300196138285.dir/0005_sys_timer_gen/ --quartus_dir=/home/na62torino/intelFPGA/18.1/quartus --verilog --config=/tmp/alt8305_3593339300196138285.dir/0005_sys_timer_gen//testbench_ls_sys_timer_component_configuration.pl  --do_build_sim=0  ]
Info: sys_timer: Done RTL generation for module 'testbench_ls_sys_timer'
Info: sys_timer: "testbench_ls" instantiated altera_avalon_timer "sys_timer"
Info: system_ram: Starting RTL generation for module 'testbench_ls_system_ram'
Info: system_ram:   Generation command is [exec /home/na62torino/intelFPGA/18.1/quartus/linux64/perl/bin/perl -I /home/na62torino/intelFPGA/18.1/quartus/linux64/perl/lib -I /home/na62torino/intelFPGA/18.1/quartus/sopc_builder/bin/europa -I /home/na62torino/intelFPGA/18.1/quartus/sopc_builder/bin/perl_lib -I /home/na62torino/intelFPGA/18.1/quartus/sopc_builder/bin -I /home/na62torino/intelFPGA/18.1/quartus/../ip/altera/sopc_builder_ip/common -I /home/na62torino/intelFPGA/18.1/quartus/../ip/altera/sopc_builder_ip/altera_avalon_onchip_memory2 -- /home/na62torino/intelFPGA/18.1/quartus/../ip/altera/sopc_builder_ip/altera_avalon_onchip_memory2/generate_rtl.pl --name=testbench_ls_system_ram --dir=/tmp/alt8305_3593339300196138285.dir/0006_system_ram_gen/ --quartus_dir=/home/na62torino/intelFPGA/18.1/quartus --verilog --config=/tmp/alt8305_3593339300196138285.dir/0006_system_ram_gen//testbench_ls_system_ram_component_configuration.pl  --do_build_sim=0  ]
Info: system_ram: Done RTL generation for module 'testbench_ls_system_ram'
Info: system_ram: "testbench_ls" instantiated altera_avalon_onchip_memory2 "system_ram"
Info: avalon_st_adapter: Inserting error_adapter: error_adapter_0
Info: avalon_st_adapter_001: Inserting error_adapter: error_adapter_0
Info: avalon_st_adapter_002: Inserting error_adapter: error_adapter_0
Info: avalon_st_adapter_003: Inserting error_adapter: error_adapter_0
Info: avalon_st_adapter_004: Inserting error_adapter: error_adapter_0
Info: avalon_st_adapter_005: Inserting error_adapter: error_adapter_0
Info: avalon_st_adapter_006: Inserting error_adapter: error_adapter_0
Info: avalon_st_adapter_007: Inserting error_adapter: error_adapter_0
Info: avalon_st_adapter_008: Inserting error_adapter: error_adapter_0
Info: avalon_st_adapter_009: Inserting error_adapter: error_adapter_0
Info: avalon_st_adapter_010: Inserting error_adapter: error_adapter_0
Info: avalon_st_adapter_011: Inserting error_adapter: error_adapter_0
Info: avalon_st_adapter_012: Inserting error_adapter: error_adapter_0
Info: mm_interconnect_0: "testbench_ls" instantiated altera_mm_interconnect "mm_interconnect_0"
Info: irq_mapper: "testbench_ls" instantiated altera_irq_mapper "irq_mapper"
Info: rst_controller: "testbench_ls" instantiated altera_reset_controller "rst_controller"
Info: pll0: "ddr2_ram" instantiated altera_mem_if_ddr2_pll "pll0"
Info: p0: Generating clock pair generator
Info: p0: Generating testbench_ls_ddr2_ram_p0_altdqdqs
Info: p0: 
Info: p0: *****************************
Info: p0: 
Info: p0: Remember to run the testbench_ls_ddr2_ram_p0_pin_assignments.tcl
Info: p0: script after running Synthesis and before Fitting.
Info: p0: 
Info: p0: *****************************
Info: p0: 
Info: p0: "ddr2_ram" instantiated altera_mem_if_ddr2_phy_core "p0"
Info: m0: "ddr2_ram" instantiated altera_mem_if_ddr2_afi_mux "m0"
Info: s0: Generating Qsys sequencer system
Info: s0: QSYS sequencer system generated successfully
Info: s0: "ddr2_ram" instantiated altera_mem_if_ddr2_qseq "s0"
Info: dmaster: "ddr2_ram" instantiated altera_jtag_avalon_master "dmaster"
Info: c0: "ddr2_ram" instantiated altera_mem_if_nextgen_ddr2_controller "c0"
Info: oct0: "ddr2_ram" instantiated altera_mem_if_oct "oct0"
Info: dll0: "ddr2_ram" instantiated altera_mem_if_dll "dll0"
Info: mm_interconnect_0: "ddr2_ram" instantiated altera_mm_interconnect "mm_interconnect_0"
Info: FIFO_stream: "dma_fifo_subsystem_1" instantiated streamFIFO "FIFO_stream"
Info: dma: "dma_fifo_subsystem_1" instantiated altera_msgdma "dma"
Info: ETH_DMA: "from_ETH_to_DDR" instantiated altera_msgdma "ETH_DMA"
Info: data_format_adapter_0: "from_ETH_to_DDR" instantiated data_format_adapter "data_format_adapter_0"
Info: eth_fifo: "from_ETH_to_DDR" instantiated ethFIFO "eth_fifo"
Info: avalon_st_adapter: "from_ETH_to_DDR" instantiated altera_avalon_st_adapter "avalon_st_adapter"
Info: cpu: Starting RTL generation for module 'testbench_ls_nios_cpu_cpu'
Info: cpu:   Generation command is [exec /home/na62torino/intelFPGA/18.1/quartus/linux64//eperlcmd -I /home/na62torino/intelFPGA/18.1/quartus/linux64//perl/lib -I /home/na62torino/intelFPGA/18.1/quartus/sopc_builder/bin/europa -I /home/na62torino/intelFPGA/18.1/quartus/sopc_builder/bin/perl_lib -I /home/na62torino/intelFPGA/18.1/quartus/sopc_builder/bin -I /home/na62torino/intelFPGA/18.1/quartus/../ip/altera/nios2_ip/altera_nios2_gen2/cpu_lib -I /home/na62torino/intelFPGA/18.1/quartus/../ip/altera/nios2_ip/altera_nios2_gen2/nios_lib -I /home/na62torino/intelFPGA/18.1/quartus/../ip/altera/nios2_ip/altera_nios2_gen2 -I /home/na62torino/intelFPGA/18.1/quartus/../ip/altera/nios2_ip/altera_nios2_gen2 -- /home/na62torino/intelFPGA/18.1/quartus/../ip/altera/nios2_ip/altera_nios2_gen2/generate_rtl.epl --name=testbench_ls_nios_cpu_cpu --dir=/tmp/alt8305_3593339300196138285.dir/0018_cpu_gen/ --quartus_bindir=/home/na62torino/intelFPGA/18.1/quartus/linux64/ --verilog --config=/tmp/alt8305_3593339300196138285.dir/0018_cpu_gen//testbench_ls_nios_cpu_cpu_processor_configuration.pl  --do_build_sim=0  ]
Info: cpu: # 2020.02.13 13:37:56 (*) Starting Nios II generation
Info: cpu: # 2020.02.13 13:37:56 (*)   Checking for plaintext license.
Info: cpu: # 2020.02.13 13:37:56 (*)   Plaintext license not found.
Info: cpu: # 2020.02.13 13:37:56 (*)   Checking for encrypted license (non-evaluation).
Info: cpu: # 2020.02.13 13:37:57 (*)   Encrypted license found.  SOF will not be time-limited.
Info: cpu: # 2020.02.13 13:37:57 (*)   Elaborating CPU configuration settings
Info: cpu: # 2020.02.13 13:37:57 (*)   Creating all objects for CPU
Info: cpu: # 2020.02.13 13:37:57 (*)     Testbench
Info: cpu: # 2020.02.13 13:37:57 (*)     Instruction decoding
Info: cpu: # 2020.02.13 13:37:57 (*)       Instruction fields
Info: cpu: # 2020.02.13 13:37:57 (*)       Instruction decodes
Info: cpu: # 2020.02.13 13:37:57 (*)       Signals for RTL simulation waveforms
Info: cpu: # 2020.02.13 13:37:57 (*)       Instruction controls
Info: cpu: # 2020.02.13 13:37:57 (*)     Pipeline frontend
Info: cpu: # 2020.02.13 13:37:57 (*)     Pipeline backend
Info: cpu: # 2020.02.13 13:37:59 (*)   Generating RTL from CPU objects
Info: cpu: # 2020.02.13 13:38:00 (*)   Creating encrypted RTL
Info: cpu: # 2020.02.13 13:38:01 (*) Done Nios II generation
Info: cpu: Done RTL generation for module 'testbench_ls_nios_cpu_cpu'
Info: cpu: "nios_cpu" instantiated altera_nios2_gen2_unit "cpu"
Info: from_ETH_to_DDR_ETH_DMA_mm_write_translator: "mm_interconnect_0" instantiated altera_merlin_master_translator "from_ETH_to_DDR_ETH_DMA_mm_write_translator"
Info: ddr2_ram_avl_translator: "mm_interconnect_0" instantiated altera_merlin_slave_translator "ddr2_ram_avl_translator"
Info: from_ETH_to_DDR_ETH_DMA_mm_write_agent: "mm_interconnect_0" instantiated altera_merlin_master_agent "from_ETH_to_DDR_ETH_DMA_mm_write_agent"
Info: Reusing file /home/na62torino/Data/TestBench_CLONE/testbench_ls/synthesis/submodules/altera_merlin_master_agent.sv
Info: ddr2_ram_avl_agent: "mm_interconnect_0" instantiated altera_merlin_slave_agent "ddr2_ram_avl_agent"
Info: Reusing file /home/na62torino/Data/TestBench_CLONE/testbench_ls/synthesis/submodules/altera_merlin_slave_agent.sv
Info: Reusing file /home/na62torino/Data/TestBench_CLONE/testbench_ls/synthesis/submodules/altera_merlin_burst_uncompressor.sv
Info: ddr2_ram_avl_agent_rsp_fifo: "mm_interconnect_0" instantiated altera_avalon_sc_fifo "ddr2_ram_avl_agent_rsp_fifo"
Info: router: "mm_interconnect_0" instantiated altera_merlin_router "router"
Info: router_001: "mm_interconnect_0" instantiated altera_merlin_router "router_001"
Info: router_004: "mm_interconnect_0" instantiated altera_merlin_router "router_004"
Info: router_005: "mm_interconnect_0" instantiated altera_merlin_router "router_005"
Info: router_006: "mm_interconnect_0" instantiated altera_merlin_router "router_006"
Info: router_007: "mm_interconnect_0" instantiated altera_merlin_router "router_007"
Info: router_009: "mm_interconnect_0" instantiated altera_merlin_router "router_009"
Info: nios_cpu_data_master_limiter: "mm_interconnect_0" instantiated altera_merlin_traffic_limiter "nios_cpu_data_master_limiter"
Info: Reusing file /home/na62torino/Data/TestBench_CLONE/testbench_ls/synthesis/submodules/altera_merlin_traffic_limiter.sv
Info: Reusing file /home/na62torino/Data/TestBench_CLONE/testbench_ls/synthesis/submodules/altera_merlin_reorder_memory.sv
Info: Reusing file /home/na62torino/Data/TestBench_CLONE/testbench_ls/synthesis/submodules/altera_avalon_sc_fifo.v
Info: cmd_demux: "mm_interconnect_0" instantiated altera_merlin_demultiplexer "cmd_demux"
Info: cmd_demux_001: "mm_interconnect_0" instantiated altera_merlin_demultiplexer "cmd_demux_001"
Info: cmd_demux_004: "mm_interconnect_0" instantiated altera_merlin_demultiplexer "cmd_demux_004"
Info: cmd_mux: "mm_interconnect_0" instantiated altera_merlin_multiplexer "cmd_mux"
Info: Reusing file /home/na62torino/Data/TestBench_CLONE/testbench_ls/synthesis/submodules/altera_merlin_arbitrator.sv
Info: cmd_mux_001: "mm_interconnect_0" instantiated altera_merlin_multiplexer "cmd_mux_001"
Info: Reusing file /home/na62torino/Data/TestBench_CLONE/testbench_ls/synthesis/submodules/altera_merlin_arbitrator.sv
Info: cmd_mux_002: "mm_interconnect_0" instantiated altera_merlin_multiplexer "cmd_mux_002"
Info: Reusing file /home/na62torino/Data/TestBench_CLONE/testbench_ls/synthesis/submodules/altera_merlin_arbitrator.sv
Info: cmd_mux_004: "mm_interconnect_0" instantiated altera_merlin_multiplexer "cmd_mux_004"
Info: Reusing file /home/na62torino/Data/TestBench_CLONE/testbench_ls/synthesis/submodules/altera_merlin_arbitrator.sv
Info: rsp_demux: "mm_interconnect_0" instantiated altera_merlin_demultiplexer "rsp_demux"
Info: rsp_demux_001: "mm_interconnect_0" instantiated altera_merlin_demultiplexer "rsp_demux_001"
Info: rsp_demux_002: "mm_interconnect_0" instantiated altera_merlin_demultiplexer "rsp_demux_002"
Info: rsp_demux_004: "mm_interconnect_0" instantiated altera_merlin_demultiplexer "rsp_demux_004"
Info: rsp_mux: "mm_interconnect_0" instantiated altera_merlin_multiplexer "rsp_mux"
Info: Reusing file /home/na62torino/Data/TestBench_CLONE/testbench_ls/synthesis/submodules/altera_merlin_arbitrator.sv
Info: rsp_mux_001: "mm_interconnect_0" instantiated altera_merlin_multiplexer "rsp_mux_001"
Info: Reusing file /home/na62torino/Data/TestBench_CLONE/testbench_ls/synthesis/submodules/altera_merlin_arbitrator.sv
Info: rsp_mux_004: "mm_interconnect_0" instantiated altera_merlin_multiplexer "rsp_mux_004"
Info: Reusing file /home/na62torino/Data/TestBench_CLONE/testbench_ls/synthesis/submodules/altera_merlin_arbitrator.sv
Info: nios_cpu_data_master_to_ddr2_ram_avl_cmd_width_adapter: "mm_interconnect_0" instantiated altera_merlin_width_adapter "nios_cpu_data_master_to_ddr2_ram_avl_cmd_width_adapter"
Info: Reusing file /home/na62torino/Data/TestBench_CLONE/testbench_ls/synthesis/submodules/altera_merlin_burst_uncompressor.sv
Info: avalon_st_adapter: "mm_interconnect_0" instantiated altera_avalon_st_adapter "avalon_st_adapter"
Info: avalon_st_adapter_001: "mm_interconnect_0" instantiated altera_avalon_st_adapter "avalon_st_adapter_001"
Info: avalon_st_adapter_002: "mm_interconnect_0" instantiated altera_avalon_st_adapter "avalon_st_adapter_002"
Info: jtag_phy_embedded_in_jtag_master: "dmaster" instantiated altera_jtag_dc_streaming "jtag_phy_embedded_in_jtag_master"
Info: Reusing file /home/na62torino/Data/TestBench_CLONE/testbench_ls/synthesis/submodules/altera_avalon_st_pipeline_base.v
Info: timing_adt: "dmaster" instantiated timing_adapter "timing_adt"
Info: b2p: "dmaster" instantiated altera_avalon_st_bytes_to_packets "b2p"
Info: p2b: "dmaster" instantiated altera_avalon_st_packets_to_bytes "p2b"
Info: transacto: "dmaster" instantiated altera_avalon_packets_to_master "transacto"
Info: b2p_adapter: "dmaster" instantiated channel_adapter "b2p_adapter"
Info: p2b_adapter: "dmaster" instantiated channel_adapter "p2b_adapter"
Info: ng0: "c0" instantiated altera_mem_if_nextgen_ddr2_controller_core "ng0"
Info: a0: "c0" instantiated alt_mem_ddrx_mm_st_converter "a0"
Info: dispatcher_internal: "dma" instantiated modular_sgdma_dispatcher "dispatcher_internal"
Info: read_mstr_internal: "dma" instantiated dma_read_master "read_mstr_internal"
Info: write_mstr_internal: "ETH_DMA" instantiated dma_write_master "write_mstr_internal"
Info: data_format_adapter_0: "avalon_st_adapter" instantiated data_format_adapter "data_format_adapter_0"
Info: error_adapter_0: "avalon_st_adapter" instantiated error_adapter "error_adapter_0"
Info: error_adapter_0: "avalon_st_adapter_001" instantiated error_adapter "error_adapter_0"
Info: error_adapter_0: "avalon_st_adapter_002" instantiated error_adapter "error_adapter_0"
Info: testbench_ls: Done "testbench_ls" with 77 modules, 250 files
Info: qsys-generate succeeded.
Info: Finished: Create HDL design files for synthesis
