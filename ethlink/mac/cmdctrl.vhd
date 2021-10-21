--**************************************************************
--**************************************************************
--
-- Template file: comp_ck1.rec (new component, single clk)
--
--**************************************************************
--**************************************************************
--
--
-- Component cmdctrl
--
--
--
--
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

-- libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- 
use work.component_txport1.all;
use work.component_rxport1.all;
-- note: components txport1,rxport1 are included at package level because 
-- some I/O definitions use constants 'txport1_NPORTS','rxport1_NPORTS'

package component_cmdctrl is

--
-- cmdctrl constants (edit)
--
-- constant cmdctrl_[constant_name] : [type] := [value];
--

--
-- cmdctrl typedefs (edit)
--
-- subtype cmdctrl_[name]_t is [type];
-- type cmdctrl_[name]_t is [type];
--
subtype cmdctrl_nibble_t is std_logic_vector(3 downto 0);
type cmdctrl_nibble_vector_t is array(NATURAL RANGE <>) of cmdctrl_nibble_t;
subtype cmdctrl_byte_t is std_logic_vector(7 downto 0);
type cmdctrl_byte_vector_t is array(NATURAL RANGE <>) of cmdctrl_byte_t;
subtype cmdctrl_seqnum_t is std_logic_vector(31 downto 0);
type cmdctrl_seqnum_vector_t is array(NATURAL RANGE <>) of cmdctrl_seqnum_t;

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- cmdctrl inputs (edit)
--
type cmdctrl_inputs_t is record

   -- clock list
   clk2 : std_logic;

   -- reset list
   rst2 : std_logic;
   
   -- txport read-side status (clock domain clk2, rst2)
   tport_renable : std_logic_vector(1 to txport1_NPORTS);
   tport_rerror  : std_logic_vector(1 to txport1_NPORTS);
   tport_rseqnum : cmdctrl_seqnum_vector_t(1 to txport1_NPORTS);
   --
   -- renable --> txport status (read side)
   -- rerror  --> write op when full | write op when not ready (read side, 'werror' sticky bit)
   -- rseqnum --> seqnum status (read side only, array 1..NPORTS of 32bit counters)
   --

   -- rxport write-side status (clock domain clk2, rst2)
   rport_wready   : std_logic_vector(1 to rxport1_NPORTS);
   rport_rxseqnum : cmdctrl_seqnum_vector_t(1 to rxport1_NPORTS);
   -- 
   rport_werrempty : std_logic_vector(1 to rxport1_NPORTS); 
   rport_werrfull  : std_logic_vector(1 to rxport1_NPORTS); 
   --
   -- wready  --> rxport ready (rready status to write-side)
   -- rxseqnum --> rxport seqnum (array 1..NPORTS of 32bit counters)
   -- 
   -- werrempty --> read-when-empty error (rerrempty status to write-side)
   -- werrfull  --> write-when-full error (sticky bit, write-side)
   --               note: sticky bit, cleared when rxport re-enabled

   -- txframe status (clock domain clk2, rst2)
   tx_enablests  : std_logic;
   tx_cmddone    : std_logic;
   tx_cmdregfull : std_logic;
   --
   -- enablests  --> txframe enable status
   -- cmddone    --> txcmd short frame done (pulse, one clock) 
   -- cmdregfull --> cmd input fifo status (1 --> cmd loaded --> fifo full) 
   --

   -- macread command
   tx_macread_data : cmdctrl_byte_vector_t(0 to 5);
   tx_macread_addr : std_logic_vector(3 downto 0);
   tx_macread_ok   : std_logic;
   --
   -- macread_data --> data from last macread command (48bit mac)
   -- macread_addr --> addr from last macread command (4bit maclut index)
   -- macread_ok   --> macread data ok (pulse, one clock)
   --

   -- rxframe status (clock domain clk2, rst2)
   rx_enablests : std_logic;
   --
   -- enablests  --> rxframe enable status
   --

   -- rxframe command interface (clock domain clk2,rst2)
   rx_cmdready    : std_logic;
   rx_cmdsrcport  : std_logic_vector(3 downto 0);
   rx_cmddestaddr : std_logic_vector(7 downto 0);
   rx_cmdsrcaddr  : std_logic_vector(7 downto 0);
   rx_cmdcode     : std_logic_vector(7 downto 0);
   rx_cmdports    : std_logic_vector(7 downto 0);
   rx_cmdparams   : cmdctrl_byte_vector_t(0 to 5);
   rx_cmddone     : std_logic;
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

   -- external interface (clock domain clk2,rst2)
   ext_tport_enable_wr      : std_logic;
   ext_tport_ackenable_wr   : std_logic;
   ext_tport_timerenable_wr : std_logic;
   ext_tport_seqnumclr_wr   : std_logic;
   ext_tport_enable         : std_logic_vector(15 downto 0);
   ext_tport_ackenable      : std_logic_vector(15 downto 0);
   ext_tport_timerenable    : std_logic_vector(15 downto 0);
   ext_tport_seqnumclr      : std_logic_vector(15 downto 0);
   --
   ext_rport_enable_wr    : std_logic; 
   ext_rport_seqnumena_wr : std_logic;
   ext_rport_seqnumclr_wr : std_logic;
   ext_rport_enable       : std_logic_vector(15 downto 0);
   ext_rport_seqnumena    : std_logic_vector(15 downto 0);
   ext_rport_seqnumclr    : std_logic_vector(15 downto 0);

   -- srcfilter control (clock domain clk2,rst2)
   ext_tport_srcfilterena    : std_logic_vector(15 downto 0);
   ext_tport_srcfilterena_wr : std_logic;
   --
   ext_tport_srcfilter       : std_logic_vector(3 downto 0);
   ext_tport_srcfilteraddr   : std_logic_vector(7 downto 0); 
   ext_tport_srcfilterport   : std_logic_vector(3 downto 0); 
   ext_tport_srcfilter_wr    : std_logic;
   --
   ext_rport_srcfilterena    : std_logic_vector(15 downto 0);
   ext_rport_srcfilterena_wr : std_logic;
   --
   ext_rport_srcfilter       : std_logic_vector(3 downto 0);
   ext_rport_srcfilteraddr   : std_logic_vector(7 downto 0); 
   ext_rport_srcfilterport   : std_logic_vector(3 downto 0); 
   ext_rport_srcfilter_wr    : std_logic;

   -- framegen control (clock domain clk2,rst2)
   ext_fgen_ena         : std_logic;
   ext_fgen_loop        : std_logic;
   ext_fgen_trig        : std_logic_vector(15 downto 0);
   ext_fgen_wr          : std_logic;
   --
   ext_fgen_destaddr    : std_logic_vector(7 downto 0);
   ext_fgen_destport    : std_logic_vector(3 downto 0);
   ext_fgen_destaddr_wr : std_logic;
   --
   ext_fgen_destmode    : std_logic_vector(2 downto 0);
   ext_fgen_destmode_wr : std_logic;
   --
   ext_fgen_framelen    : std_logic_vector(10 downto 0);
   ext_fgen_framelen_wr : std_logic;

   -- maclut control (clock domain clk2,rst2)
   ext_maclut_sel  : std_logic_vector(2 downto 0);
   ext_maclut_data : std_logic_vector(7 downto 0);
   ext_maclut_addr : std_logic_vector(3 downto 0);
   ext_maclut_load : std_logic;
   ext_maclut_wr   : std_logic;
   ext_maclut_rd   : std_logic;

end record;

--
-- cmdctrl outputs (edit)
--
type cmdctrl_outputs_t is record

   -- txport cmdctrl-interface (clock domain clk2,rst2)
   tport_enable      : std_logic_vector(1 to txport1_NPORTS);
   tport_ackenable   : std_logic_vector(1 to txport1_NPORTS);
   tport_timerenable : std_logic_vector(1 to txport1_NPORTS);
   --
   tport_cmdseqnumclr   : std_logic_vector(1 to txport1_NPORTS);
   tport_cmdackreceived : std_logic;
   tport_cmdackportaddr : std_logic_vector(3 downto 0);
   tport_cmdackseqnum   : std_logic_vector(31 downto 0);
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

   -- rxport cmdctrl-interface (clock domain clk2,rst2)
   rport_enable    : std_logic_vector(1 to rxport1_NPORTS); 
   --
   rport_seqnumena : std_logic_vector(1 to rxport1_NPORTS);
   rport_seqnumclr : std_logic_vector(1 to rxport1_NPORTS);
   --
   rport_srcfilterena  : std_logic_vector(1 to rxport1_NPORTS);
   rport_srcfilteraddr : cmdctrl_byte_vector_t(1 to rxport1_NPORTS); 
   rport_srcfilterport : cmdctrl_nibble_vector_t(1 to rxport1_NPORTS); 
   --
   -- enable  --> write side enable/flush request (level, cmdctrl driven)
   --             rxport is enabled when both 'rena,enable' are asserted
   --
   -- seqnumena --> seqnum enable flags (level, cmdctrl driven)
   --               0 --> seqnum filter OFF (frames with any 'wseqnum' accepted)
   --               1 --> seqnum filter ON  (frames accepted when 'wseqnum = rxseqnum(wdestport)';
   --                     rxseqnum is incremented at the end of frame-write-operation: frames written into 
   --                     rxport fifos without errors are considered delivered) 
   --
   -- seqnumclr --> rxseqnum(index) = 0 (pulse, 1 clock, cmdctrl driven)
   --               index = 1..NPORTS --> command applied in parallel to all selected ports
   --
   -- srcfilterena  --> srcfilter enable flags (level, cmdctrl driven)
   --                   0 --> srcfilter OFF (any src-node accepted)
   --                   1 --> srcfilter ON  (frame accepted when 'srcaddr,srcport = filteraddr,filterport')
   -- srcfilteraddr     srcfilter address (array 1..NPORTS of 8bit node-addr)
   -- srcfilterport     srcfilter port (array 1..NPORTS of 4bit node-port) 
   --

   -- txframe command-interface (clock domain clk2,rst2)
   tx_cmdwrite     : std_logic;
   tx_cmddestport  : std_logic_vector(3 downto 0);
   tx_cmddestaddr  : std_logic_vector(7 downto 0);
   tx_cmdcode      : std_logic_vector(7 downto 0);
   tx_cmdports     : std_logic_vector(7 downto 0);
   tx_cmdparams    : cmdctrl_byte_vector_t(0 to 5);
   tx_cmd_txreq    : std_logic;
   tx_cmd_macread  : std_logic;
   tx_cmd_macwrite : std_logic;
   --
   -- cmdwrite     --> command write request (cmd written to single register input fifo, pulse, 1 clock) 
   -- cmddestport  --> destport (4bit)
   -- cmddestaddr  --> destaddr (8bit)
   -- cmdcode      --> code (8bit)
   -- cmdports     --> ports (8bit)
   -- cmdparams    --> params (6 x 8bit)
   -- cmd_txreq    --> exec flag ('1' command frame transmitted, '0' command does not need transmission)
   -- cmd_macread  --> exec flag ('0' standard txcmd frame, '1' MAC-address-lut-read special frame)
   -- cmd_macwrite --> exec flag ('1' MAC-address-lut write) 
   --

   -- rxframe command interface (clock domain clk2,rst2)
   rx_cmdread : std_logic; 
   --
   -- cmdread --> single register output fifo read ack (pulse, 1 clock) 
   --

   -- framegen control
   fgen_wr   : std_logic;
   --
   fgen_ena  : std_logic;
   fgen_loop : std_logic;
   fgen_trig : std_logic_vector(1 to txport1_NPORTS);
   fgen_framelen : std_logic_vector(10 downto 0);
   fgen_destaddr : std_logic_vector(7 downto 0);
   fgen_destport : std_logic_vector(3 downto 0);
   fgen_destmode : std_logic_vector(2 downto 0);

   -- external interface status (clock domain clk2,rst2)
   ext_tport_enable_sts      : std_logic_vector(15 downto 0);
   ext_tport_ackenable_sts   : std_logic_vector(15 downto 0);
   ext_tport_timerenable_sts : std_logic_vector(15 downto 0);
   ext_tport_renable_sts     : std_logic_vector(15 downto 0);
   ext_tport_rerror_sts      : std_logic_vector(15 downto 0);
   --
   ext_rport_enable_sts    : std_logic_vector(15 downto 0);
   ext_rport_seqnumena_sts : std_logic_vector(15 downto 0);
   ext_rport_wready_sts    : std_logic_vector(15 downto 0);
   ext_rport_werrempty_sts : std_logic_vector(15 downto 0); 
   ext_rport_werrfull_sts  : std_logic_vector(15 downto 0); 

   -- srcfilter status (clock domain clk2,rst2)
   ext_tport_srcfilterena_sts  : std_logic_vector(15 downto 0);
   ext_tport_srcfilteraddr_sts : cmdctrl_byte_vector_t(1 to txport1_NPORTS); 
   ext_tport_srcfilterport_sts : cmdctrl_nibble_vector_t(1 to txport1_NPORTS); 
   --
   ext_rport_srcfilterena_sts  : std_logic_vector(15 downto 0);
   ext_rport_srcfilteraddr_sts : cmdctrl_byte_vector_t(1 to rxport1_NPORTS); 
   ext_rport_srcfilterport_sts : cmdctrl_nibble_vector_t(1 to rxport1_NPORTS); 

   -- framegen status
   ext_fgen_ena_sts      : std_logic;
   ext_fgen_loop_sts     : std_logic;
   ext_fgen_trig_sts     : std_logic_vector(15 downto 0);
   ext_fgen_framelen_sts : std_logic_vector(10 downto 0);
   ext_fgen_destaddr_sts : std_logic_vector(7 downto 0);
   ext_fgen_destport_sts : std_logic_vector(3 downto 0);
   ext_fgen_destmode_sts : std_logic_vector(2 downto 0);

   -- maclut status
   ext_maclut_data_sts  : cmdctrl_byte_vector_t(0 to 5);
   ext_maclut_addr_sts  : std_logic_vector(3 downto 0);
   ext_maclut_valid_sts : std_logic;

