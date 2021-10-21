--**************************************************************
--**************************************************************
--
-- Template file: compmap1.rec (Std --> RecType)
--
--**************************************************************
--**************************************************************
--
--
-- Component rxdatabuf1  
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

package component_rxdatabuf1 is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- rxdatabuf1 inputs (constant)
--
type rxdatabuf1_inputs_t is record

   -- input list
   aclr : STD_LOGIC;
   data : STD_LOGIC_VECTOR (9 DOWNTO 0);
   rdclk : STD_LOGIC;
   rdreq : STD_LOGIC;
   wrclk : STD_LOGIC;
   wrreq : STD_LOGIC;

end record;

--
-- rxdatabuf1 outputs (constant)
--
type rxdatabuf1_outputs_t is record

   -- output list
   q : STD_LOGIC_VECTOR (9 DOWNTO 0);
   rdempty : STD_LOGIC;
   rdfull : STD_LOGIC;
   rdusedw : STD_LOGIC_VECTOR (12 DOWNTO 0);
   wrempty : STD_LOGIC;
   wrfull : STD_LOGIC;
   wrusedw : STD_LOGIC_VECTOR (12 DOWNTO 0);

end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- rxdatabuf1 component common interface (constant)
--
type rxdatabuf1_t is record
   inputs : rxdatabuf1_inputs_t;
   outputs : rxdatabuf1_outputs_t;
end record;

--
-- rxdatabuf1 vector type (constant)
--
type rxdatabuf1_vector_t is array(NATURAL RANGE <>) of rxdatabuf1_t;

--
-- rxdatabuf1 component declaration (constant)
--
component rxdatabuf1
port (
   inputs : in rxdatabuf1_inputs_t;
   outputs : out rxdatabuf1_outputs_t
);
end component;

--
-- rxdatabuf1 global signal to export range/width params (constant)
--
signal component_rxdatabuf1 : rxdatabuf1_t;

end component_rxdatabuf1;

--
-- rxdatabuf1 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_rxdatabuf1.all;

-- rxdatabuf1 entity (constant)
entity rxdatabuf1 is
port (
   inputs : in rxdatabuf1_inputs_t;
   outputs : out rxdatabuf1_outputs_t
);
end rxdatabuf1;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of rxdatabuf1 is

--
-- altrxdatabuf1 component declaration (constant)
--
component altrxdatabuf1
port
(
   aclr : in STD_LOGIC  := '0';
   data : in STD_LOGIC_VECTOR (9 DOWNTO 0);
   rdclk : in STD_LOGIC;
   rdreq : in STD_LOGIC;
   wrclk : in STD_LOGIC;
   wrreq : in STD_LOGIC;
   q : out STD_LOGIC_VECTOR (9 DOWNTO 0);
   rdempty : out STD_LOGIC;
   rdfull : out STD_LOGIC;
   rdusedw : out STD_LOGIC_VECTOR (12 DOWNTO 0);
   wrempty : out STD_LOGIC;
   wrfull : out STD_LOGIC;
   wrusedw : out STD_LOGIC_VECTOR (12 DOWNTO 0)
);
end component;

begin

--
-- component port map (constant)
--
altrxdatabuf1_inst : altrxdatabuf1 port map
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
