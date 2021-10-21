library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_BIT.all;
use work.userlib.all;
use work.component_ethlink.all;


entity Controller is
  generic (Ndet : integer := 14);
end Controller;

architecture rtl of Controller is


   constant clkin_50       : time := 20000 ps; --Internal oscillator

  --ports:
  signal s_OSCILL_50 :   std_logic;
  signal s_resetn    :   std_logic;
  signal s_CHOKE     :  std_logic_vector(Ndet - 1 downto 0);  --one for each detector
  signal s_error     :  std_logic_vector(Ndet - 1 downto 0);  --one for each detector
  signal s_BCRST :  std_logic;
  signal s_ECRST :  std_logic;
  signal s_LTU0        :  std_logic;
  signal s_LTU1        :  std_logic;
  signal s_LTU2        :  std_logic;
  signal s_LTU3        :  std_logic;
  signal s_LTU4        :  std_logic;
  signal s_LTU5        :  std_logic;
  signal s_LTU_TRIGGER :  std_logic;
  signal s_Led1 :  std_logic;
  signal s_SMA_clkout_p :  std_logic;
  signal s_sw0 :  std_logic;
  signal s_sw1 :  std_logic;
  signal s_sw2 :  std_logic;
  signal s_sw3 :  std_logic;
  signal s_BUTTON0 :  std_logic;
  signal s_SW :  std_logic_vector(7 downto 0);  --



  
--PLL SIGNALS-----------------
  signal pll_c0           : std_logic;
  signal pll_locked       : std_logic;
------------------------------
  signal counter_RUN      : unsigned(31 downto 0);
  signal counter_INTERRUN : unsigned(31 downto 0);

  type FSM_tstmp is (idle, sob, run, eob);
  signal state             : FSM_tstmp;
  signal s_readdata        : std_logic;
  signal s_RUN             : std_logic;
------------------------------------------------
  signal mdio_sin          : std_logic_vector(0 to 3);
  signal mdio_sena         : std_logic_vector(0 to 3);
  signal mdio_sout         : std_logic_vector(0 to 3);
-------------------------------------------------
--trigger_input
  signal s_timestamp       : std_logic_vector(31 downto 0);
  signal s_triggerword     : std_logic_vector(5 downto 0);
  signal s_numberoftrigger : std_logic_vector(24 downto 0);
  signal s_received        : std_logic;
  signal s_outtrigger      : std_logic;                                               
                                               
                                               
                                               


  
  component pll is
    port
      (
        areset : in  std_logic;
        inclk0 : in  std_logic;
        c0     : out std_logic;
        locked : out std_logic
        );
  end component;

  component Trigger_input is
    port
      (
        clk40           : in  std_logic;
        clk50           : in  std_logic;
        LTU0            : in  std_logic;
        LTU1            : in  std_logic;
        LTU2            : in  std_logic;
        LTU3            : in  std_logic;
        LTU4            : in  std_logic;
        LTU5            : in  std_logic;
        LTU_TRIGGER     : in  std_logic;
        RUN             : in  std_logic;
        timestamp       : out std_logic_vector(31 downto 0);
        triggerword     : out std_logic_vector(5 downto 0);
        numberoftrigger : out std_logic_vector(24 downto 0);
        received        : out std_logic
        );
  end component;



  component random is
    port (
      clk           : in  std_logic;
      reset         : in  std_logic;
      RUN           : in  std_logic;
      validateCHOKE : out std_logic_vector (Ndet - 1 downto 0);  --output CHOKE
      validateERROR : out std_logic_vector (Ndet - 1 downto 0)   --output ERROR
      );
  end component;

---------


begin

  PLL_INST : pll port map
    (
      areset => '0',
      inclk0 => s_OSCILL_50,
      c0     => pll_c0,                 --40 MHz
      locked => pll_locked
      );

  RANDOM_INST : random port map
    (
      clk           => pll_c0,          --40 MHz
      reset         => '0',
      RUN           => s_RUN,
      validateCHOKE => s_CHOKE,
      validateERROR => s_error
      );