end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- cmdctrl component common interface (constant)
--
type cmdctrl_t is record
   inputs : cmdctrl_inputs_t;
   outputs : cmdctrl_outputs_t;
end record;

--
-- cmdctrl vector type (constant)
--
type cmdctrl_vector_t is array(NATURAL RANGE <>) of cmdctrl_t;

--
-- cmdctrl component declaration (constant)
--
component cmdctrl
port (
   inputs : in cmdctrl_inputs_t;
   outputs : out cmdctrl_outputs_t
);
end component;

--
-- cmdctrl global signal to export range/width params (constant)
--
signal component_cmdctrl : cmdctrl_t;

end component_cmdctrl;

--
-- cmdctrl entity declaration
--

-- libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
--
-- use work.component_[name].all;
--
use work.component_cmdctrl.all;
use work.component_txport1.all;
use work.component_rxport1.all;
 
-- cmdctrl entity (constant)
entity cmdctrl is
port (
   inputs : in cmdctrl_inputs_t;
   outputs : out cmdctrl_outputs_t
);
end cmdctrl;

--**************************************************************
--**************************************************************

--**************************************************************
--
--
-- Component Architecture
--
--
--**************************************************************

architecture rtl of cmdctrl is

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
--constant LLLLL : natural := 000;

--
-- state machines (edit)
--
-- type [FSMname]_t is (S0, S1, S2, S3 ...);
-- 
type FSMmain_t is (S0, S1, S1_0, S1_1, S2, S99, S100);
type FSMmaclut_t is (S0, S1, S2);

--
-- local registers (edit)
--
--
-- Notes: one record-type for each clock domain
--

--
-- clock domain: clk2
--
type reglist_clk2_t is record
   --
   -- FSM list
   --
   -- [FSMname] : [FSMname]_t;
   --
   FSMmain : FSMmain_t;
   FSMmaclut : FSMmaclut_t;

   -- register list
   tport_enable      : std_logic_vector(15 downto 0);
   tport_ackenable   : std_logic_vector(15 downto 0);
   tport_timerenable : std_logic_vector(15 downto 0);
   --   
   rport_enable    : std_logic_vector(15 downto 0);
   rport_seqnumena : std_logic_vector(15 downto 0);

   tport_enable_wr      : std_logic;
   tport_ackenable_wr   : std_logic;
   tport_timerenable_wr : std_logic;
   tport_seqnumclr_wr   : std_logic;
   --
   rport_enable_wr    : std_logic;
   rport_seqnumena_wr : std_logic;
   rport_seqnumclr_wr : std_logic;

   tport_enable_flag      : std_logic;
   tport_ackenable_flag   : std_logic;
   tport_timerenable_flag : std_logic;
   tport_seqnumclr_flag   : std_logic;
   --
   rport_enable_flag      : std_logic;
   rport_seqnumena_flag   : std_logic;
   rport_seqnumclr_flag   : std_logic;

   tport_enable_save      : std_logic_vector(15 downto 0);
   tport_ackenable_save   : std_logic_vector(15 downto 0);
   tport_timerenable_save : std_logic_vector(15 downto 0);
   tport_seqnumclr_save   : std_logic_vector(15 downto 0);
   --   
   rport_enable_save      : std_logic_vector(15 downto 0);
   rport_seqnumena_save   : std_logic_vector(15 downto 0);
   rport_seqnumclr_save   : std_logic_vector(15 downto 0);

   tfilter_addr    : cmdctrl_byte_vector_t(1 to txport1_NPORTS);
   tfilter_port    : cmdctrl_nibble_vector_t(1 to txport1_NPORTS);
   tfilter_ena     : std_logic_vector(1 to txport1_NPORTS);
   tfilter_ok      : std_logic_vector(1 to txport1_NPORTS);
   tfilter_addr_ok : std_logic_vector(1 to txport1_NPORTS);
   tfilter_port_ok : std_logic_vector(1 to txport1_NPORTS);
   --
   rfilter_addr    : cmdctrl_byte_vector_t(1 to rxport1_NPORTS);
   rfilter_port    : cmdctrl_nibble_vector_t(1 to rxport1_NPORTS);
   rfilter_ena     : std_logic_vector(1 to rxport1_NPORTS);
   rfilter_ok      : std_logic_vector(1 to rxport1_NPORTS);
   rfilter_addr_ok : std_logic_vector(1 to rxport1_NPORTS);
   rfilter_port_ok : std_logic_vector(1 to rxport1_NPORTS);
   
   tport_srcfilter_wr    : std_logic;
   tport_srcfilterena_wr : std_logic;
   --
   rport_srcfilter_wr    : std_logic;
   rport_srcfilterena_wr : std_logic;
   --
   tport_srcfilterena_flag : std_logic;
   tport_srcfilter_flag    : std_logic;
   --
   rport_srcfilterena_flag : std_logic;
   rport_srcfilter_flag    : std_logic;

   tport_srcfilterena_save  : std_logic_vector(15 downto 0);
   tport_srcfilter_save     : std_logic_vector(3 downto 0);
   tport_srcfilteraddr_save : std_logic_vector(7 downto 0); 
   tport_srcfilterport_save : std_logic_vector(3 downto 0); 
   --
   rport_srcfilterena_save  : std_logic_vector(15 downto 0);
   rport_srcfilter_save     : std_logic_vector(3 downto 0);
   rport_srcfilteraddr_save : std_logic_vector(7 downto 0); 
   rport_srcfilterport_save : std_logic_vector(3 downto 0); 

   framegen_wr : std_logic;
   framegen_destaddr_wr : std_logic;
   framegen_destmode_wr : std_logic;
   framegen_framelen_wr : std_logic;
   --
   framegen_flag          : std_logic;
   framegen_destaddr_flag : std_logic;
   framegen_destmode_flag : std_logic;
   framegen_framelen_flag : std_logic;
   fgen_wr   : std_logic;
   --
   fgen_ena_save  : std_logic;
   fgen_loop_save : std_logic;
   fgen_trig_save : std_logic_vector(1 to txport1_NPORTS);
   fgen_framelen_save : std_logic_vector(10 downto 0);
   fgen_destaddr_save : std_logic_vector(7 downto 0);
   fgen_destport_save : std_logic_vector(3 downto 0);
   fgen_destmode_save : std_logic_vector(2 downto 0);
   --   
   fgen_ena  : std_logic;
   fgen_loop : std_logic;
   fgen_trig : std_logic_vector(1 to txport1_NPORTS);
   fgen_framelen : std_logic_vector(10 downto 0);
   fgen_destaddr : std_logic_vector(7 downto 0);
   fgen_destport : std_logic_vector(3 downto 0);
   fgen_destmode : std_logic_vector(2 downto 0);

   maclut_load : std_logic;
   maclut_wr   : std_logic;
   maclut_rd   : std_logic;
   maclut_flag : std_logic;
   --
   mac_addr_save  : std_logic_vector(3 downto 0);
   mac_data_save  : cmdctrl_byte_vector_t(0 to 5);
   mac_write_save : std_logic;
   mac_read_save  : std_logic;
   --
   macread_addr  : std_logic_vector(3 downto 0);
   macread_data  : cmdctrl_byte_vector_t(0 to 5);
   macread_valid : std_logic;

   -- end of list
   eol : std_logic;

end record;
constant reglist_clk2_default : reglist_clk2_t :=
(
   FSMmain => S0,
   FSMmaclut => S0,

   tport_enable => (others => '0'),
   tport_ackenable => (others => '0'),
   tport_timerenable => (others => '0'),
   --
   rport_enable => (others => '0'),
   rport_seqnumena => (others => '0'),

   tport_enable_wr => '0',
   tport_ackenable_wr => '0',
   tport_timerenable_wr => '0',
   tport_seqnumclr_wr => '0',
   --
   rport_enable_wr => '0',
   rport_seqnumena_wr => '0',
   rport_seqnumclr_wr => '0',

   tport_enable_flag      => '0',
   tport_ackenable_flag   => '0',
   tport_timerenable_flag => '0',
   tport_seqnumclr_flag   => '0',
   --
   rport_enable_flag      => '0',
   rport_seqnumena_flag   => '0',
   rport_seqnumclr_flag   => '0',

   tport_enable_save => (others => '0'),
   tport_ackenable_save => (others => '0'),
   tport_timerenable_save => (others => '0'),
   tport_seqnumclr_save => (others => '0'),
   --
   rport_enable_save => (others => '0'),
   rport_seqnumena_save => (others => '0'),
   rport_seqnumclr_save => (others => '0'),

   tfilter_addr => (others => "00000000"),
   tfilter_port => (others => "0000"),
   tfilter_ena  => (others => '0'),
   tfilter_ok   => (others => '0'),
   tfilter_addr_ok => (others => '0'),
   tfilter_port_ok => (others => '0'),
   --
   rfilter_addr => (others => "00000000"),
   rfilter_port => (others => "0000"),
   rfilter_ena  => (others => '0'),
   rfilter_ok   => (others => '0'),
   rfilter_addr_ok => (others => '0'),
   rfilter_port_ok => (others => '0'),

   tport_srcfilter_wr => '0',
   tport_srcfilterena_wr => '0',
   --
   rport_srcfilter_wr => '0',
   rport_srcfilterena_wr => '0',
   --
   tport_srcfilterena_flag => '0',
   tport_srcfilter_flag    => '0',
   --
   rport_srcfilterena_flag => '0',
   rport_srcfilter_flag    => '0',

   tport_srcfilterena_save  => (others => '0'),
   tport_srcfilter_save     => (others => '0'),
   tport_srcfilteraddr_save => (others => '0'),
   tport_srcfilterport_save => (others => '0'),
   --
   rport_srcfilterena_save  => (others => '0'),
   rport_srcfilter_save     => (others => '0'),
   rport_srcfilteraddr_save => (others => '0'),
   rport_srcfilterport_save => (others => '0'),
  
   framegen_wr => '0',
   framegen_destaddr_wr => '0',
   framegen_destmode_wr => '0',
   framegen_framelen_wr => '0',
   --
   framegen_flag          => '0',
   framegen_destaddr_flag => '0',
   framegen_destmode_flag => '0',
   framegen_framelen_flag => '0',
   --  
   fgen_wr   => '0',
   fgen_ena  => '0',
   fgen_loop => '0',
   fgen_trig => (others => '0'),
   fgen_framelen => (others => '0'),
   fgen_destaddr => (others => '0'),
   fgen_destport => (others => '0'),
   fgen_destmode => (others => '0'),
   --
   fgen_ena_save  => '0',
   fgen_loop_save => '0',
   fgen_trig_save => (others => '0'),
   fgen_framelen_save => (others => '0'),
   fgen_destaddr_save => (others => '0'),
   fgen_destport_save => (others => '0'),
   fgen_destmode_save => (others => '0'),

   maclut_load => '0',
   maclut_wr   => '0',
   maclut_rd   => '0',
   maclut_flag => '0',
   --
   mac_addr_save  => (others => '0'),
   mac_data_save  => (others => "00000000"),
   mac_write_save => '0',
   mac_read_save  => '0',
   --
   macread_addr  => (others => '0'),
   macread_data  => (others => "00000000"),
   macread_valid => '0',
  
   eol => '0'
);

