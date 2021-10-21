--**************************************************************
--**************************************************************
--
-- Template file: compmap1.rec (Std --> RecType)
--
--**************************************************************
--**************************************************************
--
--
-- Component n2top1  
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

package component_n2top1 is

--**************************************************************
--
-- I/O section begin 
--
--**************************************************************

--
-- n2top1 inputs (constant)
--
type n2top1_inputs_t is record

   -- input list
   clk1 : STD_LOGIC;
   reset_n : STD_LOGIC;
   s_readdata_to_the_iobusMAC_0 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMAC_0 : STD_LOGIC;
   s_waitrequest_to_the_iobusMAC_0 : STD_LOGIC;
   s_readdata_to_the_iobusMAC_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMAC_1 : STD_LOGIC;
   s_waitrequest_to_the_iobusMAC_1 : STD_LOGIC;
   s_readdata_to_the_iobusMAC_2 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMAC_2 : STD_LOGIC;
   s_waitrequest_to_the_iobusMAC_2 : STD_LOGIC;
   s_readdata_to_the_iobusMAC_3 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMAC_3 : STD_LOGIC;
   s_waitrequest_to_the_iobusMAC_3 : STD_LOGIC;
   s_readdata_to_the_iobusMAC_4 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMAC_4 : STD_LOGIC;
   s_waitrequest_to_the_iobusMAC_4 : STD_LOGIC;
   s_readdata_to_the_iobusMAC_5 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMAC_5 : STD_LOGIC;
   s_waitrequest_to_the_iobusMAC_5 : STD_LOGIC;
   s_readdata_to_the_iobusMAC_6 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMAC_6 : STD_LOGIC;
   s_waitrequest_to_the_iobusMAC_6 : STD_LOGIC;
   s_readdata_to_the_iobusMAC_7 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMAC_7 : STD_LOGIC;
   s_waitrequest_to_the_iobusMAC_7 : STD_LOGIC;
   s_readdata_to_the_iobusMDIO_0 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMDIO_0 : STD_LOGIC;
   s_waitrequest_to_the_iobusMDIO_0 : STD_LOGIC;
   s_readdata_to_the_iobusMDIO_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMDIO_1 : STD_LOGIC;
   s_waitrequest_to_the_iobusMDIO_1 : STD_LOGIC;
   s_readdata_to_the_iobusMDIO_2 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMDIO_2 : STD_LOGIC;
   s_waitrequest_to_the_iobusMDIO_2 : STD_LOGIC;
   s_readdata_to_the_iobusMDIO_3 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMDIO_3 : STD_LOGIC;
   s_waitrequest_to_the_iobusMDIO_3 : STD_LOGIC;
   s_readdata_to_the_iobusMDIO_4 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMDIO_4 : STD_LOGIC;
   s_waitrequest_to_the_iobusMDIO_4 : STD_LOGIC;
   s_readdata_to_the_iobusMDIO_5 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMDIO_5 : STD_LOGIC;
   s_waitrequest_to_the_iobusMDIO_5 : STD_LOGIC;
   s_readdata_to_the_iobusMDIO_6 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMDIO_6 : STD_LOGIC;
   s_waitrequest_to_the_iobusMDIO_6 : STD_LOGIC;
   s_readdata_to_the_iobusMDIO_7 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMDIO_7 : STD_LOGIC;
   s_waitrequest_to_the_iobusMDIO_7 : STD_LOGIC;
   s_readdata_to_the_iobusREGFILE_0 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusREGFILE_0 : STD_LOGIC;
   s_waitrequest_to_the_iobusREGFILE_0 : STD_LOGIC;
   rxd_to_the_rs232_uart : STD_LOGIC;

end record;

