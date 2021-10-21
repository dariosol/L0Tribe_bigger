-------------------------------------------------------------------------------
-- Title      : <L0Tribe>
-- Project    : 
-------------------------------------------------------------------------------
-- File       : ethlink.vhd
-- Author     : na62torino  <na62torino@na62torino-WorkStation>
-- Company    : 
-- Created    : 2020-02-12
-- Last update: 2020-12-03
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: <cursor>
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-02-12  1.0      na62torino	Created
-------------------------------------------------------------------------------




library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package component_ethlink is

  constant SGMII_NODES : natural := 4; -- Default;
  constant RGMII_NODES : natural := 4; -- Mezzanines;
  constant ethlink_NODES : natural := 8;

  
  type FSMSend_t is (S0, S1, S1_header,S1_1,S1_2, S1_3,S2);
  type FSMBuffer_t is (S0,S1,S1_Latency,S1_1_Latency,S2,S2_Latency,S2_2_Latency,S3);
  type FSMReceive32bit_t is (S0, S1, S2,S3_1,S3_2,S3_3,S3_4,S3_5,S3_6,S3_7,S3_8,S4);
  type FSMSend_vector_t is array(natural range <>) of FSMSend_t;
  type FSMBuffer_vector_t is array(natural range <>) of FSMBuffer_t;      

  
  type vector is array(natural range <>) of std_logic;
  type vector3 is array(natural range <>) of std_logic_vector(2 downto 0);
  type vector4 is array(natural range <>) of std_logic_vector(3 downto 0);
  type vector8 is array(natural range <>) of std_logic_vector(7 downto 0);
  type vector14 is array(natural range <>) of std_logic_vector(13 downto 0);
  type vector15 is array(natural range <>) of std_logic_vector(14 downto 0);
  type vector16 is array(natural range <>) of std_logic_vector(15 downto 0);
  type vector24 is array(natural range <>) of std_logic_vector(23 downto 0);
  type vector32 is array(natural range <>) of std_logic_vector(31 downto 0);
  type vector64 is array(natural range <>) of std_logic_vector(63 downto 0);
  type vector256 is array(natural range <>) of std_logic_vector(255 downto 0);


  type ethlink_inputs_t is record

    startData          : std_logic;
    clkin_50           : std_logic;
    clkin_125          : std_logic;
    cpu_resetn         : std_logic;
    --sgmii rx
    rxp           : std_logic_vector(0 to SGMII_NODES - 1);
    --
    -- rgmii inputs (enet interface)
    --
    -- rgmii rx
    enet_rx_clk : std_logic_vector(0 to RGMII_NODES - 1);
    enet_rx_dv  : std_logic_vector(0 to RGMII_NODES - 1);
    enet_rx_er  : std_logic_vector(0 to RGMII_NODES - 1);
    enet_rx_d   : vector8(0 to RGMII_NODES - 1);


    USER_DIPSW         : std_logic_vector(7 downto 0);
    primitiveFIFOempty0: std_logic;
    primitiveFIFOempty1: std_logic;
    primitiveFIFOempty2: std_logic;
    primitiveFIFOempty3: std_logic;
    primitiveFIFOempty4: std_logic;
    primitiveFIFOempty5: std_logic; 
    
    PrimitiveDataIn   : vector256(0 to ethlink_NODES -2);
  end record;


  type ethlink_outputs_t is record
    resetn            : std_logic;
    enet_resetn       : std_logic_vector(0 to RGMII_NODES - 1);
    txp               : std_logic_vector(0 to SGMII_NODES - 1);
    -------------------------------------------------------
    -- rgmii tx
    enet_gtx_clk : std_logic_vector(0 to RGMII_NODES - 1);
    enet_tx_en   : std_logic_vector(0 to RGMII_NODES - 1);
    enet_tx_er   : std_logic_vector(0 to RGMII_NODES - 1);
    enet_tx_d    : vector8(0 to RGMII_NODES - 1);
    
    macdata           : std_logic_vector(63 downto 0);
    macreceived       : std_logic;
    packetreceived    : std_logic;

    --read the new data from the fifo (passed to the serializer)
    readfromfifo0          : std_logic;
    readfromfifo1          : std_logic;
    readfromfifo2          : std_logic;
    readfromfifo3          : std_logic;
    readfromfifo4          : std_logic;
    readfromfifo5          : std_logic;
    
    detectorUnderInit : std_logic_vector(3 downto 0);
  end record;


  type ethlink_t is record
    inputs  : ethlink_inputs_t;
    outputs : ethlink_outputs_t;
  end record;

--
-- ethlink vector type (constant)
--
  type ethlink_vector_t is array(natural range <>) of ethlink_t;

  component ethlink
    port (
      inputs  : in  ethlink_inputs_t;
      outputs : out ethlink_outputs_t
      );
  end component;

  signal component_ethlink : ethlink_t;
end component_ethlink;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.userlib.all;
use work.mac_globals.all;
--
-- use work.component_[name].all;
--
use work.component_ethlink.all;
use work.component_syncrst1.all;
use work.component_mac_sgmii.all;
use work.component_mac_rgmii.all;
use work.component_txport1.all;
use work.component_bufferfifo.all;
use work.component_PrimitiveSerializer.all;


entity ethlink is
  port (
    inputs  : in  ethlink_inputs_t;
    outputs : out ethlink_outputs_t
    );
end ethlink;

architecture rtl of ethlink is

  
  type reglist_clk50_t is record
    div2                   : std_logic;
  end record;

  constant reglist_clk50_default : reglist_clk50_t :=
    (
      div2                   => '0'
      );

  type reglist_clk125_t is record
    wena                : std_logic_vector(0 to ethlink_NODES-2);
    rena                : std_logic_vector(0 to ethlink_NODES-2);
    hwaddress           : std_logic_vector(7 downto 0);
    FSMSend             : FSMSend_vector_t(0 to ethlink_NODES-2);
    FSMReceive32bit     : FSMReceive32bit_t;
    FSMReceive32bitRGMII: FSMReceive32bit_t;
    FSMBuffer           : FSMBuffer_vector_t(0 to ethlink_NODES-2);
    readfromfifo        : std_logic_vector(0 to ethlink_NODES-2);
    startData           : std_logic;
    sendflag            : std_logic_vector(0 to ethlink_NODES-2);
    latency             : vector16(0 to  ethlink_NODES-2);
    primitiveinpacket   : vector8(0 to ethlink_NODES-2 );
    primitiveFIFOempty  : std_logic_vector(0 to ethlink_NODES-2);
    macdata             : std_logic_vector(63 downto 0);
    macreceived         : std_logic;
    data0               : std_logic_vector(7 downto 0);
    data1               : std_logic_vector(7 downto 0);
    data2               : std_logic_vector(7 downto 0);
    data3               : std_logic_vector(7 downto 0);
    data4               : std_logic_vector(7 downto 0);
    data5               : std_logic_vector(7 downto 0);
    data6               : std_logic_vector(7 downto 0);
    data7               : std_logic_vector(7 downto 0);
    detectorUnderInit   : std_logic_vector(3 downto 0);
    packetreceived      : std_logic;
    sourceID            : vector8(0 to ethlink_NODES-2);
    SubSourceID         : vector8(0 to ethlink_NODES-2);
    MTPAssembly         : vector24(0 to ethlink_NODES-2);
    npackets            : vector8(0 to ethlink_NODES-2);
    MTPLength           : vector16(0 to ethlink_NODES-2);
    framecounter        : vector24(0 to ethlink_NODES-2);
    framecounter_copy   : vector24(0 to ethlink_NODES-2 );
    tstmpword           : vector32(0 to ethlink_NODES-2);
    offset              : vector8(0 to ethlink_NODES-2);
  end record;

  constant reglist_clk125_default : reglist_clk125_t :=
    (
      FSMSend             => (others => S0),
      FSMReceive32bit     => S0,
      FSMReceive32bitRGMII=> S0,
      FSMBuffer           => (others => S0),
      wena                => (others => '0'),
      rena                => (others => '0'),
      hwaddress           => "00000000",
      readfromfifo        => (others =>'0'),
      startData           => '0',
      sendflag            => "0000000",
      latency             => (others=>X"031F"),
      primitiveinpacket   => (others=>X"00"),
      primitiveFIFOempty  => (others =>'0'),
      macdata             => (others=>'0'),
      macreceived         => '0',
      data0               => (others=>'0'),
      data1               => (others=>'0'),
      data2               => (others=>'0'),
      data3               => (others=>'0'),
      data4               => (others=>'0'),
      data5               => (others=>'0'),
      data6               => (others=>'0'),
      data7               => (others=>'0'),
      detectorUnderInit   => (others=>'0'),
      packetreceived      => '0',
      sourceID            => (others =>X"00"),
      SubSourceID         => (others =>X"00"),
      MTPAssembly         => (others =>X"000000"),
      npackets            => (others =>X"00"),
      MTPLength           => (others =>X"0000"),
      framecounter        => (others=>X"000000"),
      framecounter_copy   => (others=>X"000000"),
      tstmpword           => (others=>X"00000000"),
      offset              => (others=>X"00")
      );


  type reglist_t is record

    clk50  : reglist_clk50_t;
    clk125 : reglist_clk125_t;
  end record;


  type resetlist_t is record
    main   : std_logic;
    clk50  : std_logic;
    clk125 : std_logic;
  end record;

  type netlist_t is record
    -- internal clocks
    clk125      : std_logic;
    rst         : resetlist_t;
    SyncRST     : syncrst1_t;
    MAC         : mac_sgmii_vector_t(0 to SGMII_NODES - 1);
    enet_MAC    : mac_rgmii_vector_t(0 to RGMII_NODES - 1);
    bufferfifo  : bufferfifo_vector_t(0 to ethlink_NODES - 2);
    PrimitiveSerializer : PrimitiveSerializer_vector_t(0 to ethlink_NODES - 2);
  end record;


  subtype inputs_t is ethlink_inputs_t;
  subtype outputs_t is ethlink_outputs_t;

  type allregs_t is record
    din  : reglist_t;
    dout : reglist_t;
  end record;


  signal allregs : allregs_t;
  signal allnets : netlist_t;
  signal allouts : outputs_t;

