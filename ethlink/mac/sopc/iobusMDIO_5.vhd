-- iobusMDIO_5.vhd

-- This file was auto-generated as part of a SOPC Builder generate operation.
-- If you edit it your changes will probably be lost.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity iobusMDIO_5 is
	port (
		clk             : in  std_logic                     := '0';             --  clock.clk
		rst             : in  std_logic                     := '0';             --       .reset
		mmaddress       : in  std_logic_vector(1 downto 0)  := (others => '0'); --  slave.address
		mmread          : in  std_logic                     := '0';             --       .read
		mmwrite         : in  std_logic                     := '0';             --       .write
		mmwritedata     : in  std_logic_vector(31 downto 0) := (others => '0'); --       .writedata
		mmreaddatavalid : out std_logic;                                        --       .readdatavalid
		mmwaitrequest   : out std_logic;                                        --       .waitrequest
		mmreaddata      : out std_logic_vector(31 downto 0);                    --       .readdata
		s_readdata      : in  std_logic_vector(31 downto 0) := (others => '0'); -- export.export
		s_readdatavalid : in  std_logic                     := '0';             --       .export
		s_waitrequest   : in  std_logic                     := '0';             --       .export
		s_clk           : out std_logic;                                        --       .export
		s_rst           : out std_logic;                                        --       .export
		s_address       : out std_logic_vector(1 downto 0);                     --       .export
		s_read          : out std_logic;                                        --       .export
		s_write         : out std_logic;                                        --       .export
		s_writedata     : out std_logic_vector(31 downto 0)                     --       .export
	);
end entity iobusMDIO_5;

architecture rtl of iobusMDIO_5 is
	component MMslaveint is
		generic (
			ADDRSIZE : natural := 4
		);
		port (
			clk             : in  std_logic                     := 'X';             --  clock.clk
			rst             : in  std_logic                     := 'X';             --       .reset
			mmaddress       : in  std_logic_vector(1 downto 0)  := (others => 'X'); --  slave.address
			mmread          : in  std_logic                     := 'X';             --       .read
			mmwrite         : in  std_logic                     := 'X';             --       .write
			mmwritedata     : in  std_logic_vector(31 downto 0) := (others => 'X'); --       .writedata
			mmreaddatavalid : out std_logic;                                        --       .readdatavalid
			mmwaitrequest   : out std_logic;                                        --       .waitrequest
			mmreaddata      : out std_logic_vector(31 downto 0);                    --       .readdata
			s_readdata      : in  std_logic_vector(31 downto 0) := (others => 'X'); -- export.export
			s_readdatavalid : in  std_logic                     := 'X';             --       .export
			s_waitrequest   : in  std_logic                     := 'X';             --       .export
			s_clk           : out std_logic;                                        --       .export
			s_rst           : out std_logic;                                        --       .export
			s_address       : out std_logic_vector(1 downto 0);                     --       .export
			s_read          : out std_logic;                                        --       .export
			s_write         : out std_logic;                                        --       .export
			s_writedata     : out std_logic_vector(31 downto 0)                     --       .export
		);
	end component MMslaveint;

begin

	iobusmdio_5 : component MMslaveint
		generic map (
			ADDRSIZE => 2
		)
		port map (
			clk             => clk,             --  clock.clk
			rst             => rst,             --       .reset
			mmaddress       => mmaddress,       --  slave.address
			mmread          => mmread,          --       .read
			mmwrite         => mmwrite,         --       .write
			mmwritedata     => mmwritedata,     --       .writedata
			mmreaddatavalid => mmreaddatavalid, --       .readdatavalid
			mmwaitrequest   => mmwaitrequest,   --       .waitrequest
			mmreaddata      => mmreaddata,      --       .readdata
			s_readdata      => s_readdata,      -- export.export
			s_readdatavalid => s_readdatavalid, --       .export
			s_waitrequest   => s_waitrequest,   --       .export
			s_clk           => s_clk,           --       .export
			s_rst           => s_rst,           --       .export
			s_address       => s_address,       --       .export
			s_read          => s_read,          --       .export
			s_write         => s_write,         --       .export
			s_writedata     => s_writedata      --       .export
		);

end architecture rtl; -- of iobusMDIO_5
