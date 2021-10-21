--**************************************************************
--**************************************************************
--
-- Template file: comp_ck1.rec (new component, single clk)
--
--**************************************************************
--**************************************************************
--
--
-- Component scfiforeg1
--
--
-- - Register-based single clock FIFO, show-ahead mode,
--   width = 8bit, depth = 3word
-- - FIFO write+read operations with minimum latency
--   (full-condition immediately removed when rdreq asserted) 
-- - component description assumes all inputs registered
--   (combinatorial path between rdreq-input/full-output signals,
--   component must be connected to registered core logic)
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

package component_scfiforeg1 is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- scfiforeg1 inputs (edit)
--
type scfiforeg1_inputs_t is record

   -- input list
   aclr : STD_LOGIC;
   clock : STD_LOGIC;
   data : STD_LOGIC_VECTOR (7 DOWNTO 0);
   rdreq : STD_LOGIC;
   sclr : STD_LOGIC;
   wrreq : STD_LOGIC;

end record;

--
-- scfiforeg1 outputs (edit)
--
type scfiforeg1_outputs_t is record

   -- output list
   empty : STD_LOGIC;
   full : STD_LOGIC;
   q : STD_LOGIC_VECTOR (7 DOWNTO 0);

end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- scfiforeg1 component common interface (constant)
--
type scfiforeg1_t is record
   inputs : scfiforeg1_inputs_t;
   outputs : scfiforeg1_outputs_t;
end record;

--
-- scfiforeg1 vector type (constant)
--
type scfiforeg1_vector_t is array(NATURAL RANGE <>) of scfiforeg1_t;

--
-- scfiforeg1 component declaration (constant)
--
component scfiforeg1
port (
   inputs : in scfiforeg1_inputs_t;
   outputs : out scfiforeg1_outputs_t
);
end component;

--
-- scfiforeg1() global signal to export range/width params (constant)
--
signal component_scfiforeg1 : scfiforeg1_t;

end component_scfiforeg1;

--
-- scfiforeg1 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
--
-- use work.component_[name].all;
--
use work.component_scfiforeg1.all;

-- scfiforeg1 entity (constant)
entity scfiforeg1 is
port (
   inputs : in scfiforeg1_inputs_t;
   outputs : out scfiforeg1_outputs_t
);
end scfiforeg1;

--**************************************************************
--**************************************************************

--**************************************************************
--
--
-- Component Architecture
--
--
--**************************************************************

architecture rtl of scfiforeg1 is

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
--type FSMmain_t is (S0, S1, S2, S3);

--
-- local registers (edit)
--
--
-- Notes: one record-type for each clock domain
--

--
-- clock domain: clock
--
type reglist_clock_t is record

   -- FSM list
   -- [FSMname] : [FSMname]_t;
   
   fifofull : std_logic_vector(1 downto 0);
   fiforegI : std_logic_vector(7 downto 0);
   fiforegII : std_logic_vector(7 downto 0);
   fiforegIII : std_logic_vector(7 downto 0);

   -- end of list
   eol : std_logic;

end record;
constant reglist_clock_default : reglist_clock_t :=
(
   fifofull => "00",
   fiforegI => (others => '0'),
   fiforegII => (others => '0'),
   fiforegIII => (others => '0'),

   eol => '0'
);

--
-- all local registers (edit)
--
-- Notes: one record-element for each clock domain
--
type reglist_t is record
   clock : reglist_clock_t;
end record;

--
-- all local nets (edit)
--
type netlist_t is record

   fifo_clr : std_logic;
   fifo_rdreq : std_logic;
   fifo_wrreq : std_logic;
   fifo_empty : std_logic;
   fifo_full : std_logic;
   --
   -- component interface signals (edit)
   --
   -- [instance_name] : [component_name]_t;
   -- [instance_name] : [component_name]_vector_t([instance_range]);
   --
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
subtype inputs_t is scfiforeg1_inputs_t;
subtype outputs_t is scfiforeg1_outputs_t;

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
-- architecture rtl of scfiforeg1
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
-- clock domain: clock,aclr (edit)
--
process (inputs.clock, inputs.aclr)
begin
   if (inputs.aclr = '1') then
      allregs.dout.clock <= reglist_clock_default;
   elsif rising_edge(inputs.clock) then
      allregs.dout.clock <= allregs.din.clock;
   end if;
end process;

--**************************************************************
--
-- combinatorial logic
--
--
-- Notes: single process with combinatorial procedures.
--
-- All combinatorial logic is controlled by one single vhdl process:
-- this process receives events from inputs/allregs/allnets/allouts 
-- signals, maps all signals to variables and calls procedures with
-- single and/or multi clock domain.
--
-- All procedures receive data from (i,ri,ro) read-only variables and
-- (r,n,o) inout-variables; procedures write new data to (r,n,o) inout-variables.
-- Inout-variables propagates through all combinatorial procedures and
-- generate new final signals (in case of multi-assignment, max
-- priority is associated to last called procedure).
-- When combinatorial process ends with any signal transition, execution continues 
-- with multi-delta-zero cycles until all signals receive new correct values
-- (VHDL execution semantic).     
--
-- Procedures SHOULD read initial variables values from read-only
-- params (in this way read values are independent from procedure-call-order).
--
-- When 'n','o' variables are controlled only by a single procedure then read 
-- operation can be done using inout params directly (with true combinatorial
-- subs and with single signal driver, read operations are completly independent
-- from procedure-call-order: when procedures read inout params before the 
-- driver's assignment, program execution continues with multi-delta-zero cycles 
-- until all signals receive new correct values; 'n','o' variables work as true 
-- netlist connections between procedures).
-- When the same variable is assigned in more procedures, the last procedure
-- call takes max priority (in this case side effects may appear because 
-- others subs can process a temporary value not equal to the final 
-- correct data).
--
-- Warning: in case of read operations using inout-reg-vars instead of 
-- read-only-reg-vars then 'r' equals to 'ro' before driver's assignment 
-- and equals to 'ri' after assignment (in general, expression like 
-- 'r.NNNN := func(r.NNNN)' works as expected when single-assignment).    
--
-- Warning: procedures can describe TRUE netlists using inout params   
-- (async latch loops can be generated). In general, register must be used 
-- to cut all feedback loops; procedures driving a signal should not read 
-- the same signal.
--
--**************************************************************

