--**************************************************************
--**************************************************************
--
-- Template file: comp_ck1.rec (new component, single clk)
--
--**************************************************************
--**************************************************************
--
--
-- Component rgmii1 
--
-- RGMII: Reduced Gigabit Media Independent Interface
-- GMII : Gigabit Media Independent Interface
--
-- Component connects RGMII (4bit datapath) to GMII (8bit datapath)
-- using altera megafunctions altddio_in/out.
-- Component includes encoding/decoding logic (xor) for control signals.
-- Output clock is generated by a toggling altddio output (zero skew 
-- between data and clock).
-- Note: current version uses rx/tx inverted clocks to gain additional setup/hold time
-- (external PHY working in RGMII standard mode without additional internal delay and
-- without PCB routing delay --> PHY RGMII-ID option not used).
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

package component_rgmii1 is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- rgmii1 inputs (edit)
--
type rgmii1_inputs_t is record
   
   -- Rx-interface: rgmii input (4bit, rxc dual edge) 
   rxc    : std_logic;
   rx_ctl : std_logic;
   rd     : std_logic_vector(3 downto 0);
   rxrst  : std_logic;
   --
   -- note: dual edge logic, rxrst should be async asserted, sync deasserted using rxc negedge
   --

   -- Tx-interface: gmii input (8bit, txc single edge)
   gtxc   : std_logic;
   gtx_en : std_logic;
   gtx_er : std_logic;
   gtxd   : std_logic_vector(7 downto 0);   
   txrst  : std_logic;
   --
   -- note: dual edge logic, txrst should be async asserted, sync deasserted using gtxc negedge
   --

end record;

--
-- rgmii1 outputs (edit)
--
type rgmii1_outputs_t is record

   -- Rx-interface: gmii output (8bit, rxc single edge)
   grxc   : std_logic;
   grx_dv : std_logic;
   grx_er : std_logic;
   grxd   : std_logic_vector(7 downto 0);   

   -- Tx-interface: rgmii output (4bit, txc dual edge) 
   txc    : std_logic;
   tx_ctl : std_logic;
   td     : std_logic_vector(3 downto 0);

end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- rgmii1 component common interface (constant)
--
type rgmii1_t is record
   inputs : rgmii1_inputs_t;
   outputs : rgmii1_outputs_t;
end record;

--
-- rgmii1 component declaration (constant)
--
component rgmii1
port (
   inputs : in rgmii1_inputs_t;
   outputs : out rgmii1_outputs_t
);
end component;

end component_rgmii1;

--
-- rgmii1 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_rgmii1.all;
use work.component_ddout1.all;
use work.component_ddin1.all;

-- rgmii1 entity (constant)
entity rgmii1 is
port (
   inputs : in rgmii1_inputs_t;
   outputs : out rgmii1_outputs_t
);
end rgmii1;

--**************************************************************
--**************************************************************

--**************************************************************
--
--
-- Component Architecture
--
--
--**************************************************************

architecture rtl of rgmii1 is

--**************************************************************
--
-- Architecture declaration begin 
--
--**************************************************************

--
-- local registers (edit)
--
--
-- Notes: one record-type for each clock domain --> single clock version
--

--
-- clock domain clk1
--
type reglist1_t is record

   -- end of list
   eol : std_logic;

end record;
constant reglist1_default : reglist1_t :=
(
   eol => '0'
);

--
-- all local registers (edit)
--
-- Notes: one record-element for each clock domain --> single clock version
--
type reglist_t is record
   clk1 : reglist1_t;
end record;

--
-- all local nets (edit)
--
type netlist_t is record
   --
   -- component interface signals (edit)
   --
   -- [instance_name] : [component_name]_t;
   --
   ddout : ddout1_t;
   ddin  : ddin1_t;
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
subtype inputs_t is rgmii1_inputs_t;
subtype outputs_t is rgmii1_outputs_t;

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
-- architecture rtl of rgmii1
--
--**************************************************************
begin

--**************************************************************
--
-- components instances (edit)
--
--**************************************************************

--[instance_name] : [component_name] port map
--(
--   inputs => allnets.[instance_name].inputs,
--   outputs => allcmps.[instance_name].outputs
--);

ddout : ddout1 port map
(
   inputs => allnets.ddout.inputs,
   outputs => allcmps.ddout.outputs
);

ddin : ddin1 port map
(
   inputs => allnets.ddin.inputs,
   outputs => allcmps.ddin.outputs
);

--**************************************************************
--
-- sequential logic
--
--
-- Notes: one record-type for each clock domain --> single clock version
--
--**************************************************************

