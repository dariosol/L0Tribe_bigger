--**************************************************************
--**************************************************************
--
-- Template file: comp_ck1.std
--
--**************************************************************
--**************************************************************
--
--
-- Component regfile1
-- 
-- Register file (Avalon slave interface) 
--
-- address : 4bit
-- data    : 32bit
-- memory space : 16 x 4 = 64 bytes
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

package component_regfile1 is

--
-- local typedefs (edit)
--
subtype regfile1_ctrlreg_t is std_logic_vector(31 downto 0);
type regfile1_ctrlvect_t is array(NATURAL RANGE <>) of regfile1_ctrlreg_t;

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- regfile1 inputs (edit)
--
type regfile1_inputs_t is record

   -- clock list
   clk1 : std_logic;

   -- reset list
   rst1 : std_logic;

   -- ctrlreg vector in
   rinvect : regfile1_ctrlvect_t(0 to 15);    

   -- Avalon interface
   mmaddress : std_logic_vector(3 downto 0);
   mmread : std_logic;
   mmwrite : std_logic;
   mmwritedata : std_logic_vector(31 downto 0);
   
end record;

--
-- regfile1 outputs (edit)
--
type regfile1_outputs_t is record

   -- ctrlreg vector out
   routvect : regfile1_ctrlvect_t(0 to 15);    
   routwrpulse : std_logic_vector(0 to 15);    

   -- Avalon interface
   mmreaddata : std_logic_vector(31 downto 0);
   mmreaddatavalid : std_logic;
   mmwaitrequest : std_logic;

   -- Avalon interface debug 
   dbg_address : std_logic_vector(3 downto 0);
   dbg_read : std_logic;
   dbg_write : std_logic;
   dbg_writedata : std_logic_vector(31 downto 0);

   dbg_readdata : std_logic_vector(31 downto 0);
   dbg_readdatavalid : std_logic;
   dbg_waitrequest : std_logic;
   --
   -- NOTE:  
   -- slave bus interface exported using dbg_ signals when component embedded 
   -- in a SOPC nios2 project
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
-- regfile1 component common interface (constant)
--
type regfile1_t is record
   inputs : regfile1_inputs_t;
   outputs : regfile1_outputs_t;
end record;

--
-- regfile1 component declaration (constant)
--
component regfile1
port (
   inputs : in regfile1_inputs_t;
   outputs : out regfile1_outputs_t
);
end component;

end component_regfile1;

--
-- regfile1 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_regfile1.all;

-- regfile1 entity (constant)
entity regfile1 is
port (
   inputs : in regfile1_inputs_t;
   outputs : out regfile1_outputs_t
);
end regfile1;

--**************************************************************
--**************************************************************

--**************************************************************
--
--
-- Component Architecture
--
--
--**************************************************************

architecture rtl of regfile1 is

--**************************************************************
--
-- Architecture declaration begin 
--
--**************************************************************

--
-- constants (edit)
--
constant REGFILESIZE : natural := outputs.routvect'length;

--
-- state machines (edit)
--
type FSMmmslave_t is (S0, S1, S2, S3);

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

   -- Avalon read/write FSM
   FSMmmslave : FSMmmslave_t;

   -- ctrlreg vector
   rvect : regfile1_ctrlvect_t(0 to REGFILESIZE - 1);

   -- write pulse vector
   wrpulse : std_logic_vector(0 to REGFILESIZE - 1);

   -- end of list
   eol : std_logic;

end record;
constant reglist1_default : reglist1_t :=
(
   FSMmmslave => S0,
   rvect => (others => (others => '0')),
   wrpulse => (others => '0'),
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
   a : std_logic;
   b : std_logic;
   dbg : std_logic_vector(8 downto 0); --unsigned(8 downto 0);
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
subtype inputs_t is regfile1_inputs_t;
subtype outputs_t is regfile1_outputs_t;

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
-- architecture rtl of regfile1
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

--c1 : counter1 port map
--(
--   inputs => allnets.c1.inputs,
--   outputs => allnets.c1.outputs
--);

--**************************************************************
--
-- sequential logic
--
--
-- Notes: one record-type for each clock domain --> single clock version
--
--**************************************************************

--
-- clock domain: rst1,clk1 (edit)
--
process (inputs.clk1, inputs.rst1)
begin
   if (inputs.rst1 = '1') then
      allregs.dout.clk1 <= reglist1_default;
   elsif rising_edge(inputs.clk1) then
      allregs.dout.clk1 <= allregs.din.clk1;
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

process (inputs, allouts, allregs, allnets) -- [, allcmps)]

--**************************************************************
--
-- Combinatorial description begin
--
--**************************************************************

--
-- AVALON slave interface (edit)
--
-- 32bit interface
--
procedure SubAVALONslave
(
   variable i : in inputs_t;
   variable ri : in reglist1_t;
   variable ro : in reglist1_t;
   variable o : inout outputs_t;
   variable r : inout reglist1_t;
   variable s : inout netlist_t
) is
begin

   -- Regs defaults
   r.wrpulse := (others => '0');  -- write pulse deasserted

   -- Avalon defaults
   o.mmreaddatavalid := '0';      -- data valid deasserted
   o.mmwaitrequest := '0';        -- wait request deasserted

   case ro.FSMmmslave is
   when S0 =>
      --
      -- reset state
      --
      r.FSMmmslave := S1;

   when S1 =>
      --
      -- idle state
      --
      if i.mmread = '1' then

         -- read accepted, to read done
         o.mmwaitrequest := '0';
         r.FSMmmslave := S2;

      elsif i.mmwrite = '1' then

         -- wait-state, to write done
         o.mmwaitrequest := '1';
         r.FSMmmslave := S3;

      end if;

   when S2 =>
      --
      -- read done : readdatavalid generation + wait state until done
      --
      o.mmwaitrequest := '1';   -- wait state until read done
      o.mmreaddatavalid := '1'; -- current data is valid

      r.FSMmmslave:= S1;

   when S3 =>
      --
      -- write done : current write cycle accepted
      --
      o.mmwaitrequest := '0';

      -- write mux 
      r.rvect(UINT(i.mmaddress))   := i.mmwritedata(31 downto 0);
      r.wrpulse(UINT(i.mmaddress)) := '1';
      -- NOTE: (rvect,wrpulse) will change next clock cycle; 
      --       wrpulse width = 1 clock
      
      r.FSMmmslave := S1;

   end case;

   -- Avalon read mux (always ON)
   o.mmreaddata(31 downto 0) := i.rinvect(UINT(i.mmaddress));

   -- Avalon interface debug 
   o.dbg_address := i.mmaddress;
   o.dbg_read := i.mmread;
   o.dbg_write := i.mmwrite;
   o.dbg_writedata := i.mmwritedata;

   o.dbg_readdata := o.mmreaddata;
   o.dbg_readdatavalid := o.mmreaddatavalid;
   o.dbg_waitrequest := o.mmwaitrequest;

   -- ctrlreg vector outputs
   o.routvect := ro.rvect;
   o.routwrpulse := ro.wrpulse;
   
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
   --n.[instance_name].outputs := allcmps.[instance_name].outputs;

   --
   -- all procedures call (edit)
   --
   SubAVALONslave(i, ri, ro, o, r, n);

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
outputs <= allouts;

end rtl;
--**************************************************************
--
-- architecture rtl of regfile1
--
--**************************************************************
