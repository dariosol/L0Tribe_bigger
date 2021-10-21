--**************************************************************
--**************************************************************
--
-- Template file: comp_ck2.rec (new component, dual clk)
--
--**************************************************************
--**************************************************************
--
--
-- Component txport1
--
-- Array of transmission ports
--
-- - input ports: '1..NPORTS' (global param)
-- - all ports operate in fifo mode with flush/retransmit
--   capabilities    
-- - all transmission requests compete for common txframe resource: 
--   tx requests are processed by round-robin scheduler  
-- - dpram/dcfifo based clock-domain-crossing:
--   write side --> user clock domain (each port has dedicated clock domain)
--   read side  --> common tx/rx clock domain
-- - datapath range/width defined by global params: 
--   'TX_WDATA_WIDTH_MAX'   --> constant maximum width
--   'TX_WDATA_WIDTH' table --> width table (port indexed)
--   note: all ports have the same 'wdata' interface ('TX_WDATA_WIDTH_MAX' constant 
--   maximum width); each port will use a sub-section of 'wdata' according to global
--   'TX_WDATA_WIDTH' table 
--
--
-- Notes:
--
-- (edit)     --> custom description (component edit)
-- (constant) --> common description (do not modify)
--
--**************************************************************
--**************************************************************

--**************************************************************
--
--
-- Component Interface
--
--
--**************************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mac_globals.all;
use work.component_dpram1.all;
use work.component_dcfifo2.all; -- txparamfifo/txbackfifo (dual clock)
--
--use work.component_dcfifo0.all; -- txbackfifo (dual clock, single bit) 
--use work.component_dcfifo1.all; -- txwlenfifo (single clock)           
--??? da verificare se la logica si semplifica... 
--??? usare un single clock fifo come memoria slotlen e un single bit dual clock fifo per il clock domain crossing...
--

package component_txport1 is

--
-- txport1 constants (edit)
--

-- total number of input ports (global param)
constant txport1_NPORTS : natural := TX_NPORTS;
-- wdata max width (global param)
constant txport1_WDATA_WIDTH_MAX : natural := TX_WDATA_WIDTH_MAX;
-- wdata width table (global param)
constant txport1_WDATA_WIDTH : TX_WDATA_WIDTH_table_t := TX_WDATA_WIDTH;
-- note: this is the main entry point for global constants (component description uses its
-- own 'txport1_NNNNN' constants)   

--
-- txport1 typedefs (edit)
--

--
-- range/width with fixed size
--

-- wdata single/vector type
subtype txport1_wdata_t is std_logic_vector(txport1_WDATA_WIDTH_MAX - 1 downto 0);
type txport1_wdata_vector_t is array(NATURAL RANGE <>) of txport1_wdata_t;
-- note: all ports have the same 'wdata' interface ('TX_WDATA_WIDTH_MAX' constant 
-- maximum width); each port will use a sub-section of 'wdata' according to global
-- 'TX_WDATA_WIDTH' table 

-- framelen,wdlen single/vector type
subtype txport1_framelen_t is std_logic_vector(10 downto 0);
type txport1_framelen_vector_t is array(NATURAL RANGE <>) of txport1_framelen_t;

-- destport single/vector type
subtype txport1_destport_t is std_logic_vector(3 downto 0);
type txport1_destport_vector_t is array(NATURAL RANGE <>) of txport1_destport_t;

-- destaddr single/vector type
subtype txport1_destaddr_t is std_logic_vector(7 downto 0);
type txport1_destaddr_vector_t is array(NATURAL RANGE <>) of txport1_destaddr_t;

-- frames single/vector type
subtype txport1_frames_t is std_logic_vector(4 downto 0);
type txport1_frames_vector_t is array(NATURAL RANGE <>) of txport1_frames_t;

-- txseqnum single/vector type
subtype txport1_seqnum_t is std_logic_vector(31 downto 0);
type txport1_seqnum_vector_t is array(NATURAL RANGE <>) of txport1_seqnum_t;

--
-- Note: input ports use dual-clock components as clock-domain-crossing 
-- modules ('txdatabuf' is a dual-port memory working as data-frame-buffer; 
-- 'txparamfifo' works as datapath for all frame-params; 'txbackfifo' used 
-- for data-frame-buffer de-allocation).
--
-- frame-params       --> framelen(11),destport(4),destaddr(8),multicast(1)
-- txdatabuf-pointers --> wbase(12),wlen(11)
-- back-params        --> wlen(11) 
-- (each port has dedicated inputs for frame-params: txparamfifo moves 
-- all frame-params + txdatabuf wbase/wlen pointers from write to read side;
-- txbackfifo returns wlen param to write side for memory de-allocation)
--
-- Write operation:
-- 1) frame-data is loaded into 'txdatabuf' (dpram with fifo-like write interface)
-- 2) txreq asserted --> all frame-params are written into 'txparamfifo',
--                       frame is ready for transmission
--    txclr asserted --> frame-data discarded (max priority)   
-- 
-- 'txdatabuf' is 4096 bytes long (fifo contains at least two frames when datalen = 1500)
-- 'txparamfifo' is a small fifo (maxlen = 16, maxwidth = 48bit) so compiler can use MLABs:
-- StratixIII --> 320bit, max 16x20bit/MLAB (16words x 48bit : 3 MLABs) 
-- StratixIV  --> 640bit, max 32x20bit/MLAB (16words x 48bit : 3 MLABs)  
-- 
-- Note1: all fifos generated with [ADD_USEDW_MSB_BIT STRING "ON"] 
-- (usedw indicates true fifo length)
-- Note2: 'txparamfifo','txbackfifo' generated with [LPM_SHOWAHEAD STRING "ON"]
-- (rdreq works as 'ack' signal)  
--

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- txport1 inputs (edit)
--
type txport1_inputs_t is record

   -- txport1 write interface: TX_NPORTS clock domains
   wclk : std_logic_vector(1 to txport1_NPORTS);
   wrst : std_logic_vector(1 to txport1_NPORTS);

   -- txport1 read side: common tx/rx clock domain
   clk2 : std_logic;
   rst2 : std_logic;
   --
   -- NOTE: we assume all resets async asserted, sync deasserted by related clocks
   --

   -- txport1 write interface (clock domain wclk(),wrst()) 
   wena : std_logic_vector(1 to txport1_NPORTS);               
   wreq : std_logic_vector(1 to txport1_NPORTS);               
   wdata : txport1_wdata_vector_t(1 to txport1_NPORTS);        
   wframelen : txport1_framelen_vector_t(1 to txport1_NPORTS);
   wdestport : txport1_destport_vector_t(1 to txport1_NPORTS); 
   wdestaddr : txport1_destaddr_vector_t(1 to txport1_NPORTS);
   wmulticast : std_logic_vector(1 to txport1_NPORTS);
   wtxreq : std_logic_vector(1 to txport1_NPORTS);   
   wtxclr : std_logic_vector(1 to txport1_NPORTS);        
   -- 
   -- wena = 1 --> txport enable (write side enable request, txport-enabled signaled by wready = 1)
   -- wena = 0 --> txport flush (wready = 0, write-op not enabled, all loaded frames are
   --              transmitted, partially loaded frame is discarded until txport is empty)
   --   
   -- wreq = 1, wdata --> txdatabuf write request (accepted when wready = 1 and wfull = 0)
   --
   -- wframelen --> frame transmitted using framesize = wframelen (11bit, 46..1500) 
   -- wdestport --> frame transmitted using destport  = wdestport (4bit, 0..15)
   --
   -- wdestaddr, wmulticast = 0 --> unicast frame transmitted using destaddr = wdestaddr (8bit, 0..255)
   -- wdestaddr, wmulticast = 1 --> multicast frame transmitted using groupaddr = wdestaddr (8bit, groupaddr = 0..255) 
   --
   -- wtxreq = 1 --> txparamfifo write request (current frame completed, all frame-params
   --                are loaded into txparamfifo when wready = 1)
   --
   -- wtxclr = 1 --> frame will be flushed without transmission (accepted when wready = 1,
   --                this bit gives the possibility to discard current frame once loaded into txdatabuf but
   --                not yet completed)
   --                note: wtxclr has max priority --> frame data will be discarded and write request ignored
   --                                                  when (wtxreq,wtxclr) both asserted on the same clock cycle     
   --   

   -- txframe-interface (clock domain clk2, rst2)
   txportreqok : std_logic;
   txrdreq : std_logic;
   txdone : std_logic;
   --
   --
   -- txportreqok --> common input for 'transmission request accepted' (txframe driven)
   -- txrdreq     --> common input for 'txfifo-burst-read operations' (txframe driven) 
   -- txdone      --> common input for 'transmission completed' (txframe driven) 
   -- 
   -- NOTE: txframe-interface operations
   --
   -- 1) scheduler continuously checks all ports (round-robin loop) until it detects 
   --    a port ready for transmission;
   -- 2) scheduler asserts common output 'txportreq' and waits for 'txportreqok';
   -- 3) scheduler deasserts 'txportreq' when 'txportreqok' received: now txframe logic takes control;   
   -- 4) txframe logic starts txfifo-burst-read operation for current port (port is scheduler-indexed);
   -- 5) scheduler will continue when 'txdone' received (note: 'txdone' asserted when
   --    current read-request completed --> 'txdone' not overlapped with last 'txrdreq')
   -- 6) scheduler also checks/execs all received commands
   --

   -- cmdctrl-interface
   enable         : std_logic_vector(1 to txport1_NPORTS);
   ackenable      : std_logic_vector(1 to txport1_NPORTS);
   timerenable    : std_logic_vector(1 to txport1_NPORTS);
   --
   cmdseqnumclr   : std_logic_vector(1 to txport1_NPORTS);
   cmdackreceived : std_logic;
   cmdackportaddr : std_logic_vector(3 downto 0);
   cmdackseqnum   : std_logic_vector(31 downto 0);
   --
   -- enable  --> read side enable/discard request (level, cmdctrl driven)
   --             txport is enabled when both wena,enable are asserted
   --             ('enable = 0' stops transmission at the end of current frame,
   --             other loaded frames are discarded until txport is empty).  
   --
   -- ackenable      --> ackenable flags (level, cmdctrl driven)
   --                    0 --> 'datagram mode' (frame transmitted only once)
   --                    1 --> 'connection mode' (frame re-transmission until ack received)
   -- timerenable    --> txtimer enable flags (level, cmdctrl driven)
   --                    0 --> timer off (full speed transmission)
   --                    1 --> timer on  ('datagram mode': holdoff applied between transmissions) 
   --                                    ('connection mode': re-transmission holdoff applied until ack received)
   --
   -- cmdseqnumclr   --> txseqnum(index) = 0 (pulse, 1 clock, cmdctrl driven)
   --                    index = 1..NPORTS --> command applied in parallel to all selected ports
   --
   -- cmdackreceived --> txseqnum(index)++ with frame-flush when 'ackseqnum(index) = txseqnum(index)' (pulse, 1 clock, cmdctrl driven)
   --                    index = cmdackportaddr --> command applied to selected port
   -- cmdackportaddr     cmdparam ackportaddr (1..NPORTS) 
   -- cmdackseqnum       cmdparam ackseqnum   (32bit)
   --

