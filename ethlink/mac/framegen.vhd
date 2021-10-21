--**************************************************************
--**************************************************************
--
-- Template file: comp_ck2.rec (new component, dual clk)
--
--**************************************************************
--**************************************************************
--
--
-- Component framegen
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

package component_framegen is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- framegen constants (edit)
--
-- constant framegen_[constant_name] : [type] := [value];
--

--
-- framegen typedefs (edit)
--
-- subtype framegen_[name]_t is [type];
-- type framegen_[name]_t is [type];
--

--
-- framegen inputs (edit)
--
type framegen_inputs_t is record

   -- clock list
   tx_clk : std_logic;   -- gmii tx clock
   
   -- reset list
   reset_tx_clk : std_logic;
   --
   -- NOTE: we assume all resets async asserted, sync deasserted by related clocks
   --
 
   -- write interface: txport1_NPORTS clock domains
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

   -- txport interface (clock domain wclk(),wrst()) 
   tport_wready : std_logic_vector(1 to txport1_NPORTS);
   tport_wempty : std_logic_vector(1 to txport1_NPORTS); 
   tport_wfull : std_logic_vector(1 to txport1_NPORTS); 
   tport_werror : std_logic_vector(1 to txport1_NPORTS);
   tport_wdatalen : txport1_framelen_vector_t(1 to txport1_NPORTS);
   tport_wframes : txport1_frames_vector_t(1 to txport1_NPORTS);

   -- framegen control
   fgen_wr   : std_logic;
   --
   fgen_ena  : std_logic;
   fgen_loop : std_logic;
   fgen_trig : std_logic_vector(1 to txport1_NPORTS);
   -- framegen params
   fgen_framelen : std_logic_vector(10 downto 0);
   fgen_destaddr : std_logic_vector(7 downto 0);
   fgen_destport : std_logic_vector(3 downto 0);
   fgen_destmode : std_logic_vector(2 downto 0);

end record;

--
-- framegen outputs (edit)
--
type framegen_outputs_t is record

   -- txport interface (clock domain wclk(),wrst()) 
   tport_wena : std_logic_vector(1 to txport1_NPORTS);               
   tport_wreq : std_logic_vector(1 to txport1_NPORTS);               
   tport_wdata : txport1_wdata_vector_t(1 to txport1_NPORTS);        
   tport_wframelen : txport1_framelen_vector_t(1 to txport1_NPORTS);
   tport_wdestport : txport1_destport_vector_t(1 to txport1_NPORTS); 
   tport_wdestaddr : txport1_destaddr_vector_t(1 to txport1_NPORTS);
   tport_wmulticast : std_logic_vector(1 to txport1_NPORTS);
   tport_wtxreq : std_logic_vector(1 to txport1_NPORTS);   
   tport_wtxclr : std_logic_vector(1 to txport1_NPORTS);        

   -- write interface outputs (clock domain wclk(),wrst()) 
   wready : std_logic_vector(1 to txport1_NPORTS);
   wempty : std_logic_vector(1 to txport1_NPORTS); 
   wfull : std_logic_vector(1 to txport1_NPORTS); 
   werror : std_logic_vector(1 to txport1_NPORTS);
   wdatalen : txport1_framelen_vector_t(1 to txport1_NPORTS);
   wframes : txport1_frames_vector_t(1 to txport1_NPORTS);

end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- framegen component common interface (constant)
--
type framegen_t is record
   inputs : framegen_inputs_t;
   outputs : framegen_outputs_t;
end record;

--
-- framegen vector type (constant)
--
type framegen_vector_t is array(NATURAL RANGE <>) of framegen_t;

--
-- framegen component declaration (constant)
--
component framegen
port (
   inputs : in framegen_inputs_t;
   outputs : out framegen_outputs_t
);
end component;

--
-- framegen global signal to export range/width params (constant)
--
signal component_framegen : framegen_t;

end component_framegen;

--
-- framegen entity declaration
--

-- libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
--
-- use work.component_[name].all;
--
use work.component_framegen.all;
use work.component_regsync1.all;
use work.component_txport1.all;

-- framegen entity (constant)
entity framegen is
port (
   inputs : in framegen_inputs_t;
   outputs : out framegen_outputs_t
);
end framegen;

--**************************************************************
--**************************************************************

--**************************************************************
--
--
-- Component Architecture
--
--
--**************************************************************

architecture rtl of framegen is

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
type FSMframegen_t is (S0, S1, S2, S3, S3_1, S4);

--
-- local registers (edit)
--
--
-- Notes: one record-type for each clock domain
--

--
-- clock domain wclk (edit)
--
type reglist_wclk_t is record

   -- FSM list
   FSMframegen : FSMframegen_t;

   -- framegen synchronizers
   framegenena : std_logic;
   framegenenaI : std_logic;
   framegenenaII : std_logic;
   framegenloop : std_logic;
   framegenloopI : std_logic;
   framegenloopII : std_logic;
   framegentrig : std_logic;
   framegentrigI : std_logic;
   framegentrigII : std_logic;

   -- framegen counters
   framecount : std_logic_vector(15+1 downto 0);
   frameloop : std_logic_vector(15 downto 0);
   counter : std_logic_vector(31 downto 0); -- !! Debug !!

   -- end of list 
   eol : std_logic;

end record;
constant reglist_wclk_default : reglist_wclk_t :=
(
   FSMframegen => S0,
   framegenena => '0',
   framegenenaI => '0',
   framegenenaII => '0',
   framegenloop => '0',
   framegenloopI => '0',
   framegenloopII => '0',
   framegentrig => '0',
   framegentrigI => '0',
   framegentrigII => '0',
   --
   frameloop => (others => '0'),
   framecount => (others => '0'),
   counter => (others => '0'),

   eol => '0'
);
type reglist_wclk_vector_t is array(NATURAL RANGE <>) of reglist_wclk_t;

--
-- clock domain tx_clk
--
type reglist_tx_clk_t is record

   -- framegen control
   framegenena : std_logic;
   framegenloop : std_logic;
   framegentrig : std_logic_vector(1 to txport1_NPORTS);

   -- end of list 
   eol : std_logic;

end record;
constant reglist_tx_clk_default : reglist_tx_clk_t :=
(
   framegenena => '0',
   framegenloop => '0',
   framegentrig => (others => '0'),

   eol => '0'
);

--
-- all local registers (edit)
--
-- Notes: one record-element for each clock domain
--
type reglist_t is record
   tx_clk : reglist_tx_clk_t;
   -- Framegen: indexed regs
   wclk : reglist_wclk_vector_t(1 to txport1_NPORTS);
end record;

--
-- all local nets (edit)
--
type netlist_t is record

   -- Framegen: indexed clock,reset
   wclk : std_logic_vector(1 to txport1_NPORTS);
   wrst : std_logic_vector(1 to txport1_NPORTS);
   
   --
   -- component interface signals (edit)
   --
   -- [instance_name] : [component_name]_t;
   --
   -- Framegen: params synchronizer (from clk to wclk)
   wframegensync : regsync1_vector_t(1 to txport1_NPORTS); 

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
subtype inputs_t is framegen_inputs_t;
subtype outputs_t is framegen_outputs_t;

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
-- architecture rtl of framegen
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
wframegensync : FOR index IN allnets.wframegensync'range GENERATE
wframegensync : regsync1 port map
(
   inputs => allnets.wframegensync(index).inputs,
   outputs => allcmps.wframegensync(index).outputs
);
END GENERATE;

--**************************************************************
--
-- sequential logic
--
--
-- Notes: one record-type for each clock domain
--
--**************************************************************

--
-- clock domain: tx_clk (edit)
--
process (inputs.tx_clk, inputs.reset_tx_clk)
begin
   if (inputs.reset_tx_clk = '1') then
      allregs.dout.tx_clk <= reglist_tx_clk_default;
   elsif rising_edge(inputs.tx_clk) then
      allregs.dout.tx_clk <= allregs.din.tx_clk;
   end if;
