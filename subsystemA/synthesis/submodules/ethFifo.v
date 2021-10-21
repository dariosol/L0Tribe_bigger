module ethFifo(
// QSYS interface
	input csi_clk,
	input rsi_reset_n,
	//Avalon ST interface
	input asi_ready,
	output reg asi_valid,
	output	 [63:0] asi_data,
	output asi_startofpacket,
	output asi_endofpacket,
	//Peripheral Interface
	input [63:0] fifo_data,
	output reg fifo_read,
	input wire fifo_empty,
	input wire fifo_full
	);
	reg send_flag = 1'b0;
	reg FSM = 1'b0;
	reg sop = 1'b0;
	reg eop = 1'b0;
	assign asi_startofpacket = sop;
	assign asi_endofpacket = eop;
	assign asi_data = fifo_data; //connecting avalon to fifo
	always @(posedge csi_clk)
		begin	
			case(FSM)
				1'b0:
				begin
					if(fifo_full)
					begin
						fifo_read = 1'b1;
						sop <= 1'b1;
						FSM = 1'b1;
						
					end
					eop = 1'b0;
				end
				1'b1:
				begin
					sop <= 1'b0;
					asi_valid = 1'b1;
					if(fifo_empty)
					begin
						fifo_read <= 1'b0;
						asi_valid <= 1'b0;
						eop = 1'b1;
						FSM = 1'b0;
					end
				end
			endcase		
		end
endmodule
