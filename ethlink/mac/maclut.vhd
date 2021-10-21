--**************************************************************
--**************************************************************
--
-- Template file: comp_ck1.rec (new component, single clk)
--
--**************************************************************
--**************************************************************
--
--
-- Component maclut
--
--
-- MACaddress lut
--
-- - write interface receives 48bit parallel input bus, 
--   write op takes 6 clocks to complete, 'writedone' pulse
--   marks end of operation (48bit input bus assumed constant
--   until write operation completed)
--
-- - read interface works as showahead read fifo 
--   (read operation can be paused/restarted at full-speed)
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package component_maclut is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- maclut typedefs (edit)
--
subtype maclut_byte_t is std_logic_vector(7 downto 0);
type maclut_byte_vector_t is array(NATURAL RANGE <>) of maclut_byte_t;

--
-- maclut inputs (edit)
--
type maclut_inputs_t is record

   -- clock list
   clk : std_logic;
   -- reset list
   rst : std_logic;
   --
   -- NOTE: we assume all resets async asserted, sync deasserted by related clocks
   --
   
   -- write interface inputs
   wrreq : std_logic;
   wrpointer : std_logic_vector(3 downto 0);
   wrmacaddr : maclut_byte_vector_t(0 to 5);
   --
   -- wrreq     --> write op request (pulse, 1 clock)
   -- wrpointer --> macaddr pointer (4bit, maclut limited to 16 master nodes) 
   -- wrmacaddr --> 48bit macaddress parallel bus 
   --

   -- read interface inputs
   rdinit : std_logic;
   rdnext : std_logic;
   rdpointer : std_logic_vector(3 downto 0);
   --
   -- rdinit    --> read op initialized (pulse, 1 clock)
   -- rdnext    --> read request ack (pulse, 1 clock, showahead output fifo)
   -- rdpointer --> macaddr pointer (4bit, maclut limited to 16 master nodes)
   --

end record;

--
-- maclut outputs (edit)
--
type maclut_outputs_t is record

   -- write interface outputs
   writedone : std_logic;
   --
   -- writedone --> pulse, 1 clock
   --

   -- read interface outputs
   qready : std_logic;
   q : std_logic_vector(7 downto 0);
   --
   -- qready --> output is ready (output fifo not empty)
   -- q      --> output data (macaddr is read in sequence, from byte0 to byte5)
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
-- maclut component common interface (constant)
--
type maclut_t is record
   inputs : maclut_inputs_t;
   outputs : maclut_outputs_t;
end record;

--
-- maclut vector type (constant)
--
type maclut_vector_t is array(NATURAL RANGE <>) of maclut_t;

--
-- maclut component declaration (constant)
--
component maclut
port (
   inputs : in maclut_inputs_t;
   outputs : out maclut_outputs_t
);
end component;

--
-- maclut global signal to export range/width params (constant)
--
signal component_maclut : maclut_t;

end component_maclut;

--
-- maclut entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
--
-- use work.component_[name].all;
--
use work.component_maclut.all;
use work.component_dpram2.all;
use work.component_scfiforeg1.all;

-- maclut entity (constant)
entity maclut is
port (
   inputs : in maclut_inputs_t;
   outputs : out maclut_outputs_t
);
end maclut;

--**************************************************************
--**************************************************************

--**************************************************************
--
--
-- Component Architecture
--
--
--**************************************************************

architecture rtl of maclut is

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
type FSMmaclutwrite_t is (S0, S1, S2);

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

   -- FSM list
   FSMmaclutwrite : FSMmaclutwrite_t;

   -- register list
   wrindex : std_logic_vector(2 downto 0);          
   wrpointer : std_logic_vector(3 downto 0);
   --
   dpramreadI : std_logic;
   dpramready : std_logic;
   dpramrdindex : std_logic_vector(2 downto 0);
   dpramrdpointer : std_logic_vector(3 downto 0);

   -- end of list
   eol : std_logic;

end record;
constant reglist_clk_default : reglist_clk_t :=
(
   FSMmaclutwrite => S0,
   wrindex => "000",
   wrpointer => "0000",
   --
   dpramreadI => '0',
   dpramready => '0',
   dpramrdindex => "000",
   dpramrdpointer => "0000",

   eol => '0'
);

--
-- all local registers (edit)
--
-- Notes: one record-element for each clock domain
--
type reglist_t is record
   clk : reglist_clk_t;
end record;

