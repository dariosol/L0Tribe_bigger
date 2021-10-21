--**************************************************************
--**************************************************************
--
-- Template file: compmap1.rec (Std --> RecType)
--
--**************************************************************
--**************************************************************
--
--
-- Component pll_refclk  
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

package component_pll_refclk is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- pll_refclk inputs (constant)
--
type pll_refclk_inputs_t is record

   -- input list
   areset : STD_LOGIC;
   inclk0 : STD_LOGIC;

end record;

--
-- pll_refclk outputs (constant)
--
type pll_refclk_outputs_t is record

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
-- pll_refclk component common interface (constant)
--
type pll_refclk_t is record
   inputs : pll_refclk_inputs_t;
   outputs : pll_refclk_outputs_t;
end record;

--
-- pll_refclk component declaration (constant)
--
component pll_refclk
port (
   inputs : in pll_refclk_inputs_t;
   outputs : out pll_refclk_outputs_t
);
end component;

end component_pll_refclk;

--
-- pll_refclk entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_pll_refclk.all;

-- pll_refclk entity (constant)
entity pll_refclk is
port (
   inputs : in pll_refclk_inputs_t;
   outputs : out pll_refclk_outputs_t
);
end pll_refclk;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of pll_refclk is

--
-- altpll_refclk component declaration (constant)
--
component altpll_refclk
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
altpll_refclk_inst : altpll_refclk port map
(
   areset => inputs.areset,
   inclk0 => inputs.inclk0,
   c0 => outputs.c0,
   locked => outputs.locked
);

end rtl;