begin

  SyncRST : syncrst1 port map
    (
      inputs  => allnets.SyncRST.inputs,
      outputs => allnets.SyncRST.outputs
      );

  MAC : for index in 0 to SGMII_NODES - 1 GENERATE
    MAC : mac_sgmii
      generic map
      (
        instance => index
        -- note: SGMII nodes mapped to range 0..3
        )
      port map
      (
        inputs => allnets.MAC(index).inputs,
        outputs => allnets.MAC(index).outputs
        );
  end GENERATE;
 

  enet_MAC : for index in 0 to RGMII_NODES - 1 GENERATE
    enet_MAC : mac_rgmii
      generic map
      (
        instance => (index+4)
        -- note: RGMII nodes mapped to range 4..7
        )
      port map
      (
        inputs => allnets.enet_MAC(index).inputs,
        outputs => allnets.enet_MAC(index).outputs
        );
       end GENERATE;


  bufferfifo_inst : for index in 0 to ethlink_NODES-2 generate
    bufferfifo_inst : bufferfifo port map
      (
        inputs  => allnets.bufferfifo(index).inputs,
        outputs => allnets.bufferfifo(index).outputs
        );
  end generate;

  PrimitiveSerializer_inst : for index in 0 to ethlink_NODES-2 generate
    PrimitiveSerializer_inst : PrimitiveSerializer port map
      (
        inputs  => allnets.PrimitiveSerializer(index).inputs,
        outputs => allnets.PrimitiveSerializer(index).outputs
        );
  end generate;

  process (inputs.clkin_50, allnets.rst.clk50)
  begin
    if (allnets.rst.clk50 = '1') then
      allregs.dout.clk50 <= reglist_clk50_default;
    elsif rising_edge(inputs.clkin_50) then
      allregs.dout.clk50 <= allregs.din.clk50;
    end if;
  end process;


  process (allnets.clk125, allnets.rst.clk125)
  begin
    if (allnets.rst.clk125 = '1') then
      allregs.dout.clk125 <= reglist_clk125_default;
    elsif rising_edge(allnets.clk125) then
      allregs.dout.clk125 <= allregs.din.clk125;
    end if;
  end process;



  process (inputs, allouts, allregs, allnets)
    procedure SubReset
      (
        variable i  : in    inputs_t;
        variable ri : in    reglist_t;
        variable ro : in    reglist_t;
        variable o  : inout outputs_t;
        variable r  : inout reglist_t;
        variable n  : inout netlist_t
        ) is
    begin

      n.clk125                := i.clkin_125;
      n.SyncRST.inputs.clk(1) := i.clkin_50;
      n.SyncRST.inputs.clr(1) := not(i.cpu_resetn);
      n.rst.main              := n.SyncRST.outputs.rst(1);


      n.SyncRST.inputs.clk(2) := n.clk125;
      n.SyncRST.inputs.clr(2) := n.rst.main;
      n.rst.clk125            := n.SyncRST.outputs.rst(2);


      n.SyncRST.inputs.clk(3) := i.clkin_50;
      n.SyncRST.inputs.clr(3) := n.rst.clk125;
      n.rst.clk50             := n.SyncRst.outputs.rst(3);

      n.SyncRst.inputs.clk(4) := '0';
      n.SyncRst.inputs.clr(4) := '1';

      n.SyncRst.inputs.clk(5) := '0';
      n.SyncRst.inputs.clr(5) := '1';


      n.SyncRst.inputs.clk(6) := '0';
      n.SyncRst.inputs.clr(6) := '1';


      n.SyncRst.inputs.clk(7) := '0';
      n.SyncRst.inputs.clr(7) := '1';


      n.SyncRst.inputs.clk(8) := '0';
      n.SyncRst.inputs.clr(8) := '1';

    end procedure;


    procedure SubMain                   --Setta tutti i clock e i macaddress
      (
        variable i  : in    inputs_t;
        variable ri : in    reglist_t;
        variable ro : in    reglist_t;
        variable o  : inout outputs_t;
        variable r  : inout reglist_t;
        variable n  : inout netlist_t
        ) is
    begin

      
      r.clk50.div2                     := not(ro.clk50.div2);
      r.clk125.hwaddress               := i.USER_DIPSW(7 downto 0);
      r.clk125.startData               := i.startData;
      r.clk125.framecounter_copy       := ro.clk125.framecounter;


      r.clk125.offset(0) := X"02";
      r.clk125.offset(1) := X"02";
      r.clk125.offset(2) := X"04";
      r.clk125.offset(3) := X"02";
      r.clk125.offset(4) := X"02";
      r.clk125.offset(5) := X"02";

      r.clk125.primitiveFIFOempty(0)   := i.primitiveFIFOempty0;
      r.clk125.primitiveFIFOempty(1)   := i.primitiveFIFOempty1;
      r.clk125.primitiveFIFOempty(2)   := i.primitiveFIFOempty2;
      r.clk125.primitiveFIFOempty(3)   := i.primitiveFIFOempty3;
      r.clk125.primitiveFIFOempty(4)   := i.primitiveFIFOempty4;
      r.clk125.primitiveFIFOempty(5)   := '0';
      r.clk125.primitiveFIFOempty(6)   := '0';

      o.readfromfifo0               := ro.clk125.readfromfifo(0);
      o.readfromfifo1               := ro.clk125.readfromfifo(1);
      o.readfromfifo2               := ro.clk125.readfromfifo(2);
      o.readfromfifo3               := ro.clk125.readfromfifo(3);
      o.readfromfifo4               := ro.clk125.readfromfifo(4);


      o.macdata                        := ro.clk125.macdata;
      o.macreceived                    := ro.clk125.macreceived;
      o.packetreceived                 := ro.clk125.packetreceived;

      o.detectorUnderInit              := ro.clk125.detectorUnderInit;
                                        --with primitives

      for index in 0 to ethlink_NODES - 2  loop
        n.bufferfifo(index).inputs.data  := (others => '0');
        n.bufferfifo(index).inputs.wrreq := '0';
        n.bufferfifo(index).inputs.rdreq := '0';        
        n.bufferfifo(index).inputs.clk   := n.clk125;
        n.bufferfifo(index).inputs.aclr  := not i.cpu_resetn;

        n.PrimitiveSerializer(index).inputs.clk    := n.clk125;
        n.PrimitiveSerializer(index).inputs.aclr   := not(i.cpu_resetn);
        n.PrimitiveSerializer(index).inputs.datain := i.PrimitiveDataIn(index);
        n.PrimitiveSerializer(index).inputs.rdreq  := '0';        

      end loop;
      
      for index in 0 to SGMII_NODES-1 loop
      
        
        -- Note: there are some limitations about bidirectional buffers: bidir components
        -- must be localized into top level entity so we create
        -- an i/o bus with sin/sout/sena
        
        -- MAC clock, reset
        n.MAC(index).inputs.ref_clk := n.clk125;         -- SGMII
                                                         -- 1000
                                                         -- --> n.clk125
        n.MAC(index).inputs.rst     := not i.cpu_resetn; -- async
                                                         -- -->
                                                         -- syncrst
                                                         -- embedded
                                                         -- into MAC

        -- MAC Avalon interface (indexed)

        n.MAC(index).inputs.clk := i.clkin_50; -- avalon bus
                                                              -- clock (also
                                                              -- CPU_PORT clock)
        n.MAC(index).inputs.mmaddress   := (others=>'0');
        n.MAC(index).inputs.mmread      := '0';
        n.MAC(index).inputs.mmwrite     := '0';
        n.MAC(index).inputs.mmwritedata := (others=>'0');


        -- MAC hardware address (indexed)
        n.MAC(index).inputs.nodeaddr := ro.clk125.hwaddress;
        n.MAC(index).inputs.nodeaddr(1 downto 0) := SLV(index, 2);