end record;

--
-- txport1 outputs (edit)
--
type txport1_outputs_t is record

   -- write interface status (clock domain wclk(),wrst()) 
   wready : std_logic_vector(1 to txport1_NPORTS);
   wempty : std_logic_vector(1 to txport1_NPORTS); 
   wfull : std_logic_vector(1 to txport1_NPORTS); 
   werror : std_logic_vector(1 to txport1_NPORTS);
   wdatalen : txport1_framelen_vector_t(1 to txport1_NPORTS);
   wframes : txport1_frames_vector_t(1 to txport1_NPORTS);
   --
   -- wready  --> txport status (write-op enabled when wready = 1)
   -- wempty  --> txport is empty (both fifos are empty)
   -- wfull   --> txport is full (16 frames loaded or txdatabuf full) 
   -- werror  --> write op when full | write op when not ready (sticky bit, cleared when txport re-enabled)
   -- wdatalen --> current frame datalen (payload in bytes, 0..1500)
   -- wframes  --> loaded frames (txparamfifo length, 0..16)
   --

   -- write interface status (clock domain clk2, rst2)
   renable : std_logic_vector(1 to txport1_NPORTS);
   rempty : std_logic_vector(1 to txport1_NPORTS);
   rfull  : std_logic_vector(1 to txport1_NPORTS);
   rerror : std_logic_vector(1 to txport1_NPORTS);
   rframes : txport1_frames_vector_t(1 to txport1_NPORTS);
   rseqnum : txport1_seqnum_vector_t(1 to txport1_NPORTS);
   --
   -- renable --> txport status (read side)
   -- rempty  --> txport is empty (read side, both fifos are empty)
   -- rfull   --> txport is full (read side, 16 frames loaded or txdatabuf full)
   -- rerror  --> write op when full | write op when not ready (read side, 'werror' sticky bit)
   -- rframes --> loaded frames (read side, txparamfifo length, 0..16)
   -- rseqnum --> seqnum status (read side only, array 1..NPORTS of 32bit counters)
   --

   -- txframe-interface (clock domain clk2, rst2)
   txready : std_logic;
   txportreq : std_logic; 
   txportaddr : std_logic_vector(3 downto 0);
   txdatalen  : std_logic_vector(10 downto 0);
   txframelen : std_logic_vector(10 downto 0);
   txdestport : std_logic_vector(3 downto 0);
   txdestaddr : std_logic_vector(7 downto 0);
   txmulticast : std_logic;
   txdata : std_logic_vector(7 downto 0);
   txempty : std_logic;
   txseqnum : std_logic_vector(31 downto 0);
   txrdaddress : std_logic_vector(11 downto 0); 
   --
   -- txready    --> common ready flag (at least 1 port with txframe request asserted) ??? forse non serve ???
   -- txportreq  --> common request for txframe (all params are valid when asserted) 
   -- txportaddr --> param txport_address (1..15, 0 --> txframe-interface disabled/not yet scheduled) 
   -- txdatalen  --> param txport_datalen (11bit, true datalen = 0..max-payload-size)
   -- txframelen --> param txport_framelen (11bit, frame max-payload-size = 46..1500)
   -- txdestport --> param txport_destport (4bit) ??? e se arriva uno zero --> puo' servire come marker per una special frame, per il momento la txframe si limita a trasmettere txdestport senza controllare il valore...
   -- txdestaddr  --> param txport_destaddr (8bit)
   -- txmulticast --> param txport_multicast (1bit) 
   -- txdata     --> txport data (8bit)
   -- txempty    --> txport empty status (1bit)
   -- txseqnum   --> txport txseqnum (32bit)  
   -- txrdaddress --> txport rdaddress (12bit, !! Debug !!) 
   --

   -- !! Debug !!  
   txparamfifo : dcfifo2_vector_t(1 to txport1_NPORTS);
   -- !! Debug !!
   
end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- txport1 component common interface (constant)
--
type txport1_t is record
   inputs : txport1_inputs_t;
   outputs : txport1_outputs_t;
end record;

--
-- txport1 vector type (constant)
--
type txport1_vector_t is array(NATURAL RANGE <>) of txport1_t;

--
-- txport1 component declaration (constant)
--
component txport1
port (
   inputs : in txport1_inputs_t;
   outputs : out txport1_outputs_t
);
end component;

end component_txport1;

--
-- txport1 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.mac_globals.all;
use work.component_txport1.all;
use work.component_dpram1.all;
use work.component_dcfifo2.all;
use work.component_scfiforeg1.all;

-- txport1 entity (constant)
entity txport1 is
port (
   inputs : in txport1_inputs_t;
   outputs : out txport1_outputs_t
);
end txport1;

--**************************************************************
--**************************************************************

--**************************************************************
--
--
-- Component Architecture
--
--
--**************************************************************

architecture rtl of txport1 is

--**************************************************************
--
-- Architecture declaration begin 
--
--**************************************************************

--
-- local constants (edit)
--
-- constant [name] : [type] := [value];

