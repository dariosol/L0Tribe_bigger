//                              -*- Mode: Verilog -*-
// Filename        : TestBench_LS.v
// Description     : Top module of L0Tribe
//Data are transferred from eth port0 to the DDR2 via DMA
//Then data are read back and sent via eth.
//When the buffer fifo has < 128 words, an interrupt is sent
//to receive primitives from DDR.

module TestBench_LS(
		    //////// CLOCK //////////
		    GCLKIN,
		    GCLKOUT_FPGA,
		    OSC_50_BANK6,
		    
		    //Clock 40 MHz To L0TP:
		    SMA_clkout_p,
		  
		    //////// External PLL //////////
		    MAX_I2C_SCLK,
		    MAX_I2C_SDAT,

		    //////// BUTTON x 4, EXT_IO and CPU_RESET_n //////////
		    BUTTON,
		    CPU_RESET_n,
		    EXT_IO,
		    /////// LED ////////////
		    LED,
		    //////// Fan //////////
		    FAN_CTRL,
   

		    //////// SDCARD //////////
		    SD_CLK,
		    SD_CMD,
		    SD_DAT,
		    SD_WP_n,

		    //////// DDR2 SODIMM //////////
		    M1_DDR2_addr,   
		    M1_DDR2_ba,	    
		    M1_DDR2_cas_n,  
		    M1_DDR2_cke,    
		    M1_DDR2_clk,    
		    M1_DDR2_clk_n,  
		    M1_DDR2_cs_n,   
		    M1_DDR2_dm,	    
		    M1_DDR2_dq,	    
		    M1_DDR2_dqs,    
		    M1_DDR2_dqsn,   
		    M1_DDR2_odt,    
		    M1_DDR2_ras_n,  
		    M1_DDR2_SA,	    
		    M1_DDR2_SCL,    
		                    
		    M1_DDR2_SDA,    
		    M1_DDR2_we_n,   
		    M1_DDR2_oct_rdn,
		    M1_DDR2_oct_rup,


		    M2_DDR2_addr,   
		    M2_DDR2_ba,	    
		    M2_DDR2_cas_n,  
		    M2_DDR2_cke,    
		    M2_DDR2_clk,    
		    M2_DDR2_clk_n,  
		    M2_DDR2_cs_n,   
		    M2_DDR2_dm,	    
		    M2_DDR2_dq,	    
		    M2_DDR2_dqs,    
		    M2_DDR2_dqsn,   
		    M2_DDR2_odt,    
		    M2_DDR2_ras_n,  
		    M2_DDR2_SA,
		    
		    M2_DDR2_SCL,                  
		    M2_DDR2_SDA,    
		    M2_DDR2_we_n,   
		    M2_DDR2_oct_rdn,
		    M2_DDR2_oct_rup,

		    ////ETHLINK/////
		    // SGMII(0 to 3): Onboard ethernet links 
		    ETH_RST_n    ,
		    ETH_RX_p     , 
		    ETH_TX_p     , 


		    // RGMII(0 to 1) : HSMC Port A -------------
		    // RGMII(2 to 3) : HSMC Port B -------------
		    ENET_RST_n  ,
		    ENET_TX_EN  ,
		    ENET_TX_ER  ,
		    ENET_GTX_CLK,
		    ENET_TX_D0  ,
		    ENET_TX_D1  ,
		    ENET_TX_D2  ,
		    ENET_TX_D3  ,
		    ENET_RX_DV  ,
		    ENET_RX_ER  ,
		    ENET_RX_CLK ,
		    ENET_RX_D0  ,
		    ENET_RX_D1  ,
		    ENET_RX_D2  ,
		    ENET_RX_D3  ,
		   //DIP SWITCHES
		    SW,
		    //////// 3-port High-Speed USB OTG //////////
		    OTG_A,
		    OTG_CS_n,
		    OTG_D,
		    OTG_DC_DACK,
		    OTG_DC_DREQ,
		    OTG_DC_IRQ,
		    OTG_HC_DACK,
		    OTG_HC_DREQ,
		    OTG_HC_IRQ,
		    OTG_OE_n,
		    OTG_RESET_n,
		    OTG_WE_n,
		    //////// SOB - EOB signals //////////////
		    //////// Connected on pins of JP3 connector////////
		    //Start of Burst (ECRST = 1; BCRST = 1)
		    //End   of Burst (ECRST = 1; BCRST = 0)
		    BCRST,
		    ECRST,
		    SynchTribe
		    );
   
   
   //=======================================================
   //  PORT declarations
   //=======================================================

   //////////// CLOCK //////////
   input		          		GCLKIN;
   output 					GCLKOUT_FPGA;
   output                                       SMA_clkout_p;
   input		          		OSC_50_BANK6;

   //////////// External PLL //////////
   output 					MAX_I2C_SCLK;
   inout		          		MAX_I2C_SDAT;

   //////////// BUTTON x 4, EXT_IO and CPU_RESET_n //////////
   input [3:0] 					BUTTON;
   input		          		CPU_RESET_n;
   inout		          		EXT_IO;

   //////////// Led ///////////
   output [7:0] 				LED;
   //////////// Fan //////////
   output 					FAN_CTRL;

   //////////// SDCARD //////////
   output 					SD_CLK;
   inout		          		SD_CMD;
   inout [3:0] 					SD_DAT;
   input		          		SD_WP_n;

   //////////// DDR2 SODIMM //////////
   output [15:0] 				M1_DDR2_addr;
   output [2:0] 				M1_DDR2_ba;
   output 					M1_DDR2_cas_n;
   output [1:0] 				M1_DDR2_cke;
   inout [1:0] 					M1_DDR2_clk;
   inout [1:0] 					M1_DDR2_clk_n;
   output [1:0] 				M1_DDR2_cs_n;
   output [7:0] 				M1_DDR2_dm;
   inout [63:0] 				M1_DDR2_dq;
   inout [7:0] 					M1_DDR2_dqs;
   inout [7:0] 					M1_DDR2_dqsn;
   output [1:0] 				M1_DDR2_odt;
   output 					M1_DDR2_ras_n;
   output [1:0] 				M1_DDR2_SA;
   output 					M1_DDR2_SCL;
   inout 					M1_DDR2_SDA;
   output 					M1_DDR2_we_n;
   input 					M1_DDR2_oct_rdn;
   input 					M1_DDR2_oct_rup;



   output [15:0] 				M2_DDR2_addr;
   output [2:0] 				M2_DDR2_ba;
   output 					M2_DDR2_cas_n;
   output [1:0] 				M2_DDR2_cke;
   inout [1:0] 					M2_DDR2_clk;
   inout [1:0] 					M2_DDR2_clk_n;
   output [1:0] 				M2_DDR2_cs_n;
   output [7:0] 				M2_DDR2_dm;
   inout [63:0] 				M2_DDR2_dq;
   inout [7:0] 					M2_DDR2_dqs;
   inout [7:0] 					M2_DDR2_dqsn;
   output [1:0] 				M2_DDR2_odt;
   output 					M2_DDR2_ras_n;
   output [1:0] 				M2_DDR2_SA;
   output 					M2_DDR2_SCL;
   inout 					M2_DDR2_SDA;
   output 					M2_DDR2_we_n;
   input 					M2_DDR2_oct_rdn;
   input 					M2_DDR2_oct_rup;



   
   /////////// ETHLINK //////////
   input [7:0]                                  SW;

   // SGMII(0 to 3): Onboard ethernet links
   output                                      ETH_RST_n;
   input [0:3] 				       ETH_RX_p ;
   output [0:3] 			       ETH_TX_p ;
   
   
   // RGMII(0 to 1) : HSMC Port A -------------
   // RGMII(2 to 3) : HSMC Port B -------------

   output [0:3]				       ENET_RST_n  ;
   output [0:3] 			       ENET_TX_EN  ;
   output [0:3] 			       ENET_TX_ER  ;
   output [0:3] 			       ENET_GTX_CLK;
   output [7:0]			               ENET_TX_D0  ;
   output [7:0] 			       ENET_TX_D1  ;
   output [7:0] 			       ENET_TX_D2  ;
   output [7:0] 			       ENET_TX_D3  ;
   input [0:3] 				       ENET_RX_DV  ;
   input [0:3] 				       ENET_RX_ER  ;
   input [0:3] 				       ENET_RX_CLK ;
   input [7:0]   			       ENET_RX_D0;
   input [7:0] 			               ENET_RX_D1;
   input [7:0] 			               ENET_RX_D2;
   input [7:0] 			               ENET_RX_D3;
   ///////////USB/////////////////
   output [17:1] 			       OTG_A;
   output 				       OTG_CS_n;
   inout [31:0] 			       OTG_D;
   output 				       OTG_DC_DACK;
   input 				       OTG_DC_DREQ;
   input 				       OTG_DC_IRQ;
   output 				       OTG_HC_DACK;
   input 				       OTG_HC_DREQ;
   input 				       OTG_HC_IRQ;
   output 				       OTG_OE_n;
   output 				       OTG_RESET_n;
   output 				       OTG_WE_n;
   output 				       BCRST;
   output 				       ECRST;
   output 				       SynchTribe; //signal to synchronize two tribe boards. The bigger fpga sends the start, the smaller receive it

   //===== ==================================================
   //  REG/WIRE declarations
   //=======================================================
   wire 					clk_pll_40;
   wire 					clk_pll_200;
   wire 					clk_pll_125;
   //wire 					clk_pll_400;

   wire 					lock40MHz;
   wire 					lock125MHz;

   reg [7:0] 					interrupt;
   reg [7:0] 				        polling;

   wire                                         wECRST;
   wire                                         wBCRST;

   