-- !! DEBUG !! constant address indexed (0..3)
        -- MAC multicast address (not used)
        n.MAC(index).inputs.multicastaddr := "00000000";

                    -- MAC CPU interface (0 --> interface OFF, 1..NPORTS -->
        -- interface ON)
        n.MAC(index).inputs.CPUtxport := "0000";
        n.MAC(index).inputs.CPUrxport := "0000";

        -- sgmii inputs (eth interface)
        n.MAC(index).inputs.rxp := i.rxp(index);

        -- sgmii outputs (eth interface)
        o.txp(index) := n.MAC(index).outputs.txp;

        -- sgmii phy async reset --
        o.resetn := i.cpu_resetn;
      end loop;


      --
      -- 'RGMII_NODES' interfaces
      --
      for index in 0 to RGMII_NODES-1 LOOP

        n.enet_MAC(index).inputs.ref_clk := n.clk125;         --
                                                              --RGMII
                                                              --1000
                                                              ----> n.clk125
        n.enet_MAC(index).inputs.rst     := not i.cpu_resetn;
-- async --> syncrst embedded into MAC

        n.enet_MAC(index).inputs.clk         := i.clkin_50;
-- avalon bus clock (also CPU_PORT clock)
        n.enet_MAC(index).inputs.mmaddress   := (others=>'0');
        n.enet_MAC(index).inputs.mmread      := '0';
        n.enet_MAC(index).inputs.mmwrite     :='0';
        n.enet_MAC(index).inputs.mmwritedata := (others=>'0');
        
        -- MAC hardware address (indexed)
        n.enet_MAC(index).inputs.nodeaddr := SLV(UINT(ro.clk125.hwaddress) + 4, 8);
-- RGMII maps to hwaddress + 4 (max 4 + 4 nodes)
        n.enet_MAC(index).inputs.nodeaddr(1 downto 0) := SLV(index, 2);
-- !! DEBUG !! constant address indexed (0..3)
        -- MAC multicast address (not used)
        n.enet_MAC(index).inputs.multicastaddr := "00000000";
        
        -- MAC CPU interface (0 --> interface OFF,
        -- 1..NPORTS --> interface ON)
        n.enet_MAC(index).inputs.CPUtxport := "0000";
        n.enet_MAC(index).inputs.CPUrxport := "0000";
        
        
        -- rgmii inputs (enet interface)
        n.enet_MAC(index).inputs.rxc := i.enet_rx_clk(index);
        n.enet_MAC(index).inputs.rx_ctl := i.enet_rx_dv(index);
        n.enet_MAC(index).inputs.rd := i.enet_rx_d(index)(3 downto 0);
        -- rgmii --> i.enet_rx_d(7 downto 4) not used
        -- rgmii --> i.enet_rx_er not used
        
        -- rgmii outputs (enet interface)
        o.enet_gtx_clk(index) := n.enet_MAC(index).outputs.txc;
        o.enet_tx_en(index)   := n.enet_MAC(index).outputs.tx_ctl;
        o.enet_tx_er(index)   := '0';
-- rgmii --> tx_er = gnd
        o.enet_tx_d(index)(3 downto 0) := n.enet_MAC(index).outputs.td;
        o.enet_tx_d(index)(7 downto 4) := "0000";
