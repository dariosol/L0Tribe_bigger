module streamFIFO(
		  // QSYS interface
		  input 	 csi_clk,
		  input 	 rsi_reset_n,
		  //Avalon ST interface
		  output reg 	 asi_ready,
		  input 	 asi_valid,
		  input [255:0]  asi_data,
		  //Peripheral Interface
		  output [255:0] fifo_data,
		  output 	 fifo_write,
		  output wire 	 fifo_send
		  );

   reg send_flag = 1'b0;
   reg FSM = 1'b0;
   
////Function for reversing the number of bits in a parallel bus.
//   function [16-1:0] bitOrder (
//			       input [255:0] data
//			       );
//      integer i;
//      begin
//	 for (i=0; i < 256; i=i+1) begin : reverse
//            bitOrder[255-i] = data[i]; //Note how the vectors get swapped around here by the index. For i=0, i_out=15, and vice versa.
//	 end
//      end
//   endfunction // bitOrder
//
   
   assign fifo_write = asi_valid; // write word to fifo
   assign fifo_data[255:224] = asi_data[31:0]; //connecting avalon to fifo
   assign fifo_data[223:192] = asi_data[63:32]; //connecting avalon to fifo
   assign fifo_data[191:160] = asi_data[95:64]; //connecting avalon to fifo
   assign fifo_data[159:128] = asi_data[127:96]; //connecting avalon to fifo
   assign fifo_data[127:96]  = asi_data[159:128]; //connecting avalon to fifo
   assign fifo_data[95:64]   = asi_data[191:160]; //connecting avalon to fifo
   assign fifo_data[63:32]   = asi_data[223:192]; //connecting avalon to fifo
   assign fifo_data[31:0]    = asi_data[255:224]; //connecting avalon to fifo
   
   always @(posedge csi_clk)
     begin	
	asi_ready = 1'b1;
	case(FSM)
	  1'b0:
	    begin
	       send_flag = 1'b0;
	       if(asi_valid) FSM <= 1'b1;
	    end
	  1'b1:
	    begin
	       if(~asi_valid)
		 begin
		    send_flag = 1'b1;
		    FSM <= 1'b0;
		 end
	    end
	endcase		
     end
   assign fifo_send = send_flag;
endmodule
