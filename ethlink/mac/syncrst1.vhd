--**************************************************************
--**************************************************************
--
-- Template file: comp_ck2.rec (new component, dual/multi clk)
--
--**************************************************************
--**************************************************************
--
--
-- Component syncrst1
--
--
-- Reset generator: async reset input, sync reset output
-- (reset async asserted, sync deasserted)
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package component_syncrst1 is

constant syncrst1_SIZE : natural := 8;

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- syncrst1 inputs (edit)
--
type syncrst1_inputs_t is record

   -- clock list
   clk : std_logic_vector(1 to syncrst1_SIZE);

   -- reset list
   clr : std_logic_vector(1 to syncrst1_SIZE);
  
end record;

--
-- syncrst1 outputs (edit)
--
type syncrst1_outputs_t is record

   -- output list
   rst : std_logic_vector(1 to syncrst1_SIZE);

end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- syncrst1 component common interface (constant)
--
type syncrst1_t is record
   inputs : syncrst1_inputs_t;
   outputs : syncrst1_outputs_t;
end record;

--
-- syncrst1 component declaration (constant)
--
component syncrst1
port (
   inputs : in syncrst1_inputs_t;
   outputs : out syncrst1_outputs_t
);
end component;

end component_syncrst1;

--
-- syncrst1 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_syncrst1.all;

-- syncrst1 entity (constant)
entity syncrst1 is
port (
   inputs : in syncrst1_inputs_t;
   outputs : out syncrst1_outputs_t
);
end syncrst1;

--**************************************************************
--**************************************************************

--**************************************************************
--
--
-- Component Architecture
--
--
--**************************************************************

architecture rtl of syncrst1 is

--**************************************************************
--
-- Architecture declaration begin 
--
--**************************************************************

--
-- state machines (edit)
--
--type FSMmain_t is (S0, S1, S2, S3);

--
-- local registers (edit)
--
--
-- Notes: one record-type for each clock domain
--

--
-- clock domain: clk
--
type reglist_clk_t is record

   -- reset synchronizer
   rstI : std_logic;
   rst : std_logic;

   -- end of list
   eol : std_logic;

end record;
constant reglist_clk_default : reglist_clk_t :=
(
   rstI => '1',
   rst => '1',
   eol => '0'
);
type reglist_clk_vector_t is array(NATURAL RANGE <>) of reglist_clk_t;

--
-- all local registers (edit)
--
-- Notes: one record-element for each clock domain
--
type reglist_t is record
   clk : reglist_clk_vector_t(1 to syncrst1_SIZE); -- clk array
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
   --c1 : counter1_t;

   -- end of list
   eol : std_logic;

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
subtype inputs_t is syncrst1_inputs_t;
subtype outputs_t is syncrst1_outputs_t;

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
--[signal allcmps : netlist_t;]

--
-- outputs driver (internal signal for read access) (constant)
--
signal allouts : outputs_t;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- architecture rtl of syncrst1
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

--**************************************************************
--
-- sequential logic
--
--
-- Notes: one record-type for each clock domain
--
--**************************************************************

--
-- clock domain: clk,clr (edit)
--
process_clk : FOR i IN inputs.clk'range GENERATE

process (inputs.clk(i), inputs.clr(i))
begin
   if (inputs.clr(i) = '1') then
      allregs.dout.clk(i) <= reglist_clk_default;
   elsif rising_edge(inputs.clk(i)) then
      allregs.dout.clk(i) <= allregs.din.clk(i);
   end if;
end process;

END GENERATE;

--**************************************************************
--
-- combinatorial logic
--
--
-- Notes: single process with combinatorial procedures
--
--**************************************************************

process (inputs, allouts, allregs, allnets) --[, allcmps)]

--**************************************************************
--
-- combinatorial description begin
--
--**************************************************************

--
-- Reset signals (all clock domains, async asserted, sync deasserted) (edit)
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

FOR index IN 1 TO syncrst1_SIZE LOOP

   -- clock domain: clk,clr 
   r.clk(index).rstI := '0';
   r.clk(index).rst  := ro.clk(index).rstI;   

   -- outputs
   o.rst(index) := ro.clk(index).rst;

END LOOP;

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

   -- all clock domains
   SubReset(i, ri, ro, o, r, n);

   -- allouts/regs/nets updates
   allouts <= o;
   allregs.din <= r;
   allnets <= n;

end process;

--**************************************************************
--**************************************************************

--
-- output connections (constant)
--
outputs <= allouts;

end rtl;
--**************************************************************
--
-- architecture rtl of syncrst1
--
--**************************************************************
