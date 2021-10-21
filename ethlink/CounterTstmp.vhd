library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;
use work.userlib.all;
use work.GLOBALS.all;

--Timestamp generator.
--It uses 40 MHz PLL-clock
--To pass timestamp from 40 MHz to 125 MHz: Dual clock fifo.
--the outputs are registered.
--only 30 bit of timestamp generated (107 seconds)

entity altcountertimestamp is
   port (
      clock40               : in STD_LOGIC;
      clock125              : in STD_LOGIC;
      BURST                 : in STD_LOGIC;
      internal_timestamp    : out STD_LOGIC_VECTOR(29 downto 0);
      internal_timestamp125 : out STD_LOGIC_VECTOR(29 downto 0)
      );
end entity;

architecture rtl of altcountertimestamp is
   signal timestamp : std_logic_vector(29 downto 0);
   signal s_rdreq : std_logic;
   signal s_wrreq : std_logic;
   signal s_internal_timestamp125 : std_logic_vector(29 downto 0);
   signal s_rdempty : std_logic;
   signal s_rdfull  : std_logic;
   signal s_rdusedw : std_logic_vector(4 downto 0);
   signal s_wrempty : std_logic;
   signal s_wrfull  : std_logic;
   signal s_wrusedw : std_logic_vector(4 downto 0);
   signal s_aclr    : std_logic;
 
      component altFIFOtstmp IS 
	 port
	    (
	       aclr		: IN STD_LOGIC  := '0';
	       data		: IN STD_LOGIC_VECTOR (29 DOWNTO 0);
	       rdclk		: IN STD_LOGIC ;
	       rdreq		: IN STD_LOGIC ;
	       wrclk		: IN STD_LOGIC ;
	       wrreq		: IN STD_LOGIC ;
	       
	       q		: OUT STD_LOGIC_VECTOR (29 DOWNTO 0);
	       rdempty		: OUT STD_LOGIC ;
	       rdfull		: OUT STD_LOGIC ;
	       rdusedw		: OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
	       wrempty		: OUT STD_LOGIC ;
	       wrfull		: OUT STD_LOGIC ;
	       wrusedw		: OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
	       );	  
      end component;

begin


   FIFOTstsmp_inst : altFIFOtstmp port map (
      aclr	   => s_aclr,
      data	   => timestamp,
      rdclk	   => clock125 ,
      rdreq	   => s_rdreq,
      wrclk	   => clock40 ,
      wrreq	   => s_wrreq ,
      q		   => s_internal_timestamp125,
      rdempty      => s_rdempty,
      rdfull       => s_rdfull,
      rdusedw      => s_rdusedw,
      wrempty      => s_wrempty,
      wrfull       => s_wrfull,
      wrusedw      => s_wrusedw
      );

   PROCESS(clock40, BURST)
   begin
      if (BURST = '0') then
	 timestamp <= (OTHERS => '0');
      elsif (clock40'event) and (clock40 = '1')then
	 timestamp <= SLV(UINT(timestamp) + 1,30);
	 s_wrreq <='1';
      end if;
   end process;
   
   
   PROCESS(clock125, BURST)
   begin
      if (BURST='0') then
	 s_aclr<='1';
      elsif (clock125'event) and (clock125 = '1')then
	 s_aclr<='0';
	 if s_rdempty ='0' then
	    s_rdreq<='1';
	 else
	    s_rdreq<='0';
	 end if;
      end if;
   end process;

   internal_timestamp125<=s_internal_timestamp125;
   internal_timestamp <= timestamp; --40 MHz
   
end rtl;


