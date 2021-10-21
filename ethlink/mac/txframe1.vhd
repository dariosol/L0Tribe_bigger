--**************************************************************
--**************************************************************
--
-- Template file: comp_ck1.rec (new component, single clk)
--
--**************************************************************
--**************************************************************
--
--
-- Component txframe1
--
-- Frame transmission logic:
--
-- - frame format:
--   preamble(7)/SFD(1)/dest(6)/src(6)/ltype(2)/ipheader(20)/udpheader(8)/udpdata(..)/crc(4)
--   
-- - udpdata format:
--   header(10)/zero(..)  command frame
--   header(10)/data(..)  data frame (*)
--
--   header format:
--   txdata  : daddr(1)/saddr(1)/cmd(1)/ports(1)/seqnum(4)/ldata(2) (cmd.code == 0) (*)  
--   txcmd   : daddr(1)/saddr(1)/cmd(1)/ports(1)/cmdparams(6)       (cmd.code <> 0)
--   txpause : cmdpause(2)/txquanta(2)/padzero(6)  
--
--   (*) note: header(10) is optional for data frames
--
-- - ieee MAC control frames (tx Pause command) supported 
-- - ltype-field depends on frame type (UDP/Pause)
-- - ldata-field contains true data-length (i.e. datalen shorter 
--   than datafieldlen, ladata value calculated using frame params)
-- - txdata collected from txport array (selected txport signaled
--   by 'txportaddr' input)
-- - output data sent to gmii interface
-- - transmission starts when (max to min priority):
--      * pause frame request;
--      * command frame request (short frame with protocol data)
--      * txport request (data frame with optional header)
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

package component_txframe1 is

--**************************************************************
--
-- I/O section begin
--
--**************************************************************

--
-- local typedefs (edit)
--
subtype txframe1_byte_t is std_logic_vector(7 downto 0);
type txframe1_byte_vector_t is array(NATURAL RANGE <>) of txframe1_byte_t;

--
-- txframe1 inputs (edit)
--
type txframe1_inputs_t is record

   -- txframe clock domain: common tx/rx clock domain
   clk2 : std_logic;
   rst2 : std_logic;
   --
   -- NOTE: we assume all resets async asserted, sync deasserted by related clocks
   --

   -- txframe-interface (clock domain clk2,rst2)
   enable : std_logic; -- ???? questo ingresso serve davvero...txframe sempre ON ?????
   txportreq : std_logic;
   txportaddr : std_logic_vector(3 downto 0);
   txdatalen : std_logic_vector(10 downto 0);
   txframelen : std_logic_vector(10 downto 0);
   txdestport : std_logic_vector(3 downto 0);
   txdestaddr : std_logic_vector(7 downto 0);
   txmulticast : std_logic;
   txbroadcast : std_logic;
   txdata : std_logic_vector(7 downto 0);
   txseqnum : std_logic_vector(31 downto 0);
   --
   -- enable     --> global enable
   -- txportreq  --> common request for txframe (all params are valid when asserted) 
   -- txportaddr --> param txport_address (1..15, 0 --> tx-interface disabled/not yet scheduled) 
   -- txdatalen  --> param txport_datalen (11bit, true datalen = 0..[max_payload_size-(28)-(header_size)])
   -- txframelen --> param txport_framelen (11bit, frame max_payload_size = 46..1500)
   -- txdestport --> param txport_destport (4bit) 
   -- txdestaddr --> param txport_destaddr (8bit)
   -- txmulticast --> param txport_multicast (1bit) 
   -- txbroadcast --> param txport_broadcast (1bit) 
   -- txdata     --> txport data (8bit)
   -- txseqnum   --> txport txseqnum (32bit)  
   --

   -- command-interface (clock domain clk2,rst2)
   cmdwrite : std_logic;
   cmddestport : std_logic_vector(3 downto 0);
   cmddestaddr : std_logic_vector(7 downto 0);
   cmdcode : std_logic_vector(7 downto 0);
   cmdports : std_logic_vector(7 downto 0);
   cmdparams : txframe1_byte_vector_t(0 to 5);
   cmd_txreq : std_logic;
   cmd_macread : std_logic;
   cmd_macwrite : std_logic;
   --
   -- cmdwrite    --> command write request (cmd written to single register input fifo, pulse, 1 clock) 
   -- cmddestport --> destport (4bit)
   -- cmddestaddr --> destaddr (8bit)
   -- cmdcode     --> code (8bit)
   -- cmdports    --> ports (8bit)
   -- cmdparams   --> params (6 x 8bit)
   -- cmd_txreq   --> exec flag ('1' command frame transmitted, '0' command does not need transmission)
   -- cmd_macread --> exec flag ('0' standard txcmd frame, '1' MAC-address-lut-read special frame)
   -- cmd_macwrite --> exec flag ('1' MAC-address-lut write) 
   --

   -- ieee MAC pause-frame transmission
   txpausereq : std_logic;
   txpausequanta : std_logic_vector(15 downto 0);
   -- 
   -- txpausereq    --> pause-frame request (write request, pulse, 1 clock)
   -- txpausequanta --> pause-frame 'quanta' parameter 
   --
   -- NOTE: this interface can be used to transmit special ieee MAC pause-frame
   -- (normally not used)
   --   

   -- ieee MAC pause-timer control
   pauseload : std_logic;
   pausequanta : std_logic_vector(15 downto 0);
   --
   -- pauseload     --> pause-timer control (pause-timer loaded with current pausequanta)
   -- pausequanta
   --
   -- NOTE: pause-timer is controlled by external logic (received MACpause frames
   -- are filtered by external logic and applied to theese inputs, interface is
   -- always ON)
   --   

   -- node params
   txnodeaddr : std_logic_vector(7 downto 0);
   --
   -- txnodeaddr  --> node address (8bit)
   --
   -- NOTE: assuming all node params quasi-static (inputs do not change during
   -- frame transmission)
   --

end record;

--
-- txframe1 outputs (edit)
--
type txframe1_outputs_t is record

   -- tx-interface (clock domain clk2, rst2)
   txenablests : std_logic;
   txrdreq : std_logic;
   --
   txportreqok : std_logic;
   txframedone : std_logic;
   txcmddone : std_logic;
   cmdregfull : std_logic;
   txpausedone : std_logic;
   pausetimerdone : std_logic;
   --
   -- txenablests --> txframe enable status
   -- txrdreq     --> common rdreq for txport-burst-read operations 
   --
   -- txportreqok --> txport request accepted (pulse, one clock)
   -- txframedone --> txframe done (pulse, one clock)
   -- txcmddone   --> txcmd short frame done (pulse, one clock) 
   -- cmdregfull  --> cmd input fifo status (1 --> cmd loaded --> fifo full) 
   -- txpausedone --> txpause done (pulse, one clock)
   -- pausetimerdone --> pause-timer status (0 --> pause in progress, 1 --> pause done)
   --

   -- macread command
   macread_data : txframe1_byte_vector_t(0 to 5);
   macread_addr : std_logic_vector(3 downto 0);
   macread_ok : std_logic;
   --
   -- macread_data --> data from last macread command (48bit mac)
   -- macread_addr --> addr from last macread command (4bit maclut index)
   -- macread_ok   --> macread data ok (pulse, one clock)
   --

   -- gmii tx-interface (8bit, txc single edge)
   gtxc : std_logic;
   gtx_en : std_logic;
   gtx_er : std_logic;
   gtxd : std_logic_vector(7 downto 0);
   --
   -- gtxc   --> gmii tx-clock (common tx/rx clock domain: gmii tx-clock is 'clk2')
   -- gtx_en --> gmii enable
   -- gtx_er --> gmii error
   -- gtxd   --> gmii data
   --

end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- txframe1 component common interface (constant)
--
type txframe1_t is record
   inputs : txframe1_inputs_t;
   outputs : txframe1_outputs_t;
end record;

--
-- txframe1 vector type (constant)
--
type txframe1_vector_t is array(NATURAL RANGE <>) of txframe1_t;

--
-- txframe1 component declaration (constant)
--
component txframe1
generic (
   instance : natural
); 
port (
   inputs : in txframe1_inputs_t;
   outputs : out txframe1_outputs_t
);
end component;

end component_txframe1;

--
-- txframe1 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mac_globals.all;
use work.userlib.all;
use work.component_txframe1.all;
use work.component_crc32.all;
use work.component_maclut.all;

-- txframe1 entity (constant)
entity txframe1 is
generic (
   instance : natural
); 
port (
   inputs : in txframe1_inputs_t;
   outputs : out txframe1_outputs_t
);
end txframe1;

--**************************************************************
--**************************************************************

--**************************************************************
--
--
-- Component Architecture
--
--
--**************************************************************

architecture rtl of txframe1 is

--**************************************************************
--
-- Architecture declaration begin
--
--**************************************************************

--
-- local constants (edit)
--
-- constant [name] : [type] := [value];

-- file 'mac_globals.vhd'
--constant BIT_TIME_ns : natural := 10;
--constant CLOCK_FREQ_MHz : natural := 25;
--constant INTERFRAME_GAP_bit : natural := 96;
--constant BIT_PER_CLOCK : natural := 4;
-- file 'mac_globals.vhd'

constant CLOCK_TIME_ns : natural := 1000 / CLOCK_FREQ_MHz;
constant INTERFRAME_GAP_ns : natural := INTERFRAME_GAP_bit * BIT_TIME_ns;
constant INTERFRAME_GAP_clk : natural := INTERFRAME_GAP_ns / CLOCK_TIME_ns;
constant PAUSE_QUANTA_ns : natural := BIT_TIME_ns * 512;
constant PAUSE_QUANTA_clk : natural := PAUSE_QUANTA_ns / CLOCK_TIME_ns;

--
-- state machines (edit)
--
type FSMtxframectrl_t is
(  
   S0,   
   S1_0, -- enable/disable logic
   S1_1, -- main decoder
   S1_2, -- txport test
   S1_3, -- cmd test/dispatch
   S1_4, -- mac write request
   S1_5, -- mac read request 
   S1_5_0,
   S1_5_1,
   S1_5_2,
   S1_5_3,
   S1_5_4,
   S1_5_5,
   S1_5_6,
   S2,   -- txdata in progress
   S3,   -- txcmd in progress
   S4    -- txpause in progress
);

