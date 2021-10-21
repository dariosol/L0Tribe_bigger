--**************************************************************
--**************************************************************
--
-- Template file: comp_ck1.rec (new component, single clk)
--
--**************************************************************
--**************************************************************
--
--
-- Component mac_sgmii
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

package component_mac_sgmii is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- mac_sgmii constants (edit)
--
-- constant mac_sgmii_[constant_name] : [type] := [value];
--

--
-- mac_sgmii typedefs (edit)
--
-- subtype mac_sgmii_[name]_t is [type];
-- type mac_sgmii_[name]_t is [type];
--

--
-- mac_sgmii inputs (edit)
--
type mac_sgmii_inputs_t is record

   -- clock list
   clk : std_logic;       -- Avalon-MM clock
   ref_clk : std_logic;   -- sgmii reference clock (125 MHz local reference clock) 
   
   -- reset list
   rst  : std_logic;   
   -- note: async reset 

   -- sgmii rx-interface 
   rxp : std_logic;

   -- RegFile interface (Avalon-MM slave)
   mmaddress : std_logic_vector(3 downto 0);
   mmread : std_logic;
   mmwrite : std_logic;
   mmwritedata : std_logic_vector(31 downto 0);
   
   -- node params (quasi-static params, assumed synchronized to ref_clk)
   nodeaddr : std_logic_vector(7 downto 0);
   multicastaddr : std_logic_vector(7 downto 0);
   
   -- write interface: TX_NPORTS clock domains 
   wclk : std_logic_vector(1 to txport1_NPORTS);
   wrst : std_logic_vector(1 to txport1_NPORTS);

   -- write interface inputs (clock domain wclk(),wrst()) 
   wena : std_logic_vector(1 to txport1_NPORTS);               
   wreq : std_logic_vector(1 to txport1_NPORTS);               
   wdata : txport1_wdata_vector_t(1 to txport1_NPORTS);        
   wframelen : txport1_framelen_vector_t(1 to txport1_NPORTS);
   wdestport : txport1_destport_vector_t(1 to txport1_NPORTS); 
   wdestaddr : txport1_destaddr_vector_t(1 to txport1_NPORTS);
   wmulticast : std_logic_vector(1 to txport1_NPORTS);
   wtxreq : std_logic_vector(1 to txport1_NPORTS);   
   wtxclr : std_logic_vector(1 to txport1_NPORTS);        

   -- read interface: RX_NPORTS clock domains
   rclk : std_logic_vector(1 to rxport1_NPORTS);
   rrst : std_logic_vector(1 to rxport1_NPORTS);

   -- read interface inputs (clock domain rclk(),rrst()) 
   rena : std_logic_vector(1 to rxport1_NPORTS);
   rreq : std_logic_vector(1 to rxport1_NPORTS);
   rack : std_logic_vector(1 to rxport1_NPORTS);

   -- CPU interface (0 --> interface OFF, 1..NPORTS --> interface ON)
   CPUtxport : std_logic_vector(3 downto 0);
   CPUrxport : std_logic_vector(3 downto 0);
   -- note: CPU interface inputs work as generic parameters (normally driven by constant values) 

end record;

--
-- mac_sgmii outputs (edit)
--
type mac_sgmii_outputs_t is record

   -- sgmii tx-interface 
   txp : std_logic;

   -- RegFile interface (Avalon-MM slave)
   mmreaddata : std_logic_vector(31 downto 0);
   mmreaddatavalid : std_logic;
   mmwaitrequest : std_logic;

   -- write interface outputs (clock domain wclk(),wrst()) 
   wready : std_logic_vector(1 to txport1_NPORTS);
   wempty : std_logic_vector(1 to txport1_NPORTS); 
   wfull : std_logic_vector(1 to txport1_NPORTS); 
   werror : std_logic_vector(1 to txport1_NPORTS);
   wdatalen : txport1_framelen_vector_t(1 to txport1_NPORTS);
   wframes : txport1_frames_vector_t(1 to txport1_NPORTS);

   -- read interface outputs (clock domain rclk(),rrst()) 
   renasts : std_logic_vector(1 to rxport1_NPORTS);
   rdata : rxport1_rdata_vector_t(1 to rxport1_NPORTS);
   rready : std_logic_vector(1 to rxport1_NPORTS);
   rempty : std_logic_vector(1 to rxport1_NPORTS); 
   rfull : std_logic_vector(1 to rxport1_NPORTS);
   rframes : rxport1_frames_vector_t(1 to rxport1_NPORTS);
   rsrcaddr : rxport1_srcaddr_vector_t(1 to rxport1_NPORTS);
   rsrcport : rxport1_srcport_vector_t(1 to rxport1_NPORTS);
   rdatalen : rxport1_datalen_vector_t(1 to rxport1_NPORTS);
   rdatacnt : rxport1_datalen_vector_t(1 to rxport1_NPORTS);
   rseqnum  : rxport1_seqnum_vector_t(1 to rxport1_NPORTS);
   reoframe : std_logic_vector(1 to rxport1_NPORTS);
   --
   rerrfull : std_logic_vector(1 to rxport1_NPORTS); 
   rerrempty : std_logic_vector(1 to rxport1_NPORTS); 