--
-- all local registers (edit)
--
-- Notes: one record-element for each clock domain
--
type reglist_t is record
   clk2 : reglist_clk2_t;
end record;

--
-- all local nets (edit)
--
type netlist_t is record

   ---- 5bit cmdcode
   --cmdcode : unsigned(4 downto 0);
   --cmdseq  : unsigned(1 downto 0);
   ----
   -- 4bit cmdcode
   cmdcode : unsigned(3 downto 0);
   cmdseq  : unsigned(2 downto 0);
   --
   cmdecho : std_logic;
   --
   word16 : std_logic_vector(15 downto 0);
   wout16 : std_logic_vector(15 downto 0);

   ext_cmdexec : std_logic;
   ext_cmdready : std_logic;

   tport_enable_wr      : std_logic;
   tport_ackenable_wr   : std_logic;
   tport_timerenable_wr : std_logic;
   tport_seqnumclr_wr   : std_logic;
   --
   rport_enable_wr    : std_logic;
   rport_seqnumena_wr : std_logic;
   rport_seqnumclr_wr : std_logic;

   tport_srcfilter_wr    : std_logic;
   tport_srcfilterena_wr : std_logic;
   --
   rport_srcfilter_wr    : std_logic;
   rport_srcfilterena_wr : std_logic;

   framegen_wr : std_logic;
   framegen_destaddr_wr : std_logic;
   framegen_destmode_wr : std_logic;
   framegen_framelen_wr : std_logic;

   maclut_load : std_logic;
   maclut_wr   : std_logic;
   maclut_rd   : std_logic;

   --
   -- component interface signals (edit)
   --
   -- [instance_name] : [component_name]_t;
   -- [instance_name] : [component_name]_vector_t([instance_range]);
   --
   --c1 : counter1_t;
   --cc : counter1_vector_t(1 to 2);

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
subtype inputs_t is cmdctrl_inputs_t;
subtype outputs_t is cmdctrl_outputs_t;

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
-- architecture rtl of cmdctrl
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

--**************************************************************
--
-- sequential logic
--
--
-- Notes: one record-type for each clock domain
--
--**************************************************************

--
-- clock domain: clk2,rst2 (edit)
--
process (inputs.clk2, inputs.rst2)
begin
   if (inputs.rst2 = '1') then
      allregs.dout.clk2 <= reglist_clk2_default;
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

process (inputs, allouts, allregs, allnets) --[, allcmps)]

--**************************************************************
--
-- Combinatorial description begin
--
--**************************************************************

