--**************************************************************
--**************************************************************
--
-- Template file: compmap1.rec (Std --> RecType)
--
--**************************************************************
--**************************************************************
--
--
-- Component sgmii1  
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

package component_sgmii1 is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- sgmii1 inputs (constant)
--
type sgmii1_inputs_t is record

   -- input list
   gmii_tx_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
   gmii_tx_en : STD_LOGIC;
   gmii_tx_err : STD_LOGIC;
   reset_tx_clk : STD_LOGIC;
   reset_rx_clk : STD_LOGIC;
   address : STD_LOGIC_VECTOR (4 DOWNTO 0);
   read : STD_LOGIC;
   writedata : STD_LOGIC_VECTOR (15 DOWNTO 0);
   write : STD_LOGIC;
   clk : STD_LOGIC;
   reset : STD_LOGIC;
   rxp : STD_LOGIC;
   ref_clk : STD_LOGIC;

end record;

--
-- sgmii1 outputs (constant)
--
type sgmii1_outputs_t is record

   -- output list
   gmii_rx_d : STD_LOGIC_VECTOR (7 DOWNTO 0);
   gmii_rx_dv : STD_LOGIC;
   gmii_rx_err : STD_LOGIC;
   tx_clk : STD_LOGIC;
   rx_clk : STD_LOGIC;
   readdata : STD_LOGIC_VECTOR (15 DOWNTO 0);
   waitrequest : STD_LOGIC;
   txp : STD_LOGIC;
   led_an : STD_LOGIC;
   led_disp_err : STD_LOGIC;
   led_char_err : STD_LOGIC;
   led_link : STD_LOGIC;

end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- sgmii1 component common interface (constant)
--
type sgmii1_t is record
   inputs : sgmii1_inputs_t;
   outputs : sgmii1_outputs_t;
end record;

--
-- sgmii1 component declaration (constant)
--
component sgmii1
port (
   inputs : in sgmii1_inputs_t;
   outputs : out sgmii1_outputs_t
);
end component;

end component_sgmii1;

--
-- sgmii1 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_sgmii1.all;

-- sgmii1 entity (constant)
entity sgmii1 is
port (
   inputs : in sgmii1_inputs_t;
   outputs : out sgmii1_outputs_t
);
end sgmii1;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of sgmii1 is

--
-- alttse1 component declaration (constant)
--
component alttse1
port
(
   gmii_tx_d : in STD_LOGIC_VECTOR (7 DOWNTO 0);
   gmii_tx_en : in STD_LOGIC;
   gmii_tx_err : in STD_LOGIC;
   reset_tx_clk : in STD_LOGIC;
   reset_rx_clk : in STD_LOGIC;
   address : in STD_LOGIC_VECTOR (4 DOWNTO 0);
   read : in STD_LOGIC;
   writedata : in STD_LOGIC_VECTOR (15 DOWNTO 0);
   write : in STD_LOGIC;
   clk : in STD_LOGIC;
   reset : in STD_LOGIC;
   rxp : in STD_LOGIC;
   ref_clk : in STD_LOGIC;
   gmii_rx_d : out STD_LOGIC_VECTOR (7 DOWNTO 0);
   gmii_rx_dv : out STD_LOGIC;
   gmii_rx_err : out STD_LOGIC;
   tx_clk : out STD_LOGIC;
   rx_clk : out STD_LOGIC;
   readdata : out STD_LOGIC_VECTOR (15 DOWNTO 0);
   waitrequest : out STD_LOGIC;
   txp : out STD_LOGIC;
   led_an : out STD_LOGIC;
   led_disp_err : out STD_LOGIC;
   led_char_err : out STD_LOGIC;
   led_link : out STD_LOGIC
);
end component;

begin

--
-- component port map (constant)
--
alttse1_inst : alttse1 port map
(
   gmii_tx_d => inputs.gmii_tx_d,
   gmii_tx_en => inputs.gmii_tx_en,
   gmii_tx_err => inputs.gmii_tx_err,
   reset_tx_clk => inputs.reset_tx_clk,
   reset_rx_clk => inputs.reset_rx_clk,
   address => inputs.address,
   read => inputs.read,
   writedata => inputs.writedata,
   write => inputs.write,
   clk => inputs.clk,
   reset => inputs.reset,
   rxp => inputs.rxp,
   ref_clk => inputs.ref_clk,
   gmii_rx_d => outputs.gmii_rx_d,
   gmii_rx_dv => outputs.gmii_rx_dv,
   gmii_rx_err => outputs.gmii_rx_err,
   tx_clk => outputs.tx_clk,
   rx_clk => outputs.rx_clk,
   readdata => outputs.readdata,
   waitrequest => outputs.waitrequest,
   txp => outputs.txp,
   led_an => outputs.led_an,
   led_disp_err => outputs.led_disp_err,
   led_char_err => outputs.led_char_err,
   led_link => outputs.led_link
);

end rtl;
