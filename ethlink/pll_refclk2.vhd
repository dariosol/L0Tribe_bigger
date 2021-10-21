--**************************************************************
--**************************************************************
--
-- Template file: compmap1.rec (Std --> RecType)
--
--**************************************************************
--**************************************************************
--
--
-- Component pll_refclk2  
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

package component_pll_refclk2 is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- pll_refclk2 inputs (constant)
--
type pll_refclk2_inputs_t is record

   -- input list
   areset : STD_LOGIC;
   inclk0 : STD_LOGIC;
end record;

--
-- pll_refclk2 outputs (constant)
--
type pll_refclk2_outputs_t is record

   -- output list
   c0 : STD_LOGIC;
   locked : STD_LOGIC;

end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- pll_refclk2 component common interface (constant)
--
type pll_refclk2_t is record
   inputs : pll_refclk2_inputs_t;
   outputs : pll_refclk2_outputs_t;
end record;

--
-- pll_refclk2 component declaration (constant)
--
component pll_refclk2
port (
   inputs : in pll_refclk2_inputs_t;
   outputs : out pll_refclk2_outputs_t
);
end component;

end component_pll_refclk2;

--
-- pll_refclk2 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_pll_refclk2.all;

-- pll_refclk2 entity (constant)
entity pll_refclk2 is
port (
   inputs : in pll_refclk2_inputs_t;
   outputs : out pll_refclk2_outputs_t
);
end pll_refclk2;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of pll_refclk2 is

--
-- altpll_refclk22 component declaration (constant)
--
component altpll_refclk2
port
(
   areset : in STD_LOGIC  := '0';
   inclk0 : in STD_LOGIC  := '0';
   c0 : out STD_LOGIC;
   locked : out STD_LOGIC
);
end component;

begin

--
-- component port map (constant)
--
altpll_refclk2_inst : altpll_refclk2 port map
(
   areset => inputs.areset,
   inclk0 => inputs.inclk0,
   c0 => outputs.c0,
   locked => outputs.locked
);

end rtl;
