#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <string.h>
#include <io.h>
#include <time.h>
#include "system.h"
#include "altera_msgdma_descriptor_regs.h"
#include "altera_msgdma_csr_regs.h"
#include "altera_msgdma_response_regs.h"
#include "altera_avalon_pio_regs.h"
#include "altera_msgdma.h"
#include "sys/alt_irq.h"
#include "alt_types.h"
#include <sys/alt_alarm.h>
#include "sys/alt_cache.h"
#include "sys/alt_errno.h"
#include "stdbool.h"
#define nrams 2
#define ndet  5 //CHOD(0),RICH(1),LKr(2),MUV3(3),newCHOD(4)

#define HAL_PLATFORM_RESET() NIOS2_WRITE_STATUS(0); NIOS2_WRITE_IENABLE(0); ((void (*) (void)) NIOS2_RESET_ADDR) ()

///////////////////////////////////////
///RAM:
//Each detector has 280MB allocated (to host almost 70M primitives).
//In the first ram (RAM 0) I allocate CHOD, RICH and LKR.
//In the second ram (RAM 1) I allocate NewCHOD and MUV3

//RAM CONFIGURATION:
/////////RAM0////////
//DET NUMBER --- NAME ------ ADDRESS
//   0           CHOD     [0x80 ; 0x11800000]
//   1           RICH     [0x11800000 ; 0x23000000]
//   2           LKr      [0x23000000 ; 0x34800000]

/////////RAM1////////
//DET NUMBER --- NAME ------ ADDRESS
//   3           MUV3        [0x80 ; 0x11800000]
//   4           NewCHOD     [0x11800000 ; 0x23000000]
///////////////////////////////////////



alt_u32 addressRAM0_0 = 0x80; //CONTAINS CHOD, RICH, LKR
alt_u32 addressRAM0_1 = 0x11800080; //CONTAINS CHOD, RICH, LKR
alt_u32 addressRAM0_2 = 0x23000080; //CONTAINS CHOD, RICH, LKR

alt_u32 addressRAM1_0 = 0x80; //CONTAINS NewCHOD, MUV3
alt_u32 addressRAM1_1 = 0x11800080; //CONTAINS NewCHOD, MUV3


////////////////////////////
///Pointers to read from the DDR2
alt_msgdma_standard_descriptor a_descriptor[ndet];
alt_msgdma_standard_descriptor *a_descriptor_ptr[ndet];
alt_msgdma_dev dev[ndet];
alt_msgdma_dev *dev_ptr[ndet];

alt_u32 control = 0;

///READING OPERATORS:
alt_u32 rd_addr[ndet];
alt_u32 * rd_adr_p[ndet];
alt_u32 * ram_access_ptr[ndet];

///Which detector is ready to be initialized
alt_u8 detectorUnderInit=15;

//volatile alt_u32 * FIFOEMPTY = (alt_u32*) PILOT_SIG_BASE;
volatile alt_u32 * FIFOUSEDW0= (alt_u32*) INPUT_IO_0_BASE;
volatile alt_u32 * FIFOUSEDW1= (alt_u32*) INPUT_IO_1_BASE;
volatile alt_u32 * FIFOUSEDW2= (alt_u32*) INPUT_IO_2_BASE;
volatile alt_u32 * FIFOUSEDW3= (alt_u32*) INPUT_IO_3_BASE;
volatile alt_u32 * FIFOUSEDW4= (alt_u32*) INPUT_IO_4_BASE;
volatile alt_u32 * POLLING= (alt_u32*)     INPUT_IO_5_BASE;


////////////////////////////////////////
////Function for interrupt
////////////////////////////////////////
volatile alt_u8 ISR_transfer_flag = 0;
volatile int ISR_input_val = 0;
////
void * ISR_input_ptr = (void *) &(ISR_input_val);
static void ISR_transfer_callback(void * context){
  volatile int* ISR_input_ptr = (volatile int *) context;

  *ISR_input_ptr = IORD_ALTERA_AVALON_PIO_EDGE_CAP(PILOT_SIG_BASE);
  IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PILOT_SIG_BASE,0xe);
  ISR_transfer_flag = *ISR_input_ptr;
}