--
-- n2top1 outputs (constant)
--
type n2top1_outputs_t is record

   -- output list
   s_address_from_the_iobusMAC_0 : STD_LOGIC_VECTOR (3 DOWNTO 0);
   s_clk_from_the_iobusMAC_0 : STD_LOGIC;
   s_read_from_the_iobusMAC_0 : STD_LOGIC;
   s_rst_from_the_iobusMAC_0 : STD_LOGIC;
   s_write_from_the_iobusMAC_0 : STD_LOGIC;
   s_writedata_from_the_iobusMAC_0 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMAC_1 : STD_LOGIC_VECTOR (3 DOWNTO 0);
   s_clk_from_the_iobusMAC_1 : STD_LOGIC;
   s_read_from_the_iobusMAC_1 : STD_LOGIC;
   s_rst_from_the_iobusMAC_1 : STD_LOGIC;
   s_write_from_the_iobusMAC_1 : STD_LOGIC;
   s_writedata_from_the_iobusMAC_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMAC_2 : STD_LOGIC_VECTOR (3 DOWNTO 0);
   s_clk_from_the_iobusMAC_2 : STD_LOGIC;
   s_read_from_the_iobusMAC_2 : STD_LOGIC;
   s_rst_from_the_iobusMAC_2 : STD_LOGIC;
   s_write_from_the_iobusMAC_2 : STD_LOGIC;
   s_writedata_from_the_iobusMAC_2 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMAC_3 : STD_LOGIC_VECTOR (3 DOWNTO 0);
   s_clk_from_the_iobusMAC_3 : STD_LOGIC;
   s_read_from_the_iobusMAC_3 : STD_LOGIC;
   s_rst_from_the_iobusMAC_3 : STD_LOGIC;
   s_write_from_the_iobusMAC_3 : STD_LOGIC;
   s_writedata_from_the_iobusMAC_3 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMAC_4 : STD_LOGIC_VECTOR (3 DOWNTO 0);
   s_clk_from_the_iobusMAC_4 : STD_LOGIC;
   s_read_from_the_iobusMAC_4 : STD_LOGIC;
   s_rst_from_the_iobusMAC_4 : STD_LOGIC;
   s_write_from_the_iobusMAC_4 : STD_LOGIC;
   s_writedata_from_the_iobusMAC_4 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMAC_5 : STD_LOGIC_VECTOR (3 DOWNTO 0);
   s_clk_from_the_iobusMAC_5 : STD_LOGIC;
   s_read_from_the_iobusMAC_5 : STD_LOGIC;
   s_rst_from_the_iobusMAC_5 : STD_LOGIC;
   s_write_from_the_iobusMAC_5 : STD_LOGIC;
   s_writedata_from_the_iobusMAC_5 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMAC_6 : STD_LOGIC_VECTOR (3 DOWNTO 0);
   s_clk_from_the_iobusMAC_6 : STD_LOGIC;
   s_read_from_the_iobusMAC_6 : STD_LOGIC;
   s_rst_from_the_iobusMAC_6 : STD_LOGIC;
   s_write_from_the_iobusMAC_6 : STD_LOGIC;
   s_writedata_from_the_iobusMAC_6 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMAC_7 : STD_LOGIC_VECTOR (3 DOWNTO 0);
   s_clk_from_the_iobusMAC_7 : STD_LOGIC;
   s_read_from_the_iobusMAC_7 : STD_LOGIC;
   s_rst_from_the_iobusMAC_7 : STD_LOGIC;
   s_write_from_the_iobusMAC_7 : STD_LOGIC;
   s_writedata_from_the_iobusMAC_7 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMDIO_0 : STD_LOGIC_VECTOR (1 DOWNTO 0);
   s_clk_from_the_iobusMDIO_0 : STD_LOGIC;
   s_read_from_the_iobusMDIO_0 : STD_LOGIC;
   s_rst_from_the_iobusMDIO_0 : STD_LOGIC;
   s_write_from_the_iobusMDIO_0 : STD_LOGIC;
   s_writedata_from_the_iobusMDIO_0 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMDIO_1 : STD_LOGIC_VECTOR (1 DOWNTO 0);
   s_clk_from_the_iobusMDIO_1 : STD_LOGIC;
   s_read_from_the_iobusMDIO_1 : STD_LOGIC;
   s_rst_from_the_iobusMDIO_1 : STD_LOGIC;
   s_write_from_the_iobusMDIO_1 : STD_LOGIC;
   s_writedata_from_the_iobusMDIO_1 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMDIO_2 : STD_LOGIC_VECTOR (1 DOWNTO 0);
   s_clk_from_the_iobusMDIO_2 : STD_LOGIC;
   s_read_from_the_iobusMDIO_2 : STD_LOGIC;
   s_rst_from_the_iobusMDIO_2 : STD_LOGIC;
   s_write_from_the_iobusMDIO_2 : STD_LOGIC;
   s_writedata_from_the_iobusMDIO_2 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMDIO_3 : STD_LOGIC_VECTOR (1 DOWNTO 0);
   s_clk_from_the_iobusMDIO_3 : STD_LOGIC;
   s_read_from_the_iobusMDIO_3 : STD_LOGIC;
   s_rst_from_the_iobusMDIO_3 : STD_LOGIC;
   s_write_from_the_iobusMDIO_3 : STD_LOGIC;
   s_writedata_from_the_iobusMDIO_3 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMDIO_4 : STD_LOGIC_VECTOR (1 DOWNTO 0);
   s_clk_from_the_iobusMDIO_4 : STD_LOGIC;
   s_read_from_the_iobusMDIO_4 : STD_LOGIC;
   s_rst_from_the_iobusMDIO_4 : STD_LOGIC;
   s_write_from_the_iobusMDIO_4 : STD_LOGIC;
   s_writedata_from_the_iobusMDIO_4 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMDIO_5 : STD_LOGIC_VECTOR (1 DOWNTO 0);
   s_clk_from_the_iobusMDIO_5 : STD_LOGIC;
   s_read_from_the_iobusMDIO_5 : STD_LOGIC;
   s_rst_from_the_iobusMDIO_5 : STD_LOGIC;
   s_write_from_the_iobusMDIO_5 : STD_LOGIC;
   s_writedata_from_the_iobusMDIO_5 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMDIO_6 : STD_LOGIC_VECTOR (1 DOWNTO 0);
   s_clk_from_the_iobusMDIO_6 : STD_LOGIC;
   s_read_from_the_iobusMDIO_6 : STD_LOGIC;
   s_rst_from_the_iobusMDIO_6 : STD_LOGIC;
   s_write_from_the_iobusMDIO_6 : STD_LOGIC;
   s_writedata_from_the_iobusMDIO_6 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMDIO_7 : STD_LOGIC_VECTOR (1 DOWNTO 0);
   s_clk_from_the_iobusMDIO_7 : STD_LOGIC;
   s_read_from_the_iobusMDIO_7 : STD_LOGIC;
   s_rst_from_the_iobusMDIO_7 : STD_LOGIC;
   s_write_from_the_iobusMDIO_7 : STD_LOGIC;
   s_writedata_from_the_iobusMDIO_7 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusREGFILE_0 : STD_LOGIC_VECTOR (3 DOWNTO 0);
   s_clk_from_the_iobusREGFILE_0 : STD_LOGIC;
   s_read_from_the_iobusREGFILE_0 : STD_LOGIC;
   s_rst_from_the_iobusREGFILE_0 : STD_LOGIC;
   s_write_from_the_iobusREGFILE_0 : STD_LOGIC;
   s_writedata_from_the_iobusREGFILE_0 : STD_LOGIC_VECTOR (31 DOWNTO 0);
   txd_from_the_rs232_uart : STD_LOGIC;