--This module manages the ethernet output to the L0TP or to a workstation.
--The first 3 ethernet ports send primitives to L0TP reading them from
--preset-RAMs. The third sends the sampled triggers to the workstation
--It includes also and internal PLL for the 125 MHz clock domain. I never moved
--it to the top level of the project.


--LINK 0: IP Sorgente: 192.168.1.16
--         MAC Sorgente: 00:01:02:03:04:10
--         IP Destinatario: 192.168.1.5
--         MAC Destinatario: 00:01:02:03:04:05
--LINK 0 has to be plug in Link 1 of L0TP

--LINK 1: IP Sorgente: 192.168.1.17
--         MAC Sorgente: 00:01:02:03:04:11
--         IP Destinatario: 192.168.1.11
--         MAC Destinatario: 00:01:02:03:04:0b
--LINK 1 has to be plug in Link 8 of L0TP

--Trigger are sent from LINK 3

  ethlink_inst : ethlink port map
    (
      inputs.clkin_50   => s_OSCILL_50,
      inputs.cpu_resetn => '1',

      inputs.startdata  => s_RUN,
      inputs.sw0        => '0',
      inputs.sw1        => '0',
      inputs.sw2        => '0',
      inputs.sw3        => '0',

      inputs.timestamp       => (others=>'0'),
      inputs.numberoftrigger => (others=>'0'),
      inputs.triggerword     => (others=>'0'),
      inputs.received        => '0',

      outputs.outtrigger     => s_outtrigger
      );



  clock:process
  begin
    s_OSCILL_50 <='0';
    wait for clkin_50/2;

    s_OSCILL_50 <='1';
    wait for clkin_50/2;
  end process;

  GEN_RESET: process
  begin
    s_resetn <= '0';
    wait for 50 ns;
    s_resetn <= '1';
    wait;
  end process;
  
    
  process(s_resetn,pll_c0)
  begin

    s_sma_clkout_p <= pll_c0;             -- clock to L0TP

    if s_resetn = '0' then
      counter_INTERRUN <= (others => '0');
      counter_RUN      <= (others => '0');
      state            <= idle;
      s_readdata       <= '0';
    elsif rising_edge(pll_c0) then
      case state is
        when idle =>
          counter_INTERRUN <= counter_INTERRUN +1;
          counter_RUN      <= (others => '0');
          if counter_INTERRUN > 10 then  --10 sec
            s_readdata <= '1';
            state      <= sob;
          else
            s_readdata <= '0';
            state      <= idle;
          end if;

        when sob =>
          counter_INTERRUN <= (others => '0');
          state            <= run;
          s_readdata       <= '0';


        when run =>
          s_readdata  <= '0';
          counter_RUN <= counter_RUN +1;
          if counter_RUN > 200000000 then  --5 sec
            state <= eob;
          else
            state <= run;
          end if;

        when eob =>
          s_readdata  <= '0';
          counter_RUN <= (others => '0');
          state       <= idle;
      end case;
    end if;
  end process;


-- Output depends on the current state
-- BCRST and ECRST to determine SOB / EOB
--
--BCRST=1 and ECRST='1' => SOB signal
--BCRST=0 and ECRST='1' => EOB signal
--BCRST=0 and ECRST='0' => previous state
--BCRST=1 and ECRST='0' => Not Permitted
--
--

  process (state)
  begin
    s_RUN <= '0';
    case state is
      when idle =>
        s_Led1  <= '1';                   -- inverse logic
        s_BCRST <= '0';
        s_ECRST <= '0';
      when sob =>
        s_Led1  <= '0';
        s_ECRST <= '1';
        s_BCRST <= '1';

      when run =>
        s_RUN <= '1';
        s_Led1  <= '0';
        s_BCRST <= '0';
        s_ECRST <= '0';
      when eob =>
        s_Led1  <= '1';
        s_ECRST <= '1';
        s_BCRST <= '0';
    end case;
  end process;




  
end rtl;