/****************************************************************/
/****************************************************************/
/****************************************************************/
/******************************************************************
 *  Function: GetInputString
 *
 *  Purpose: Parses an input string for the character '\n'.  Then
 *           returns the string, minus any '\r' characters it
 *           encounters.
 *
 ******************************************************************/
char entry[4];
void GetInputString( char* entry, int size, FILE * stream )
{
  int i;
  int ch = 0;

  for(i = 0; (ch != '\n') && (i < size); )
    {
      if( (ch = getc(stream)) != '\r')
	{
	  entry[i] = ch;
	  i++;
	}
    }
}

/****************************************************************/
/****************************************************************/
/****************************************************************/
void Start() {
  printf("Welcome to the L0Tribe initializer program\n\n");
  printf("You should have the ethernet connection correctly setup to send primitives to the L0Tribe RAM\n");
  printf("Primitives to the L0Tribe RAM pass from the eth link 0: configured as 192.168.1.8; mac: 00:01:02:03:04:08\n\n");

  IOWR(CTRL_SIG_BASE,0,0);
  printf("Type y when you are ready to start\n");

  while(1) {
    GetInputString( entry, sizeof(entry), stdin );
    printf("you wrote: %c, type y when you are ready to start\n", entry[0]);
    detectorUnderInit=IORD(INPUT_IO_BASE,0);
    printf("Input from IO: %d\n",(int)detectorUnderInit);
    if(entry[0] == 'y')
      {
	printf(" OK!\n ");
	break;
      }
  }
}

/****************************************************************/
/****************************************************************/
/****************************************************************/
void Init() {
  printf("NDETECTORS: %d\n",ndet);
  for (int i=0; i < ndet; ++i) {
    a_descriptor_ptr[i] = &a_descriptor[i];
    dev_ptr[i]= &dev[i];
    rd_adr_p[i] = 0x0;
    rd_addr[i] = 0x0;
    ram_access_ptr[i] = &rd_addr[i];
  }
  ////////////////////////////////////////////////////////////////////////////////
  /////////////////INITIALIZATION OF INTERRUPTS://////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  
  IOWR_ALTERA_AVALON_PIO_IRQ_MASK(PILOT_SIG_BASE,0xe); //enabling interrupt on all 4 inputs
  IOWR_ALTERA_AVALON_PIO_EDGE_CAP(PILOT_SIG_BASE,0xe); //clearing older interrupts
  alt_ic_isr_register(PILOT_SIG_IRQ_INTERRUPT_CONTROLLER_ID, PILOT_SIG_IRQ, ISR_transfer_callback, ISR_input_ptr,0x0);//setting interrupt callback
  ISR_transfer_flag = 0;
  

  printf("would you like to reset the FPGA? y/n\n ");
  while(1) {
    GetInputString( entry, sizeof(entry), stdin );
    printf("you wrote: %c\n",entry[0]);
    if(entry[0] == 'y') {
      IOWR(CTRL_SIG_BASE,0,2); //SOB
      break;
    }
    if(entry[0] == 'n') {
      break;
    }
  }


}

bool checkendburst(alt_u32 SOB,alt_u32 EOB) {
  if(EOB-SOB > 6.8e3) return 1;
  else return 0;
}
/****************************************************************/
/****************************************************************/
/****************************************************************/
void CleanRAM() {

 
  printf("would you like to clean the ram? y/n\n ");
  while(1) {
    GetInputString( entry, sizeof(entry), stdin );
    printf("you wrote: %c\n",entry[0]);
    if(entry[0] == 'y') {
      IOWR(CTRL_SIG_BASE,0,0);
      break;
    }
    if(entry[0] == 'n') {
      IOWR(CTRL_SIG_BASE,0,0);
      break;
    }
  }




  if(entry[0] == 'y') {
    printf("OK! cleaning RAM0...\n ");

    for (unsigned int i = 0x0; i < DDR2_RAM_SPAN; i+=4)
      {
	IOWR_32DIRECT(DDR2_RAM_BASE, i,0x0);
      }

    printf("OK! cleaning RAM1...\n ");

    for (unsigned int i = 0x0; i < DDR2_RAM_1_SPAN; i+=4)
      {
	IOWR_32DIRECT(DDR2_RAM_1_BASE, i,0x0);
      }
  }
  else printf("OK! continuing without clean\n ");

}