--
-- all local nets (edit)
--
type netlist_t is record

   dpram_rdinit : std_logic;
   dpram_rdnext : std_logic;

   --
   -- component interface signals (edit)
   --
   -- [instance_name] : [component_name]_t;
   --
   dpram : dpram2_t;
   fifo : scfiforeg1_t;

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
subtype inputs_t is maclut_inputs_t;
subtype outputs_t is maclut_outputs_t;

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
-- architecture rtl of maclut
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

dpram : dpram2 port map
(
   inputs => allnets.dpram.inputs,
   outputs => allcmps.dpram.outputs
);

fifo : scfiforeg1 port map
(
   inputs => allnets.fifo.inputs,
   outputs => allcmps.fifo.outputs
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
process (inputs.clk, inputs.rst)
begin
   if (inputs.rst = '1') then
      allregs.dout.clk <= reglist_clk_default;
   elsif rising_edge(inputs.clk) then
      allregs.dout.clk <= allregs.din.clk;
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

process (inputs, allouts, allregs, allnets, allcmps)

--**************************************************************
--
-- Combinatorial description begin
--
--**************************************************************

--
-- MAClutwrite combinatorial procedure (edit)
--
-- clock domain: clk
--
procedure SubMAClutwrite
(
   variable i : in inputs_t;
   variable ri: in reglist_clk_t;
   variable ro: in reglist_clk_t;
   variable o : inout outputs_t;
   variable r : inout reglist_clk_t;
   variable n : inout netlist_t
) is
begin
   --
   -- MAC-address-lut write interface (dpram lut: 16slot x 8byte = 128byte)
   --

   -- defaults (dpram write-side)
   n.dpram.inputs.clock := i.clk;
   n.dpram.inputs.data  := SLV(0, 8);
   n.dpram.inputs.wraddress(2 downto 0) := ro.wrindex;
   n.dpram.inputs.wraddress(6 downto 3) := ro.wrpointer;
   n.dpram.inputs.wren := '0';
   
   -- outputs defaults
   o.writedone := '0';

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
      if i.wrreq = '1' then 
         -- burst-write starts
         r.wrindex := "000";          
         r.wrpointer := i.wrpointer; 
         r.FSMmaclutwrite := S2;
      else
         -- wait
         null;
      end if;

   when S2 =>
      --
      -- burst-write (note: 48bit input bus assumed constant)
      --
      if UINT(ro.wrindex) < 6 then 
         n.dpram.inputs.wren := '1';
         n.dpram.inputs.data := i.wrmacaddr(UINT(ro.wrindex)); 
         r.wrindex := SLV(UINT(ro.wrindex) + 1, r.wrindex);
         -- note: MAC addresses are stored starting at the beginning of 8byte memory slot 
         -- (lut(0..5) = macaddr(0..5), lut(6..7) = not used --> default zero)
      else
         -- write-done pulse
         o.writedone := '1';
         r.FSMmaclutwrite := S1;  
      end if;

   end case;

end procedure;


--
-- MAClutread combinatorial procedure (edit)
--
-- clock domain: clk
--
procedure SubMAClutread
(
   variable i : in inputs_t;
   variable ri: in reglist_clk_t;
   variable ro: in reglist_clk_t;
   variable o : inout outputs_t;
   variable r : inout reglist_clk_t;
   variable n : inout netlist_t
) is
begin

   --
   -- MAC-address-lut read interface (dpram lut: 16slot x 8byte = 128byte)
   --

   -- dpram read-side defaults
   n.dpram.inputs.rdaddress(2 downto 0) := ro.dpramrdindex;
   n.dpram.inputs.rdaddress(6 downto 3) := ro.dpramrdpointer;
   -- note: MAC addresses are stored starting at the beginning of 8byte memory slot 
   -- (lut(0..5) = macaddr(0..5), lut(6..7) = not used --> default zero)    

   -- output fifo defaults
   n.fifo.inputs.clock := i.clk;
   n.fifo.inputs.aclr := i.rst;
   n.fifo.inputs.sclr := '0';
   n.fifo.inputs.rdreq := '0';
   n.fifo.inputs.wrreq := '0';
   n.fifo.inputs.data := n.dpram.outputs.q;

   -- outputs
   o.qready := not(n.fifo.outputs.empty);
   o.q      := n.fifo.outputs.q;

   --
   -- maclut read-logic
   --
   n.dpram_rdinit := '0';
   --
   if i.rdinit = '1' then 
      -- new read address 
      n.dpram_rdinit := '1';
      -- output fifo cleared
      n.fifo.inputs.sclr := '1';
   elsif n.fifo.outputs.empty = '0' then
      -- maclut output is ready
      if i.rdnext = '1' then
         -- current output read, next
         n.fifo.inputs.rdreq := '1';
      end if;          
      -- note: burst-read --> there is an initial delay until maclut output is ready then
      -- read operations will continue under 'i.rdnext' control at max speed without additional delays
      -- (maclut output is a showahead fifo, 'i.rdnext = 1' works as fifo-read-ack signal) 
   else
      -- maclut output is empty (reset state | dpram-read in progress)
      null;
   end if;

   --
   -- dpram read-logic
   --
   if n.dpram_rdinit = '1' then 
      -- new read address: dpram read-latency-chain cleared
      r.dpramready   := '0';
      r.dpramreadI   := '0';
      r.dpramrdindex   := SLV(0, r.dpramrdindex);           
      r.dpramrdpointer := i.rdpointer(3 downto 0);
   else
      -- dpram read-latency-chain always ON (dpram read-op takes 2 clocks)
      --
      -- dpramreadI --> dpram read in progress (clock1)
      -- dpramready --> dpram q valid          (clock2)
      --
      r.dpramready := ro.dpramreadI; 

      -- read-request test 
      r.dpramreadI := '0';
      if n.dpram_rdnext = '1' then
         -- next address request: read operation for current address starts, next address prepared    
         r.dpramreadI := '1';
         r.dpramrdindex := SLV(UINT(ro.dpramrdindex) + 1, r.dpramrdindex); 
      end if; 
   end if;

   --
   -- output-fifo write-logic
   --
   -- note: logic always ON, output fifo is empty until first write op then it contains
   -- at least one word --> read op works full-speed once fifo is found not empty  
   -- 
   -- fifo depth = 2(dpram-read-latency) + 1(output-reg) = 3
   --
   -- dpram-read/fifo-write sequence
   -- 
   -- A = dpram rdaddress input
   -- M = dpram read
   -- Q = dpram q output
   -- F = fifo registers
   -- Y = fifo output
   --
   -- A M Q F F Y
   -- 0 - - - - -  fifo empty 
   -- 1 0 - - - -  fifo empty
   -- 2 1 0 - - -  fifo empty
   -- 3 2 1 - - 0  pause (now fifo always not empty)
   -- 3 - 2 - 1 0  pause
   -- 3 - - 2 1 0  rdnext
   -- 4 3 - - 2 1  rdnext
   -- 5 4 3 - - 2  rdnext
   -- 6 5 4 - - 3  rdnext
   -- 7 6 5 - - 4  pause
   -- 7 - 6 - 5 4  pause
   -- 7 - - 6 5 4  rdnext
   -- 8 7 - - 6 5  rdnext
   -- 9 8 7 - - 6  rdnext
   -- A 9 8 - - 7  rdnext
   -- ....
   --
   if ro.dpramready = '1' and n.fifo.outputs.full = '0' then
      -- dpram data ready, output fifo not full --> fifo-write op
      n.fifo.inputs.wrreq := '1';     
   end if;
   --
   n.dpram_rdnext := '0';
   if n.fifo.outputs.empty = '1' then
      -- empty fifo can accept all data from dpram-read-pipeline, 'rdnext' continuosly asserted
      n.dpram_rdnext := '1';
   else
      -- fifo not empty, dpram-read controlled by fifo-read-request (output fifo absorbs dpram 
      -- read-latency when fifo-read pause/restart --> fifo is always not empty, full speed 
      -- burst-read guaranteed)    
      if n.fifo.inputs.rdreq = '1' then        
         -- fifo-read-request will consume one fifo word --> new dpram-read can start
         -- because there is free space to accept next data      
         n.dpram_rdnext := '1';
      else
         -- fifo-read-request stops: data walking through dpram-read-pipeline will move 
         -- into the fifo, dpram address unchanged
         null;
      end if;
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
   n.dpram.outputs := allcmps.dpram.outputs; 
   n.fifo.outputs  := allcmps.fifo.outputs; 

   --
   -- all procedures call (edit)
   --
   -- clock domain: clk
   SubMAClutwrite(i, ri.clk, ro.clk, o, r.clk, n);
   SubMAClutread(i, ri.clk, ro.clk, o, r.clk, n);
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
-- architecture rtl of maclut
--
--**************************************************************