-- input address width
--constant WADDRWIDTH_bit  : natural := (component_dpram1.inputs.wraddress'length);

-- input data width
--constant WDATAWIDTH_bit  : natural := (component_dpram1.inputs.data'length);
--constant WDATAWIDTH_byte : natural := (WDATAWIDTH_bit / 8);
-- note: input width assumed as byte multiple (8,16,32,64 bit)

-- txtimer timeout (holdoff/retransmit time interval)
-- note: 10bit timer --> max Timeout = 1024us 
constant TXTIMER_TOUT_us : natural := 1024; 

--
-- state machines (edit)
--
type FSMtxportwr_t is (S0, S1, S1_1, S2_0, S2_1, S2_2); 
-- note: simple type, clock domain wclk(index) --> [regname].wclk(index).FSMtxportwr 
type FSMtxportrd_t is (S0, S1, S2, S3, S4);   
type FSMtxportrd_vector_t is array(NATURAL RANGE <>) of FSMtxportrd_t; 
-- note: vector type, clock domain clk2 --> [regname].clk2.FSMtxportrd(index)
type FSMtxportrdena_t is (S0, S1_0, S1_1);   
type FSMtxportrdena_vector_t is array(NATURAL RANGE <>) of FSMtxportrdena_t; 
-- note: vector type, clock domain clk2 --> [regname].clk2.FSMtxportrdena(index)
type FSMtxscheduler_t is (S0, S1, S1_0, S1_1, S2); 
-- note: simple type, clock domain clk2 --> [regname].clk2.FSMtxscheduler 

--
-- local registers (edit)
--
--
-- Notes: one record-type for each clock domain
--

--
-- clock domain wclk(index)
--
type reglist_wclk_t is record

   -- FSM list
   FSMtxportwr : FSMtxportwr_t;

   -- write side enable command (send, sync from wclk to clk2)
   txportena : std_logic;

   -- write side enable command (return, sync from clk2 to wclk)
   txportenaret : std_logic;
   txportenaretI : std_logic;
   txportenaretII : std_logic;

   -- read side enable request (send, sync from clk2 to wclk)
   txportrdena : std_logic;
   txportrdenaI : std_logic;
   txportrdenaII : std_logic;

   -- read side enable request (return, sync from wclk to clk2)
   txportrdenaret : std_logic;

   -- write side error flag (send, sync from wclk to clk2)
   err_txportwrite : std_logic;

   -- error flags
   err_txdatabufwrite : std_logic;
   err_txparamfifowrite : std_logic;

   -- write counters
   baseptr : std_logic_vector(11 downto 0);
   datalen : std_logic_vector(10 downto 0);
   freelen : std_logic_vector(11+1 downto 0);

   -- end of list
   eol : std_logic;

end record;
constant reglist_wclk_default : reglist_wclk_t :=
(
   FSMtxportwr => S0,
   txportena => '0',   
   txportenaret => '0',   
   txportenaretI => '0',   
   txportenaretII => '0',   
   txportrdena => '0',
   txportrdenaI => '0',
   txportrdenaII => '0',
   txportrdenaret => '0',
   err_txportwrite => '0',
   err_txdatabufwrite => '0',
   err_txparamfifowrite => '0',
   baseptr => (others => '0'),
   datalen => (others => '0'),
   freelen => (others => '0'),

   eol => '0'
);
type reglist_wclk_vector_t is array(NATURAL RANGE <>) of reglist_wclk_t;

--
-- clock domain clk2
--
subtype txtimer_t is unsigned(10 downto 0);
type txtimer_vector_t is array(NATURAL RANGE <>) of txtimer_t; 
--
type reglist2_t is record

   -- FSM list
   FSMtxportrdena : FSMtxportrdena_vector_t(1 to txport1_NPORTS);
   FSMtxportrd : FSMtxportrd_vector_t(1 to txport1_NPORTS);
   FSMtxscheduler : FSMtxscheduler_t;

   -- write side enable command (send, sync from wclk to clk2)
   txportena : std_logic_vector(1 to txport1_NPORTS);
   txportenaI : std_logic_vector(1 to txport1_NPORTS);
   txportenaII : std_logic_vector(1 to txport1_NPORTS);

   -- write side enable command (return, sync from clk2 to wclk)
   txportenaret : std_logic_vector(1 to txport1_NPORTS);

   -- write side error flag (send, sync from wclk to clk2) .... forse non servono....
   err_txportwrite : std_logic_vector(1 to txport1_NPORTS);
   err_txportwriteI : std_logic_vector(1 to txport1_NPORTS);
   err_txportwriteII : std_logic_vector(1 to txport1_NPORTS);

   -- read side enable request (send, sync from clk2 to wclk)
   txportrdena : std_logic_vector(1 to txport1_NPORTS);

   -- read side enable request (return, sync from wclk to clk2)
   txportrdenaret : std_logic_vector(1 to txport1_NPORTS);
   txportrdenaretI : std_logic_vector(1 to txport1_NPORTS);
   txportrdenaretII : std_logic_vector(1 to txport1_NPORTS);

   -- txframe-interface regs
   txpointer : unsigned(3 downto 0);
   txportreq : std_logic;
   rdaddress : std_logic_vector(11 downto 0);
   rddatalen : std_logic_vector(10 downto 0);
   rdempty : std_logic;
   dpramready : std_logic;
   dpramreadI : std_logic;

   -- txseqnum array
   txseqnum : txport1_seqnum_vector_t(1 to txport1_NPORTS);

   -- txtimer regs
   prescaler : std_logic_vector(7 downto 0);
   txtimer : txtimer_vector_t(1 to txport1_NPORTS);

   -- command regs (single register input fifos) 
   cmdseqnumclr   : std_logic_vector(1 to txport1_NPORTS);
   cmdackreceived : std_logic;
   cmdackportaddr : std_logic_vector(3 downto 0);
   cmdackseqnum   : std_logic_vector(31 downto 0);

   -- end of list
   eol : std_logic;

end record;
constant reglist2_default : reglist2_t :=
(
   FSMtxportrdena => (others => S0),
   FSMtxportrd => (others => S0),
   FSMtxscheduler => S0,
   txportena => (others => '0'),
   txportenaI => (others => '0'),
   txportenaII => (others => '0'),
   txportenaret => (others => '0'),
   err_txportwrite => (others => '0'),
   err_txportwriteI => (others => '0'),
   err_txportwriteII => (others => '0'),
   txportrdena => (others => '0'),
   txportrdenaret => (others => '0'),
   txportrdenaretI => (others => '0'),
   txportrdenaretII => (others => '0'),
   txpointer => (others => '0'),
   txportreq => '0',
   rdaddress => (others => '0'),
   rddatalen => (others => '0'),
   rdempty => '0',
   dpramready => '0',
   dpramreadI => '0',
   txseqnum => (others => SLV(0, 32)),
   prescaler => (others => '0'),
   txtimer => (others => SLV(0, 10+1)),
   cmdseqnumclr => (others => '0'),
   cmdackreceived => '0',
   cmdackportaddr => (others => '0'),
   cmdackseqnum => (others => '0'),

   eol => '0'
);

--
-- all local registers (edit)
--
-- Notes: one record-element for each clock domain
--
type reglist_t is record
   wclk : reglist_wclk_vector_t(1 to txport1_NPORTS); -- wclk array
   clk2 : reglist2_t;                                 
end record;

--
-- all local nets (edit)
--
type netlist_t is record

   -- write-side nets

   -- empty/full flags
   txdatabufwrfull : std_logic_vector(1 to txport1_NPORTS);
   txdatabufwrempty : std_logic_vector(1 to txport1_NPORTS);

   -- read-side nets

   -- flush/discard signals distributed to all ports
   frame_flush   : std_logic_vector(1 to txport1_NPORTS);
   frame_discard : std_logic_vector(1 to txport1_NPORTS);
   
   -- txpointer control
   txpointer_load : std_logic;
   txpointer_inc : std_logic;

   -- rdpointer control
   rdpointer_init : std_logic;
   rdpointer_inc : std_logic;

   -- txtimer control
   txtimer_start : std_logic_vector(1 to txport1_NPORTS);
   txtimer_stop  : std_logic_vector(1 to txport1_NPORTS);
   txtimer : std_logic_vector(1 to txport1_NPORTS);

   -- seqnum control
   txseqnum_clr : std_logic_vector(1 to txport1_NPORTS);
   txseqnum_inc : std_logic_vector(1 to txport1_NPORTS);

   --
   -- component interface signals (edit)
   --
   -- [instance_name] : [component_name]_t;
   --
   txdatabuf   : dpram1_vector_t(1 to txport1_NPORTS);
   txparamfifo : dcfifo2_vector_t(1 to txport1_NPORTS);
   txbackfifo  : dcfifo2_vector_t(1 to txport1_NPORTS);
   txfifo      : scfiforeg1_t;

end record;

--**************************************************************
--
-- Architecture declaration end 
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- inputs/outputs record-type alias (constant)

--
subtype inputs_t is txport1_inputs_t;
subtype outputs_t is txport1_outputs_t;

--
-- all local registers (constant)
--
type allregs_t is record
   din : reglist_t;
   dout : reglist_t;
end record;
signal allregs : allregs_t;

--
-- all local nets (constant)
--
signal allnets : netlist_t;
signal allcmps : netlist_t;

--
-- outputs driver (internal signal for read access) (constant)
--
signal allouts : outputs_t;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- architecture rtl of txport1
--
--**************************************************************
begin

--**************************************************************
--
-- components instances (edit)
--
--**************************************************************

--[instance/label_name] : [component_name] port map
--(
--   inputs => allnets.[instance_name].inputs,
--   outputs => allcmps.[instance_name].outputs
--);

L1 : FOR i IN 1 to txport1_NPORTS GENERATE

txdatabuf : dpram1 
generic map
(
   WDATA_WIDTH => txport1_WDATA_WIDTH(i)
)
port map
(
   inputs => allnets.txdatabuf(i).inputs,
   outputs => allcmps.txdatabuf(i).outputs
);

txparamfifo : dcfifo2 port map
(
   inputs => allnets.txparamfifo(i).inputs,
   outputs => allcmps.txparamfifo(i).outputs
);

txbackfifo : dcfifo2 port map
(
   inputs => allnets.txbackfifo(i).inputs,
   outputs => allcmps.txbackfifo(i).outputs
);

END GENERATE;

txfifo : scfiforeg1 port map
(
   inputs => allnets.txfifo.inputs,
   outputs => allcmps.txfifo.outputs
);

--**************************************************************
--
-- sequential logic
--
--
-- Notes: one record-type for each clock domain
--
--**************************************************************

--
-- clock domain: wclk,wrst (edit)
--
process_wclk : FOR i IN inputs.wclk'range GENERATE

process (inputs.wclk(i), inputs.wrst(i))
begin
   if (inputs.wrst(i) = '1') then
      allregs.dout.wclk(i) <= reglist_wclk_default;
   elsif rising_edge(inputs.wclk(i)) then
      allregs.dout.wclk(i) <= allregs.din.wclk(i);
   end if;
end process;

END GENERATE;

--
-- clock domain: clk2,rst2 (edit)
--
process (inputs.clk2, inputs.rst2)
begin
   if (inputs.rst2 = '1') then
      allregs.dout.clk2 <= reglist2_default;
   elsif rising_edge(inputs.clk2) then
      allregs.dout.clk2 <= allregs.din.clk2;
   end if;
end process;

--**************************************************************
--
-- combinatorial logic
--
--
-- Notes: single process with combinatorial procedures.
--
--**************************************************************

process (inputs, allouts, allregs, allnets, allcmps)

--**************************************************************
--
-- Combinatorial description begin
--
--**************************************************************

--
-- FSMtxportrdena combinatorial procedure (edit)
--
-- clock domain: clk2
--
procedure SubFSMtxportrdena
(
   variable i : in inputs_t;
   variable ri: in reglist2_t;
   variable ro: in reglist2_t;
   variable o : inout outputs_t;
   variable r : inout reglist2_t;
   variable n : inout netlist_t
) is
begin

FOR index IN 1 TO txport1_NPORTS LOOP

   --
   -- 'txportrdena' round-trip logic   
   --
   -- read-side 'enable' requests are transmitted to write-side where are merged 
   -- with 'wena' inputs --> main control logic located to the txport write-side
   --
   -- note: round-trip logic always ON 
   --
   case ro.FSMtxportrdena(index) is
   when S0 =>
      --
      -- reset state
      --
      r.FSMtxportrdena(index) := S1_0;

   when S1_0 =>
      --
      -- not-enable request in progress
      --MODIFICATO
      r.txportrdena(index) := '1';
      if ro.txportrdenaret(index) = '0' then
         -- 'txportrdena' negedge round-trip completed
         if i.enable(index) = '1' then
            -- read side enable request   
            r.txportrdena(index) := '1';
            r.FSMtxportrdena(index) := S1_1;
         end if;
      else
         -- 'txportrdena' negedge round-trip in progress
         null;
      end if;
      -- note: this is a blocking state, i.enable ignored until negedge round-trip
      -- completed because we must not inject single clock pulses into clock-crossing logic  

   when S1_1 =>
      --
      -- enable request in progress 
      --
      r.txportrdena(index) := '1';
      if ro.txportrdenaret(index) = '1' then
         -- 'txportrdena' posedge round-trip completed
         if i.enable(index) = '0' then 
            -- read side not-enabled request
            r.txportrdena(index) := '1';
            r.FSMtxportrdena(index) := S1_0;
         end if;
      else
         -- 'txportrdena' posedge round-trip in progress
         null;
      end if;
      -- note: this is a blocking state, i.enable ignored until posedge round-trip
      -- completed because we must not inject single clock pulses into clock-crossing logic  

   end case;
   
END LOOP;

end procedure;


--
-- FSMtxportrd combinatorial procedure (edit)
--
-- clock domain: clk2
--
procedure SubFSMtxportrd
(
   variable i : in inputs_t;
   variable ri: in reglist2_t;
   variable ro: in reglist2_t;
   variable o : inout outputs_t;
   variable r : inout reglist2_t;
   variable n : inout netlist_t
) is
begin

FOR index IN 1 TO txport1_NPORTS LOOP

   --
   -- txport read control 
   --
   -- txport enabled     --> standard tx request (txparamfifo contains one param-word per frame)
   -- txport not enabled --> discard op until txparamfifo/txbackfifo both empty 
   --

   -- defaults (read side, clock domain clk2)
   n.txdatabuf(index).inputs.rdclock := i.clk2;
   n.txdatabuf(index).inputs.rdaddress := ro.rdaddress;
   -- note: rdaddress bus controlled by single read-pointer (not indexed) 
   --
   n.txparamfifo(index).inputs.rdclk := i.clk2;
   n.txparamfifo(index).inputs.rdreq := '0';
   -- 
   n.txbackfifo(index).inputs.aclr  := i.rst2;
   n.txbackfifo(index).inputs.wrclk := i.clk2;
   n.txbackfifo(index).inputs.wrreq := '0';
   n.txbackfifo(index).inputs.data  := (others => '0');

   case ro.FSMtxportrd(index) is
   when S0 =>
      --
      -- reset state
      --
      r.FSMtxportrd(index) := S4; 
      -- note: we start with cleanup operation, FSMtxportrd will move to S1 when txport enabled

   when S1 =>
      --
      -- idle state: txframe/discard test (note: txport assumed enabled, txportenaret unchanged)
      --
      if ro.txportena(index) = '0' then
         -- txport not enabled --> discard operation (fifos cleanup without txframe)
         r.FSMtxportrd(index) := S4;
      elsif n.txparamfifo(index).outputs.rdempty = '0' then
          -- txport enabled, txparamfifo not empty: txframe request
         r.FSMtxportrd(index) := S2;
         -- note: 'showahead' fifo --> q output is ready when not empty 
      else
         -- txparamfifo empty: nop
         null;
      end if;
      --
      -- note: txportena round-trip is used to notify current read-side status to write-side 
      --
      -- txportena = 0 --> discard operation starts but write-side will see
      --                   txportenaret = 0 only when operation done (S4, round-trip closed)
      -- txportena = 1 --> txport enabled, write-side will see txportenaret = 1 (txportenaret unchanged, round-trip open)  
      --

   when S2 =>
      --
      -- txframe request ('S2' --> txframe request until frame done)
      --
      if n.frame_discard(index) = '1' then
         -- to discard operation
         r.FSMtxportrd(index) := S4;
      elsif n.frame_flush(index) = '1' then
         -- to flush operation
         r.FSMtxportrd(index) := S3;
      else
         -- txframe request in progress
         null;
      end if;
      -- note: S2 is a blocking state, exit from S2 controlled by signals 'frame_flush','frame_discard'
      -- (scheduler takes control: scheduler asserts 'frame_flush' when cmdackreceived 
      -- or 'frame_discard' when current port not enabled)
      
   when S3 =>
      --
      -- flush operation
      --
      if n.txparamfifo(index).outputs.rdempty = '0' then
         -- current frame will be de-allocated
         if n.txbackfifo(index).outputs.wrfull = '0' then
            -- txbackfifo not full: frame-length will return back to write logic to
            -- free allocated memory space 
            n.txbackfifo(index).inputs.wrreq := '1';
            n.txbackfifo(index).inputs.data(10 downto 0) := n.txparamfifo(index).outputs.q(10+36 downto 0+36);
            -- frame-params discarded
            n.txparamfifo(index).inputs.rdreq := '1';
            -- restart
            r.FSMtxportrd(index) := S1;
         else
            -- txbackfifo full: write-side memory de-allocation in progress, waiting for txbackfifo free space
            null;
            -- note: S3 is a blocking state until frame flush operation completely done
         end if;
      else
         -- txparamfifo is empty: nothing to do, restart
         r.FSMtxportrd(index) := S1;         
         -- note: this condition should never appear, state S3 should always see txparamfifo 
         -- not empty... 
      end if;

   when S4 =>
      --
      -- discard operation (txparamfifo cleanup without txframe)
      -- 

      -- txparamfifo continuously flushed
      if n.txparamfifo(index).outputs.rdempty = '0' then
         n.txparamfifo(index).inputs.rdreq := '1';
      end if;
      
      if n.txbackfifo(index).outputs.wrempty = '0' then
         -- txbackfifo not empty: waiting for write-side memory de-allocation
         null;
      else 
         -- txportena level will return back to write-side to notify 'discard operation done' (round-trip closed)    
         r.txportenaret(index) := ro.txportena(index);
         -- waiting for txport enable command 
         if ro.txportena(index) = '1' then 
            -- txport re-enabled: to idle state 
            r.FSMtxportrd(index) := S1;
         end if;
      end if;
      --
      -- note: S4 is a blocking state --> txparamfifo continuously flushed, txbackfifo empty condition notified to write-side
      --                                  by txportena round-trip, exit from S4 with 'txportenaret' asserted 
      --
      -- note1: dcfifo sync-logic may set read side 'rdempty' flag when fifo is not really empty
      --        (or set write side 'wrfull' flag when fifo is not really full) --> to avoid false empty detection 
      --        we do not use txparamfifo.rdempty = 1 as 'discard operation done' indicator,
      --        only 'wrempty = 1' means fifo really empty so write-side checks txparamfifo, read-side checks txbackfifo and signals
      --        empty condition to write-side using txportena round-trip-path.         
      --        txport write operations will restart when both fifos are empty and 'txportena' posedge 
      --        round-trip completed (this ensures txportena posedge recognized by read side logic before any write op)

   end case;

   -- txport read-status
   o.renable(index) := ro.txportena(index);
   o.rempty(index)  := n.txparamfifo(index).outputs.rdempty;
   o.rfull(index)   := n.txparamfifo(index).outputs.rdfull;
   o.rerror(index)  := ro.err_txportwrite(index); -- NOTE: sticky bit, write side controlled

   -- txport read-level
   o.rframes(index) := n.txparamfifo(index).outputs.rdusedw;

END LOOP;

end procedure;


--
-- Cmdinterface combinatorial procedure (edit)
--
-- clock domain: clk2
--
procedure SubCmdInterface
(
   variable i : in inputs_t;
   variable ri: in reglist2_t;
   variable ro: in reglist2_t;
   variable o : inout outputs_t;
   variable r : inout reglist2_t;
   variable n : inout netlist_t
) is
begin

   --
   -- Cmd-Interface: commands are latched by single register input fifos (always ON)    
   --
   if ro.cmdackreceived = '0' and i.cmdackreceived = '1' then 
      -- cmd latched
      r.cmdackportaddr := i.cmdackportaddr;
      r.cmdackseqnum   := i.cmdackseqnum;
      r.cmdackreceived := '1';
   end if;
   --
   FOR index IN 1 TO txport1_NPORTS LOOP
      if ro.cmdseqnumclr(index) = '0' and i.cmdseqnumclr(index) = '1' then 
         -- cmd latched
         r.cmdseqnumclr(index) := '1';
      end if;
   END LOOP;
   -- note: flags are checked/reset by scheduler logic; command requests ignored
   -- when fifo-register is full

end procedure;


--
-- FSMtxscheduler combinatorial procedure (edit)
--
-- clock domain: clk2
--
procedure SubFSMtxscheduler
(
   variable i : in inputs_t;
   variable ri: in reglist2_t;
   variable ro: in reglist2_t;
   variable o : inout outputs_t;
   variable r : inout reglist2_t;
   variable n : inout netlist_t
) is
begin

   --
   -- Round-robin scheduler
   --

   -- output txfifo for burst-read operations (defaults)
   n.txfifo.inputs.clock := i.clk2;
   n.txfifo.inputs.aclr  := i.rst2;
   n.txfifo.inputs.rdreq := '0';
   n.txfifo.inputs.sclr  := '0';
   n.txfifo.inputs.wrreq := '0';
   --
   n.txfifo.inputs.data  := "00000000";
   if UINT(ro.txpointer) >= 1 and UINT(ro.txpointer) <= txport1_NPORTS then
      n.txfifo.inputs.data := n.txdatabuf(UINT(ro.txpointer)).outputs.q(7 downto 0);
      -- note: output txfifo gets data from txdatabuf array (ro.txpointer indexed)
   end if;
   -- defaults
   n.txpointer_load := '0';
   n.txpointer_inc  := '0';
   --
   n.rdpointer_init := '0';
   n.rdpointer_inc  := '0';

   -- txframe-interface: port index to output
   o.txportaddr := SLV(ro.txpointer, ro.txpointer'length); -- note: sizes must match

   -- txframe-interface: output mux (ro.txpointer indexed)
   o.txdata      := n.txfifo.outputs.q(7 downto 0);      
   --
   o.txframelen  := (others => '0');
   o.txdestport  := (others => '0'); 
   o.txdestaddr  := (others => '0'); 
   o.txmulticast := '0';
   o.txrdaddress := (others => '0'); 
   o.txdatalen   := (others => '0'); 
   o.txseqnum    := (others => '0');
   if UINT(ro.txpointer) >= 1 and UINT(ro.txpointer) <= txport1_NPORTS then
      o.txframelen  := n.txparamfifo(UINT(ro.txpointer)).outputs.q(10 downto  0);
      o.txdestport  := n.txparamfifo(UINT(ro.txpointer)).outputs.q(14 downto 11); 
      o.txdestaddr  := n.txparamfifo(UINT(ro.txpointer)).outputs.q(22 downto 15);
      o.txmulticast := n.txparamfifo(UINT(ro.txpointer)).outputs.q(23); 
      o.txrdaddress := n.txparamfifo(UINT(ro.txpointer)).outputs.q(11+24 downto 0+24); -- ??? forse non serve....solo per debug
      o.txdatalen   := n.txparamfifo(UINT(ro.txpointer)).outputs.q(10+36 downto 0+36);
      --
      o.txseqnum    := ro.txseqnum(UINT(ro.txpointer));
      --
   end if;
   o.txempty := '1';
   -- note: txframe-interface defaults to empty (output data available only when scheduled) 

   -- indexed defaults
   FOR index IN 1 TO txport1_NPORTS LOOP
      n.frame_flush(index)   := '0';
      n.frame_discard(index) := '0';
      n.txtimer_start(index) := '0';
      n.txtimer_stop(index)  := '0';
      n.txseqnum_clr(index)  := '0';
      n.txseqnum_inc(index)  := '0';
   END LOOP;

   case ro.FSMtxscheduler is
   when S0 =>
      --
      -- reset state
      --
      n.txpointer_load := '1';
      r.FSMtxscheduler := S1;

   when S1 =>
      --
      -- command exec (applied to all ports before scheduler takes control)
      --
      FOR index IN 1 TO txport1_NPORTS LOOP

         --
         -- cmd ackreceived
         --
         if ro.cmdackreceived = '1' and index = UINT(ro.cmdackportaddr) then
            -- cmd flag cleared
            r.cmdackreceived := '0'; 
            if i.ackenable(index) = '1' and ro.txportena(index) = '1' and ro.FSMtxportrd(index) = S2 then
               -- ackmode enabled, txport enabled, txframe request in progress: ack test
               if SLV(ro.txseqnum(index)) = SLV(ro.cmdackseqnum) then
                  -- ack aligned: txseqnum++
                  n.txseqnum_inc(index) := '1';
                  -- current frame flushed 
                  n.frame_flush(index) := '1';
                  -- holdoff stops: port can start a new transmission without additional delay
                  n.txtimer_stop(index) := '1';
               else
                  -- ack not aligned: nop
                  null;
               end if;
            else
               -- ackmode|txport|txframe not enabled: ackreceived ignored
               null;
            end if;                    
         end if;
         -- note: 'cmdackreceived' is the result of external cmdctrl test logic (connected node#/port# verified), 
         --       command must be completed by txseqnum test (scheduler filter-out any duplicated/wrong ack request,
         --       txseqnum is incremented only when received ack aligned)    

         --
         -- cmd seqnumclr
         --
         if ro.cmdseqnumclr(index) = '1' then
            -- cmd flag cleared
            r.cmdseqnumclr(index) := '0'; 
            -- txseqnum zero
            n.txseqnum_clr(index) := '1';
         end if;
         -- note: cmdseqnumclr always ON (txportena not tested)
     
      END LOOP;
      --
      r.FSMtxscheduler := S1_0;

   when S1_0 =>
      --
      -- init state (wait txframe request with round-robin)
      --
      r.txportreq := '0';
      if ro.FSMtxportrd(UINT(ro.txpointer)) = S2 and n.txtimer(UINT(ro.txpointer)) = '0' then
         -- tx request detected, re-transmit timer off: common txportreq asserted
         r.txportreq := '1';
         -- common read-pointer initialized, txfifo cleared
         n.rdpointer_init := '1';
         n.txfifo.inputs.sclr := '1';
         r.FSMtxscheduler := S1_1;
      else
         -- tx request not asserted | holdoff in progress: scheduler moves to next port
         n.txpointer_inc := '1';
         r.FSMtxscheduler := S1; -- !!!!! attenzione: ping pong S1,S1_0 !!!!!      
      end if;
      -- note: assuming 'txpointer' in range 1..NPORTS (compiler is free to optimize
      -- indexing logic when pointer out of range) 
      --??? forse e' meglio indicare cosa fare quando index-out-of-range ???

   when S1_1 =>
      --
      -- txframe request in progress ('txportreq' asserted)
      --
      if i.txportreqok = '1' then 
         -- request accepted --> txframe request removed
         r.txportreq := '0';
         r.FSMtxscheduler := S2; ---....occorre attendere il txfifo not empty quando ci sono dati ???? oppure si lascia alla txframe il compito di controllare la txdatalen e la txempty????
      elsif ro.txportena(UINT(ro.txpointer)) = '0' then
         -- request not yet accepted, txport not enabled: txframe request removed  
         r.txportreq := '0';
         -- forced cleanup (this unlocks FSMtxportrd blocked into S2 state)
         n.frame_discard(UINT(ro.txpointer)) := '1';
         r.FSMtxscheduler := S1;
         -- note: when txframe module is ready to process a new frame, it waits for 'ro.txportreq = 1' 
         -- and immediately asserts 'i.txportreqok' (same clock cycle, unregistered ack).
      else
         -- wait
         null;
      end if;
      --
      -- note: this is a blocking state --> scheduler will wait for txframe resource or 
      -- cleanup request. When txframe not enabled 'i.txportreqok' never asserted and only 
      -- cleanup request can unlock current port.
      -- Scheduler forces 'frame_discard = 1' when 'txportena = 0': this unlocks FSMtxportrd blocked
      -- into S2 state, FSMtxportread will exec a cleanup operation (S4)
      --
      -- note1: we do not test 'txportrdena = 0' because we have to wait for standard cleanup request 
      -- (write side is the master controller, it chooses between txframe/flush/discard operations; 
      -- read side is just a slave executing txframe/discard requests).  
      --
      -- .....lo scheduler controlla la linea txportena non per il possibile blocco della txframe ma
      -- perche' potrebbe arrivare in ogni momento una cleanup request e se la txframe non e' ancora 
      -- stata attivata si sblocca subito la FSMread in S2;
      -- se la txframe e' gia' in progress si assume che prima o poi arrivera' un txdone = 1 mentre in caso di
      -- txframe non ancora attivata e' possibile rimuovere la richiesta e permettere alla FSMread di fare 
      -- la cleanup.....
      --     

      -- rdempty,rdaddress are valid: txdatabuf-read/txfifo-write can start
      if ro.dpramready = '1' and n.txfifo.outputs.full = '0' then
         -- txdatabuf output is ready, txfifo not full: txfifo write op
         n.txfifo.inputs.wrreq := '1';
      end if;
      if ro.rdempty = '1' then
         -- txdatabuf is empty: nop
         null;
      elsif n.txfifo.outputs.empty = '1' then
         -- txdatabuf not empty, txfifo is empty: output fifo can accept all data from 
         -- dpram-read-pipeline --> 'n.rdpointer_inc' continuously asserted
         n.rdpointer_inc := '1';
      else
         -- data walking through dpram-read-pipeline will move into the fifo, dpram address unchanged
         null;
      end if;
      -- note: txdatabuf-read/txfifo-write logic is enabled when txframe request 
      -- in progress --> this allows a gain of some clock cycles so burst-read can 
      -- start immediately when txframe takes control
      -- (...in realta' questa logica non e' indispensabile perche' quando la txframe
      -- processera' i dati saranno passati almeno 14 cicli di clock e il txfifo
      -- sara' sicuramente pronto...la logica e' stata inserita prevedendo la
      -- possibilita' di lavorare con un fifo-esterno che applica una burst-read immediata...)  

   when S2 =>
      --
      -- txframe in progress
      --

      -- txfifo empty flag to output
      o.txempty := n.txfifo.outputs.empty;
      -- note: txfifo works as elastic-buffer to guarantee full speed burst-read operations
      -- (external txframe module can pause/restart sequential data-read process without dpram 
      -- read latencies)
      -- note1: output txfifo is a showahead fifo (rdreq works as 'ack')      

      -- txframe-interface: txfifo read logic
      if i.txrdreq = '1' and n.txfifo.outputs.empty = '0' then
         -- read request accepted (show-ahead fifo, rdreq works as ack)
         n.txfifo.inputs.rdreq := '1';
      else
         -- rdreq not asserted | txfifo empty --> nop
         null;
      end if;

      -- txframe-interface: txfifo write logic
      if ro.dpramready = '1' and n.txfifo.outputs.full = '0' then
         -- txdatabuf output is ready, txfifo not full: txfifo write op
         n.txfifo.inputs.wrreq := '1';
      end if;
      if ro.rdempty = '1' then
         -- txdatabuf is empty: nop
         null;
      elsif n.txfifo.outputs.empty = '1' then
         -- txdatabuf not empty, txfifo is empty: output fifo can accept all data from 
         -- dpram-read-pipeline --> 'n.rdpointer_inc' continuously asserted
         n.rdpointer_inc := '1';
      else
         -- txdatabuf not empty, txfifo not empty: dpram-read controlled by fifo-read-request 
         -- (output fifo absorbs dpram read-latency when fifo-read pause/restart --> fifo is always not empty, 
         -- full speed burst-read guaranteed)    
         if n.txfifo.inputs.rdreq = '1' then        
            -- current fifo-read-request will consume one fifo word --> new dpram-read can start
            -- because there is free space to accept next data      
            n.rdpointer_inc := '1';
         else
            -- fifo-read-request stops: data walking through dpram-read-pipeline will move 
            -- into the fifo, dpram address unchanged
            null;
         end if;
      end if;

      if i.txdone = '1' then
         -- txframe completed: holdoff timer starts
         n.txtimer_start(UINT(ro.txpointer)) := '1';
         -- txseqnum++
         if i.ackenable(UINT(ro.txpointer)) = '0' then
            -- txseqnum++ (datagram mode)
            n.txseqnum_inc(UINT(ro.txpointer)) := '1';
            -- current frame flushed 
            n.frame_flush(UINT(ro.txpointer)) := '1';
         else
            -- txseqnum++/flush controlled by cmdack logic (connection mode) 
            null;
         end if; 
         -- txframe done: scheduler moves to next port
         n.txpointer_inc := '1';
         r.FSMtxscheduler := S1;
      else
         -- txframe in progress
         null;
      end if;
      --
      -- note: this is a blocking state --> once started txframe will always end with 'txdone' asserted 
      --      

   end case;
 
   -- txportreq to output
   o.txportreq := ro.txportreq;

   -- scheduler txpointer logic (ptr = 1..NPORTS)
   if n.txpointer_load = '1' then
      r.txpointer := SLV(1, r.txpointer);
   elsif n.txpointer_inc = '1' then
      if ro.txpointer >= txport1_NPORTS then
         r.txpointer := SLV(1, r.txpointer);
      else
         r.txpointer := ro.txpointer + 1;
      end if; 
   end if;

   -- txdatabuf read-pointer logic
   if n.rdpointer_init = '1' then
      r.rdaddress := n.txparamfifo(UINT(ro.txpointer)).outputs.q(11+24 downto 0+24); -- baseptr 
      r.rddatalen := n.txparamfifo(UINT(ro.txpointer)).outputs.q(10+36 downto 0+36); -- datalen       
   elsif n.rdpointer_inc = '1' then
      -- rdptr++
      r.rdaddress := SLV(UINT(ro.rdaddress) + 1, r.rdaddress);  
      -- datalen--
      r.rddatalen := SLV(UINT(ro.rddatalen) - 1, r.rddatalen);
   end if;    
   -- txdatabuf rdempty flag calculated with current rddatalen (note: r.NNNNNN)
   if UINT(r.rddatalen) = 0 then
      r.rdempty := '1';
   else
      r.rdempty := '0';
   end if;
   
   -- txdatabuf dpram-read logic
   if n.rdpointer_init = '1' then 
      -- new read address: dpram read-latency-chain cleared
      r.dpramready   := '0';
      r.dpramreadI   := '0';
   else
      -- dpram read-latency-chain always ON (dpram read-op takes 2 clocks)
      --
      -- dpramreadI --> dpram read in progress (clock1)
      -- dpramready --> dpram q valid          (clock2)
      --
      r.dpramready := ro.dpramreadI; 

      -- read-request test 
      r.dpramreadI := '0';
      if n.rdpointer_inc = '1' then
         -- next address request: read operation for current address starts    
         r.dpramreadI := '1';
      end if; 
   end if;
   
   --
   -- txseqnum logic
   --
   -- note: one txseqnum counter for each txport 
   --
   FOR index IN 1 TO txport1_NPORTS LOOP
      if n.txseqnum_clr(index) = '1' then
         r.txseqnum(index) := SLV(0, 32);
      elsif n.txseqnum_inc(index) = '1' then
         r.txseqnum(index) := SLV(SLV(ro.txseqnum(index)) + 1, 32); -- unsigned++                          
      end if;
      -- txseqnum to output
      o.rseqnum(index) := ro.txseqnum(index);
   END LOOP;

   --
   -- holdoff-timer clock prescaler (1MHz, common resource for all txports, always ON)
   --
   -- note: 7bit prescaler --> clock divisor = CLOCK_FREQ_MHz
   --       (fclk = 125MHz --> ftimer = fclk / CLOCK_FREQ_MHz = 1MHz)
   --
   if ro.prescaler(7) = '1' then
      -- reload
      r.prescaler := SLV(128-(CLOCK_FREQ_MHz-1), r.prescaler);
      -- note: reload op consumes one clock, reload uses 'CLOCK_FREQ_MHz-1'
   else
      -- prescaler++
      r.prescaler := SLV(UINT(r.prescaler) + 1, r.prescaler);
   end if;
    
   --
   -- holdoff-timer logic (one txtimer counter for each port)
   --
   -- note: 10bit timer --> max Timeout = 1024 * Tclock   
   --       (Tclock = 1us --> max Timeout = 1024us --> 1kHz)
   --
   FOR index IN 1 TO txport1_NPORTS LOOP
      if i.timerenable(index) = '0' or n.txtimer_stop(index) = '1' then
         -- timer not enabled | stop request --> forced zero (timer OFF) 
         r.txtimer(index) := SLV(0, r.txtimer(index));
         -- note: timer not enabled --> 'txtimer_start' ignored
      else
         -- timer enabled
         if n.txtimer_start(index) = '1' then
            -- timer ON: holdoff starts (msb = 1)
            r.txtimer(index) := SLV(2*1024-TXTIMER_TOUT_us, r.txtimer(index));      
         elsif ro.txtimer(index)(10) = '0' then
            -- holdoff done: msb = 0, timer stops
            null;
         elsif ro.prescaler(7) = '1' then
            -- txtimer++
            r.txtimer(index) := SLV(UINT(ro.txtimer(index)) + 1, r.txtimer(index));
         end if;
      end if;
      -- run bit
      n.txtimer(index) := ro.txtimer(index)(10); 
   END LOOP;

   -- common ready flag (at least 1 port with txframe request asserted) .... forse non serve....
   o.txready := '0';
   FOR index IN 1 TO txport1_NPORTS LOOP
      if ro.FSMtxportrd(index) = S2 then
         -- indexed port is ready (txframe request asserted) 
         o.txready := '1'; 
      end if;
   END LOOP;

end procedure;


--
-- FSMtxportwr combinatorial procedure (edit)
--
-- clock domain: all clocks
--
procedure SubFSMtxportwr
(
   variable i : in inputs_t;
   variable ri: in reglist_t;
   variable ro: in reglist_t;
   variable o : inout outputs_t;
   variable r : inout reglist_t;
   variable n : inout netlist_t
) is
begin

--NOTA NOTA NOTA
--............ --> l'unico segnale di stato di ogni txport diventa txportena, 'i.enable' lato read e' solo una richiesta che
--                 viene processata dalla write side insieme alla wena
--                 write side: master controller
--                 read side: slave executer 
--

FOR index IN 1 TO txport1_NPORTS LOOP

   -- txdatabuf defaults (write side, clock domain wclk(index))
   n.txdatabuf(index).inputs.wren    := '0';
   n.txdatabuf(index).inputs.wrclock := i.wclk(index);
   --n.txdatabuf(index).inputs.aclr  := i.wrst(index); -- ...la dpram non ha l'ingresso aclr...
   n.txdatabuf(index).inputs.data    := i.wdata(index);
   --n.txdatabuf(index).inputs.wraddress := SLV((UINT(ro.wclk(index).baseptr) + UINT(ro.wclk(index).datalen)) / WDATAWIDTH_byte, WADDRWIDTH_bit); -- ??? usare un registro dedicato ???
   n.txdatabuf(index).inputs.wraddress := SLV((UINT(ro.wclk(index).baseptr) + UINT(ro.wclk(index).datalen)) / (txport1_WDATA_WIDTH(index) / 8), 12); -- ??? usare un registro dedicato ???
   -- note: 11bit datalen --> max frame slot length = 2047, address range = baseptr + (0..2046)

   -- txparamfifo defaults (write side, clock domain wclk(index))
   n.txparamfifo(index).inputs.wrreq := '0';
   n.txparamfifo(index).inputs.wrclk := i.wclk(index);
   n.txparamfifo(index).inputs.aclr  := i.wrst(index);
   --
   n.txparamfifo(index).inputs.data(47 downto  0) := SLV(0, 48); -- data default: all zero
   -- 
   n.txparamfifo(index).inputs.data(10 downto  0) := i.wframelen(index); 
   n.txparamfifo(index).inputs.data(14 downto 11) := i.wdestport(index);
   n.txparamfifo(index).inputs.data(22 downto 15) := i.wdestaddr(index);
   n.txparamfifo(index).inputs.data(23)           := i.wmulticast(index); 
   n.txparamfifo(index).inputs.data(11+24 downto 0+24) := ro.wclk(index).baseptr;
   n.txparamfifo(index).inputs.data(10+36 downto 0+36) := ro.wclk(index).datalen;

   -- txbackfifo defaults (read side, clock domain wclk(index))
   n.txbackfifo(index).inputs.rdclk := i.wclk(index);
   n.txbackfifo(index).inputs.rdreq := '0';
   -- note: n.txbackfifo(index).outputs.q(10 downto 0) --> datalen for memory de-allocation 

   -- outputs defaults
   o.wready(index) := '0';

   -- txportwr control
   case ro.wclk(index).FSMtxportwr is
   when S0 =>
      --
      -- reset state
      --
      r.wclk(index).FSMtxportwr := S1;

   when S1 =>
      --
      -- init state (assuming txport not enabled)
      --
      if i.wena(index) = '1' and ro.wclk(index).txportrdena = '1' then
         -- write+read sides both enabled: txport enable command starts
         r.wclk(index).txportena := '1';         
         r.wclk(index).FSMtxportwr := S1_1;
      else
         -- txport not enabled: wait
         r.wclk(index).txportena := '0';
      end if;
      -- note: this state merges enable requests from txport write+read sides and
      -- asserts common 'txportena' status flag   

      --
      -- txport is empty
      --
      -- datalen zero 
      r.wclk(index).datalen := SLV(0, r.wclk(index).datalen);
      -- freelen 4096 
      r.wclk(index).freelen := SLV(4096, r.wclk(index).freelen);
      -- baseptr zero 
      r.wclk(index).baseptr := SLV(0, r.wclk(index).baseptr);

   when S1_1 =>
      --
      -- enable command in progress ('txportena' posedge round-trip)
      --      
      r.wclk(index).txportena := '1';
      if ro.wclk(index).txportenaret = '1' then
         -- txport error flags cleared 
         r.wclk(index).err_txdatabufwrite := '0';
         r.wclk(index).err_txparamfifowrite := '0';
         -- enable command done: continue
         r.wclk(index).FSMtxportwr := S2_0;
      else
         -- command in progress
         null;
      end if;

   when S2_0 =>
      --
      -- run state
      --
      if i.wena(index) = '0' or ro.wclk(index).txportrdena = '0' then
         -- txport not enabled: to flush operation ('o.wready' deasserted, default value)
         r.wclk(index).FSMtxportwr := S2_1;
      elsif n.txparamfifo(index).outputs.wrfull = '1' then
         -- txparamfifo full --> write side not ready ('o.wready' deasserted, default value)  
         null;
      else
         --
         -- txport enabled, txparamfifo not full: write side is ready (inputs 'wreq,wtxclr,wtxreq' take control)    
         --
         o.wready(index) := '1';
         --
         if n.txdatabufwrfull(index) = '0' then
            -- txdatabuf not full
            if i.wreq(index) = '1' then
               -- data write op
               n.txdatabuf(index).inputs.wren := '1';
               --n.txdatabuf(index).inputs.wraddress := SLV(UINT(ro.wclk(index).baseptr) + UINT(ro.wclk(index).datalen), 12); -- default address --> ??? usare un registro ???
               -- datalen++
               --r.wclk(index).datalen := SLV(UINT(ro.wclk(index).datalen) + 1, r.wclk(index).datalen); 
               --r.wclk(index).datalen := SLV(UINT(ro.wclk(index).datalen) + WDATAWIDTH_byte, r.wclk(index).datalen);
               r.wclk(index).datalen := SLV(UINT(ro.wclk(index).datalen) + (txport1_WDATA_WIDTH(index) / 8), r.wclk(index).datalen);               
               -- note: datalen --> current frame length (in bytes), datalen++ depends on WDATAWIDTH_byte parameter
            end if;
         else 
            -- txdatabuf full --> write ignored ('err_txdatabufwrite' asserted, see error-flag logic) 
            null;
         end if;
         -- 
         if i.wtxclr(index) = '1' then
            -- loaded frame discarded (max priority)
            r.wclk(index).datalen := SLV(0, r.wclk(index).datalen);
            -- note: txdatabuf free space = freelen - datalen --> next free space = freelen - zero = freelen
         elsif i.wtxreq(index) = '1' then
            -- all params for current frame are loaded 
            n.txparamfifo(index).inputs.wrreq := '1';
            -- current baseptr
            n.txparamfifo(index).inputs.data(11+24 downto 0+24) := ro.wclk(index).baseptr;
            -- current calculated datalen (note: r.NNNNNN)
            n.txparamfifo(index).inputs.data(10+36 downto 0+36) := r.wclk(index).datalen; 
            -- new frame: baseptr++ using current datalen (note: r.NNNNNN)
            r.wclk(index).baseptr := SLV(UINT(ro.wclk(index).baseptr) + UINT(r.wclk(index).datalen), 12);    
            -- new frame: freelen-- using current datalen (note: r.NNNNNN)
            r.wclk(index).freelen := SLV(UINT(ro.wclk(index).freelen) - UINT(r.wclk(index).datalen), 12+1);    
            -- new frame: datalen zero 
            r.wclk(index).datalen := SLV(0, r.wclk(index).datalen);
         end if;
         --
         -- note: 'wreq' and 'wtxreq'/'wtxclr' can be applied on the same clock cycle 
         --        --> txparamfifo write path uses current calculated datalen (r.NNNNNN);
         --            the same variable is then overwritten with zero to define true datalen register
         --            value for next clock cycle     
         --  
      end if;
      --
      -- Note: FSM propagates 'i.wena' to 'o.wready' so external logic simply checks 'o.wready' 
      -- for each write request --> 'i.wena' is embedded into 'o.wready'. 
      -- External logic driving 'i.wena' should ignore 'o.wready' (otherwise conbinatorial-latch-loops
      -- may be generated): 'i.wena' can be freely asserted/deasserted, 'o.wready' status will immediatly
      -- follow (S2_0 continuosly checks txport enable request: when enable request deasserted all
      -- write operations are blocked and FSM moves to S2_1 so next clock cycle 'o.wready' will default to zero).  
      --

   when S2_1 =>
      --
      -- flush operation in progress
      --
      if ro.wclk(index).txportrdena = '1' and n.txparamfifo(index).outputs.wrempty = '0' then
         -- read side enabled, txparamfifo not emtpy: txframe in progress for all loaded frames
         null;
      else 
         -- read side not enabled | all frames transmitted: 'txportena' de-asserted to force read side cleanup
         r.wclk(index).txportena := '0';         
         r.wclk(index).FSMtxportwr := S2_2;
         -- note: read-side 'enable' has higher priority than write-side 'wena' --> 'wena = 0' waits for
         -- flush operations (all loaded frames transmitted, partial loaded frame data discarded), 
         -- 'enable = 0' immediately starts cleanup operations and unlocks scheduler when external txframe 
         -- module not enabled.
         -- note1: txparamfifo is a 'showahead' fifo, 'wrempty = 1' means all loaded
         -- frames completely processed
      end if;

   when S2_2 =>
      --
      -- 'txportena' negedge round-trip
      --    
      r.wclk(index).txportena := '0';
      if ro.wclk(index).txportenaret = '0' then
         -- negedge round-trip done: read-side cleanup completed (read-side continuously reads txparamfifo,
         -- write-side continuosly reads txbackfifo using de-allocation logic, read-side has seen txbackfifo.wrempty = 1
         -- so txbackfifo is really empty when txbackfifo.rdempty = 1) --> write will restart when both fifos are empty ??? per sicurezza si includono entrambi ma forse si potrebbe usare solo txparamfifo 
         if n.txbackfifo(index).outputs.rdempty = '1' and n.txparamfifo(index).outputs.wrempty = '1' then
            -- cleanup done: restart
            r.wclk(index).FSMtxportwr := S1;
         else
            null;
         end if;
      else         
         -- negedge in progress: 
         null;
      end if;

   end case;

   -- de-allocation logic: 'freelen' adjusted using current calculated value + txbackfifo data (note: r.NNNNNN) 
   if n.txbackfifo(index).outputs.rdempty = '0' then
      -- additional freespace from de-allocated memory
      r.wclk(index).freelen := SLV(UINT(r.wclk(index).freelen) + UINT(n.txbackfifo(index).outputs.q(10 downto 0)), 12+1);
      -- de-allocation done
      n.txbackfifo(index).inputs.rdreq := '1';
   end if;
   -- note: de-allocation logic always ON

   -- txdatabuf full flag
   n.txdatabufwrfull(index) := '0';
   --if ((UINT(ro.wclk(index).datalen) + WDATAWIDTH_byte) >= 2048)                         or   -- frame-slot test
   --   ((UINT(ro.wclk(index).datalen) + WDATAWIDTH_byte) >  UINT(ro.wclk(index).freelen)) then -- freelen test
   if ((UINT(ro.wclk(index).datalen) + (txport1_WDATA_WIDTH(index) / 8)) >= 2048)                         or   -- frame-slot test
      ((UINT(ro.wclk(index).datalen) + (txport1_WDATA_WIDTH(index) / 8)) >  UINT(ro.wclk(index).freelen)) then -- freelen test
      -- not sufficient free space to accept one data word 
      n.txdatabufwrfull(index) := '1';
   end if;
   -- txdatabuf empty flag
   n.txdatabufwrempty(index) := '0';
   if (UINT(ro.wclk(index).freelen) >= 4096) and (UINT(ro.wclk(index).datalen) = 0) then
      n.txdatabufwrempty(index) := '1';
      -- note: txdatabuf is empty when freelen>=4096 AND datalen=0 (datalen starts from zero
      -- and follows frame-data write operations, freelen does not change until frame-params 
      -- are loaded)
   end if;

   -- txport write level
   o.wdatalen(index) := ro.wclk(index).datalen;
   o.wframes(index)  := n.txparamfifo(index).outputs.wrusedw;
   --
   o.wempty(index)   := n.txparamfifo(index).outputs.wrempty and n.txdatabufwrempty(index); 
   o.wfull(index)    := n.txparamfifo(index).outputs.wrfull  or  n.txdatabufwrfull(index);
   -- note: txparamfifo full (16 frames loaded) or txdatabuffifo full (current frame-slot full)
   -- are both signaled using the same 'wfull' output --> wready flag depends only on txparamfifo full 
   -- condition so 'wready,wfull' works as 2bit indicator for txport status   
   --
   -- wready  wfull
   --    0      0    'txport not enabled'
   --    0      1    'txparamfifo full'
   --    1      0    'txport is ready'
   --    1      1    'txdatabuf is full'
   --
   -- wready = 0 --> 'txport not enabled' or 'txparamfifo full'
   --                (wtxclr,wtxreq,wreq are ignored and generate errors)
   --
   -- wready = 1 --> 'txport is ready' 
   --                (wtxclr/wtxreq always accepted, wreq depends on wfull)
   --

   -- txport write errors (sticky bits, cleared by FSMtxportwr when txport re-enabled)
   if o.wready(index) = '0' or o.wfull(index) = '1' then
      -- txport not ready | txport is full: 'wreq' generates error
      if i.wreq(index) = '1' then
         r.wclk(index).err_txdatabufwrite := '1';
      end if;
   else
      -- txport ready and not full: 'wreq' accepted, write error bit unchanged 
      null;
   end if;
   --
   if o.wready(index) = '0' then
      -- txport not ready: 'wtxreq','wtxclr' generates error
      if i.wtxreq(index) = '1' or i.wtxclr(index) = '1' then
         r.wclk(index).err_txparamfifowrite := '1';
      end if;
   else
      -- txport is ready: 'wtxreq','wtxclr' always accepted, write error bit unchanged 
      null;
   end if;
   o.werror(index) := ro.wclk(index).err_txdatabufwrite or ro.wclk(index).err_txparamfifowrite;

END LOOP;

end procedure;


--
-- Crossing clocks combinatorial procedure (edit)
--
-- clock domain: all clocks
--
procedure SubCrossingClocks
(
   variable i : in inputs_t;
   variable ri: in reglist_t;
   variable ro: in reglist_t;
   variable o : inout outputs_t;
   variable r : inout reglist_t;
   variable n : inout netlist_t
) is
begin

FOR index IN 1 TO txport1_NPORTS LOOP

   --
   -- write side synchronizers
   -- 
   -- wclk(index) --> clk2 (send)                       
   -- clk2 --> wclk(index) (return)
   --

   -- write side enable command (send)
   r.clk2.txportenaI(index) := ro.wclk(index).txportena;
   r.clk2.txportenaII(index):= ro.clk2.txportenaI(index);
   r.clk2.txportena(index)  := ro.clk2.txportenaII(index);
   -- write side enable command (return)
   r.wclk(index).txportenaretI := ro.clk2.txportenaret(index);
   r.wclk(index).txportenaretII:= ro.wclk(index).txportenaretI;
   r.wclk(index).txportenaret  := ro.wclk(index).txportenaretII;
   -- note: round-trip return signal controlled by FSMtxportrd

   -- write side error flags (send)
   r.wclk(index).err_txportwrite  := ro.wclk(index).err_txdatabufwrite or ro.wclk(index).err_txparamfifowrite;
   r.clk2.err_txportwriteI(index) := ro.wclk(index).err_txportwrite; 
   r.clk2.err_txportwriteII(index):= ro.clk2.err_txportwriteI(index);
   r.clk2.err_txportwrite(index)  := ro.clk2.err_txportwriteII(index);
   -- note: 'err_txportwrite' driver must be a single register (combinatorial logic not allowed with synchronizers) 

   --
   -- read side synchronizers
   --
   -- clk2 --> wclk(index) (send)
   -- wclk(index) --> clk2 (return)
   --

   -- read side status (send)
   r.wclk(index).txportrdenaI := ro.clk2.txportrdena(index);
   r.wclk(index).txportrdenaII:= ro.wclk(index).txportrdenaI;
   r.wclk(index).txportrdena  := ro.wclk(index).txportrdenaII;
   -- read side status (return)
   r.wclk(index).txportrdenaret  := ro.wclk(index).txportrdena;
   r.clk2.txportrdenaretI(index) := ro.wclk(index).txportrdenaret;
   r.clk2.txportrdenaretII(index):= ro.clk2.txportrdenaretI(index);
   r.clk2.txportrdenaret(index)  := ro.clk2.txportrdenaretII(index);
   -- note: round-trip always ON

END LOOP;

end procedure;


--
-- Debug combinatorial procedure (edit)
--
-- clock domain: all clocks
--
procedure SubDebug
(
   variable i : in inputs_t;
   variable ri: in reglist_t;
   variable ro: in reglist_t;
   variable o : inout outputs_t;
   variable r : inout reglist_t;
   variable n : inout netlist_t
) is
begin

   -- !! Debug !!  
   o.txparamfifo := n.txparamfifo;
   -- !! Debug !!

end procedure;


--**************************************************************
--
-- combinatorial description end
--
--**************************************************************

--
-- combinatorial process
--
variable i : inputs_t;
variable ri: reglist_t;
variable ro: reglist_t;
variable o : outputs_t;
variable r : reglist_t;
variable n : netlist_t;
begin
   -- read only variables
   i := inputs;
   ri := allregs.din;
   ro := allregs.dout;
   -- read/write variables
   o := allouts;
   r := allregs.dout;
   n := allnets;
   -- components outputs
   FOR index IN 1 TO txport1_NPORTS LOOP
      n.txdatabuf(index).outputs := allcmps.txdatabuf(index).outputs;
      n.txparamfifo(index).outputs := allcmps.txparamfifo(index).outputs;
      n.txbackfifo(index).outputs := allcmps.txbackfifo(index).outputs;
   END LOOP;
   n.txfifo.outputs := allcmps.txfifo.outputs;

   --
   -- all procedures call (edit)
   --

   -- clock domain: clk2
   SubFSMtxportrdena(i, ri.clk2, ro.clk2, o, r.clk2, n);
   SubFSMtxportrd   (i, ri.clk2, ro.clk2, o, r.clk2, n);
   SubFSMtxscheduler(i, ri.clk2, ro.clk2, o, r.clk2, n);
   SubCmdInterface  (i, ri.clk2, ro.clk2, o, r.clk2, n);

   -- clock domain: all clocks
   SubFSMtxportwr   (i, ri, ro, o, r, n);
   SubCrossingClocks(i, ri, ro, o, r, n);
   SubDebug         (i, ri, ro, o, r, n);

   -- allouts/regs/nets updates
   allouts <= o;
   allregs.din <= r;
   allnets <= n;

end process;

--**************************************************************
--**************************************************************

--
-- output connections (edit)
--
outputs <= allouts;

end rtl;
--**************************************************************
--
-- architecture rtl of txport1
--
--**************************************************************

