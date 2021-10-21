--**************************************************************
--**************************************************************
--
-- Template file: compmap1.rec (Std --> RecType)
--
--**************************************************************
--**************************************************************
--
--
-- Component dcfifo2  
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

package component_dcfifo2 is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- dcfifo2 inputs (constant)
--
type dcfifo2_inputs_t is record

   -- input list
   aclr : STD_LOGIC;
   data : STD_LOGIC_VECTOR (47 DOWNTO 0);
   rdclk : STD_LOGIC;
   rdreq : STD_LOGIC;
   wrclk : STD_LOGIC;
   wrreq : STD_LOGIC;

end record;

--
-- dcfifo2 outputs (constant)
--
type dcfifo2_outputs_t is record

   -- output list
   q : STD_LOGIC_VECTOR (47 DOWNTO 0);
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
-- dcfifo2 component common interface (constant)
--
type dcfifo2_t is record
   inputs : dcfifo2_inputs_t;
   outputs : dcfifo2_outputs_t;
end record;

--
-- dcfifo2 vector type (constant)
--
type dcfifo2_vector_t is array(NATURAL RANGE <>) of dcfifo2_t;

--
-- dcfifo2 component declaration (constant)
--
component dcfifo2
port (
   inputs : in dcfifo2_inputs_t;
   outputs : out dcfifo2_outputs_t
);
end component;

--
-- dcfifo2 global signal to export params (constant)
--
signal component_dcfifo2 : dcfifo2_t;

end component_dcfifo2;

--
-- dcfifo2 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_dcfifo2.all;

-- dcfifo2 entity (constant)
entity dcfifo2 is
port (
   inputs : in dcfifo2_inputs_t;
   outputs : out dcfifo2_outputs_t
);
end dcfifo2;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of dcfifo2 is

--
-- altdcfifo2 component declaration (constant)
--
component altdcfifo2
port
(
   aclr : in STD_LOGIC  := '0';
   data : in STD_LOGIC_VECTOR (47 DOWNTO 0);
   rdclk : in STD_LOGIC;
   rdreq : in STD_LOGIC;
   wrclk : in STD_LOGIC;
   wrreq : in STD_LOGIC;
   q : out STD_LOGIC_VECTOR (47 DOWNTO 0);
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
altdcfifo2_inst : altdcfifo2 port map
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