type FSMtxframe_t is
(
   S0, S1,                                         -- tx init
   S2_0, S2_1, S2_2, S2_3,                         -- tx interframe, command decoder
   S3_0, S3_1,                                     -- tx preamble
   S4_0, S4_1, S4_2, S4_3, S4_4, S4_5,             -- tx destaddr
   S5_0, S5_1, S5_2, S5_3, S5_4, S5_5,             -- tx srcaddr
   S6_0, S6_1,                                     -- tx lentype

   IP_0, IP_1, IP_2, IP_3, IP_4, IP_5,             -- tx IP header
   IP_6, IP_7, IP_8, IP_9, IP_10, IP_11,           --
   IP_12, IP_13, IP_14, IP_15, IP_16, IP_17,       --
   IP_18, IP_19,                                   --

   UDP_0, UDP_1, UDP_2, UDP_3, UDP_4, UDP_5,       -- tx UDP header
   UDP_6, UDP_7,                                   --

   S6_2, S6_3, S6_4, S6_5,                         -- tx daddr,saddr,cmd,ports
   S6_6, S6_7, S6_8, S6_9, S6_10, S6_11,           -- tx params,ldata
   S7_0, S7_1,                                     -- tx data/pad
   S8_0, S8_1, S8_2, S8_3, S8_4,                   -- tx fcs
   S9,                                             -- tx end

   S10_0, S10_1, S10_2, S10_3, S10_4, S10_5,       -- txpause destaddr
   S11_0, S11_1,                                   -- txpause lentype
   S12_0, S12_1,                                   -- txpause command
   S13_0, S13_1                                    -- txpause quanta
);

type FSMmaclutwrite_t is
(
   S0, S1, S2
);

--
-- local registers (edit)
--
--
-- Notes: one record-type for each clock domain
--

--
-- clock domain clk2
--
type reglist2_t is record

   -- FSM list
   FSMtxframectrl : FSMtxframectrl_t;
   FSMtxframe : FSMtxframe_t;
   FSMmaclutwrite : FSMmaclutwrite_t;

   -- gtx pipeline
   gtx_en1 : std_logic;
   gtx_er1 : std_logic;
   gtxd1 : std_logic_vector(7 downto 0);
   gtx_crc1 : std_logic;
   gtx_wrreq1 : std_logic;

   -- MAC mapper drivers
   dnodeaddr : std_logic_vector(7 downto 0);
   dmulticast : std_logic;
   dbroadcast : std_logic;

   -- cmd input regs
   cmdflag : std_logic;
   cmddestport : std_logic_vector(3 downto 0);
   cmddestaddr : std_logic_vector(7 downto 0);
   cmdports    : std_logic_vector(7 downto 0);
   cmdcode     : std_logic_vector(7 downto 0);
   cmdparams   : txframe1_byte_vector_t(0 to 5);
   cmd_txreq   : std_logic;
   cmd_macread : std_logic;
   cmd_macwrite : std_logic;

   -- interframe counter
   interframe_timer : unsigned(7 downto 0);

   -- preamble counter
   pcounter : unsigned(3 downto 0);

   -- data counter
   ldata : unsigned(15 downto 0);
   lcounter : unsigned(16 downto 0);
   lcounter_test : std_logic;
   dcounter : unsigned(16 downto 0);
   dcounter_test : std_logic;

   -- datalen test
   datafieldlen : std_logic_vector(10 downto 0);
   datalen      : std_logic_vector(10 downto 0);
   datalen_null : std_logic;
   datalen_zero : std_logic;

   -- IP/UDP frame length
   ipframelen  : std_logic_vector(10 downto 0); 
   udpframelen : std_logic_vector(10 downto 0); 

   -- IP checksum
   ipchksum0 : unsigned(31 downto 0);
   ipchksum1 : unsigned(31 downto 0);
   ipchksum2 : unsigned(31 downto 0);
   ipchksum3 : unsigned(31 downto 0);
   ipchksum4 : unsigned(31 downto 0);
   ipchksum  : unsigned(15 downto 0);

   -- pause-timer
   pausetimer : unsigned(15+1 downto 0);
   -- note: 15+1 --> up counter, overflow bit test

   -- prescaler for pause-timer quanta
   prescaler : unsigned(7 downto 0);
   -- note: prescaler reload for 100Mbps = 128
   --       prescaler reload for 1000Mbps = 64

   -- txpause control
   txpausereqI : std_logic;
   txpauseflag : std_logic;
   txpausequanta : std_logic_vector(15 downto 0);

   -- txframe global status
   txframeon : std_logic;

   -- tx flag (transmission in progress)
   txON : std_logic;

   -- macread command
   macread_data : txframe1_byte_vector_t(0 to 5);
   macread_addr : std_logic_vector(3 downto 0);

   -- end of list
   eol : std_logic;

end record;
constant reglist2_default : reglist2_t :=
(
   FSMtxframectrl => S0,
   FSMtxframe => S0,
   FSMmaclutwrite => S0,
   gtx_en1 => '0',
   gtx_er1 => '0',
   gtxd1 => (others => '0'),
   gtx_crc1 => '0',
   gtx_wrreq1 => '0',
   dnodeaddr => (others => '0'),
   dmulticast => '0',
   dbroadcast => '0',
   cmdflag => '0',
   cmddestport => (others => '0'),
   cmddestaddr => (others => '0'),
   cmdports    => (others => '0'),
   cmdcode     => (others => '0'),
   cmdparams   => (others => "00000000"),
   cmd_txreq   => '0',
   cmd_macread => '0',
   cmd_macwrite => '0',
   interframe_timer => (others => '0'),
   pcounter => (others => '0'),
   ldata => (others => '0'),
   lcounter => (others => '0'),
   lcounter_test => '0',
   dcounter => (others => '0'),
   dcounter_test => '0',
   datafieldlen => (others => '0'),
   datalen      => (others => '0'),
   datalen_null => '0',
   datalen_zero => '0',
   ipframelen  => (others => '0'),
   udpframelen => (others => '0'),
   ipchksum0 => (others => '0'),
   ipchksum1 => (others => '0'),
   ipchksum2 => (others => '0'),
   ipchksum3 => (others => '0'),
   ipchksum4 => (others => '0'),
   ipchksum => (others => '0'),
   pausetimer => ("10000000000000000"), -- default: pausetimer done 
   prescaler => (others => '0'),
   txpausereqI => '0',
   txpauseflag => '0',
   txpausequanta => (others => '0'),
   txframeon => '0',
   txON => '0',
   macread_data => (others => "00000000"),
   macread_addr => (others => '0'),

   eol => '0'
);

--
-- all local registers (edit)
--
-- Notes: one record-element for each clock domain
--
type reglist_t is record
   clk2 : reglist2_t;
end record;

--
-- all local nets (edit)
--
type netlist_t is record

   -- tx frame control
   frame_done : std_logic;
   dcounter_load : std_logic;
   dcounter_inc : std_logic;

   -- IP/UDP signals
   ipsrcaddr : std_logic_vector(31 downto 0);
   ipdestaddr : std_logic_vector(31 downto 0);
   ipbasechksum : unsigned(31 downto 0);

   -- gmii driver
   gtx_en : std_logic;
   gtx_er : std_logic;
   gtxd : std_logic_vector(7 downto 0);
   gtx_crc : std_logic;
   gtx_wrreq : std_logic;
   gtx_full : std_logic;

   -- pause-timer control
   pauseclk : std_logic;
   pausetimer_done : std_logic;

   -- maclut control
   maclutwrreq : std_logic;
   maclutwrok : std_logic;
   dest_multicast : std_logic;
   dest_broadcast : std_logic;
   dest_nodeaddr : std_logic_vector(7 downto 0);
   destaddr : txframe1_byte_vector_t(0 to 5);
   src_nodeaddr : std_logic_vector(7 downto 0);
   srcaddr : txframe1_byte_vector_t(0 to 5);  

   --
   -- component interface signals (edit)
   --
   -- [instance_name] : [component_name]_t;
   --
   txcrc : crc32_t;
   maclut : maclut_t;

end record;

--
-- local signals (edit)
--

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
subtype inputs_t is txframe1_inputs_t;
subtype outputs_t is txframe1_outputs_t;

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
-- architecture rtl of txframe1
--
--**************************************************************
begin

--**************************************************************
--
-- components instances (edit)
--
--**************************************************************

--[instance_name/label] : [component_name] port map
--(
--   inputs => allnets.[instance_name].inputs,
--   outputs => allcmps.[instance_name].outputs
--);

txcrc : crc32 port map
(
   inputs => allnets.txcrc.inputs,
   outputs => allcmps.txcrc.outputs
);