--
-- FSMmain combinatorial procedure (edit)
--
-- clock domain: clk2
--
procedure SubFSMmain
(
   variable i : in inputs_t;
   variable ri: in reglist_clk2_t;
   variable ro: in reglist_clk2_t;
   variable o : inout outputs_t;
   variable r : inout reglist_clk2_t;
   variable n : inout netlist_t
) is
begin

   --
   -- output defaults
   --

   -- txport cmdctrl-interface (clock domain clk2,rst2)
   o.tport_enable      := (others => '0');
   o.tport_ackenable   := (others => '0');
   o.tport_timerenable := (others => '0');
   FOR index IN 1 TO txport1_NPORTS LOOP   
      o.tport_enable(index)      := ro.tport_enable(index);
      o.tport_ackenable(index)   := ro.tport_ackenable(index);
      o.tport_timerenable(index) := ro.tport_timerenable(index);
   END LOOP;
   -- note: outputs are level-driven by 16bit regs (range 1..NPORTS, bit0 reserved)
   --
   o.tport_cmdseqnumclr   := (others => '0');
   o.tport_cmdackreceived := '0';
   o.tport_cmdackportaddr := (others => '0');
   o.tport_cmdackseqnum   := (others => '0');
   -- note: outputs are pulse-driven by cmdctrl logic (pulse-width = 1 clock)

   -- rxport cmdctrl-interface (clock domain clk2,rst2)
   o.rport_enable    := (others => '0');
   o.rport_seqnumena := (others => '0');
   FOR index IN 1 TO rxport1_NPORTS LOOP   
      o.rport_enable(index)    := ro.rport_enable(index);
      o.rport_seqnumena(index) := ro.rport_seqnumena(index); 
      --
      o.rport_srcfilterena(index)  := ro.rfilter_ena(index);
      o.rport_srcfilteraddr(index) := ro.rfilter_addr(index); 
      o.rport_srcfilterport(index) := ro.rfilter_port(index); 
   END LOOP;
   -- note: outputs are level-driven by 16bit regs (range 1..NPORTS, bit0 reserved)
   --
   o.rport_seqnumclr := (others => '0');
   -- note: outputs are pulse-driven by cmdctrl logic (pulse-width = 1 clock)

   -- txframe command-interface (clock domain clk2,rst2)
   o.tx_cmdwrite     := '0';
   o.tx_cmddestport  := (others => '0');
   o.tx_cmddestaddr  := (others => '0');
   o.tx_cmdcode      := (others => '0');
   o.tx_cmdports     := (others => '0');
   o.tx_cmdparams    := (others => "00000000");
   o.tx_cmd_txreq    := '0';
   o.tx_cmd_macread  := '0';
   o.tx_cmd_macwrite := '0';

   -- rxframe command-interface (clock domain clk2,rst2)
   o.rx_cmdread := '0'; 

   -- framegen control (clock domain clk2,rst2)
   o.fgen_loop := ro.fgen_loop;
   FOR index IN 1 TO txport1_NPORTS LOOP   
      o.fgen_trig(index) := ro.fgen_trig(index);
   END LOOP;
   o.fgen_destaddr := ro.fgen_destaddr;
   o.fgen_destport := ro.fgen_destport;
   o.fgen_destmode := ro.fgen_destmode;
   o.fgen_framelen := ro.fgen_framelen;
   o.fgen_ena      := ro.fgen_ena;
   --
   o.fgen_wr := ro.fgen_wr;
   --
   -- note: framegen module must be level-driven by registers --> synchronizer into framegen module 
   -- captures its private copy of all flags/params and starts a sync-write-op; new write requests 
   -- applied when framegen sync-write-op is in progress are delayed until sync-write-op is done 
   -- (see regsync1.vhd) 
   --

   -- defaults
   --n.cmdcode := SLV(i.rx_cmdcode(4 downto 0)); -- 5bit cmdcode
   --n.cmdseq  := SLV(i.rx_cmdcode(6 downto 5)); -- 2bit cmdseq
   n.cmdcode := SLV(i.rx_cmdcode(3 downto 0)); -- 4bit cmdcode
   n.cmdseq  := SLV(i.rx_cmdcode(6 downto 4)); -- 3bit cmdseq
   n.cmdecho := i.rx_cmdcode(7); 
   -- note: commands use nibble low (nibble high reserved for cmd-echo/cmd-seqnum)
   n.word16  := (others => '0');
   n.wout16  := (others => '0');
   -- note: 16bit temporary nets used for bit-pack/bit-unpack operations
   r.fgen_wr := '0';
   -- note: framegen write pulse defaults to zero (1 clock write pulse generated when 
   -- framegen params are updated)      
   n.ext_cmdexec := '0';

   case ro.FSMmain is
   when S0 =>
      --
      -- reset state
      --
      r.FSMmain := S1;

   when S1 =>
      --
      -- idle state
      --
      if n.ext_cmdready = '1' then
         -- external cmd received: to 'external cmd exec'
         r.FSMmain := S100;         
      else 
         -- external cmd not present: to 'rx command test'  
         r.FSMmain := S1_0;
      end if;
      -- note: 'external cmd exec' state will return to 'rx command test' state
      -- (round-robin scheduler for external/received commands) 

   when S1_0 =>
      --
      -- rx command test
      --
      if i.rx_cmdready = '0' then
         -- rx command not present: return to idle state
         r.FSMmain := S1;
      elsif n.cmdecho = '1' then
         -- echo command received: command ignored
         r.FSMmain := S99;        
      else 
         -- cmd received: current params applied to cmd-filter-logic, continue
         r.FSMmain := S1_1;         
      end if;

   when S1_1 =>
      --
      -- wait state
      --
      r.FSMmain := S2;
      -- note: cmd-filter-test results will be ready next clock cycle

   when S2 =>
      --
      -- rx command exec state
      --
      if n.cmdcode = 1 then
         --
         -- txport write (flags enable, ackenable, timerenable)
         --
         if i.tx_cmdregfull = '0' then
            -- txframe cmdreg not full: command accepted (command will generate echo-frame) 
            o.tx_cmdwrite    := '1';
            o.tx_cmddestport := i.rx_cmdsrcport;
            o.tx_cmddestaddr := i.rx_cmdsrcaddr;
            o.tx_cmdcode     := i.rx_cmdcode;   -- default: cmdcode loopback echo
            o.tx_cmdcode(7)  := '1';            -- bit7 = echo-frame marker
            o.tx_cmdports    := i.rx_cmdports;  -- default: cmdports loopback echo
            o.tx_cmdparams   := i.rx_cmdparams; -- default: cmdparams loopback echo
            --
            -- command exec
            --
            -- note: cmd-params are organized in groups of 16bit (little endian format)
            -- note1: bits 1..15 work as port-mask, bit0 used as SET/CLR write level
            n.word16 := i.rx_cmdparams(1) & i.rx_cmdparams(0);
            n.wout16 := SLV(0, 15) & n.word16(0);
            FOR index IN 1 TO txport1_NPORTS LOOP
               if n.word16(index) = '1' and ro.tfilter_ok(index) = '1' then
                  r.tport_enable(index) := n.word16(0);
                  n.wout16(index) := '1';
               end if;
            END LOOP;
            o.tx_cmdparams(0) := n.wout16( 7 downto 0);
            o.tx_cmdparams(1) := n.wout16(15 downto 8);
            --
            n.word16 := i.rx_cmdparams(3) & i.rx_cmdparams(2);
            n.wout16 := SLV(0, 15) & n.word16(0);
            FOR index IN 1 TO txport1_NPORTS LOOP
               if n.word16(index) = '1' and ro.tfilter_ok(index) = '1' then
                  r.tport_ackenable(index) := n.word16(0);
                  n.wout16(index) := '1';
               end if;
            END LOOP;
            o.tx_cmdparams(2) := n.wout16( 7 downto 0);
            o.tx_cmdparams(3) := n.wout16(15 downto 8);
            --
            n.word16 := i.rx_cmdparams(5) & i.rx_cmdparams(4);
            n.wout16 := SLV(0, 15) & n.word16(0);
            FOR index IN 1 TO txport1_NPORTS LOOP
               if n.word16(index) = '1' and ro.tfilter_ok(index) = '1' then
                  r.tport_timerenable(index) := n.word16(0);
                  n.wout16(index) := '1';
               end if;
            END LOOP;
            o.tx_cmdparams(4) := n.wout16( 7 downto 0);
            o.tx_cmdparams(5) := n.wout16(15 downto 8);
            --
            o.tx_cmd_txreq    := '1';
            o.tx_cmd_macread  := '0';
            o.tx_cmd_macwrite := '0';
            -- note: command replies using bit-masks of updated ports

            -- command done
            r.FSMmain := S99;         
         else
            -- txframe cmdreg is full: command ignored (echo-frame not transmitted)
            r.FSMmain := S99;         
         end if;  

      elsif n.cmdcode = 2 then
         --
         -- txport read (enable, ackenable, timerenable)
         --
         if i.tx_cmdregfull = '0' then
            -- txframe cmdreg not full: command accepted (command will generate echo-frame) 
            o.tx_cmdwrite    := '1';
            o.tx_cmddestport := i.rx_cmdsrcport;
            o.tx_cmddestaddr := i.rx_cmdsrcaddr;
            o.tx_cmdcode     := i.rx_cmdcode;   -- default: cmdcode loopback echo
            o.tx_cmdcode(7)  := '1';            -- bit7 = echo-frame marker
            o.tx_cmdports    := i.rx_cmdports;  -- default: cmdports loopback echo
            o.tx_cmdparams   := i.rx_cmdparams; -- default: cmdparams loopback echo
            --
            -- command exec
            --
            -- txport flags transmitted
            o.tx_cmdparams(0) := ro.tport_enable(7 downto 0);
            o.tx_cmdparams(1) := ro.tport_enable(15 downto 8);
            o.tx_cmdparams(2) := ro.tport_ackenable(7 downto 0);
            o.tx_cmdparams(3) := ro.tport_ackenable(15 downto 8);
            o.tx_cmdparams(4) := ro.tport_timerenable(7 downto 0);
            o.tx_cmdparams(5) := ro.tport_timerenable(15 downto 8);
            -- note: all flags are 16bit little endian
            o.tx_cmd_txreq    := '1';
            o.tx_cmd_macread  := '0';
            o.tx_cmd_macwrite := '0';

            -- command done
            r.FSMmain := S99;         
         else
            -- txframe cmdreg is full: command ignored (echo-frame not transmitted)
            r.FSMmain := S99;         
         end if;  

      elsif n.cmdcode = 3 then
         --
         -- txport read (renable, rerror)
         --
         if i.tx_cmdregfull = '0' then
            -- txframe cmdreg not full: command accepted (command will generate echo-frame) 
            o.tx_cmdwrite    := '1';
            o.tx_cmddestport := i.rx_cmdsrcport;
            o.tx_cmddestaddr := i.rx_cmdsrcaddr;
            o.tx_cmdcode     := i.rx_cmdcode;   -- default: cmdcode loopback echo
            o.tx_cmdcode(7)  := '1';            -- bit7 = echo-frame marker
            o.tx_cmdports    := i.rx_cmdports;  -- default: cmdports loopback echo
            o.tx_cmdparams   := i.rx_cmdparams; -- default: cmdparams loopback echo
            --
            -- command exec
            --
            -- txport status transmitted
            FOR index IN 1 TO txport1_NPORTS LOOP
               n.word16(index) := i.tport_renable(index);            
            END LOOP;
            o.tx_cmdparams(0) := n.word16(7 downto 0);
            o.tx_cmdparams(1) := n.word16(15 downto 8);
            --
            FOR index IN 1 TO txport1_NPORTS LOOP
               n.word16(index) := i.tport_rerror(index);            
            END LOOP;
            o.tx_cmdparams(2) := n.word16(7 downto 0);
            o.tx_cmdparams(3) := n.word16(15 downto 8);
            --
            o.tx_cmdparams(4) := "00000000";
            o.tx_cmdparams(5) := "00000000";
            -- note: all flags are 16bit little endian
            o.tx_cmd_txreq    := '1';
            o.tx_cmd_macread  := '0';
            o.tx_cmd_macwrite := '0';

            -- command done
            r.FSMmain := S99;         
         else
            -- txframe cmdreg is full: command ignored (echo-frame not transmitted)
            r.FSMmain := S99;         
         end if;  

      elsif n.cmdcode = 4 then
         --
         -- txport ackreceived 
         --
         if i.tx_cmdregfull = '0' then
            -- txframe cmdreg not full: command accepted (command will generate echo-frame) 
            o.tx_cmdwrite    := '1';
            o.tx_cmddestport := i.rx_cmdsrcport;
            o.tx_cmddestaddr := i.rx_cmdsrcaddr;
            o.tx_cmdcode     := i.rx_cmdcode;   -- default: cmdcode loopback echo
            o.tx_cmdcode(7)  := '1';            -- bit7 = echo-frame marker
            o.tx_cmdports    := i.rx_cmdports;  -- default: cmdports loopback echo
            o.tx_cmdparams   := i.rx_cmdparams; -- default: cmdparams loopback echo
            --
            -- txport 'ackreceived' applied (portaddr indexed)
            --
            o.tport_cmdackreceived := '1';
            o.tport_cmdackportaddr := i.rx_cmdports(3 downto 0); 
            -- note: ackportaddr = nibble low
            o.tport_cmdackseqnum(31 downto 24) := i.rx_cmdparams(3);
            o.tport_cmdackseqnum(23 downto 16) := i.rx_cmdparams(2);
            o.tport_cmdackseqnum(15 downto  8) := i.rx_cmdparams(1);
            o.tport_cmdackseqnum( 7 downto  0) := i.rx_cmdparams(0);
            -- note: 32bit little endian
            o.tx_cmd_txreq    := '1';
            o.tx_cmd_macread  := '0';
            o.tx_cmd_macwrite := '0';
            -- note: command replies with current written params 
            --??? per il momento il comando genera un echo....ma puo' diventare un comando di write only senza frame di risposta

            -- command done
            r.FSMmain := S99;         
         else
            -- txframe cmdreg is full: command ignored (echo-frame not transmitted)
            r.FSMmain := S99;         
         end if;

      elsif n.cmdcode = 5 then
         --
         -- rxport write (enable, seqnumenable) 
         --
         if i.tx_cmdregfull = '0' then
            -- txframe cmdreg not full: command accepted (command will generate echo-frame) 
            o.tx_cmdwrite    := '1';
            o.tx_cmddestport := i.rx_cmdsrcport;
            o.tx_cmddestaddr := i.rx_cmdsrcaddr;
            o.tx_cmdcode     := i.rx_cmdcode;   -- default: cmdcode loopback echo
            o.tx_cmdcode(7)  := '1';            -- bit7 = echo-frame marker
            o.tx_cmdports    := i.rx_cmdports;  -- default: cmdports loopback echo
            o.tx_cmdparams   := i.rx_cmdparams; -- default: cmdparams loopback echo
            --
            -- command exec
            --
            -- note: cmd-params are organized in groups of 16bit (little endian format)
            -- note1: bits 1..15 work as port-mask, bit0 used as SET/CLR write level
            n.word16 := i.rx_cmdparams(1) & i.rx_cmdparams(0);
            n.wout16 := SLV(0, 15) & n.word16(0);
            FOR index IN 1 TO rxport1_NPORTS LOOP
               if n.word16(index) = '1' and ro.rfilter_ok(index) = '1' then
                  r.rport_enable(index) := n.word16(0);
                  n.wout16(index) := '1';
               end if;
            END LOOP;
            o.tx_cmdparams(0) := n.wout16( 7 downto 0);
            o.tx_cmdparams(1) := n.wout16(15 downto 8);
            --
            n.word16 := i.rx_cmdparams(3) & i.rx_cmdparams(2);
            n.wout16 := SLV(0, 15) & n.word16(0);
            FOR index IN 1 TO rxport1_NPORTS LOOP
               if n.word16(index) = '1' and ro.rfilter_ok(index) = '1' then
                  r.rport_seqnumena(index) := n.word16(0);
                  n.wout16(index) := '1';
               end if;
            END LOOP;
            o.tx_cmdparams(2) := n.wout16( 7 downto 0);
            o.tx_cmdparams(3) := n.wout16(15 downto 8);
            --
            o.tx_cmd_txreq    := '1';
            o.tx_cmd_macread  := '0';
            o.tx_cmd_macwrite := '0';
            -- note: command replies using bit-masks of updated ports

            -- command done
            r.FSMmain := S99;         
         else
            -- txframe cmdreg is full: command ignored (echo-frame not transmitted)
            r.FSMmain := S99;         
         end if;  

      elsif n.cmdcode = 6 then
         --
         -- rxport read (enable, seqnumenable)
         --
         if i.tx_cmdregfull = '0' then
            -- txframe cmdreg not full: command accepted (command will generate echo-frame) 
            o.tx_cmdwrite    := '1';
            o.tx_cmddestport := i.rx_cmdsrcport;
            o.tx_cmddestaddr := i.rx_cmdsrcaddr;
            o.tx_cmdcode     := i.rx_cmdcode;   -- default: cmdcode loopback echo
            o.tx_cmdcode(7)  := '1';            -- bit7 = echo-frame marker
            o.tx_cmdports    := i.rx_cmdports;  -- default: cmdports loopback echo
            o.tx_cmdparams   := i.rx_cmdparams; -- default: cmdparams loopback echo
            --
            -- command exec
            --
            -- rxport flags transmitted
            o.tx_cmdparams(0) := ro.rport_enable(7 downto 0);
            o.tx_cmdparams(1) := ro.rport_enable(15 downto 8);
            o.tx_cmdparams(2) := ro.rport_seqnumena(7 downto 0);
            o.tx_cmdparams(3) := ro.rport_seqnumena(15 downto 8);
            o.tx_cmdparams(4) := "00000000";
            o.tx_cmdparams(5) := "00000000";
            -- note: all flags are 16bit little endian
            o.tx_cmd_txreq    := '1';
            o.tx_cmd_macread  := '0';
            o.tx_cmd_macwrite := '0';
            -- command done
            r.FSMmain := S99;         
         else
            -- txframe cmdreg is full: command ignored (echo-frame not transmitted)
            r.FSMmain := S99;         
         end if;  

      elsif n.cmdcode = 7 then
         --
         -- rxport read (wready, werrempty, werrfull)
         --
         if i.tx_cmdregfull = '0' then
            -- txframe cmdreg not full: command accepted (command will generate echo-frame) 
            o.tx_cmdwrite    := '1';
            o.tx_cmddestport := i.rx_cmdsrcport;
            o.tx_cmddestaddr := i.rx_cmdsrcaddr;
            o.tx_cmdcode     := i.rx_cmdcode;   -- default: cmdcode loopback echo
            o.tx_cmdcode(7)  := '1';            -- bit7 = echo-frame marker
            o.tx_cmdports    := i.rx_cmdports;  -- default: cmdports loopback echo
            o.tx_cmdparams   := i.rx_cmdparams; -- default: cmdparams loopback echo
            --
            -- command exec
            --
            -- rxport status transmitted
            FOR index in 1 to rxport1_NPORTS LOOP             
               n.word16(index) := i.rport_wready(index);
            END LOOP;
            o.tx_cmdparams(0) := n.word16(7 downto 0);
            o.tx_cmdparams(1) := n.word16(15 downto 8);
            --
            FOR index in 1 to rxport1_NPORTS LOOP             
               n.word16(index) := i.rport_werrempty(index);
            END LOOP;
            o.tx_cmdparams(2) := n.word16(7 downto 0);
            o.tx_cmdparams(3) := n.word16(15 downto 8);
            --
            FOR index in 1 to rxport1_NPORTS LOOP             
               n.word16(index) := i.rport_werrfull(index);
            END LOOP;
            o.tx_cmdparams(4) := n.word16(7 downto 0);
            o.tx_cmdparams(5) := n.word16(15 downto 8);
            -- note: all flags are 16bit little endian
            o.tx_cmd_txreq    := '1';
            o.tx_cmd_macread  := '0';
            o.tx_cmd_macwrite := '0';
            -- command done
            r.FSMmain := S99;         
         else
            -- txframe cmdreg is full: command ignored (echo-frame not transmitted)
            r.FSMmain := S99;         
         end if;  

      elsif n.cmdcode = 8 then
         --
         -- txport,rxport seqnumclr
         --
         if i.tx_cmdregfull = '0' then
            -- txframe cmdreg not full: command accepted (command will generate echo-frame) 
            o.tx_cmdwrite    := '1';
            o.tx_cmddestport := i.rx_cmdsrcport;
            o.tx_cmddestaddr := i.rx_cmdsrcaddr;
            o.tx_cmdcode     := i.rx_cmdcode;   -- default: cmdcode loopback echo
            o.tx_cmdcode(7)  := '1';            -- bit7 = echo-frame marker
            o.tx_cmdports    := i.rx_cmdports;  -- default: cmdports loopback echo
            o.tx_cmdparams   := i.rx_cmdparams; -- default: cmdparams loopback echo
            --
            -- command exec
            --
            -- note: cmd-params are organized in groups of 16bit (little endian format)
            -- note1: bits 1..15 work as port-mask, bit0 reserved (loopback only)
            n.word16 := i.rx_cmdparams(1) & i.rx_cmdparams(0);
            n.wout16 := SLV(0, 15) & n.word16(0);
            FOR index IN 1 TO txport1_NPORTS LOOP
               if n.word16(index) = '1' and ro.tfilter_ok(index) = '1' then
                  -- txport 'seqnumclr' applied
                  o.tport_cmdseqnumclr(index) := '1';
                  n.wout16(index) := '1';
               end if;
            END LOOP;
            o.tx_cmdparams(0) := n.wout16( 7 downto 0);
            o.tx_cmdparams(1) := n.wout16(15 downto 8);
            --
            n.word16 := i.rx_cmdparams(3) & i.rx_cmdparams(2);
            n.wout16 := SLV(0, 15) & n.word16(0);
            FOR index IN 1 TO rxport1_NPORTS LOOP
               if n.word16(index) = '1' and ro.rfilter_ok(index) = '1' then
                  -- rxport 'seqnumclr' applied
                  o.rport_seqnumclr(index) := '1';
                  n.wout16(index) := '1';
               end if;
            END LOOP;
            o.tx_cmdparams(2) := n.wout16( 7 downto 0);
            o.tx_cmdparams(3) := n.wout16(15 downto 8);
            --
            o.tx_cmd_txreq    := '1';
            o.tx_cmd_macread  := '0';
            o.tx_cmd_macwrite := '0';
            -- note: command replies using bit-masks of updated ports

            -- command done
            r.FSMmain := S99;         
         else
            -- txframe cmdreg is full: command ignored (echo-frame not transmitted)
            r.FSMmain := S99;         
         end if;

      elsif n.cmdcode = 9 then
         --
         -- txseqnum,tfilter read
         --
         if i.tx_cmdregfull = '0' then
            -- txframe cmdreg not full: command accepted (command will generate echo-frame) 
            o.tx_cmdwrite    := '1';
            o.tx_cmddestport := i.rx_cmdsrcport;
            o.tx_cmddestaddr := i.rx_cmdsrcaddr;
            o.tx_cmdcode     := i.rx_cmdcode;   -- default: cmdcode loopback echo
            o.tx_cmdcode(7)  := '1';            -- bit7 = echo-frame marker
            o.tx_cmdports    := i.rx_cmdports;  -- default: cmdports loopback echo
            o.tx_cmdparams   := i.rx_cmdparams; -- default: cmdparams loopback echo
            --
            -- command exec
            --
            -- txseqnum,tfilter transmitted (portaddr indexed)
            FOR index IN 1 TO txport1_NPORTS LOOP
               if UINT(i.rx_cmdports(3 downto 0)) = index then -- portaddr = nibble low
                  o.tx_cmdparams(0) := i.tport_rseqnum(index)( 7 downto  0);
                  o.tx_cmdparams(1) := i.tport_rseqnum(index)(15 downto  8);
                  o.tx_cmdparams(2) := i.tport_rseqnum(index)(23 downto 16);
                  o.tx_cmdparams(3) := i.tport_rseqnum(index)(31 downto 24);   
                  -- note: 32bit little endian
                  o.tx_cmdparams(4) := ro.tfilter_addr(index)(7 downto 0);
                  o.tx_cmdparams(5) := ro.tfilter_ena(index) & "000" & ro.tfilter_port(index);
                  -- note: 16bit little endian (bit15 = tfilter_ena, bit11..8 = tfilter_port, bit7..0 = tfilter_addr)
               end if;
            END LOOP;
            --
            o.tx_cmd_txreq    := '1';
            o.tx_cmd_macread  := '0';
            o.tx_cmd_macwrite := '0';
            -- command done
            r.FSMmain := S99;         
         else
            -- txframe cmdreg is full: command ignored (echo-frame not transmitted)
            r.FSMmain := S99;         
         end if;  

      elsif n.cmdcode = 10 then
         --
         -- rxseqnum,rfilter read
         --
         if i.tx_cmdregfull = '0' then
            -- txframe cmdreg not full: command accepted (command will generate echo-frame) 
            o.tx_cmdwrite    := '1';
            o.tx_cmddestport := i.rx_cmdsrcport;
            o.tx_cmddestaddr := i.rx_cmdsrcaddr;
            o.tx_cmdcode     := i.rx_cmdcode;   -- default: cmdcode loopback echo
            o.tx_cmdcode(7)  := '1';            -- bit7 = echo-frame marker
            o.tx_cmdports    := i.rx_cmdports;  -- default: cmdports loopback echo
            o.tx_cmdparams   := i.rx_cmdparams; -- default: cmdparams loopback echo
            --
            -- command exec
            --
            -- rxseqnum,rfilter transmitted (portaddr indexed)
            FOR index IN 1 TO rxport1_NPORTS LOOP
               if UINT(i.rx_cmdports(3 downto 0)) = index then -- portaddr = nibble low
                  o.tx_cmdparams(0) := i.rport_rxseqnum(index)( 7 downto  0);
                  o.tx_cmdparams(1) := i.rport_rxseqnum(index)(15 downto  8);
                  o.tx_cmdparams(2) := i.rport_rxseqnum(index)(23 downto 16);
                  o.tx_cmdparams(3) := i.rport_rxseqnum(index)(31 downto 24);   
                  -- note: 32bit little endian
                  o.tx_cmdparams(4) := ro.rfilter_addr(index)(7 downto 0);
                  o.tx_cmdparams(5) := ro.rfilter_ena(index) & "000" & ro.rfilter_port(index);
                  -- note: 16bit little endian (bit15 = rfilter_ena, bit11..8 = rfilter_port, bit7..0 = rfilter_addr)
               end if;
            END LOOP;
            --
            o.tx_cmd_txreq    := '1';
            o.tx_cmd_macread  := '0';
            o.tx_cmd_macwrite := '0';
            -- command done
            r.FSMmain := S99;         
         else
            -- txframe cmdreg is full: command ignored (echo-frame not transmitted)
            r.FSMmain := S99;         
         end if;  

      elsif n.cmdcode = 11 then
         --
         -- mac read
         --
         if i.tx_cmdregfull = '0' then
            -- txframe cmdreg not full: mac-read command request         
            o.tx_cmdwrite    := '1';
            o.tx_cmddestport := i.rx_cmdsrcport;
            o.tx_cmddestaddr := i.rx_cmdsrcaddr;
            o.tx_cmdcode     := i.rx_cmdcode;   -- default: cmdcode loopback echo
            o.tx_cmdcode(7)  := '1';            -- bit7 = echo-frame marker
            o.tx_cmdports    := i.rx_cmdports;  -- cmdports contains mac-read 8bit nodeaddr (note: current LUT is 16 words --> only nibble low is used)
            o.tx_cmdparams   := i.rx_cmdparams; -- default: cmdparams loopback echo
            --
            -- command exec
            --
            o.tx_cmd_txreq    := '1';
            o.tx_cmd_macread  := '1';
            o.tx_cmd_macwrite := '0';
            -- command done
            r.FSMmain := S99;         
         else
           -- txframe cmdreg is full: mac-read command ignored (echo-frame not transmitted)
           r.FSMmain := S99;         
         end if;  

      elsif n.cmdcode = 12 then
         --
         -- mac write
         --
         if i.tx_cmdregfull = '0' then
            -- txframe cmdreg not full: mac-write command request         
            o.tx_cmdwrite    := '1';
            o.tx_cmddestport := i.rx_cmdsrcport;
            o.tx_cmddestaddr := i.rx_cmdsrcaddr;
            o.tx_cmdcode     := i.rx_cmdcode;   -- default: cmdcode loopback echo
            o.tx_cmdcode(7)  := '1';            -- bit7 = echo-frame marker
            o.tx_cmdports    := i.rx_cmdports;  -- cmdports contains mac-write 8bit nodeaddr (note: current LUT is 16 words --> only nibble low is used)
            o.tx_cmdparams   := i.rx_cmdparams; -- default: cmdparams loopback echo
            --
            -- command exec
            --
            o.tx_cmd_txreq    := '1';
            o.tx_cmd_macread  := '1';
            o.tx_cmd_macwrite := '1';
            -- note: command updates txframe mac-table then re-reads written data and transmits mac-read frame 

            -- command done
            r.FSMmain := S99;         
         else
            -- txframe cmdreg is full: mac-write command ignored (echo-frame not transmitted)
            r.FSMmain := S99;         
         end if;  

      elsif n.cmdcode = 13 then
         --
         -- open/close connection
         --
         if i.tx_cmdregfull = '0' then
            -- txframe cmdreg not full: command accepted (command will generate echo-frame) 
            o.tx_cmdwrite    := '1';
            o.tx_cmddestport := i.rx_cmdsrcport;
            o.tx_cmddestaddr := i.rx_cmdsrcaddr;
            o.tx_cmdcode     := i.rx_cmdcode;   -- default: cmdcode loopback echo
            o.tx_cmdcode(7)  := '1';            -- bit7 = echo-frame marker
            o.tx_cmdports    := i.rx_cmdports;  -- default: cmdports loopback echo
            o.tx_cmdparams   := i.rx_cmdparams; -- default: cmdparams loopback echo
            --
            -- command exec
            --
            -- note: cmd-params are organized in groups of 16bit (little endian format)
            -- note1: bits 1..15 work as port-mask, bit0 used as OPEN/CLOSE request
            n.word16 := i.rx_cmdparams(1) & i.rx_cmdparams(0);
            n.wout16 := SLV(0, 15) & n.word16(0);
            FOR index IN 1 TO txport1_NPORTS LOOP
               if n.word16(index) = '1' and (ro.tfilter_ok(index) = '1' or i.rx_cmdports(7) = '1') then
                  -- indexed tport selected, tfilter does not block | forced mode: open/close applied
                  if n.word16(0) = '1' then
                     -- open tport connection
                     r.tfilter_ena(index)  := '1';
                     r.tfilter_addr(index) := i.rx_cmdsrcaddr;
                     r.tfilter_port(index) := i.rx_cmdports(3 downto 0);
                  else
                     -- close tport connection
                     r.tfilter_ena(index)  := '0';
                     r.tfilter_addr(index) := "00000000";
                     r.tfilter_port(index) := "0000";
                  end if;
                  n.wout16(index) := '1';
               end if;
            END LOOP;
            if (i.rx_cmdports(6) = '0') then
               -- write mode: command replies using bit-masks of updated ports
               o.tx_cmdparams(0) := n.wout16( 7 downto 0);
               o.tx_cmdparams(1) := n.wout16(15 downto 8);
            else 
               -- read mode: command replies using tfilter status
               n.wout16 := SLV(0, 16);
               FOR index IN 1 to txport1_NPORTS LOOP
                  n.wout16(index) := ro.tfilter_ena(index);
               END LOOP;
               o.tx_cmdparams(0) := n.wout16( 7 downto 0);
               o.tx_cmdparams(1) := n.wout16(15 downto 8);
            end if;
            -- 
            n.word16 := i.rx_cmdparams(3) & i.rx_cmdparams(2);
            n.wout16 := SLV(0, 15) & n.word16(0);
            FOR index IN 1 TO rxport1_NPORTS LOOP
               if n.word16(index) = '1' and (ro.rfilter_ok(index) = '1' or i.rx_cmdports(7) = '1') then
                  -- indexed rport selected, rfilter does not block | forced mode: open/close applied
                  if n.word16(0) = '1' then
                     -- open rport connection
                     r.rfilter_ena(index)  := '1';
                     r.rfilter_addr(index) := i.rx_cmdsrcaddr;
                     r.rfilter_port(index) := i.rx_cmdports(3 downto 0);
                  else
                     -- close rport connection
                     r.rfilter_ena(index)  := '0';
                     r.rfilter_addr(index) := "00000000";
                     r.rfilter_port(index) := "0000";
                  end if;
                  n.wout16(index) := '1';
               end if;
            END LOOP;
            if (i.rx_cmdports(6) = '0') then
               -- write mode: command replies using bit-masks of updated ports
               o.tx_cmdparams(2) := n.wout16( 7 downto 0);
               o.tx_cmdparams(3) := n.wout16(15 downto 8);
            else 
               -- read mode: command replies using rfilter status
               n.wout16 := SLV(0, 16);
               FOR index IN 1 to rxport1_NPORTS LOOP
                  n.wout16(index) := ro.rfilter_ena(index);
               END LOOP;
               o.tx_cmdparams(2) := n.wout16( 7 downto 0);
               o.tx_cmdparams(3) := n.wout16(15 downto 8);
            end if;
            -- TX/RX NPORTS params (note: newtwork nodes may have a different configurations 
            -- of TX/RX ports --> command will return actual values)
            o.tx_cmdparams(4) := SLV(txport1_NPORTS, 8);
            o.tx_cmdparams(5) := SLV(rxport1_NPORTS, 8);
            --
            o.tx_cmd_txreq    := '1';
            o.tx_cmd_macread  := '0';
            o.tx_cmd_macwrite := '0';
            -- command done
            r.FSMmain := S99;         
         else
            -- txframe cmdreg is full: command ignored (echo-frame not transmitted)
            r.FSMmain := S99;         
         end if;  
         --
         -- note: different nodes/machines can try to connect to the same node/port so a lightweight form 
         -- of arbitration logic has been implemented on destination (target) nodes.
         -- Connections are distinguished on a source address/port basis: there is NO connection/session
         -- numbering, only one connection per port is supported (each port has its own srcaddr,srcport 
         -- filter).
         --
         -- note1: open/close commands allow exclusive access from source nodes
         -- to destination tx/rx ports --> all ports connected to the same source node can receive 
         -- commands only from that node (uninterrumpible transactions working on
         -- one/more ports are possible). 
         -- 'open' command selects one/more ports for successive operations: once a connection
         -- is established all requests from others -not connected- nodes are ignored
         -- 'close' command restores one/more ports to not-connected-state (requests from
         -- any nodes are accepted so race-conditions may appear).
         --
         -- note2: there is a special 'open/close forced mode' to gain control of
         -- a node when it is locked by others connections (recovery always possible)      
         --
         -- note3: there is a special 'open/close read mode' to get current status of all ports
         --

      elsif n.cmdcode = 14 then
         --
         -- framegen control
         --
         if i.tx_cmdregfull = '0' then
            -- txframe cmdreg not full: command accepted (command will generate echo-frame) 
            o.tx_cmdwrite    := '1';
            o.tx_cmddestport := i.rx_cmdsrcport;
            o.tx_cmddestaddr := i.rx_cmdsrcaddr;
            o.tx_cmdcode     := i.rx_cmdcode;   -- default: cmdcode loopback echo
            o.tx_cmdcode(7)  := '1';            -- bit7 = echo-frame marker
            o.tx_cmdports    := i.rx_cmdports;  -- default: cmdports loopback echo
            o.tx_cmdparams   := i.rx_cmdparams; -- default: cmdparams loopback echo
            --
            -- command exec
            --
            -- note: cmd-params are organized in groups of 16bit (little endian format)
            if i.rx_cmdports(7) = '0' then
               -- framegen flags/params updated
               n.word16 := i.rx_cmdparams(1) & i.rx_cmdparams(0);
               r.fgen_loop := n.word16(0);
               FOR index IN 1 to txport1_NPORTS LOOP
                  r.fgen_trig(index) := n.word16(index); 
               END LOOP;
               --
               n.word16 := i.rx_cmdparams(3) & i.rx_cmdparams(2); 
               r.fgen_destaddr := n.word16(7 downto 0);
               r.fgen_destport := n.word16(11 downto 8);     
               r.fgen_destmode := n.word16(14 downto 12);
               r.fgen_ena      := n.word16(15);  
               --
               n.word16 := i.rx_cmdparams(5) & i.rx_cmdparams(4);
               r.fgen_framelen := n.word16(10 downto 0);
               -- framegen write pulse
               r.fgen_wr := '1';
               -- note: framegen write pulse appears to output with 1 clock latency
               -- (write pulse aligned with registered params)
               --
               -- note1: command replies using current written params (tx_cmdparams default loopback)
               --
            else
               -- framegen flags/params read: command replies using current framegen status
               n.word16 := SLV(0, 16);
               FOR index IN 1 to txport1_NPORTS LOOP
                  n.word16(index) := ro.fgen_trig(index); 
               END LOOP;     
               o.tx_cmdparams(0) := n.word16(7 downto 1) & ro.fgen_loop;  
               o.tx_cmdparams(1) := n.word16(15 downto 8);
               --
               o.tx_cmdparams(2) := ro.fgen_destaddr(7 downto 0); 
               o.tx_cmdparams(3) := ro.fgen_ena & ro.fgen_destmode(2 downto 0) & ro.fgen_destport(3 downto 0);
               --
               o.tx_cmdparams(4) := ro.fgen_framelen(7 downto 0);
               o.tx_cmdparams(5) := "00000" & ro.fgen_framelen(10 downto 8);  
            end if;
            --
            o.tx_cmd_txreq    := '1';
            o.tx_cmd_macread  := '0';
            o.tx_cmd_macwrite := '0';
            -- command done
            r.FSMmain := S99;         
         else
            -- txframe cmdreg is full: command ignored (echo-frame not transmitted)
            r.FSMmain := S99;         
         end if;  
         --
         -- note: current implementation of framegen control logic does not depend on
         -- connection-state --> command always accepted, we assume some form of
         -- external arbitration between network source nodes (framegen is only a debug/test resource...)
         --

      elsif n.cmdcode = 15 then
         --
         -- init 
         --
         if i.tx_cmdregfull = '0' then
            -- txframe cmdreg not full: command accepted (command will generate echo-frame) 
            o.tx_cmdwrite    := '1';
            o.tx_cmddestport := i.rx_cmdsrcport;
            o.tx_cmddestaddr := i.rx_cmdsrcaddr;
            o.tx_cmdcode     := i.rx_cmdcode;   -- default: cmdcode loopback echo
            o.tx_cmdcode(7)  := '1';            -- bit7 = echo-frame marker
            o.tx_cmdports    := i.rx_cmdports;  -- default: cmdports loopback echo
            o.tx_cmdparams   := i.rx_cmdparams; -- default: cmdparams loopback echo
            --
            -- command exec
            --
            -- note: all ports are initialized
            r.tport_enable      := (others => '0');
            r.tport_ackenable   := (others => '0');
            r.tport_timerenable := (others => '0');
            --
            r.rport_enable      := (others => '0');
            r.rport_seqnumena   := (others => '0');
            --
            r.tfilter_addr      := (others => "00000000");
            r.tfilter_port      := (others => "0000");
            r.tfilter_ena       := (others => '0');
            --
            r.rfilter_addr      := (others => "00000000");
            r.rfilter_port      := (others => "0000");
            r.rfilter_ena       := (others => '0');
            -- note: internal-node-state is level driven by cmdctrl module --> all regs default to zero  

            r.fgen_ena      := '0';
            r.fgen_loop     := '0';
            r.fgen_trig     := (others => '0');
            r.fgen_framelen := (others => '0');
            r.fgen_destaddr := (others => '0');
            r.fgen_destport := (others => '0');
            r.fgen_destmode := (others => '0');
            --
            r.fgen_wr := '1';
            -- note: framegen params must be written into framegen module so
            -- we have to generate a write cycle
            
            o.tx_cmd_txreq    := '1';
            o.tx_cmd_macread  := '0';
            o.tx_cmd_macwrite := '0';
            -- note: command replies using received params

            -- command done
            r.FSMmain := S99;         
         else
            -- txframe cmdreg is full: command ignored (echo-frame not transmitted)
            r.FSMmain := S99;      
         end if;  
         --
         -- note: 'init' command always accepted (connection-state is ignored) --> this command works as
         -- remote reset for current node 
         --

      else
         --
         -- command ignored 
         --
         r.FSMmain := S99;

      end if;

   when S99 =>
      --
      -- command done
      --
      o.rx_cmdread := '1';
      r.FSMmain := S1;

   when S100 =>
      --
      -- external cmd exec
      --
      n.ext_cmdexec := '1';
      if n.ext_cmdready = '0' then
         -- all external commands processed: return to 'rx command test'
         r.FSMmain := S1_0;
      end if;
      -- note: 'external cmd exec' state will return to 'rx command test' state
      -- (round-robin scheduler for external/received commands) 

   end case;

   -- 
   -- tport cmd filter
   --
   FOR index IN 1 TO txport1_NPORTS LOOP
      -- cmd_srcaddr test
      r.tfilter_addr_ok(index) := '0';
      if ro.tfilter_addr(index) = i.rx_cmdsrcaddr(7 downto 0) then 
         r.tfilter_addr_ok(index) := '1';
      end if;
      -- cmd_srcport test
      r.tfilter_port_ok(index) := '0';
      if ro.tfilter_port(index) = i.rx_cmdports(3 downto 0) then
         r.tfilter_port_ok(index) := '1';
      end if;
      -- note: registered flags 'tfilter_NNNN_ok' are generated with 1 clock delay (clk1)
   END LOOP;
   --
   FOR index IN 1 TO txport1_NPORTS LOOP
      -- tport filter test
      r.tfilter_ok(index) := '0';
      if (ro.tfilter_ena(index) = '0') or ((ro.tfilter_addr_ok(index) = '1') and (ro.tfilter_port_ok(index) = '1')) then    
         -- filter off | (cmd_srcaddr,cmd_srcport) match --> registered flag 'tfilter_ok' generated with 1 clock delay (clk2) 
         r.tfilter_ok(index) := '1';       
      end if; 
   END LOOP;
   -- note: test logic always ON --> when cmd is received ('i.rx_cmdready = 1') input parameters do not 
   --                                change until cmd is read ('S99')
   -- note1: logic needs 2 clock cycles to generate test-results ('S1_0' --[clk1]--> 'S1_1' --[clk2]--> 'S2') 

   -- 
   -- rport cmd filter
   --
   FOR index IN 1 TO rxport1_NPORTS LOOP
      -- cmd_srcaddr test
      r.rfilter_addr_ok(index) := '0';
      if ro.rfilter_addr(index) = i.rx_cmdsrcaddr(7 downto 0) then 
         r.rfilter_addr_ok(index) := '1';
      end if;
      -- cmd_srcport test
      r.rfilter_port_ok(index) := '0';
      if ro.rfilter_port(index) = i.rx_cmdports(3 downto 0) then
         r.rfilter_port_ok(index) := '1';
      end if;
      -- note: registered flags 'rfilter_NNNN_ok' are generated with 1 clock delay (clk1)
   END LOOP;
   --
   FOR index IN 1 TO rxport1_NPORTS LOOP
      -- rport filter test
      r.rfilter_ok(index) := '0';
      if (ro.rfilter_ena(index) = '0') or ((ro.rfilter_addr_ok(index) = '1') and (ro.rfilter_port_ok(index) = '1')) then    
         -- filter off | (cmd_srcaddr,cmd_srcport) match --> registered flag 'rfilter_ok' generated with 1 clock delay (clk2) 
         r.rfilter_ok(index) := '1';       
      end if; 
   END LOOP;
   -- note: test logic always ON --> when cmd is received ('i.rx_cmdready = 1') input parameters do not 
   --                                change until cmd is read ('S99')
   -- note1: logic needs 2 clock cycles to generate test-results ('S1_0' --[clk1]--> 'S1_1' --[clk2]--> 'S2') 

  
