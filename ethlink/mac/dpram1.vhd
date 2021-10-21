--**************************************************************
--**************************************************************
--
--
-- Component dpram1
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
-- Component Interface (package)
--
--
--**************************************************************

-- libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mac_globals.all;

package component_dpram1 is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- dpram1 inputs (edit)
--
type dpram1_inputs_t is record

   -- input list
   data : STD_LOGIC_VECTOR (TX_WDATA_WIDTH_MAX - 1 DOWNTO 0);
   rdaddress : STD_LOGIC_VECTOR (11 DOWNTO 0);
   rdclock : STD_LOGIC;
   wraddress : STD_LOGIC_VECTOR (11 DOWNTO 0);
   wrclock : STD_LOGIC;
   wren : STD_LOGIC;

end record;

--
-- dpram1 outputs (edit)
--
type dpram1_outputs_t is record

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
-- dpram1 component common interface (constant)
--
type dpram1_t is record
   inputs : dpram1_inputs_t;
   outputs : dpram1_outputs_t;
end record;

--
-- dpram1 vector type (constant)
--
type dpram1_vector_t is array(NATURAL RANGE <>) of dpram1_t;

--
-- dpram1 component declaration (edit)
--
component dpram1
generic (
   WDATA_WIDTH : natural
); 
port (
   inputs : in dpram1_inputs_t;
   outputs : out dpram1_outputs_t
);
end component;

--
-- dpram1 global signal to export range/width params (constant)
--
signal component_dpram1 : dpram1_t;

end component_dpram1;

--**************************************************************
--
--
-- Component Interface (entity)
--
--
--**************************************************************

--
-- dpram1 entity declaration
--

-- libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_dpram1.all;
 
-- dpram1 entity (edit)
entity dpram1 is
generic (
   WDATA_WIDTH : natural
); 
port (
   inputs : in dpram1_inputs_t;
   outputs : out dpram1_outputs_t
);
end dpram1;

--**************************************************************
--**************************************************************

--**************************************************************
--
--
-- Component Architecture
--
--
--**************************************************************

architecture rtl of dpram1 is

--**************************************************************
--
-- Architecture declaration begin 
--
--**************************************************************

--
-- altdpram1_8_8 component declaration (constant)
--
component altdpram1_8_8
port
(
   data : in STD_LOGIC_VECTOR (7 DOWNTO 0);
   rdaddress : in STD_LOGIC_VECTOR (11 DOWNTO 0);
   rdclock : in STD_LOGIC;
   wraddress : in STD_LOGIC_VECTOR (11 DOWNTO 0);
   wrclock : in STD_LOGIC;
   wren : in STD_LOGIC  := '1';
   q : out STD_LOGIC_VECTOR (7 DOWNTO 0)
);
end component;

--
-- altdpram1_16_8 component declaration (constant)
--
component altdpram1_16_8
port
(
   data : in STD_LOGIC_VECTOR (15 DOWNTO 0);
   rdaddress : in STD_LOGIC_VECTOR (11 DOWNTO 0);
   rdclock : in STD_LOGIC;
   wraddress : in STD_LOGIC_VECTOR (10 DOWNTO 0);
   wrclock : in STD_LOGIC;
   wren : in STD_LOGIC  := '1';
   q : out STD_LOGIC_VECTOR (7 DOWNTO 0)
);
end component;

--
-- altdpram1_32_8 component declaration (constant)
--
component altdpram1_32_8
port
(
   data : in STD_LOGIC_VECTOR (31 DOWNTO 0);
   rdaddress : in STD_LOGIC_VECTOR (11 DOWNTO 0);
   rdclock : in STD_LOGIC;
   wraddress : in STD_LOGIC_VECTOR (9 DOWNTO 0);
   wrclock : in STD_LOGIC;
   wren : in STD_LOGIC  := '1';
   q : out STD_LOGIC_VECTOR (7 DOWNTO 0)
);
end component;

--
-- altdpram1_64_8 component declaration (constant)
--
component altdpram1_64_8
port
(
   data : in STD_LOGIC_VECTOR (63 DOWNTO 0);
   rdaddress : in STD_LOGIC_VECTOR (11 DOWNTO 0);
   rdclock : in STD_LOGIC;
   wraddress : in STD_LOGIC_VECTOR (8 DOWNTO 0);
   wrclock : in STD_LOGIC  := '1';
   wren : in STD_LOGIC  := '0';
   q : out STD_LOGIC_VECTOR (7 DOWNTO 0)
);
end component;

--**************************************************************
--
-- Architecture declaration end 
--
--**************************************************************

--**************************************************************
--
-- architecture rtl of dpram1
--
--**************************************************************
begin

--**************************************************************
--
-- components instances (edit)
--
--**************************************************************

DPRAM_8_8 : IF (WDATA_WIDTH = 8) GENERATE
--
-- component port map (constant)
--
dpram1_inst : altdpram1_8_8 port map
(
   data => inputs.data(WDATA_WIDTH - 1 downto 0),
   rdaddress => inputs.rdaddress,
   rdclock => inputs.rdclock,
   wraddress => inputs.wraddress(11 downto 0),
   wrclock => inputs.wrclock,
   wren => inputs.wren,
   q => outputs.q
);
END GENERATE;

DPRAM_16_8 : IF (WDATA_WIDTH = 16) GENERATE
--
-- component port map (constant)
--
dpram1_inst : altdpram1_16_8 port map
(
   data => inputs.data(WDATA_WIDTH - 1 downto 0),
   rdaddress => inputs.rdaddress,
   rdclock => inputs.rdclock,
   wraddress => inputs.wraddress(10 downto 0),
   wrclock => inputs.wrclock,
   wren => inputs.wren,
   q => outputs.q
);
END GENERATE;

DPRAM_32_8 : IF (WDATA_WIDTH = 32) GENERATE
--
-- component port map (constant)
--
dpram1_inst : altdpram1_32_8 port map
(
   data => inputs.data(WDATA_WIDTH - 1 downto 0),
   rdaddress => inputs.rdaddress,
   rdclock => inputs.rdclock,
   wraddress => inputs.wraddress(9 downto 0),
   wrclock => inputs.wrclock,
   wren => inputs.wren,
   q => outputs.q
);
END GENERATE;

DPRAM_64_8 : IF (WDATA_WIDTH = 64) GENERATE
--
-- component port map (constant)
--
dpram1_inst : altdpram1_64_8 port map
(
   data => inputs.data(WDATA_WIDTH - 1 downto 0),
   rdaddress => inputs.rdaddress,
   rdclock => inputs.rdclock,
   wraddress => inputs.wraddress(8 downto 0),
   wrclock => inputs.wrclock,
   wren => inputs.wren,
   q => outputs.q
);
END GENERATE;

end rtl;
--**************************************************************
--
-- architecture rtl of dpram1
--
--**************************************************************
