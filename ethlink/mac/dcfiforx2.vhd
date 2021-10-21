--**************************************************************
--**************************************************************
--
-- Template file: compmap1.rec (Std --> RecType)
--
--**************************************************************
--**************************************************************
--
--
-- Component dcfiforx2  
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

package component_dcfiforx2 is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- dcfiforx2 inputs (constant)
--
type dcfiforx2_inputs_t is record

   -- input list
   aclr : STD_LOGIC;
   data : STD_LOGIC_VECTOR (63 DOWNTO 0);
   rdclk : STD_LOGIC;
   rdreq : STD_LOGIC;
   wrclk : STD_LOGIC;
   wrreq : STD_LOGIC;

end record;

--
-- dcfiforx2 outputs (constant)
--
type dcfiforx2_outputs_t is record

   -- output list
   q : STD_LOGIC_VECTOR (63 DOWNTO 0);
   rdempty : STD_LOGIC;
   rdfull : STD_LOGIC;
   rdusedw : STD_LOGIC_VECTOR (4 DOWNTO 0);
   wrempty : STD_LOGIC;
   wrfull : STD_LOGIC;
   wrusedw : STD_LOGIC_VECTOR (4 DOWNTO 0);

end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- dcfiforx2 component common interface (constant)
--
type dcfiforx2_t is record
   inputs : dcfiforx2_inputs_t;
   outputs : dcfiforx2_outputs_t;
end record;

--
-- dcfiforx2 vector type (constant)
--
type dcfiforx2_vector_t is array(NATURAL RANGE <>) of dcfiforx2_t;

--
-- dcfiforx2 component declaration (constant)
--
component dcfiforx2
port (
   inputs : in dcfiforx2_inputs_t;
   outputs : out dcfiforx2_outputs_t
);
end component;

--
-- dcfiforx2 global signal to export range/width params (constant)
--
signal component_dcfiforx2 : dcfiforx2_t;

end component_dcfiforx2;

--
-- dcfiforx2 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_dcfiforx2.all;

-- dcfiforx2 entity (constant)
entity dcfiforx2 is
port (
   inputs : in dcfiforx2_inputs_t;
   outputs : out dcfiforx2_outputs_t
);
end dcfiforx2;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of dcfiforx2 is

--
-- altdcfiforx2 component declaration (constant)
--
component altdcfiforx2
port
(
   aclr : in STD_LOGIC  := '0';
   data : in STD_LOGIC_VECTOR (63 DOWNTO 0);
   rdclk : in STD_LOGIC;
   rdreq : in STD_LOGIC;
   wrclk : in STD_LOGIC;
   wrreq : in STD_LOGIC;
   q : out STD_LOGIC_VECTOR (63 DOWNTO 0);
   rdempty : out STD_LOGIC;
   rdfull : out STD_LOGIC;
   rdusedw : out STD_LOGIC_VECTOR (4 DOWNTO 0);
   wrempty : out STD_LOGIC;
   wrfull : out STD_LOGIC;
   wrusedw : out STD_LOGIC_VECTOR (4 DOWNTO 0)
);
end component;

begin

--
-- component port map (constant)
--
altdcfiforx2_inst : altdcfiforx2 port map
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
