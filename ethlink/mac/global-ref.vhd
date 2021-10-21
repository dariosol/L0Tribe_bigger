--**************************************************************
--**************************************************************
--
--
-- Global Parameters
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package globals is

--
-- constants (edit)
--

-- total number of tx/rx ports
constant TX_NPORTS : natural := 2; -- 2;
constant RX_NPORTS : natural := 2; -- 2;

-- port address (from 1 to NPORTS)
constant CPU_PORT : natural := 1;
constant FF_PORT  : natural := 2;

-- IP/UDP address
type IPv4_address_t is array(0 to 3) of natural range 0 to 255;
constant IPv4_NADDR : IPv4_address_t := (192, 168,   1,   0); -- Subnet Address
constant IPv4_MADDR : IPv4_address_t := (239, 255,   0,   0); -- Multicast Address
constant IPv4_BADDR : IPv4_address_t := (192, 168,   1, 255); -- Subnet Broadcast Address

---- txframe/rxframe params (100 Mbit/s, gmii, full duplex)
--constant BIT_TIME_ns : natural := 10;
--constant CLOCK_FREQ_MHz : natural := 25; 
--constant INTERFRAME_GAP_bit : natural := 96;
--constant BIT_PER_CLOCK : natural := 4;
--constant ENET_MODE : natural := 100;

-- txframe/rxframe params (1000 Mbit/s, gmii, full duplex)
constant BIT_TIME_ns : natural := 1;
constant CLOCK_FREQ_MHz : natural := 125; 
constant INTERFRAME_GAP_bit : natural := 96;
constant BIT_PER_CLOCK : natural := 8;
constant ENET_MODE : natural := 1000;

end globals;

