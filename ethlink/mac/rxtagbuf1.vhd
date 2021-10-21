--**************************************************************
--**************************************************************
--
-- Template file: compmap1.rec (Std --> RecType)
--
--**************************************************************
--**************************************************************
--
--
-- Component rxtagbuf1  
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package component_rxtagbuf1 is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- rxtagbuf1 inputs (constant)
--
type rxtagbuf1_inputs_t is record

   -- input list
   aclr : STD_LOGIC;
   data : STD_LOGIC_VECTOR (15 DOWNTO 0);
   rdclk : STD_LOGIC;
   rdreq : STD_LOGIC;
   wrclk : STD_LOGIC;
   wrreq : STD_LOGIC;

end record;

--
-- rxtagbuf1 outputs (constant)
--
type rxtagbuf1_outputs_t is record

   -- output list
   q : STD_LOGIC_VECTOR (15 DOWNTO 0);
   rdempty : STD_LOGIC;
   rdfull : STD_LOGIC;
   rdusedw : STD_LOGIC_VECTOR (8 DOWNTO 0);
   wrempty : STD_LOGIC;
   wrfull : STD_LOGIC;
   wrusedw : STD_LOGIC_VECTOR (8 DOWNTO 0);

end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- rxtagbuf1 component common interface (constant)
--
type rxtagbuf1_t is record
   inputs : rxtagbuf1_inputs_t;
   outputs : rxtagbuf1_outputs_t;
end record;

--
-- rxtagbuf1 vector type (constant)
--
type rxtagbuf1_vector_t is array(NATURAL RANGE <>) of rxtagbuf1_t;

--
-- rxtagbuf1 component declaration (constant)
--
component rxtagbuf1
port (
   inputs : in rxtagbuf1_inputs_t;
   outputs : out rxtagbuf1_outputs_t
);
end component;

--
-- rxtagbuf1 global signal to export range/width params (constant)
--
signal component_rxtagbuf1 : rxtagbuf1_t;

end component_rxtagbuf1;

--
-- rxtagbuf1 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_rxtagbuf1.all;

-- rxtagbuf1 entity (constant)
entity rxtagbuf1 is
port (
   inputs : in rxtagbuf1_inputs_t;
   outputs : out rxtagbuf1_outputs_t
);
end rxtagbuf1;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of rxtagbuf1 is

--
-- altrxtagbuf1 component declaration (constant)
--
component altrxtagbuf1
port
(
   aclr : in STD_LOGIC  := '0';
   data : in STD_LOGIC_VECTOR (15 DOWNTO 0);
   rdclk : in STD_LOGIC;
   rdreq : in STD_LOGIC;
   wrclk : in STD_LOGIC;
   wrreq : in STD_LOGIC;
   q : out STD_LOGIC_VECTOR (15 DOWNTO 0);
   rdempty : out STD_LOGIC;
   rdfull : out STD_LOGIC;
   rdusedw : out STD_LOGIC_VECTOR (8 DOWNTO 0);
   wrempty : out STD_LOGIC;
   wrfull : out STD_LOGIC;
   wrusedw : out STD_LOGIC_VECTOR (8 DOWNTO 0)
);
end component;

begin

--
-- component port map (constant)
--
altrxtagbuf1_inst : altrxtagbuf1 port map
(
   aclr => inputs.aclr,
   data => inputs.data,
   rdclk => inputs.rdclk,
   rdreq => inputs.rdreq,
   wrclk => inputs.wrclk,
   wrreq => inputs.wrreq,
   q => outputs.q,
   rdempty => outputs.rdempty,
   rdfull => outputs.rdfull,
   rdusedw => outputs.rdusedw,
   wrempty => outputs.wrempty,
   wrfull => outputs.wrfull,
   wrusedw => outputs.wrusedw
);

end rtl;
