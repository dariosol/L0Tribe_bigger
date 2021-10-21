
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;

package mac_globals is

--
-- constants (indexed by MAC instance number)
--

-- total number of ethernet interfaces
constant ETH_NODES : natural := 8; 


-- MAC address
type MAC_address_t is array(0 to 5) of std_logic_vector(7 downto 0);
type MAC_address_table_t is array(0 to ETH_NODES - 1) of MAC_address_t; 
constant MAC_MASTERNODE_ADDR : MAC_address_table_t :=
(
   -- 0 => (x"00", x"11", x"22", x"33", x"44", x"00"), -- MAC MasterNode ETH0
   -- 1 => (x"00", x"11", x"22", x"33", x"44", x"00"), -- MAC MasterNode ETH1
   -- 2 => (x"00", x"11", x"22", x"33", x"44", x"00"), -- MAC MasterNode ETH2
   -- 3 => (x"00", x"11", x"22", x"33", x"44", x"00"), -- MAC MasterNode ETH3
   -- 4 => (x"00", x"11", x"22", x"33", x"44", x"00"), -- MAC MasterNode ETH4
   -- 5 => (x"00", x"11", x"22", x"33", x"44", x"00"), -- MAC MasterNode ETH5
   -- 6 => (x"00", x"11", x"22", x"33", x"44", x"00"), -- MAC MasterNode ETH6
   -- 7 => (x"00", x"11", x"22", x"33", x"44", x"00"), -- MAC MasterNode ETH7
   others => (x"00", x"11", x"22", x"33", x"44", x"00") -- MAC MasterNode (default)
);
constant MAC_SLAVENODE_ADDR : MAC_address_table_t :=
(
   -- 0 => (x"00", x"01", x"02", x"03", x"04", x"00"), -- MAC SlaveNode ETH0
   -- 1 => (x"00", x"01", x"02", x"03", x"04", x"00"), -- MAC SlaveNode ETH1
   -- 2 => (x"00", x"01", x"02", x"03", x"04", x"00"), -- MAC SlaveNode ETH2
   -- 3 => (x"00", x"01", x"02", x"03", x"04", x"00"), -- MAC SlaveNode ETH3
   -- 4 => (x"00", x"01", x"02", x"03", x"04", x"00"), -- MAC SlaveNode ETH4
   -- 5 => (x"00", x"01", x"02", x"03", x"04", x"00"), -- MAC SlaveNode ETH5
   -- 6 => (x"00", x"01", x"02", x"03", x"04", x"00"), -- MAC SlaveNode ETH6
   -- 7 => (x"00", x"01", x"02", x"03", x"04", x"00"), -- MAC SlaveNode ETH7
   others => (x"00", x"01", x"02", x"03", x"04", x"00") -- MAC SlaveNode (dafault)
);
--
-- slave nodes 0..191    --> constant pattern mac address 00:01:02:03:04:[00..BF]
-- master nodes 192..255 --> constant pattern mac address 00:11:22:33:44:[C0..FF]
--
-- Note: mac address byte5 (last byte) works as node address indicator (constant pattern zero) 
--
-- Note1: node interval 192+0..192+15 reserved for master nodes with not-modifiable mac address
-- (frame transmission to nodes 192..207 uses a programmable mac_dest_address instead of 
-- MAC_MASTERNODE_ADDR) 
--  

-- IP/UDP address
type IPv4_address_t is array(0 to 3) of natural range 0 to 255;
type IPv4_address_table_t is array(0 to ETH_NODES - 1) of IPv4_address_t;
constant IPv4_NADDR : IPv4_address_table_t := 
(
   --   0 => (192, 168,   1,   0), -- Subnet Address ETH0
   --   1 => (192, 168,   1,   0), -- Subnet Address ETH1
   --   2 => (192, 168,   1,   0), -- Subnet Address ETH2
   --   3 => (192, 168,   1,   0), -- Subnet Address ETH3
   --   4 => (192, 168,   1,   0), -- Subnet Address ETH4
   --   5 => (192, 168,   1,   0), -- Subnet Address ETH5
   --   6 => (192, 168,   1,   0), -- Subnet Address ETH6
   --   7 => (192, 168,   1,   0), -- Subnet Address ETH7
   others => (192, 168,   1,   0)  -- Subnet Address (default)
);
constant IPv4_MADDR : IPv4_address_t := (239, 255,   0,   0); -- Multicast Address
constant IPv4_BADDR : IPv4_address_table_t := 
(
   --   0 => (192, 168,   1, 255), -- Subnet Broadcast Address ETH0
   --   1 => (192, 168,   1, 255), -- Subnet Broadcast Address ETH1
   --   2 => (192, 168,   1, 255), -- Subnet Broadcast Address ETH2
   --   3 => (192, 168,   1, 255), -- Subnet Broadcast Address ETH3
   --   4 => (192, 168,   1, 255), -- Subnet Broadcast Address ETH4
   --   5 => (192, 168,   1, 255), -- Subnet Broadcast Address ETH5
   --   6 => (192, 168,   1, 255), -- Subnet Broadcast Address ETH6
   --   7 => (192, 168,   1, 255), -- Subnet Broadcast Address ETH7
   others => (192, 168,   1, 255)  -- Subnet Broadcast Address (default)
);

