library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
use IEEE.NUMERIC_BIT.all;
use work.userlib.all;

entity altPrimitiveSerializer is
   port (
         clk              : in std_logic;
         aclr             : in std_logic;
	 datain           : in std_logic_vector(255 downto 0);
         rdreq            : in std_logic;
	 dataout          : out std_logic_vector(31 downto 0);
         rdpointer        : out std_logic_vector(2 downto 0)
	 );

end altPrimitiveSerializer;

architecture rtl of altPrimitiveSerializer is

 
  signal s_datain : std_logic_vector(255 downto 0);
  signal s_rdpointer : std_logic_vector(2 downto 0);

begin

   s_datain   <= datain;
   
   rdpointer <= s_rdpointer;

 process(aclr,clk) is                  
 begin
   if(aclr = '1') then
     s_rdpointer <= (others => '0');
   elsif(clk'event and clk='1') then
     if(rdreq = '1') then
       s_rdpointer <= SLV(UINT(s_rdpointer)+1,3);
     else
       s_rdpointer <= s_rdpointer;
     end if;
    end if;
   end process;

     
process(s_rdpointer) is
  begin
    --32 bit output:   --Change the direction of the data in:
       if(s_rdpointer = "111") then
         dataout(31 downto 24) <= s_datain(231 downto 224);
         dataout(23 downto 16) <= s_datain(239 downto 232);
         dataout(15 downto 8) <=  s_datain(247 downto 240);
         dataout(7 downto 0) <=   s_datain(255 downto 248);
         
       elsif(s_rdpointer = "110") then
          dataout(31 downto 24) <= s_datain(199 downto 192);
          dataout(23 downto 16) <= s_datain(207 downto 200);
          dataout(15 downto 8)  <= s_datain(215 downto 208);
          dataout(7 downto 0)   <= s_datain(223 downto 216);
          
       elsif(s_rdpointer = "101") then
          dataout(31 downto 24) <= s_datain(167 downto 160);
          dataout(23 downto 16) <= s_datain(175 downto 168);
          dataout(15 downto 8)  <= s_datain(183 downto 176);
          dataout(7 downto 0)   <= s_datain(191 downto 184);
                                   
               
       elsif(s_rdpointer = "100") then
          dataout(31 downto 24) <= s_datain(135 downto 128);
          dataout(23 downto 16) <= s_datain(143 downto 136);
          dataout(15 downto 8)  <= s_datain(151 downto 144);
          dataout(7 downto 0)   <= s_datain(159 downto 152);
               
       elsif(s_rdpointer = "011") then
          dataout(31 downto 24)  <= s_datain(103 downto 96) ;
          dataout(23 downto 16)  <= s_datain(111 downto 104) ;
          dataout(15 downto 8)   <= s_datain(119 downto 112) ;
          dataout(7 downto 0)    <= s_datain(127 downto 120) ;
               
       elsif(s_rdpointer = "010") then
          dataout(31 downto 24)  <= s_datain(71 downto 64) ;
          dataout(23 downto 16)  <= s_datain(79 downto 72) ;
          dataout(15 downto 8)   <= s_datain(87 downto 80) ;
          dataout(7 downto 0)    <= s_datain(95 downto 88) ;
               
       elsif(s_rdpointer = "001") then
          dataout(31 downto 24)  <= s_datain(39 downto 32) ;
          dataout(23 downto 16)  <= s_datain(47 downto 40) ;
          dataout(15 downto 8)   <= s_datain(55 downto 48) ;
          dataout(7 downto 0)    <= s_datain(63 downto 56) ;
               
       elsif(s_rdpointer = "000") then
          dataout(31 downto 24)  <= s_datain(7 downto 0);
          dataout(23 downto 16)  <= s_datain(15 downto 8);
          dataout(15 downto 8)   <= s_datain(23 downto 16);
          dataout(7 downto 0)    <= s_datain(31 downto 24);
               
       end if;
end process;
                    
END RTL;
