module ISP1761_IF(	//	avalon MM slave port, ISP1362, host control
					
					csi_dummy_clk,
					rsi_rst_n,

					//Avalon MM Slave
					avs_cs_n,
					avs_address,
					avs_write_n,
					avs_writedata,
					avs_read_n,
					avs_readdata,
					ins_hc_irq,
					
					ins_dc_irq,
					
					//Peripheral interface
					coe_CS_N,
					coe_WR_N,
					coe_RD_N,
					coe_D,
					coe_A,
					coe_DC_IRQ,
					coe_HC_IRQ,
					coe_DC_DREQ,
					coe_HC_DREQ,
					coe_DC_DACK,
					coe_HC_DACK,
					coe_RESET_n
					
				 );


// slave hc
input				csi_dummy_clk;
input				rsi_rst_n;
input				avs_cs_n;
input   [17:0]     		avs_address;
input				avs_write_n;
input	[31:0]			avs_writedata;
input			        avs_read_n;
output	[31:0]			avs_readdata;
output 		   	ins_hc_irq;
output 		   	ins_dc_irq;

					// export
output				coe_CS_N;					
output				coe_WR_N;
output				coe_RD_N;
inout [31:0]		coe_D;
output[17:1]		coe_A;
input               coe_DC_IRQ;              
input               coe_HC_IRQ;
input               coe_DC_DREQ;              
input               coe_HC_DREQ;              
output              coe_DC_DACK;              
output              coe_HC_DACK;
output		    coe_RESET_n;


assign coe_CS_N = avs_cs_n;
assign coe_WR_N = avs_write_n;
assign coe_RD_N = avs_read_n;
assign coe_A = avs_address[17:1];
assign	ins_hc_irq =  coe_HC_IRQ;
assign	ins_dc_irq =  coe_DC_IRQ;
assign	coe_RESET_n = rsi_rst_n;

assign	coe_D		  =	(!avs_cs_n & avs_read_n) ? avs_writedata : 32'hzzzzzzzz;
assign  avs_readdata = (!avs_cs_n & !avs_read_n & avs_write_n) ? coe_D : 32'hzzzzzzzz;




endmodule