mlut : maclut port map
(
   inputs => allnets.maclut.inputs,
   outputs => allcmps.maclut.outputs
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
-- clock domain: rst2,clk2 (edit)
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
-- FSMtxframectrl combinatorial procedure (edit)
--
-- clock domain: clk2
--
procedure SubFSMtxframectrl
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
   -- txframe control
   --
   -- All requests are accepted/decoded by 'S1_nnn' states, frame transmission requests 
   -- are signaled by 'S2,S3,S4' states:
   --
   -- if txpausereq
   --    --> txpause (S4, ieee pause-frame, max priority)
   -- if cmdreq
   --    --> txcmd (S3, command short-frame)
   -- if txportreq
   --    --> txframe (S2, data long-frame)
   --

   -- outputs defaults
   o.txportreqok := '0';
   o.txframedone := '0';
   o.txpausedone := '0';
   o.txcmddone   := '0';
   o.txenablests := ro.txframeon;
   o.cmdregfull  := ro.cmdflag;
   --
   o.macread_data := ro.macread_data(0 to 5);
   o.macread_addr := ro.cmdports(3 downto 0);
   o.macread_ok   := '0';

   --
   -- single register input fifos
   --
   if i.txpausereq = '1' and ro.txpauseflag = '0' then
      -- txpause request latched
      r.txpauseflag := '1';
      r.txpausequanta := i.txpausequanta;
   end if; 
   --
   if i.cmdwrite = '1' and ro.cmdflag = '0' then
      -- cmd latched
      r.cmdflag := '1';
      r.cmddestport := i.cmddestport;
      r.cmddestaddr := i.cmddestaddr;
      r.cmdports    := i.cmdports;
      r.cmdcode     := i.cmdcode;
      r.cmdparams   := i.cmdparams;
      r.cmd_txreq   := i.cmd_txreq;
      r.cmd_macread := i.cmd_macread;
      r.cmd_macwrite := i.cmd_macwrite;
   end if; 
   -- Note: pause/cmd requests are latched and processed
   -- by FSMtxframectrl; registered flags are cleared when
   -- requests accepted/executed

   -- nets defaults
   n.maclutwrreq := '0';

   -- maclut defaults (read-side)
   n.maclut.inputs.rdinit := '0';
   n.maclut.inputs.rdnext := '0';
   n.maclut.inputs.rdpointer := (others => '0');

   case ro.FSMtxframectrl is
   when S0 =>
      --
      -- reset state
      --
      r.FSMtxframectrl := S1_0;

   when S1_0 =>
      -- 
      -- init state (enable/disable logic)
      --
      if i.enable = '0' then     
         -- txframe not enabled
         r.txframeon := '0'; 
         -- all input fifos cleared
         r.txpauseflag := '0';
         r.cmdflag := '0';
      else
         -- txframe enabled, continue
         r.txframeon := '1';
         r.FSMtxframectrl := S1_1;
      end if;

   when S1_1 =>
      --
      -- main decoder
      --
      if (ro.txpauseflag = '1') then
         --
         -- pause frame request (max priority)
         -- 
         r.FSMtxframectrl := S4;
      
      elsif ro.cmdflag = '1' then
         --
         -- command request
         --
         r.FSMtxframectrl := S1_3;
         
      elsif (i.txportreq = '1') then
         --
         -- frame transmission request from txport array: port request accepted
         --
         -- note: same clock cycle, unregistered ack
         --
         o.txportreqok := '1'; 
         r.FSMtxframectrl := S1_2;

      else
         --
         -- nop: return to init state (enable input periodically tested)
         --
         r.FSMtxframectrl := S1_0;

      end if;

   when S1_2 =>
      --
      -- txport test
      --   
      if i.txportreq = '0' then
         -- txport-scheduler has recognized 'txportreqok' signal by deasserting i.txportreq 
         if (UINT(i.txportaddr) /= 0) then
            -- valid txportaddr: now txframe has full control over scheduled txport
            r.FSMtxframectrl := S2;
         else
            -- error: invalid port address, forced 'txframedone' output pulse
            o.txframedone := '1';
            -- return to init state
            r.FSMtxframectrl := S1_0;
            -- note: this condition should never appear (but in case of error
            -- txframe request must always end with 'txframedone' asserted)
            -- ...???...il test txportaddr /= 0 puo' essere ignorato --> si trasmette qualsiasi txportaddr ??? 
         end if;
      else
         -- error: txport-scheduler not responding as expected, return to init state
         r.FSMtxframectrl := S1_0;
         -- note: this condition should never appear (in case of error we
         -- assume current txframe request not recognized so we simply return 
         -- to init state without 'txframedone' asserted)
      end if;

   when S1_3 =>
      --
      -- cmd test/dispatch
      --
      if ro.cmd_macwrite = '1' then
         -- mac write request (max priority)
         r.FSMtxframectrl := S1_4;
      elsif ro.cmd_macread = '1' and ro.cmd_txreq = '0' then
         -- mac read request (transmission not enabled, executed after write request to read last written data)
         r.FSMtxframectrl := S1_5;
      elsif ro.cmd_txreq = '1' then
         -- tx command request (frame transmission will eventually execute the mac read command)
         r.FSMtxframectrl := S3;
      else
         -- command done, to init state
         r.cmdflag := '0';
         r.FSMtxframectrl := S1_0;
      end if;
      -- note: all commands not using transmission are evaluated/executed first;
      -- transmission will start when all sub-cmd flags cleared 
--.....qui si puo' indicare che un comando e' definito da piu' sub-cmd e che solo quando
--     tutti i sub-cmd sono stati eseguiti si ritorna in S1_0 --> tutti i sub-cmd ritornano sempre in S1_3 per il clenaup finale, anche la txcmd ???

   when S1_4 =>
      --
      -- mac write request
      --
      n.maclutwrreq := '1';
      if n.maclutwrok = '1' then
         -- sub-cmd done --> return to cmd test
         r.cmd_macwrite := '0';
         r.FSMtxframectrl := S1_3;
      else
         -- write in progress
         null;
      end if;

   when S1_5 =>
      --
      -- mac read request
      --
      -- MAClut init (4bit address from 'ro.cmdports', maclut limited to 16 master nodes)
      n.maclut.inputs.rdinit := '1';
      n.maclut.inputs.rdpointer := ro.cmdports(3 downto 0);
      -- note: maclut inputs (read-side) are controlled by FSMtxframectrl and by FSMtxframe
      -- (MAClut read-side is a shared resource controlled by two consecutive procedures 
      -- with not-overlapped operations --> FSMtxframectrl defines input defaults and applies  
      -- macread command when FSMtxframe is in idle state; FSMtxframe takes control over maclut
      -- read-side when FSMtxframectrl is waiting in S3 state --> MAClut is driven by   
      -- one FSM at the time)      
      r.FSMtxframectrl := S1_5_0;

   when S1_5_0 =>
      --
      -- mac read 0
      --
      if n.maclut.outputs.qready = '1' then
         -- maclut data is valid
         r.macread_data(0) := n.maclut.outputs.q;
         -- next byte
         n.maclut.inputs.rdnext := '1';
         r.FSMtxframectrl := S1_5_1;         
      else
         -- waiting for maclut data
         null;
      end if;

   when S1_5_1 =>
      --
      -- mac read 1
      --
      r.macread_data(1) := n.maclut.outputs.q;
      -- next byte
      n.maclut.inputs.rdnext := '1';
      r.FSMtxframectrl := S1_5_2;         
      
   when S1_5_2 =>
      --
      -- mac read 2
      --
      r.macread_data(2) := n.maclut.outputs.q;
      -- next byte
      n.maclut.inputs.rdnext := '1';
      r.FSMtxframectrl := S1_5_3;         

   when S1_5_3 =>
      --
      -- mac read 3
      --
      r.macread_data(3) := n.maclut.outputs.q;
      -- next byte
      n.maclut.inputs.rdnext := '1';
      r.FSMtxframectrl := S1_5_4;         

   when S1_5_4 =>
      --
      -- mac read 4
      --
      r.macread_data(4) := n.maclut.outputs.q;
      -- next byte
      n.maclut.inputs.rdnext := '1';
      r.FSMtxframectrl := S1_5_5;         

   when S1_5_5 =>
      --
      -- mac read 5
      --
      r.macread_data(5) := n.maclut.outputs.q;
      -- read done
      r.FSMtxframectrl := S1_5_6;         

   when S1_5_6 =>
      --
      -- mac read done
      --
      o.macread_ok := '1';
      -- sub-cmd done --> return to cmd test
      r.cmd_macread := '0';
      r.FSMtxframectrl := S1_3;

   when S2 =>
      --
      -- frame in progress ('S2' --> txframe ON, data from txport array)
      --
      if n.frame_done = '1' then                                                                
         -- txdone output pulses
         o.txframedone := '1';
         -- frame done, to init state
         r.FSMtxframectrl := S1_0;
      else
         -- tx in progress
         null;
      end if;

   when S3 =>
      --
      -- tx command in progress ('S3' --> txcommand ON, short frame, header field only, no data)
      --
      if n.frame_done = '1' then
         -- txcmddone output pulse
         o.txcmddone := '1';
         -- macread output pulse
         if ro.cmd_macread = '1' then
            o.macread_ok := '1';
         end if;
         -- sub-cmd done --> return to cmd test
         r.cmd_txreq := '0';
         r.cmd_macread := '0';
         r.FSMtxframectrl := S1_3; 
      else
         -- tx in progress
         null;
      end if;

   when S4 =>
      --
      -- pause in progress ('S4' --> txpause ON)
      --
      if n.frame_done = '1' then
         -- txdone output pulse
         o.txpausedone := '1';
         -- tx flag cleared
         r.txpauseflag := '0';
         -- frame done, to init state
         r.FSMtxframectrl := S1_0;
      else
         null;
      end if;

   end case;
   
end procedure;


--
-- PauseTimer control (edit)
--
-- clock domain: clk2
--
procedure SubPauseTimer
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
   -- pause-timer logic
   --
   -- timer clock generated by prescaler
   -- timer reload controlled by 'pauseload','pausequanta' inputs
   --
   -- note: logic always ON ('pauseload' request always recognized/accepted)
   --

   -- timer prescaler (up counter, free running)
   n.pauseclk := '0';
   if UINT(ro.prescaler) >= PAUSE_QUANTA_clk then
      n.pauseclk := '1';
      r.prescaler := SLV(0, r.prescaler);
   else
      r.prescaler := ro.prescaler + 1;
   end if;

   -- timer control (up counter, stop on overflow)
   if i.pauseload = '1' then
      -- timer reload
      r.pausetimer := SLV(65536 - UINT(i.pausequanta), r.pausetimer);
   elsif ro.pausetimer(16) = '1' then
      -- timeout done: timer stop
      null;
   else
      -- pause-request in progress
      if ro.txON = '0' then
         -- txframe is off, timeout in progress: pause clock test  
         if n.pauseclk = '1' then 
            -- timer++ 
            r.pausetimer := ro.pausetimer + 1;
         end if;
      else
         -- txframe in progress: pause-interval will start when txframe is off
         null;
      end if;
      -- note: pause-request when transmission in progress --> logic waits until txframe is off
      -- then pausetimer starts (transmission does not restart until pause-interval expired);
      -- the only exception are txpause-frames never blocked by pause-interval:
      -- in this case pause-timer holds, waits until txpause done and continues using 
      -- the current value (txpause transmission delays are not taken in account)
   end if;
   n.pausetimer_done := ro.pausetimer(16);

   -- pause-timer status to output
   o.pausetimerdone := n.pausetimer_done;

end procedure;


--
-- GMII output control (edit)
--
-- clock domain: clk2
--
procedure SubGMIIoutput
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
   -- GMII outputs controlled by gtx register
   -- (register works in fifo mode with depth = 1)
   --
   -- write: gtx_full = '0' --> gtx_wrreq = '1'
   -- read : 1 clock latency 4bit/8bit nibble mux
   --
   --
   -- Note: this description is a little bit complex...but it uses minimum regs and it works! 
   -- (logic can be rewritten in a cleaner way using additional FSM...)   
   --

   -- outputs defaults (gmii tx-interface, clock domain clk2)
   o.gtxc := i.clk2;
   o.gtx_en := ro.gtx_en1;
   o.gtx_er := ro.gtx_er1;

   -- 4bit/8bit mode
   if BIT_PER_CLOCK = 4 then
      -- 4bit mode: nibble output
      if n.gtx_full = '1' then
         -- new byte written: double nibble_low to output
         o.gtxd(7 downto 0) := ro.gtxd1(3 downto 0) & ro.gtxd1(3 downto 0);
      else
         -- gtx empty, byte contents unchanged: double nibble_high to output
         o.gtxd(7 downto 0) := ro.gtxd1(7 downto 4) & ro.gtxd1(7 downto 4);
      end if;
   end if;
   if BIT_PER_CLOCK = 8 then
      -- 8bit mode: gtx byte in output
      o.gtxd := ro.gtxd1;
   end if;

   -- gtx empty/full control
   r.gtx_wrreq1 := n.gtx_wrreq;
   if BIT_PER_CLOCK = 8 then
      -- 8bit mode: register always empty (full clock write speed, tx byte)
      n.gtx_full := '0';
   end if;
   if BIT_PER_CLOCK = 4 then
      -- 4bit mode: 1 clock latency (half clock write speed, tx nibble)
      n.gtx_full := ro.gtx_wrreq1;
   end if;

   -- gtx write control, crc calculation control
   r.gtx_crc1 := '0';
   if n.gtx_wrreq = '1' then
      if n.gtx_full = '0' then
         -- register empty: write using current data set
         r.gtx_en1 := n.gtx_en;
         r.gtx_er1 := n.gtx_er;
         r.gtx_crc1 := n.gtx_crc;
         r.gtxd1 := n.gtxd;
      else
         -- error: write when full, write ignored
         null;
      end if;
   else
      -- crc calculation stopped, gtx_en gtx_er gtxd unchanged
      null;
   end if;

end procedure;


--
-- FSMmaclutwrite combinatorial procedure (edit)
--
-- clock domain: clk2
--
procedure SubFSMmaclutwrite
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
   -- MAC-address-lut write interface (dpram lut: 16slot x 8byte = 128byte)
   --

   -- defaults (maclut write-side)
   n.maclut.inputs.clk := i.clk2;
   n.maclut.inputs.rst := i.rst2;   
   n.maclut.inputs.wrreq := '0';
   --
   n.maclut.inputs.wrpointer := ro.cmdports(3 downto 0);
   -- note: current slot pointer taken from reg 'cmdports' (nibble low)
   FOR index IN 0 TO 5 LOOP
      n.maclut.inputs.wrmacaddr(index) := ro.cmdparams(index);
   END LOOP;  
   -- note: current MAC address taken from 'cmdparams' regs
   -- note1: MAC addresses are stored starting at the beginning of 8byte memory slot 
   -- (lut(0..5) = mac(0..5), lut(6..7) = zero)

   -- nets defaults
   n.maclutwrok := '0';
   --
   case ro.FSMmaclutwrite is
   when S0 =>
      --
      -- reset state
      --
      r.FSMmaclutwrite := S1;

   when S1 =>
      --
      -- idle state
      --
      if n.maclutwrreq = '1' then
         -- write op starts
         n.maclut.inputs.wrreq := '1';
         r.FSMmaclutwrite := S2;
      else
         -- wait
         null;
      end if;

   when S2 =>
      --
      -- write
      --
      if n.maclut.outputs.writedone = '1' then
         -- write-done pulse
         n.maclutwrok := '1';
         r.FSMmaclutwrite := S1;  
      else
         -- write in progress
         null;
      end if;

   end case;

end procedure;


--
-- SubMACaddress combinatorial procedure (edit)
--
-- clock domain: clk2
--
procedure SubMACaddress
(
   variable i : in inputs_t;
   variable ri: in reglist2_t;
   variable ro: in reglist2_t;
   variable o : inout outputs_t;
   variable r : inout reglist2_t;
   variable n : inout netlist_t
) is
--
constant BROADCAST_ADDR   : txframe1_byte_vector_t(0 to 5) := (x"FF", x"FF", x"FF", x"FF", x"FF", x"FF");
-- !! Debug !!
--constant TXMULTICAST_ADDR : txframe1_byte_vector_t(0 to 5) := (x"01", x"00", x"5E", x"7F", x"00", x"00"); .....da calcolare usando il mcast ???
---- note: MAC multicast pattern 01-00-5E-7F-00-00 corresponds to IP multicast 239.255.0.NNN (see (*) SubFSMtxframe)
-- !! Debug !!
constant TXMULTICAST_ADDR : txframe1_byte_vector_t(0 to 5) := (x"01", x"00", x"5E", 
                                                               '0' & SLV(IPv4_MADDR(1), 7), 
                                                                     SLV(IPv4_MADDR(2), 8), 
                                                                     SLV(IPv4_MADDR(3), 8));
-- note: MAC multicast pattern 01-00-5E-[0..7F]-[0..FF]-[0..FF] corresponds to 23bit lsb of IPv4_MADDR (see (*) SubFSMtxframe)
--       (standard "Host Extensions for IP Multicasting" RFC1112, "Administratively Scoped IP Multicast" RFC2365)  

-- !! Debug !!
--constant MASTERNODE_ADDR : txframe1_byte_vector_t(0 to 5) := (x"00", x"11", x"22", x"33", x"44", x"00");
--constant SLAVENODE_ADDR  : txframe1_byte_vector_t(0 to 5) := (x"00", x"01", x"02", x"03", x"04", x"00");
-- !! Debug !!
constant MASTERNODE_ADDR : txframe1_byte_vector_t(0 to 5) := (SLV(MAC_MASTERNODE_ADDR(instance)(0), 8),
                                                              SLV(MAC_MASTERNODE_ADDR(instance)(1), 8),
                                                              SLV(MAC_MASTERNODE_ADDR(instance)(2), 8),
                                                              SLV(MAC_MASTERNODE_ADDR(instance)(3), 8),
                                                              SLV(MAC_MASTERNODE_ADDR(instance)(4), 8),
                                                              SLV(                     0, 8));
constant SLAVENODE_ADDR : txframe1_byte_vector_t(0 to 5)  := (SLV(MAC_SLAVENODE_ADDR(instance)(0), 8),
                                                              SLV(MAC_SLAVENODE_ADDR(instance)(1), 8),
                                                              SLV(MAC_SLAVENODE_ADDR(instance)(2), 8),
                                                              SLV(MAC_SLAVENODE_ADDR(instance)(3), 8),
                                                              SLV(MAC_SLAVENODE_ADDR(instance)(4), 8),
                                                              SLV(                    0, 8));
--
-- note: custom slave/master address with constant pattern (mac address byte5 works as 
-- node address indicator --> constant pattern zero) 
--
begin
   --
   -- MAC destaddr mapper
   --
   -- inputs:
   -- n.dest_broadcasr  broadcast flag (max priority)
   -- n.dest_multicast  multicast flag
   -- n.dest_nodeaddr   node address to map 
   -- 
   -- outputs:
   -- n.destaddr        resolved MAC address for selected dest_nodeaddr    
   --
   if n.dest_broadcast = '1' then
      -- broadcast nodeaddr (max priority)
      n.destaddr    := BROADCAST_ADDR;
   elsif n.dest_multicast = '1' then
      -- multicast nodeaddr
      n.destaddr    := TXMULTICAST_ADDR;
      n.destaddr(5) := n.dest_nodeaddr; 
   else
      -- unicast nodeaddr
      if UINT(n.dest_nodeaddr) >= 192 and UINT(n.dest_nodeaddr) <= 255 then
         -- address interval 192..255 assigned to master nodes: constant pattern master mac address (default) 
         n.destaddr    := MASTERNODE_ADDR;
         n.destaddr(5) := n.dest_nodeaddr; 
         if UINT(n.dest_nodeaddr) <= 192+15 THEN
            -- address interval 192+0..192+15 assigned via programmable maclut memory
            FOR index IN 0 TO 5 LOOP
               n.destaddr(index) := n.maclut.outputs.q(7 downto 0);
            END LOOP;  
            -- note: maclut is read sequentially, common output bus drives all destaddr bytes
         end if;
      else
         -- address interval 0..191 assigned to slave nodes: constant pattern slave mac address      
         n.destaddr    := SLAVENODE_ADDR;
         n.destaddr(5) := n.dest_nodeaddr; 
      end if;
   end if;
   -- note: logic is fully combinatorial

   --
   -- MAC srcaddr mapper
   --
   -- inputs:
   -- n.src_nodeaddr    node address to map
   -- 
   -- outputs:
   -- n.srcaddr         resolved MAC address for selected src_nodeaddr    
   --
   if UINT(n.src_nodeaddr) >= 192 and UINT(n.src_nodeaddr) <= 255 then
      -- address interval 192..255 assigned to master nodes: constant pattern master mac address
      n.srcaddr    := MASTERNODE_ADDR;
      n.srcaddr(5) := n.src_nodeaddr; 
   else
      -- address interval 0..191 assigned to slave nodes: constant pattern slave mac address      
      n.srcaddr    := SLAVENODE_ADDR;
      n.srcaddr(5) := n.src_nodeaddr; 
   end if;
   -- note: logic is fully combinatorial 

end procedure;


--
-- FSMtxframe combinatorial procedure (edit)
--
-- clock domain: clk2
--
procedure SubFSMtxframe
(
   variable i : in inputs_t;
   variable ri: in reglist2_t;
   variable ro: in reglist2_t;
   variable o : inout outputs_t;
   variable r : inout reglist2_t;
   variable n : inout netlist_t
) is

-- IP protocol 0x0800
constant TXIP_LTYPE : txframe1_byte_vector_t(0 to 1) := (x"08", x"00");

-- IP header
constant TXIP_VER_TOS : txframe1_byte_vector_t(0 to 1) := (x"45", x"00");   -- (const) IPv4 (20byte header), TOS = 0 (routine)
constant TXIP_LEN     : txframe1_byte_vector_t(0 to 1) := (x"00", x"00");   -- (param) Total Length
constant TXIP_IDENT   : txframe1_byte_vector_t(0 to 1) := (x"00", x"00");   -- (param) Identification
constant TXIP_FRAG    : txframe1_byte_vector_t(0 to 1) := (x"00", x"00");   -- (const) Fragment Info (not fragmented)
constant TXIP_TTL_PROT: txframe1_byte_vector_t(0 to 1) := (x"10", x"11");   -- (const) TTL (max 16 hops), Protocol (UDP = 17)
constant TXIP_CHKSUM  : txframe1_byte_vector_t(0 to 1) := (x"00", x"00");   -- (param) Checksum
--
-- !! Debug !!
--constant TXIP_SADDR   : txframe1_byte_vector_t(0 to 3) := (SLV(192,8), SLV(168,8), SLV(  0,8), SLV(  0,8)); -- (param) Unicast Src Address
--constant TXIP_DADDR   : txframe1_byte_vector_t(0 to 3) := (SLV(192,8), SLV(168,8), SLV(  0,8), SLV(  0,8)); -- (param) Unicast Dest Address
--constant TXIP_MADDR   : txframe1_byte_vector_t(0 to 3) := (SLV(239,8), SLV(255,8), SLV(  0,8), SLV(  0,8)); -- (param) Multicast Dest Address (see (*) SubMACaddress) 
--constant TXIP_BADDR   : txframe1_byte_vector_t(0 to 3) := (SLV(192,8), SLV(168,8), SLV(  0,8), SLV(255,8)); -- (const) Network Broadcast Dest Address
-- !! Debug !!
constant TXIP_SADDR   : txframe1_byte_vector_t(0 to 3) := (SLV(IPv4_NADDR(instance)(0), 8), SLV(IPv4_NADDR(instance)(1), 8), SLV(IPv4_NADDR(instance)(2), 8), SLV(IPv4_NADDR(instance)(3), 8)); -- (param) Unicast Src Address
constant TXIP_DADDR   : txframe1_byte_vector_t(0 to 3) := (SLV(IPv4_NADDR(instance)(0), 8), SLV(IPv4_NADDR(instance)(1), 8), SLV(IPv4_NADDR(instance)(2), 8), SLV(IPv4_NADDR(instance)(3), 8)); -- (param) Unicast Dest Address
constant TXIP_MADDR   : txframe1_byte_vector_t(0 to 3) := (SLV(IPv4_MADDR(0), 8), SLV(IPv4_MADDR(1), 8), SLV(IPv4_MADDR(2), 8), SLV(IPv4_MADDR(3), 8)); -- (param) Multicast Dest Address (see (*) SubMACaddress) 
constant TXIP_BADDR   : txframe1_byte_vector_t(0 to 3) := (SLV(IPv4_BADDR(instance)(0), 8), SLV(IPv4_BADDR(instance)(1), 8), SLV(IPv4_BADDR(instance)(2), 8), SLV(IPv4_BADDR(instance)(3), 8)); -- (const) Network Broadcast Dest Address
--constant TXIP_BADDR   : txframe1_byte_vector_t(0 to 3) := (SLV(255,8), SLV(255,8), SLV(255,8), SLV(255,8)); -- (const) Broadcast Dest Address  ??? si usa il Broadcast 255.255.255.255 che non dipende dalla subnet ??? 
--
-- Note: for each frame --> (param) fields are calculated/updated by logic, (const) fields unchanged
--

--
-- IP checksum (precalculated constant base offsets)
--
-- Note: IP SrcAddr is always Unicast
--
constant TXIP_CHKSUM0 : unsigned(31 downto 0) := SLV(TXIP_VER_TOS(0)  & TXIP_VER_TOS(1) , 32) + 
                                                 SLV(TXIP_FRAG(0)     & TXIP_FRAG(1)    , 32) +
                                                 SLV(TXIP_TTL_PROT(0) & TXIP_TTL_PROT(1), 32);

constant TXIP_CHKSUM0_UCAST: unsigned(31 downto 0) := TXIP_CHKSUM0 + SLV(TXIP_SADDR(0) & TXIP_SADDR(1), 32) +
                                                                     SLV(TXIP_DADDR(0) & TXIP_DADDR(1), 32);
constant TXIP_CHKSUM0_MCAST: unsigned(31 downto 0) := TXIP_CHKSUM0 + SLV(TXIP_SADDR(0) & TXIP_SADDR(1), 32) +
                                                                     SLV(TXIP_MADDR(0) & TXIP_MADDR(1), 32);
constant TXIP_CHKSUM0_BCAST: unsigned(31 downto 0) := TXIP_CHKSUM0 + SLV(TXIP_SADDR(0) & TXIP_SADDR(1), 32) +
                                                                     SLV(TXIP_BADDR(0) & TXIP_BADDR(1), 32);

constant TXIP_CHKSUM1_UCAST : unsigned(31 downto 0) := SLV(TXIP_CHKSUM0_UCAST(31 downto 16), 32) + SLV(TXIP_CHKSUM0_UCAST(15 downto 0), 32);   
constant TXIP_CHKSUM1_MCAST : unsigned(31 downto 0) := SLV(TXIP_CHKSUM0_MCAST(31 downto 16), 32) + SLV(TXIP_CHKSUM0_MCAST(15 downto 0), 32);   
constant TXIP_CHKSUM1_BCAST : unsigned(31 downto 0) := SLV(TXIP_CHKSUM0_BCAST(31 downto 16), 32) + SLV(TXIP_CHKSUM0_BCAST(15 downto 0), 32);   

constant TXIP_CHKSUM_UCAST  : unsigned(31 downto 0) := SLV(TXIP_CHKSUM1_UCAST(31 downto 16), 32) + SLV(TXIP_CHKSUM1_UCAST(15 downto 0), 32);   
constant TXIP_CHKSUM_MCAST  : unsigned(31 downto 0) := SLV(TXIP_CHKSUM1_MCAST(31 downto 16), 32) + SLV(TXIP_CHKSUM1_MCAST(15 downto 0), 32);   
constant TXIP_CHKSUM_BCAST  : unsigned(31 downto 0) := SLV(TXIP_CHKSUM1_BCAST(31 downto 16), 32) + SLV(TXIP_CHKSUM1_BCAST(15 downto 0), 32);   
--
-- Note: there are 3 different checksum offsets for Unicast/Multicast/Broadcast cases  
--

-- file 'mac_globals.vhd'
----
---- UDP header
----
--subtype txframe1_udpport_t is std_logic_vector(15 downto 0);
--type txframe1_udpport_vector_t is array(NATURAL RANGE <>) of txframe1_udpport_t;
---- Base UDPsrcport 10000 (pattern 0xNNN[0] = 0x2710)
--constant TXUDP_SRCPORT  : txframe1_udpport_t := SLV(10000, 16);                            
---- Local ports are statically connected to remote UDP ports  
--constant TXUDP_DESTPORT : txframe1_udpport_vector_t(0 to 15) := (      0 => SLV(10000, 16),  -- local port zero reserved for command frames (connected to default UDPdestport)
--                                                                 FF_PORT => SLV(12000, 16),  -- FF_PORT sends to UDP port group 12000..12015 (pattern 0xNNN[0] = 0x2EE0)
--                                                                 others  => SLV(10000, 16)); -- default UDPdestport (pattern 0xNNN[0] = 0x2710)
----
---- Note: All network nodes share the UDPport space 10000..10015 (master-to-slave and slave-to-slave communications allowed).
----       Slave side:  UDPports 10000..10015 are hardware-assigned to slave functions (i.e. CPU_PORT = 10001, port 10000 is reserved for commands).
----       Master side: UDPports 10000..10015 represent a 'pool' of 16 generic ports (process/threads choose a port-number from this 'pool',
----       slave nodes will reply to master-node request using received port numbers).
---- 
----       Master nodes use special UDPport interval 12000..12015 as fast-path rx queues
----       (slave ports send data to fast-path queues using nibble 'txdestport' as index).
----
-- file 'mac_globals.vhd'

-- ieee MAC pause-frame
constant TXPAUSE_DADDR : txframe1_byte_vector_t(0 to 5) := (x"01", x"80", x"C2", x"00", x"00", x"01");
constant TXPAUSE_LTYPE : txframe1_byte_vector_t(0 to 1) := (x"88", x"08");
constant TXPAUSE_CMD   : txframe1_byte_vector_t(0 to 1) := (x"00", x"01");
--
begin

   --
   -- tx frame
   --
   -- Frame transmission controlled by 'FSMtxframectrl':
   --
   -- FSMtxframectrl = S2 --> data frame transmission
   -- FSMtxframectrl = S3 --> command frame transmission
   -- FSMtxframectrl = S4 --> pause frame transmission
   --
   -- FSMtxframectrl = others --> waiting for transmission request
   --
   -- NOTE: assuming all parameters quasi-static (inputs do not change during
   -- frame transmission, logic combines inputs values with local registered values)
   --

   -- outputs defaults
   o.txrdreq := '0';

   -- txcrc defaults (clock domain clk2)
   n.txcrc.inputs.clk1 := i.clk2;
   n.txcrc.inputs.rst1 := i.rst2;
   n.txcrc.inputs.init := '0';
   n.txcrc.inputs.data := ro.gtxd1(7 downto 0);
   n.txcrc.inputs.datavalid := ro.gtx_crc1;

   -- MAC mapper drivers
   n.dest_nodeaddr  := ro.dnodeaddr;
   n.dest_multicast := ro.dmulticast;
   n.dest_broadcast := ro.dbroadcast;
   n.src_nodeaddr   := i.txnodeaddr;
   -- note: MAC mapper output vectors --> n.destaddr(5..0), n.srcaddr(5..0)

   -- nets defaults
   n.frame_done := '0';
   n.dcounter_load := '0';
   n.dcounter_inc := '0';
   n.gtxd := SLV(0, n.gtxd);
   n.gtx_en := '0';
   n.gtx_er := '0';
   n.gtx_crc := '0';
   n.gtx_wrreq := '0';

   case ro.FSMtxframe is
   when S0 =>
      --
      -- reset state
      --
      r.FSMtxframe := S1;

   when S1 =>
      --
      -- idle state, interframe timer start, crc32 init
      --
      r.interframe_timer := SLV(0, r.interframe_timer);
      n.txcrc.inputs.init := '1';
      r.txON := '0';

      r.FSMtxframe := S2_0;

   when S2_0 =>
      --
      -- interframe wait
      --
      if ro.interframe_timer >= INTERFRAME_GAP_clk then
         -- interframe delay done
         r.FSMtxframe := S2_1;
      else
         -- interframe_timer++
         r.interframe_timer := ro.interframe_timer + 1;
      end if;

   when S2_1 =>
      --
      -- txframe command decoder
      --
      if (ro.FSMtxframectrl = S4) then
         --
         -- txpause command (note: NOT blocked by pausetimer)
         --
         r.FSMtxframe := S2_2;
         --
         -- pause frame request: txpause without pause delay test
         -- (IEEE Std 802.3 - Annex 31B : "the PAUSE operation cannot
         -- be used to inhibit transmission of MAC control frames")
         --
      elsif (n.pausetimer_done = '1') then
         --
         -- pause delay done: txframe test
         --
         if (ro.FSMtxframectrl = S2) or (ro.FSMtxframectrl = S3) then
            -- txframe command
            r.FSMtxframe := S2_2;
         else
            -- wait
            null;
         end if;
      else
         --
         -- pause in progress, wait
         --
         null;
      end if;

   when S2_2 =>
      --
      -- txframe: MAC mapper init
      --

      -- txdata --> header from txport interface (default)
      r.dnodeaddr  := i.txdestaddr;
      r.dmulticast := i.txmulticast;
      r.dbroadcast := i.txbroadcast;
      if ro.FSMtxframectrl = S3 then
         -- txcmd --> header from cmd regs   
         r.dnodeaddr := ro.cmddestaddr;
         r.dmulticast := '0';
         r.dbroadcast := '0';
         -- note: commands use unicast destaddr
      end if;
      r.FSMtxframe := S2_3;

   when S2_3 =>
      --
      -- txframe: preamble counter init
      --
      r.pcounter := SLV(1, r.pcounter);
      r.txON := '1';
      r.FSMtxframe := S3_0;

      -- MAClut init (MAClut prepared using MAC mapper 'ro.dnodeaddr')
      n.maclut.inputs.rdinit := '1';
      n.maclut.inputs.rdpointer := ro.dnodeaddr(3 downto 0);
      -- note: macaddr rdpointer --> 4bit, maclut limited to 16 master nodes

   when S3_0 =>

      -- tx PREAMBLE
      n.gtxd(7 downto 0) := x"55";
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '0';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';

         -- pcounter test
         if ro.pcounter >= 7 then
            -- preamble done
            r.FSMtxframe := S3_1;
         end if;
         -- pcounter++
         r.pcounter := ro.pcounter + 1;

      end if;
      -- note: tx PREAMBLE takes 7 clocks --> during this interval
      -- MAClut has time to prepare first macaddress byte

   when S3_1 =>

      -- preamble done, tx SFD
      n.gtxd(7 downto 0) := x"D5";
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '0';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S4_0;
         -- pause frame test: PAUSE DADDR --> S10_0..S10_5
         if ro.FSMtxframectrl = S4 then
            r.FSMtxframe := S10_0;
         end if;
      end if;

   when S4_0 =>

      -- tx DADDR0
      n.gtxd(7 downto 0) := n.destaddr(0);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S4_1;
         n.maclut.inputs.rdnext := '1';
      end if;

   when S4_1 =>

      -- tx DADDR1
      n.gtxd(7 downto 0) := n.destaddr(1);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S4_2;
         n.maclut.inputs.rdnext := '1';
      end if;

   when S4_2 =>

      -- tx DADDR2
      n.gtxd(7 downto 0) := n.destaddr(2);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S4_3;
         n.maclut.inputs.rdnext := '1';
      end if;

   when S4_3 =>

      -- tx DADDR3
      n.gtxd(7 downto 0) := n.destaddr(3);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S4_4;
         n.maclut.inputs.rdnext := '1';
      end if;

   when S4_4 =>

      -- tx DADDR4
      n.gtxd(7 downto 0) := n.destaddr(4);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S4_5;
         n.maclut.inputs.rdnext := '1';
      end if;

   when S4_5 =>

      -- tx DADDR5
      n.gtxd(7 downto 0) := n.destaddr(5);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S5_0;
      end if;
      -- note: now maclut is free (maclut is a shared resource, cmd_macread uses maclut 
      -- to transmit selected macaddr) 

   when S5_0 =>

      -- tx SADDR0
      n.gtxd(7 downto 0) := n.srcaddr(0);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S5_1;
      end if;

   when S5_1 =>

      -- tx SADDR1
      n.gtxd(7 downto 0) := n.srcaddr(1);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S5_2;
      end if;

   when S5_2 =>

      -- tx SADDR2
      n.gtxd(7 downto 0) := n.srcaddr(2);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S5_3;
      end if;

   when S5_3 =>

      -- tx SADDR3
      n.gtxd(7 downto 0) := n.srcaddr(3);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S5_4;
      end if;

   when S5_4 =>

      -- tx SADDR4
      n.gtxd(7 downto 0) := n.srcaddr(4);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S5_5;
      end if;

   when S5_5 =>

      -- tx SADDR5
      n.gtxd(7 downto 0) := i.txnodeaddr;
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S6_0;
         -- pause frame test: PAUSE LTYPE --> S11_0
         if ro.FSMtxframectrl = S4 then
            r.FSMtxframe := S11_0;
         end if;
      end if;

   when S6_0 =>

      -- tx LTYPE0
      n.gtxd(7 downto 0) := TXIP_LTYPE(0);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S6_1;
      end if;

   when S6_1 =>

      -- tx LTYPE1
      n.gtxd(7 downto 0) := TXIP_LTYPE(1);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := IP_0;
      end if;

      -- MAClut init (MAClut prepared for command request 'cmd_macread')
      n.maclut.inputs.rdinit := '1';
      n.maclut.inputs.rdpointer := ro.cmdports(3 downto 0);
      -- note: rdpointer taken from cmdports field (4bit, maclut limited to 16 master nodes)

   --
   -- IP header begin
   --
   when IP_0 =>

      -- tx IP_VER
      n.gtxd(7 downto 0) := TXIP_VER_TOS(0);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := IP_1;
      end if;

   when IP_1 =>

      -- tx IP_TOS
      n.gtxd(7 downto 0) := TXIP_VER_TOS(1);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := IP_2;
      end if;

   when IP_2 =>

      -- tx IP_LEN
      n.gtxd(7 downto 0) := SLV(ro.ipframelen, 16)(15 downto 8);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := IP_3;
      end if;

   when IP_3 =>

      -- tx IP_LEN
      n.gtxd(7 downto 0) := SLV(ro.ipframelen, 16)(7 downto 0);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := IP_4;
      end if;

   when IP_4 =>

      -- tx IP_IDENT 
      n.gtxd(7 downto 0) := i.txseqnum(15 downto 8); -- default: txseqnum(1)
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      -- tx command test
      if ro.FSMtxframectrl = S3 then
         n.gtxd(7 downto 0) := ro.cmdcode;
         -- note: command frame uses (cmdcode, cmdports) as identifier
      end if;

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := IP_5;
      end if;

   when IP_5 =>

      -- tx IP_IDENT
      n.gtxd(7 downto 0) := i.txseqnum(7 downto 0); -- default: txseqnum(0)
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      -- tx command test
      if ro.FSMtxframectrl = S3 then
         n.gtxd(7 downto 0) := ro.cmdports;
         -- note: command frame uses (cmdcode, cmdports) as identifier
      end if;

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := IP_6;
      end if;

   when IP_6 =>

      -- tx IP_FRAG
      n.gtxd(7 downto 0) := TXIP_FRAG(0);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := IP_7;
      end if;

   when IP_7 =>

      -- tx IP_FRAG
      n.gtxd(7 downto 0) := TXIP_FRAG(1);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := IP_8;
      end if;

   when IP_8 =>

      -- tx IP_TTL
      n.gtxd(7 downto 0) := TXIP_TTL_PROT(0);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := IP_9;
      end if;

   when IP_9 =>

      -- tx IP_PROT
      n.gtxd(7 downto 0) := TXIP_TTL_PROT(1);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := IP_10;
      end if;

   when IP_10 =>

      -- tx IP_CHKSUM
      n.gtxd(7 downto 0) := NOT(SLV(ro.ipchksum, 16)(15 downto 8));
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := IP_11;
      end if;

   when IP_11 =>

      -- tx IP_CHKSUM
      n.gtxd(7 downto 0) := NOT(SLV(ro.ipchksum, 16)(7 downto 0));
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := IP_12;
      end if;

   when IP_12 =>

      -- tx IP_SADDR
      n.gtxd(7 downto 0) := n.ipsrcaddr(31 downto 24);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := IP_13;
      end if;

   when IP_13 =>

      -- tx IP_SADDR
      n.gtxd(7 downto 0) := n.ipsrcaddr(23 downto 16);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := IP_14;
      end if;

   when IP_14 =>

      -- tx IP_SADDR
      n.gtxd(7 downto 0) := n.ipsrcaddr(15 downto 8);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := IP_15;
      end if;

   when IP_15 =>

      -- tx IP_SADDR
      n.gtxd(7 downto 0) := n.ipsrcaddr(7 downto 0);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := IP_16;
      end if;

   when IP_16 =>

      -- tx IP_DADDR
      n.gtxd(7 downto 0) := n.ipdestaddr(31 downto 24);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := IP_17;
      end if;

   when IP_17 =>

      -- tx IP_DADDR
      n.gtxd(7 downto 0) := n.ipdestaddr(23 downto 16);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := IP_18;
      end if;

   when IP_18 =>

      -- tx IP_DADDR
      n.gtxd(7 downto 0) := n.ipdestaddr(15 downto 8);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := IP_19;
      end if;

   when IP_19 =>

      -- tx IP_DADDR
      n.gtxd(7 downto 0) := n.ipdestaddr(7 downto 0);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := UDP_0;
      end if;

   --
   -- UDP header begin
   --
   when UDP_0 =>

      -- tx TXUDP_SRCPORT
      n.gtxd(7 downto 0) := TXUDP_SRCPORT(15 downto 8);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := UDP_1;
      end if;

   when UDP_1 =>

      -- tx TXUDP_SRCPORT
      n.gtxd(7 downto 0) := TXUDP_SRCPORT(7 downto 4) & i.txportaddr;
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      -- tx command test
      if ro.FSMtxframectrl = S3 then
         n.gtxd(3 downto 0) := "0000";
         -- note: commands are transmitted from dedicated local portaddr zero
      end if;

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := UDP_2;
      end if;

   when UDP_2 =>

      -- tx TXUDP_DESTPORT
      n.gtxd(7 downto 0) := TXUDP_DESTPORT(UINT(i.txportaddr))(15 downto 8); -- default: data frame
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      -- tx command test
      if ro.FSMtxframectrl = S3 then
         n.gtxd(7 downto 0) := TXUDP_DESTPORT(0)(15 downto 8);
         -- note: command frame uses TXUDP_DESTPORT() indexed by dedicated local portaddr zero
      end if;

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := UDP_3;
      end if;

   when UDP_3 =>

      -- tx TXUDP_DESTPORT
      n.gtxd(7 downto 0) := TXUDP_DESTPORT(UINT(i.txportaddr))(7 downto 4) & i.txdestport; -- default: data frame
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      -- tx command test
      if ro.FSMtxframectrl = S3 then
         n.gtxd(7 downto 4) := TXUDP_DESTPORT(0)(7 downto 4);
         n.gtxd(3 downto 0) := ro.cmddestport;
         -- note: command frame uses TXUDP_DESTPORT() indexed by dedicated local portaddr zero;
         --       command frame is transmitted to remote UDP port 'cmddestport'
      end if;

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := UDP_4;
      end if;

   when UDP_4 =>

      -- tx TXUDP_LENGTH
      n.gtxd(7 downto 0) := SLV(ro.udpframelen, 16)(15 downto 8);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := UDP_5;
      end if;

   when UDP_5 =>

      -- tx TXUDP_LENGTH
      n.gtxd(7 downto 0) := SLV(ro.udpframelen, 16)(7 downto 0);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := UDP_6;
      end if;

   when UDP_6 =>

      -- tx TXUDP_CHKSUM
      n.gtxd(7 downto 0) := "00000000";
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := UDP_7;
      end if;

   when UDP_7 =>

      -- tx TXUDP_CHKSUM
      n.gtxd(7 downto 0) := "00000000";
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      -- !! optional header(10) !!
      if OPTIONAL_DATA_FRAME_HEADER = 1 then
      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S6_2;
      end if;
      else
      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';

         -- dcounter init
         n.dcounter_load := '1';
         -- note: counters + registered counter_test_flags will be valid next clock cycle

         -- cmd/pad/data test (DATA frame without header --> pad/data test from S6_11)
         if ro.FSMtxframectrl = S3 then
            -- command frame: continue with CMD header
            r.FSMtxframe := S6_2;
            -- note: this test has max priority --> flags 'datalen_NNNN' are not valid when 
            -- command frame selected
         elsif ro.datalen_null = '1' then
            -- datafield not present: tx CRC
            r.FSMtxframe := S8_0;
            -- note: this condition should never appear, frame should not be shorter than IP/UDP header...
         elsif ro.datalen_zero = '1' then
            -- datalen is zero: pad field request (at least one pad-byte to output)
            r.FSMtxframe := S7_1;
         else
            -- datalen > 0: fifo not empty, fifo read request to prepare first data-byte
            --o.txrdreq := '1'; !!! note: txport showahead fifo !!!
            -- tx data (at least one data-byte to output)
            r.FSMtxframe := S7_0;
         end if;
      end if;
      end if;
      -- !! optional header(10) !!

   --
   -- DATA/CMD header begin
   --
   when S6_2 =>

      -- tx HEADER DADDR
      n.gtxd(7 downto 0) := i.txdestaddr; -- default      
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      -- tx command test
      if ro.FSMtxframectrl = S3 then
         n.gtxd(7 downto 0) := ro.cmddestaddr;
      end if;

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S6_3;
      end if;

   when S6_3 =>

      -- tx HEADER SADDR
      n.gtxd(7 downto 0) := i.txnodeaddr;
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S6_4;
      end if;

   when S6_4 =>

      -- tx HEADER CMD
      n.gtxd(7 downto 0) := x"00"; -- default      
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      -- multicast flag (bit7)
      n.gtxd(7) := i.txmulticast;

      -- tx command test
      if ro.FSMtxframectrl = S3 then
         n.gtxd(7 downto 0) := ro.cmdcode;
         -- note: commands are transmitted using unicast destaddr --> there is NO multicast flag
         -- (bit7 works as command echo flag)
      end if;

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S6_5;
      end if;

   when S6_5 =>

      -- tx HEADER PORTS
      n.gtxd(7 downto 4) := i.txdestport; -- default
      n.gtxd(3 downto 0) := i.txportaddr; --
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      -- tx command test
      if ro.FSMtxframectrl = S3 then
         n.gtxd(7 downto 0) := ro.cmdports;
      end if;

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S6_6;
      end if;
      -- note: next clock cycle MAClut output is ready ('MACread' command returns data using
      -- last 6 bytes of HEADER)

   when S6_6 =>

      -- tx HEADER SEQNUM0 (lsb) ??? msb,lsb
      n.gtxd(7 downto 0) := i.txseqnum(7 downto 0); -- default
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      -- tx command test
      if ro.FSMtxframectrl = S3 then
         n.gtxd(7 downto 0) := ro.cmdparams(0);
         if ro.cmd_macread = '1' then
            -- MACread command: cmdparams field taken from maclut
            n.gtxd(7 downto 0) := n.maclut.outputs.q;
            r.macread_data(0)  := n.maclut.outputs.q; -- macread data updated
         end if;
      end if;

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S6_7;
         n.maclut.inputs.rdnext := '1';
      end if;

   when S6_7 =>

      -- tx HEADER SEQNUM1
      n.gtxd(7 downto 0) := i.txseqnum(7+8 downto 0+8); -- default
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      -- tx command test
      if ro.FSMtxframectrl = S3 then
         n.gtxd(7 downto 0) := ro.cmdparams(1);
         if ro.cmd_macread = '1' then
            -- MACread command: cmdparams field taken from maclut
            n.gtxd(7 downto 0) := n.maclut.outputs.q;
            r.macread_data(1)  := n.maclut.outputs.q; -- macread data updated
         end if;
      end if;

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S6_8;
         n.maclut.inputs.rdnext := '1';
      end if;

   when S6_8 =>

      -- tx HEADER SEQNUM2
      n.gtxd(7 downto 0) := i.txseqnum(7+16 downto 0+16); -- default
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      -- tx command test
      if ro.FSMtxframectrl = S3 then
         n.gtxd(7 downto 0) := ro.cmdparams(2);
         if ro.cmd_macread = '1' then
            -- MACread command: cmdparams field taken from maclut
            n.gtxd(7 downto 0) := n.maclut.outputs.q;
            r.macread_data(2)  := n.maclut.outputs.q; -- macread data updated
         end if;
      end if;

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S6_9;
         n.maclut.inputs.rdnext := '1';
      end if;

   when S6_9 =>

      -- tx HEADER SEQNUM3 (msb) ???? oppure msb,lsb
      n.gtxd(7 downto 0) := i.txseqnum(7+24 downto 0+24); -- default
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      -- tx command test
      if ro.FSMtxframectrl = S3 then
         n.gtxd(7 downto 0) := ro.cmdparams(3);
         if ro.cmd_macread = '1' then
            -- MACread command: cmdparams field taken from maclut
            n.gtxd(7 downto 0) := n.maclut.outputs.q;
            r.macread_data(3)  := n.maclut.outputs.q; -- macread data updated
         end if;
      end if;

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S6_10;
         n.maclut.inputs.rdnext := '1';
      end if;

   when S6_10 =>

      -- tx LDATA0 (msb)
      n.gtxd(7 downto 0) := SLV(ro.datalen, 16)(15 downto 8); -- default
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      -- tx command test
      if ro.FSMtxframectrl = S3 then
         n.gtxd(7 downto 0) := ro.cmdparams(4);
         if ro.cmd_macread = '1' then
            -- MACread command: cmdparams field taken from maclut
            n.gtxd(7 downto 0) := n.maclut.outputs.q;
            r.macread_data(4)  := n.maclut.outputs.q; -- macread data updated
         end if;
      end if;

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S6_11;
         n.maclut.inputs.rdnext := '1';
      end if;

   when S6_11 =>

      -- tx LDATA1 (lsb)
      n.gtxd(7 downto 0) := SLV(ro.datalen, 16)(7 downto 0); -- default
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      -- tx command test
      if ro.FSMtxframectrl = S3 then
         n.gtxd(7 downto 0) := ro.cmdparams(5);
         if ro.cmd_macread = '1' then
            -- MACread command: cmdparams field taken from maclut
            n.gtxd(7 downto 0) := n.maclut.outputs.q;
            r.macread_data(5)  := n.maclut.outputs.q; -- macread data updated
         end if;
      end if;

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';

         -- dcounter init
         n.dcounter_load := '1';
         -- note: counters + registered counter_test_flags will be valid next clock cycle

         -- pad/data test
         if ro.FSMtxframectrl = S3 then
            -- command frame: pad field request (at least one pad-byte to output)
            r.FSMtxframe := S7_1;
            -- note: this test has max priority --> flags 'datalen_NNNN' are not valid when 
            -- command frame selected
         elsif ro.datalen_null = '1' then
            -- datafield not present: tx CRC
            r.FSMtxframe := S8_0;
            -- note: this condition should never appear, frame should be bigger than header...
         elsif ro.datalen_zero = '1' then
            -- datalen is zero: pad field request (at least one pad-byte to output)
            r.FSMtxframe := S7_1;
         else
            -- datalen > 0: fifo not empty, fifo read request to prepare first data-byte
            --o.txrdreq := '1'; !!! note: txport showahead fifo !!!
            -- tx data (at least one data-byte to output)
            r.FSMtxframe := S7_0;
         end if;

      end if;

   when S7_0 =>

      -- tx data from txfifo
      n.gtxd(7 downto 0) := i.txdata(7 downto 0);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';

         -- length test
         if ro.dcounter_test = '1' then
            -- datalen done: tx CRC
            r.FSMtxframe := S8_0;
         elsif ro.lcounter_test = '1' then
            -- dcounter++
            n.dcounter_inc := '1';
            -- ldata done, to zero pad field
            r.FSMtxframe := S7_1;
         else
            -- dcounter++
            n.dcounter_inc := '1';
            -- next (assuming fifo not empty)
            o.txrdreq := '1';
         end if;

      end if;

   when S7_1 =>

      -- tx zero pad field (at least one pad-byte to output)
      n.gtxd(7 downto 0) := x"00";
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';

         -- frame len test
         if ro.dcounter_test = '1' then
            -- datalen done : tx CRC
            r.FSMtxframe := S8_0;
         else
            -- dcounter++
            n.dcounter_inc := '1';
         end if;

      end if;

   when S8_0 =>

      -- tx CRC0
      n.gtxd(7 downto 0) := n.txcrc.outputs.fcs(7 downto 0);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '0';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S8_1;
      end if;

   when S8_1 =>

      -- tx CRC1
      n.gtxd(7 downto 0) := n.txcrc.outputs.fcs(15 downto 8);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '0';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S8_2;
      end if;

   when S8_2 =>

      -- tx CRC2
      n.gtxd(7 downto 0) := n.txcrc.outputs.fcs(23 downto 16);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '0';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S8_3;
      end if;

   when S8_3 =>

      -- tx CRC3
      n.gtxd(7 downto 0) := n.txcrc.outputs.fcs(31 downto 24);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '0';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S8_4;
      end if;

   when S8_4 =>

      -- end of frame (gtx register clear op)
      n.gtxd(7 downto 0) := x"00";
      n.gtx_en := '0';
      n.gtx_er := '0';
      n.gtx_crc := '0';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S9;
      end if;
      -- note: gtx register clear op --> gtx_wrreq with gtx_en = '0'

   when S9 =>

      -- frame done
      n.frame_done := '1';
      r.FSMtxframe := S1;

   when S10_0 =>

      -- tx PAUSE DADDR0
      n.gtxd(7 downto 0) := TXPAUSE_DADDR(0);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S10_1;
      end if;

   when S10_1 =>

      -- tx PAUSE DADDR1
      n.gtxd(7 downto 0) := TXPAUSE_DADDR(1);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S10_2;
      end if;

   when S10_2 =>

      -- tx PAUSE DADDR2
      n.gtxd(7 downto 0) := TXPAUSE_DADDR(2);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S10_3;
      end if;

   when S10_3 =>

      -- tx PAUSE DADDR3
      n.gtxd(7 downto 0) := TXPAUSE_DADDR(3);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S10_4;
      end if;

   when S10_4 =>

      -- tx PAUSE DADDR4
      n.gtxd(7 downto 0) := TXPAUSE_DADDR(4);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S10_5;
      end if;

   when S10_5 =>

      -- tx PAUSE DADDR5
      n.gtxd(7 downto 0) := TXPAUSE_DADDR(5);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S5_0;
      end if;
      -- note: continue with standard SADDR --> S5_0..S5_5

   when S11_0 =>

      -- tx PAUSE LTYPE0
      n.gtxd(7 downto 0) := TXPAUSE_LTYPE(0);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S11_1;
      end if;

   when S11_1 =>

      -- tx PAUSE LTYPE1
      n.gtxd(7 downto 0) := TXPAUSE_LTYPE(1);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S12_0;
      end if;

   when S12_0 =>

      -- tx PAUSE CMD0 (msb)
      n.gtxd(7 downto 0) := TXPAUSE_CMD(0);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S12_1;
      end if;

   when S12_1 =>

      -- tx PAUSE CMD1 (lsb)
      n.gtxd(7 downto 0) := TXPAUSE_CMD(1);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         -- pause frame: dcounter init
         n.dcounter_load := '1';
         r.FSMtxframe := S13_0;
      end if;

   when S13_0 =>

      -- tx PAUSE QUANTA0 (msb)
      n.gtxd(7 downto 0) := ro.txpausequanta(15 downto 8);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         r.FSMtxframe := S13_1;
      end if;

   when S13_1 =>

      -- tx PAUSE QUANTA1 (lsb)
      n.gtxd(7 downto 0) := ro.txpausequanta(7 downto 0);
      n.gtx_en := '1';
      n.gtx_er := '0';
      n.gtx_crc := '1';

      if n.gtx_full = '0' then
         n.gtx_wrreq := '1';
         -- pause frame: registers 'dcounter,dcounter_test' are ready;
         -- pad-field-len > 0 --> to S7_1 (at least one pad-byte to output)
         r.FSMtxframe := S7_1;
      end if;

   end case;

   --
   -- datalen test logic (always ON, test results registered)
   --
   r.datalen_null := '0';
   r.datalen_zero := '0';
   r.datalen      := SLV(0, r.datalen);
   r.datafieldlen := SLV(0, r.datafieldlen);
   -- !! optional header(10) !!
   if OPTIONAL_DATA_FRAME_HEADER = 1 then
   if UINT(i.txframelen) <= (10+28) then
      -- header-only frame --> datafield not present, padfield not present
      -- (note: frame should not be shorter than header...)
      r.datalen_null := '1';
   else
      -- current datafieldlen >= 1 
      r.datafieldlen := SLV(UINT(i.txframelen) - (10+28), r.datafieldlen);
      --
      if UINT(i.txdatalen) = 0 then
         -- fifo-len is zero, datafieldlen >= 1 --> zero datalen, padfield is present 
         r.datalen_zero := '1';
      end if;
      -- 
      if UINT(i.txdatalen) >= UINT(r.datafieldlen) then
         -- fifo-len >= datafieldlen >= 1 --> datafield full (datalen = datafieldlen), padfield not present  
         r.datalen := r.datafieldlen;
      else
         -- fifo-len < datafieldlen --> datafield not full (datalen = fifo-len), padfield is present 
         r.datalen := i.txdatalen;
      end if;
      -- note: we use current calculated 'datafieldlen' (r.NNNNNNN)
   end if;
   -- note: datalen logic is always ON but 'ro.datafieldlen','ro.datalen','ro.datalen_NNNNN' 
   -- are valid only when txdata frame selected (ro.FSMtxframectrl = S2)
   else
   --if UINT(i.txframelen) <= (10+28) then -- !! optional header(10) !!
   if UINT(i.txframelen) <= (28) then 
      -- header-only frame --> datafield not present, padfield not present
      -- (note: frame should not be shorter than IP/UDP header...)
      r.datalen_null := '1';
   else
      -- current datafieldlen >= 1 
      --r.datafieldlen := SLV(UINT(i.txframelen) - (10+28), r.datafieldlen); -- !! optional header(10) !!
      r.datafieldlen := SLV(UINT(i.txframelen) - (28), r.datafieldlen);
      --
      if UINT(i.txdatalen) = 0 then
         -- fifo-len is zero, datafieldlen >= 1 --> zero datalen, padfield is present 
         r.datalen_zero := '1';
      end if;
      -- 
      if UINT(i.txdatalen) >= UINT(r.datafieldlen) then
         -- fifo-len >= datafieldlen >= 1 --> datafield full (datalen = datafieldlen), padfield not present  
         r.datalen := r.datafieldlen;
      else
         -- fifo-len < datafieldlen --> datafield not full (datalen = fifo-len), padfield is present 
         r.datalen := i.txdatalen;
      end if;
      -- note: we use current calculated 'datafieldlen' (r.NNNNNNN)
   end if;
   -- note: datalen logic is always ON but 'ro.datafieldlen','ro.datalen','ro.datalen_NNNNN' 
   -- are valid only when txdata frame selected (ro.FSMtxframectrl = S2)
   end if;
   -- !! optional header(10) !!

   --
   -- dcounter control logic (note: logic works for any cmd/data/pause frame)
   --
   if n.dcounter_load = '1' then
      -- load command: datafieldlen,datalen captured
      r.dcounter := SLV(65536 - UINT(ro.datafieldlen) + 1, r.dcounter'length);
      r.lcounter := SLV(65536 - UINT(ro.datalen)      + 1, r.lcounter'length);
      -- command frame test: datafield minimum length (6+6+2+28+10+[8]+4 = 64)
      if ro.FSMtxframectrl = S3 then 
         r.dcounter := SLV(65536 - (8) + 1, r.dcounter'length);
      end if;
      -- pause frame test: datafield minimum length (6+6+2+2+2+[42]+4 = 64)
      if ro.FSMtxframectrl = S4 then 
         r.dcounter := SLV(65536 - (42) + 1, r.dcounter'length);
      end if;
      -- note: 'dcounter' overwritten when command/pause frames because 'ro.datafieldlen','ro.datalen' are
      -- not valid (only 'dcounter' is used for command/pause frames, 'lcounter' ignored)
   elsif n.dcounter_inc = '1' then
      -- inc command (both counters incremented)
      r.dcounter := ro.dcounter + 1;
      r.lcounter := ro.lcounter + 1;
   end if;

   -- dcounter test logic (r.NNNNNN --> registered test flag aligned with 'dcounter')
   r.dcounter_test := '0';
   if r.dcounter >= 65536 then
      r.dcounter_test := '1';
   end if;

   -- lcounter test logic (r.NNNNNN --> registered test flag aligned with 'lcounter')
   r.lcounter_test := '0';
   if r.lcounter >= 65536 then
      r.lcounter_test := '1';
   end if;

   --
   -- IP/UDP total length
   --
   -- !! optional header(10) !!
   if OPTIONAL_DATA_FRAME_HEADER = 1 then
   r.ipframelen  := SLV(UINT(ro.datalen) + (20+8+10), r.ipframelen'length); -- default: data frame
   r.udpframelen := SLV(UINT(ro.datalen) + (8+10), r.udpframelen'length);   --
   else
   --r.ipframelen  := SLV(UINT(ro.datalen) + (20+8+10), r.ipframelen'length); -- default: data frame -- !! optional header(10) !!
   --r.udpframelen := SLV(UINT(ro.datalen) + (8+10), r.udpframelen'length);   --                     -- !! optional header(10) !!
   r.ipframelen  := SLV(UINT(ro.datalen) + (20+8), r.ipframelen'length); -- default: data frame
   r.udpframelen := SLV(UINT(ro.datalen) + (8), r.udpframelen'length);   --
   end if;
   -- !! optional header(10) !!
   if ro.FSMtxframectrl = S3 then
      r.ipframelen  := SLV((0) + (20+8+10), r.ipframelen'length);
      r.udpframelen := SLV((0) + (8+10), r.udpframelen'length);
      -- note: command frames are transmitted using header-only-frames ('ro.datalen' is not valid when command frame selected)
   end if;

   --
   -- IP destaddr mapper
   --
   if ro.FSMtxframectrl = S3 then
      -- command frames are transmitted to unicast destaddr (max priority)
      n.ipdestaddr := TXIP_DADDR(0) & TXIP_DADDR(1) & TXIP_DADDR(2) & ro.cmddestaddr; 
      n.ipbasechksum := TXIP_CHKSUM_UCAST; 
   elsif i.txbroadcast = '1' then
      -- broadcast address (high priority)
      n.ipdestaddr := TXIP_BADDR(0) & TXIP_BADDR(1) & TXIP_BADDR(2) & TXIP_BADDR(3); 
      n.ipbasechksum := TXIP_CHKSUM_BCAST; 
   elsif i.txmulticast = '1' then
      -- multicast address (mid priority)
      n.ipdestaddr := TXIP_MADDR(0) & TXIP_MADDR(1) & TXIP_MADDR(2) & i.txdestaddr;
      n.ipbasechksum := TXIP_CHKSUM_MCAST; 
   else
      -- unicast address (low priority)
      n.ipdestaddr := TXIP_DADDR(0) & TXIP_DADDR(1) & TXIP_DADDR(2) & i.txdestaddr; 
      n.ipbasechksum := TXIP_CHKSUM_UCAST; 
   end if;
   --
   -- Note: constants TXIP_CHKSUM_UCAST/MCAST/BCAST are pre-calculated 
   --       using corresponding TX_IP_DADDR/MADDR/BADDR(0..1)
   --

   --
   -- IP srcaddr mapper
   --
   ---- multi-homing mode (one IP srcaddr for each destport --> UDPdestport duplicated into IPsrcaddr)
   --n.ipsrcaddr := TXIP_SADDR(0) & TXIP_SADDR(1) & "0000" & i.txdestport & i.txnodeaddr; -- default: data frame
   --if ro.FSMtxframectrl = S3 then
   --   n.ipsrcaddr := TXIP_SADDR(0) & TXIP_SADDR(1) & "0000" & ro.cmddestport & i.txnodeaddr;
   --   -- note: command frame is transmitted to remote UDP port 'cmddestport'
   --end if;
   -- !!!!! nota: per il momento la versione multi-homing non viene usata...vedi rxhashing/RSS/MDI-X scheda 10Gbit intel vs broadcom 
   -- single IP mode
   n.ipsrcaddr := TXIP_SADDR(0) & TXIP_SADDR(1) & TXIP_SADDR(2) & i.txnodeaddr; -- subnet defined by TXIP_SADDR(2)
   --n.ipsrcaddr := TXIP_SADDR(0) & TXIP_SADDR(1) & "00000000" & i.txnodeaddr; -- subnet zero !! Debug !!

   --
   -- IP checksum
   --
   -- checksum = Base_Checksum + Variable_Params = 
   --          = Base_Checksum + Total_Length + Identification + SrcAddr(2..3) + DestAddr(2..3) 
   --
   r.ipchksum0 := n.ipbasechksum + UINT(ro.ipframelen);
   r.ipchksum1 := ro.ipchksum0   + UINT(i.txseqnum(15 downto 0));
   if ro.FSMtxframectrl = S3 then
      r.ipchksum1 := ro.ipchksum0 + UINT(ro.cmdcode(7 downto 0) & ro.cmdports(7 downto 0));
      -- note: command frame uses (cmdcode, cmdports) as identifier
   end if;
   r.ipchksum2 := ro.ipchksum1   + UINT(n.ipsrcaddr(15 downto 0));
   r.ipchksum3 := ro.ipchksum2   + UINT(n.ipdestaddr(15 downto 0)); 
   -- 1st carry level
   r.ipchksum4 := SLV(UINT(ro.ipchksum3(15 downto 0)) + UINT(ro.ipchksum3(31 downto 16)), r.ipchksum4); 
   -- 2nd carry level
   r.ipchksum  := SLV(UINT(ro.ipchksum4(15 downto 0)) + UINT(ro.ipchksum4(31 downto 16)), r.ipchksum); 
   --
   -- Note: checksum calculation takes 6 clock cycles (adders always ON: all frame params do not 
   --       change during frame transmission)
   --

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
   n.txcrc.outputs := allcmps.txcrc.outputs;
   n.maclut.outputs := allcmps.maclut.outputs;

   --
   -- all procedures call (edit)
   --

   -- clock domain: clk2
   SubFSMtxframectrl(i, ri.clk2, ro.clk2, o, r.clk2, n);
   SubPauseTimer    (i, ri.clk2, ro.clk2, o, r.clk2, n);
   SubFSMmaclutwrite(i, ri.clk2, ro.clk2, o, r.clk2, n);
   SubMACaddress    (i, ri.clk2, ro.clk2, o, r.clk2, n);
   SubFSMtxframe    (i, ri.clk2, ro.clk2, o, r.clk2, n);
   SubGMIIoutput    (i, ri.clk2, ro.clk2, o, r.clk2, n);

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
-- architecture rtl of txframe1
--
--**************************************************************
