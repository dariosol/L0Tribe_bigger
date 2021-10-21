--**************************************************************
--**************************************************************
--
-- Template file: comp_ck1.rec (new component, single clk)
--
--**************************************************************
--**************************************************************
--
--
-- Component crc32
--
-- IEEE 802.3 Frame check sequence (FCS) field calculation using crc32
--
-- polynomial: (0 1 2 4 5 7 8 10 11 12 16 22 23 26 32) --> POLY = 0xEDB88320     
-- data width: 8
-- convention: the first serial bit is d(0), crc msb is crc(0)
-- crc_poly  : 0xEDB88320
-- crc_init  : 0xFFFFFFFF
-- crc_check : 0x2144DF1C
-- crc_output: complemented 
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

package component_crc32 is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- crc32 inputs (edit)
--
type crc32_inputs_t is record

   -- clock list
   clk1 : std_logic;

   -- reset list
   rst1 : std_logic;
   
   -- input list
   datavalid : std_logic;
   data : std_logic_vector(7 downto 0);
   init : std_logic;

end record;

--
-- crc32 outputs (edit)
--
type crc32_outputs_t is record

   -- output list
   fcs : std_logic_vector(31 downto 0);
   fcserr : std_logic;
 
end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- crc32 component common interface (constant)
--
type crc32_t is record
   inputs : crc32_inputs_t;
   outputs : crc32_outputs_t;
end record;

--
-- crc32 component declaration (constant)
--
component crc32
port (
   inputs : in crc32_inputs_t;
   outputs : out crc32_outputs_t
);
end component;

end component_crc32;

--
-- crc32 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_crc32.all;
use work.pkg_crc32_d8.all;

-- crc32 entity (constant)
entity crc32 is
port (
   inputs : in crc32_inputs_t;
   outputs : out crc32_outputs_t
);
end crc32;

--**************************************************************
--**************************************************************

--**************************************************************
--
--
-- Component Architecture
--
--
--**************************************************************

architecture rtl of crc32 is

--**************************************************************
--
-- Architecture declaration begin 
--
--**************************************************************

--
-- local constants (edit)
--
constant CRC_INIT : std_logic_vector(31 downto 0) := x"FFFFFFFF";
constant CRC_POLY : std_logic_vector(31 downto 0) := x"EDB88320";
constant CRC_TEST : std_logic_vector(31 downto 0) := x"2144DF1C";

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

   -- register list
   crc : std_logic_vector(31 downto 0);
   crcreq : std_logic;   
   crcdata : std_logic_vector(7 downto 0);

   -- debug
   reg_clk1 : std_logic;

end record;
constant reglist1_default : reglist1_t :=
(
   crc => (others => '0'),
   crcreq => '0',
   crcdata => (others => '0'),
   reg_clk1 => '1'
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

   -- debug
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
signal dbg : std_logic_vector(8 downto 0); --unsigned(8 downto 0);

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
subtype inputs_t is crc32_inputs_t;
subtype outputs_t is crc32_outputs_t;

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
-- architecture rtl of crc32
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
-- Notes: single process with combinatorial procedures.
--
--**************************************************************

process (inputs, allouts, allregs, allnets) -- [, allcmps)]

--**************************************************************
--
-- Combinatorial description begin
--
--**************************************************************

--
-- FCS combinatorial procedure (edit)
--
procedure SubFCS
(
   variable i : in inputs_t;
   variable ri: in reglist1_t;
   variable ro: in reglist1_t;
   variable o : inout outputs_t;
   variable r : inout reglist1_t;
   variable n : inout netlist_t
) is
begin

-- registered version (note: 2 clock latency)
--   -- crc control
--   r.crcreq := '0';
--   r.crcdata := i.data;   
--   if i.init = '1' then
--      -- crc init
--      r.crc := CRC_INIT;
--   elsif i.datavalid = '1' then
--      -- crc calculation request (note: 1 clock latency)
--      r.crcreq := '1';
--   else
--      null;
--   end if;      
--
--   -- crc calculation
--   if ro.crcreq = '1' then
--      r.crc := nextCRC32_D8(ro.crcdata, ro.crc);      
--   end if;
--
--   -- output FCS complemented
--   o.fcs := not(ro.crc);
-- registered version (note: 2 clock latency)

-- unregisterd version (note: zero latency) 
   -- crc control
   if i.init = '1' then
      -- crc init
      r.crc := CRC_INIT;
   elsif i.datavalid = '1' then
      -- crc calculation 
      r.crc := nextCRC32_D8(i.data, ro.crc);
   else
      null;
   end if;      

   -- output FCS complemented
   o.fcs := not(r.crc);
-- unregisterd version (note: zero latency)

   -- FCS error test
   o.fcserr := '0';
   if o.fcs /= CRC_TEST then
      o.fcserr := '1';
   end if;

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
   SubFCS(i, ri, ro, o, r, n);

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
-- architecture rtl of crc32
--
--**************************************************************
