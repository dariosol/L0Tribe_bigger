--**************************************************************
--**************************************************************
--
-- Template file: compmap1.rec (Std --> RecType)
--
--**************************************************************
--**************************************************************
--
--
-- Component ddout1  
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

package component_ddout1 is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- ddout1 inputs (constant)
--
type ddout1_inputs_t is record

   -- input list
   aclr : STD_LOGIC;
   datain_h : STD_LOGIC_VECTOR (5 DOWNTO 0);
   datain_l : STD_LOGIC_VECTOR (5 DOWNTO 0);
   outclock : STD_LOGIC;

end record;

--
-- ddout1 outputs (constant)
--
type ddout1_outputs_t is record

   -- output list
   dataout : STD_LOGIC_VECTOR (5 DOWNTO 0);

end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- ddout1 component common interface (constant)
--
type ddout1_t is record
   inputs : ddout1_inputs_t;
   outputs : ddout1_outputs_t;
end record;

--
-- ddout1 component declaration (constant)
--
component ddout1
port (
   inputs : in ddout1_inputs_t;
   outputs : out ddout1_outputs_t
);
end component;

end component_ddout1;

--
-- ddout1 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_ddout1.all;

-- ddout1 entity (constant)
entity ddout1 is
port (
   inputs : in ddout1_inputs_t;
   outputs : out ddout1_outputs_t
);
end ddout1;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of ddout1 is

--
-- altddout1 component declaration (constant)
--
component altddout1
port
(
   aclr : in STD_LOGIC  := '0';
   datain_h : in STD_LOGIC_VECTOR (5 DOWNTO 0);
   datain_l : in STD_LOGIC_VECTOR (5 DOWNTO 0);
   outclock : in STD_LOGIC;
   dataout : out STD_LOGIC_VECTOR (5 DOWNTO 0)
);
end component;

begin

--
-- component port map (constant)
--
altddout1_inst : altddout1 port map
(
   aclr => inputs.aclr,
   datain_h => inputs.datain_h,
   datain_l => inputs.datain_l,
   outclock => inputs.outclock,
   dataout => outputs.dataout
);

end rtl;
