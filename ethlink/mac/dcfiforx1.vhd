--**************************************************************
--**************************************************************
--
-- Template file: compmap1.rec (Std --> RecType)
--
--**************************************************************
--**************************************************************
--
--
-- Component dcfiforx1  
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

package component_dcfiforx1 is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- dcfiforx1 inputs (constant)
--
type dcfiforx1_inputs_t is record

   -- input list
   aclr : STD_LOGIC;
   data : STD_LOGIC_VECTOR (7 DOWNTO 0);
   rdclk : STD_LOGIC;
   rdreq : STD_LOGIC;
   wrclk : STD_LOGIC;
   wrreq : STD_LOGIC;

end record;

--
-- dcfiforx1 outputs (constant)
--
type dcfiforx1_outputs_t is record

   -- output list
   q : STD_LOGIC_VECTOR (7 DOWNTO 0);
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
-- dcfiforx1 component common interface (constant)
--
type dcfiforx1_t is record
   inputs : dcfiforx1_inputs_t;
   outputs : dcfiforx1_outputs_t;
end record;

--
-- dcfiforx1 vector type (constant)
--
type dcfiforx1_vector_t is array(NATURAL RANGE <>) of dcfiforx1_t;

--
-- dcfiforx1 component declaration (constant)
--
component dcfiforx1
port (
   inputs : in dcfiforx1_inputs_t;
   outputs : out dcfiforx1_outputs_t
);
end component;

--
-- dcfiforx1 global signal to export range/width params (constant)
--
signal component_dcfiforx1 : dcfiforx1_t;

end component_dcfiforx1;

--
-- dcfiforx1 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_dcfiforx1.all;

-- dcfiforx1 entity (constant)
entity dcfiforx1 is
port (
   inputs : in dcfiforx1_inputs_t;
   outputs : out dcfiforx1_outputs_t
);
end dcfiforx1;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of dcfiforx1 is

--
-- altdcfiforx1 component declaration (constant)
--
component altdcfiforx1
port
(
   aclr : in STD_LOGIC  := '0';
   data : in STD_LOGIC_VECTOR (7 DOWNTO 0);
   rdclk : in STD_LOGIC;
   rdreq : in STD_LOGIC;
   wrclk : in STD_LOGIC;
   wrreq : in STD_LOGIC;
   q : out STD_LOGIC_VECTOR (7 DOWNTO 0);
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
altdcfiforx1_inst : altdcfiforx1 port map
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
