--**************************************************************
--**************************************************************
--
-- Template file: compmap1.rec (Std --> RecType)
--
--**************************************************************
--**************************************************************
--
--
-- Component dpram2  
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

package component_dpram2 is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- dpram2 inputs (constant)
--
type dpram2_inputs_t is record

   -- input list
   clock : STD_LOGIC;
   data : STD_LOGIC_VECTOR (7 DOWNTO 0);
   rdaddress : STD_LOGIC_VECTOR (6 DOWNTO 0);
   wraddress : STD_LOGIC_VECTOR (6 DOWNTO 0);
   wren : STD_LOGIC;

end record;

--
-- dpram2 outputs (constant)
--
type dpram2_outputs_t is record

   -- output list
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
-- dpram2 component common interface (constant)
--
type dpram2_t is record
   inputs : dpram2_inputs_t;
   outputs : dpram2_outputs_t;
end record;

--
-- dpram2 vector type (constant)
--
type dpram2_vector_t is array(NATURAL RANGE <>) of dpram2_t;

--
-- dpram2 component declaration (constant)
--
component dpram2
port (
   inputs : in dpram2_inputs_t;
   outputs : out dpram2_outputs_t
);
end component;

--
-- dpram2 global signal to export params (constant)
--
signal component_dpram2 : dpram2_t;

end component_dpram2;

--
-- dpram2 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_dpram2.all;

-- dpram2 entity (constant)
entity dpram2 is
port (
   inputs : in dpram2_inputs_t;
   outputs : out dpram2_outputs_t
);
end dpram2;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of dpram2 is

--
-- altdpram2 component declaration (constant)
--
component altdpram2
port
(
   clock : in STD_LOGIC;
   data : in STD_LOGIC_VECTOR (7 DOWNTO 0);
   rdaddress : in STD_LOGIC_VECTOR (6 DOWNTO 0);
   wraddress : in STD_LOGIC_VECTOR (6 DOWNTO 0);
   wren : in STD_LOGIC  := '1';
   q : out STD_LOGIC_VECTOR (7 DOWNTO 0)
);
end component;

begin

--
-- component port map (constant)
--
altdpram2_inst : altdpram2 port map
(
   clock => inputs.clock,
   data => inputs.data,
   rdaddress => inputs.rdaddress,
   wraddress => inputs.wraddress,
   wren => inputs.wren,
   q => outputs.q
);

end rtl;