end record;

--**************************************************************
--
-- I/O section end
--
--**************************************************************

--**************************************************************
--**************************************************************

--
-- n2top1 component common interface (constant)
--
type n2top1_t is record
   inputs : n2top1_inputs_t;
   outputs : n2top1_outputs_t;
end record;

--
-- n2top1 vector type (constant)
--
type n2top1_vector_t is array(NATURAL RANGE <>) of n2top1_t;

--
-- n2top1 component declaration (constant)
--
component n2top1
port (
   inputs : in n2top1_inputs_t;
   outputs : out n2top1_outputs_t
);
end component;

--
-- n2top1 global signal to export range/width params (constant)
--
signal component_n2top1 : n2top1_t;

end component_n2top1;

--
-- n2top1 entity declaration
--

-- Local libraries (edit)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.component_n2top1.all;

-- n2top1 entity (constant)
entity n2top1 is
port (
   inputs : in n2top1_inputs_t;
   outputs : out n2top1_outputs_t
);
end n2top1;

--**************************************************************
--**************************************************************

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

architecture rtl of n2top1 is

--
-- nios component declaration (constant)
--
component nios
port
(
   clk1 : in STD_LOGIC;
   reset_n : in STD_LOGIC;
   s_readdata_to_the_iobusMAC_0 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMAC_0 : in STD_LOGIC;
   s_waitrequest_to_the_iobusMAC_0 : in STD_LOGIC;
   s_readdata_to_the_iobusMAC_1 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMAC_1 : in STD_LOGIC;
   s_waitrequest_to_the_iobusMAC_1 : in STD_LOGIC;
   s_readdata_to_the_iobusMAC_2 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMAC_2 : in STD_LOGIC;
   s_waitrequest_to_the_iobusMAC_2 : in STD_LOGIC;
   s_readdata_to_the_iobusMAC_3 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMAC_3 : in STD_LOGIC;
   s_waitrequest_to_the_iobusMAC_3 : in STD_LOGIC;
   s_readdata_to_the_iobusMAC_4 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMAC_4 : in STD_LOGIC;
   s_waitrequest_to_the_iobusMAC_4 : in STD_LOGIC;
   s_readdata_to_the_iobusMAC_5 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMAC_5 : in STD_LOGIC;
   s_waitrequest_to_the_iobusMAC_5 : in STD_LOGIC;
   s_readdata_to_the_iobusMAC_6 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMAC_6 : in STD_LOGIC;
   s_waitrequest_to_the_iobusMAC_6 : in STD_LOGIC;
   s_readdata_to_the_iobusMAC_7 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMAC_7 : in STD_LOGIC;
   s_waitrequest_to_the_iobusMAC_7 : in STD_LOGIC;
   s_readdata_to_the_iobusMDIO_0 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMDIO_0 : in STD_LOGIC;
   s_waitrequest_to_the_iobusMDIO_0 : in STD_LOGIC;
   s_readdata_to_the_iobusMDIO_1 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMDIO_1 : in STD_LOGIC;
   s_waitrequest_to_the_iobusMDIO_1 : in STD_LOGIC;
   s_readdata_to_the_iobusMDIO_2 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMDIO_2 : in STD_LOGIC;
   s_waitrequest_to_the_iobusMDIO_2 : in STD_LOGIC;
   s_readdata_to_the_iobusMDIO_3 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMDIO_3 : in STD_LOGIC;
   s_waitrequest_to_the_iobusMDIO_3 : in STD_LOGIC;
   s_readdata_to_the_iobusMDIO_4 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMDIO_4 : in STD_LOGIC;
   s_waitrequest_to_the_iobusMDIO_4 : in STD_LOGIC;
   s_readdata_to_the_iobusMDIO_5 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMDIO_5 : in STD_LOGIC;
   s_waitrequest_to_the_iobusMDIO_5 : in STD_LOGIC;
   s_readdata_to_the_iobusMDIO_6 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMDIO_6 : in STD_LOGIC;
   s_waitrequest_to_the_iobusMDIO_6 : in STD_LOGIC;
   s_readdata_to_the_iobusMDIO_7 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusMDIO_7 : in STD_LOGIC;
   s_waitrequest_to_the_iobusMDIO_7 : in STD_LOGIC;
   s_readdata_to_the_iobusREGFILE_0 : in STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_readdatavalid_to_the_iobusREGFILE_0 : in STD_LOGIC;
   s_waitrequest_to_the_iobusREGFILE_0 : in STD_LOGIC;
   rxd_to_the_rs232_uart : in STD_LOGIC;
   s_address_from_the_iobusMAC_0 : out STD_LOGIC_VECTOR (3 DOWNTO 0);
   s_clk_from_the_iobusMAC_0 : out STD_LOGIC;
   s_read_from_the_iobusMAC_0 : out STD_LOGIC;
   s_rst_from_the_iobusMAC_0 : out STD_LOGIC;
   s_write_from_the_iobusMAC_0 : out STD_LOGIC;
   s_writedata_from_the_iobusMAC_0 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMAC_1 : out STD_LOGIC_VECTOR (3 DOWNTO 0);
   s_clk_from_the_iobusMAC_1 : out STD_LOGIC;
   s_read_from_the_iobusMAC_1 : out STD_LOGIC;
   s_rst_from_the_iobusMAC_1 : out STD_LOGIC;
   s_write_from_the_iobusMAC_1 : out STD_LOGIC;
   s_writedata_from_the_iobusMAC_1 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMAC_2 : out STD_LOGIC_VECTOR (3 DOWNTO 0);
   s_clk_from_the_iobusMAC_2 : out STD_LOGIC;
   s_read_from_the_iobusMAC_2 : out STD_LOGIC;
   s_rst_from_the_iobusMAC_2 : out STD_LOGIC;
   s_write_from_the_iobusMAC_2 : out STD_LOGIC;
   s_writedata_from_the_iobusMAC_2 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMAC_3 : out STD_LOGIC_VECTOR (3 DOWNTO 0);
   s_clk_from_the_iobusMAC_3 : out STD_LOGIC;
   s_read_from_the_iobusMAC_3 : out STD_LOGIC;
   s_rst_from_the_iobusMAC_3 : out STD_LOGIC;
   s_write_from_the_iobusMAC_3 : out STD_LOGIC;
   s_writedata_from_the_iobusMAC_3 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMAC_4 : out STD_LOGIC_VECTOR (3 DOWNTO 0);
   s_clk_from_the_iobusMAC_4 : out STD_LOGIC;
   s_read_from_the_iobusMAC_4 : out STD_LOGIC;
   s_rst_from_the_iobusMAC_4 : out STD_LOGIC;
   s_write_from_the_iobusMAC_4 : out STD_LOGIC;
   s_writedata_from_the_iobusMAC_4 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMAC_5 : out STD_LOGIC_VECTOR (3 DOWNTO 0);
   s_clk_from_the_iobusMAC_5 : out STD_LOGIC;
   s_read_from_the_iobusMAC_5 : out STD_LOGIC;
   s_rst_from_the_iobusMAC_5 : out STD_LOGIC;
   s_write_from_the_iobusMAC_5 : out STD_LOGIC;
   s_writedata_from_the_iobusMAC_5 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMAC_6 : out STD_LOGIC_VECTOR (3 DOWNTO 0);
   s_clk_from_the_iobusMAC_6 : out STD_LOGIC;
   s_read_from_the_iobusMAC_6 : out STD_LOGIC;
   s_rst_from_the_iobusMAC_6 : out STD_LOGIC;
   s_write_from_the_iobusMAC_6 : out STD_LOGIC;
   s_writedata_from_the_iobusMAC_6 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMAC_7 : out STD_LOGIC_VECTOR (3 DOWNTO 0);
   s_clk_from_the_iobusMAC_7 : out STD_LOGIC;
   s_read_from_the_iobusMAC_7 : out STD_LOGIC;
   s_rst_from_the_iobusMAC_7 : out STD_LOGIC;
   s_write_from_the_iobusMAC_7 : out STD_LOGIC;
   s_writedata_from_the_iobusMAC_7 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMDIO_0 : out STD_LOGIC_VECTOR (1 DOWNTO 0);
   s_clk_from_the_iobusMDIO_0 : out STD_LOGIC;
   s_read_from_the_iobusMDIO_0 : out STD_LOGIC;
   s_rst_from_the_iobusMDIO_0 : out STD_LOGIC;
   s_write_from_the_iobusMDIO_0 : out STD_LOGIC;
   s_writedata_from_the_iobusMDIO_0 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMDIO_1 : out STD_LOGIC_VECTOR (1 DOWNTO 0);
   s_clk_from_the_iobusMDIO_1 : out STD_LOGIC;
   s_read_from_the_iobusMDIO_1 : out STD_LOGIC;
   s_rst_from_the_iobusMDIO_1 : out STD_LOGIC;
   s_write_from_the_iobusMDIO_1 : out STD_LOGIC;
   s_writedata_from_the_iobusMDIO_1 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMDIO_2 : out STD_LOGIC_VECTOR (1 DOWNTO 0);
   s_clk_from_the_iobusMDIO_2 : out STD_LOGIC;
   s_read_from_the_iobusMDIO_2 : out STD_LOGIC;
   s_rst_from_the_iobusMDIO_2 : out STD_LOGIC;
   s_write_from_the_iobusMDIO_2 : out STD_LOGIC;
   s_writedata_from_the_iobusMDIO_2 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMDIO_3 : out STD_LOGIC_VECTOR (1 DOWNTO 0);
   s_clk_from_the_iobusMDIO_3 : out STD_LOGIC;
   s_read_from_the_iobusMDIO_3 : out STD_LOGIC;
   s_rst_from_the_iobusMDIO_3 : out STD_LOGIC;
   s_write_from_the_iobusMDIO_3 : out STD_LOGIC;
   s_writedata_from_the_iobusMDIO_3 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMDIO_4 : out STD_LOGIC_VECTOR (1 DOWNTO 0);
   s_clk_from_the_iobusMDIO_4 : out STD_LOGIC;
   s_read_from_the_iobusMDIO_4 : out STD_LOGIC;
   s_rst_from_the_iobusMDIO_4 : out STD_LOGIC;
   s_write_from_the_iobusMDIO_4 : out STD_LOGIC;
   s_writedata_from_the_iobusMDIO_4 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMDIO_5 : out STD_LOGIC_VECTOR (1 DOWNTO 0);
   s_clk_from_the_iobusMDIO_5 : out STD_LOGIC;
   s_read_from_the_iobusMDIO_5 : out STD_LOGIC;
   s_rst_from_the_iobusMDIO_5 : out STD_LOGIC;
   s_write_from_the_iobusMDIO_5 : out STD_LOGIC;
   s_writedata_from_the_iobusMDIO_5 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMDIO_6 : out STD_LOGIC_VECTOR (1 DOWNTO 0);
   s_clk_from_the_iobusMDIO_6 : out STD_LOGIC;
   s_read_from_the_iobusMDIO_6 : out STD_LOGIC;
   s_rst_from_the_iobusMDIO_6 : out STD_LOGIC;
   s_write_from_the_iobusMDIO_6 : out STD_LOGIC;
   s_writedata_from_the_iobusMDIO_6 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusMDIO_7 : out STD_LOGIC_VECTOR (1 DOWNTO 0);
   s_clk_from_the_iobusMDIO_7 : out STD_LOGIC;
   s_read_from_the_iobusMDIO_7 : out STD_LOGIC;
   s_rst_from_the_iobusMDIO_7 : out STD_LOGIC;
   s_write_from_the_iobusMDIO_7 : out STD_LOGIC;
   s_writedata_from_the_iobusMDIO_7 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
   s_address_from_the_iobusREGFILE_0 : out STD_LOGIC_VECTOR (3 DOWNTO 0);
   s_clk_from_the_iobusREGFILE_0 : out STD_LOGIC;
   s_read_from_the_iobusREGFILE_0 : out STD_LOGIC;
   s_rst_from_the_iobusREGFILE_0 : out STD_LOGIC;
   s_write_from_the_iobusREGFILE_0 : out STD_LOGIC;
   s_writedata_from_the_iobusREGFILE_0 : out STD_LOGIC_VECTOR (31 DOWNTO 0);
   txd_from_the_rs232_uart : out STD_LOGIC
);
end component;

