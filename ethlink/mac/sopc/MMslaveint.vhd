--**************************************************************
--**************************************************************
--
--
-- Component MMslaveint (nios2 generic memory mapped slave)
--
-- address : ADDRSIZE (default 4)
-- data    : 32bit
--
--**************************************************************
--**************************************************************

-- Standard libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MMslaveint is
generic
(
   ADDRSIZE : natural := 4
);
port
(
   clk : in std_logic;
   rst : in std_logic;
   mmaddress : in std_logic_vector((ADDRSIZE - 1) downto 0);
   mmread : in std_logic;
   mmwrite : in std_logic;
   mmwritedata : in std_logic_vector(31 downto 0);
   s_readdata : in std_logic_vector(31 downto 0);
   s_readdatavalid : in std_logic;
   s_waitrequest : in std_logic;
   mmreaddata : out std_logic_vector(31 downto 0);
   mmreaddatavalid : out std_logic;
   mmwaitrequest : out std_logic;
   s_clk : out std_logic;
   s_rst : out std_logic;
   s_address : out std_logic_vector((ADDRSIZE - 1) downto 0);
   s_read : out std_logic;
   s_write : out std_logic;
   s_writedata : out std_logic_vector(31 downto 0)
);
end MMslaveint;

--**************************************************************
--
-- Component Architecture
--
--**************************************************************

-- Local libraries (constant)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of MMslaveint is

--
-- MMslaveint component declaration (constant)
--
--component MMslaveint
--generic
--(
--   ADDRSIZE : natural := 4
--);
--port
--(
--   clk : in std_logic;
--   rst : in std_logic;
--   mmaddress : in std_logic_vector((ADDRSIZE - 1) downto 0);
--   mmread : in std_logic;
--   mmwrite : in std_logic;
--   mmwritedata : in std_logic_vector(31 downto 0);
--   s_readdata : in std_logic_vector(31 downto 0);
--   s_readdatavalid : in std_logic;
--   s_waitrequest : in std_logic;
--   mmreaddata : out std_logic_vector(31 downto 0);
--   mmreaddatavalid : out std_logic;
--   mmwaitrequest : out std_logic;
--   s_clk : out std_logic;
--   s_rst : out std_logic;
--   s_address : out std_logic_vector((ADDRSIZE - 1) downto 0);
--   s_read : out std_logic;
--   s_write : out std_logic;
--   s_writedata : out std_logic_vector(31 downto 0)
--);
--end component;

begin

   -- Avalon bus <-- Slave bus
   mmreaddata <= s_readdata;
   mmreaddatavalid <= s_readdatavalid;
   mmwaitrequest <= s_waitrequest;

   -- Slave bus <-- Avalon bus
   s_clk <= clk;
   s_rst <= rst;   
   s_address <= mmaddress;
   s_read <= mmread;
   s_write <= mmwrite;
   s_writedata <= mmwritedata;

end rtl;