end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- mac_sgmii component common interface (constant)
--
type mac_sgmii_t is record
   inputs : mac_sgmii_inputs_t;
   outputs : mac_sgmii_outputs_t;
end record;

--
-- mac_sgmii vector type (constant)
--
type mac_sgmii_vector_t is array(NATURAL RANGE <>) of mac_sgmii_t;

--
-- mac_sgmii component declaration (constant)
--
component mac_sgmii
generic (
   instance : natural
); 
port (
   inputs : in mac_sgmii_inputs_t;
   outputs : out mac_sgmii_outputs_t
);
end component;

--
-- mac_sgmii global signal to export range/width params (constant)
--
signal component_mac_sgmii : mac_sgmii_t;

end component_mac_sgmii;

--
-- mac_sgmii entity declaration
--

-- libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
--
-- use work.component_[name].all;
--
use work.component_mac_sgmii.all;
use work.component_sgmii1.all;
use work.component_syncrst1.all;
use work.component_mac_gmii.all;
--
use work.component_txport1.all;
use work.component_rxport1.all;
-- note: components are included because some I/O definitions 
-- use constants 'txport1_NPORTS','rxport1_NPORTS' ....si potrebbero usare solo le TX/RX_NPORTS....
 
-- mac_sgmii entity (constant)
entity mac_sgmii is
generic (
   instance : natural
); 
port (
   inputs : in mac_sgmii_inputs_t;
   outputs : out mac_sgmii_outputs_t
);
end mac_sgmii;

--**************************************************************
--**************************************************************

--**************************************************************
--
--
-- Component Architecture
--
--
--**************************************************************

architecture rtl of mac_sgmii is

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

--
-- state machines (edit)
--
-- type [FSMname]_t is (S0, S1, S2, S3 ...);
-- 

--
-- local registers (edit)
--
--
-- Notes: one record-type for each clock domain
--

--
-- clock domain: clk (note: regs are not used, reglist is empty)  
--
type reglist_clk_t is record

   -- end of list
   eol : std_logic;

end record;
constant reglist_clk_default : reglist_clk_t :=
(
   eol => '0'
);

--
-- clock domain: tx_clk
--
type reglist_tx_clk_t is record

   -- end of list
   eol : std_logic;

end record;
constant reglist_tx_clk_default : reglist_tx_clk_t :=
(
   eol => '0'
);

--
-- all local registers (edit)
--
-- Notes: one record-element for each clock domain
--
type reglist_t is record
   clk    : reglist_clk_t;
   tx_clk : reglist_tx_clk_t;
end record;

--
-- all local resets (edit)
--
-- Notes: one record-element for each clock domain
--
type resetlist_t is record
   clk : std_logic;
   tx_clk : std_logic;
   tx_clk_negedge : std_logic;
   rx_clk : std_logic;   
   rx_clk_negedge : std_logic;
end record;

--
-- all local nets (edit)
--
type netlist_t is record

   -- internal clocks
   tx_clk : std_logic;
   rx_clk : std_logic;

   -- internal resets (all clock domains: async asserted, sync deasserted)
   rst : resetlist_t;

   --
   -- component interface signals (edit)
   --
   -- [instance_name] : [component_name]_t;
   -- [instance_name] : [component_name]_vector_t([instance_range]);
   --
   syncrst : syncrst1_t;
   sgmii   : sgmii1_t;
   mac     : mac_gmii_t;

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
subtype inputs_t is mac_sgmii_inputs_t;
subtype outputs_t is mac_sgmii_outputs_t;

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
-- architecture rtl of mac_sgmii
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