end procedure;


--
-- External control interface 
--
-- clock domain: clk2
--
-- !!! SubExtCtrl MUST be called after SubFSMmain !!!
--
procedure SubExtCtrl
(
   variable i : in inputs_t;
   variable ri: in reglist_clk2_t;
   variable ro: in reglist_clk2_t;
   variable o : inout outputs_t;
   variable r : inout reglist_clk2_t;
   variable n : inout netlist_t
) is
begin

   --
   -- config posedge detectors
   --
   r.tport_enable_wr := i.ext_tport_enable_wr;
   n.tport_enable_wr := i.ext_tport_enable_wr and not(ro.tport_enable_wr);
   r.tport_ackenable_wr := i.ext_tport_ackenable_wr;
   n.tport_ackenable_wr := i.ext_tport_ackenable_wr and not(ro.tport_ackenable_wr);
   r.tport_timerenable_wr := i.ext_tport_timerenable_wr;
   n.tport_timerenable_wr := i.ext_tport_timerenable_wr and not(ro.tport_timerenable_wr);
   r.tport_seqnumclr_wr := i.ext_tport_seqnumclr_wr;
   n.tport_seqnumclr_wr := i.ext_tport_seqnumclr_wr and not(ro.tport_seqnumclr_wr);
   --
   r.rport_enable_wr := i.ext_rport_enable_wr;
   n.rport_enable_wr := i.ext_rport_enable_wr and not(ro.rport_enable_wr);
   r.rport_seqnumena_wr := i.ext_rport_seqnumena_wr;
   n.rport_seqnumena_wr := i.ext_rport_seqnumena_wr and not(ro.rport_seqnumena_wr);
   r.rport_seqnumclr_wr := i.ext_rport_seqnumclr_wr;
   n.rport_seqnumclr_wr := i.ext_rport_seqnumclr_wr and not(ro.rport_seqnumclr_wr);
   -- note: external interface uses posedge of 'NNNNNN_wr' inputs (interface can work 
   -- with external write pulses of variable length --> i.e. NIOS2 parallel slow I/O)

   --
   -- config write request (single register fifo)
   --
   if n.tport_enable_wr = '1' and ro.tport_enable_flag = '0' then
      r.tport_enable_save := i.ext_tport_enable;
      r.tport_enable_flag := '1';
   end if;
   if n.tport_ackenable_wr = '1' and ro.tport_ackenable_flag = '0' then
      r.tport_ackenable_save := i.ext_tport_ackenable;
      r.tport_ackenable_flag := '1';
   end if;
   if n.tport_timerenable_wr = '1' and ro.tport_timerenable_flag = '0' then
      r.tport_timerenable_save := i.ext_tport_timerenable;
      r.tport_timerenable_flag := '1';
   end if;
   if n.tport_seqnumclr_wr = '1' and ro.tport_seqnumclr_flag = '0' then
      r.tport_seqnumclr_save := i.ext_tport_seqnumclr;
      r.tport_seqnumclr_flag := '1';
   end if;
   --
   if n.rport_enable_wr = '1' and ro.rport_enable_flag = '0' then
      r.rport_enable_save := i.ext_rport_enable;
      r.rport_enable_flag := '1';
   end if;
   if n.rport_seqnumena_wr = '1' and ro.rport_seqnumena_flag = '0' then
      r.rport_seqnumena_save := i.ext_rport_seqnumena;
      r.rport_seqnumena_flag := '1';
   end if;
   if n.rport_seqnumclr_wr = '1' and ro.rport_seqnumclr_flag = '0' then
      r.rport_seqnumclr_save := i.ext_rport_seqnumclr;
      r.rport_seqnumclr_flag := '1';
   end if;

   --
   -- config write operation
   --
   -- note: bits 1..15 work as write mask, bit0 defines SET/CLR write level
   -- (SET/CLR applied only to selected bits, not-selected bits unchanged)  
   --
   if n.ext_cmdexec = '1' and ro.tport_enable_flag = '1' then
      FOR index IN 1 to 15 LOOP
         if ro.tport_enable_save(index) = '1' then
            -- mask = 1 --> bit0 defines SET/CLR write level
            r.tport_enable(index) := ro.tport_enable_save(0);
         else
            -- mask = 0 --> current bit unchanged
            null;
         end if;
      END LOOP;
      -- !! Debug !! simple copy
      --r.tport_enable      := ro.tport_enable_save;
      -- !! Debug !! simple copy
      r.tport_enable_flag := '0';
   end if;
   if n.ext_cmdexec = '1' and ro.tport_ackenable_flag = '1' then
      FOR index IN 1 to 15 LOOP
         if ro.tport_ackenable_save(index) = '1' then
            r.tport_ackenable(index) := ro.tport_ackenable_save(0);
         end if;
      END LOOP;
      -- !! Debug !! simple copy
      --r.tport_ackenable      := ro.tport_ackenable_save;
      -- !! Debug !! simple copy
      r.tport_ackenable_flag := '0';
   end if;
   if n.ext_cmdexec = '1' and ro.tport_timerenable_flag = '1' then
      FOR index IN 1 to 15 LOOP
         if ro.tport_timerenable_save(index) = '1' then
            r.tport_timerenable(index) := ro.tport_timerenable_save(0); 
         end if;
      END LOOP;
      -- !! Debug !! simple copy
      --r.tport_timerenable      := ro.tport_timerenable_save;
      -- !! Debug !! simple copy
      r.tport_timerenable_flag := '0';
   end if;
   if n.ext_cmdexec = '1' and ro.tport_seqnumclr_flag = '1' then
      FOR index in 1 to txport1_NPORTS LOOP
         o.tport_cmdseqnumclr(index) := ro.tport_seqnumclr_save(index);
      END LOOP;
      -- note: bits 1..15 work as port-mask, bit0 reserved
      -- (command applied in parallel to all selected ports)
      r.tport_seqnumclr_flag := '0';
   end if;
   --
   if n.ext_cmdexec = '1' and ro.rport_enable_flag = '1' then
      FOR index IN 1 to 15 LOOP
         if ro.rport_enable_save(index) = '1' then
            r.rport_enable(index) := ro.rport_enable_save(0);
         end if;
      END LOOP;
      -- !! Debug !! simple copy
      --r.rport_enable      := ro.rport_enable_save;
      -- !! Debug !! simple copy
      r.rport_enable_flag := '0';
   end if;
   if n.ext_cmdexec = '1' and ro.rport_seqnumena_flag = '1' then
      FOR index IN 1 to 15 LOOP
         if ro.rport_seqnumena_save(index) = '1' then
            r.rport_seqnumena(index) := ro.rport_seqnumena_save(0);
         end if;
      END LOOP;
      -- !! Debug !! simple copy
      --r.rport_seqnumena      := ro.rport_seqnumena_save;
      -- !! Debug !! simple copy
      r.rport_seqnumena_flag := '0';
   end if;
   if n.ext_cmdexec = '1' and ro.rport_seqnumclr_flag = '1' then
      FOR index in 1 to rxport1_NPORTS LOOP
         o.rport_seqnumclr(index) := ro.rport_seqnumclr_save(index);
      END LOOP;
      -- note: bits 1..15 work as port-mask, bit0 reserved
      -- (command applied in parallel to all selected ports)
      r.rport_seqnumclr_flag := '0';
   end if;

   --
   -- config output status
   --
   o.ext_tport_enable_sts      := ro.tport_enable(15 downto 0);
   o.ext_tport_ackenable_sts   := ro.tport_ackenable(15 downto 0);
   o.ext_tport_timerenable_sts := ro.tport_timerenable(15 downto 0);
   --
   o.ext_tport_renable_sts := (others => '0'); -- default zero
   o.ext_tport_rerror_sts  := (others => '0'); --
   FOR index IN 1 to txport1_NPORTS LOOP
      o.ext_tport_renable_sts(index) := i.tport_renable(index);
      o.ext_tport_rerror_sts(index)  := i.tport_rerror(index);
   END LOOP;   
   --
   o.ext_rport_enable_sts    := ro.rport_enable(15 downto 0);
   o.ext_rport_seqnumena_sts := ro.rport_seqnumena(15 downto 0);
   --
   o.ext_rport_wready_sts    := (others => '0'); -- default zero
   o.ext_rport_werrempty_sts := (others => '0'); --
   o.ext_rport_werrfull_sts  := (others => '0'); --
   FOR index IN 1 to rxport1_NPORTS LOOP
      o.ext_rport_wready_sts(index)    := i.rport_wready(index);
      o.ext_rport_werrempty_sts(index) := i.rport_werrempty(index);
      o.ext_rport_werrfull_sts(index)  := i.rport_werrfull(index);
   END LOOP;   
   --
   -- note: status signals from tport/rport arrays are grouped 
   -- into 16bit words (bit range: NPORTS..1, unused bits are zero) 
   --

   --
   -- srcfilter posedge detectors
   --
   r.tport_srcfilterena_wr := i.ext_tport_srcfilterena_wr;
   n.tport_srcfilterena_wr := i.ext_tport_srcfilterena_wr and not(ro.tport_srcfilterena_wr);
   r.tport_srcfilter_wr    := i.ext_tport_srcfilter_wr;
   n.tport_srcfilter_wr    := i.ext_tport_srcfilter_wr and not(ro.tport_srcfilter_wr);
   --
   r.rport_srcfilterena_wr := i.ext_rport_srcfilterena_wr;
   n.rport_srcfilterena_wr := i.ext_rport_srcfilterena_wr and not(ro.rport_srcfilterena_wr);
   r.rport_srcfilter_wr    := i.ext_rport_srcfilter_wr;
   n.rport_srcfilter_wr    := i.ext_rport_srcfilter_wr and not(ro.rport_srcfilter_wr);
   -- note: external interface uses posedge of 'NNNNNN_wr' inputs (interface can work 
   -- with external write pulses of variable length --> i.e. NIOS2 parallel slow I/O)

   --
   -- srcfilter write request (single register fifo)
   --
   if n.tport_srcfilterena_wr = '1' and ro.tport_srcfilterena_flag = '0' then
      r.tport_srcfilterena_save := i.ext_tport_srcfilterena;
      r.tport_srcfilterena_flag := '1';
   end if;
   if n.tport_srcfilter_wr = '1' and ro.tport_srcfilter_flag = '0' then
      r.tport_srcfilter_save     := i.ext_tport_srcfilter;
      r.tport_srcfilteraddr_save := i.ext_tport_srcfilteraddr;
      r.tport_srcfilterport_save := i.ext_tport_srcfilterport;
      r.tport_srcfilter_flag := '1';
   end if;
   --
   if n.rport_srcfilterena_wr = '1' and ro.rport_srcfilterena_flag = '0' then
      r.rport_srcfilterena_save := i.ext_rport_srcfilterena;
      r.rport_srcfilterena_flag := '1';
   end if;
   if n.rport_srcfilter_wr = '1' and ro.rport_srcfilter_flag = '0' then
      r.rport_srcfilter_save     := i.ext_rport_srcfilter;
      r.rport_srcfilteraddr_save := i.ext_rport_srcfilteraddr;
      r.rport_srcfilterport_save := i.ext_rport_srcfilterport;
      r.rport_srcfilter_flag := '1';
   end if;

   --
   -- srcfilter write operation
   --
   if n.ext_cmdexec = '1' and ro.tport_srcfilterena_flag = '1' then
      FOR index IN 1 TO txport1_NPORTS LOOP
         r.tfilter_ena(index) := ro.tport_srcfilterena_save(index); -- ???? usare la SET/CLR ????
      END LOOP;
      r.tport_srcfilterena_flag := '0';
   end if;
   if n.ext_cmdexec = '1' and ro.tport_srcfilter_flag = '1' then
      FOR index IN 1 to txport1_NPORTS LOOP
         if index = UINT(ro.tport_srcfilter_save) then
            r.tfilter_addr(index) := ro.tport_srcfilteraddr_save;
            r.tfilter_port(index) := ro.tport_srcfilterport_save;
         end if;
      END LOOP;
      r.tport_srcfilter_flag := '0';
   end if;
   --
   if n.ext_cmdexec = '1' and ro.rport_srcfilterena_flag = '1' then
      FOR index IN 1 TO rxport1_NPORTS LOOP
         r.rfilter_ena(index) := ro.rport_srcfilterena_save(index); -- ???? usare la SET/CLR ????
      END LOOP;
      r.rport_srcfilterena_flag := '0';
   end if;
   if n.ext_cmdexec = '1' and ro.rport_srcfilter_flag = '1' then
      FOR index IN 1 to rxport1_NPORTS LOOP
         if index = UINT(ro.rport_srcfilter_save) then
            r.rfilter_addr(index) := ro.rport_srcfilteraddr_save;
            r.rfilter_port(index) := ro.rport_srcfilterport_save;
         end if;
      END LOOP;
      r.rport_srcfilter_flag := '0';
   end if;

   --
   -- srcfilter output status
   --
   o.ext_tport_srcfilterena_sts  := (others => '0');
   o.ext_tport_srcfilteraddr_sts := (others => "00000000");
   o.ext_tport_srcfilterport_sts := (others => "0000");
   FOR index IN 1 to txport1_NPORTS LOOP
      o.ext_tport_srcfilterena_sts(index)  := ro.tfilter_ena(index);
      o.ext_tport_srcfilteraddr_sts(index) := ro.tfilter_addr(index);
      o.ext_tport_srcfilterport_sts(index) := ro.tfilter_port(index);
   END LOOP;   
   --
   o.ext_rport_srcfilterena_sts  := (others => '0');
   o.ext_rport_srcfilteraddr_sts := (others => "00000000");
   o.ext_rport_srcfilterport_sts := (others => "0000");
   FOR index IN 1 to rxport1_NPORTS LOOP
      o.ext_rport_srcfilterena_sts(index)  := ro.rfilter_ena(index);
      o.ext_rport_srcfilteraddr_sts(index) := ro.rfilter_addr(index);
      o.ext_rport_srcfilterport_sts(index) := ro.rfilter_port(index);
   END LOOP;   
                                             
   --
   -- framegen posedge detectors
   --
   r.framegen_wr := i.ext_fgen_wr;
   n.framegen_wr := i.ext_fgen_wr and not(ro.framegen_wr);
   r.framegen_destaddr_wr := i.ext_fgen_destaddr_wr;
   n.framegen_destaddr_wr := i.ext_fgen_destaddr_wr and not(ro.framegen_destaddr_wr);
   r.framegen_destmode_wr := i.ext_fgen_destmode_wr;
   n.framegen_destmode_wr := i.ext_fgen_destmode_wr and not(ro.framegen_destmode_wr);
   r.framegen_framelen_wr := i.ext_fgen_framelen_wr;
   n.framegen_framelen_wr := i.ext_fgen_framelen_wr and not(ro.framegen_framelen_wr);
   -- note: external interface uses posedge of 'NNNNNN_wr' inputs (interface can work 
   -- with external write pulses of variable length --> i.e. NIOS2 parallel slow I/O)

   --
   -- framegen write request (single register fifo)
   --
   if n.framegen_wr = '1' and ro.framegen_flag = '0' then
      r.fgen_ena_save  := i.ext_fgen_ena;
      r.fgen_loop_save := i.ext_fgen_loop;
      FOR index in 1 to txport1_NPORTS LOOP
         r.fgen_trig_save(index) := i.ext_fgen_trig(index);
      END LOOP;
      r.framegen_flag := '1';
   end if;
   if n.framegen_destaddr_wr = '1' and ro.framegen_destaddr_flag = '0' then
      r.fgen_destaddr_save := i.ext_fgen_destaddr(7 downto 0);
      r.fgen_destport_save := i.ext_fgen_destport(3 downto 0);
      r.framegen_destaddr_flag := '1';
   end if;
   if n.framegen_destmode_wr = '1' and ro.framegen_destmode_flag = '0' then
      r.fgen_destmode_save := i.ext_fgen_destmode(2 downto 0);
      r.framegen_destmode_flag := '1';
   end if;
   if n.framegen_framelen_wr = '1' and ro.framegen_framelen_flag = '0' then
      r.fgen_framelen_save := i.ext_fgen_framelen(10 downto 0);
      r.framegen_framelen_flag := '1';
   end if;

   --
   -- framegen write operation
   --
   if n.ext_cmdexec = '1' and ro.framegen_flag = '1' then
      r.fgen_wr := '1';
      --
      r.fgen_ena  := ro.fgen_ena_save;
      r.fgen_loop := ro.fgen_loop_save;
      FOR index in 1 to txport1_NPORTS LOOP
         r.fgen_trig(index) := ro.fgen_trig_save(index);
      END LOOP;
      -- note: bit(15..1) used, bit(0) reserved
      r.framegen_flag := '0';
   end if;
   --
   if n.ext_cmdexec = '1' and ro.framegen_destaddr_flag = '1' then
      r.fgen_wr := '1';
      --
      r.fgen_destaddr := ro.fgen_destaddr_save(7 downto 0);
      r.fgen_destport := ro.fgen_destport_save(3 downto 0);
      r.framegen_destaddr_flag := '0';
   end if;
   --
   if n.ext_cmdexec = '1' and ro.framegen_destmode_flag = '1' then
      r.fgen_wr := '1';
      --
      r.fgen_destmode := ro.fgen_destmode_save(2 downto 0);
      r.framegen_destmode_flag := '0'; 
   end if;
   --
   if n.ext_cmdexec = '1' and ro.framegen_framelen_flag = '1' then
      r.fgen_wr := '1';
      --
      r.fgen_framelen := ro.fgen_framelen_save(10 downto 0);
      r.framegen_framelen_flag := '0';
   end if;

   --
   -- framegen output status
   --
   o.ext_fgen_ena_sts  := ro.fgen_ena;
   o.ext_fgen_loop_sts := ro.fgen_loop;
   --
   o.ext_fgen_trig_sts := (others => '0');
   FOR index IN 1 to txport1_NPORTS LOOP
      o.ext_fgen_trig_sts(index) := ro.fgen_trig(index);
   END LOOP;  
   -- 
   o.ext_fgen_destaddr_sts := ro.fgen_destaddr(7 downto 0);
   o.ext_fgen_destport_sts := ro.fgen_destport(3 downto 0);
   o.ext_fgen_destmode_sts := ro.fgen_destmode(2 downto 0);
   o.ext_fgen_framelen_sts := ro.fgen_framelen(10 downto 0);  

   --
   -- maclut posedge detectors
   --
   r.maclut_wr := i.ext_maclut_wr;
   n.maclut_wr := i.ext_maclut_wr and not(ro.maclut_wr);
   r.maclut_rd := i.ext_maclut_rd;
   n.maclut_rd := i.ext_maclut_rd and not(ro.maclut_rd);
   r.maclut_load := i.ext_maclut_load;
   n.maclut_load := i.ext_maclut_load and not(ro.maclut_load);
   -- note: external interface uses posedge of 'NNNNNN_wr/rd/load' inputs (interface can work 
   -- with external write pulses of variable length --> i.e. NIOS2 parallel slow I/O)

   --
   -- maclut load (maclut byte register is updated until write/read request) 
   --
   if n.maclut_load = '1' and ro.maclut_flag = '0' then
      FOR index IN 0 to 5 LOOP
         if UINT(i.ext_maclut_sel) = index then
            -- selected byte updated
            r.mac_data_save(index) := i.ext_maclut_data;
         end if;
      END LOOP;
   end if;

   --
   -- maclut write/read request (single register fifo)
   --
   if (n.maclut_wr = '1' or n.maclut_rd = '1') and ro.maclut_flag = '0' then
      r.mac_addr_save  := i.ext_maclut_addr(3 downto 0);
      r.mac_write_save := n.maclut_wr;
      r.mac_read_save  := n.maclut_rd;
      r.macread_valid  := '0';
      -- note: any maclut write/read request makes current status not valid
      -- ('macread_valid = 0' means "new macread command is needed" or "macread command is in progress"
      -- ...status captured when 'macread_valid = 0' should be discarded because 'maclut content is 
      -- changed' or 'command in progress, waiting for completion') 
      r.maclut_flag := '1';
   end if;

   --
   -- maclut write/read operation
   --
   case ro.FSMmaclut is
   when S0 =>
      --
      -- reset state
      --
      r.FSMmaclut := S1;

   when S1 =>
      --
      -- init state
      --
      if n.ext_cmdexec = '1' and ro.maclut_flag = '1' then
         -- external command scheduled, maclut command request
         if i.tx_cmdregfull = '0' then
            -- txframe cmdreg not full: mac-write/read command request         
            o.tx_cmdwrite    := '1';
            --o.tx_cmddestport := i.rx_cmdsrcport; -- not used: defaults to zero
            --o.tx_cmddestaddr := i.rx_cmdsrcaddr; -- not used: defaults to zero
            --o.tx_cmdcode     := i.rx_cmdcode;    -- not used: defaults to zero
            o.tx_cmdports    := "0000" & ro.mac_addr_save; -- maclut external addr (note: current LUT is 16 words --> only nibble low is used)
            o.tx_cmdparams   := ro.mac_data_save;          -- maclut external data (48bit mac)
            --
            -- command exec
            --
            o.tx_cmd_txreq    := '0';
            o.tx_cmd_macread  := ro.mac_read_save;
            o.tx_cmd_macwrite := ro.mac_write_save;
            -- note: command updates txframe mac-table without transmission
            -- note1: when write+read both enabled --> command will write new mac address
            -- then re-read LUT memory at the same nodeaddr 
            --
            -- maclut command loaded: to exec state 
            r.FSMmaclut := S2;   
         else
            -- txframe cmdreg is full: waiting for empty condition
            null;
         end if;
      else
         -- waiting for command scheduler / maclut command request
         null;
      end if;

   when S2 =>
      --
      -- exec state
      -- 
      if i.tx_cmdregfull = '0' then
         -- maclut command done: current status updated
         if ro.mac_read_save = '1' then
            -- macread operation done: output params updated
            r.macread_data  := i.tx_macread_data(0 to 5);
            r.macread_addr  := i.tx_macread_addr(3 downto 0);
            r.macread_valid := '1';
         end if;
         -- maclut command done: return to idle state 
         r.maclut_flag := '0';
         r.FSMmaclut := S1;   
      else
         -- maclut command in progress
         null;
      end if;

   end case;

   -- macwrite test
   if ro.FSMmain = S2 and UINT(n.cmdcode) = 12 and o.tx_cmdwrite = '1' then
      -- macwrite command loaded by rxframe interface: current macread output status become 
      -- not valid (max priority) 
      r.macread_valid := '0'; 
   end if;

   -- maclut output params
   o.ext_maclut_data_sts  := ro.macread_data(0 to 5);
   o.ext_maclut_addr_sts  := ro.macread_addr(3 downto 0);
   o.ext_maclut_valid_sts := ro.macread_valid;

   -- external cmd signaled
   n.ext_cmdready := (
      ro.tport_enable_flag       or
      ro.tport_ackenable_flag    or
      ro.tport_timerenable_flag  or
      ro.tport_seqnumclr_flag    or
      --
      ro.rport_enable_flag       or
      ro.rport_seqnumena_flag    or
      ro.rport_seqnumclr_flag    or
      --
      ro.tport_srcfilterena_flag or 
      ro.tport_srcfilter_flag    or
      --
      ro.rport_srcfilterena_flag or 
      ro.rport_srcfilter_flag    or
      --
      ro.framegen_flag           or
      ro.framegen_destaddr_flag  or
      ro.framegen_destmode_flag  or
      ro.framegen_framelen_flag  or
      --
      ro.maclut_flag
   );
   -- note: all external commands work in parallel --> each register 'ro.NNNNNN_flag'
   -- is cleared by the respective execution logic; when a flag is cleared the 
   -- external command is ready for a new execution
   -- note1: FSMmain waits (S100 state) until all external commands are done 
   -- (when a command requires a long execution time it does not block others 
   -- fast commands --> they can be continuously applied/execuded until all flags are zero...)

end procedure;


--
-- Debug combinatorial procedure (edit)
--
-- clock domain: clk2
--
procedure SubDebug
(
   variable i : in inputs_t;
   variable ri: in reglist_clk2_t;
   variable ro: in reglist_clk2_t;
   variable o : inout outputs_t;
   variable r : inout reglist_clk2_t;
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
   --n.[instance_name].outputs := allcmps.[instance_name].outputs;

   --
   -- all procedures call (edit)
   --
   -- clock domain: clk2
   SubFSMmain(i, ri.clk2, ro.clk2, o, r.clk2, n);
   SubExtCtrl(i, ri.clk2, ro.clk2, o, r.clk2, n);
   -- !!! SubExtCtrl MUST be called after SubFSMmain !!!

   SubDebug(i, ri.clk2, ro.clk2, o, r.clk2, n);
   -- all clock domains
   --SubDebug(i, ri, ro, o, r, n);

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
-- architecture rtl of cmdctrl
--
--**************************************************************