end process;

--
-- Framegen clock domain: wclk,wrst (edit)
--
process_wclk : FOR i IN 1 to txport1_NPORTS GENERATE

process (inputs.wclk(i), inputs.wrst(i))
begin
   if (inputs.wrst(i) = '1') then
      allregs.dout.wclk(i) <= reglist_wclk_default;
   elsif rising_edge(inputs.wclk(i)) then
      allregs.dout.wclk(i) <= allregs.din.wclk(i);
   end if;
 end process;

END GENERATE;

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
-- Main combinatorial procedure
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
   -- write interface connected to txport interface (default path)
   --
   o.tport_wena       := i.wena(1 to txport1_NPORTS);
   o.tport_wreq       := i.wreq(1 to txport1_NPORTS);
   o.tport_wdata      := i.wdata(1 to txport1_NPORTS);
   o.tport_wframelen  := i.wframelen(1 to txport1_NPORTS);
   o.tport_wdestport  := i.wdestport(1 to txport1_NPORTS);
   o.tport_wdestaddr  := i.wdestaddr(1 to txport1_NPORTS);
   o.tport_wmulticast := i.wmulticast(1 to txport1_NPORTS);
   o.tport_wtxreq     := i.wtxreq(1 to txport1_NPORTS);   
   o.tport_wtxclr     := i.wtxclr(1 to txport1_NPORTS);        
   --
   o.wready   := i.tport_wready(1 to txport1_NPORTS);
   o.wempty   := i.tport_wempty(1 to txport1_NPORTS); 
   o.wfull    := i.tport_wfull(1 to txport1_NPORTS); 
   o.werror   := i.tport_werror(1 to txport1_NPORTS);
   o.wdatalen := i.tport_wdatalen(1 to txport1_NPORTS);
   o.wframes  := i.tport_wframes(1 to txport1_NPORTS);

end procedure;


--
-- Framegen control
-- !!! SubFramegen MUST be called after SubMain !!!
--
-- all clock domains
--
procedure SubFramegen
(
   variable i : in inputs_t;
   variable ri: in reglist_t;
   variable ro: in reglist_t;
   variable o : inout outputs_t;
   variable r : inout reglist_t;
   variable n : inout netlist_t
) is
begin