process (inputs, allouts, allregs, allnets) -- [, allcmps)]

--**************************************************************
--
-- Combinatorial description begin
--
--**************************************************************

--
-- FIFO combinatorial procedure (edit)
--
-- clock domain: clock
--
procedure SubFifo
(
   variable i : in inputs_t;
   variable ri: in reglist_clock_t;
   variable ro: in reglist_clock_t;
   variable o : inout outputs_t;
   variable r : inout reglist_clock_t;
   variable n : inout netlist_t
) is
begin

   --
   -- inputs
   --
   n.fifo_clr    := i.sclr;
   n.fifo_rdreq  := i.rdreq;
   n.fifo_wrreq  := i.wrreq;

   --
   -- outputs
   --
   o.q      := ro.fiforegI;
   o.empty  := n.fifo_empty;
   o.full   := n.fifo_full;

   --
   -- fifo FSM (fifo depth = 3, showahead mode)
   --
   if ro.fifofull = "00" then
      -- fifo empty (note: fifo output is regI) 
      if n.fifo_wrreq = '1' then
         -- write regI
         r.fiforegI := i.data;
         r.fifofull := "01";
      end if;
      --
      n.fifo_empty := '1';
      n.fifo_full  := '0';
      --
   elsif ro.fifofull = "01" then
      -- fifo not empty (regI valid)
      if n.fifo_wrreq = '1' and n.fifo_rdreq = '0' then
         -- write regII
         r.fiforegII := i.data;
         r.fifofull := "10";
      elsif n.fifo_wrreq = '1' and n.fifo_rdreq = '1' then
         -- write+read regI 
         r.fiforegI := i.data;
         r.fifofull := "01";
      elsif n.fifo_wrreq = '0' and n.fifo_rdreq = '1' then
         -- read regI
         r.fifofull := "00";
      else
         -- nop
         null;
      end if;
      --
      n.fifo_empty := '0';
      n.fifo_full  := '0';
      --
   elsif ro.fifofull = "10" then
      -- fifo not empty (regII,regI valid)
      if n.fifo_wrreq = '1' and n.fifo_rdreq = '0' then
         -- write regIII
         r.fiforegIII := i.data;
         r.fifofull := "11";
      elsif n.fifo_wrreq = '1' and n.fifo_rdreq = '1' then 
         -- write+read+shift regII
         r.fiforegI := ro.fiforegII; 
         r.fiforegII := i.data;
         r.fifofull := "10";
      elsif n.fifo_wrreq = '0' and n.fifo_rdreq = '1' then
         -- read+shift regI
         r.fiforegI := ro.fiforegII; 
         r.fifofull := "01";
      else
         -- nop
         null;
      end if;
      --
      n.fifo_empty := '0';
      n.fifo_full  := '0';
      --
   else 
      -- fifo full
      if n.fifo_wrreq = '1' and n.fifo_rdreq = '0' then
         -- all regs full, write stops
         null;
      elsif n.fifo_wrreq = '1' and n.fifo_rdreq = '1' then 
         -- all regs full, write+read+shift 
         r.fiforegI := ro.fiforegII; 
         r.fiforegII := ro.fiforegIII; 
         r.fiforegIII := i.data;
         r.fifofull := "11";
      elsif n.fifo_wrreq = '0' and n.fifo_rdreq = '1' then
         -- all regs full, read+shift
         r.fiforegI := ro.fiforegII; 
         r.fiforegII := ro.fiforegIII; 
         r.fifofull := "10";
      else
         -- nop
         null;
      end if;
      --
      n.fifo_empty := '0';
      n.fifo_full  := '1';
      if n.fifo_rdreq = '1' then
         n.fifo_full  := '0';
         -- note: fifo_full deasserted when fifo_rdreq --> fifo_wrreq always allowed (write+read+shift op)   
      end if;
      --
   end if;

   -- synchronous clear (always ON, max priority)
   if n.fifo_clr = '1' then
      -- fifo cleared (max priority)
      r.fifofull := "00";
      -- note: fifo registers unchanged
   else
      -- fifo ON
      null;
   end if;

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
   --n.[instance_name].outputs := allcmps.[instance_name].outputs;

   --
   -- all procedures call (edit)
   --
   -- clock domain: clock
   SubFifo(i, ri.clock, ro.clock, o, r.clock, n);
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
-- architecture rtl of scfiforeg1
--
--**************************************************************