begin

--
-- component port map (constant)
--
nios_inst : nios port map
(
   clk1 => inputs.clk1,
   reset_n => inputs.reset_n,
   s_readdata_to_the_iobusMAC_0 => inputs.s_readdata_to_the_iobusMAC_0,
   s_readdatavalid_to_the_iobusMAC_0 => inputs.s_readdatavalid_to_the_iobusMAC_0,
   s_waitrequest_to_the_iobusMAC_0 => inputs.s_waitrequest_to_the_iobusMAC_0,
   s_readdata_to_the_iobusMAC_1 => inputs.s_readdata_to_the_iobusMAC_1,
   s_readdatavalid_to_the_iobusMAC_1 => inputs.s_readdatavalid_to_the_iobusMAC_1,
   s_waitrequest_to_the_iobusMAC_1 => inputs.s_waitrequest_to_the_iobusMAC_1,
   s_readdata_to_the_iobusMAC_2 => inputs.s_readdata_to_the_iobusMAC_2,
   s_readdatavalid_to_the_iobusMAC_2 => inputs.s_readdatavalid_to_the_iobusMAC_2,
   s_waitrequest_to_the_iobusMAC_2 => inputs.s_waitrequest_to_the_iobusMAC_2,
   s_readdata_to_the_iobusMAC_3 => inputs.s_readdata_to_the_iobusMAC_3,
   s_readdatavalid_to_the_iobusMAC_3 => inputs.s_readdatavalid_to_the_iobusMAC_3,
   s_waitrequest_to_the_iobusMAC_3 => inputs.s_waitrequest_to_the_iobusMAC_3,
   s_readdata_to_the_iobusMAC_4 => inputs.s_readdata_to_the_iobusMAC_4,
   s_readdatavalid_to_the_iobusMAC_4 => inputs.s_readdatavalid_to_the_iobusMAC_4,
   s_waitrequest_to_the_iobusMAC_4 => inputs.s_waitrequest_to_the_iobusMAC_4,
   s_readdata_to_the_iobusMAC_5 => inputs.s_readdata_to_the_iobusMAC_5,
   s_readdatavalid_to_the_iobusMAC_5 => inputs.s_readdatavalid_to_the_iobusMAC_5,
   s_waitrequest_to_the_iobusMAC_5 => inputs.s_waitrequest_to_the_iobusMAC_5,
   s_readdata_to_the_iobusMAC_6 => inputs.s_readdata_to_the_iobusMAC_6,
   s_readdatavalid_to_the_iobusMAC_6 => inputs.s_readdatavalid_to_the_iobusMAC_6,
   s_waitrequest_to_the_iobusMAC_6 => inputs.s_waitrequest_to_the_iobusMAC_6,
   s_readdata_to_the_iobusMAC_7 => inputs.s_readdata_to_the_iobusMAC_7,
   s_readdatavalid_to_the_iobusMAC_7 => inputs.s_readdatavalid_to_the_iobusMAC_7,
   s_waitrequest_to_the_iobusMAC_7 => inputs.s_waitrequest_to_the_iobusMAC_7,
   s_readdata_to_the_iobusMDIO_0 => inputs.s_readdata_to_the_iobusMDIO_0,
   s_readdatavalid_to_the_iobusMDIO_0 => inputs.s_readdatavalid_to_the_iobusMDIO_0,
   s_waitrequest_to_the_iobusMDIO_0 => inputs.s_waitrequest_to_the_iobusMDIO_0,
   s_readdata_to_the_iobusMDIO_1 => inputs.s_readdata_to_the_iobusMDIO_1,
   s_readdatavalid_to_the_iobusMDIO_1 => inputs.s_readdatavalid_to_the_iobusMDIO_1,
   s_waitrequest_to_the_iobusMDIO_1 => inputs.s_waitrequest_to_the_iobusMDIO_1,
   s_readdata_to_the_iobusMDIO_2 => inputs.s_readdata_to_the_iobusMDIO_2,
   s_readdatavalid_to_the_iobusMDIO_2 => inputs.s_readdatavalid_to_the_iobusMDIO_2,
   s_waitrequest_to_the_iobusMDIO_2 => inputs.s_waitrequest_to_the_iobusMDIO_2,
   s_readdata_to_the_iobusMDIO_3 => inputs.s_readdata_to_the_iobusMDIO_3,
   s_readdatavalid_to_the_iobusMDIO_3 => inputs.s_readdatavalid_to_the_iobusMDIO_3,
   s_waitrequest_to_the_iobusMDIO_3 => inputs.s_waitrequest_to_the_iobusMDIO_3,
   s_readdata_to_the_iobusMDIO_4 => inputs.s_readdata_to_the_iobusMDIO_4,
   s_readdatavalid_to_the_iobusMDIO_4 => inputs.s_readdatavalid_to_the_iobusMDIO_4,
   s_waitrequest_to_the_iobusMDIO_4 => inputs.s_waitrequest_to_the_iobusMDIO_4,
   s_readdata_to_the_iobusMDIO_5 => inputs.s_readdata_to_the_iobusMDIO_5,
   s_readdatavalid_to_the_iobusMDIO_5 => inputs.s_readdatavalid_to_the_iobusMDIO_5,
   s_waitrequest_to_the_iobusMDIO_5 => inputs.s_waitrequest_to_the_iobusMDIO_5,
   s_readdata_to_the_iobusMDIO_6 => inputs.s_readdata_to_the_iobusMDIO_6,
   s_readdatavalid_to_the_iobusMDIO_6 => inputs.s_readdatavalid_to_the_iobusMDIO_6,
   s_waitrequest_to_the_iobusMDIO_6 => inputs.s_waitrequest_to_the_iobusMDIO_6,
   s_readdata_to_the_iobusMDIO_7 => inputs.s_readdata_to_the_iobusMDIO_7,
   s_readdatavalid_to_the_iobusMDIO_7 => inputs.s_readdatavalid_to_the_iobusMDIO_7,
   s_waitrequest_to_the_iobusMDIO_7 => inputs.s_waitrequest_to_the_iobusMDIO_7,
   s_readdata_to_the_iobusREGFILE_0 => inputs.s_readdata_to_the_iobusREGFILE_0,
   s_readdatavalid_to_the_iobusREGFILE_0 => inputs.s_readdatavalid_to_the_iobusREGFILE_0,
   s_waitrequest_to_the_iobusREGFILE_0 => inputs.s_waitrequest_to_the_iobusREGFILE_0,
   rxd_to_the_rs232_uart => inputs.rxd_to_the_rs232_uart,
   s_address_from_the_iobusMAC_0 => outputs.s_address_from_the_iobusMAC_0,
   s_clk_from_the_iobusMAC_0 => outputs.s_clk_from_the_iobusMAC_0,
   s_read_from_the_iobusMAC_0 => outputs.s_read_from_the_iobusMAC_0,
   s_rst_from_the_iobusMAC_0 => outputs.s_rst_from_the_iobusMAC_0,
   s_write_from_the_iobusMAC_0 => outputs.s_write_from_the_iobusMAC_0,
   s_writedata_from_the_iobusMAC_0 => outputs.s_writedata_from_the_iobusMAC_0,
   s_address_from_the_iobusMAC_1 => outputs.s_address_from_the_iobusMAC_1,
   s_clk_from_the_iobusMAC_1 => outputs.s_clk_from_the_iobusMAC_1,
   s_read_from_the_iobusMAC_1 => outputs.s_read_from_the_iobusMAC_1,
   s_rst_from_the_iobusMAC_1 => outputs.s_rst_from_the_iobusMAC_1,
   s_write_from_the_iobusMAC_1 => outputs.s_write_from_the_iobusMAC_1,
   s_writedata_from_the_iobusMAC_1 => outputs.s_writedata_from_the_iobusMAC_1,
   s_address_from_the_iobusMAC_2 => outputs.s_address_from_the_iobusMAC_2,
   s_clk_from_the_iobusMAC_2 => outputs.s_clk_from_the_iobusMAC_2,
   s_read_from_the_iobusMAC_2 => outputs.s_read_from_the_iobusMAC_2,
   s_rst_from_the_iobusMAC_2 => outputs.s_rst_from_the_iobusMAC_2,
   s_write_from_the_iobusMAC_2 => outputs.s_write_from_the_iobusMAC_2,
   s_writedata_from_the_iobusMAC_2 => outputs.s_writedata_from_the_iobusMAC_2,
   s_address_from_the_iobusMAC_3 => outputs.s_address_from_the_iobusMAC_3,
   s_clk_from_the_iobusMAC_3 => outputs.s_clk_from_the_iobusMAC_3,
   s_read_from_the_iobusMAC_3 => outputs.s_read_from_the_iobusMAC_3,
   s_rst_from_the_iobusMAC_3 => outputs.s_rst_from_the_iobusMAC_3,
   s_write_from_the_iobusMAC_3 => outputs.s_write_from_the_iobusMAC_3,
   s_writedata_from_the_iobusMAC_3 => outputs.s_writedata_from_the_iobusMAC_3,
   s_address_from_the_iobusMAC_4 => outputs.s_address_from_the_iobusMAC_4,
   s_clk_from_the_iobusMAC_4 => outputs.s_clk_from_the_iobusMAC_4,
   s_read_from_the_iobusMAC_4 => outputs.s_read_from_the_iobusMAC_4,
   s_rst_from_the_iobusMAC_4 => outputs.s_rst_from_the_iobusMAC_4,
   s_write_from_the_iobusMAC_4 => outputs.s_write_from_the_iobusMAC_4,
   s_writedata_from_the_iobusMAC_4 => outputs.s_writedata_from_the_iobusMAC_4,
   s_address_from_the_iobusMAC_5 => outputs.s_address_from_the_iobusMAC_5,
   s_clk_from_the_iobusMAC_5 => outputs.s_clk_from_the_iobusMAC_5,
   s_read_from_the_iobusMAC_5 => outputs.s_read_from_the_iobusMAC_5,
   s_rst_from_the_iobusMAC_5 => outputs.s_rst_from_the_iobusMAC_5,
   s_write_from_the_iobusMAC_5 => outputs.s_write_from_the_iobusMAC_5,
   s_writedata_from_the_iobusMAC_5 => outputs.s_writedata_from_the_iobusMAC_5,
   s_address_from_the_iobusMAC_6 => outputs.s_address_from_the_iobusMAC_6,
   s_clk_from_the_iobusMAC_6 => outputs.s_clk_from_the_iobusMAC_6,
   s_read_from_the_iobusMAC_6 => outputs.s_read_from_the_iobusMAC_6,
   s_rst_from_the_iobusMAC_6 => outputs.s_rst_from_the_iobusMAC_6,
   s_write_from_the_iobusMAC_6 => outputs.s_write_from_the_iobusMAC_6,
   s_writedata_from_the_iobusMAC_6 => outputs.s_writedata_from_the_iobusMAC_6,
   s_address_from_the_iobusMAC_7 => outputs.s_address_from_the_iobusMAC_7,
   s_clk_from_the_iobusMAC_7 => outputs.s_clk_from_the_iobusMAC_7,
   s_read_from_the_iobusMAC_7 => outputs.s_read_from_the_iobusMAC_7,
   s_rst_from_the_iobusMAC_7 => outputs.s_rst_from_the_iobusMAC_7,
   s_write_from_the_iobusMAC_7 => outputs.s_write_from_the_iobusMAC_7,
   s_writedata_from_the_iobusMAC_7 => outputs.s_writedata_from_the_iobusMAC_7,
   s_address_from_the_iobusMDIO_0 => outputs.s_address_from_the_iobusMDIO_0,
   s_clk_from_the_iobusMDIO_0 => outputs.s_clk_from_the_iobusMDIO_0,
   s_read_from_the_iobusMDIO_0 => outputs.s_read_from_the_iobusMDIO_0,
   s_rst_from_the_iobusMDIO_0 => outputs.s_rst_from_the_iobusMDIO_0,
   s_write_from_the_iobusMDIO_0 => outputs.s_write_from_the_iobusMDIO_0,
   s_writedata_from_the_iobusMDIO_0 => outputs.s_writedata_from_the_iobusMDIO_0,
   s_address_from_the_iobusMDIO_1 => outputs.s_address_from_the_iobusMDIO_1,
   s_clk_from_the_iobusMDIO_1 => outputs.s_clk_from_the_iobusMDIO_1,
   s_read_from_the_iobusMDIO_1 => outputs.s_read_from_the_iobusMDIO_1,
   s_rst_from_the_iobusMDIO_1 => outputs.s_rst_from_the_iobusMDIO_1,
   s_write_from_the_iobusMDIO_1 => outputs.s_write_from_the_iobusMDIO_1,
   s_writedata_from_the_iobusMDIO_1 => outputs.s_writedata_from_the_iobusMDIO_1,
   s_address_from_the_iobusMDIO_2 => outputs.s_address_from_the_iobusMDIO_2,
   s_clk_from_the_iobusMDIO_2 => outputs.s_clk_from_the_iobusMDIO_2,
   s_read_from_the_iobusMDIO_2 => outputs.s_read_from_the_iobusMDIO_2,
   s_rst_from_the_iobusMDIO_2 => outputs.s_rst_from_the_iobusMDIO_2,
   s_write_from_the_iobusMDIO_2 => outputs.s_write_from_the_iobusMDIO_2,
   s_writedata_from_the_iobusMDIO_2 => outputs.s_writedata_from_the_iobusMDIO_2,
   s_address_from_the_iobusMDIO_3 => outputs.s_address_from_the_iobusMDIO_3,
   s_clk_from_the_iobusMDIO_3 => outputs.s_clk_from_the_iobusMDIO_3,
   s_read_from_the_iobusMDIO_3 => outputs.s_read_from_the_iobusMDIO_3,
   s_rst_from_the_iobusMDIO_3 => outputs.s_rst_from_the_iobusMDIO_3,
   s_write_from_the_iobusMDIO_3 => outputs.s_write_from_the_iobusMDIO_3,
   s_writedata_from_the_iobusMDIO_3 => outputs.s_writedata_from_the_iobusMDIO_3,
   s_address_from_the_iobusMDIO_4 => outputs.s_address_from_the_iobusMDIO_4,
   s_clk_from_the_iobusMDIO_4 => outputs.s_clk_from_the_iobusMDIO_4,
   s_read_from_the_iobusMDIO_4 => outputs.s_read_from_the_iobusMDIO_4,
   s_rst_from_the_iobusMDIO_4 => outputs.s_rst_from_the_iobusMDIO_4,
   s_write_from_the_iobusMDIO_4 => outputs.s_write_from_the_iobusMDIO_4,
   s_writedata_from_the_iobusMDIO_4 => outputs.s_writedata_from_the_iobusMDIO_4,
   s_address_from_the_iobusMDIO_5 => outputs.s_address_from_the_iobusMDIO_5,
   s_clk_from_the_iobusMDIO_5 => outputs.s_clk_from_the_iobusMDIO_5,
   s_read_from_the_iobusMDIO_5 => outputs.s_read_from_the_iobusMDIO_5,
   s_rst_from_the_iobusMDIO_5 => outputs.s_rst_from_the_iobusMDIO_5,
   s_write_from_the_iobusMDIO_5 => outputs.s_write_from_the_iobusMDIO_5,
   s_writedata_from_the_iobusMDIO_5 => outputs.s_writedata_from_the_iobusMDIO_5,
   s_address_from_the_iobusMDIO_6 => outputs.s_address_from_the_iobusMDIO_6,
   s_clk_from_the_iobusMDIO_6 => outputs.s_clk_from_the_iobusMDIO_6,
   s_read_from_the_iobusMDIO_6 => outputs.s_read_from_the_iobusMDIO_6,
   s_rst_from_the_iobusMDIO_6 => outputs.s_rst_from_the_iobusMDIO_6,
   s_write_from_the_iobusMDIO_6 => outputs.s_write_from_the_iobusMDIO_6,
   s_writedata_from_the_iobusMDIO_6 => outputs.s_writedata_from_the_iobusMDIO_6,
   s_address_from_the_iobusMDIO_7 => outputs.s_address_from_the_iobusMDIO_7,
   s_clk_from_the_iobusMDIO_7 => outputs.s_clk_from_the_iobusMDIO_7,
   s_read_from_the_iobusMDIO_7 => outputs.s_read_from_the_iobusMDIO_7,
   s_rst_from_the_iobusMDIO_7 => outputs.s_rst_from_the_iobusMDIO_7,
   s_write_from_the_iobusMDIO_7 => outputs.s_write_from_the_iobusMDIO_7,
   s_writedata_from_the_iobusMDIO_7 => outputs.s_writedata_from_the_iobusMDIO_7,
   s_address_from_the_iobusREGFILE_0 => outputs.s_address_from_the_iobusREGFILE_0,
   s_clk_from_the_iobusREGFILE_0 => outputs.s_clk_from_the_iobusREGFILE_0,
   s_read_from_the_iobusREGFILE_0 => outputs.s_read_from_the_iobusREGFILE_0,
   s_rst_from_the_iobusREGFILE_0 => outputs.s_rst_from_the_iobusREGFILE_0,
   s_write_from_the_iobusREGFILE_0 => outputs.s_write_from_the_iobusREGFILE_0,
   s_writedata_from_the_iobusREGFILE_0 => outputs.s_writedata_from_the_iobusREGFILE_0,
   txd_from_the_rs232_uart => outputs.txd_from_the_rs232_uart
);

end rtl;
