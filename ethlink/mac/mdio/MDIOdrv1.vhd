--**************************************************************
--**************************************************************
--
-- Template file: comp_ck1.rec (new component, single clk)
--
--**************************************************************
--**************************************************************
--
--
-- Component MDIOdrv1
--
--
-- MII Management interface (low level driver)
--
-- (IEEE 802.3 clause 22, MCL/MDIO serial interface)
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

package component_MDIOdrv1 is

--
-- MDIOdrv1 params (edit)
--
--constant MDIOdrv1_phyaddr : integer := 0;
--constant MDIOdrv1_address : integer := 0;

--
-- MDIOdrv1 inputs (edit)
--
type MDIOdrv1_inputs_t is record

   -- clock, reset 
   clk1 : std_logic;
   rst1 : std_logic;

   -- Avalon interface
   mmaddress : std_logic_vector(1 downto 0);
   mmread : std_logic;
   mmwrite : std_logic;
   mmwritedata : std_logic_vector(31 downto 0);

   -- Serial link
   sin : std_logic;

end record;

--
-- MDIOdrv1 outputs (edit)
--
type MDIOdrv1_outputs_t is record

   -- Avalon interface
   mmreaddata : std_logic_vector(31 downto 0);
   mmreaddatavalid : std_logic;
   mmwaitrequest : std_logic;

   -- Serial link
   sout : std_logic;
   sena : std_logic;
   sclk : std_logic;

   -- Debug
   dataout : std_logic_vector(15 downto 0);
   flag_valid : std_logic;
   flag_busy : std_logic;
   flag_wrerr : std_logic;
   debug : std_logic_vector(7 downto 0);

end record;

--
-- MDIOdrv1 component common interface (constant)
--
type MDIOdrv1_t is record
   inputs : MDIOdrv1_inputs_t;
   outputs : MDIOdrv1_outputs_t;
end record;

--
-- MDIOdrv1 vector type (constant)
--
type MDIOdrv1_vector_t is array(NATURAL RANGE <>) of MDIOdrv1_t;

--
-- MDIOdrv1 component declaration (constant)
--
component MDIOdrv1
port (
   inputs : in MDIOdrv1_inputs_t;
   outputs : out MDIOdrv1_outputs_t
);
end component;

--
-- MDIOdrv1 global signal to export range/width params (constant)
--
signal component_MDIOdrv1 : MDIOdrv1_t;

end component_MDIOdrv1;

--
-- MDIOdrv1 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_MDIOdrv1.all;

-- MDIOdrv1 entity (constant)
entity MDIOdrv1 is
port (
   inputs : in MDIOdrv1_inputs_t;
   outputs : out MDIOdrv1_outputs_t
);
end MDIOdrv1;

--**************************************************************
--
--
-- Component Architecture
--
--
--**************************************************************

architecture rtl of MDIOdrv1 is

--
-- state machines (edit)
--
type FSMmmslave_t is (S0, S1, S2, S3);
type FSMmain_t is (S0, S1, S2, S3);
type FSMsclk_t is (S0, S1, S2, S3);
type FSMshiftreg_t is (S0, S1, S2, S3, S4, S5, S6);

--
-- local registers (edit)
--
--
-- Notes: one record-type for each clock domain
--

--
-- clock domain clk1
--
type reglist1_t is record

   -- Avalon read/write FSM
   FSMmmslave : FSMmmslave_t;
   
   -- Main FSM
   FSMmain : FSMmain_t;

   -- Main FSM control
   rdreq : std_logic;
   wrreq : std_logic;

   -- Status/Error flags
   flag_busy : std_logic;   -- read/write in progress
   flag_wrerr : std_logic;  -- Avalon write access with system busy, write ignored
   flag_rderr : std_logic;  -- rdata not valid (poweron default or TA field
                            -- error when invalid address or bad interface)

   -- address register 
   address : std_logic_vector(4 downto 0);
   phyaddr : std_logic_vector(4 downto 0);

   -- read/write regs
   rdata : std_logic_vector(15 downto 0);
   wdata : std_logic_vector(15 downto 0);

   -- Serial clock FSM
   FSMsclk : FSMsclk_t;   

   -- Shift register FSM
   FSMshiftreg : FSMshiftreg_t;

   -- Registered serial I/O
   sclk : std_logic;
   sout : std_logic;
   sena : std_logic;
   sin : std_logic;

   -- Counters/Shiftregs/Ctrlregs
   sclkdiv : unsigned(7 downto 0);
   sclkcnt : unsigned(7 downto 0);
   shiftreg : unsigned(15 downto 0);
   sclkON : std_logic;