----
---- clock domain: rst1,clk1 (edit)
----
--process (inputs.clk1, inputs.rst1)
--begin
--   if (inputs.rst1 = '1') then
--      allregs.dout.clk1 <= reglist1_default;
--   elsif rising_edge(inputs.clk1) then
--      allregs.dout.clk1 <= allregs.din.clk1;
--   end if;
--end process;

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
-- Rx-interface (edit)
--
procedure SubRGMIIrx
(
   variable i : in inputs_t;
   variable ri: in reglist1_t;
   variable ro: in reglist1_t;
   variable o : inout outputs_t;
   variable r : inout reglist1_t;
   variable n : inout netlist_t
) is
begin

   -- Rx-interface: rgmii input (4bit, rxc dual edge)
   n.ddin.inputs.aclr := i.rxrst; 
   n.ddin.inputs.datain(3 downto 0) := i.rd(3 downto 0);
   n.ddin.inputs.datain(4) := i.rx_ctl;
   n.ddin.inputs.inclock := not i.rxc;
   -- Note: input clock inverted to gain additional setup time
   -- (rx clock negedge latches 1st nibble, rx clock posedge latches 2nd nibble). 
   -- Marvell PHY generates rx output with Tskew = +/-0.5ns so we need
   -- an additional internal delay to guarantee sampling out of the uncertainty
   -- interval: using inverted clock and applying an input delay on all data/ctrl lines 
   -- (D1,D2,D3 input delay chains for Stratix IV), all 'ddin regs' will see
   -- setup/hold time intervals with good margin. 
   -- For example, applying an internal delay of 1.0ns typ, the new setup/hold 
   -- time intervals are:
   --
   -- setup = 4ns(Ttime) - 1.0ns(Tdly) - 0.5ns(Tskew) = 2.5ns typ 
   -- hold  = -0.5ns(Tskew) + 1.0ns(Tdly) = 0.5ns typ
   --
   -- Input delay chains can be assigned explicitly using the 'Assignment Editor'
   -- or creating a 'TimeQuest' tsu/th request to indicate the arrival time of 
   -- data/ctrl signals:
   --
   -- tsu = 4ns(Ttime) - 0.5ns(Tskew) - 0.5ns(slack) = 3.0ns  -->  max = 4 - 3.0 = 1.0ns
   -- th  = -0.5ns(Tskew) - 0.5ns(slack) = -1.0ns             -->  min = -1.0ns
   --
   -- (for safety, an additional slack of 0.5ns is included so the total skew interval is +/-1.0ns)    
   -- 
   -- The hold interval request is a negative value: this value takes in account
   -- the Marvell PHY output Tskew (fitter will adjust internal delay to sample data/ctrl
   -- lines out of the +/-1.0ns uncertainty region).  
   -- The setup interval is a positive value related to the maximum internal delay
   -- applicable.    

   -- Rx-interface: gmii output (8bit, rxc single edge)
   o.grxc := n.ddin.inputs.inclock;
   o.grx_dv := n.ddin.outputs.dataout_l(4);
   o.grx_er := n.ddin.outputs.dataout_l(4) xor n.ddin.outputs.dataout_h(4);
   o.grxd(3 downto 0) := n.ddin.outputs.dataout_l(3 downto 0);   
   o.grxd(7 downto 4) := n.ddin.outputs.dataout_h(3 downto 0);   

end procedure;

--
-- Tx-interface (edit)
--
procedure SubRGMIItx
(
   variable i : in inputs_t;
   variable ri: in reglist1_t;
   variable ro: in reglist1_t;
   variable o : inout outputs_t;
   variable r : inout reglist1_t;
   variable n : inout netlist_t
) is
begin

   -- Tx-interface: rgmii output (4bit, txc dual edge) 
   o.tx_ctl := n.ddout.outputs.dataout(4);
   o.td(3 downto 0) := n.ddout.outputs.dataout(3 downto 0);
   o.txc := n.ddout.outputs.dataout(5);
   -- note: output clock is generated by a toggling ddout output

   -- Tx-interface: gmii input (8bit, txc single edge)
   n.ddout.inputs.aclr := i.txrst;
   n.ddout.inputs.outclock := i.gtxc;
   n.ddout.inputs.datain_h(3 downto 0) := i.gtxd(3 downto 0);
   n.ddout.inputs.datain_l(3 downto 0) := i.gtxd(7 downto 4);
   n.ddout.inputs.datain_h(4) := i.gtx_en;
   n.ddout.inputs.datain_l(4) := i.gtx_en xor i.gtx_er;
   n.ddout.inputs.datain_h(5) := '0'; -- '1';
   n.ddout.inputs.datain_l(5) := '1'; -- '0';
   -- Note: output clock inverted (clock negedge generates 1st nibble, clock posedge generates 
   -- 2nd nibble) to gain additional setup time --> Marvell PHY needs tsu = 1.0ns min, th = 0.8ns min:   
   -- using inverted clock and applying the output maximum delay (D5(15) + D6(6) = 1ns for StratixIV) 
   -- to all data/ctrl lines, the new setup/hold time intervals are:
   --
   -- tsu = 4ns - 1ns = 3ns (slack typ = 3 - 1.0 = 2ns), th = 1ns (slack typ = 1 - 0.8 = 0.2ns)
   --
   -- Output delay chains must be assigned explicitly using the 'Assignment Editor':
   -- D5 Delay (output register to io buffer) --> 15 
   -- D6 Delay (output register to io buffer) --> 6
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
variable ri: reglist1_t;
variable ro: reglist1_t;
variable o : outputs_t;
variable r : reglist1_t;
variable n : netlist_t;
begin
   --
   -- clock domain clk1
   --
   -- read only variables
   i := inputs;
   ri := allregs.din.clk1;
   ro := allregs.dout.clk1;
   -- read/write variables
   o := allouts;
   r := allregs.dout.clk1;
   n := allnets;
   -- components outputs
   n.ddin.outputs := allcmps.ddin.outputs;
   n.ddout.outputs := allcmps.ddout.outputs;

   --
   -- all procedures call (edit)
   --
   SubRGMIItx(i, ri, ro, o, r, n);
   SubRGMIIrx(i, ri, ro, o, r, n);

   -- allouts/regs/nets updates
   allouts <= o;
   allregs.din.clk1 <= r;
   allnets <= n;

end process;

--**************************************************************
--**************************************************************

--
-- output connections (edit)
--

--
-- Direct assignment ('outputs' controlled by 'allouts' signal)
--
outputs <= allouts;

end rtl;
--**************************************************************
--
-- architecture rtl of rgmii1
--
--**************************************************************
