--**************************************************************
--**************************************************************
--
-- Template file: comp_ck1.std
--
--**************************************************************
--**************************************************************
--
--
-- Component regsync1
-- 
-- Register synchronizer (from wclk to rclk).
-- Synchronizer works as dual clock fifo with depth = 1:
-- write side controlled by wreq input --> write request delayed until 
-- fifo empty (in case of multiple write requests when fifo full,
-- last write request wins); 
-- read side always active --> automatic read when fifo full, output
-- pulse when update done.
--
-- data    : 32bit
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

package component_regsync1 is

--
-- local typedefs (edit)
--
subtype regsync1_ctrlreg_t is std_logic_vector(31 downto 0);

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- regsync1 inputs (edit)
--
type regsync1_inputs_t is record

   -- clock list
   rclk : std_logic;
   wclk : std_logic;    

   -- reset list
   rrst : std_logic;
   wrst : std_logic;    

   -- write request
   wreq : std_logic;    

   -- write data
   dreg : regsync1_ctrlreg_t;    

end record;

--
-- regsync1 outputs (edit)
--
type regsync1_outputs_t is record

   -- wfull flag
   wfull : std_logic;    

   -- read data
   qreg : regsync1_ctrlreg_t;    

   -- read pulse
   qupdate : std_logic;    

end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- regsync1 component common interface (constant)
--
type regsync1_t is record
   inputs : regsync1_inputs_t;
   outputs : regsync1_outputs_t;
end record;
type regsync1_vector_t is array(NATURAL range <>) of regsync1_t;

--
-- regsync1 component declaration (constant)
--
component regsync1
port (
   inputs : in regsync1_inputs_t;
   outputs : out regsync1_outputs_t
);
end component;

end component_regsync1;

--
-- regsync1 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_regsync1.all;

-- regsync1 entity (constant)
entity regsync1 is
port (
   inputs : in regsync1_inputs_t;
   outputs : out regsync1_outputs_t
);
end regsync1;

--**************************************************************
--**************************************************************

--**************************************************************
--
--
-- Component Architecture
--
--
--**************************************************************

architecture rtl of regsync1 is

--**************************************************************
--
-- Architecture declaration begin 
--
--**************************************************************

--
-- constants (edit)
--
constant REGSIZE : natural := outputs.qreg'length;

--
-- state machines (edit)
--
--type FSMmmslave_t is (S0, S1, S2, S3);

--
-- local registers (edit)
--
--
-- Notes: one record-type for each clock domain 
--

--
-- clock domain rclk
--
type reglist_rclk_t is record

   -- ctrlreg 
   creg : regsync1_ctrlreg_t;
   cregI : regsync1_ctrlreg_t;

   -- sync logic (from wclk to rclk)
   fwdI    : std_logic;
   fwdII   : std_logic;
   fwdIII  : std_logic;

   -- sync logic (from rclk to wclk)
   revedge : std_logic;

   -- read pulse
   qupdate : std_logic;

   -- end of list
   eol : std_logic;

end record;
constant reglist_rclk_default : reglist_rclk_t :=
(
   creg => (others => '0'),
   cregI => (others => '0'),

   fwdI => '0',
   fwdII => '0',   
   fwdIII => '0',   

   revedge => '0',   

   qupdate => '0',

   eol => '0'
);

--
-- clock domain wclk()
--
type reglist_wclk_t is record

   -- ctrlreg 
   creg : regsync1_ctrlreg_t;

   -- delayed write flag 
   wreqflag : std_logic;

   -- sync logic (from wclk to rclk)
   fwdedge : std_logic;

   -- sync logic (from rclk to wclk)
   revI    : std_logic;
   revII   : std_logic;

   -- end of list
   eol : std_logic;

end record;
constant reglist_wclk_default : reglist_wclk_t :=
(
   creg => (others => '0'),

   wreqflag => '0',

   fwdedge => '0',
   
   revI    => '0',
   revII   => '0',   

   eol => '0'
);

--
-- all local registers (edit)
--
-- Notes: one record-element for each clock domain 
--
type reglist_t is record
   rclk : reglist_rclk_t;
   wclk : reglist_wclk_t;
end record;

--
-- all local nets (edit)
--
type netlist_t is record
   dbg_a : std_logic;
   dbg_b : std_logic;
   --
   -- component interface signals (edit)
   --
   -- [instance_name] : [component_name]_t;
   --
   --c1 : counter1_t;
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
subtype inputs_t is regsync1_inputs_t;
subtype outputs_t is regsync1_outputs_t;

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
-- architecture rtl of regsync1
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
-- clock domain: rclk,rrst (edit)
--
process (inputs.rclk, inputs.rrst)
begin
   if (inputs.rrst = '1') then
      allregs.dout.rclk <= reglist_rclk_default;
   elsif rising_edge(inputs.rclk) then
      allregs.dout.rclk <= allregs.din.rclk;
   end if;
end process;

--
-- clock domain: wclk,wrst (edit)
--
process (inputs.wclk, inputs.wrst)
begin
   if (inputs.wrst = '1') then
      allregs.dout.wclk <= reglist_wclk_default;
   elsif rising_edge(inputs.wclk) then
      allregs.dout.wclk <= allregs.din.wclk;
   end if;
end process;

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
-- Combinatorial description begin
--
--**************************************************************

--
-- Main
--
-- all clock domains
--
procedure SubMain
(
   variable i : in inputs_t;
   variable ri : in reglist_t;
   variable ro : in reglist_t;
   variable o : inout outputs_t;
   variable r : inout reglist_t;
   variable s : inout netlist_t
) is
begin

   --
   -- write logic (from wclk to rclk)
   --
   if ro.wclk.fwdedge = ro.wclk.revII then
      -- level match, fifo empty 
      if (i.wreq = '1' or ro.wclk.wreqflag = '1') then
         -- write request: reg update (wclk)
         r.wclk.creg := i.dreg;
         -- fwdedge starts
         r.wclk.fwdedge := not ro.wclk.fwdedge;
         -- clear delayed write flag
         r.wclk.wreqflag := '0';
      end if;
   else
      -- fifo full, write in progress
      if (i.wreq = '1') then
         -- write request when full: delayed write flag ON
         r.wclk.wreqflag := '1';     
      end if;
   end if;

   -- crossing clocks (fwd)
   r.rclk.fwdI := ro.wclk.fwdedge;
   r.rclk.fwdII := ro.rclk.fwdI; 
   r.rclk.fwdIII := ro.rclk.fwdII; 
   r.rclk.revedge := ro.rclk.fwdIII; 

   r.rclk.cregI := ro.wclk.creg;

   --
   -- read logic (from rclk to wclk)
   --
   r.rclk.qupdate := '0';
   if ro.rclk.fwdIII /= ro.rclk.revedge then
      -- new level received: reg update
      r.rclk.creg := ro.rclk.cregI;
      -- read pulse 
      r.rclk.qupdate := '1';
   else
      null;
   end if;

   -- crossing clocks (rev)
   r.wclk.revI  := ro.rclk.revedge;
   r.wclk.revII := ro.wclk.revI; 

   -- outputs
   o.wfull := '0';
   if (ro.wclk.fwdedge /= ro.wclk.revII) then
      o.wfull := '1';
   end if;
   o.qreg := ro.rclk.creg;   
   o.qupdate := ro.rclk.qupdate;

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
   SubMain(i, ri, ro, o, r, n);

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
-- architecture rtl of regsync1
--
--**************************************************************