/****************************************************************/
/****************************************************************/
/****************************************************************/
void SetDetectors() {
  //L0Tribe receives primitives from workstation.
  //Every 8 bytes it write a primitive in the FifoToRAM
  //When the ethernet packet is finished: a signal called ToRamFULL
  //says to the DMA to start moving data to the DDR.

  alt_msgdma_standard_descriptor a_descriptor_wr;
  alt_msgdma_standard_descriptor * a_descriptor_ptr_wr = &a_descriptor_wr;
  alt_msgdma_dev dev_wr;
  alt_msgdma_dev *dev_ptr_wr = &dev_wr;
  dev_ptr_wr = alt_msgdma_open(FROM_ETH_TO_DDR_ETH_DMA_CSR_NAME);

  alt_u32 control_wr = 0;
  alt_u32  len_wr=256;
  alt_u32 * wr_adr_p = (alt_u32 *) addressRAM0_0;

  alt_u32 status=0;


  while(1) {
    printf("which detector you like to write into the ram (0-4)? n to skip\n");
    GetInputString( entry, sizeof(entry), stdin );
    printf("you wrote: %c\n",entry[0]);

    if(entry[0] == '0') {
      if(dev_ptr_wr==NULL) {
	printf("Cannot Open DMA interface\n");
	break;
      }

      while(1) {
	if(alt_msgdma_construct_standard_st_to_mm_descriptor(dev_ptr_wr,a_descriptor_ptr_wr,wr_adr_p,len_wr,control_wr)!=-EINVAL) {/*printf("invalid arg\n");*/
	  status = alt_msgdma_standard_descriptor_async_transfer(dev_ptr_wr,a_descriptor_ptr_wr); //switching to async to get a speedup
	  if(status==0){
	    wr_adr_p+=64; //spedisco 1024 bytes: 1024
	  }
	  detectorUnderInit=IORD(INPUT_IO_BASE,0);
	  if(detectorUnderInit!=0) {
	    break;
	  }
	}
      }
    }
    else if(entry[0] == '1') {

      if(dev_ptr_wr==NULL) {
	printf("Cannot Open DMA interface\n");
	break;
      }
      while(1) {
	if(alt_msgdma_construct_standard_st_to_mm_descriptor(dev_ptr_wr,a_descriptor_ptr_wr,wr_adr_p,len_wr,control_wr)!=-EINVAL) {/*printf("invalid arg\n");*/
	  status = alt_msgdma_standard_descriptor_async_transfer(dev_ptr_wr,a_descriptor_ptr_wr); //switching to async to get a speedup
	  if(status==0){
	    wr_adr_p+=64; //spedisco 1024 bytes: 1024
	  }

	  detectorUnderInit=IORD(INPUT_IO_BASE,0);
	  if(detectorUnderInit!=1) {
	    break;
	  }
	}
      }
    }
    else if(entry[0] == '2') {
      printf("Waiting for Detector 2\n");

      if(dev_ptr_wr==NULL) {
	printf("Cannot Open DMA interface\n");
	break;
      }
      while(1) {
	if(alt_msgdma_construct_standard_st_to_mm_descriptor(dev_ptr_wr,a_descriptor_ptr_wr,wr_adr_p,len_wr,control_wr)!=-EINVAL) {/*printf("invalid arg\n");*/
	  status = alt_msgdma_standard_descriptor_async_transfer(dev_ptr_wr,a_descriptor_ptr_wr); //switching to async to get a speedup
	  if(status==0){
	    wr_adr_p+=64; //spedisco 1024 bytes: 1024
	  }

	  detectorUnderInit=IORD(INPUT_IO_BASE,0);
	  if(detectorUnderInit!=2) {
	    break;
	  }
	}
      }
    }

    else if(entry[0] == '3') {
      printf("Waiting for Detector 3\n");

      if(dev_ptr_wr==NULL) {
	printf("Cannot Open DMA interface\n");
	break;
      }
      while(1) {
	if(alt_msgdma_construct_standard_st_to_mm_descriptor(dev_ptr_wr,a_descriptor_ptr_wr,wr_adr_p,len_wr,control_wr)!=-EINVAL) {/*printf("invalid arg\n");*/
	  status = alt_msgdma_standard_descriptor_async_transfer(dev_ptr_wr,a_descriptor_ptr_wr); //switching to async to get a speedup

	  if(status==0){

	    wr_adr_p+=64; //spedisco 1024 bytes: 1024
	  }

	  detectorUnderInit=IORD(INPUT_IO_BASE,0);
	  if(detectorUnderInit!=3){
	    break;
	  }
	}
      }
    }

    else if(entry[0] == '4') {
      printf("Waiting for Detector 4\n");


      if(dev_ptr_wr==NULL) {
	printf("Cannot Open DMA interface\n");
	break;
      }
      while(1) {
	if(alt_msgdma_construct_standard_st_to_mm_descriptor(dev_ptr_wr,a_descriptor_ptr_wr,wr_adr_p,len_wr,control_wr)!=-EINVAL) {/*printf("invalid arg\n");*/
	  status = alt_msgdma_standard_descriptor_async_transfer(dev_ptr_wr,a_descriptor_ptr_wr); //switching to async to get a speedup
	  if(status==0){
	    wr_adr_p+=64; //spedisco 1024 bytes: 1024
	  }

	  detectorUnderInit=IORD(INPUT_IO_BASE,0);

	  if(detectorUnderInit!=4) {
	    break; 
	  }
	}
      }
    }


    else if(entry[0] == 'n') {
      break;
    }
  }



  printf("Fill complete\n");


  //Read back what I have written
  unsigned int write;

  for (unsigned int i = addressRAM0_0; i <  addressRAM0_0+0x20; i+=4)
    {
      write = IORD_32DIRECT(DDR2_RAM_BASE, i);
      printf("DETECTOR0 address: %x; octal-base: %o; data: %x\n",i,i,write);
      
    }



  printf("UDP download PORT0 to RAM success\n");

  for (unsigned int i = addressRAM0_1-0x20; i <  addressRAM0_1 + 0x20 ; i+=4)
    {
      write = IORD_32DIRECT(DDR2_RAM_BASE, i);

      printf("DETECTOR1 address: %x; octal-base: %o; data: %x\n",i,i,write);
    }

  printf("UDP download PORT1 to RAM success\n");



  for (unsigned int i = addressRAM0_2-0x20; i <  addressRAM0_2 + 0x20 ; i+=4)
    {
      write = IORD_32DIRECT(DDR2_RAM_BASE, i);

      printf("DETECTOR2 address: %x; octal-base: %o; data: %x\n",i,i,write);
    }

  printf("UDP download PORT2 to RAM success\n");


  for (unsigned int i = addressRAM1_0-0x20; i <  addressRAM1_0 + 0x20 ; i+=4)
    {
      write = IORD_32DIRECT(DDR2_RAM_1_BASE, i);

      printf("DETECTOR3 address: %x; octal-base: %o; data: %x\n",i,i,write);
    }

  printf("UDP download PORT3 to RAM success\n");


  for (unsigned int i = addressRAM1_1-0x20; i <  addressRAM1_1 + 0x20 ; i+=4)
    {
      write = IORD_32DIRECT(DDR2_RAM_1_BASE, i);

      printf("DETECTOR4 address: %x; octal-base: %o; data: %x\n",i,i,write);
    }

  printf("UDP download PORT4 to RAM success\n");



  //DEBUG://///////////////////////////////
  //int fff=0;

  //  for (unsigned int i = 0x8080-0x20; i <  0x8080+0x20/*DDR2_RAM_SPAN*/; i+=4)
  // {
  //   write = IORD_32DIRECT(DDR2_RAM_BASE, i);

  //  if(write==0x2cac6) {
  //	printf("DETECTOR0 address: %x; octal-base: %o; data: %x\n",i,i,write);
  //	write = IORD_32DIRECT(DDR2_RAM_BASE, i+4);
  //printf("DETECTOR0 address: %x; octal-base: %o; data: %x\n",i+4,i+4,write);
  //fff++;
  // }
  //if(fff==3) break;
  //}
  //printf("END");
  // return;


}
/****************************************************************/
/****************************************************************/
/****************************************************************/
int main()
{
 
  Start();

  Init();

  ///////////////////////////
  //Test RAM INITIALIZATION:
  printf("Starting RAM INIT\n");
  ///////////////////////////

  CleanRAM();
  
  SetDetectors();



  ////////////////////////////////////////////

  printf("Initializing DATA transfer to ethernet...\n");

  dev_ptr[0] = alt_msgdma_open(DMA_FIFO_SUSBYSTEM_DMA_CSR_NAME);
  dev_ptr[1] = alt_msgdma_open(DMA_FIFO_SUBSYSTEM_1_DMA_CSR_NAME);
  dev_ptr[2] = alt_msgdma_open(DMA_FIFO_SUBSYSTEM_2_DMA_CSR_NAME);
  dev_ptr[3] = alt_msgdma_open(DMA_FIFO_SUBSYSTEM_3_DMA_CSR_NAME);
   dev_ptr[4] = alt_msgdma_open(DMA_FIFO_SUBSYSTEM_4_DMA_CSR_NAME);



  //-----------------MAIN SEND LOOP AFTER THIS LINE----------------------------

  //FIRST INITIALZATION OF PrimitiveFIFO before SOB: I start with data inside.
  //1 word:256 bit => 32B.
  //32 * 4 * 2 => 32768B max transfer length
  //32 * 1024 => 32768B size of words to be sent
  
  const alt_u32 g = 4096*4*2;
  const alt_u32 gdiv4 = 1024*4*2;

  alt_u8  addr_update[ndet];
  alt_u32 ninterrupt[ndet];
  
  rd_adr_p[0] = (alt_u32 *) addressRAM0_0;
  rd_adr_p[1] = (alt_u32 *) addressRAM0_1;
  rd_adr_p[2] = (alt_u32 *) addressRAM0_2;

  rd_adr_p[3] = (alt_u32 *) addressRAM1_0;
  rd_adr_p[4] = (alt_u32 *) addressRAM1_1;

  printf("Port 0   : First init from \n ADDR: %x \tlen: %lu word: %x\n",(int)rd_adr_p[0],g,IORD_32DIRECT(DDR2_RAM_BASE,addressRAM0_0));
  printf("Port 1   : First init from \n ADDR: %x \tlen: %lu word: %x\n",(int)rd_adr_p[1],g,IORD_32DIRECT(DDR2_RAM_BASE,addressRAM0_1));
  printf("Port 2   : First init from \n ADDR: %x \tlen: %lu word: %x\n",(int)rd_adr_p[2],g,IORD_32DIRECT(DDR2_RAM_BASE,addressRAM0_2));
  printf("Port 3   : First init from \n ADDR: %x \tlen: %lu word: %x\n",(int)rd_adr_p[3],g,IORD_32DIRECT(DDR2_RAM_1_BASE,addressRAM1_0));
  printf("Port 4   : First init from \n ADDR: %x \tlen: %lu word: %x\n",(int)rd_adr_p[4],g,IORD_32DIRECT(DDR2_RAM_1_BASE,addressRAM1_1));

  alt_u32 status=0;

  //INIT DETECTORS
  for(int i = 0; i < ndet   ; ++i) {
    addr_update[i] =1;
    ninterrupt[i]  =1;
  }
  ////RAM 0
  for(int i =0; i<ndet; ++i) {
    if(alt_msgdma_construct_standard_mm_to_st_descriptor(dev_ptr[i], a_descriptor_ptr[i], rd_adr_p[i],g , control)==-EINVAL) printf("Port %d - invalid arg\n",i);
    status = alt_msgdma_standard_descriptor_async_transfer(dev_ptr[i],a_descriptor_ptr[i]);
    printf ("Port %d status: %d\n",i, (int)status);
  }

  
  printf("FIFOUSEDW0 %d\n",(int)(*FIFOUSEDW0));
  printf("FIFOUSEDW1 %d\n",(int)(*FIFOUSEDW1));
  printf("FIFOUSEDW2 %d\n",(int)(*FIFOUSEDW2));
  printf("FIFOUSEDW3 %d\n",(int)(*FIFOUSEDW3));
  printf("FIFOUSEDW4 %d\n",(int)(*FIFOUSEDW4));
  printf("POLLING %d\n",(int)(*POLLING));
  printf(" ready to start? ");

  while(1) {
    GetInputString( entry, sizeof(entry), stdin );
    printf("you wrote: %c\n",entry[0]);
    if(entry[0] == 'y') {
      break;
    }
  }


  alt_u32 SOB = alt_nticks();
  alt_u32 EOB = alt_nticks();

  printf("SOB, time: %lu \n",SOB*alt_ticks_per_second()*0.000001);

  IOWR(CTRL_SIG_BASE,0,1); //SOB

  while(!checkendburst(SOB,EOB)) {

    //if(EOB-SOB > 6.5e6) break;
    //if(checkendburst(SOB,EOB)) break;
    
    for(int i=1;i<4;++i) {
    
      if(addr_update[i]) {
	//Preparing new transer and waiting for ISR
	rd_adr_p[i] += gdiv4;
	alt_msgdma_construct_standard_mm_to_st_descriptor(dev_ptr[i], a_descriptor_ptr[i], rd_adr_p[i], g, control);
	addr_update[i] = 0;
	ninterrupt[i]+=1;
      }
      }
    
    ////////INTERRUPTS TO REFILL THE FIFOS:///////////////////////////////////////
    /* 
      if((ISR_transfer_flag&1) == 1 && addr_update[0]==0) {
      alt_msgdma_standard_descriptor_async_transfer(dev_ptr[0],a_descriptor_ptr[0]);
      addr_update[0] = 1;
      ISR_transfer_flag &= ~(1);
      }*/
    
                
      if((ISR_transfer_flag&2) == 2 && addr_update[1]==0) {
      alt_msgdma_standard_descriptor_async_transfer(dev_ptr[1],a_descriptor_ptr[1]);
      addr_update[1] = 1;
      ISR_transfer_flag &= ~(2);
      }
      
      if((ISR_transfer_flag&4) == 4 && addr_update[2]==0) {
      alt_msgdma_standard_descriptor_async_transfer(dev_ptr[2],a_descriptor_ptr[2]);
      addr_update[2] = 1;
      ISR_transfer_flag &= ~(4);
      }
    
      if((ISR_transfer_flag&8) == 8 && addr_update[3]==0) {
      alt_msgdma_standard_descriptor_async_transfer(dev_ptr[3],a_descriptor_ptr[3]);
      addr_update[3] = 1;
      ISR_transfer_flag &= ~(8);
      }
      /*      
      if((ISR_transfer_flag&16) == 16 && addr_update[4]==0) {
      alt_msgdma_standard_descriptor_async_transfer(dev_ptr[4],a_descriptor_ptr[4]);
      addr_update[4] = 1;
      ISR_transfer_flag &= ~(16);
      }*/
    
    /*
    ////////MM-POLLING TO REFILL THE FIFOS:///////////////////////////////////////    
    //CHOD:  
    //intf("POLLING %d\n",(int)(*POLLING));    
    if((*(POLLING)&1) == 1 && addr_update[0]==0) { //Primitive FIFO usedw < 0x80: send new data
      status = alt_msgdma_standard_descriptor_async_transfer(dev_ptr[0],a_descriptor_ptr[0]);
      addr_update[0] = 1;
    }
    //RICH:
    if(*(POLLING)&2 == 2 && addr_update[1]==0) { //Primitive FIFO usedw < 0x80: send new data
      status = alt_msgdma_standard_descriptor_async_transfer(dev_ptr[1],a_descriptor_ptr[1]);
      addr_update[1] = 1;
    }
    //LKr:
    if(*(POLLING)&4 ==4 && addr_update[2]==0) { //Primitive FIFO usedw < 0x80: send new data
      status = alt_msgdma_standard_descriptor_async_transfer(dev_ptr[2],a_descriptor_ptr[2]);
      addr_update[2] = 1;
    }
    //MUV3:
    if(*(POLLING)&8 == 8 && addr_update[3]==0) { //Primitive FIFO usedw < 0x80: send new data
      status = alt_msgdma_standard_descriptor_async_transfer(dev_ptr[3],a_descriptor_ptr[3]);
      addr_update[3] = 1;
    }
    //newCHOD:
    if((*POLLING)&16 ==16 && addr_update[4]==0){ //Primitive FIFO usedw < 0x80: send new data
      status = alt_msgdma_standard_descriptor_async_transfer(dev_ptr[4],a_descriptor_ptr[4]);
      addr_update[4] = 1;
    }  
    
    */

    ////////MM-REGISTERS TO REFILL THE FIFOS:///////////////////////////////////////    
    //CHOD:  
    /*
      if(*(FIFOUSEDW0)< 1024 && addr_update[0]==0) { //Primitive FIFO usedw < 0x80: send new data
      status = alt_msgdma_standard_descriptor_async_transfer(dev_ptr[1],a_descriptor_ptr[0]);
      addr_update[0] = 1;
      }
      //RICH:
      if(*(FIFOUSEDW1)< 1024 && addr_update[1]==0) { //Primitive FIFO usedw < 0x80: send new data
      status = alt_msgdma_standard_descriptor_async_transfer(dev_ptr[1],a_descriptor_ptr[1]);
      addr_update[1] = 1;
      }
      //LKr:
      if((*FIFOUSEDW2)< 1024 && addr_update[2]==0) { //Primitive FIFO usedw < 0x80: send new data
      status = alt_msgdma_standard_descriptor_async_transfer(dev_ptr[2],a_descriptor_ptr[2]);
      addr_update[2] = 1;
      }
      //MUV3:
      if((*FIFOUSEDW3)< 1024 && addr_update[3]==0) { //Primitive FIFO usedw < 0x80: send new data
      status = alt_msgdma_standard_descriptor_async_transfer(dev_ptr[3],a_descriptor_ptr[3]);
      addr_update[3] = 1;
      }
      //newCHOD:
      if((*FIFOUSEDW4)< 1024 && addr_update[4]==0){ //Primitive FIFO usedw < 0x80: send new data
      status = alt_msgdma_standard_descriptor_async_transfer(dev_ptr[4],a_descriptor_ptr[4]);
      addr_update[4] = 1;
      }
      }
    */ 
      EOB = alt_nticks();
  }
  
  IOWR(CTRL_SIG_BASE,0,0);
  
  printf("EOB sent: burst long %f seconds\n",(EOB-SOB)*alt_ticks_per_second()*0.000001);

  for(int i=0;i<ndet;++i) {
    printf("Port%d: ninterrupt: %d \n",i,(int)ninterrupt[i]);
  }
  printf("FIFOUSEDW0 %d\n",(int)(*FIFOUSEDW0));
  printf("FIFOUSEDW1 %d\n",(int)(*FIFOUSEDW1));
  printf("FIFOUSEDW2 %d\n",(int)(*FIFOUSEDW2));
  printf("FIFOUSEDW3 %d\n",(int)(*FIFOUSEDW3));
  printf("FIFOUSEDW4 %d\n",(int)(*FIFOUSEDW4));

  printf(" Would you like to reset?\n ");
  while(1) {
    GetInputString( entry, sizeof(entry), stdin );
    printf("you wrote: %c\n",entry[0]);
    if(entry[0] == 'y') {
      HAL_PLATFORM_RESET();
    }
  }
  return 0;
}


