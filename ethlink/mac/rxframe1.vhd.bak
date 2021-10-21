--**************************************************************
--**************************************************************
--
-- Template file: comp_ck2.rec (new component, dual clk)
--
--**************************************************************
--**************************************************************
--
--
-- Component rxframe1
--
-- Frame rx logic: 
--
-- - frame format:
--   preamble(7)/SFD(1)/dest(6)/src(6)/ltype(2)/ipheader(20+4*[0..10])/udpheader(8)/udpdata(..)/crc(4)
--   
-- - udpdata format:
--   header(10)/data(..)
--
--   header format:
--   rxdata  : daddr(1)/saddr(1)/cmd(1)/ports(1)/seqnum(4)/ldata(2) (cmd.code == 0)  
--   rxcmd   : daddr(1)/saddr(1)/cmd(1)/ports(1)/cmdparams(6)       (cmd.code <> 0)
--   rxpause : cmdpause(2)/txquanta(2)/padzero(6)  
--
-- - programmable max frame length = 0..16383 (14bit) 
-- - ldata-field contains true data-length (i.e. rxdata shorter than data field length) 
-- - rxdata written to rxport array: ports are indexed by rxdestport output
--   (valid port address 1..NPORTS, address 0 reserved)
-- - rx enable/disable input
-- - input data read from gmii interface
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
use work.globals.all;

package component_rxframe1 is

--
-- local typedefs (edit)
--
subtype rxframe1_byte_t is std_logic_vector(7 downto 0);
type rxframe1_byte_vector_t is array(NATURAL RANGE <>) of rxframe1_byte_t;

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- rxframe1 inputs (edit)
--
type rxframe1_inputs_t is record

   -- clock list
   clk1 : std_logic;
   clk2 : std_logic; 
   -- NOTE: clk2 is driven by gmii_rxc (rx-interface), 
   --       clk1 is driven by tx_clk (common tx/rx clock domain)

   -- reset list
   rst1 : std_logic;
   rst2 : std_logic;
   -- NOTE: all resets must be async asserted, sync deasserted

   -- Rx frame (clock domain clk1,rst1)

   -- rxframe globals
   enable        : std_logic;
   maxframelen   : std_logic_vector(13 downto 0);
   nodeaddr      : std_logic_vector(7 downto 0);
   multicastaddr : std_logic_vector(7 downto 0);
   --
   -- enable        --> global enable (??? nota: per il momento e' solo un comando di rxframe-read-side pause, la rxframe-write-side e' sempre ON)
   -- maxframelen   --> frame maxlength (0..16383, 14bit)
   --                   maxlength = dest(6)+src(6)+ltype(2)+ipheader(20+4*[0..10])+udpheader(8)+header(10)+data(..)+crc(4) = 46+10..16383 
   -- nodeaddr      --> node address (8bit)
   -- multicastaddr --> multicast groupaddr (8bit)
   --

   -- header filter modes
   mode_destaddr_unicast   : std_logic;
   mode_destaddr_multicast : std_logic;
   mode_destaddr_broadcast : std_logic;
   mode_pause              : std_logic;
   mode_data               : std_logic;
   mode_cmd                : std_logic;
   --
   -- mode_destaddr_unicast       ('1' destaddr=unicast recognized, '0' filtered out)
   -- mode_destaddr_multicast     ('1' destaddr=multicast recognized, '0' filtered out)
   -- mode_destaddr_broadcast     ('1' destaddr=broadcast recognized, '0' filtered out)
   -- mode_pause                  ('1' pause frame recognized, '0' filtered out)
   -- mode_data                   ('1' data  frame recognized, '0' filtered out)
   -- mode_cmd                    ('1' cmd   frame recognized, '0' filtered out)
   --

   -- command frame interface
   cmdread : std_logic; 
   --
   -- cmdread --> single register output fifo read ack (pulse, 1 clock) 
   --
   
   -- Rx frame (clock domain clk2,rst2)

   -- gmii rx-interface (8bit, rxc single edge)
   --grxc : std_logic; --> clk2 input
   grx_en : std_logic;
   grx_er : std_logic;
   grxd : std_logic_vector(7 downto 0);

end record;

--
-- rxframe1 outputs (edit)
--
type rxframe1_outputs_t is record

   -- Rx frame (clock domain clk1, rst1)

   -- rxenable status flag
   rxenablests : std_logic;
 
   -- rxdata output port
   rxdata      : std_logic_vector(7 downto 0);
   rxdatalen   : std_logic_vector(13 downto 0);
   rxdestaddr  : std_logic_vector(7 downto 0);
   rxmulticast : std_logic;
   rxsrcaddr   : std_logic_vector(7 downto 0);
   rxdestport  : std_logic_vector(3 downto 0);
   rxsrcport   : std_logic_vector(3 downto 0);
   rxseqnum    : std_logic_vector(31 downto 0);
   rxldata     : std_logic_vector(15 downto 0);
   rxwrreq     : std_logic;
   rxframeok   : std_logic; 
   rxframedone : std_logic;
   --
   -- rxdata      --> frame data (8bit)
   -- rxdatalen   --> frame datafield length (13bit)
   -- rxdestaddr  --> param destaddr (8bit)
   -- rxmulticast --> param multicast ('1' rxdestaddr is a groupaddr, '0' rxdestaddr is a node address)
   -- rxsrcaddr   --> param srcaddr (8bit)
   -- rxdestport  --> param destport (4bit, valid range 1..15, destport = 0 reserved)
   -- rxsrcport   --> param srcport (4bit, valid range 1..15, destport = 0 reserved)
   -- rxseqnum    --> param seqnum (32bit)
   -- rxldata     --> param ldata (16bit)
   -- rxwrreq     --> rxport wrreq 
   -- rxframeok   --> rxport write in progress (level) 
   -- rxframedone --> rxdata write done (pulse, 1 clock)
   --

   -- pause outputs
   pausequanta : std_logic_vector(15 downto 0);
   pausedone   : std_logic;
   --
   -- pausequanta --> last received pausequanta (16bit)
   -- pausedone   --> pause frame received (pulse, 1 clock)
   --

   -- command frame interface
   cmdready : std_logic;
   cmdsrcport  : std_logic_vector(3 downto 0);
   cmddestaddr : std_logic_vector(7 downto 0);
   cmdsrcaddr : std_logic_vector(7 downto 0);
   cmdcode : std_logic_vector(7 downto 0);
   cmdports : std_logic_vector(7 downto 0);
   cmdparams : rxframe1_byte_vector_t(0 to 5);
   cmddone   : std_logic;
   --
   -- cmdready    --> command is ready (single register output fifo, showahead mode,
   --                 flag cleared when input 'cmdread' asserted) 
   -- cmdsrcport  --> cmd udp srcport (4bit)
   -- cmddestaddr --> cmd header(0): destaddr (8bit)
   -- cmdsrcaddr  --> cmd header(1): srcaddr (8bit)
   -- cmdcode     --> cmd header(2): code (8bit)
   -- cmdports    --> cmd header(3): ports (8bit)
   -- cmdparams   --> cmd header(4 to 9): params (6 x 8bit)
   -- cmddone     --> command frame received (pulse, 1 clock)
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
-- rxframe1 component common interface (constant)
--
type rxframe1_t is record
   inputs : rxframe1_inputs_t;
   outputs : rxframe1_outputs_t;
end record;

--
-- rxframe1 vector type (constant)
--
type rxframe1_vector_t is array(NATURAL RANGE <>) of rxframe1_t;

--
-- rxframe1 component declaration (constant)
--
component rxframe1
port (
   inputs : in rxframe1_inputs_t;
   outputs : out rxframe1_outputs_t
);
end component;

end component_rxframe1;

--
-- rxframe1 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.globals.all;
use work.component_rxframe1.all;
use work.component_rxdatabuf1.all;
use work.component_rxtagbuf1.all;
use work.component_crc32.all;

-- rxframe1 entity (constant)
entity rxframe1 is
port (
   inputs : in rxframe1_inputs_t;
   outputs : out rxframe1_outputs_t
);
end rxframe1;

--**************************************************************
--**************************************************************

--**************************************************************
--
--
-- Component Architecture
--
--
--**************************************************************

architecture rtl of rxframe1 is

--**************************************************************
--
-- Architecture declaration begin 
--
--**************************************************************

--
-- local constants (edit)
--
-- constant [name] : [type] := [value];
--
constant BUFFER_HALF_FULL_LEVEL : natural := 2048;
constant BUFFER_FULL_LEVEL      : natural := 4032; -- x"FC0"
-- note: 
-- buffersize      = 4096
-- half_full_level = 2048 (msb test)
-- full_level      = 4032 (pattern "111..111000..00000" --> simpler logic)
-- note1:
-- buffer full level --> there must be enough free space for 
-- frame trailer write op ('databuf_size > BUFFER_FULL_LEVEL') 
-- note2:
-- buffer half_full level --> there must be enough free space to
-- accept a new frame of max length comprehensive of header and
-- trailer ('databuf_size - BUFFER_HALF_FULL_LEVEL >= maxframelen + 2')

--
-- state machines (edit)
--
type FSMrxbufwr_t is 
(
   S0,  -- reset
   S1,  -- idle
   S2,  -- wait frame
   S3   -- receive
);

type FSMrxbufrd_t is 
(
   S0,                                 -- reset 
   S1,                                 -- idle
   S2,                                 -- wait frame
   S2_1,                               -- buffer flush
   S3,                                 -- header align
   S4_0, S4_1, S4_2, S4_3, S4_4, S4_5, -- destaddr
   S5_0, S5_1, S5_2, S5_3, S5_4, S5_5, -- srcaddr
   S6_0, S6_1,                         -- lentype
   S7_0, S7_1, S7_2, S7_3, S7_4, S7_5, -- IPheader(0..5)
   S7_6, S7_7, S7_8, S7_9,             -- IPheader(6..9)
   S7_10, S7_11, S7_12, S7_13, S7_14,  -- IPheader(10..14)
   S7_15, S7_16, S7_17, S7_18, S7_19,  -- IPheader(15..19)
   S7_LOOP1,                           -- IP options (max 40 bytes)
   S7_20, S7_21, S7_22, S7_23,         -- UDPheader(20..23)
   S7_24, S7_25, S7_26, S7_27,         -- UDPheader(24..27)
   S7_28, S7_29, S7_30, S7_31, S7_32,  -- header(28+0..28+4)
   S7_33, S7_34, S7_35, S7_36, S7_37,  -- header(28+5..28+9)
   S8_0, S8_1, S8_2,                   -- header filter 
   S9_0, S9_1, S9_2, S9_3,             -- data frame
   S10_0, S10_1,                       -- pause frame
   S11_0, S11_1                        -- cmd frame
);

--
-- local registers (edit)
--
--
-- Notes: one record-type for each clock domain
--

--
-- clock domain clk2 (grxc)
--
type reglist2_t is record

   -- FSM list
   FSMrxbufwr : FSMrxbufwr_t;

   -- gmii interface
   grxd     : std_logic_vector(7 downto 0);
   grx_en   : std_logic;
   grx_er   : std_logic;
   grx_en_l : std_logic;
   grx_er_l : std_logic;
   grxfull  : std_logic;
   grxerror : std_logic;
   grxalign : std_logic;

   -- framelen test
   framelen : unsigned(13+1 downto 0); -- +1 for overflow flag

   -- end of list
   eol : std_logic;

end record;
constant reglist2_default : reglist2_t :=
(
   FSMrxbufwr => S0,

   grxd => (others => '0'),
   grx_en => '0',
   grx_er => '0',
   grx_en_l => '0',
   grx_er_l => '0',
   grxfull => '0',
   grxerror => '0',
   grxalign => '0',

   framelen => (others => '0'),

   eol => '0'
);