syncrst : syncrst1 port map
(
   inputs => allnets.syncrst.inputs,
   outputs => allcmps.syncrst.outputs
);

mac : mac_gmii
generic map
(
   instance => instance
)
port map
(
   inputs => allnets.mac.inputs,
   outputs => allcmps.mac.outputs
);

sgmii : sgmii1 port map
(
   inputs => allnets.sgmii.inputs,
   outputs => allcmps.sgmii.outputs
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
-- clock domain: clk,rst (edit)
--
process (inputs.clk, allnets.rst.clk)
begin
   if (allnets.rst.clk = '1') then
      allregs.dout.clk <= reglist_clk_default;
   elsif rising_edge(inputs.clk) then
      allregs.dout.clk <= allregs.din.clk;
   end if;
end process;

--
-- clock domain: tx_clk,rst (edit)
--
process (allnets.tx_clk, allnets.rst.tx_clk)
begin
   if (allnets.rst.tx_clk = '1') then
      allregs.dout.tx_clk <= reglist_tx_clk_default;
   elsif rising_edge(allnets.tx_clk) then
      allregs.dout.tx_clk <= allregs.din.tx_clk;
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
-- Reset signals (all clock domains, async asserted, sync deasserted)
--
procedure SubReset
(
   variable i : in inputs_t;
   variable ri: in reglist_t;
   variable ro: in reglist_t;
   variable o : inout outputs_t;
   variable r : inout reglist_t;
   variable n : inout netlist_t
) is
begin

   -- 
   -- Internal clocks generated by sgmii interface
   --
   n.tx_clk := n.sgmii.outputs.tx_clk;
   n.rx_clk := n.sgmii.outputs.rx_clk;
   -- note: 'common tx/rx clock domain' corresponds to 'tx_clk' = 'ref_clk'
 
   --
   -- Internal resets generated by reset synchronizer (async asserted, sync deasserted)
   --

   --
   -- level 1 (max priority: deasserted first)
   --
   
   -- clock domain tx_clk
   n.syncrst.inputs.clk(1) := n.tx_clk;
   n.syncrst.inputs.clr(1) := i.rst;
   n.rst.tx_clk := n.syncrst.outputs.rst(1);
   
   --
   -- level 2 (min priority: deasserted last)
   --

   -- clock domain tx_clk_negedge
   n.syncrst.inputs.clk(2) := not n.tx_clk; -- for tx_clk negedge registers (rgmii)
   n.syncrst.inputs.clr(2) := n.rst.tx_clk;
   n.rst.tx_clk_negedge := n.SyncRST.outputs.rst(2);

   -- clock domain rx_clk
   n.syncrst.inputs.clk(3) := n.rx_clk; 
   n.syncrst.inputs.clr(3) := n.rst.tx_clk;
   n.rst.rx_clk := n.syncrst.outputs.rst(3);

   -- clock domain rx_clk_negedge
   n.syncrst.inputs.clk(4) := not n.rx_clk; -- for rx_clk negedge registers (rgmii)
   n.syncrst.inputs.clr(4) := n.rst.tx_clk;
   n.rst.rx_clk_negedge := n.syncrst.outputs.rst(4);

   -- clock domain clk
   n.syncrst.inputs.clk(5) := i.clk;
   n.syncrst.inputs.clr(5) := n.rst.tx_clk;
   n.rst.clk := n.syncrst.outputs.rst(5);

   -- unused section
   n.syncrst.inputs.clk(6) := '0';
   n.syncrst.inputs.clr(6) := n.rst.tx_clk;
   -- n.rst.RRRRR := n.syncrst.outputs.rst(6);

   -- unused section
   n.syncrst.inputs.clk(7) := '0';
   n.syncrst.inputs.clr(7) := n.rst.tx_clk;
   -- n.rst.RRRRR := n.syncrst.outputs.rst(7);

   -- unused section
   n.syncrst.inputs.clk(8) := '0';
   n.syncrst.inputs.clr(8) := n.rst.tx_clk;
   -- n.rst.RRRRR := n.syncrst.outputs.rst(8);

   -- sgmii defaults
   n.sgmii.inputs.ref_clk   := i.ref_clk;
   -- note: 'ref_clk' is the main 125MHz clock (sgmii generates 'tx_clk,rx_clk' from ref_clk)
   n.sgmii.inputs.address   := "00000";
   n.sgmii.inputs.read      := '0';
   n.sgmii.inputs.writedata := (others => '0');
   n.sgmii.inputs.write     := '0';
   n.sgmii.inputs.clk       := i.clk;
   -- note: sgmii AVALON-MM interface not used (but 'clk' signal must be connected)

   -- sgmii resets
   n.sgmii.inputs.reset := i.rst; -- note: sgmii accepts async reset
   n.sgmii.inputs.reset_tx_clk := n.rst.tx_clk;
   --n.sgmii.inputs.reset_rx_clk := n.rst.rx_clk; 
   n.sgmii.inputs.reset_rx_clk := n.rst.tx_clk;
   -- !! NOTE: sgmii 'rx_clk output' is blocked until reset_rx_clk removed --> we use rst.tx_clk for both reset inputs
   -- !! NOTE: sgmii 'tx_clk output' = 'ref_clk input', sgmii registers using reset_rx_clk are clocked by ref_clk 
   -- !!!...rx_clk non e' uguale a ref_clk ma i due clock sono in fase e tutti i registri
   -- !!!...che usano reset_rx_clk utilizzano direttamente ref_clk...da ricontrollare!!!

end procedure;


--
-- Main combinatorial procedure (edit)
--
-- all clock domains
--
procedure SubMain
(
   variable i : in inputs_t;
   variable ri: in reglist_t;
   variable ro: in reglist_t;
   variable o : inout outputs_t;
   variable r : inout reglist_t;
   variable n : inout netlist_t
) is
begin

   --
   -- MAC interface
   --

   -- Avalon-MM clock,reset 
   n.mac.inputs.clk := i.clk;
   n.mac.inputs.reset_clk := n.rst.clk;

   -- common tx/rx_clock domain
   n.mac.inputs.tx_clk := n.tx_clk;
   n.mac.inputs.reset_tx_clk := n.rst.tx_clk;
   -- note: tx_clk is the main 'common tx/rx clock domain' --> gmii tx interface
   -- is clocked by tx_clk (sgmii 'tx_clk output')
   -- note1: sgmii 'tx_clk output' = 'ref_clk input' (ref_clk,tx_clk are the same clock signal)

   -- gmii rx clock domain
   n.mac.inputs.rx_clk := n.rx_clk;
   n.mac.inputs.reset_rx_clk := n.rst.rx_clk;
   -- note: gmii rx interface is clocked by dedicated rx_clk (sgmii 'rx_clk output')  

   --
   -- Inputs
   --

   -- RegFile interface (Avalon-MM slave)
   n.mac.inputs.mmaddress   := i.mmaddress(3 downto 0);
   n.mac.inputs.mmread      := i.mmread;
   n.mac.inputs.mmwrite     := i.mmwrite;
   n.mac.inputs.mmwritedata := i.mmwritedata(31 downto 0);
   
   -- node params (quasi-static params, assumed synchronized to ref_clk)
   n.mac.inputs.nodeaddr      := i.nodeaddr(7 downto 0);
   n.mac.inputs.multicastaddr := i.multicastaddr(7 downto 0);
   
   -- write interface: TX_NPORTS clock domains
   n.mac.inputs.wclk := i.wclk(1 to txport1_NPORTS);
   n.mac.inputs.wrst := i.wrst(1 to txport1_NPORTS);

   -- write interface inputs (clock domain wclk(),wrst()) 
   n.mac.inputs.wena       := i.wena(1 to txport1_NPORTS);               
   n.mac.inputs.wreq       := i.wreq(1 to txport1_NPORTS);               
   n.mac.inputs.wdata      := i.wdata(1 to txport1_NPORTS);        
   n.mac.inputs.wframelen  := i.wframelen(1 to txport1_NPORTS);
   n.mac.inputs.wdestport  := i.wdestport(1 to txport1_NPORTS); 
   n.mac.inputs.wdestaddr  := i.wdestaddr(1 to txport1_NPORTS);
   n.mac.inputs.wmulticast := i.wmulticast(1 to txport1_NPORTS);
   n.mac.inputs.wtxreq     := i.wtxreq(1 to txport1_NPORTS);   
   n.mac.inputs.wtxclr     := i.wtxclr(1 to txport1_NPORTS);        

   -- read interface: RX_NPORTS clock domains
   n.mac.inputs.rclk := i.rclk(1 to rxport1_NPORTS);
   n.mac.inputs.rrst := i.rrst(1 to rxport1_NPORTS);

   -- read interface inputs (clock domain rclk(),rrst()) 
   n.mac.inputs.rena := i.rena(1 to rxport1_NPORTS);
   n.mac.inputs.rreq := i.rreq(1 to rxport1_NPORTS);
   n.mac.inputs.rack := i.rack(1 to rxport1_NPORTS);

   -- CPU interface
   n.mac.inputs.CPUtxport := i.CPUtxport;
   n.mac.inputs.CPUrxport := i.CPUrxport;

   --
   -- Outputs
   --

   -- RegFile interface (Avalon-MM slave)
   o.mmreaddata := n.mac.outputs.mmreaddata(31 downto 0);
   o.mmreaddatavalid := n.mac.outputs.mmreaddatavalid;
   o.mmwaitrequest := n.mac.outputs.mmwaitrequest;

   -- write interface outputs (clock domain wclk(),wrst()) 
   o.wready := n.mac.outputs.wready(1 to txport1_NPORTS);
   o.wempty := n.mac.outputs.wempty(1 to txport1_NPORTS); 
   o.wfull := n.mac.outputs.wfull(1 to txport1_NPORTS); 
   o.werror := n.mac.outputs.werror(1 to txport1_NPORTS);
   o.wdatalen := n.mac.outputs.wdatalen(1 to txport1_NPORTS);
   o.wframes := n.mac.outputs.wframes(1 to txport1_NPORTS);

   -- read interface outputs (clock domain rclk(),rrst()) 
   o.renasts := n.mac.outputs.renasts(1 to rxport1_NPORTS);
   o.rdata := n.mac.outputs.rdata(1 to rxport1_NPORTS);
   o.rready := n.mac.outputs.rready(1 to rxport1_NPORTS);
   o.rempty := n.mac.outputs.rempty(1 to rxport1_NPORTS); 
   o.rfull := n.mac.outputs.rfull(1 to rxport1_NPORTS);
   o.rframes := n.mac.outputs.rframes(1 to rxport1_NPORTS);
   o.rsrcaddr := n.mac.outputs.rsrcaddr(1 to rxport1_NPORTS);
   o.rsrcport := n.mac.outputs.rsrcport(1 to rxport1_NPORTS);
   o.rdatalen := n.mac.outputs.rdatalen(1 to rxport1_NPORTS);
   o.rdatacnt := n.mac.outputs.rdatacnt(1 to rxport1_NPORTS);
   o.rseqnum  := n.mac.outputs.rseqnum(1 to rxport1_NPORTS);
   o.reoframe := n.mac.outputs.reoframe(1 to rxport1_NPORTS);
   --
   o.rerrfull := n.mac.outputs.rerrfull(1 to rxport1_NPORTS); 
   o.rerrempty := n.mac.outputs.rerrempty(1 to rxport1_NPORTS);

   --
   -- SGMII tx interface
   --

   -- sgmii inputs (gmii interface)
   n.sgmii.inputs.gmii_tx_en  := n.mac.outputs.gtx_en;
   n.sgmii.inputs.gmii_tx_err := n.mac.outputs.gtx_er;
   n.sgmii.inputs.gmii_tx_d   := n.mac.outputs.gtxd(7 downto 0);

   -- sgmii outputs (tx interface)
   o.txp := n.sgmii.outputs.txp;
   
   --
   -- SGMII rx interface
   --

   -- sgmii inputs (rx interface)
   n.sgmii.inputs.rxp := i.rxp;

   -- sgmii outputs (gmii interface)
   n.mac.inputs.grx_en := n.sgmii.outputs.gmii_rx_dv;
   n.mac.inputs.grx_er := n.sgmii.outputs.gmii_rx_err;
   n.mac.inputs.grxd   := n.sgmii.outputs.gmii_rx_d(7 downto 0);

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
   n.syncrst.outputs := allcmps.syncrst.outputs;
   n.sgmii.outputs := allcmps.sgmii.outputs;
   n.mac.outputs := allcmps.mac.outputs;

   --
   -- all procedures call (edit)
   --
   -- all clock domains
   SubReset(i, ri, ro, o, r, n);
   SubMain(i, ri, ro, o, r, n);
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
-- architecture rtl of mac_sgmii
--
--**************************************************************