--
-- constants (common values for all MAC instances)
--

-- total number of tx/rx ports
constant TX_NPORTS : natural := 2;
constant RX_NPORTS : natural := 2;

-- port address (from 1 to NPORTS)
constant CPU_PORT : natural := 1;
constant FF_PORT  : natural := 2;

-- txport max data-path-width
constant TX_WDATA_WIDTH_MAX : natural := 64;
-- txport data-path-width table (constant array indexed by port number)
type TX_WDATA_WIDTH_table_t is array(1 to TX_NPORTS) of natural; 
constant TX_WDATA_WIDTH : TX_WDATA_WIDTH_table_t := 
(
   CPU_PORT => 8,
   FF_PORT  => 64,
   others   => 8
);
-- note: all tx ports have the same 'wdata' width (global param TX_WDATA_WIDTH_MAX), 
-- each port will use a sub-section of 'wdata' according to TX_WDATA_WIDTH table
-- note1: 'width' parameters MUST be a power of 2 (8,16,32,64)

-- data frame optional header
constant OPTIONAL_DATA_FRAME_HEADER : natural := 0;
--
-- OPTIONAL_DATA_FRAME_HEADER = 0 --> data frames without custom header
-- OPTIONAL_DATA_FRAME_HEADER = 1 --> data frames with custom header
--
-- Note: command frames always include custom header (10 bytes)
--

--
-- TXUDP port map
--
subtype txframe1_udpport_t is std_logic_vector(15 downto 0);
type txframe1_udpport_vector_t is array(NATURAL RANGE <>) of txframe1_udpport_t;
-----------MY CONFIGURATION:-----------------------------------------------------------------------------
constant TXUDP_SRCPORT  : txframe1_udpport_t :=  SLV(58912, 16);  -- (DE4)Tolgo 2 perché metto il base address, poi il sistema legge la porta dalla TEL e somma 2, gli ultimi bit del numero E622                       
 --Local ports are statically connected to remote UDP ports  
 constant TXUDP_DESTPORT : txframe1_udpport_vector_t(0 to 15) := 
(
         0 =>  SLV(58912, 16), -- local port zero reserved for command frames (connected to default UDPdestport)
   FF_PORT =>  SLV(58912, 16), -- (PC) FF_PORT sends to UDP port group 12000..12015 (pattern 0xNNN[0] = 0x2EE0)
  others   =>  SLV(58912, 16)  -- default UDPdestport (pattern 0xNNN[0] = 0x2710)

); 

--
-- RXUDP port map
--
subtype rxframe1_udpport_t is std_logic_vector(15 downto 0);
-- Base UDP srcport = 54816 (pattern 0xNNN[0] = 0xD620)

------------------MY CONFIGURATION------------------------------------------------------
--constant RXUDP_SRCPORT  : rxframe1_udpport_t := SLV(54816, 16); --(TEL62)(0xD622)           --tolgo due perché metto il BASEADDRESS	                  
constant RXUDP_SRCPORT  : rxframe1_udpport_t := SLV(58912, 16); --(TEL62)(0xD622)
constant RXUDP_DESTPORT : rxframe1_udpport_t := SLV(58912, 16);  --(DE4) (0xE622)                          
-------------------------------------------------------------------------------------



--
-- Note: all frames are received using UDPport base addresses 'SrcPort=RXUDP_SRCPORT' and 'DestPort=RXUDP_DESTPORT'
--       (UDPport base addresses must have a pattern 0xNNN[0], nibble low is taken from 4bit srcport/destport addresses)
--       example:
--       SrcPort  = 54816 : each rx-port will accept any SrcPort(54816+0..54816+15) (4bit 'rsrcport' output) 
--       DestPort = 58912 : CPU_PORT = 1 --> 58912+1, FF_PORT = 2 --> 58912+2, port 0 --> 58912+0 reserved for commands 
--

-- Note: all frames are received using UDPport base addresses 'SrcPort=RXUDP_SRCPORT' and 'DestPort=RXUDP_DESTPORT'
--       (UDPport base addresses must have a pattern 0xNNN[0], nibble low is taken from 4bit srcport/destport addresses)
--       example:
--       SrcPort  = 54816 : each rx-port will accept any SrcPort(54816+0..54816+15) (4bit 'rsrcport' output) 
--       DestPort = 58912 : CPU_PORT = 1 --> 58912+1, FF_PORT = 2 --> 58912+2, port 0 --> 58912+0 reserved for commands 
--

--
-- Note1: all network nodes are configured to share the UDPport space DestPort(58912+0..58912+15), SrcPort(54816+0..54816+15)
-- Slave side (FPGA): UDPports (0..15) are hardware-assigned to slave functions (i.e. CPU_PORT = 1, FF_PORT = 2, 
--                    port 0 is reserved for commands)
-- Master side (PC) : UDPports (0..15) represent a 'pool' of 16 generic ports (process/threads choose a port-number from 
--                    this 'pool', slave nodes will reply to master-node requests using received port numbers)
--

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

end mac_globals;