--
-- clock domain clk1
--
type reglist1_t is record

   -- FSM list
   FSMrxbufrd : FSMrxbufrd_t;

   -- header fields
   destaddr : std_logic_vector(7 downto 0);
   srcaddr : std_logic_vector(7 downto 0);
   cmdfield : std_logic_vector(7 downto 0);
   ports : std_logic_vector(7 downto 0);
   destport : std_logic_vector(3 downto 0);  
   srcport : std_logic_vector(3 downto 0);  
   params : rxframe1_byte_vector_t(0 to 5);

   -- ldata field
   ldata : std_logic_vector(15 downto 0);

   -- test registers
   test_destaddr_individual : std_logic_vector(0 to 5);
   test_destaddr_broadcast  : std_logic_vector(0 to 5);
   test_destaddr_multicast  : std_logic_vector(0 to 5);
   test_destaddr_pause      : std_logic_vector(0 to 5);
   test_srcaddr_slave       : std_logic_vector(0 to 5);
   test_srcaddr_master      : std_logic_vector(0 to 5);
   test_srcaddr_broadcast   : std_logic_vector(0 to 5);
   test_lentype_ipv4        : std_logic_vector(0 to 1);
   test_lentype_pause       : std_logic_vector(0 to 1);
   test_lentype_jumbo       : std_logic_vector(0 to 1);
   test_cmdpause            : std_logic_vector(0 to 1);
   test_dataframe           : std_logic;
   test_cmdframe            : std_logic;
   test_daddr               : std_logic;
   test_baddr               : std_logic;
   test_maddr               : std_logic;
   test_saddr               : std_logic;
   test_multicast           : std_logic;
   --
   test_IPv4                : std_logic;
   test_IPv4_option         : std_logic;
   test_framelen            : std_logic_vector(0 to 1);
   test_IPv4_unfragment     : std_logic_vector(0 to 1);
   test_IPv4_udp_protocol   : std_logic;
   test_IPv4_srcaddr        : std_logic_vector(0 to 3);
   test_IPv4_destaddr_ucast : std_logic_vector(0 to 3);
   test_IPv4_destaddr_mcast : std_logic_vector(0 to 3);
   test_IPv4_destaddr_bcast : std_logic_vector(0 to 3);
   test_IPv4_destaddr_ncast : std_logic_vector(0 to 3);
   test_UDP_srcport         : std_logic_vector(0 to 1);
   test_UDP_destport        : std_logic_vector(0 to 1);
   --
   macdestbyte : std_logic_vector(7 downto 0);
   macsrcbyte  : std_logic_vector(7 downto 0);
   MAC_destaddr_broadcast  : std_logic;
   MAC_destaddr_multicast  : std_logic;
   MAC_destaddr_individual : std_logic;
   MAC_srcaddr_master      : std_logic;
   MAC_srcaddr_slave       : std_logic;
   MAC_srcaddr_broadcast   : std_logic;
   --
   IPv4_opt_counter : std_logic_vector(6 downto 0);
   IPv4_opt_len : std_logic_vector(3 downto 0);
   IPv4_UDP : std_logic;
   IPv4_srcaddr : std_logic_vector(7 downto 0);
   IPv4_destaddr_ucast : std_logic;
   IPv4_destaddr_mcast : std_logic;
   IPv4_destaddr_bcast : std_logic;
   IPv4_length : std_logic_vector(15 downto 0);
   --
   UDP_srcport  : std_logic_vector(3 downto 0);
   UDP_destport : std_logic_vector(3 downto 0);
   UDP_length   : std_logic_vector(15 downto 0);
   
   -- lentype field
   lentype_ipv4  : std_logic;
   lentype_jumbo : std_logic;

   -- header filter regs
   destaddrok : std_logic;
   srcaddrok  : std_logic;
   daddrok    : std_logic;
   saddrok    : std_logic;   
   dataok     : std_logic;
   cmdok      : std_logic;
   pauseok    : std_logic;
   frameok    : std_logic;
   dataportok : std_logic;
   cmdportok  : std_logic;

   -- datalen test
   datalen       : std_logic_vector(13 downto 0);
   lencounter    : unsigned(13 downto 0);
   test_datalen  : std_logic;
   
   -- destport test
   test_destport : std_logic;

   -- rxframe status
   rxframeon : std_logic;

   -- pausequanta register
   cmdpause_quanta : std_logic_vector(15 downto 0);
   pausequanta : std_logic_vector(15 downto 0);

   -- rxcmd register
   cmdready : std_logic;
   cmdsrcport : std_logic_vector(3 downto 0);
   cmddestaddr : std_logic_vector(7 downto 0);
   cmdsrcaddr : std_logic_vector(7 downto 0);
   cmdcode : std_logic_vector(7 downto 0);
   cmdports : std_logic_vector(7 downto 0);
   cmdparams : rxframe1_byte_vector_t(0 to 5);

   -- end of list
   eol : std_logic;

end record;
constant reglist1_default : reglist1_t :=
(
   FSMrxbufrd => S0, 

   destaddr => (others => '0'),          
   srcaddr => (others => '0'),          
   cmdfield => (others => '0'),          
   ports => (others => '0'),          
   destport => (others => '0'),          
   srcport => (others => '0'),          
   params => (others => "00000000"),
   ldata => (others => '0'),

   test_destaddr_individual => (others => '0'),          
   test_destaddr_broadcast  => (others => '0'),
   test_destaddr_multicast  => (others => '0'),          
   test_destaddr_pause      => (others => '0'),          
   test_srcaddr_slave       => (others => '0'),          
   test_srcaddr_master      => (others => '0'),          
   test_srcaddr_broadcast   => (others => '0'),          
   test_lentype_ipv4        => (others => '0'),          
   test_lentype_pause       => (others => '0'),          
   test_lentype_jumbo       => (others => '0'),          
   test_cmdpause            => (others => '0'),
   test_dataframe           => '0',
   test_cmdframe            => '0',
   test_daddr               => '0',
   test_baddr               => '0',
   test_maddr               => '0',
   test_saddr               => '0',
   test_multicast           => '0',
   
   test_IPv4                => '0',
   test_IPv4_option         => '0',
   test_framelen            => (others => '0'),
   test_IPv4_unfragment     => (others => '0'),
   test_IPv4_udp_protocol   => '0',
   test_IPv4_srcaddr        => (others => '0'),
   test_IPv4_destaddr_ucast => (others => '0'),
   test_IPv4_destaddr_mcast => (others => '0'),
   test_IPv4_destaddr_bcast => (others => '0'),
   test_IPv4_destaddr_ncast => (others => '0'),
   test_UDP_srcport         => (others => '0'),
   test_UDP_destport        => (others => '0'),

   macdestbyte => (others => '0'),
   macsrcbyte => (others => '0'),
   MAC_destaddr_broadcast  => '0',
   MAC_destaddr_multicast  => '0',
   MAC_destaddr_individual => '0',
   MAC_srcaddr_master      => '0',
   MAC_srcaddr_slave       => '0',
   MAC_srcaddr_broadcast   => '0',

   IPv4_opt_counter    => (others => '0'),
   IPv4_opt_len        => (others => '0'),
   IPv4_UDP            => '0',
   IPv4_srcaddr        => (others => '0'),
   IPv4_destaddr_ucast => '0',
   IPv4_destaddr_mcast => '0',
   IPv4_destaddr_bcast => '0',
   IPv4_length         => (others => '0'),
   
   UDP_srcport  => (others => '0'),
   UDP_destport => (others => '0'),
   UDP_length   => (others => '0'), 

   lentype_ipv4  => '0',
   lentype_jumbo => '0',

   destaddrok => '0',
   srcaddrok => '0',
   daddrok => '0',
   saddrok => '0',
   dataok  => '0',
   cmdok   => '0',
   pauseok => '0',
   frameok => '0',
   dataportok => '0',
   cmdportok  => '0',

   datalen       => (others => '0'),
   lencounter    => (others => '0'),
   test_datalen  => '0',

   test_destport => '0',
   rxframeon => '0',

   cmdpause_quanta => (others => '0'),
   pausequanta => (others => '0'),

   cmdready => '0',
   cmdsrcport => (others => '0'),
   cmddestaddr => (others => '0'),
   cmdsrcaddr => (others => '0'),
   cmdcode => (others => '0'),
   cmdports => (others => '0'),
   cmdparams => (others => "00000000"),

   eol => '0'
);

--
-- all local registers (edit)
--
-- Notes: one record-element for each clock domain
--
type reglist_t is record
   clk1 : reglist1_t;
   clk2 : reglist2_t;
end record;

--

-- all local nets (edit)
--
type netlist_t is record

   -- FSMrxbufwr
   rxdatabuf_half_full : std_logic;
   rxdatabuf_full : std_logic;
   framelenerr : std_logic;

   -- gmii rx-interface status
   grxready : std_logic;
   grxdatavalid  : std_logic;
   grxinterframe : std_logic;
   grxerrorclear : std_logic;
   grxalignclear : std_logic;

   -- FSMrxbufrd
   index : integer;
   test_destaddr_req : std_logic;
   test_srcaddr_req : std_logic;
   test_lentype_req : std_logic;
   test_header_req : std_logic;

   bufheader : std_logic;
   bufempty : std_logic;
   buftrailer : std_logic;
   eoframe : std_logic;

   lencounter_clr : std_logic; 
   lencounter_inc : std_logic; 

   rxportwrreq : std_logic;
 
   rxframedone : std_logic;
   pausedone : std_logic;
   cmddone   : std_logic;

   cmdfifo_wrreq : std_logic;
   cmdfifo_full : std_logic;
 
   --
   -- component interface signals (edit)
   --
   -- [instance_name] : [component_name]_t;
   --
   rxdatabuf : rxdatabuf1_t;
   rxtagbuf : rxtagbuf1_t;
   rxcrc : crc32_t;
   
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
subtype inputs_t is rxframe1_inputs_t;
subtype outputs_t is rxframe1_outputs_t;

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
-- architecture rtl of rxframe1
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

rxdatabuf : rxdatabuf1 port map
(
   inputs => allnets.rxdatabuf.inputs,
   outputs => allcmps.rxdatabuf.outputs
);

rxtagbuf : rxtagbuf1 port map
(
   inputs => allnets.rxtagbuf.inputs,
   outputs => allcmps.rxtagbuf.outputs
);