FOR index in 1 to txport1_NPORTS LOOP
   --
   -- Framegen: register map (from mac_gmii.vhd)
   -- 
   -- reg12.0  (rw): Framegen continuous-loop
   --
   -- reg12.1  (rw): Framegen trigger bit 1..15
   -- ..           : 
   -- reg12.15 (rw): 
   --
   -- reg12.16 (rw): Framegen destaddr (8bit, fmux = 0) 
   -- ..           : 
   -- reg12.23 (rw): 
   --
   -- reg12.24 (rw): Framegen destport (4bit, fmux = 0)
   -- ..           :
   -- reg12.27 (rw):  
   --
   -- reg12.16 (rw): Framegen destmode (3bit, fmux = 1) 
   -- ..           : 
   -- reg12.18 (rw): 
   --
   -- reg12.16 (rw): Framegen framelen (11bit, fmux = 2) 
   -- ..           : 
   -- reg12.26 (rw): 
   --
   -- reg12.28 (rw): Framegen fmux selector (2bit)
   -- reg12.29 (rw): 
   --
   -- reg12.30 (rw): Framegen write_flag
   -- reg12.31 (rw): Framegen enable
   --

   --
   -- Framegen: params synchronizer (from tx_clk to wclk) 
   --
   -- wreg.0  : Framegen framelen (11bit) 
   -- ..      : 
   -- wreg.10 : 
   --
   -- wreg.16 : Framegen destaddr (8bit) 
   -- ..      : 
   -- wreg.23 : 
   --
   -- wreg.24 : Framegen destport (4bit)
   -- ..      :
   -- wreg.27 :  
   --
   -- wreg.28 : Framegen destmode (3bit)
   -- ..      :
   -- wreg.30 :  
   --
   -- write clock domain: tx_clk
   n.wframegensync(index).inputs.wclk := i.tx_clk;
   n.wframegensync(index).inputs.wrst := i.reset_tx_clk;
   n.wframegensync(index).inputs.wreq := i.fgen_wr;      
   -- note: write requests applied when sync-write-op is in progress are 
   -- delayed until sync-write-op is done (see regsync1.vhd)
   n.wframegensync(index).inputs.dreg(10 downto 0)  := i.fgen_framelen;
   n.wframegensync(index).inputs.dreg(15 downto 11) := "00000";
   n.wframegensync(index).inputs.dreg(23 downto 16) := i.fgen_destaddr;
   n.wframegensync(index).inputs.dreg(27 downto 24) := i.fgen_destport;
   n.wframegensync(index).inputs.dreg(30 downto 28) := i.fgen_destmode;
   n.wframegensync(index).inputs.dreg(31)           := '0';
   -- read clock domain: wclk,wrst (indexed)
   n.wframegensync(index).inputs.rclk := i.wclk(index); 
   n.wframegensync(index).inputs.rrst := i.wrst(index); 
   
   --
   -- Framegen: control bits (from tx_clk to wclk)
   -- 
   -- reg12.0  (rw): Framegen continuous-loop
   --
   -- reg12.1  (rw): Framegen trigger bit 1..15
   -- ..           : 
   -- reg12.15 (rw): 
   --
   -- reg12.31 (rw): Framegen enable
   --
   r.tx_clk.framegenloop        := i.fgen_loop; --&&& n.rfile.outputs.routvect(12)(0);
   r.tx_clk.framegentrig(index) := i.fgen_trig(index); --&&& n.rfile.outputs.routvect(12)(index);
   r.tx_clk.framegenena         := i.fgen_ena; --&&& n.rfile.outputs.routvect(12)(31);

   -- Framegen control bits distributed to all ports (from tx_clk to wclk(index))
   r.wclk(index).framegenloopI  := ro.tx_clk.framegenloop;
   r.wclk(index).framegenloopII := ro.wclk(index).framegenloopI;
   r.wclk(index).framegenloop   := ro.wclk(index).framegenloopII;

   r.wclk(index).framegentrigI  := ro.tx_clk.framegentrig(index);
   r.wclk(index).framegentrigII := ro.wclk(index).framegentrigI;
   r.wclk(index).framegentrig   := ro.wclk(index).framegentrigII;

   r.wclk(index).framegenenaI  := ro.tx_clk.framegenena;
   r.wclk(index).framegenenaII := ro.wclk(index).framegenenaI;
   r.wclk(index).framegenena   := ro.wclk(index).framegenenaII;

   --
   -- Framegen control
   --
   case ro.wclk(index).FSMframegen is
   when S0 =>
      --
      -- reset state
      --
      r.wclk(index).FSMframegen := S1;

   when S1 =>
      --
      -- init state (wait framegen enable + trigger condition)
      --
      if ro.wclk(index).framegenena = '1' and ro.wclk(index).framegentrig = '1' then
         -- framegen enabled + trigger
         -- NOTE: framegen mode will overwrite txport interface;
         -- framegen starts with current indexed port not enabled (forced flush operation)
         o.tport_wena(index)   := '0';
         o.tport_wreq(index)   := '0';
         o.tport_wtxreq(index) := '0';
         o.tport_wtxclr(index) := '0';
         -- framegen mode: standard interface forced to not ready state
         o.wready(index) := '0';
         -- continue
         r.wclk(index).FSMframegen := S2;
      else
         -- txport standard interface (defined by previously
         -- called procedure 'SubMain')
         null;
      end if;
    
      -- !! Debug !!
      if (ro.wclk(index).framegenena = '0') then
         -- 32bit global counter cleared when framegen not enabled
         r.wclk(index).counter := SLV(0, 32);
      end if;
      -- !! Debug !!      

   when S2 =>         
      --
      -- framegen enabled + trigger asserted            
      --

      -- framegen mode overwrites txport interface:
      -- indexed port enabled, write interface forced to not ready state 
      o.tport_wena(index)   := '1';
      o.tport_wreq(index)   := '0';
      o.tport_wtxreq(index) := '0';
      o.tport_wtxclr(index) := '0';
      o.wready(index)       := '0';
      --
      if ro.wclk(index).framegenena = '1' then
         -- frameloop init  
         r.wclk(index).framecount := SLV(0, 16+1); -- up counter, msb-test, 65536 frames will be transmitted
         r.wclk(index).frameloop  := SLV(28+10, 16); -- up counter, wframelen(46..1500) = header(28+10) + data(8..1462) 
         r.wclk(index).FSMframegen := S3;
      else
         -- framegen not enabled 
         r.wclk(index).FSMframegen := S4;
      end if;  

   when S3 =>         
      --
      -- frame loop          
      --

      -- framegen mode overwrites txport interface:
      -- indexed port enabled, write interface forced to not ready state 
      o.tport_wena(index)   := '1';
      o.tport_wreq(index)   := '0';
      o.tport_wtxreq(index) := '0';
      o.tport_wtxclr(index) := '0';
      o.wready(index)       := '0';
      --
      if ro.wclk(index).framegenena = '1' then
         -- loop test
         if ro.wclk(index).framecount(16) = '1' then
            -- loop done: restart
            r.wclk(index).FSMframegen := S3_1;
         elsif UINT(ro.wclk(index).frameloop) < UINT(n.wframegensync(index).outputs.qreg(10 downto 0)) then 
            -- in-frame-loop in progress
            if i.tport_wready(index) = '1' and i.tport_wfull(index) = '0' then
               -- tx port ready: current frameloop written to wdata input   
               o.tport_wreq(index)  := '1';
               o.tport_wdata(index) := SLV(UINT(ro.wclk(index).frameloop), o.tport_wdata(index)'length);
               -- write done, next
               r.wclk(index).frameloop := SLV(UINT(ro.wclk(index).frameloop) + o.tport_wdata(index)'length / 8, r.wclk(index).frameloop);
               -- note: wdata'length assumed as byte multiple (8,16,24,32)
               -- !! Debug !! 
               -- 32bit global counter overwrites first 4 bytes (applied when 8bit wdata)
               if (o.tport_wdata(index)'length = 8)then 
                  if UINT(ro.wclk(index).frameloop) = (28+10 + 0) then
                     o.tport_wdata(index) := ro.wclk(index).counter(7 downto 0);               
                  elsif UINT(ro.wclk(index).frameloop) = (28+10 + 1) then
                     o.tport_wdata(index) := ro.wclk(index).counter(15 downto 8);               
                  elsif UINT(ro.wclk(index).frameloop) = (28+10 + 2) then
                     o.tport_wdata(index) := ro.wclk(index).counter(23 downto 16);               
                  elsif UINT(ro.wclk(index).frameloop) = (28+10 + 3) then
                     o.tport_wdata(index) := ro.wclk(index).counter(31 downto 24);                
                  end if;
               else 
                  null;
               end if;
               -- !! Debug !! 
            else 
               -- txport not ready | txport full: waiting for free space
               null;
            end if;
         elsif i.tport_wready(index) = '1' then
            -- in-frame-loop done: transmission request for current frame using common params
            o.tport_wtxreq(index) := '1';
            o.tport_wframelen(index) := n.wframegensync(index).outputs.qreg(10 downto 0);
            o.tport_wdestaddr(index) := n.wframegensync(index).outputs.qreg(23 downto 16);
            -- !! Debug !! 
            -- programmable 'destport' (constant destport | global counter modulo 2,4,8,16)   
            if UINT(n.wframegensync(index).outputs.qreg(30 downto 28)) = 0 then 
               -- default mode (constant destport)
               o.tport_wdestport(index) := n.wframegensync(index).outputs.qreg(27 downto 24);
            elsif UINT(n.wframegensync(index).outputs.qreg(30 downto 28)) = 1 then
               -- destport taken from global counter (mod 2)
               o.tport_wdestport(index) := "000" & ro.wclk(index).counter(0);
            elsif UINT(n.wframegensync(index).outputs.qreg(30 downto 28)) = 2 then
               -- destport taken from global counter (mod 4)
               o.tport_wdestport(index) := "00" & ro.wclk(index).counter(1 downto 0);
            elsif UINT(n.wframegensync(index).outputs.qreg(30 downto 28)) = 3 then
               -- destport taken from global counter (mod 8)
               o.tport_wdestport(index) := '0' & ro.wclk(index).counter(2 downto 0);
            elsif UINT(n.wframegensync(index).outputs.qreg(30 downto 28)) = 4 then
               -- destport taken from global counter (mod 16)
               o.tport_wdestport(index) := ro.wclk(index).counter(3 downto 0);
            else
               -- default mode: constant destport
               o.tport_wdestport(index) := n.wframegensync(index).outputs.qreg(27 downto 24);
            end if;
            -- counter++ 
            r.wclk(index).counter := SLV(SLV(ro.wclk(index).counter) + 1, 32); 
            -- !! Debug !! 
            --
            o.tport_wmulticast(index) := '0';
            -- in-frame loop done: next 
            r.wclk(index).frameloop  := SLV(28+10, r.wclk(index).frameloop'length);
            r.wclk(index).framecount := SLV(UINT(ro.wclk(index).framecount) + 1, r.wclk(index).framecount'length);
         else
            -- txport not ready: waiting for free space
            null;      
         end if;  
      else
         -- framegen disabled
         r.wclk(index).FSMframegen := S4;
      end if;  

   when S3_1 =>         
      --
      -- loop done: restart test           
      --

      -- framegen mode overwrites txport interface:
      -- indexed port enabled, write interface forced to not ready state 
      o.tport_wena(index)   := '1';
      o.tport_wreq(index)   := '0';
      o.tport_wtxreq(index) := '0';
      o.tport_wtxclr(index) := '0';
      o.wready(index)       := '0';
      --
      if ro.wclk(index).framegenena = '1' then
         -- framegen enabled
         if ro.wclk(index).framegenloop = '1' then
            -- continuous loop mode: restart
            r.wclk(index).FSMframegen := S2;
         else
            -- single loop mode: trigger test
            if ro.wclk(index).framegentrig = '0' then
               -- trigger deasserted, restart
               r.wclk(index).FSMframegen := S1;
            else
               -- trigger asserted, wait negedge     
               null;
            end if;
         end if;
      else
         -- framegen disabled
         r.wclk(index).FSMframegen := S4;
      end if;  

   when S4 =>         
      --
      -- framegen not enabled: framegen ends with indexed port not enabled
      -- (forced flush operation)
      --
      o.tport_wena(index)   := '0';
      o.tport_wreq(index)   := '0';
      o.tport_wtxreq(index) := '0';
      o.tport_wtxclr(index) := '0';
      o.wready(index)       := '0';

      -- framegen not enabled: return to init state
      r.wclk(index).FSMframegen := S1;
   
   end case; 
END LOOP;

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
   FOR index IN 1 TO txport1_NPORTS LOOP
      n.wframegensync(index).outputs := allcmps.wframegensync(index).outputs;
   END LOOP;

   --
   -- all procedures call (edit)
   --
   -- all clock domains
   SubMain(i, ri, ro, o, r, n);
   SubFramegen(i, ri, ro, o, r, n);
   -- !!! SubFramegen MUST be called after SubMain !!!

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
-- architecture rtl of framegen
--
--**************************************************************