-- rgmii --> td_d(7..4) = gnd

        -- rgmii phy async reset -- 
        o.enet_resetn(index) := i.cpu_resetn;
        
      end LOOP;
      
      -- SGMII MAC inputs default values (wclk,wrst applied for Framegen operations)
      for index in 0 to SGMII_NODES - 1 LOOP
        for p in 1 to RX_NPORTS LOOP
          n.MAC(index).inputs.rack(p) := '0';
          n.MAC(index).inputs.rreq(p) := '0';
          n.MAC(index).inputs.rena(p) := '0';
          n.MAC(index).inputs.rclk(p) := '0';
          n.MAC(index).inputs.rrst(p) := '0';
        end LOOP;
        --
        for p in 1 to TX_NPORTS LOOP
          n.MAC(index).inputs.wtxclr(p)     := '0';
          n.MAC(index).inputs.wtxreq(p)     := '0';
          n.MAC(index).inputs.wmulticast(p) := '0';
          n.MAC(index).inputs.wdestaddr(p)  := "00000000";
          n.MAC(index).inputs.wdestport(p)  := "0000";
          n.MAC(index).inputs.wframelen(p)  := "00000000000";
          n.MAC(index).inputs.wdata(p)      := (others => '0');
          n.MAC(index).inputs.wreq(p)       := '0';
          n.MAC(index).inputs.wena(p)       := '0';
          n.MAC(index).inputs.wclk(p)       := n.clk125;
          n.MAC(index).inputs.wrst(p)       := n.rst.clk125;
        end LOOP;
      end LOOP;


      -- RGMII MAC inputs default values (wclk,wrst applied for Framegen operations)
      for index in 0 to RGMII_NODES - 1 LOOP
        for p in 1 to RX_NPORTS LOOP
          n.enet_MAC(index).inputs.rack(p) := '0';
          n.enet_MAC(index).inputs.rreq(p) := '0';
          n.enet_MAC(index).inputs.rena(p) := '0';
          n.enet_MAC(index).inputs.rclk(p) := '0';
          n.enet_MAC(index).inputs.rrst(p) := '0';
        end LOOP;
        --
        for p in 1 to TX_NPORTS LOOP
          n.enet_MAC(index).inputs.wtxclr(p)     := '0';
          n.enet_MAC(index).inputs.wtxreq(p)     := '0';
          n.enet_MAC(index).inputs.wmulticast(p) := '0';
          n.enet_MAC(index).inputs.wdestaddr(p)  := "00000000";
          n.enet_MAC(index).inputs.wdestport(p)  := "0000";
          n.enet_MAC(index).inputs.wframelen(p)  := "00000000000";
          n.enet_MAC(index).inputs.wdata(p)      := (others => '0');
          n.enet_MAC(index).inputs.wreq(p)       := '0';
          n.enet_MAC(index).inputs.wena(p)       := '0';
          n.enet_MAC(index).inputs.wclk(p)       := n.clk125;
          n.enet_MAC(index).inputs.wrst(p)       := n.rst.clk125;
        end LOOP;
      end LOOP;
    end procedure;



    procedure SubFillBuffer
      (
        variable i  : in    inputs_t;
        variable ri : in    reglist_clk125_t;
        variable ro : in    reglist_clk125_t;
        variable o  : inout outputs_t;
        variable r  : inout reglist_clk125_t;
        variable n  : inout netlist_t
        ) is
    begin

      -- 0 CHOD
      -- 1 RICH
      -- 2 LKr
      -- 3 MUV3
      -- 4 newCHOD
      -- 5 SPARE
      
      FOR index IN 0 to ethlink_NODES-2 LOOP
        n.bufferfifo(index).inputs.wrreq :='0';
        n.bufferfifo(index).inputs.data  := (others => '0');
        r.sendflag(index) := '0';
        n.PrimitiveSerializer(index).inputs.rdreq  := '0';
        r.readfromfifo(index) :='0';
        
        case ro.FSMBuffer(index) is

          when S0 =>
            if ro.startData = '1' then
              if ro.primitiveFIFOempty(index) ='0' then
                r.readfromfifo(index) := '1';--read primitive FIFO
                r.FSMBuffer(index)     := S1_Latency;
              end if;
            else
              n.bufferfifo(index).inputs.aclr  := '1';
              r.FSMBuffer(index)     := S0;
            end if;

           when S1_Latency => --WAITING DATA TO BE UPDATE IN THE SERIALIZER
            if ro.startData = '1' then
              r.FSMBuffer(index)     := S1_1_LATENCY;
            else
              r.FSMBuffer(index)     := S0;
            end if;

          when S1_1_Latency => --WAITING DATA TO BE UPDATE IN THE SERIALIZER
            if ro.startData = '1' then
              r.FSMBuffer(index)     := S1;
            else
              r.FSMBuffer(index)     := S0;
            end if;
            
          when S1 => --timestamp word handling
            if ro.startData = '1' then
                if n.PrimitiveSerializer(index).outputs.dataout(31 downto 24) = X"00" and SLV(UINT(n.PrimitiveSerializer(index).outputs.dataout(23 downto 0)) + UINT(ro.offset(index)),24) = ro.framecounter_copy(index)  and ro.primitiveFIFOempty(index) ='0' and UINT(ro.framecounter_copy(index)) > 0  then --timestamp word      
                  n.bufferfifo(index).inputs.data  := n.PrimitiveSerializer(index).outputs.dataout; --write the
                                                                          --timestamp word
                  n.bufferfifo(index).inputs.wrreq := '1';
                  r.primitiveinpacket(index)      := X"00"; --reset primitive in packet

                if( n.PrimitiveSerializer(index).outputs.rdpointer /="111") then
                    n.PrimitiveSerializer(index).inputs.rdreq := '1'; --read a new
                                                                      --word
                                                                      --from serializer
                    r.FSMBuffer(index)      := S2;
                  else
                    r.readfromfifo(index) := '1';
                    r.FSMBuffer(index)      := S2_latency;
                  end if;
                    
                else
                  r.FSMBuffer(index)     := S1;
                end if;
            else 
              r.FSMBuffer(index)     := S0;
            end if;
            
           -- when S1_WAITOUT =>
           -- if ro.startData = '1' then
           --   r.FSMBuffer(index)     := S2;
           -- else
           --   r.FSMBuffer(index)     := S0;
           -- end if;

          when S2 => --primitive word handling
            if ro.startData = '1' then
              if n.PrimitiveSerializer(index).outputs.dataout(31 downto 24) = X"00"  then --found another timestamp
                                                                --word: go back to S1
                r.FSMBuffer(index)     := S3;
                r.sendflag(index)      :='1'; --ready to write everything in the MAC
              else
                
                if(n.PrimitiveSerializer(index).outputs.rdpointer/="111") then
                  n.PrimitiveSerializer(index).inputs.rdreq := '1';
                  r.FSMBuffer(index)      := S2;
                else
                   r.readfromfifo(index) := '1'; --Read new word from FIFO
                   r.FSMBuffer(index)      := S2_latency;
                 end if;

                n.bufferfifo(index).inputs.data := n.PrimitiveSerializer(index).outputs.dataout; --primitive data
                n.bufferfifo(index).inputs.wrreq := '1';
                r.primitiveinpacket(index) := SLV(UINT(ro.primitiveinpacket(index))+1,8);
                
              end if;
            else 
              r.FSMBuffer(index)     := S0;
            end if;

            when S2_Latency =>
            if ro.startData = '1' then
              n.PrimitiveSerializer(index).inputs.rdreq := '1'; -- It goes to 0
              r.FSMBuffer(index)     := S2_2_LATENCY;
            else
              r.FSMBuffer(index)     := S0;
            end if;

          when S2_2_Latency =>
            if ro.startData = '1' then

              r.FSMBuffer(index)     := S2;
            else
              r.FSMBuffer(index)     := S0;
            end if;
            
          when S3 =>
            if ro.startData = '1' then      
              r.FSMBuffer(index)     := S1;
            else 
              r.FSMBuffer(index)     := S0;
            end if;


        end case;
      end LOOP;
    end procedure;
    

    procedure SubSendPrimitive
      (
        variable i  : in    inputs_t;
        variable ri : in    reglist_clk125_t;
        variable ro : in    reglist_clk125_t;
        variable o  : inout outputs_t;
        variable r  : inout reglist_clk125_t;
        variable n  : inout netlist_t
        ) is
    begin
      --TO TEST THE SYSTEM
      --L0Tribe port ===> L0TP port
      -- 0 CHOD      ===> 0 CHOD (192.168.1.4)
      -- 1 RICH      ===> 1 RICH (192.168.1.5)
      -- 2 LKr       ===> 2 was LAV, becomes LKr (192.168.1.6)
      
      -- 3 MUV3      ===> 5 was TALK becomes MUV3 (192.168.1.10)
      -- 4 newCHOD   ===> 6 was LKr, becomes newCHOD (192.168.1.11)

      -- 5 SPARE     ===> 3 used to send data to L0 tribe (192.168.1.7)
      
      FOR index IN 0 to SGMII_NODES-1 LOOP

        -- Tx FF_PORT defaults
        n.MAC(index).inputs.wtxclr(FF_PORT)     := '0';
        n.MAC(index).inputs.wtxreq(FF_PORT)     := '0';
        n.MAC(index).inputs.wmulticast(FF_PORT) := '0';

        --SEND DATA TO DE4_0-----------------------------------
        n.MAC(index).inputs.wdestport(FF_PORT) := SLV(2, 4);

        if index = 0 then
          n.MAC(index).inputs.wdestaddr(FF_PORT) := SLV(4, 8);  -- data to 1st
                                                                -- input of L0TP (CHOD)
          ---MTP DEFAULTS:
          r.SourceID(index)    := X"F4";
          r.SubSourceID(index) := X"F4";
        end if;

        if index = 1 then
          n.MAC(index).inputs.wdestaddr(FF_PORT) := SLV(5, 8);  -- data to 2nd
                                                                -- input of L0TP (RICH)
          ---MTP DEFAULTS:
          r.SourceID(index)    := X"F5";
          r.SubSourceID(index) := X"F5";
        end if;

        if index = 2 then
          n.MAC(index).inputs.wdestaddr(FF_PORT) := SLV(11, 8);  -- data to 3rd
                                                                -- input of L0TP (LKr)
          r.SourceID(index)    := X"F6";
          r.SubSourceID(index) := X"F6";
        end if;
        
          if index = 3 then
          n.MAC(index).inputs.wdestaddr(FF_PORT) := SLV(8, 8);  -- data to 7th
                                                                -- input of L0TP (MUV3)
          ---MTP DEFAULTS:
          r.SourceID(index)    := X"FA";
          r.SubSourceID(index) := X"FA";
        end if;

        


        r.MTPLength(index)   := SLV(UINT(r.primitiveinpacket(index))*4+12,16);
        r.MTPAssembly(index) := ro.framecounter(index); 
        
        n.MAC(index).inputs.wdata(FF_PORT) := (others =>'0');
        n.MAC(index).inputs.wreq(FF_PORT)  := '0';
        n.MAC(index).inputs.wena(FF_PORT)  := ro.wena(index);
        n.MAC(index).inputs.wclk(FF_PORT)  := n.clk125;
        n.MAC(index).inputs.wrst(FF_PORT)  := n.rst.clk125;   

        
        n.bufferfifo(index).inputs.rdreq := '0';

        
        
        case ro.FSMSend(index) is

          when S0 =>
            if ro.startData = '1' then
              r.latency(index)       := SLV(UINT(ro.latency(index))-1, 16);
              r.npackets(index)      :=X"00";
              r.wena(index)          := '1';              
              r.framecounter(index)  := ro.framecounter(index);
              
              if ro.sendflag(index) = '1' then --I have things in the bufferfifo
                r.FSMSend(index) := S1_header;
                
              elsif UINT(ro.latency(index)) = 4 then -- I have nothing, just write
                                                     -- the header
                r.FSMSend(index) := S1_header;
                
              else
                r.FSMSend(index)           := S0;
              end if;
              
            else --OOB
              n.MAC(index).inputs.wtxclr(FF_PORT) := '1';
              r.FSMSend(index)           := S0;
              r.latency(index)           := SLV(799, 16); --latency: 800*8: 6.4 us
              r.npackets(index)          :=X"00";
              r.wena(index)              := '0';
              r.framecounter(index)      :=X"000000";    
            end if;

          when S1_header =>
            --Write header: 64 bits already set as default
            if ro.startData = '1' then
              
              r.latency(index)       := SLV(UINT(ro.latency(index))-1, 16);
              r.framecounter(index)   := ro.framecounter(index);

              if n.MAC(index).outputs.wready(FF_PORT) = '1' and n.MAC(index).outputs.wfull(FF_PORT) = '0' then
                n.MAC(index).inputs.wdata(FF_PORT)(63 downto 56) := ro.SubSourceID(index);
                n.MAC(index).inputs.wdata(FF_PORT)(55 downto 48) := ro.primitiveinpacket(index);
                n.MAC(index).inputs.wdata(FF_PORT)(47 downto 32) := ro.MTPLength(index);

                n.MAC(index).inputs.wdata(FF_PORT)(31 downto 24) := ro.SourceID(index);
                n.MAC(index).inputs.wdata(FF_PORT)(23 downto 0)  := ro.framecounter(index);
                
                
                n.MAC(index).inputs.wreq(FF_PORT)                := '1';
                r.FSMSend(index) := S1;
                if ro.primitiveinpacket(index) /= X"00" then --leggo per tirare fuori
                                                             --la timestamp word!
                  n.bufferfifo(index).inputs.rdreq := '1';
                end if;
              else
                r.FSMSend(index) := S1;
              end if;--MAC ready




              
            else
              r.FSMSend(index) := S0;
            end if;
            
            
          when S1 =>
            --register the timestamp word and read buffer fifo
            if ro.startData = '1' then
              r.latency(index) := SLV(UINT(ro.latency(index))-1, 16); 	
              r.framecounter(index)  := ro.framecounter(index);
              
              if ro.primitiveinpacket(index) /= X"00" then
                r.tstmpword(index) :=  n.bufferfifo(index).outputs.q;
                r.FSMSend(index) := S1_1;
                n.bufferfifo(index).inputs.rdreq := '1';
                r.npackets(index) := SLV(UINT(ro.npackets(index)) +1,8);
                
              else
                --if I don't have any primitive to write, only header.
                if UINT(ro.latency(index)) = 1 then     
                  r.FSMSend(index) := S2;
                else 
                  r.FSMSend(index) := S1;
                end if;
              end if;
            else
              r.FSMSend(index) := S0;
            end if;


          when S1_1 =>
            --write the timestamp word together with the first primitive,
            --increment the counter of primitive written.
            if ro.startData = '1' then
              r.latency(index) := SLV(UINT(ro.latency(index))-1, 16);
              r.framecounter(index)  := ro.framecounter(index);
              n.MAC(index).inputs.wdata(FF_PORT)(63 downto 32):= n.bufferfifo(index).outputs.q; --data
              n.MAC(index).inputs.wdata(FF_PORT)(31 downto 0):= ro.tstmpword(index); --tstmpword
              
              if ro.npackets(index) < ro.primitiveinpacket(index) then
                n.MAC(index).inputs.wreq(FF_PORT):= '1';
                n.bufferfifo(index).inputs.rdreq := '1';
                r.npackets(index) := SLV(UINT(ro.npackets(index)) +1,8);
                r.FSMSend(index) := S1_2;
              else
                if UINT(ro.latency(index)) = 1 then     
                  r.FSMSend(index) := S2;
                  n.MAC(index).inputs.wreq(FF_PORT):= '1';
                end if;
              end if;

              
            else
              r.FSMSend(index) := S0;
            end if;


          when S1_2 =>
            -- register the new primitive in the MSB (which correspond to tstmpword)
            if ro.startData = '1' then
              r.latency(index) := SLV(UINT(ro.latency(index))-1, 16);
              r.framecounter(index)  := ro.framecounter(index);
              r.tstmpword(index) := n.bufferfifo(index).outputs.q;
              
              if ro.npackets(index) < ro.primitiveinpacket(index) then
                n.bufferfifo(index).inputs.rdreq := '1';
                r.npackets(index) := SLV(UINT(ro.npackets(index)) +1,8);
                r.FSMSend(index) := S1_3;
              else
                --if it was the last primitive, I write it in the MAC
                if UINT(ro.latency(index)) = 1 then
                  n.MAC(index).inputs.wdata(FF_PORT)(31 downto 0):= n.bufferfifo(index).outputs.q;
                  n.MAC(index).inputs.wreq(FF_PORT) := '1';
                  r.FSMSend(index) := S2;
                end if;
              end if;
            else
              r.FSMSend(index) := S0;
            end if;


          when S1_3 =>
            if ro.startData = '1' then
              r.latency(index) := SLV(UINT(ro.latency(index))-1, 16);
              r.framecounter(index)  := ro.framecounter(index);
              
              n.MAC(index).inputs.wdata(FF_PORT)(63 downto 32):= n.bufferfifo(index).outputs.q; --data
              n.MAC(index).inputs.wdata(FF_PORT)(31 downto 0):=  ro.tstmpword(index);

              if ro.npackets(index) < ro.primitiveinpacket(index) then
                n.bufferfifo(index).inputs.rdreq := '1';
                r.npackets(index) := SLV(UINT(ro.npackets(index)) +1,8);
                n.MAC(index).inputs.wreq(FF_PORT) := '1';
                r.FSMSend(index) := S1_2;
              else
                if UINT(ro.latency(index)) = 1 then
                  n.MAC(index).inputs.wreq(FF_PORT) := '1';
                  r.FSMSend(index) := S2;
                end if;
              end if;
            else
              r.FSMSend(index) := S0;
            end if;

            
            

          when S2 =>
            if ro.startData = '1' then              
              r.latency(index) := SLV(799, 16); --latency: 800*8: 6.4 us
              r.npackets(index)      :=X"00";
              r.framecounter(index)  := SLV(UINT(ro.framecounter(index))+1, 24);
              n.MAC(index).inputs.wframelen(FF_PORT) := SLV(28+UINT(ro.primitiveinpacket(index))*4+4+8+2, 11); --28:IPheader,
                                                                                                               --8:MTP-header
                                                                                                               --4:timestamp word
              n.MAC(index).inputs.wtxreq(FF_PORT) := '1';
              r.primitiveinpacket(index)          := X"00"; --reset primitive in packet
              r.FSMSend(index) := S0;
            else
              r.FSMSend(index) := S0;
            end if;
        end case;
      end LOOP;
      
    end procedure;

      procedure SubSendPrimitiveRGMII
      (
        variable i  : in    inputs_t;
        variable ri : in    reglist_clk125_t;
        variable ro : in    reglist_clk125_t;
        variable o  : inout outputs_t;
        variable r  : inout reglist_clk125_t;
        variable n  : inout netlist_t
        ) is
    begin
      --TO TEST THE SYSTEM
      --L0Tribe port ===> L0TP port
      -- 0 CHOD      ===> 0 CHOD (192.168.1.4)
      -- 1 RICH      ===> 1 RICH (192.168.1.5)
      -- 2 LKr       ===> 2 was LAV, becomes LKr (192.168.1.6)
      
      -- 3 MUV3      ===> 5 was TALK becomes MUV3 (192.168.1.10)
      -- 4 newCHOD   ===> 6 was LKr, becomes newCHOD (192.168.1.11)

      -- 5 SPARE     ===> 3 used to send data to L0 tribe (192.168.1.7)
      
      FOR index IN 0 to 0 LOOP

        -- Tx FF_PORT defaults
        n.enet_MAC(index).inputs.wtxclr(FF_PORT)     := '0';
        n.enet_MAC(index).inputs.wtxreq(FF_PORT)     := '0';
        n.enet_MAC(index).inputs.wmulticast(FF_PORT) := '0';

        --SEND DATA TO DE4_0-----------------------------------
        n.enet_MAC(index).inputs.wdestport(FF_PORT) := SLV(2, 4);

        if index = 0 then
          n.enet_MAC(index).inputs.wdestaddr(FF_PORT) := SLV(9, 8);  -- NewCHOD
          ---MTP DEFAULTS:
          r.SourceID(index+4)    := X"FB";
          r.SubSourceID(index+4) := X"FB";
        end if;

        if index = 1 then
          n.enet_MAC(index).inputs.wdestaddr(FF_PORT) := SLV(10, 8);  -- spare
                                                               
          ---MTP DEFAULTS:
          r.SourceID(index+4)    := X"FA";
          r.SubSourceID(index+4) := X"FA";
        end if;

        r.MTPLength(index+4)   := SLV(UINT(r.primitiveinpacket(index+4))*4+12,16);
        r.MTPAssembly(index+4) := ro.framecounter(index+4); 
        
        n.enet_MAC(index).inputs.wdata(FF_PORT) := (others =>'0');
        n.enet_MAC(index).inputs.wreq(FF_PORT)  := '0';
        n.enet_MAC(index).inputs.wena(FF_PORT)  := ro.wena(index+4);
        n.enet_MAC(index).inputs.wclk(FF_PORT)  := n.clk125;
        n.enet_MAC(index).inputs.wrst(FF_PORT)  := n.rst.clk125;   

        
        n.bufferfifo(index+4).inputs.rdreq := '0';

        
        
        case ro.FSMSend(index+4) is

          when S0 =>
            if ro.startData = '1' then
              r.latency(index+4)       := SLV(UINT(ro.latency(index+4))-1, 16);
              r.npackets(index+4)      :=X"00";
              r.wena(index+4)          := '1';              
              r.framecounter(index+4)  := ro.framecounter(index+4);
              
              if ro.sendflag(index+4) = '1' then --I have things in the bufferfifo
                r.FSMSend(index+4) := S1_header;
                
              elsif UINT(ro.latency(index+4)) = 4 then -- I have nothing, just write
                                                     -- the header
                r.FSMSend(index+4) := S1_header;
                
              else
                r.FSMSend(index+4)           := S0;
              end if;
              
            else --OOB
              n.enet_MAC(index).inputs.wtxclr(FF_PORT) := '1';
              r.FSMSend(index+4)           := S0;
              r.latency(index+4)           := SLV(799, 16); --latency: 800*8: 6.4 us
              r.npackets(index+4)          :=X"00";
              r.wena(index+4)              := '0';
              r.framecounter(index+4)      :=X"000000";    
            end if;

          when S1_header =>
            --Write header: 64 bits already set as default
            if ro.startData = '1' then
              
              r.latency(index+4)       := SLV(UINT(ro.latency(index+4))-1, 16);
              r.framecounter(index+4)   := ro.framecounter(index+4);

              if n.enet_MAC(index).outputs.wready(FF_PORT) = '1' and n.enet_MAC(index).outputs.wfull(FF_PORT) = '0' then
                n.enet_MAC(index).inputs.wdata(FF_PORT)(63 downto 56) := ro.SubSourceID(index+4);
                n.enet_MAC(index).inputs.wdata(FF_PORT)(55 downto 48) := ro.primitiveinpacket(index+4);
                n.enet_MAC(index).inputs.wdata(FF_PORT)(47 downto 32) := ro.MTPLength(index+4);

                n.enet_MAC(index).inputs.wdata(FF_PORT)(31 downto 24) := ro.SourceID(index+4);
                n.enet_MAC(index).inputs.wdata(FF_PORT)(23 downto 0)  := ro.framecounter(index+4);
                
                
                n.enet_MAC(index).inputs.wreq(FF_PORT)                := '1';
                r.FSMSend(index+4) := S1;
                if ro.primitiveinpacket(index+4) /= X"00" then --leggo per tirare fuori
                                                             --la timestamp word!
                  n.bufferfifo(index+4).inputs.rdreq := '1';
                end if;
              else
                r.FSMSend(index+4) := S1;
              end if;--enet_MAC ready




              
            else
              r.FSMSend(index+4) := S0;
            end if;
            
            
          when S1 =>
            --register the timestamp word and read buffer fifo
            if ro.startData = '1' then
              r.latency(index+4) := SLV(UINT(ro.latency(index+4))-1, 16); 	
              r.framecounter(index+4)  := ro.framecounter(index+4);
              
              if ro.primitiveinpacket(index+4) /= X"00" then
                r.tstmpword(index+4) :=  n.bufferfifo(index+4).outputs.q;
                r.FSMSend(index+4) := S1_1;
                n.bufferfifo(index+4).inputs.rdreq := '1';
                r.npackets(index+4) := SLV(UINT(ro.npackets(index+4)) +1,8);
                
              else
                --if I don't have any primitive to write, only header.
                if UINT(ro.latency(index+4)) = 1 then     
                  r.FSMSend(index+4) := S2;
                else 
                  r.FSMSend(index+4) := S1;
                end if;
              end if;
            else
              r.FSMSend(index+4) := S0;
            end if;


          when S1_1 =>
            --write the timestamp word together with the first primitive,
            --increment the counter of primitive written.
            if ro.startData = '1' then
              r.latency(index+4) := SLV(UINT(ro.latency(index+4))-1, 16);
              r.framecounter(index+4)  := ro.framecounter(index+4);
              n.enet_MAC(index).inputs.wdata(FF_PORT)(63 downto 32):= n.bufferfifo(index+4).outputs.q; --data
              n.enet_MAC(index).inputs.wdata(FF_PORT)(31 downto 0):= ro.tstmpword(index+4); --tstmpword
              
              if ro.npackets(index+4) < ro.primitiveinpacket(index+4) then
                n.enet_MAC(index).inputs.wreq(FF_PORT):= '1';
                n.bufferfifo(index+4).inputs.rdreq := '1';
                r.npackets(index+4) := SLV(UINT(ro.npackets(index+4)) +1,8);
                r.FSMSend(index+4) := S1_2;
              else
                if UINT(ro.latency(index+4)) = 1 then     
                  r.FSMSend(index+4) := S2;
                  n.enet_MAC(index).inputs.wreq(FF_PORT):= '1';
                end if;
              end if;

              
            else
              r.FSMSend(index+4) := S0;
            end if;


          when S1_2 =>
            -- register the new primitive in the MSB (which correspond to tstmpword)
            if ro.startData = '1' then
              r.latency(index+4) := SLV(UINT(ro.latency(index+4))-1, 16);
              r.framecounter(index+4)  := ro.framecounter(index+4);
              r.tstmpword(index+4) := n.bufferfifo(index+4).outputs.q;
              
              if ro.npackets(index+4) < ro.primitiveinpacket(index+4) then
                n.bufferfifo(index+4).inputs.rdreq := '1';
                r.npackets(index+4) := SLV(UINT(ro.npackets(index+4)) +1,8);
                r.FSMSend(index+4) := S1_3;
              else
                --if it was the last primitive, I write it in the enet_MAC
                if UINT(ro.latency(index+4)) = 1 then
                  n.enet_MAC(index).inputs.wdata(FF_PORT)(31 downto 0):= n.bufferfifo(index+4).outputs.q;
                  n.enet_MAC(index).inputs.wreq(FF_PORT) := '1';
                  r.FSMSend(index+4) := S2;
                end if;
              end if;
            else
              r.FSMSend(index+4) := S0;
            end if;


          when S1_3 =>
            if ro.startData = '1' then
              r.latency(index+4) := SLV(UINT(ro.latency(index+4))-1, 16);
              r.framecounter(index+4)  := ro.framecounter(index+4);
              
              n.enet_MAC(index).inputs.wdata(FF_PORT)(63 downto 32):= n.bufferfifo(index+4).outputs.q; --data
              n.enet_MAC(index).inputs.wdata(FF_PORT)(31 downto 0):=  ro.tstmpword(index+4);

              if ro.npackets(index+4) < ro.primitiveinpacket(index+4) then
                n.bufferfifo(index+4).inputs.rdreq := '1';
                r.npackets(index+4) := SLV(UINT(ro.npackets(index+4)) +1,8);
                n.enet_MAC(index).inputs.wreq(FF_PORT) := '1';
                r.FSMSend(index+4) := S1_2;
              else
                if UINT(ro.latency(index+4)) = 1 then
                  n.enet_MAC(index).inputs.wreq(FF_PORT) := '1';
                  r.FSMSend(index+4) := S2;
                end if;
              end if;
            else
              r.FSMSend(index+4) := S0;
            end if;

            
            

          when S2 =>
            if ro.startData = '1' then              
              r.latency(index+4) := SLV(799, 16); --latency: 800*8: 6.4 us
              r.npackets(index+4)      :=X"00";
              r.framecounter(index+4)  := SLV(UINT(ro.framecounter(index+4))+1, 24);
              n.enet_MAC(index).inputs.wframelen(FF_PORT) := SLV(28+UINT(ro.primitiveinpacket(index+4))*4+4+8+2, 11); --28:IPheader,
                                                                                                               --8:MTP-header
                                                                                                               --4:timestamp word
              n.enet_MAC(index).inputs.wtxreq(FF_PORT) := '1';
              r.primitiveinpacket(index+4)          := X"00"; --reset primitive in packet
              r.FSMSend(index+4) := S0;
            else
              r.FSMSend(index+4) := S0;
            end if;
        end case;
      end LOOP;
      
    end procedure;
  