end record;
constant reglist1_default : reglist1_t :=
(
   FSMmmslave => S0,
   FSMmain => S0,

   rdreq => '0',
   wrreq => '0',

   flag_busy => '0',
   flag_wrerr => '0',
   flag_rderr => '1', -- poweron default, rdata not valid

   address => (others => '0'),
   phyaddr => (others => '0'),

   rdata => (others => '0'),
   wdata => (others => '0'),

   FSMsclk => S0,
   FSMshiftreg => S0,
   sclk => '0',
   sout => '0',
   sena => '0',
   sin => '0',
   sclkdiv => (others => '0'),
   sclkcnt => (others => '0'),
   shiftreg => (others => '0'),
   sclkON => '0'
);

--
-- all local registers (edit)
--
-- Notes: one record-element for each clock domain
--
type reglist_t is record
   clk1 : reglist1_t;
end record;

--
-- all local nets (edit)
--
type netlist_t is record
   frame_done : std_logic;
   sclkdiv_load : std_logic;
   sclkdiv_overflow : std_logic;
   sclkcnt_load : std_logic;
   sclkcnt_ena : std_logic;
   shiftreg_ena : std_logic;
   posedge_req : std_logic;
   negedge_req : std_logic;
   --
   -- component interface signals (edit)
   --
   -- [instance_name] : [component_name]_t;
   -- [instance_name] : [component_name]_vector_t([instance_range]);
   --
   --c1 : counter1_t;
end record;

--
-- local signals (edit)
--

--**************************************************************
--**************************************************************

--
-- inputs/outputs record-type alias (constant)
--
subtype inputs_t is MDIOdrv1_inputs_t;
subtype outputs_t is MDIOdrv1_outputs_t;

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
-- architecture rtl of MDIOdrv1
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

--
-- Example (single component)
--
--c1 : counter1 port map
--(
--   inputs => allnets.c1.inputs,
--   outputs => allcmps.c1.outputs
--);
--

--
-- Example (vector of components)
--
--L1 : FOR i IN allnets.cc'range GENERATE
--
--cc : counter1 port map
--(
--   inputs => allnets.cc(i).inputs,
--   outputs => allcmps.cc(i).outputs
--);
--
--END GENERATE;
--

--**************************************************************
--
-- sequential logic
--
--
-- Notes: one clock process for each clock domain
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

process (inputs, allouts, allregs, allnets, allcmps)

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
-- baseaddr + 0 (r/w) = (9..5) phyaddr, (4..0) address
--          + 1 (r/w) = write access --> start rcommand
--                    = read  access --> read current rdata (NO rcommand loaded)
--          + 2 (r/w) = write access --> write wdata + start wcommand
--                    = read  access --> read current wdata (NO wcommand loaded)
--          + 3 (ro ) = read access  --> read current status/error
--                                       bit 31 = BUSY (BMI loop test)
--                                       bit 30..0 = status/error code, 0 --> OK, BEQ test
--
-- baseaddr + 3 (ro )
--
-- bit 31 = flag_busy  --> read/write in progress
--
-- bit  1 = flag_rderr --> current rdata not valid (poweron default or 
--                         TA field error when invalid address or
--                         bad interface); 
--
-- bit  0 = flag_wrerr --> Avalon write access with system busy, write ignored
--
--
procedure SubAVALONslave
(
   variable i : in inputs_t;
   variable ri : in reglist1_t;
   variable ro : in reglist1_t;
   variable o : inout outputs_t;
   variable r : inout reglist1_t;
   variable n : inout netlist_t
) is
begin

   -- Avalon defaults
   o.mmreaddata := SLV(0, o.mmreaddata); -- readdata = all zero
   o.mmreaddatavalid := '0';             -- data valid deasserted
   o.mmwaitrequest := '0';               -- wait request deasserted

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

      if UINT(i.mmaddress) = 0 then
         -- return current address/phyaddr (word low)
         o.mmreaddata(4 downto 0) := ro.address;
         o.mmreaddata(9 downto 5) := ro.phyaddr;
      elsif UINT(i.mmaddress) = 1 then
         -- return current busy flag (msb), rdata (word low)
         o.mmreaddata(15 downto  0) := ro.rdata;
         o.mmreaddata(31) := ro.flag_busy;
         --
         -- Notes: read with msb = 1 means 'read/write in progress' and
         -- field 'rdata' must be ignored (old rdata).
         --
      elsif UINT(i.mmaddress) = 2 then
         -- return current wdata (word low)
         o.mmreaddata(15 downto  0) := ro.wdata;
      else --> UINT(i.mmaddress) = 3
         -- return current status
         o.mmreaddata(31) := ro.flag_busy;
         o.mmreaddata(1) := ro.flag_rderr;
         o.mmreaddata(0) := ro.flag_wrerr;
      end if;

      r.FSMmmslave:= S1;

   when S3 =>
      --
      -- write done : current write cycle accepted
      --
      o.mmwaitrequest := '0';

      if ro.flag_busy = '1' then
         -- write command during busy condition: command ignored, error
         r.flag_wrerr := '1';
      else
         -- system ready: write command
         if UINT(i.mmaddress) = 0 then
            -- capture new address/phyaddr
            r.address := i.mmwritedata(4 downto 0);
            r.phyaddr := i.mmwritedata(9 downto 5);
         elsif UINT(i.mmaddress) = 1 then
            -- new wdata ignored, start read operation
            r.rdreq := '1';
         elsif UINT(i.mmaddress) = 2 then
            -- capture new wdata, start write operation
            r.wdata := i.mmwritedata(15 downto 0);
            r.wrreq := '1';
         else --> UINT(i.mmaddress) = 3
            -- new wdata ignored, read only status register
            null;
         end if;
      end if;
      --
      -- Notes: 'start command' using r.rdreq/r.wrreq registers
      -- (start command recognized next clock cycle: avalon
      -- access takes always 2 clock cycles so system can accept
      -- new command and updates flags before next avalon status read).
      --

      r.FSMmmslave := S1;

   end case;

