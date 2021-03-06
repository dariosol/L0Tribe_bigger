library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package component_PrimitiveSerializer is

type PrimitiveSerializer_inputs_t is record

   -- input list
   clk   : STD_LOGIC;
   aclr  : STD_LOGIC;
   datain: STD_LOGIC_VECTOR (255 DOWNTO 0);
   rdreq : STD_LOGIC;
end record;

--
-- PrimitiveSerializer outputs (constant)
--
type PrimitiveSerializer_outputs_t is record

   -- output list
   dataout    : STD_LOGIC_VECTOR (31 DOWNTO 0);
   rdpointer  : STD_LOGIC_VECTOR(2 downto 0);
end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- PrimitiveSerializer component common interface (constant)
--
type PrimitiveSerializer_t is record
   inputs : PrimitiveSerializer_inputs_t;
   outputs : PrimitiveSerializer_outputs_t;
end record;

--
-- PrimitiveSerializer vector type (constant)
--
type PrimitiveSerializer_vector_t is array(NATURAL RANGE <>) of PrimitiveSerializer_t;

--
-- PrimitiveSerializer component declaration (constant)
--
component PrimitiveSerializer
port (
   inputs : in PrimitiveSerializer_inputs_t;
   outputs : out PrimitiveSerializer_outputs_t
);
end component;

--
-- PrimitiveSerializer global signal to export range/width params (constant)
--
signal component_PrimitiveSerializer : PrimitiveSerializer_t;

end component_PrimitiveSerializer;

--
-- PrimitiveSerializer entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_PrimitiveSerializer.all;

-- PrimitiveSerializer entity (constant)
entity PrimitiveSerializer is
port (
   inputs : in PrimitiveSerializer_inputs_t;
   outputs : out PrimitiveSerializer_outputs_t
);
end PrimitiveSerializer;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of PrimitiveSerializer is

--
-- altPrimitiveSerializer component declaration (constant)
--
component altPrimitiveSerializer
port
(
   aclr        : in STD_LOGIC  := '0';
   datain      : in STD_LOGIC_VECTOR (255 DOWNTO 0);
   clk         : in STD_LOGIC;
   rdreq       : in STD_LOGIC;
   rdpointer   : out STD_LOGIC_VECTOR(2 downto 0);
   dataout     : out STD_LOGIC_VECTOR (31 DOWNTO 0)
);
end component;

begin

--
-- component port map (constant)
--
altPrimitiveSerializer_inst : altPrimitiveSerializer port map
(
   aclr         => inputs.aclr,
   datain       => inputs.datain,
   clk          => inputs.clk,
   rdreq        => inputs.rdreq,
   dataout      => outputs.dataout,
   rdpointer    => outputs.rdpointer
   );

end rtl;