//   assign rstn = CPU_RESET_n;
   
   
   assign FAN_CTRL	= 1'bz;	// don't control
  
   //Primitive FIFO connections
   //5 positions: one for each port.
   wire [4:0] 					fifoWR;
   wire [4:0] 					fifoRR;
   wire [4:0] 					fifoEMPTY;
   wire [4:0] 					fifoFULL;
   
   //FIFO  containing primitives
   wire [255:0] 				fifoDATA[4:0];
   wire [255:0]					fifoQ[4:0];
   wire [10:0] 					fifoWRusedW[4:0];
   wire [10:0] 					fifoRDusedW[4:0];
   
   wire [4:0] 					fifoSEND;

   wire [63:0] 					ToRamQ;            
   wire 					ToRamRR;           
   wire 					ToRamEMPTY;        
   wire 					ToRamFULL;
   wire [63:0] 					ToRamDATA;          


   //ETHLINK
   reg [3:0] 					mdio_sin;          
   reg [3:0] 					mdio_sena;        
   reg [3:0] 					mdio_sout;       


   //Data From NIOS
   reg [3:0] 					ctrl_sig;

   //Data To NIOS
   reg [7:0] 					detectorUnderInit;


//SOFTWARE RESET
   integer s_reset_counter;
   reg[1:0] FSMReset;
   parameter S0=0, S1=1, S2=2, S3=3;
   
   reg s_software_CPU_RESET_n; 
    
   
   //Dario Add: PLL 40MHz
   //To drive L0TP logic
   pll40MHz pll40MHz0 (
		       .areset(~rstn),
		       .inclk0(clk_200),
		       .c0(clk_pll_40),  //out at 40MHz	
		       .c1(clk_pll_200),  //out at 200MHz
		       //.c2(clk_pll_400),  //out at 400MHz
		       .locked(lock40MHz)
		       );

   //PLL 125MHz to drive ethernet logic
   pll125MHz pll125MHz0 (
			 .areset(~rstn),
			 .inclk0(clk_200),
			 .c0(clk_pll_125),  //out at 125MHz	
			 .locked(lock125MHz)
			 );

				

   //SOB EOB DISPATCHER
   SOBEOBDispatcher SOBEOBDispatcher0(
				      .clk(clk_pll_40),
				      .BURST(START),
				      .reset(~rstn),
				      .ECRST(wECRST),
				      .BCRST(wBCRST)
				      );
   

   //port 0
   primitiveFIFO fifo0 (
			.aclr(~rstn),
			.data(fifoDATA[0]),
			.rdclk(clk_pll_125),
			.rdreq(fifoRR[0]),
			.wrclk(clk_200),
			.wrreq(fifoWR[0]),
			.q(fifoQ[0]),
			.rdempty(fifoEMPTY[0]),
			.wrfull(fifoFULL[0]),
			.wrusedw(fifoWRusedW[0]),
			.rdusedw(fifoRDusedW[0])
			);

   //port 1
   primitiveFIFO fifo1 (
			.aclr(~rstn),
			.data(fifoDATA[1]),
			.rdclk(clk_pll_125),
			.rdreq(fifoRR[1]),
			.wrclk(clk_200),
			.wrreq(fifoWR[1]),
			.q(fifoQ[1]),
			.rdempty(fifoEMPTY[1]),
			.wrfull(fifoFULL[1]),
			.wrusedw(fifoWRusedW[1]),
			.rdusedw(fifoRDusedW[1])
			);

   //port 2
   primitiveFIFO fifo2 (
			.aclr(~rstn),
			.data(fifoDATA[2]),
			.rdclk(clk_pll_125),
			.rdreq(fifoRR[2]),
			.wrclk(clk_200),
			.wrreq(fifoWR[2]),
			.q(fifoQ[2]),
			.rdempty(fifoEMPTY[2]),
			.wrfull(fifoFULL[2]),
			.wrusedw(fifoWRusedW[2]),
			.rdusedw(fifoRDusedW[2])			
			);

   //port 3
   primitiveFIFO fifo3 (
			.aclr(~rstn),
			.data(fifoDATA[3]),
			.rdclk(clk_pll_125),
			.rdreq(fifoRR[3]),
			.wrclk(clk_200),
			.wrreq(fifoWR[3]),
			.q(fifoQ[3]),
			.rdempty(fifoEMPTY[3]),
			.wrfull(fifoFULL[3]),
			.wrusedw(fifoWRusedW[3]),
			.rdusedw(fifoRDusedW[3])
			);

			//port 3
   primitiveFIFO fifo4 (
			.aclr(~rstn),
			.data(fifoDATA[4]),
			.rdclk(clk_pll_125),
			.rdreq(fifoRR[4]),
			.wrclk(clk_200),
			.wrreq(fifoWR[4]),
			.q(fifoQ[4]),
			.rdempty(fifoEMPTY[4]),
			.wrfull(fifoFULL[4]),
			.wrusedw(fifoWRusedW[4]),
			.rdusedw(fifoRDusedW[4])
			);

   //FIFO to Transfer data from NIOS to external RAM
   FifoToRAM fifoToRAM0 (
			 .aclr(~rstn),
			 .data(ToRamDATA),
			 .rdclk(clk_200),
			 .rdreq(ToRamRR),
			 .wrclk(clk_pll_125),
			 .wrreq(ToRamWR ),
			 .q(ToRamQ),
			 .rdempty(ToRamEMPTY),
			 .wrfull()
			 );


   testbench_ls u0 (
		    .clk_200_out_clk_clk                  (clk_200),          //     clk_200_out.clk
		    .clk_50_clk                           (OSC_50_BANK6),     //     clk_50.clk
		    .ctrl_sig_export                      (ctrl_sig),      //     ctrl_sig.export
		    .ddr2_ram_status_local_init_done      (),                 // ddr2_ram_status.local_init_done
		    .ddr2_ram_status_local_cal_success    (),                 //                .local_cal_success
		    .ddr2_ram_status_local_cal_fail       (),                 //                .local_cal_fail
		    //FIFO bridge0   
		    .fifo_stream_fifo_data                (fifoDATA[0]),      //     fifo_stream.fifo_data
		    .fifo_stream_fifo_write               (fifoWR[0]),        //                .fifo_write
		    .fifo_stream_fifo_send                (fifoSEND[0]),      //                .fifo_send
		    //FIFO bridge1   
		    .fifo_stream_1_fifo_data              (fifoDATA[1]),      //     fifo_stream.fifo_data
		    .fifo_stream_1_fifo_write             (fifoWR[1]),        //                .fifo_write
		    .fifo_stream_1_fifo_send              (fifoSEND[1]),      //                .fifo_send
		    
		    .dma_fifo_subsystem_2_fifo_stream_conduit_end_fifo_data  (fifoDATA[2]),  
		    .dma_fifo_subsystem_2_fifo_stream_conduit_end_fifo_write (fifoWR[2]),
		    .dma_fifo_subsystem_2_fifo_stream_conduit_end_fifo_send  (fifoSEND[2]),
		    
		    .dma_fifo_subsystem_3_fifo_stream_conduit_end_fifo_data  (fifoDATA[3]),
		    .dma_fifo_subsystem_3_fifo_stream_conduit_end_fifo_write (fifoWR[3]),
		    .dma_fifo_subsystem_3_fifo_stream_conduit_end_fifo_send  (fifoSEND[3]),
		    
		    .dma_fifo_subsystem_4_fifo_stream_conduit_end_fifo_data  (fifoDATA[4]),
		    .dma_fifo_subsystem_4_fifo_stream_conduit_end_fifo_write (fifoWR[4]),
		    .dma_fifo_subsystem_4_fifo_stream_conduit_end_fifo_send  (fifoSEND[4]),
		    
			 
			 
			 
		    //DDR2 RAM   
		    .memory_mem_a                         (M1_DDR2_addr),
		    .memory_mem_ba                        (M1_DDR2_ba),
		    .memory_mem_ck                        (M1_DDR2_clk),
		    .memory_mem_ck_n                      (M1_DDR2_clk_n),
		    .memory_mem_cke                       (M1_DDR2_cke),
		    .memory_mem_cs_n                      (M1_DDR2_cs_n),
		    .memory_mem_dm                        (M1_DDR2_dm),
		    .memory_mem_ras_n                     (M1_DDR2_ras_n), 
		    .memory_mem_cas_n                     (M1_DDR2_cas_n),
		    .memory_mem_we_n                      (M1_DDR2_we_n),
		    .memory_mem_dq                        (M1_DDR2_dq),
		    .memory_mem_dqs                       (M1_DDR2_dqs),
		    .memory_mem_dqs_n                     (M1_DDR2_dqsn),
		    .memory_mem_odt                       (M1_DDR2_odt),
		    .oct_rdn                              (M1_DDR2_oct_rdn),
		    .oct_rup                              (M1_DDR2_oct_rup),
		    		    //DDR2 RAM   
		    .memory_1_mem_a                         (M2_DDR2_addr),
		    .memory_1_mem_ba                        (M2_DDR2_ba),
		    .memory_1_mem_ck                        (M2_DDR2_clk),
		    .memory_1_mem_ck_n                      (M2_DDR2_clk_n),
		    .memory_1_mem_cke                       (M2_DDR2_cke),
		    .memory_1_mem_cs_n                      (M2_DDR2_cs_n),
		    .memory_1_mem_dm                        (M2_DDR2_dm),
		    .memory_1_mem_ras_n                     (M2_DDR2_ras_n), 
		    .memory_1_mem_cas_n                     (M2_DDR2_cas_n),
		    .memory_1_mem_we_n                      (M2_DDR2_we_n),
		    .memory_1_mem_dq                        (M2_DDR2_dq),
		    .memory_1_mem_dqs                       (M2_DDR2_dqs),
		    .memory_1_mem_dqs_n                     (M2_DDR2_dqsn),
		    .memory_1_mem_odt                       (M2_DDR2_odt),
		    .oct_1_rdn                              (M2_DDR2_oct_rdn),
		    .oct_1_rup                              (M2_DDR2_oct_rup),
		    
		    .reset_reset_n                        (rstn),  //           reset.reset_n
		    .from_fifo_fifo_data                  (ToRamQ),               //       from_fifo.fifo_data
		    .from_fifo_fifo_read                  (ToRamRR),              //                .fifo_read
		    .from_fifo_fifo_empty                 (ToRamEMPTY),           //                .fifo_empty
		    .from_fifo_fifo_full                  (ToRamFULL),	         //                .fifo_full
		    .pilot_sig_external_connection_export (interrupt),
		    .input_io_external_connection_export  (detectorUnderInit),
		    .input_io_0_external_connection_export  (fifoWRusedW[0]),
		    .input_io_1_external_connection_export  (fifoWRusedW[1]),
		    .input_io_2_external_connection_export  (fifoWRusedW[2]),
		    .input_io_3_external_connection_export  (fifoWRusedW[3]),
		    .input_io_4_external_connection_export  (fifoWRusedW[4]),
		    .input_io_5_external_connection_export  (polling)
		    );
   

   
   Controller c0    (
		     .clkin_50          (OSC_50_BANK6),
		     .clkin_125         (clk_pll_125),
		     .cpu_resetn        ( rstn),
		     .USER_DIPSW        ( SW ),
		     .startdata         (ctrl_sig[0]),
		     
		     .datasend0         (fifoQ[0]),
		     .readfromfifo0     (fifoRR[0]),
		     .primitiveFIFOempty0(fifoEMPTY[0]),

		     .datasend1          (fifoQ[1]),
		     .readfromfifo1      (fifoRR[1]),
		     .primitiveFIFOempty1(fifoEMPTY[1]),

		     .datasend2          (fifoQ[2]),
		     .readfromfifo2      (fifoRR[2]),
		     .primitiveFIFOempty2(fifoEMPTY[2]),

		     .datasend3          (fifoQ[3]),
		     .readfromfifo3           (fifoRR[3]),
		     .primitiveFIFOempty3(fifoEMPTY[3]),

		     .datasend4          (fifoQ[4]),
		     .readfromfifo4      (fifoRR[4]),
		     .primitiveFIFOempty4(fifoEMPTY[4]),
		     
		     .macdata            (ToRamDATA),   
		     .macreceived        (ToRamWR),  
		     .packetreceived     (ToRamFULL),
		     .detectorUnderInit  (detectorUnderInit[3:0]),
		     .cETH_RX_p          (ETH_RX_p),
		     .cENET_RX_CLK       (ENET_RX_CLK),
		     .cENET_RX_DV        (ENET_RX_DV),
		     .cENET_RX_ER        (ENET_RX_ER),
		     .cENET_RX_D0        (ENET_RX_D0),
		     .cENET_RX_D1        (ENET_RX_D1),
		     .cENET_RX_D2        (ENET_RX_D2),
		     .cENET_RX_D3        (ENET_RX_D3),
		     .cETH_RST_n         (ETH_RST_n),
		     .cETH_TX_p          (ETH_TX_p),
		     .cENET_RST_n        (ENET_RST_n),
		     .cENET_GTX_CLK      (ENET_GTX_CLK),
		     .cENET_TX_EN        (ENET_TX_EN),
		     .cENET_TX_ER        (ENET_TX_ER),
		     .cENET_TX_D0        (ENET_TX_D0),
		     .cENET_TX_D1        (ENET_TX_D1),
		     .cENET_TX_D2        (ENET_TX_D2),
		     .cENET_TX_D3        (ENET_TX_D3)
		     		     
		     
		     );


   always @ (fifoWRusedW)
     if(ctrl_sig[0]) begin //IN BUST
	if (fifoWRusedW[0] < 11'h400) begin
	   interrupt[0] = 1'b1; //if I have less than 1024 words, ask NIOS to transfer
	   polling[0] = 1'b1;
        end
	else begin
	   interrupt[0] = 1'b0;
	   polling[0] =1'b0;
	end


	if (fifoWRusedW[1] < 11'h400) begin
	   interrupt[1] = 1'b1; //if I have less than 1024 words, ask NIOS to transfer
	   polling[1] = 1'b1;
        end
	else begin
	   interrupt[1] = 1'b0;
	   polling[1] =1'b0;
	end


	if (fifoWRusedW[2] < 11'h400) begin
	   interrupt[2] = 1'b1; //if I have less than 1024 words, ask NIOS to transfer
	   polling[2] = 1'b1;
        end
	else begin
	   interrupt[2] = 1'b0;
	   polling[2] =1'b0;
	end


	if (fifoWRusedW[3] < 11'h400) begin
	   interrupt[3] = 1'b1; //if I have less than 1024 words, ask NIOS to transfer
	   polling[3] = 1'b1;
        end
	else begin
	   interrupt[3] = 1'b0;
	   polling[3] =1'b0;
	end


	if (fifoWRusedW[4] < 11'h400) begin
	   interrupt[4] = 1'b1; //if I have less than 1024 words, ask NIOS to transfer
	   polling[4] = 1'b1;
        end
	else begin
	   interrupt[4] = 1'b0;
	   polling[4] =1'b0;
	end
	
     end
     else begin
	polling = 8'b00000000;
	interrupt = detectorUnderInit;
     end


	  
always @ (FSMReset) begin
   
         case (FSMReset)
	   S0:
	     s_software_CPU_RESET_n = 1'b1;
	   S1:
	     s_software_CPU_RESET_n = 1'b1;	
	   S2:
	     s_software_CPU_RESET_n <= 1'b0;//Software reset
	   S3:
	     s_software_CPU_RESET_n <= 1'b1;
	   default:
	     s_software_CPU_RESET_n <= 1'b1;
	   
	 endcase // case (FSMReset)
end // always @ (FSMReset)
   
   always @ (posedge OSC_50_BANK6) begin
	   case (FSMReset)
	     S0:
	       begin
		  s_reset_counter<=0;
		  FSMReset <=S1;
	       end
	     
	     S1:
	       if(s_reset_counter < 200000) begin
		  FSMReset<=S1;
		  s_reset_counter<=s_reset_counter+1;
	       end
	       else 
		 FSMReset<=S2;

	     S2:  if(s_reset_counter < 65000000) begin
		FSMReset<=S2;
		s_reset_counter<=s_reset_counter+1;
	     end
	     else 
	       FSMReset<=S3;
	     S3:
	       if(ctrl_sig[1]==1) begin
		  FSMReset <=S0;
	       end
	     
	       else begin 
		 FSMReset<=S3;
	       end
	   endcase // case (FSMReset)
	end // always @ (posedge OSC_50_BANK6 or CPU_RESET_n)
      



   


   assign START = ctrl_sig[0] | ~BUTTON[0];
	
   assign rstn =    s_software_CPU_RESET_n;
   
//MODIFICATO PER L0TP+	
//   assign SMA_clkout_p = clk_pll_40;
	assign SMA_clkout_p = clk_pll_125;
   
   assign ECRST        = wECRST;
   assign BCRST        = wBCRST;

   
   ///LED: Negative Logic
   assign LED[0] = ~lock40MHz;
   assign LED[1] = ~lock125MHz;
   assign LED[2] = ~ctrl_sig[0];
   assign LED[3] = ~ctrl_sig[1];
   assign LED[4] = ~ctrl_sig[2];
   assign LED[5] = ~ctrl_sig[3];
   assign LED[6] = 1'b1;
   assign LED[7] = 1'b1;

   assign SynchTribe = START ;
   
endmodule





