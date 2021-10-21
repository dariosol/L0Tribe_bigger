	component testbench_ls is
		port (
			clk_200_out_clk_clk                  : out   std_logic;                                         -- clk
			clk_50_clk                           : in    std_logic                      := 'X';             -- clk
			ctrl_sig_export                      : out   std_logic_vector(3 downto 0);                      -- export
			ddr2_ram_status_local_init_done      : out   std_logic;                                         -- local_init_done
			ddr2_ram_status_local_cal_success    : out   std_logic;                                         -- local_cal_success
			ddr2_ram_status_local_cal_fail       : out   std_logic;                                         -- local_cal_fail
			fifo_stream_fifo_data                : out   std_logic_vector(255 downto 0);                    -- fifo_data
			fifo_stream_fifo_write               : out   std_logic;                                         -- fifo_write
			fifo_stream_fifo_send                : out   std_logic;                                         -- fifo_send
			fifo_stream_1_fifo_data              : out   std_logic_vector(255 downto 0);                    -- fifo_data
			fifo_stream_1_fifo_write             : out   std_logic;                                         -- fifo_write
			fifo_stream_1_fifo_send              : out   std_logic;                                         -- fifo_send
			memory_mem_a                         : out   std_logic_vector(13 downto 0);                     -- mem_a
			memory_mem_ba                        : out   std_logic_vector(2 downto 0);                      -- mem_ba
			memory_mem_ck                        : out   std_logic_vector(1 downto 0);                      -- mem_ck
			memory_mem_ck_n                      : out   std_logic_vector(1 downto 0);                      -- mem_ck_n
			memory_mem_cke                       : out   std_logic_vector(0 downto 0);                      -- mem_cke
			memory_mem_cs_n                      : out   std_logic_vector(0 downto 0);                      -- mem_cs_n
			memory_mem_dm                        : out   std_logic_vector(7 downto 0);                      -- mem_dm
			memory_mem_ras_n                     : out   std_logic_vector(0 downto 0);                      -- mem_ras_n
			memory_mem_cas_n                     : out   std_logic_vector(0 downto 0);                      -- mem_cas_n
			memory_mem_we_n                      : out   std_logic_vector(0 downto 0);                      -- mem_we_n
			memory_mem_dq                        : inout std_logic_vector(63 downto 0)  := (others => 'X'); -- mem_dq
			memory_mem_dqs                       : inout std_logic_vector(7 downto 0)   := (others => 'X'); -- mem_dqs
			memory_mem_dqs_n                     : inout std_logic_vector(7 downto 0)   := (others => 'X'); -- mem_dqs_n
			memory_mem_odt                       : out   std_logic_vector(0 downto 0);                      -- mem_odt
			oct_rdn                              : in    std_logic                      := 'X';             -- rdn
			oct_rup                              : in    std_logic                      := 'X';             -- rup
			pilot_sig_external_connection_export : in    std_logic_vector(3 downto 0)   := (others => 'X'); -- export
			reset_reset_n                        : in    std_logic                      := 'X'              -- reset_n
		);
	end component testbench_ls;

	u0 : component testbench_ls
		port map (
			clk_200_out_clk_clk                  => CONNECTED_TO_clk_200_out_clk_clk,                  --               clk_200_out_clk.clk
			clk_50_clk                           => CONNECTED_TO_clk_50_clk,                           --                        clk_50.clk
			ctrl_sig_export                      => CONNECTED_TO_ctrl_sig_export,                      --                      ctrl_sig.export
			ddr2_ram_status_local_init_done      => CONNECTED_TO_ddr2_ram_status_local_init_done,      --               ddr2_ram_status.local_init_done
			ddr2_ram_status_local_cal_success    => CONNECTED_TO_ddr2_ram_status_local_cal_success,    --                              .local_cal_success
			ddr2_ram_status_local_cal_fail       => CONNECTED_TO_ddr2_ram_status_local_cal_fail,       --                              .local_cal_fail
			fifo_stream_fifo_data                => CONNECTED_TO_fifo_stream_fifo_data,                --                   fifo_stream.fifo_data
			fifo_stream_fifo_write               => CONNECTED_TO_fifo_stream_fifo_write,               --                              .fifo_write
			fifo_stream_fifo_send                => CONNECTED_TO_fifo_stream_fifo_send,                --                              .fifo_send
			fifo_stream_1_fifo_data              => CONNECTED_TO_fifo_stream_1_fifo_data,              --                 fifo_stream_1.fifo_data
			fifo_stream_1_fifo_write             => CONNECTED_TO_fifo_stream_1_fifo_write,             --                              .fifo_write
			fifo_stream_1_fifo_send              => CONNECTED_TO_fifo_stream_1_fifo_send,              --                              .fifo_send
			memory_mem_a                         => CONNECTED_TO_memory_mem_a,                         --                        memory.mem_a
			memory_mem_ba                        => CONNECTED_TO_memory_mem_ba,                        --                              .mem_ba
			memory_mem_ck                        => CONNECTED_TO_memory_mem_ck,                        --                              .mem_ck
			memory_mem_ck_n                      => CONNECTED_TO_memory_mem_ck_n,                      --                              .mem_ck_n
			memory_mem_cke                       => CONNECTED_TO_memory_mem_cke,                       --                              .mem_cke
			memory_mem_cs_n                      => CONNECTED_TO_memory_mem_cs_n,                      --                              .mem_cs_n
			memory_mem_dm                        => CONNECTED_TO_memory_mem_dm,                        --                              .mem_dm
			memory_mem_ras_n                     => CONNECTED_TO_memory_mem_ras_n,                     --                              .mem_ras_n
			memory_mem_cas_n                     => CONNECTED_TO_memory_mem_cas_n,                     --                              .mem_cas_n
			memory_mem_we_n                      => CONNECTED_TO_memory_mem_we_n,                      --                              .mem_we_n
			memory_mem_dq                        => CONNECTED_TO_memory_mem_dq,                        --                              .mem_dq
			memory_mem_dqs                       => CONNECTED_TO_memory_mem_dqs,                       --                              .mem_dqs
			memory_mem_dqs_n                     => CONNECTED_TO_memory_mem_dqs_n,                     --                              .mem_dqs_n
			memory_mem_odt                       => CONNECTED_TO_memory_mem_odt,                       --                              .mem_odt
			oct_rdn                              => CONNECTED_TO_oct_rdn,                              --                           oct.rdn
			oct_rup                              => CONNECTED_TO_oct_rup,                              --                              .rup
			pilot_sig_external_connection_export => CONNECTED_TO_pilot_sig_external_connection_export, -- pilot_sig_external_connection.export
			reset_reset_n                        => CONNECTED_TO_reset_reset_n                         --                         reset.reset_n
		);

