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
use work.userlib.all;

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

-- data frame optional header
constant OPTIONAL_DATA_FRAME_HEADER : natural := 0;
--
-- OPTIONAL_DATA_FRAME_HEADER = 0 --> data frames without custom header
-- OPTIONAL_DATA_FRAME_HEADER = 1 --> data frames with custom header
--
-- Note: command frames always include custom header (10 bytes)
--

-- MAC address
type MAC_address_t is array(0 to 5) of std_logic_vector(7 downto 0);
constant MAC_MASTERNODE_ADDR : MAC_address_t := (x"00", x"11", x"22", x"33", x"44", x"00");
constant MAC_SLAVENODE_ADDR  : MAC_address_t := (x"00", x"01", x"02", x"03", x"04", x"00"); 
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
constant IPv4_NADDR : IPv4_address_t := (192, 168,   1,   0); -- Subnet Address
constant IPv4_MADDR : IPv4_address_t := (239, 255,   0,   0); -- Multicast Address
constant IPv4_BADDR : IPv4_address_t := (192, 168,   1, 255); -- Subnet Broadcast Address

--
-- TXUDP port map
--
subtype txframe1_udpport_t is std_logic_vector(15 downto 0);
type txframe1_udpport_vector_t is array(NATURAL RANGE <>) of txframe1_udpport_t;
-- Base UDPsrcport 10000 (pattern 0xNNN[0] = 0x2710)

--STANDARD CONFIGURATION-----------------------------------------------------------------------
--constant TXUDP_SRCPORT  : txframe1_udpport_t := SLV(10000, 16);                            
-- Local ports are statically connected to remote UDP ports  
--constant TXUDP_DESTPORT : txframe1_udpport_vector_t(0 to 15) := 
--(
--         0 => SLV(10000, 16), -- local port zero reserved for command frames (connected to default UDPdestport)
--   FF_PORT => SLV(12000, 16), -- FF_PORT sends to UDP port group 12000..12015 (pattern 0xNNN[0] = 0x2EE0)
--  others  => SLV(10000, 16)  -- default UDPdestport (pattern 0xNNN[0] = 0x2710)

--); 
----------MY CONFIGURATION:-----------------------------------------------------------------------------
constant TXUDP_SRCPORT  : txframe1_udpport_t := SLV(58912, 16);     ---Tolgo 2 perché metto il base address, poi il sistema legge la porta dalla TEL e somma 2, gli ultimi bit del numero E622                       
 --Local ports are statically connected to remote UDP ports  
 constant TXUDP_DESTPORT : txframe1_udpport_vector_t(0 to 15) := 
(
         0 => SLV(58912, 16), -- local port zero reserved for command frames (connected to default UDPdestport)
   FF_PORT => SLV(58912, 16), -- FF_PORT sends to UDP port group 12000..12015 (pattern 0xNNN[0] = 0x2EE0)
  others  => SLV(58912, 16)  -- default UDPdestport (pattern 0xNNN[0] = 0x2710)

); 

-------------------------------------------FINO QUI
--
-- RXUDP port map
--
subtype rxframe1_udpport_t is std_logic_vector(15 downto 0);

-- Base UDP srcport/destport = 10000 (pattern 0xNNN[0] = 0x2710)
--------------STANDARD CONFIGURATION:------------------------------------------------
--constant RXUDP_SRCPORT  : rxframe1_udpport_t := SLV(10000, 16);                       
--constant RXUDP_DESTPORT : rxframe1_udpport_t := SLV(10000, 16);                            

------------------MY CONFIGURATION------------------------------------------------------
constant RXUDP_SRCPORT  : rxframe1_udpport_t := SLV(58912, 16); --(0xD622)           --tolgo due perché metto il BASEADDRESS	                  
constant RXUDP_DESTPORT : rxframe1_udpport_t := SLV(58912, 16);  -- (0xE622)                          
-------------------------------------------------------------------------------------

--
-- Note: All network nodes share the UDPport space 10000..10015
--       Slave side:  UDPports 10000..10015 are hardware-assigned to slave functions (i.e. CPU_PORT = 10001, port 10000 is reserved for commands).
--       Master side: UDPports 10000..10015 represent a 'pool' of 16 generic ports (process/threads choose a port-number from this 'pool',
--       slave nodes will reply to master-node requests using received port numbers).
-- 
--       Master nodes use special UDPport interval 12000..12015 as fast-path rx queues
--       (slave ports send data to fast-path queues using nibble 'txdestport' as index).
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

end globals;