rxcrc : crc32 port map
(
   inputs => allnets.rxcrc.inputs,
   outputs => allcmps.rxcrc.outputs
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
-- clock domain: clk1,rst1 (edit)
--
process (inputs.clk1, inputs.rst1)
begin
   if (inputs.rst1 = '1') then
      allregs.dout.clk1 <= reglist1_default;
   elsif rising_edge(inputs.clk1) then
      allregs.dout.clk1 <= allregs.din.clk1;
   end if;
end process;

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
-- FSMrxbufwr combinatorial procedure (edit)
--
-- clock domain: clk2 (grxc)
--
procedure SubFSMrxbufwr
(
   variable i : in inputs_t;
   variable ri: in reglist2_t;
   variable ro: in reglist2_t;
   variable o : inout outputs_t;
   variable r : inout reglist2_t;
   variable n : inout netlist_t
) is
begin

   -- 4bit/8bit mode
   if BIT_PER_CLOCK = 8 then
      -- 8bit mode: grx register updated with new byte
      r.grxd := i.grxd;
      r.grx_en := i.grx_en;
      r.grx_er := i.grx_er;
      r.grxfull := '0';
      r.grxalign := '1';
      -- note: when 8bit mode grxd register works as simple
      -- register (it is an always empty fifo, new 8bit data appears
      -- to output with 1 clock latency); we assume byte nibbles
      -- always aligned 
   end if;
   if BIT_PER_CLOCK = 4 then
      -- 4bit mode: grx register updated using nibble mux (2 clocks latency)
      if n.grxalignclear = '1' then
         -- grx forced not aligned 
         r.grxalign := '0';
      elsif ro.grxalign = '0' then
         -- grx not aligned: register always empty, low-nibble loaded
         r.grxd(3 downto 0) := i.grxd(3 downto 0);
         r.grx_en_l := i.grx_en;
         r.grx_er_l := i.grx_er;
         r.grxfull := '1';
         -- start-of-frame test         
         if ro.grxd(3 downto 0) = x"5" and i.grxd(3 downto 0) = x"D" then
            -- ...0x5-0xD: SFD found, grx register full
            r.grxd(7 downto 0) := x"D5";
            r.grx_en := i.grx_en and ro.grx_en_l;
            r.grx_er := i.grx_er or ro.grx_er_l;
            -- note: data_error when low-nibble or high-nibble in error, 
            --       data_valid when both nibbles are valid 
            r.grxfull := '0'; 
            -- alignment done
            r.grxalign := '1';
         end if;
         -- note: when 4bit mode we wait for nibbles 0x5-0xD to recognize 
         -- start of frame (byte alignment in progress); after 0x5-0xD we return SFD  
         -- pattern (0xD5) and assume alignment done --> next clock cycle input 
         -- nibble will be loaded as byte-low-nibble
      elsif ro.grxfull = '0' then
         -- grx register aligned+empty: low-nibble load (write request --> fifo full)
         r.grxd(3 downto 0) := i.grxd(3 downto 0);
         r.grx_en_l := i.grx_en;
         r.grx_er_l := i.grx_er;
         r.grxfull := '1'; 
      else
         -- grx register aligned+full: high-nibble load (write+read request --> fifo empty)
         r.grxd(7 downto 4) := i.grxd(3 downto 0);
         r.grx_en := i.grx_en and ro.grx_en_l;
         r.grx_er := i.grx_er or ro.grx_er_l;
         -- note: data_error when low-nibble or high-nibble in error, 
         --       data_valid when both nibbles are valid 
         r.grxfull := '0'; 
      end if; 
      -- note: when 4bit mode grxd register works as fifo with depth = 1
      -- (read request starts immediatly when high-nibble is written, 
      -- register is empty when new 8bit data appears to output) 
   
--      -- !! debug !!
--      r.grxd(3 downto 0) := i.grxd(3 downto 0);
--      r.grx_en := i.grx_en;
--      r.grx_er := i.grx_er;
--      -- !! debug !!
      
   end if;

   --
   -- gmii rx-interface status
   --

   -- grx ready when not full (full means partial nibble load)
   n.grxready := not ro.grxfull;   

   -- grx datavalid
   n.grxdatavalid := '0';
   if (ro.grx_en = '1' and ro.grx_er = '0') then
      n.grxdatavalid  := '1';
   end if;

   -- interframe
   n.grxinterframe := '0';
   if (ro.grx_en = '0' and ro.grx_er = '0')  or
      (ro.grx_en = '0' and UINT(ro.grxd) = 0) then 
      n.grxinterframe := '1';
   end if;

   -- frame error clear/set logic
   if n.grxerrorclear = '1' then
      -- grxerror clear
      r.grxerror := '0';
   elsif ro.grx_er = '1' then
      -- grxerror sticky bit
      r.grxerror := '1';
   end if;

   --
   -- rxcrc defaults (clock domain clk2)
   --
   n.rxcrc.inputs.clk1 := i.clk2;
   n.rxcrc.inputs.rst1 := i.rst2;
   n.rxcrc.inputs.init := '0';
   n.rxcrc.inputs.data := ro.grxd(7 downto 0);
   n.rxcrc.inputs.datavalid := '0';

   --
   -- rxdatabuf, rxtagbuf defaults (clock domain clk2)
   --
   n.rxdatabuf.inputs.wrclk := i.clk2;
   n.rxdatabuf.inputs.aclr := i.rst2;
   n.rxdatabuf.inputs.wrreq := '0';
   n.rxdatabuf.inputs.data(7 downto 0) := ro.grxd(7 downto 0);
   n.rxdatabuf.inputs.data(9 downto 8) := "00";

   n.rxtagbuf.inputs.wrclk := i.clk2;
   n.rxtagbuf.inputs.aclr := i.rst2;
   n.rxtagbuf.inputs.wrreq := '0';
   n.rxtagbuf.inputs.data := SLV(0, n.rxtagbuf.inputs.data);

   -- databuf half_full condition
   n.rxdatabuf_half_full := '0';
   if UINT(n.rxdatabuf.outputs.wrusedw) >= BUFFER_HALF_FULL_LEVEL then
      n.rxdatabuf_half_full := '1';
   end if;
   -- databuf full condition
   n.rxdatabuf_full := '0';
   if UINT(n.rxdatabuf.outputs.wrusedw) >= BUFFER_FULL_LEVEL then
      n.rxdatabuf_full := '1';
   end if;
   -- note1:
   -- buffer full level --> there must be enough free space for 
   -- frame trailer write op ('databuf_size > BUFFER_FULL_LEVEL') 
   -- note2:
   -- buffer half_full level --> there must be enough free space to
   -- accept a new frame of max length comprehensive of header and
   -- trailer ('databuf_size - BUFFER_HALF_FULL_LEVEL >= maxframelen + 2')

   -- framelen test (13bit up counter with stop on overflow)
   n.framelenerr := ro.framelen(14);

   -- net defaults
   n.grxerrorclear := '0';
   n.grxalignclear := '0';

   --
   -- FSMrxbufwr
   --
   -- Start/Stop frame detection with crc calculation: 
   -- incoming data-bytes are saved to 'rxdatabuf fifo';  
   -- crc-valid/error flags + framelen-check results are loaded into 
   -- 'rxtagbuf fifo' when frame stops. 
   -- rxdatabuf+rxtagbuf are used as temporary memory area with clock domain crossing:
   -- they are written at grxc clock speed and quasi-continuously read at full clock speed
   -- (tx/rx common clock domain). 
   -- When rxframe starts, buffers should have room for a complete header + frame + trailer 
   -- data packet (write logic uses buffer_half_full condition as blocking test:
   -- when buffer is half_full at SFD detection --> frame will be discarded).
   -- This solution avoid the all-frames-discarded behaviour when buffer level 
   -- is near full condition: we wait for buffer level that guarantees
   -- single frame reception.
   -- 
   case ro.FSMrxbufwr is
   when S0 =>
      --
      -- reset state
      --
      r.FSMrxbufwr := S1;

   when S1 =>
      --
      -- rx enabled: interframe test
      -- 
      if n.grxinterframe = '1' then 
         -- interframe found: start with grx not aligned, to 'wait SFD'
         n.grxalignclear := '1';
         r.FSMrxbufwr := S2;
      else
         -- frame in progress / frame error: interframe wait
         null;
      end if;

   when S2 =>
      --
      -- rx enabled: interframe found, wait SFD
      --
      if n.grxready = '1' then
      if n.grxdatavalid = '1' and SLV(ro.grxd) = x"D5" then
         if n.rxtagbuf.outputs.wrfull = '1' then
            -- tagbuf full: frame discarded, to interframe test
            r.FSMrxbufwr := S1;
         elsif n.rxdatabuf_half_full = '0' then
            -- start of frame: error clear
            n.grxerrorclear := '1'; 
            -- start of frame: crc init
            n.rxcrc.inputs.init := '1';            
            -- start of frame: framelen counter init
            r.framelen := SLV(0, r.framelen);
            -- start of frame: databuf header (01xxxxxxxx)
            n.rxdatabuf.inputs.wrreq   := '1';
            n.rxdatabuf.inputs.data(8) := '1';              
            n.rxdatabuf.inputs.data(9) := '0';              
            -- to frame reception
            r.FSMrxbufwr := S3;
         else
            -- databuf half_full: frame discarded, to interframe test
            r.FSMrxbufwr := S1;
         end if;
      else
         -- wait
         null;
      end if; -- note: in 4bit mode we have to wait for complete data byte
      end if; -- so we mask read operations with n.grxready test (NO extra indentation)

   when S3 =>
      --
      -- rxframe
      --
      if (n.grxready = '1') then
      if (n.grxdatavalid = '1') and (n.rxdatabuf_full = '0') and
         (n.framelenerr = '0') then
         
         -- normal frame reception with crc calculation 
         n.rxcrc.inputs.datavalid := '1';
         n.rxdatabuf.inputs.wrreq := '1';
         -- framelen counter with stop on overflow
         if n.framelenerr = '0' then
            r.framelen := ro.framelen + 1;
         end if;
         
      elsif (n.grxdatavalid = '0') and (n.rxdatabuf_full = '0') and
            (n.framelenerr = '0') then

         -- end of frame: databuf trailer (10xxxxxxxx)
         n.rxdatabuf.inputs.wrreq   := '1';
         n.rxdatabuf.inputs.data(8) := '0';              
         n.rxdatabuf.inputs.data(9) := '1';              

         -- end of frame: crc check when error condition not asserted
         if ro.grxerror = '1' or n.rxcrc.outputs.fcserr = '1' then
            -- data_error | crc_error: tagbuf header_error (msb = 1, 0x8001)
            n.rxtagbuf.inputs.wrreq    := '1';
            n.rxtagbuf.inputs.data(15) := '1';
            n.rxtagbuf.inputs.data(14 downto 0) := "000000000000001";
         else
            -- crc_ok: tagbuf header_ok (msb = 0, framelen)
            n.rxtagbuf.inputs.wrreq   := '1';
            n.rxtagbuf.inputs.data(15) := '0';              
            n.rxtagbuf.inputs.data(14) := '0';              
            n.rxtagbuf.inputs.data(13 downto 0) := SLV(ro.framelen(13 downto 0), 14);
         end if;

         -- to interframe test
         r.FSMrxbufwr := S1;

      else 
      
         -- full/len error: databuf trailer (10xxxxxxxx)
         n.rxdatabuf.inputs.wrreq   := '1';
         n.rxdatabuf.inputs.data(8) := '0';              
         n.rxdatabuf.inputs.data(9) := '1';              
         -- note: when 'rxdatabuf_full' asserted there is databuf free space
         -- to accept trailer write op 

         -- full/len error: tagbuf header_error (msb = 1, 0x8002/0x8004)
         n.rxtagbuf.inputs.wrreq   := '1';
         n.rxtagbuf.inputs.data(15) := '1';

         if n.framelenerr = '1' then
            -- frame too long error (0x8004)
            n.rxtagbuf.inputs.data(14 downto 0) := "000000000000100";
         else
            -- full error (0x8002)
            n.rxtagbuf.inputs.data(14 downto 0) := "000000000000010";
         end if;

         -- to interframe test
         r.FSMrxbufwr := S1;

      end if; -- note: in 4bit mode we have to wait for complete data byte
      end if; -- so we mask read operations with n.grxready test (NO extra indentation)

   end case;

end procedure;


--
-- FSMrxbufrd combinatorial procedure (edit)
--
-- clock domain: clk1
--
procedure SubFSMrxbufrd
(
   variable i : in inputs_t;
   variable ri: in reglist1_t;
   variable ro: in reglist1_t;
   variable o : inout outputs_t;
   variable r : inout reglist1_t;
   variable n : inout netlist_t
) is
begin

   -- rxdatabuf, rxtagbuf defaults (clock domain clk1)
   n.rxdatabuf.inputs.rdclk := i.clk1;
   n.rxdatabuf.inputs.rdreq := '0';

   n.rxtagbuf.inputs.rdclk := i.clk1;
   n.rxtagbuf.inputs.rdreq := '0';

   -- rxdatabuf test 
   n.bufheader := n.rxdatabuf.outputs.q(8);
   n.bufempty := n.rxdatabuf.outputs.rdempty;
   n.buftrailer := n.rxdatabuf.outputs.q(9);
   n.eoframe := n.bufempty or n.buftrailer;
   -- note: eoframe condition appears when trailer is found 
   -- or when buffer is empty (eoframe condition puts FSMrxbufrd in 
   -- idle state without extra buffer flush operation: eoframe 
   -- means flush operation done)

   --
   -- net defaults
   --
   n.index := 0;                -- index + test_request used for test procedure calls
   n.test_destaddr_req := '0';  --
   n.test_srcaddr_req := '0';   --
   n.test_lentype_req := '0';   --
   n.test_header_req := '0';    -- 
   n.lencounter_clr := '0';
   n.lencounter_inc := '0';
   n.rxportwrreq := '0';
   n.rxframedone := '0';
   n.pausedone := '0';
   n.cmddone   := '0';
   n.cmdfifo_wrreq := '0';

   --
   -- FSMrxbufrd
   --
   -- Buffered frames are validated (testing dest/src/ltype/header fields)
   -- data/cmd/pause frames are written to rxport/cmd/pause output interfaces
   -- 
   case ro.FSMrxbufrd is
   when S0 =>
      --
      -- reset state
      --
      r.FSMrxbufrd := S1;

   when S1 =>
      --
      -- idle state
      --

      -- rxframe enable/disable command latched
      r.rxframeon := i.enable;

      -- tagbuf test      
      if n.rxtagbuf.outputs.rdempty = '0' then
         -- new frame received: extract tagbuf header
         n.rxtagbuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S2;
         -- note: frame processing never stops --> all frames will be tested
         -- and eventually discarded
      else
         -- wait
         null;
      end if;

   when S2 =>
      --
      -- tagbuf header test
      --
      -- note: we assume output_latency(rxdatabuf) <= output_latency(rxtagbuf)
      -- (rxdatabuf contains a complete header + data + trailer packet when tag header is
      -- read; rxtagbuffer-sync-chain MUST be longer than rxdatabuf-sync-chain,
      -- i.e. sync_delaypipe => 6 .vs. sync_delaypipe => 5)
      --
      if ro.rxframeon = '0' then
         -- rxframe not enabled: frame discarded, to buffer flush
         r.FSMrxbufrd := S2_1; 
         -- ??? 
         -- ??? NOTA: forse occorre aggiungere un path verso la write side per bloccare la scrittura...cosi' in caso di fifo disallineati si 
         -- ??? recupera l'allineamento: la write side riceve la enable=0 e risponde con un enableret=0 bloccandosi....la read side
         -- ??? deve poi fare un flush totale di entrambi i buffer (databuf+tagbuf)...il funzionamento riprende quando enable=1
         -- ??? e la enableret=1 
         -- ??? NOTA1: la write-side riceve tutto....una frame anomala con lunghezza 0..3 (piu' piccola del crc(4)) potrebbe essere 
         -- ??? riconosciuta come valida?..NO...forse occorre inserire un test di write/read-side framelen minima per avere la sicurezza di
         -- ??? avere almeno i 6+6+2+(28+10)+4=18+(38)byte?...NO...una frame short viene completamente estratta dalla read-side e se non include
         -- ??? destaddr/srcaddr/ltype/IPheader/UDPheader/header viene ignorata...la logica di test framelen min non e' necessaria... 
         -- ??? NOTA2: anche se la frame estratta dalla read-side ha una lunghezza minima di 18+(38)=56 byte puo' succedere che il contenuto dei campi
         -- ??? 'UDPlength','ldata' sia sbagliato --> una forma di controllo sul contenuto della 'UDPlength' per essere sicuri di processare
         -- ??? dei dati header completi e' obbligatoria ('UDPlength >= 8+10' and 'ldata <= UDPlength - (8+10)', l'operazione di clipping su
         -- ??? ldata deve essere fatta usando il valore 'UDPlength - (8+10)' e come ultimo controllo un clip sulla lunghezza completa della frame
         -- ??? per evitare di ricevere il crc come blocco dati)...ma allora anche il campo 'IPv4_length' deve essere controllato per tenere conto
         -- ??? dei parametri opzionali...     
         --
      elsif n.rxtagbuf.outputs.q(15) = '0' then
         -- rxframe enabled, tagbuf header_ok found: minlen/maxlen test
         if (UINT(n.rxtagbuf.outputs.q(14 downto 0)) <= UINT(i.maxframelen)) then
            -- !! debug !! min test removed
            --(UINT(n.rxtagbuf.outputs.q(14 downto 0)) >= 64) then
            -- !! debug !! min test removed
            -- minlen ok, maxlen ok: continue
            r.FSMrxbufrd := S3;
            -- !!!! debug 
            -- test con valori costanti, con una fifo size di
            -- 4096 c'e' spazio per due jumbo frames di 2000 bytes con
            -- extra space per header / trailer 
            --(UINT(n.rxtagbuf.outputs.q(14 downto 0)) <= 2000) then 
            -- !!!! debug
         else
            -- valid frame with bad size: frame discarded, to buffer flush
            r.FSMrxbufrd := S2_1;
         end if;
      else
         -- rxframe enabled, header_error found: frame not valid (crc/data/fifo error), to buffer flush
         r.FSMrxbufrd := S2_1;
      end if;

      -- first data extraction before test/flush operations 
      -- (test/flush needs valid rxdatabuf output)
      if n.bufempty = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
      else
         -- empty buffer, to idle state
         r.FSMrxbufrd := S1;
         -- note: this condition should never appear: databuf + tagbuf fifos must be 
         -- aligned, when tagbuf signals a new frame --> databuf cannot be empty and 
         -- must have a complete header + data + trailer packet
      end if;

   when S2_1 =>
      --
      -- buffer flush until trailer
      --
      if n.buftrailer = '1' then
         -- trailer found: frame completely discarded, to idle state
         r.FSMrxbufrd := S1;
      else
         -- next data
         if n.bufempty = '0' then
            -- new data extracted
            n.rxdatabuf.inputs.rdreq := '1';
         else
            -- buffer empty, to idle state
            r.FSMrxbufrd := S1;
            -- note: this condition should never appear: databuf must have
            -- a complete header + data + trailer packet
            -- note1: fifo logic may signal a fifo rdempty condition when fifo is no
            -- really empty (this occurs when there are contemporary write and read
            -- requests near fifo empty status --> we assume rdempty never asserted
            -- for current frame because write-side prepares rxdatabuf before
            -- rxtagbuf and output_latency(rxdatabuf) <= output_latency(rxtagbuf)) 
         end if;
      end if;

   when S3 =>
      --
      -- databuf header alignment 
      --
      if n.bufempty = '1' then
         -- buffer empty: to idle state 
         r.FSMrxbufrd := S1;
      elsif n.bufheader = '1' then
         -- buffer not empty, header found: next data prepared for frame test
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S4_0;
      else
         -- buffer not empty, header not found: waiting for header 
         n.rxdatabuf.inputs.rdreq := '1';
      end if;
      -- note: transition to S4_0 should be immediate (header is now ready)
      -- note1: this logic tries to re-align fifos when unexpected packet data
      -- appears (i.e. old frames not completely discarded) but cannot solve
      -- all alignment errors between fifos...

   when S4_0 =>
      --
      -- destaddr0 test
      --

      -- call destaddr test
      n.index := 0;
      n.test_destaddr_req := '1';

      -- next data 
      if n.eoframe = '0' then 
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S4_1;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S4_1 =>
      --
      -- destaddr1 test
      --

      -- call destaddr test
      n.index := 1;
      n.test_destaddr_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S4_2;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S4_2 =>
      --
      -- destaddr2 test
      --

      -- call destaddr test
      n.index := 2;
      n.test_destaddr_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S4_3;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S4_3 =>
      --
      -- destaddr3 test
      --

      -- call destaddr test
      n.index := 3;
      n.test_destaddr_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S4_4;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S4_4 =>
      --
      -- destaddr4 test
      --

      -- call destaddr test
      n.index := 4;
      n.test_destaddr_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S4_5;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S4_5 =>
      --
      -- destaddr5 test
      --

      -- call destaddr test
      n.index := 5;
      n.test_destaddr_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S5_0;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S5_0 =>
      --
      -- srcaddr0 test
      --

      -- call srcaddr test
      n.index := 0;
      n.test_srcaddr_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S5_1;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S5_1 =>
      --
      -- srcaddr1 test
      --

      -- call srcaddr test
      n.index := 1;
      n.test_srcaddr_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S5_2;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S5_2 =>
      --
      -- srcaddr2 test
      --

      -- call srcaddr test
      n.index := 2;
      n.test_srcaddr_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S5_3;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S5_3 =>
      --
      -- srcaddr3 test
      --

      -- call srcaddr test
      n.index := 3;
      n.test_srcaddr_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S5_4;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S5_4 =>
      --
      -- srcaddr4 test
      --

      -- call srcaddr test
      n.index := 4;
      n.test_srcaddr_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S5_5;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S5_5 =>
      --
      -- srcaddr5 test
      --

      -- call srcaddr test
      n.index := 5;
      n.test_srcaddr_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S6_0;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S6_0 =>
      --
      -- lentype0 test
      --

      -- call lentype test
      n.index := 0;
      n.test_lentype_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S6_1;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S6_1 =>
      --
      -- lentype1 test
      --

      -- call lentype test
      n.index := 1;
      n.test_lentype_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_0;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_0 =>
      --
      -- header0 test 
      --

      -- call header test
      n.index := 0;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_1;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_1 =>
      --
      -- header1 test 
      --

      -- call header test
      n.index := 1;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_2;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_2 =>
      --
      -- header2 test 
      --

      -- call header test
      n.index := 2;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_3;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_3 =>
      --
      -- header3 test 
      --

      -- call header test
      n.index := 3;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_4;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_4 =>
      --
      -- header4 test 
      --

      -- call header test
      n.index := 4;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_5;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_5 =>
      --
      -- header5 test 
      --

      -- call header test
      n.index := 5;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_6;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_6 =>
      --
      -- header6 test 
      --

      -- call header test
      n.index := 6;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_7;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_7 =>
      --
      -- header7 test 
      --

      -- call header test
      n.index := 7;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_8;
      else
         r.FSMrxbufrd := S1;
      end if;

      -- lencounter init
      n.lencounter_clr := '1';

   when S7_8 =>
      --
      -- header8 test 
      --

      -- call header test
      n.index := 8;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_9;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_9 =>
      --
      -- header9 test 
      --

      -- call header test
      n.index := 9;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_10;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_10 =>
      --
      -- header10 test 
      --

      -- call header test
      n.index := 10;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_11;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_11 =>
      --
      -- header11 test 
      --

      -- call header test
      n.index := 11;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_12;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_12 =>
      --
      -- header12 test 
      --

      -- call header test
      n.index := 12;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_13;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_13 =>
      --
      -- header13 test 
      --

      -- call header test
      n.index := 13;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_14;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_14 =>
      --
      -- header14 test 
      --

      -- call header test
      n.index := 14;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_15;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_15 =>
      --
      -- header15 test 
      --

      -- call header test
      n.index := 15;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_16;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_16 =>
      --
      -- header16 test 
      --

      -- call header test
      n.index := 16;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_17;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_17 =>
      --
      -- header17 test 
      --

      -- call header test
      n.index := 17;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_18;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_18 =>
      --
      -- header18 test 
      --

      -- call header test
      n.index := 18;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_19;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_19 =>
      --
      -- header19 test 
      --

      -- call header test
      n.index := 19;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         --
         if ro.test_IPv4 = '1' then
            -- IPv4 frame received (pattern '0x4[5..F]') --> 'test_IPv4_option','IPv4_opt_len' are valid
            if ro.test_IPv4_option = '1' then
               -- IPheader has the option field ('IPv4_opt_len' > 0): to loop read 
               r.IPv4_opt_counter := SLV(64+1 - (4 * UINT(ro.IPv4_opt_len)), 7);
               r.FSMrxbufrd := S7_LOOP1;
               -- note: 'IPv4_opt_counter' includes first increment (64+1, up counter, msb test)  
            else
               -- IPheader does not have the option field: continue assuming UDPheader  
               r.FSMrxbufrd := S7_20;
            end if;
         else
            -- Not IPv4 frame: header test will continue for all bytes 0..27 
            -- (i.e. ARP request maps exactly on UDP/IP 28 bytes header space)  
            r.FSMrxbufrd := S7_20;
         end if;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_LOOP1 =>
      --
      -- IPv4 option field (max 40bytes) 
      --

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         --
         if ro.IPv4_opt_counter(6) = '1' then
            -- option field done: continue assuming UDPheader
            r.FSMrxbufrd := S7_20;
         else
            -- next byte (note: up counter, msb test)  
            r.IPv4_opt_counter := SLV(UINT(ro.IPv4_opt_counter) + 1, 7);
         end if;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_20 =>
      --
      -- header20 test 
      --

      -- call header test
      n.index := 20;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_21;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_21 =>
      --
      -- header21 test 
      --

      -- call header test
      n.index := 21;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_22;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_22 =>
      --
      -- header22 test 
      --

      -- call header test
      n.index := 22;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_23;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_23 =>
      --
      -- header23 test 
      --

      -- call header test
      n.index := 23;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_24;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_24 =>
      --
      -- header24 test 
      --

      -- call header test
      n.index := 24;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_25;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_25 =>
      --
      -- header25 test 
      --

      -- call header test
      n.index := 25;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_26;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_26 =>
      --
      -- header26 test 
      --

      -- call header test
      n.index := 26;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_27;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_27 =>
      --
      -- header27 test 
      --

      -- call header test
      n.index := 27;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_28;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_28 =>
      --
      -- header28 test 
      --

      -- call header test
      n.index := 28;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_29;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_29 =>
      --
      -- header29 test 
      --

      -- call header test
      n.index := 29;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_30;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_30 =>
      --
      -- header30 test 
      --

      -- call header test
      n.index := 30;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_31;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_31 =>
      --
      -- header31 test 
      --

      -- call header test
      n.index := 31;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_32;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_32 =>
      --
      -- header32 test 
      --

      -- call header test
      n.index := 32;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_33;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_33 =>
      --
      -- header33 test 
      --

      -- call header test
      n.index := 33;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_34;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_34 =>
      --
      -- header34 test 
      --

      -- call header test
      n.index := 34;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_35;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_35 =>
      --
      -- header35 test 
      --

      -- call header test
      n.index := 35;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_36;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_36 =>
      --
      -- header36 test 
      --

      -- call header test
      n.index := 36;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S7_37;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S7_37 =>
      --
      -- header37 test 
      --

      -- call header test
      n.index := 37;
      n.test_header_req := '1';

      -- next data
      if n.eoframe = '0' then
         n.rxdatabuf.inputs.rdreq := '1';
         r.FSMrxbufrd := S8_0;
      else
         r.FSMrxbufrd := S1;
      end if;

   when S8_0 =>
      --
      -- frame header test (level 0)
      --

      -- MAC destaddr test
      r.MAC_destaddr_broadcast  := '0';
      r.MAC_destaddr_multicast  := '0';
      r.MAC_destaddr_individual := '0';
      if ro.test_destaddr_broadcast = "111111" then
         -- broadcast destaddress
         r.MAC_destaddr_broadcast := '1';
      end if;
      if ro.test_destaddr_multicast = "111111" then
         -- multicast destaddress
         r.MAC_destaddr_multicast := '1';
      end if;
      if ro.test_destaddr_individual = "111111" then
         -- individual destaddress
         r.MAC_destaddr_individual := '1';
      end if;

      -- MAC srcaddr test
      r.MAC_srcaddr_master    := '0';
      r.MAC_srcaddr_slave     := '0';
      r.MAC_srcaddr_broadcast := '0';
      if ro.test_srcaddr_master = "111111" then
         -- srcaddr from master node
         r.MAC_srcaddr_master := '1';
      end if;
      if ro.test_srcaddr_slave = "111111" then
         -- srcaddr from slave node
         r.MAC_srcaddr_slave := '1';
      end if;
      if ro.test_srcaddr_broadcast = "111111" then
         -- broadcast srcaddr
         r.MAC_srcaddr_broadcast := '1';
      end if;

      -- MAC lentype test
      r.lentype_ipv4  := '0';
      r.lentype_jumbo := '0';
      if ro.test_lentype_ipv4 = "11" then
         -- frame ipv4 (0x0800)
         r.lentype_ipv4 := '1';
      end if;
      if ro.test_lentype_jumbo = "11" then
         -- frame jumbo (0x8870)
         r.lentype_jumbo := '1';
      end if;

      -- IP/UDP test
      r.IPv4_UDP := '0';
      if ro.test_framelen = "11" and ro.test_IPv4 = '1' and ro.test_IPv4_unfragment = "11" and ro.test_IPv4_udp_protocol = '1' and
         ro.test_IPv4_srcaddr = "1111" and ro.test_UDP_srcport = "11" and ro.test_UDP_destport = "11" then
         -- IPv4 len/type + unfragmented + udp protocol + srcaddr unicast + udp src/dest ports
         r.IPv4_UDP := '1';
      end if;
      -- 
      r.IPv4_destaddr_ucast := '0';
      r.IPv4_destaddr_mcast := '0';
      r.IPv4_destaddr_bcast := '0';
      if ro.test_IPv4_destaddr_ucast = "1111" then
         -- IPv4 destaddr unicast
         r.IPv4_destaddr_ucast := '1';
      end if;
      if ro.test_IPv4_destaddr_mcast = "1111" then
         -- IPv4 destaddr multicast
         r.IPv4_destaddr_mcast := '1';
      end if;
      if ro.test_IPv4_destaddr_bcast = "1111" or ro.test_IPv4_destaddr_ncast = "1111" then
         -- IPv4 destaddr broadcast | network broadcast
         r.IPv4_destaddr_bcast := '1';
      end if;
      -- note: 'IPv4_destaddr_NNNNN' test results are valid only when 'IPv4_UDP' asserted 

      -- test results will be ready next clock cycle
      r.FSMrxbufrd := S8_1;

   when S8_1 =>
      --
      -- frame header test (level 1)
      --

      -- pause frame
      r.pauseok := '0';
      if ro.test_destaddr_pause = "111111" and ro.test_lentype_pause = "11" and
         ro.test_cmdpause = "11" then
         -- pause macaddress + pause ltype + pause cmd: ok
         r.pauseok := '1';
      end if;
      if ro.MAC_destaddr_individual = '1' and ro.test_lentype_pause = "11" and 
         ro.test_cmdpause = "11" then
         -- individual destaddr + pause ltype + pause cmd: ok
         r.pauseok := '1';
      end if;

      -- destaddr filter
      r.destaddrok := '0';
      if ro.lentype_ipv4 = '1' and ro.IPv4_UDP = '1' then
         -- IPv4 UDP frame detected (note: jumbo frames not accepted)
         if (ro.MAC_destaddr_broadcast  = '1' and ro.IPv4_destaddr_bcast = '1') or
            (ro.MAC_destaddr_individual = '1' and ro.IPv4_destaddr_bcast = '1') or
            (ro.MAC_destaddr_multicast  = '1' and ro.IPv4_destaddr_bcast = '1') then
            if i.mode_destaddr_broadcast = '1' then
               -- broadcast address ok
               r.destaddrok := '1';
            end if;
         end if;
         if (ro.MAC_destaddr_broadcast  = '1' and ro.IPv4_destaddr_mcast = '1') or
            (ro.MAC_destaddr_individual = '1' and ro.IPv4_destaddr_mcast = '1') or
            (ro.MAC_destaddr_multicast  = '1' and ro.IPv4_destaddr_mcast = '1') then
            if i.mode_destaddr_multicast = '1' then
               -- multicast address ok
               r.destaddrok := '1';
            end if;
         end if;
         if (ro.MAC_destaddr_broadcast  = '1' and ro.IPv4_destaddr_ucast = '1') or
            (ro.MAC_destaddr_individual = '1' and ro.IPv4_destaddr_ucast = '1') or
            (ro.MAC_destaddr_multicast  = '1' and ro.IPv4_destaddr_ucast = '1') then
            if i.mode_destaddr_unicast = '1' then
               -- unicast address ok
               r.destaddrok := '1';
            end if;
         end if; 
         -- note: lightweight filter --> IPv4 frames can be transported by any 'MAC_destaddr' type  
      end if;
      --
      r.daddrok := '0';
      if ro.test_multicast = '0' and ro.test_daddr = '1' then
         -- daddr unicast/broadcast and daddr matches 'nodeaddr': unicast received ok
         r.daddrok := '1';
      end if;
      if ro.test_multicast = '0' and ro.test_baddr = '1' then
         -- daddr unicast/broadcast and daddr matches 255: broadcast received ok
         r.daddrok := '1';
      end if;
      if ro.test_multicast = '1' and ro.test_maddr = '1' then
         -- daddr multicast and daddr matches 'multicastaddr': multicast received ok
         r.daddrok := '1';
      end if;

      -- srcaddr filter
      r.srcaddrok := '0';
      if ro.lentype_ipv4 = '1' and ro.IPv4_UDP = '1' then
         -- IPv4 UDP frame detected (note: jumbo frames not accepted)
         r.srcaddrok := '1';
         -- note: 'IPv4_UDP' test-result includes IP srcaddr unicast --> MAC srcaddr not tested, any MAC srcaddr is ok
      end if;
      --
      r.saddrok := '0';
      if ro.test_saddr = '1' then
         -- saddr matches 'IPv4_srcaddr' (8bit low)
         r.saddrok := '1';
      end if;

      -- data frame
      r.dataok := '0';
      if i.mode_data = '1' and ro.test_dataframe = '1' then
         -- data frame ok
         r.dataok := '1';
      end if;
 
      -- cmd frame
      r.cmdok := '0';
      if i.mode_cmd = '1' and ro.test_cmdframe = '1' then
         -- cmd frame ok
         r.cmdok := '1';
      end if;

      -- src/dest ports (data frame)
      r.dataportok := '0';
      if (UINT(ro.UDP_destport) = UINT(ro.destport)) and
         (UINT(ro.UDP_srcport)  = UINT(ro.srcport))  and 
         (ro.test_destport = '1')                    then
         -- all src/dest ports match corresponding IP/UDP ports, destport in range 1..NPORTS 
         r.dataportok := '1';
      end if;    
      -- note: 'dataportok' test result is applicable only for data frames 
      -- ('ports' field is a generic parameter not related to UDP port addresses 
      -- when command frame received)

      -- src/dest ports (cmd frame)
      r.cmdportok := '0';
      if (UINT(ro.UDP_destport) = 0) then 
         -- port zero reserved for command frames
         r.cmdportok := '1';
      end if;    
 
      -- filter results will be ready next clock cycle
      r.FSMrxbufrd := S8_2;

   when S8_2 =>
      --
      -- frame header test (final results)
      --

      -- state transition using header test results 
      if ro.pauseok = '1' then
         -- pause frame (always processed, max priority) 
         r.FSMrxbufrd := S10_0;
      elsif ro.destaddrok = '1' and ro.srcaddrok = '1' and ro.daddrok = '1' and ro.saddrok = '1' and ro.dataok = '1' and ro.dataportok = '1' then
         -- data frame ok, continue
         r.frameok := '1';
         r.FSMrxbufrd := S9_0;
      elsif ro.destaddrok = '1' and ro.srcaddrok = '1' and ro.daddrok = '1' and ro.saddrok = '1' and ro.cmdok = '1' and ro.cmdportok = '1' then
         -- cmd ok, continue
         r.FSMrxbufrd := S11_0;
      else
         -- frame not valid: frame discarded, to buffer flush
         r.FSMrxbufrd := S2_1;
      end if; 

   when S9_0 =>
      --
      -- frame ok signaled (clk1) 
      --
      r.FSMrxbufrd := S9_1;

   when S9_1 =>
      --
      -- frame ok signaled (clk2)
      -- 
      r.FSMrxbufrd := S9_2;
      -- note: 'frameok' output asserted 2 clock cycles before data extraction loop
      -- (rxport module needs time to process current frame header) 

   when S9_2 =>
      --
      -- frame data extraction
      -- 

      -- lencounter++
      n.lencounter_inc := '1';
      -- note: lencounter++ just before data extraction loop 
      -- (current datalen = framelen info, current lencounter = 0 --> 'test_datalen' is 
      -- calculated using current values and will be valid next clock cycle)
 
      r.FSMrxbufrd := S9_3;

   when S9_3 =>
      --
      -- frame data extraction until eoframe
      -- 
      if n.eoframe = '0' then
         -- frame not done: datalen test
         if ro.test_datalen = '0' then
            -- valid data to rxport module
            n.rxportwrreq := '1';
         else
            -- data extraction done: loop will continue with pad/crc bytes
            null;
         end if;     

         -- lencounter++
         n.lencounter_inc := '1';

         -- frame not done: next data        
         n.rxdatabuf.inputs.rdreq := '1';
      else         
         -- frame done: to idle state   
         r.frameok := '0';
         n.rxframedone := '1';
         r.FSMrxbufrd := S1;
      end if;

   when S10_0 =>
      --
      -- pause frame detected
      --
      if i.mode_pause = '1' then 
         -- pause enabled: new pausequanta received, continue
         r.pausequanta := ro.cmdpause_quanta;
         r.FSMrxbufrd  := S10_1;
      else
         -- pause not enabled: to buffer flush (pause frame discarded)
         r.FSMrxbufrd := S2_1;
         -- note: pausequanta unchanged when 'mode_pause = 0' (last pausequanta received)
      end if;

   when S10_1 =>
      --
      -- pause frame done 
      -- 

      -- 'pausedone' pulse to output
      n.pausedone := '1';

      -- frame data field discarded, to buffer flush
      r.FSMrxbufrd := S2_1;

   when S11_0 =>
      --
      -- cmd frame: cmdfifo updated
      --
      if n.cmdfifo_full = '0' then
         -- single register fifo not full: write op
         n.cmdfifo_wrreq := '1';
         -- cmd frame: continue  
         r.FSMrxbufrd := S11_1;
      else
         -- fifo is full: cmd frame discarded
         r.FSMrxbufrd := S2_1;
      end if;

   when S11_1 =>
      --
      -- cmd frame done 
      --

      -- 'cmddone' pulse to output
      n.cmddone := '1';

      -- frame data field discarded, to buffer flush
      r.FSMrxbufrd := S2_1;
      -- note: all commands transported by frame header, frame data field ignored   

   end case;

   --
   -- cmd frame: single register output fifo
   --
   -- read side logic (always ON)
   if i.cmdread = '1' and ro.cmdready = '1' then
      -- read request accepted
      r.cmdready := '0';
   end if;
   -- write side logic (after read side logic, max priority)
   if n.cmdfifo_wrreq = '1' and r.cmdready = '0' then
      -- fifo is empty | fifo would become empty because read request in progress --> write request accepted
      r.cmdready := '1';
      r.cmdsrcport  := ro.UDP_srcport;
      r.cmddestaddr := ro.destaddr;
      r.cmdsrcaddr  := ro.srcaddr;
      r.cmdcode     := ro.cmdfield;
      r.cmdports    := ro.ports;
      r.cmdparams   := ro.params(0 to 5);
   end if;
   n.cmdfifo_full := ro.cmdready;
   -- note: write side logic uses current 'cmdready' value (r.NNNNNNN) --> same clock cycle read+write supported

   --
   -- frame length test
   --

   -- IP/UDP length test 0
   r.test_framelen(0) := '0';
   if UINT(ro.IPv4_length) + (6 + 6 + 2 + 4) <= UINT(n.rxtagbuf.outputs.q(13 downto 0)) then
      r.test_framelen(0) := '1';
      -- note: received IP/UDP packet must be completely contained into current frame  
   end if;

   -- IP/UDP length test 1
   r.test_framelen(1) := '0';
   if UINT(ro.UDP_length) + (20 + UINT(ro.IPv4_opt_len) * 4) = UINT(ro.IPv4_length) then
      r.test_framelen(1) := '1';
      -- note: 'IPv4_length' must match 'UDP_length' 
   end if;

   -- frame datalen
   r.datalen := ro.ldata(13 downto 0);
   if UINT(ro.ldata(13 downto 0)) + (8+10) >= UINT(ro.UDP_length) then
      -- wrong ldata field: datalen adjusted
      r.datalen := SLV(UINT(ro.UDP_length) - (8+10), r.datalen);
   end if;
   -- note: data extraction loop uses true datafield length
   -- (clipping test using UDP_length is implemented to avoid errors when ldata 
   -- contains a wrong length --> crc/pad field never recognized as valid data)  
   --
   -- note1: 'datalen' applies only when all IP/UDP framelen test are valid
   -- (IP/UDP packet completely contained into received frame, UDP_length must match
   -- IP/option/UDP total length) 

   -- datalen test
   r.test_datalen := '0';
   if UINT(ro.lencounter(13 downto 0)) >= UINT(ro.datalen(13 downto 0)) then
      -- (lencounter >= datalen) --> data field done, frame may contain extra pad bytes
      r.test_datalen := '1';
   end if;

   -- lencounter control
   if n.lencounter_clr = '1' then
      r.lencounter := SLV(0, r.lencounter);      
   elsif n.lencounter_inc = '1' then
      r.lencounter := ro.lencounter + 1; 
   end if;

   -- destport test
   r.test_destport := '0';
   if (UINT(ro.destport) >= 1) and (UINT(ro.destport) <= RX_NPORTS) then
      -- valid port address: 1..NPORTS
      r.test_destport := '1';
   end if;

end procedure;


--
-- Destination address test (edit)
--
-- clock domain: clk2
--
procedure SubDestAddressTest
(
   variable i : in inputs_t;
   variable ri: in reglist1_t;
   variable ro: in reglist1_t;
   variable o : inout outputs_t;
   variable r : inout reglist1_t;
   variable n : inout netlist_t
) is

constant BROADCAST_ADDR   : rxframe1_byte_vector_t(0 to 5) := (x"FF", x"FF", x"FF", x"FF", x"FF", x"FF");
-- !! Debug !!
--constant TXMULTICAST_ADDR : rxframe1_byte_vector_t(0 to 5) := (x"01", x"00", x"5E", x"7F", x"00", x"00");
---- note: MAC multicast pattern 01-00-5E-7F-00-00 corresponds to IP multicast 239.255.0.NNN (see (*) SubHeaderTest)
-- !! Debug !!
constant TXMULTICAST_ADDR : rxframe1_byte_vector_t(0 to 5) := (x"01", x"00", x"5E", 
                                                               '0' & SLV(IPv4_MADDR(1), 7), 
                                                                     SLV(IPv4_MADDR(2), 8), 
                                                                     SLV(IPv4_MADDR(3), 8));
-- note: MAC multicast pattern 01-00-5E-[0..7F]-[0..FF]-[0..FF] corresponds to 23bit lsb of IPv4_MADDR (see (*) SubFSMtxframe)
--       (standard "Host Extensions for IP Multicasting" RFC1112, "Administratively Scoped IP Multicast" RFC2365)  
constant SLAVENODE_ADDR   : rxframe1_byte_vector_t(0 to 5) := (x"00", x"01", x"02", x"03", x"04", x"00");
constant TXPAUSE_DADDR    : rxframe1_byte_vector_t(0 to 5) := (x"01", x"80", x"C2", x"00", x"00", x"01");

begin

   if n.test_destaddr_req = '1' then
   -- destaddr test request: n.index selects in-field bytes

   -- destaddr(5) captured (macaddress LSB works as 8bit node/group address and
   -- will be used for header validation) ....forse non serve..... 
   if (n.index = 5) then 
      r.macdestbyte := n.rxdatabuf.outputs.q(7 downto 0);
   end if;

   -- individual destaddr test
   r.test_destaddr_individual(n.index) := '0';
   if n.rxdatabuf.outputs.q(7 downto 0) = SLAVENODE_ADDR(n.index) then
      r.test_destaddr_individual(n.index) := '1';
   end if;
   -- last byte == nodeaddr
   if (n.index = 5) and (n.rxdatabuf.outputs.q(7 downto 0) = i.nodeaddr) then
      r.test_destaddr_individual(5) := '1';
   end if;   

   -- multicast destaddr test
   r.test_destaddr_multicast(n.index) := '0';
   if n.rxdatabuf.outputs.q(7 downto 0) = TXMULTICAST_ADDR(n.index) then
      r.test_destaddr_multicast(n.index) := '1';
   end if;
   -- last byte == multicastaddr
   if (n.index = 5) then -- and (n.rxdatabuf.outputs.q(7 downto 0) = i.multicastaddr) then
      r.test_destaddr_multicast(5) := '1';
      -- note: multicast filter works on bytes 0..4, last byte always accepted
      -- (network nodes may recognize one/more multicast addresses)
   end if;

   -- broadcast destaddr test
   r.test_destaddr_broadcast(n.index) := '0';
   if n.rxdatabuf.outputs.q(7 downto 0) = BROADCAST_ADDR(n.index) then
      r.test_destaddr_broadcast(n.index) := '1';
   end if;

   -- pause destaddr test
   r.test_destaddr_pause(n.index) := '0';
   if n.rxdatabuf.outputs.q(7 downto 0) = TXPAUSE_DADDR(n.index) then
      r.test_destaddr_pause(n.index) := '1';
   end if;

   end if;

end procedure; 


--
-- Source address test (edit)
--
-- clock domain: clk2
--
procedure SubSrcAddressTest
(
   variable i : in inputs_t;
   variable ri: in reglist1_t;
   variable ro: in reglist1_t;
   variable o : inout outputs_t;
   variable r : inout reglist1_t;
   variable n : inout netlist_t
) is

constant SLAVENODE_ADDR   : rxframe1_byte_vector_t(0 to 5) := (x"00", x"01", x"02", x"03", x"04", x"00");
constant MASTERNODE_ADDR  : rxframe1_byte_vector_t(0 to 5) := (x"00", x"11", x"22", x"33", x"44", x"00");
-- note: custom slave/master address with constant pattern
constant SRC_BROADCAST_ADDR : rxframe1_byte_vector_t(0 to 5) := (x"00", x"AA", x"BB", x"CC", x"DD", x"00");
-- note: custom address reserved for src "broadcast" --> address works as a backdoor when
-- srcaddr filter is enabled; this custom address must have address-type individual --> [x"00"],x"AA",...

begin

   if n.test_srcaddr_req = '1' then
   -- srcaddr test request: n.index selects in-field bytes

   -- srcaddr(5) captured (macaddress LSB works as 8bit node address and
   -- will be used for header validation) ....forse non serve....
   if (n.index = 5) then 
      r.macsrcbyte := n.rxdatabuf.outputs.q(7 downto 0);
   end if;

   -- srcaddr test (slave nodes)
   r.test_srcaddr_slave(n.index) := '0';
   if n.rxdatabuf.outputs.q(7 downto 0) = SLAVENODE_ADDR(n.index) then
      r.test_srcaddr_slave(n.index) := '1';
   end if;
   -- last byte == slaveaddr
   if (n.index = 5) then
      r.test_srcaddr_slave(5) := '1';
      -- note: srcaddr filter works on bytes 0..4, last byte always accepted
      -- (any network node can be the source of current frame) 
   end if;

   -- srcaddr test (master nodes)
   r.test_srcaddr_master(n.index) := '0';
   if n.rxdatabuf.outputs.q(7 downto 0) = MASTERNODE_ADDR(n.index) then
      r.test_srcaddr_master(n.index) := '1';
   end if;
   -- last byte == masteraddr
   if (n.index = 5) then
      r.test_srcaddr_master(5) := '1';
      -- note: srcaddr filter works on bytes 0..4, last byte always accepted
      -- (any network node can be the source of current frame) 
   end if;
   -- note: srcaddr filter only accepts master nodes programmed with custom macaddress
   -- (to keep logic simple we do not use a dedicated rxframe-mac-lut, this filter must
   -- be OFF when network master nodes use their own macaddress)     

   -- broadcast srcaddr test
   r.test_srcaddr_broadcast(n.index) := '0';
   if n.rxdatabuf.outputs.q(7 downto 0) = SRC_BROADCAST_ADDR(n.index) then
      r.test_srcaddr_broadcast(n.index) := '1';
   end if;
   -- last byte == masteraddr
   if (n.index = 5) then
      r.test_srcaddr_broadcast(5) := '1';
      -- note: srcaddr filter works on bytes 0..4, last byte always accepted
   end if;   

   end if;

end procedure; 


--
-- LenType test (edit)
--
-- clock domain: clk2
--
procedure SubLenTypeTest
(
   variable i : in inputs_t;
   variable ri: in reglist1_t;
   variable ro: in reglist1_t;
   variable o : inout outputs_t;
   variable r : inout reglist1_t;
   variable n : inout netlist_t
) is
constant LENTYPE_IPv4  : rxframe1_byte_vector_t(0 to 1) := (x"08", x"00");
constant LENTYPE_PAUSE : rxframe1_byte_vector_t(0 to 1) := (x"88", x"08"); 
constant LENTYPE_JUMBO : rxframe1_byte_vector_t(0 to 1) := (x"88", x"70"); 

begin

   if n.test_lentype_req = '1' then
   -- lentype test request: n.index selects in-field bytes

--   -- lentype field capture
--   if n.index = 0 then
--      r.lentype(15 downto 8) := n.rxdatabuf.outputs.q(7 downto 0);
--   end if;
--   if n.index = 1 then
--      r.lentype(7 downto 0) := n.rxdatabuf.outputs.q(7 downto 0);
--   end if;
-- puo' servire per controllare la lunghezza....oppure si accetta tutto
-- quello che arriva......per il momento basta il solo test su srcaddr + lentype ?????????

   -- lentype test (IPv4)
   r.test_lentype_ipv4(n.index) := '0';
   if n.rxdatabuf.outputs.q(7 downto 0) = LENTYPE_IPv4(n.index) then 
      r.test_lentype_ipv4(n.index) := '1';
   end if;

   -- lentype test (pause)
   r.test_lentype_pause(n.index) := '0';
   if n.rxdatabuf.outputs.q(7 downto 0) = LENTYPE_PAUSE(n.index) then 
      r.test_lentype_pause(n.index) := '1';
   end if;

   -- lentype test (jumbo)
   r.test_lentype_jumbo(n.index) := '0';
   if n.rxdatabuf.outputs.q(7 downto 0) = LENTYPE_JUMBO(n.index) then 
      r.test_lentype_jumbo(n.index) := '1';
   end if;

   end if;

end procedure; 


--
-- Header test (edit)
--
-- clock domain: clk2
--
procedure SubHeaderTest
(
   variable i : in inputs_t;
   variable ri: in reglist1_t;
   variable ro: in reglist1_t;
   variable o : inout outputs_t;
   variable r : inout reglist1_t;
   variable n : inout netlist_t
) is
--
-- PAUSE command
--
constant CMDPAUSE : rxframe1_byte_vector_t(0 to 1) := (x"00", x"01");

--
-- IP header
--
-- !! Debug !!
--constant RXIP_SADDR : rxframe1_byte_vector_t(0 to 3) := (SLV(192,8), SLV(168,8), SLV(  0,8), SLV(  0,8)); -- Unicast Src Address
--constant RXIP_DADDR : rxframe1_byte_vector_t(0 to 3) := (SLV(192,8), SLV(168,8), SLV(  0,8), SLV(  0,8)); -- Unicast Dest Address
--constant RXIP_MADDR : rxframe1_byte_vector_t(0 to 3) := (SLV(239,8), SLV(255,8), SLV(  0,8), SLV(  0,8)); -- Multicast Dest Address (see (*) SubDestAddrTest)
--constant RXIP_BADDR : rxframe1_byte_vector_t(0 to 3) := (SLV(192,8), SLV(168,8), SLV(  0,8), SLV(255,8)); -- Network Broadcast Dest Address 
-- !! Debug !!
constant RXIP_SADDR : rxframe1_byte_vector_t(0 to 3) := (SLV(IPv4_NADDR(0), 8), SLV(IPv4_NADDR(1), 8), SLV(IPv4_NADDR(2), 8), SLV(IPv4_NADDR(3), 8)); -- Unicast Src Address
constant RXIP_DADDR : rxframe1_byte_vector_t(0 to 3) := (SLV(IPv4_NADDR(0), 8), SLV(IPv4_NADDR(1), 8), SLV(IPv4_NADDR(2), 8), SLV(IPv4_NADDR(3), 8)); -- Unicast Dest Address
constant RXIP_MADDR : rxframe1_byte_vector_t(0 to 3) := (SLV(IPv4_MADDR(0), 8), SLV(IPv4_MADDR(1), 8), SLV(IPv4_MADDR(2), 8), SLV(IPv4_MADDR(3), 8)); -- Multicast Dest Address (see (*) SubDestAddrTest)
constant RXIP_BADDR : rxframe1_byte_vector_t(0 to 3) := (SLV(IPv4_BADDR(0), 8), SLV(IPv4_BADDR(1), 8), SLV(IPv4_BADDR(2), 8), SLV(IPv4_BADDR(3), 8)); -- Network Broadcast Dest Address 
constant RXIP_BCAST : rxframe1_byte_vector_t(0 to 3) := (SLV(255,8), SLV(255,8), SLV(255,8), SLV(255,8)); -- Broadcast Dest Address

--
-- UDP header
--
subtype rxframe1_udpport_t is std_logic_vector(15 downto 0);
-- Base UDP srcport/destport = 10000 (pattern 0xNNN[0] = 0x2710)
constant RXUDP_BASEPORT : rxframe1_udpport_t := SLV(10000, 16);                            
constant RXUDP_SRCPORT  : rxframe1_udpport_t := RXUDP_BASEPORT;                            
constant RXUDP_DESTPORT : rxframe1_udpport_t := RXUDP_BASEPORT;                            
--
-- Note: All network nodes share the UDPport space 10000..10015
--       Slave side:  UDPports 10000..10015 are hardware-assigned to slave functions (i.e. CPU_PORT = 10001, port 10000 is reserved for commands).
--       Master side: UDPports 10000..10015 represent a 'pool' of 16 generic ports (process/threads choose a port-number from this 'pool',
--       slave nodes will reply to master-node requests using received port numbers).
-- 

begin

   if n.test_header_req = '1' then
   -- header test request: n.index selects header bytes

   -- IPv4 test
   if n.index = 0 then
      r.test_IPv4 := '0';
      if UINT(n.rxdatabuf.outputs.q(7 downto 4)) = 4 and UINT(n.rxdatabuf.outputs.q(3 downto 0)) >= 5 then
         -- pattern '0x4[5..F]' --> IPv4 frame
         r.test_IPv4 := '1';
      end if;
      -- note: 'test_IPv4' is applicable only when ltype IPv4 detected ????? oppure NO perche' c'e' anche il caso jumbo-frame ???
      r.test_IPv4_option := '0';
      if UINT(n.rxdatabuf.outputs.q(3 downto 0)) > 5 then
         r.test_IPv4_option := '1';
      end if;
      -- capture 'IPv4_opt_len' (max length = 15 - 5 = 10 word32)
      r.IPv4_opt_len := SLV(UINT(n.rxdatabuf.outputs.q(3 downto 0)) - 5, 4);
      -- note: 'test_IPv4_option','IPv4_opt_len' are applicable only when 'test_IPv4' asserted
   end if;

   -- IPv4 TOS field
   if n.index = 1 then
      null;
   end if;
   -- note: IPv4 TOS field ignored

   -- IPv4 length field
   if n.index = 2 then
      r.IPv4_length(15 downto 8) := n.rxdatabuf.outputs.q(7 downto 0);
   end if;
   --
   if n.index = 3 then
      r.IPv4_length(7 downto 0) := n.rxdatabuf.outputs.q(7 downto 0);
   end if;
   -- note: 'IPv4_length' captured for IP/UDP length test

   -- IPv4 identification field
   if n.index = 4 then
      null;
   end if;
   --
   if n.index = 5 then
      null;
   end if;
   -- note: IPv4 identification ignored 

   -- IPv4 fragment field 
   if n.index = 6 then
      r.test_IPv4_unfragment(0) := '0';
      if UINT(n.rxdatabuf.outputs.q(7 downto 0) and "10111111") = 0 then
         r.test_IPv4_unfragment(0) := '1';
      end if;
   end if;
   --
   if n.index = 7 then
      r.test_IPv4_unfragment(1) := '0';
      if UINT(n.rxdatabuf.outputs.q(7 downto 0)) = 0 then
         r.test_IPv4_unfragment(1) := '1';
      end if;
   end if;
   -- note: fragment 'DF' bit ignored, all others bits must be zero

   -- IPv4 TTL field
   if n.index = 8 then
      null;
   end if;
   -- note: IPv4 TTL field ignored

   -- IPv4 protocol field 
   if n.index = 9 then
      r.test_IPv4_udp_protocol := '0';
      if UINT(n.rxdatabuf.outputs.q(7 downto 0)) = 17 then
         r.test_IPv4_udp_protocol := '1';
      end if;
   end if;

   -- IPv4 checksum field
   if n.index = 10 then
      null;
   end if;
   --
   if n.index = 11 then
      null;
   end if;
   -- note: IPv4 checksum not tested (frame is validated by cross-checking all IP/UDP/header fields)

   -- IPv4 srcaddr (note: must be unicast)
   if n.index = 12+0 then
      r.test_IPv4_srcaddr(0) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = RXIP_SADDR(0) then
         r.test_IPv4_srcaddr(0) := '1';
      end if;
   end if;
   --
   if n.index = 12+1 then
      r.test_IPv4_srcaddr(1) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = RXIP_SADDR(1) then
         r.test_IPv4_srcaddr(1) := '1';
      end if;
   end if;
   --
   if n.index = 12+2 then
      r.test_IPv4_srcaddr(2) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = RXIP_SADDR(2) then    
         r.test_IPv4_srcaddr(2) := '1';
      end if;
   end if;
   --
   if n.index = 12+3 then
      -- capture 'IPv4_srcaddr' (8bit low)
      r.IPv4_srcaddr := n.rxdatabuf.outputs.q(7 downto 0);
      r.test_IPv4_srcaddr(3) := '0';
      if (UINT(n.rxdatabuf.outputs.q(7 downto 0)) /= 0) and (UINT(n.rxdatabuf.outputs.q(7 downto 0)) /= 255) then 
         -- srcaddr must be unicast (valid range 1..254, 'zero' | 'allones' not allowed) 
         r.test_IPv4_srcaddr(3) := '1';
      end if;      
      -- note: srcaddr filter works on bytes 0..2, last byte always accepted (any network node
      -- with address 1..254)
   end if;

   -- IPv4 destaddr (note: can be unicast/multicast/netcast/broadcast)
   if n.index = 16+0 then
      r.test_IPv4_destaddr_ucast(0) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = RXIP_DADDR(0) then
         r.test_IPv4_destaddr_ucast(0) := '1';
      end if;
      r.test_IPv4_destaddr_mcast(0) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = RXIP_MADDR(0) then
         r.test_IPv4_destaddr_mcast(0) := '1';
      end if;
      r.test_IPv4_destaddr_ncast(0) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = RXIP_BADDR(0) then
         r.test_IPv4_destaddr_ncast(0) := '1';
      end if;
      r.test_IPv4_destaddr_bcast(0) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = RXIP_BCAST(0) then
         r.test_IPv4_destaddr_bcast(0) := '1';
      end if;
   end if;
   --
   if n.index = 16+1 then
      r.test_IPv4_destaddr_ucast(1) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = RXIP_DADDR(1) then
         r.test_IPv4_destaddr_ucast(1) := '1';
      end if;
      r.test_IPv4_destaddr_mcast(1) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = RXIP_MADDR(1) then
         r.test_IPv4_destaddr_mcast(1) := '1';
      end if;
      r.test_IPv4_destaddr_ncast(1) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = RXIP_BADDR(1) then
         r.test_IPv4_destaddr_ncast(1) := '1';
      end if;
      r.test_IPv4_destaddr_bcast(1) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = RXIP_BCAST(1) then
         r.test_IPv4_destaddr_bcast(1) := '1';
      end if;
   end if;
   --
   if n.index = 16+2 then
      r.test_IPv4_destaddr_ucast(2) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = RXIP_DADDR(2) then
         r.test_IPv4_destaddr_ucast(2) := '1';
      end if;
      r.test_IPv4_destaddr_mcast(2) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = RXIP_MADDR(2) then    
         r.test_IPv4_destaddr_mcast(2) := '1';
      end if;
      r.test_IPv4_destaddr_ncast(2) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = RXIP_BADDR(2) then    
         r.test_IPv4_destaddr_ncast(2) := '1';
      end if;
      r.test_IPv4_destaddr_bcast(2) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = RXIP_BCAST(2) then    
         r.test_IPv4_destaddr_bcast(2) := '1';
      end if;
   end if;
   --
   if n.index = 16+3 then
      r.test_IPv4_destaddr_ucast(3) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = i.nodeaddr then
         r.test_IPv4_destaddr_ucast(3) := '1';
      end if;
      r.test_IPv4_destaddr_mcast(3) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = i.multicastaddr then 
         r.test_IPv4_destaddr_mcast(3) := '1';
      end if;
      r.test_IPv4_destaddr_ncast(3) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = RXIP_BADDR(3) then 
         r.test_IPv4_destaddr_ncast(3) := '1';
      end if;
      r.test_IPv4_destaddr_bcast(3) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = RXIP_BCAST(3) then 
         r.test_IPv4_destaddr_bcast(3) := '1';
      end if;
   end if;

   -- UDP srcport
   if n.index = 20+0 then
      r.test_UDP_srcport(0) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = RXUDP_SRCPORT(15 downto 8) then
         r.test_UDP_srcport(0) := '1';
      end if;
   end if;
   --
   if n.index = 20+1 then
      r.test_UDP_srcport(1) := '0';
      if n.rxdatabuf.outputs.q(7 downto 4) = RXUDP_SRCPORT(7 downto 4) then
         r.test_UDP_srcport(1) := '1';
         -- note: nibble lsb always accepted
      end if;
      -- capture 'UDP_srcport'
      r.UDP_srcport := n.rxdatabuf.outputs.q(3 downto 0);
   end if;

   -- UDP destport
   if n.index = 22+0 then
      r.test_UDP_destport(0) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = RXUDP_DESTPORT(15 downto 8) then
         r.test_UDP_destport(0) := '1';
      end if;
   end if;
   --
   if n.index = 22+1 then
      r.test_UDP_destport(1) := '0';
      if n.rxdatabuf.outputs.q(7 downto 4) = RXUDP_DESTPORT(7 downto 4) then
         r.test_UDP_destport(1) := '1';
         -- note: nibble lsb always accepted
      end if;
      -- capture 'UDP_destport'
      r.UDP_destport := n.rxdatabuf.outputs.q(3 downto 0);
   end if;

   -- UDP length
   if n.index = 24+0 then
      r.UDP_length(15 downto 8) := n.rxdatabuf.outputs.q(7 downto 0);
   end if;
   --
   if n.index = 24+1 then
      r.UDP_length(7 downto 0) := n.rxdatabuf.outputs.q(7 downto 0);
   end if;
   -- note: 'UDP_length' captured for IP/UDP length test

   -- UDP checksum
   if n.index = 26+0 then
      null;
   end if;
   --
   if n.index = 26+1 then
      null;
   end if;
   -- note: UDP checksum not tested (frame is validated by cross-checking all IP/UDP/header fields)

   -- all header fields captured
   if n.index = 28+0 then
      r.destaddr := n.rxdatabuf.outputs.q(7 downto 0);
   end if;
   if n.index = 28+1 then
      r.srcaddr := n.rxdatabuf.outputs.q(7 downto 0);
   end if;
   if n.index = 28+2 then
      r.cmdfield := n.rxdatabuf.outputs.q(7 downto 0);
   end if;
   if n.index = 28+3 then
      r.destport := n.rxdatabuf.outputs.q(7 downto 4);
      r.srcport  := n.rxdatabuf.outputs.q(3 downto 0);
      r.ports    := n.rxdatabuf.outputs.q(7 downto 0);
   end if;
   if n.index = 28+4 then
      r.params(0) := n.rxdatabuf.outputs.q(7 downto 0);
   end if;
   if n.index = 28+5 then
      r.params(1) := n.rxdatabuf.outputs.q(7 downto 0);
   end if;
   if n.index = 28+6 then
      r.params(2) := n.rxdatabuf.outputs.q(7 downto 0);
   end if;
   if n.index = 28+7 then
      r.params(3) := n.rxdatabuf.outputs.q(7 downto 0);
   end if;
   if n.index = 28+8 then
      r.params(4) := n.rxdatabuf.outputs.q(7 downto 0);
      r.ldata(15 downto 8) := r.params(4);
   end if;
   if n.index = 28+9 then
      r.params(5) := n.rxdatabuf.outputs.q(7 downto 0);
      r.ldata(7 downto 0) := r.params(5);
   end if;

   -- daddr test
   if n.index = 28+0 then
      -- unicast node address
      r.test_daddr := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = i.nodeaddr then 
         r.test_daddr := '1';  
         -- note: 'test_daddr' is applicable only when IPunicast destaddr detected
      end if;
      -- broadcast node address
      r.test_baddr := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = "11111111" then 
         r.test_baddr := '1';  
         -- note: 'test_baddr' is applicable only when IPbroadcast destaddr detected
      end if;
      -- multicast group address
      r.test_maddr := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = i.multicastaddr then 
         -- group address matches current multicastaddr groupmask
         r.test_maddr := '1';  
         -- note: 'test_maddr' is applicable only when IPmulticast destaddr detected
      end if;
   end if;

   -- saddr test
   if n.index = 28+1 then
      r.test_saddr := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = ro.IPv4_srcaddr then 
         -- saddr must be equal to 'IPv4_srcaddr'
         r.test_saddr := '1';
      end if;
      -- note: 'saddr test' combines current 'rxdatabuf' with
      -- register 'ro.IPv4_srcaddr' (register has been loaded when 'n.index = 12+3')
   end if;

   -- multicast test
   if n.index = 28+2 then
      r.test_multicast := '0';
      if n.rxdatabuf.outputs.q(7) = '1' then
         -- destaddr is a multicast group
         r.test_multicast := '1';
         -- note: bit7 works as additional bit for 'daddr' field to indicate
         -- multicast group address   
      end if;
   end if;

   -- data frame test
   if n.index = 28+2 then
      r.test_dataframe := '0';
      if UINT(n.rxdatabuf.outputs.q(3 downto 0)) = 0 then
         r.test_dataframe := '1';
      end if;
      -- note: 4bit cmd.code = zero
   end if;

   -- cmd frame test
   if n.index = 28+2 then
      r.test_cmdframe := '0';
      if UINT(n.rxdatabuf.outputs.q(3 downto 0)) /= 0 then
         r.test_cmdframe := '1';
      end if;
      -- note: 4bit cmd.code <> zero
   end if;

   -- pause command test
   if n.index = 0 then
      r.test_cmdpause(0) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = CMDPAUSE(0) then 
         r.test_cmdpause(0) := '1';
      end if;
   end if;
   if n.index = 1 then
      r.test_cmdpause(1) := '0';
      if n.rxdatabuf.outputs.q(7 downto 0) = CMDPAUSE(1) then 
         r.test_cmdpause(1) := '1';
      end if;
   end if;
   -- pause quanta captured
   if n.index = 2 then
      r.cmdpause_quanta(15 downto 8) := n.rxdatabuf.outputs.q(7 downto 0);
   end if;
   --
   if n.index = 3 then
      r.cmdpause_quanta(7 downto 0) := n.rxdatabuf.outputs.q(7 downto 0);
   end if;
   -- note: synthesis will remove all redundant registers 
   -- (index = 2..3 --> 'cmdpause_quanta' is a duplicate of 'IPv4_length' field)

--......aggiungere un test tra ldata e framelen ???? non sembra fondamentale, il data loop si ferma
--......comunque alla fine della frame...vedi test sulla frame length IP/UDP

   end if;

end procedure; 


--
-- Output data control (edit)
--
-- clock domain: clk2
--
procedure SubOutputData
(
   variable i : in inputs_t;
   variable ri: in reglist1_t;
   variable ro: in reglist1_t;
   variable o : inout outputs_t;
   variable r : inout reglist1_t;
   variable n : inout netlist_t
) is
begin
   --
   -- rx-interface outputs
   --

   -- rxenable status flag
   o.rxenablests := ro.rxframeon;

   -- rxdata path
   o.rxdata := n.rxdatabuf.outputs.q(7 downto 0);
   o.rxdatalen := ro.datalen;
   o.rxdestaddr := ro.destaddr;
   o.rxmulticast := ro.test_multicast;
   o.rxdestport := ro.destport;
   o.rxsrcaddr := ro.srcaddr;
   o.rxsrcport := ro.srcport;
   o.rxseqnum  := (ro.params(0) & ro.params(1) & ro.params(2) & ro.params(3)); -- ??? oppure 3,2,1,0
   o.rxldata   := ro.ldata;
   -- !!! per il momento si restituiscono tutti i campi header 10byte che sono stati gia' controllati e che
   --     sono allineati all'header IP/UDP...sara' da rivedere e forse occorrera' restituire solo i campi IP/UDP mentre
   --     dall'header 10byte si useranno solo i parametri seqnum + ldata (tutto il resto e' gia' codificato nel
   --     header IP/UDP...) !!!     

   o.rxwrreq := n.rxportwrreq;
   o.rxframeok := ro.frameok;
   o.rxframedone := n.rxframedone;

   --
   -- pause frame outputs 
   --
   o.pausequanta := ro.pausequanta(15 downto 0);
   o.pausedone   := n.pausedone;
   -- note: 'pausedone' generated when new pausequanta is ready --> 'FSMrxbufrd = S10_1'

   --
   -- command frame outputs
   --
   o.cmdready    := ro.cmdready;
   o.cmdsrcport  := ro.cmdsrcport;
   o.cmddestaddr := ro.cmddestaddr;
   o.cmdsrcaddr  := ro.cmdsrcaddr;
   o.cmdcode     := ro.cmdcode;
   o.cmdports    := ro.cmdports;
   o.cmdparams   := ro.cmdparams(0 to 5);
   o.cmddone     := n.cmddone;
   -- note: 'cmddone' generated when new command is ready --> 'FSMrxbufrd = S11_1'

end procedure; 


--
-- Debug combinatorial procedure (edit)
--
-- all clock domains
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

   null;

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
   n.rxdatabuf.outputs := allcmps.rxdatabuf.outputs;
   n.rxtagbuf.outputs := allcmps.rxtagbuf.outputs;
   n.rxcrc.outputs := allcmps.rxcrc.outputs;

   --
   -- all procedures call (edit)
   --

   -- clock domain clk2
   SubFSMrxbufwr     (i, ri.clk2, ro.clk2, o, r.clk2, n);

   -- clock domain clk1
   SubFSMrxbufrd     (i, ri.clk1, ro.clk1, o, r.clk1, n);
   SubDestAddressTest(i, ri.clk1, ro.clk1, o, r.clk1, n);
   SubSrcAddressTest (i, ri.clk1, ro.clk1, o, r.clk1, n);
   SubLenTypeTest    (i, ri.clk1, ro.clk1, o, r.clk1, n);
   SubHeaderTest     (i, ri.clk1, ro.clk1, o, r.clk1, n);
   SubOutputData     (i, ri.clk1, ro.clk1, o, r.clk1, n);

   -- all clock domains
   SubDebug(i, ri, ro, o, r, n);

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
-- architecture rtl of rxframe1
--
--**************************************************************

