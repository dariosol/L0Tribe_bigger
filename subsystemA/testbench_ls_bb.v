
module testbench_ls (
	clk_200_out_clk_clk,
	clk_50_clk,
	ctrl_sig_export,
	ddr2_ram_status_local_init_done,
	ddr2_ram_status_local_cal_success,
	ddr2_ram_status_local_cal_fail,
	dma_fifo_subsystem_2_fifo_stream_conduit_end_fifo_data,
	dma_fifo_subsystem_2_fifo_stream_conduit_end_fifo_write,
	dma_fifo_subsystem_2_fifo_stream_conduit_end_fifo_send,
	dma_fifo_subsystem_3_fifo_stream_conduit_end_fifo_data,
	dma_fifo_subsystem_3_fifo_stream_conduit_end_fifo_write,
	dma_fifo_subsystem_3_fifo_stream_conduit_end_fifo_send,
	dma_fifo_subsystem_4_fifo_stream_conduit_end_fifo_data,
	dma_fifo_subsystem_4_fifo_stream_conduit_end_fifo_write,
	dma_fifo_subsystem_4_fifo_stream_conduit_end_fifo_send,
	fifo_stream_fifo_data,
	fifo_stream_fifo_write,
	fifo_stream_fifo_send,
	fifo_stream_1_fifo_data,
	fifo_stream_1_fifo_write,
	fifo_stream_1_fifo_send,
	from_fifo_fifo_data,
	from_fifo_fifo_read,
	from_fifo_fifo_empty,
	from_fifo_fifo_full,
	input_io_0_external_connection_export,
	input_io_1_external_connection_export,
	input_io_2_external_connection_export,
	input_io_3_external_connection_export,
	input_io_4_external_connection_export,
	input_io_5_external_connection_export,
	input_io_external_connection_export,
	memory_mem_a,
	memory_mem_ba,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_dm,
	memory_mem_ras_n,
	memory_mem_cas_n,
	memory_mem_we_n,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	memory_mem_odt,
	memory_1_mem_a,
	memory_1_mem_ba,
	memory_1_mem_ck,
	memory_1_mem_ck_n,
	memory_1_mem_cke,
	memory_1_mem_cs_n,
	memory_1_mem_dm,
	memory_1_mem_ras_n,
	memory_1_mem_cas_n,
	memory_1_mem_we_n,
	memory_1_mem_dq,
	memory_1_mem_dqs,
	memory_1_mem_dqs_n,
	memory_1_mem_odt,
	oct_rdn,
	oct_rup,
	oct_1_rdn,
	oct_1_rup,
	pilot_sig_external_connection_export,
	reset_reset_n);	

	output		clk_200_out_clk_clk;
	input		clk_50_clk;
	output	[3:0]	ctrl_sig_export;
	output		ddr2_ram_status_local_init_done;
	output		ddr2_ram_status_local_cal_success;
	output		ddr2_ram_status_local_cal_fail;
	output	[255:0]	dma_fifo_subsystem_2_fifo_stream_conduit_end_fifo_data;
	output		dma_fifo_subsystem_2_fifo_stream_conduit_end_fifo_write;
	output		dma_fifo_subsystem_2_fifo_stream_conduit_end_fifo_send;
	output	[255:0]	dma_fifo_subsystem_3_fifo_stream_conduit_end_fifo_data;
	output		dma_fifo_subsystem_3_fifo_stream_conduit_end_fifo_write;
	output		dma_fifo_subsystem_3_fifo_stream_conduit_end_fifo_send;
	output	[255:0]	dma_fifo_subsystem_4_fifo_stream_conduit_end_fifo_data;
	output		dma_fifo_subsystem_4_fifo_stream_conduit_end_fifo_write;
	output		dma_fifo_subsystem_4_fifo_stream_conduit_end_fifo_send;
	output	[255:0]	fifo_stream_fifo_data;
	output		fifo_stream_fifo_write;
	output		fifo_stream_fifo_send;
	output	[255:0]	fifo_stream_1_fifo_data;
	output		fifo_stream_1_fifo_write;
	output		fifo_stream_1_fifo_send;
	input	[63:0]	from_fifo_fifo_data;
	output		from_fifo_fifo_read;
	input		from_fifo_fifo_empty;
	input		from_fifo_fifo_full;
	input	[15:0]	input_io_0_external_connection_export;
	input	[15:0]	input_io_1_external_connection_export;
	input	[15:0]	input_io_2_external_connection_export;
	input	[15:0]	input_io_3_external_connection_export;
	input	[15:0]	input_io_4_external_connection_export;
	input	[7:0]	input_io_5_external_connection_export;
	input	[15:0]	input_io_external_connection_export;
	output	[13:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output	[1:0]	memory_mem_ck;
	output	[1:0]	memory_mem_ck_n;
	output	[0:0]	memory_mem_cke;
	output	[0:0]	memory_mem_cs_n;
	output	[7:0]	memory_mem_dm;
	output	[0:0]	memory_mem_ras_n;
	output	[0:0]	memory_mem_cas_n;
	output	[0:0]	memory_mem_we_n;
	inout	[63:0]	memory_mem_dq;
	inout	[7:0]	memory_mem_dqs;
	inout	[7:0]	memory_mem_dqs_n;
	output	[0:0]	memory_mem_odt;
	output	[13:0]	memory_1_mem_a;
	output	[2:0]	memory_1_mem_ba;
	output	[1:0]	memory_1_mem_ck;
	output	[1:0]	memory_1_mem_ck_n;
	output	[0:0]	memory_1_mem_cke;
	output	[0:0]	memory_1_mem_cs_n;
	output	[7:0]	memory_1_mem_dm;
	output	[0:0]	memory_1_mem_ras_n;
	output	[0:0]	memory_1_mem_cas_n;
	output	[0:0]	memory_1_mem_we_n;
	inout	[63:0]	memory_1_mem_dq;
	inout	[7:0]	memory_1_mem_dqs;
	inout	[7:0]	memory_1_mem_dqs_n;
	output	[0:0]	memory_1_mem_odt;
	input		oct_rdn;
	input		oct_rup;
	input		oct_1_rdn;
	input		oct_1_rup;
	input	[7:0]	pilot_sig_external_connection_export;
	input		reset_reset_n;
endmodule
