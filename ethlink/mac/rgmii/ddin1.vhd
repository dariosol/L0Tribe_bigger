--**************************************************************
--**************************************************************
--
-- Template file: compmap1.rec (Std --> RecType)
--
--**************************************************************
--**************************************************************
--
--
-- Component ddin1  
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

package component_ddin1 is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- ddin1 inputs (constant)
--
type ddin1_inputs_t is record

   -- input list
   aclr : STD_LOGIC;
   datain : STD_LOGIC_VECTOR (4 DOWNTO 0);
   inclock : STD_LOGIC;

end record;

--
-- ddin1 outputs (constant)
--
type ddin1_outputs_t is record

   -- output list
   dataout_h : STD_LOGIC_VECTOR (4 DOWNTO 0);
   dataout_l : STD_LOGIC_VECTOR (4 DOWNTO 0);

end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- ddin1 component common interface (constant)
--
type ddin1_t is record
   inputs : ddin1_inputs_t;
   outputs : ddin1_outputs_t;
end record;

--
-- ddin1 component declaration (constant)
--
component ddin1
port (
   inputs : in ddin1_inputs_t;
   outputs : out ddin1_outputs_t
);
end component;

end component_ddin1;

--
-- ddin1 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_ddin1.all;

-- ddin1 entity (constant)
entity ddin1 is
port (
   inputs : in ddin1_inputs_t;
   outputs : out ddin1_outputs_t
);
end ddin1;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of ddin1 is

--
-- altddin1 component declaration (constant)
--
component altddin1
port
(
   aclr : in STD_LOGIC  := '0';
   datain : in STD_LOGIC_VECTOR (4 DOWNTO 0);
   inclock : in STD_LOGIC;
   dataout_h : out STD_LOGIC_VECTOR (4 DOWNTO 0);
   dataout_l : out STD_LOGIC_VECTOR (4 DOWNTO 0)
);
end component;

begin

--
-- component port map (constant)
--
altddin1_inst : altddin1 port map
(
   aclr => inputs.aclr,
   datain => inputs.datain,
   inclock => inputs.inclock,
   dataout_h => outputs.dataout_h,
   dataout_l => outputs.dataout_l
);

end rtl;