-----------------------------------------------------------------	
-----------------------------------------------------------------
-----------------------------------------------------------------
    --Procedure to send data from ethernet to the external ram
    --ethernet port used: 0.
-----------------------------------------------------------------
-----------------------------------------------------------------
-----------------------------------------------------------------

    procedure SubReceive32bit
      (
        variable i : in inputs_t;
        variable ri: in reglist_clk125_t;
        variable ro: in reglist_clk125_t;
        variable o : inout outputs_t;
        variable r : inout reglist_clk125_t;
        variable n : inout netlist_t
        
        ) is
    begin


      
      
      
      n.MAC(3).outputs.rsrcport(FF_PORT):= SLV(2,4);
      n.MAC(3).outputs.rsrcaddr(FF_PORT)  :=SLV(11,8);
      
      
      -- Rx FF_PORT defaults
      n.MAC(3).inputs.rack(FF_PORT)       := '0';
      n.MAC(3).inputs.rreq(FF_PORT)       := '0';
      n.MAC(3).inputs.rena(FF_PORT)       := ro.rena(3);
      n.MAC(3).inputs.rclk(FF_PORT)       := n.clk125;
      n.MAC(3).inputs.rrst(FF_PORT)       := n.rst.clk125;
      
      r.macreceived := '0';
      r.macdata := (others=>'0');
      r.packetreceived :='0';
      
      case ro.FSMReceive32bit is
        
        when S0 =>
          if ro.startData = '0' then
            r.FSMReceive32bit := S1;
          else
            r.FSMReceive32bit := S0;
            r.rena(3):='0';
          end if;
          
        when S1 =>
          r.rena(3):='1';
          r.FSMReceive32bit := S2;
          
        when S2 =>
          if ro.startData = '0' then
            -----	waiting for new frame:
            if n.MAC(3).outputs.rready(FF_PORT) = '1' then
              if n.MAC(3).outputs.reoframe(FF_PORT) = '0' then
                n.MAC(3).inputs.rreq(FF_PORT) := '1'; --Read request to get the first byte
                r.FSMReceive32bit := S3_1;
              else
                r.packetreceived :='1';
                r.FSMReceive32bit := S4;
              end if;--EOF
            else
              r.FSMReceive32bit := S2;    
            end if; --MAC not Ready
          else -- in burst
            r.FSMReceive32bit := S0;
          end if;
          
        when S3_1 =>
          if ro.startData = '0' then
            r.data0 := n.MAC(3).outputs.rdata(FF_PORT); --byte 0
            if n.MAC(3).outputs.reoframe(FF_PORT) = '0' then
              n.MAC(3).inputs.rreq(FF_PORT):='1';    
              r.FSMReceive32bit:=S3_2;
            else
              r.packetreceived :='1';
              r.FSMReceive32bit := S4;		  
            end if;
          else -- in burst
            r.FSMReceive32bit := S0;
          end if;
          
        when S3_2 =>
          if ro.startData = '0' then
            r.data1 := n.MAC(3).outputs.rdata(FF_PORT); --byte 1
            if n.MAC(3).outputs.reoframe(FF_PORT) = '0' then
              n.MAC(3).inputs.rreq(FF_PORT):='1';    
              r.FSMReceive32bit:=S3_3;
            else
              r.packetreceived :='1';
              r.FSMReceive32bit := S4;		  
            end if;
          else -- in burst
            r.FSMReceive32bit := S0;
          end if;
          
        when S3_3 =>
          if ro.startData = '0' then
            r.data2 := n.MAC(3).outputs.rdata(FF_PORT); --byte 2
            if n.MAC(3).outputs.reoframe(FF_PORT) = '0' then
              n.MAC(3).inputs.rreq(FF_PORT):='1';    
              r.FSMReceive32bit:=S3_4;
            else
              r.packetreceived :='1';
              r.FSMReceive32bit := S4;		  
            end if;
          else -- in burst
            r.FSMReceive32bit := S0;
          end if;
          
        when S3_4 =>
          if ro.startData = '0' then
            r.data3 := n.MAC(3).outputs.rdata(FF_PORT); --byte 3
            if n.MAC(3).outputs.reoframe(FF_PORT) = '0' then
              n.MAC(3).inputs.rreq(FF_PORT):='1';    
              r.FSMReceive32bit:=S3_5;
            else
              r.packetreceived :='1';
              r.FSMReceive32bit := S4;		  
            end if;
          else -- in burst
            r.FSMReceive32bit := S0;
          end if;
          
        when S3_5 =>
          r.data4 := n.MAC(3).outputs.rdata(FF_PORT); --byte 4
          if n.MAC(3).outputs.reoframe(FF_PORT) = '0' then
            n.MAC(3).inputs.rreq(FF_PORT):='1';    
            r.FSMReceive32bit:=S3_6;
          else
            r.packetreceived :='1';
            r.FSMReceive32bit := S4;		  
          end if;
          
        when S3_6 =>
          r.data5 := n.MAC(3).outputs.rdata(FF_PORT); --byte 5
          if n.MAC(3).outputs.reoframe(FF_PORT) = '0' then
            n.MAC(3).inputs.rreq(FF_PORT):='1';    
            r.FSMReceive32bit:=S3_7;
          else
            r.packetreceived :='1';
            r.FSMReceive32bit := S4;		  
          end if;
          
          
        when S3_7 =>
          r.data6 := n.MAC(3).outputs.rdata(FF_PORT); --byte 6
          if n.MAC(3).outputs.reoframe(FF_PORT) = '0' then
            n.MAC(3).inputs.rreq(FF_PORT):='1';    
            r.FSMReceive32bit:=S3_8;
          else
            r.packetreceived :='1';
            r.FSMReceive32bit := S4;		  
          end if;
          
        when S3_8 =>                                  --byte 7
          if(ro.data0 & ro.data1 & ro.data2 & ro.data3 & ro.data4 & ro.data5 & ro.data6 = X"5A5A5A5A5A5A5A") then
            r.detectorUnderInit :=  n.MAC(3).outputs.rdata(FF_PORT)(3 downto 0);
            r.macreceived := '0';
            r.macdata := (others=>'0');      
          else
            r.detectorUnderInit :=  ro.detectorUnderInit;
            r.macdata :=     ro.data0 &
                             ro.data1 &
                             ro.data2 &
                             ro.data3 &
                             ro.data4 &
                             ro.data5 &
                             ro.data6 &
                             n.MAC(3).outputs.rdata(FF_PORT);
            r.macreceived := '1';
        end if;
          if n.MAC(3).outputs.reoframe(FF_PORT) = '0' then
            n.MAC(3).inputs.rreq(FF_PORT):='1';    
            r.FSMReceive32bit:=S3_1;
          else
            r.packetreceived :='1';
            r.FSMReceive32bit := S4;		  
          end if;
          
          if n.MAC(3).outputs.rready(FF_PORT) ='0' then
            r.FSMReceive32bit := S2;
          end if;		  
          
        when S4 => --END OF FRAME
          if n.MAC(3).outputs.rready(FF_PORT) = '1' then  
            n.MAC(3).inputs.rack(FF_PORT) := '1';
          else
            null;
          end if;
          r.FSMReceive32bit := S0;
      end case;
      
    end procedure;
      

        procedure SubReceive32bitRGMII
      (
        variable i : in inputs_t;
        variable ri: in reglist_clk125_t;
        variable ro: in reglist_clk125_t;
        variable o : inout outputs_t;
        variable r : inout reglist_clk125_t;
        variable n : inout netlist_t
        
        ) is
    begin

      
      
      
      n.enet_MAC(1).outputs.rsrcport(FF_PORT):= SLV(2,4);
      n.enet_MAC(1).outputs.rsrcaddr(FF_PORT)  :=SLV(11,8);
      
      
      -- Rx FF_PORT defaults
      n.enet_MAC(1).inputs.rack(FF_PORT)       := '0';
      n.enet_MAC(1).inputs.rreq(FF_PORT)       := '0';
      n.enet_MAC(1).inputs.rena(FF_PORT)       := ro.rena(5);
      n.enet_MAC(1).inputs.rclk(FF_PORT)       := n.clk125;
      n.enet_MAC(1).inputs.rrst(FF_PORT)       := n.rst.clk125;
      
      r.macreceived := '0';
      r.macdata := (others=>'0');
      r.packetreceived :='0';
      
      case ro.FSMReceive32bitRGMII is
        
        when S0 =>
          if ro.startData = '0' then
            r.FSMReceive32bitRGMII := S1;
          else
            r.FSMReceive32bitRGMII := S0;
            r.rena(5):='0';
          end if;
          
        when S1 =>
          r.rena(5):='1';
          r.FSMReceive32bitRGMII := S2;
          
        when S2 =>
          if ro.startData = '0' then
            -----	waiting for new frame:
            if n.enet_MAC(1).outputs.rready(FF_PORT) = '1' then
              if n.enet_MAC(1).outputs.reoframe(FF_PORT) = '0' then
                n.enet_MAC(1).inputs.rreq(FF_PORT) := '1'; --Read request to get the first byte
                r.FSMReceive32bitRGMII := S3_1;
              else
                r.packetreceived :='1';
                r.FSMReceive32bitRGMII := S4;
              end if;--EOF
            else
              r.FSMReceive32bitRGMII := S2;    
            end if; --MAC not Ready
          else -- in burst
            r.FSMReceive32bitRGMII := S0;
          end if;
          
        when S3_1 =>
          if ro.startData = '0' then
            r.data0 := n.enet_MAC(1).outputs.rdata(FF_PORT); --byte 0
            if n.enet_MAC(1).outputs.reoframe(FF_PORT) = '0' then
              n.enet_MAC(1).inputs.rreq(FF_PORT):='1';    
              r.FSMReceive32bitRGMII:=S3_2;
            else
              r.packetreceived :='1';
              r.FSMReceive32bitRGMII := S4;		  
            end if;
          else -- in burst
            r.FSMReceive32bitRGMII := S0;
          end if;
          
        when S3_2 =>
          if ro.startData = '0' then
            r.data1 := n.enet_MAC(1).outputs.rdata(FF_PORT); --byte 1
            if n.enet_MAC(1).outputs.reoframe(FF_PORT) = '0' then
              n.enet_MAC(1).inputs.rreq(FF_PORT):='1';    
              r.FSMReceive32bitRGMII:=S3_3;
            else
              r.packetreceived :='1';
              r.FSMReceive32bitRGMII := S4;		  
            end if;
          else -- in burst
            r.FSMReceive32bitRGMII := S0;
          end if;
          
        when S3_3 =>
          if ro.startData = '0' then
            r.data2 := n.enet_MAC(1).outputs.rdata(FF_PORT); --byte 2
            if n.enet_MAC(1).outputs.reoframe(FF_PORT) = '0' then
              n.enet_MAC(1).inputs.rreq(FF_PORT):='1';    
              r.FSMReceive32bitRGMII:=S3_4;
            else
              r.packetreceived :='1';
              r.FSMReceive32bitRGMII := S4;		  
            end if;
          else -- in burst
            r.FSMReceive32bitRGMII := S0;
          end if;
          
        when S3_4 =>
          if ro.startData = '0' then
            r.data3 := n.enet_MAC(1).outputs.rdata(FF_PORT); --byte 3
            if n.enet_MAC(1).outputs.reoframe(FF_PORT) = '0' then
              n.enet_MAC(1).inputs.rreq(FF_PORT):='1';    
              r.FSMReceive32bitRGMII:=S3_5;
            else
              r.packetreceived :='1';
              r.FSMReceive32bitRGMII := S4;		  
            end if;
          else -- in burst
            r.FSMReceive32bitRGMII := S0;
          end if;
          
        when S3_5 =>
          r.data4 := n.enet_MAC(1).outputs.rdata(FF_PORT); --byte 4
          if n.enet_MAC(1).outputs.reoframe(FF_PORT) = '0' then
            n.enet_MAC(1).inputs.rreq(FF_PORT):='1';    
            r.FSMReceive32bitRGMII:=S3_6;
          else
            r.packetreceived :='1';
            r.FSMReceive32bitRGMII := S4;		  
          end if;
          
        when S3_6 =>
          r.data5 := n.enet_MAC(1).outputs.rdata(FF_PORT); --byte 5
          if n.enet_MAC(1).outputs.reoframe(FF_PORT) = '0' then
            n.enet_MAC(1).inputs.rreq(FF_PORT):='1';    
            r.FSMReceive32bitRGMII:=S3_7;
          else
            r.packetreceived :='1';
            r.FSMReceive32bitRGMII := S4;		  
          end if;
          
          
        when S3_7 =>
          r.data6 := n.enet_MAC(1).outputs.rdata(FF_PORT); --byte 6
          if n.enet_MAC(1).outputs.reoframe(FF_PORT) = '0' then
            n.enet_MAC(1).inputs.rreq(FF_PORT):='1';    
            r.FSMReceive32bitRGMII:=S3_8;
          else
            r.packetreceived :='1';
            r.FSMReceive32bitRGMII := S4;		  
          end if;
          
        when S3_8 =>                                  --byte 7
          if(ro.data0 & ro.data1 & ro.data2 & ro.data3 & ro.data4 & ro.data5 & ro.data6 = X"5A5A5A5A5A5A5A") then
            r.detectorUnderInit :=  n.enet_MAC(1).outputs.rdata(FF_PORT)(3 downto 0);
            r.macreceived := '0';
            r.macdata := (others=>'0');      
          else
            r.detectorUnderInit :=  ro.detectorUnderInit;
            r.macdata :=     ro.data0 &
                             ro.data1 &
                             ro.data2 &
                             ro.data3 &
                             ro.data4 &
                             ro.data5 &
                             ro.data6 &
                             n.enet_MAC(1).outputs.rdata(FF_PORT);
            r.macreceived := '1';
        end if;
          if n.enet_MAC(1).outputs.reoframe(FF_PORT) = '0' then
            n.enet_MAC(1).inputs.rreq(FF_PORT):='1';    
            r.FSMReceive32bitRGMII:=S3_1;
          else
            r.packetreceived :='1';
            r.FSMReceive32bitRGMII := S4;		  
          end if;
          
          if n.enet_MAC(1).outputs.rready(FF_PORT) ='0' then
            r.FSMReceive32bitRGMII := S2;
          end if;		  
          
        when S4 => --END OF FRAME
          if n.enet_MAC(1).outputs.rready(FF_PORT) = '1' then  
            n.enet_MAC(1).inputs.rack(FF_PORT) := '1';
          else
            null;
          end if;
          r.FSMReceive32bitRGMII := S0;
      end case;
      
    end procedure;

      
    
    
    variable i  : inputs_t;
    variable ri : reglist_t;
    variable ro : reglist_t;
    variable o  : outputs_t;
    variable r  : reglist_t;
    variable n  : netlist_t;
  begin
    -- read only variables
    i  := inputs;
    ri := allregs.din;
    ro := allregs.dout;
    -- read/write variables
    o  := allouts;
    r  := allregs.dout;
    n  := allnets;


    -- all clock domains
    SubMain(i, ri, ro, o, r, n);
    SubReset(i, ri, ro, o, r, n);

    SubFillBuffer(i, ri.clk125, ro.clk125, o, r.clk125, n);
    SubSendPrimitive(i, ri.clk125, ro.clk125, o, r.clk125, n);
    SubSendPrimitiveRGMII(i, ri.clk125, ro.clk125, o, r.clk125, n);
    SubReceive32bit(i, ri.clk125, ro.clk125, o, r.clk125, n);
--    SubReceive32bitRGMII(i, ri.clk125, ro.clk125, o, r.clk125, n);
    
    
    -- allouts/regs/nets updates
    allouts     <= o;
    allregs.din <= r;
    allnets     <= n;

  end process;

  outputs <= allouts;

end rtl;