end procedure;

--
-- FSMmain combinatorial procedure (edit)
--
-- Main state machine for read/write operations
--
procedure SubFSMmain
(
   variable i : in inputs_t;
   variable ri : in reglist1_t;
   variable ro : in reglist1_t;
   variable o : inout outputs_t;
   variable r : inout reglist1_t;
   variable n : inout netlist_t
) is
begin

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
      if ro.rdreq = '1' then
         -- read request accepted
         r.sclkON := '1';
         r.flag_busy := '1';
         r.flag_rderr := '0';  
         r.flag_wrerr := '0';
         r.rdreq := '0';
         r.FSMmain := S2;
      elsif ro.wrreq = '1' then
         -- write request accepted
         r.sclkON := '1';
         r.flag_busy := '1';
         r.flag_rderr := '0'; 
         r.flag_wrerr := '0';
         r.wrreq := '0';
         r.FSMmain := S3;
      else
         -- sclk stop
         r.sclkON := '0';
         r.flag_busy := '0';
      end if;

   when S2 =>
      --
      -- read in progress
      --
      if n.frame_done = '1' then
         -- read done: capture current shiftreg
         r.rdata(15 downto 0) := SLV(ro.shiftreg, r.rdata'length); 
         r.FSMmain := S0;
      end if;

   when S3 =>
      --
      -- write in progress
      --
      if n.frame_done = '1' then
         r.FSMmain := S0;
      end if;

   end case;

end procedure;

--
-- FSMsclk combinatorial procedure (edit)
--
--
-- Serial clock generation/control
--
-- clk1 = 50MHz
-- sclk = clk1 / 20 = 2.5MHz
--
procedure SubFSMsclk
(
   variable i : in inputs_t;
   variable ri : in reglist1_t;
   variable ro : in reglist1_t;
   variable o : inout outputs_t;
   variable r : inout reglist1_t;
   variable n : inout netlist_t
) is
begin

   -- defaults
   n.sclkdiv_load := '0';
   n.posedge_req := '0';
   n.negedge_req := '0';

   case ro.FSMsclk is
   when S0 =>
      --
      -- reset state
      --
      r.FSMsclk := S1;

   when S1 =>
      --
      -- idle state
      --
      if (ro.sclkON = '1') then
         -- sclkON: restart sclkdiv
         n.sclkdiv_load := '1';
         -- start with sclk = 0
         r.sclk := '0';
         r.FSMsclk := S2;
      end if;

   when S2 =>
      --
      -- sclk ON, phase 0
      --
      if (n.sclkdiv_overflow = '1') then
         -- posedge
         r.sclk := '1';
         -- restart sclkdiv
         n.sclkdiv_load := '1';
         -- mark current clock cycle as 'posedge request'
         n.posedge_req := '1';
         r.FSMsclk := S3;
      end if;

   when S3 =>
      --
      -- sclk ON, phase 1
      --
      if (n.sclkdiv_overflow = '1') then
         -- negedge
         r.sclk := '0';
         -- mark current clock cycle as 'negedge request'
         n.negedge_req := '1';
         -- restart sclkdiv
         n.sclkdiv_load := '1';
         -- continue?
         if ro.sclkON  = '1' then
            r.FSMsclk := S2;
         else
            -- to idle
            r.FSMsclk := S1;
         end if;
         -- 
         -- Notes: sclk continuous generation when commands are received 
         -- without pauses (sclk is not halted/stretched).
         --
      end if;
   end case;

end procedure;

--
-- sclkdiv counter (up counter with stop on overflow)
--
procedure Subsclkdiv
(
   variable i : in inputs_t;
   variable ri : in reglist1_t;
   variable ro : in reglist1_t;
   variable o : inout outputs_t;
   variable r : inout reglist1_t;
   variable n : inout netlist_t
) is
begin

   -- overflow test
   n.sclkdiv_overflow := '0';
   if ro.sclkdiv >= 16 then
      n.sclkdiv_overflow := '1';
   end if;

   if n.sclkdiv_load = '1' then
      -- reload
      r.sclkdiv := SLV(16 - 10 + 1, r.sclkdiv'length);
   else
      -- up counter with stop on overflow
      if n.sclkdiv_overflow = '0' then
         r.sclkdiv := ro.sclkdiv + 1;
      end if;
   end if;

end procedure;

--
-- Shift register
--
procedure SubShiftRegister
(
   variable i : in inputs_t;
   variable ri : in reglist1_t;
   variable ro : in reglist1_t;
   variable o : inout outputs_t;
   variable r : inout reglist1_t;
   variable n : inout netlist_t
) is
begin

   -- defaults
   n.sclkcnt_ena := '0';
   n.shiftreg_ena := '0';
   n.frame_done := '0';

   case ro.FSMshiftreg is
   when S0 =>
      --
      -- reset state
      --
      r.FSMshiftreg := S1;

   when S1 =>
      --
      -- idle state
      --
      -- output driver disabled
      r.sena := '0';
      if (ro.FSMmain = S2 or ro.FSMmain = S3) then
         -- read/write in progress : preamble start (32 sclk) with output driver disabled
         r.sclkcnt := SLV((64 - 32), r.sclkcnt);
         r.FSMshiftreg := S2;
      end if;

   when S2 =>
      --
      -- wait end of preamble
      --
      if ro.sclkcnt >= 64 then
         -- preamble done: header start
         -- frame start opcode
         r.shiftreg(15 downto 14) :=  "01";
         -- read/write opcode
         r.shiftreg(13 downto 12) :=  "10";
         if ro.FSMmain = S3 then
            r.shiftreg(13 downto 12) := "01";
         end if;
         -- address
         r.shiftreg(11 downto 7) := SLV(ro.phyaddr);
         r.shiftreg(6 downto 2) := SLV(ro.address);
         -- fixed TA (default write mode)
         r.shiftreg(1 downto 0) := "10";
         -- up counter with dual overflow
         r.sclkcnt := SLV((64 - 16 + 2), r.sclkcnt);
         r.FSMshiftreg := S3;
      else
         -- cnt++
         n.sclkcnt_ena := '1';
      end if;

   when S3 =>
      --
      -- wait end of header
      --
      -- sout enabled
      r.sena := '1';
      if ro.sclkcnt >= 64 then
         -- counter 1st-overflow: TA field (2 sclk) in output
         if ro.FSMmain = S2 then
            -- read: sout highZ
            r.sena := '0';
         end if;
      end if;
      if ro.sclkcnt >= 64 and ro.sclkcnt(1 downto 0) = 1 then
         -- TA 2nd bit: capture ro.sin level before sclk posedge
         if n.posedge_req = '1' then
            -- rderr when TA 2nd bit == 1 --> sout highZ, pullup     
            r.flag_rderr := ro.sin;
         end if;
      end if;
      if ro.sclkcnt >= 64 and ro.sclkcnt(1 downto 0) >= 2 then
         -- counter 2nd-overflow, header end: reload clock counter (16 sclk)
         r.sclkcnt := SLV((64 - 16), r.sclkcnt);
         -- to read/write
         if ro.FSMmain = S2 then
            -- read
            r.FSMshiftreg := S4;
         else
            -- write
            r.shiftreg := SLV(ro.wdata);
            r.FSMshiftreg := S5;
         end if;
      else
         -- cnt++
         n.sclkcnt_ena := '1';
         -- shift
         if n.negedge_req = '1' then
            -- shiftout when negedge
            n.shiftreg_ena := '1';
         end if;
      end if;

   when S4 =>
      --
      -- read
      --
      if ro.sclkcnt >= 64 then
         -- frame end
         n.frame_done := '1';
         r.FSMshiftreg := S1;
      else
         -- cnt++
         n.sclkcnt_ena := '1';
         -- shift
         if n.posedge_req = '1' then
            -- shiftin using current sin (before sclk posedge)
            n.shiftreg_ena := '1';
         end if;
      end if;

   when S5 =>
      --
      -- write
      --
      if ro.sclkcnt >= 64 then
         -- frame end
         n.frame_done := '1';
         r.FSMshiftreg := S1;
      else
         -- cnt++
         n.sclkcnt_ena := '1';
         -- shift
         if n.negedge_req = '1' then
            -- shiftout when negedge
            n.shiftreg_ena := '1';
         end if;
      end if;

   when S6 =>
      --
      --
      --
      r.FSMshiftreg := S0;

   end case;

   --
   -- input.sin registered with single DFFE
   --
   r.sin := i.sin;

   --
   -- Shift register control
   --
   if n.shiftreg_ena = '1' then
      -- shiftin (using registered sin)
      r.shiftreg(15 downto 1) := ro.shiftreg(14 downto 0);
      r.shiftreg(0) := ro.sin;
      -- shiftout
      r.sout := ro.shiftreg(15);
   end if;

end procedure;

--
-- sclk counter control
--
procedure Subsclkcnt
(
   variable i : in inputs_t;
   variable ri : in reglist1_t;
   variable ro : in reglist1_t;
   variable o : inout outputs_t;
   variable r : inout reglist1_t;
   variable n : inout netlist_t
) is
begin

   if n.sclkcnt_ena = '1' then
      -- posedge counter
      if n.posedge_req = '1' then
         -- up counter
         r.sclkcnt := ro.sclkcnt + 1;
      end if;
   end if;

end procedure;

--
-- Outputs map (edit)
--
procedure SubOutputs
(
   variable i : in inputs_t;
   variable ri : in reglist1_t;
   variable ro : in reglist1_t;
   variable o : inout outputs_t;
   variable r : inout reglist1_t;
   variable n : inout netlist_t
) is
begin

   -- MDIO outputs
   o.sclk := ro.sclk; -- reg output
   --o.sclk := ri.sclk;  -- comb output
   o.sout := ro.sout; -- reg output
   o.sena := ro.sena; -- reg output

end procedure;

--
-- Debug combinatorial procedure (edit)
--
procedure SubDebug
(
   variable i : in inputs_t;
   variable ri : in reglist1_t;
   variable ro : in reglist1_t;
   variable o : inout outputs_t;
   variable r : inout reglist1_t;
   variable n : inout netlist_t
) is
begin

   -- debug/test
   o.dataout := SLV(ro.shiftreg, o.dataout'length);
   o.debug := SLV(ro.sclkcnt, o.debug'length); -- reg output

   o.flag_busy := ro.flag_busy; -- reg output
   o.flag_wrerr := ro.flag_wrerr; -- reg output
   o.flag_valid := (not ro.flag_busy) and (not ro.flag_rderr); 

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
variable ri : reglist1_t;
variable ro : reglist1_t;
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
   --...
   --n.[instance_name].outputs := allcmps.[instance_name].outputs;

   --
   -- all procedures call (edit)
   --
   SubAVALONslave(i, ri, ro, o, r, n);
   SubFSMmain(i, ri, ro, o, r, n);
   SubFSMsclk(i, ri, ro, o, r, n);
   Subsclkdiv(i, ri, ro, o, r, n);
   Subsclkcnt(i, ri, ro, o, r, n);
   SubShiftRegister(i, ri, ro, o, r, n);
   SubOutputs(i, ri, ro, o, r, n);
   SubDebug(i, ri, ro, o, r, n);

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
-- architecture rtl of MDIOdrv1
--
--**************************************************************
