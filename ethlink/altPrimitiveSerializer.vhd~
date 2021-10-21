library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
use IEEE.NUMERIC_BIT.all;
use work.globals.all;
use work.userlib.all;
--Module to handle SOB and EOB signals. Moreover, it monitors the choke/error
--signals to stop/re-enable the data taking during the burst.
--Each choke source can be masked by a register.

entity altTTC is
   port (clk40             : in std_logic; --40 MHZ FROM LTU
	 reset           : in std_logic;
	 startRUN        : in std_logic;
	 BCRST           : in std_logic;
	 BURST             : out std_logic;
         BURSTERROR      : out std_logic_vector(5 downto 0);
	 ECRST           : in std_logic;
	 led1            : out std_logic;
	 led3            : out std_logic;
    
	 CHOKE           : in std_logic_vector(13 downto 0);
	 ERROR           : in std_logic_vector(13 downto 0);
         FAKECHOKE       : in std_logic_vector(13 downto 0);
	 FAKEERROR       : in std_logic_vector(13 downto 0);
	 
	 CHOKE_ON        : out std_logic;   
	 CHOKE_OFF       : out std_logic;  
	 ERROR_ON   		 : out std_logic;	 
	 ERROR_OFF   	 : out std_logic;		 
	 CHOKE_signal    : out std_logic_vector(13 downto 0);
	 ERROR_signal    : out std_logic_vector(13 downto 0);
	 activateCHOKE   : in std_logic;
	 activateERROR   : in std_logic;
	 CHOKEMASK       : in std_logic_vector(13 downto 0);
	 ERRORMASK       : in std_logic_vector(13 downto 0)
	 );

end altTTC;

architecture rtl of altTTC is
   type FSMChoke_t is (Idle,Chokestate,Dead_time0,Dead_time1,Dead_time2,Dead_time3);
   type FSMERROR_t is (Idle,ERRORstate,Dead_time0,Dead_time1);
   type FSMBurst_t is (Idle,Burststate,Dead_time0,Dead_time1,Dead_time2,Dead_time3);

   signal FSMChoke          : FSMChoke_t;
   signal FSMERROR          : FSMError_t;
   signal FSMBurst          : FSMBurst_t;
   
   signal s_n_of_choke      : std_logic_vector(31 downto 0);
   signal s_n_of_error      : std_logic_vector(31 downto 0);
   signal s_BURST           : std_logic;
   signal s_BURSTERROR      : std_logic_vector(5 downto 0);     
   signal s_CHOKE_OFF       : std_logic;
   signal s_CHOKE_ON        : std_logic;
   signal s_ERROR_OFF       : std_logic;
   signal s_ERROR_ON        : std_logic;
   signal s_CHOKE           : std_logic_vector(13 downto 0);
   signal s_ERROR           : std_logic_vector(13 downto 0);
   signal s_FAKECHOKE       : std_logic_vector(13 downto 0);
   signal s_FAKEERROR       : std_logic_vector(13 downto 0);            
   signal CHOKE_s1          : std_logic_vector(13 downto 0);
   signal CHOKE_s2          : std_logic_vector(13 downto 0);
   signal ERROR_s1          : std_logic_vector(13 downto 0);
   signal ERROR_s2          : std_logic_vector(13 downto 0);
   signal s_CHOKEMASK       : std_logic_vector(13 downto 0);
   signal s_ERRORMASK       : std_logic_vector(13 downto 0);

   signal s_ECRST           : std_logic;
   signal s_BCRST           : std_logic;
begin



   s_ECRST <= ECRST;
   s_BCRST <= BCRST;

   
	
	
process(clk40, reset,CHOKE,ERROR,FAKECHOKE,FAKEERROR,CHOKEMASK,ERRORMASK) is
 begin
    if(reset = '1') then
         CHOKE_s1    <= (others=>'0');
         ERROR_s1    <= (others=>'0');           
	 CHOKE_s2    <= (others=>'0');
         ERROR_s2    <= (others=>'0');           
         
	 s_FAKEERROR <= (others=>'0');
         s_FAKECHOKE <= (others=>'0');
         
    elsif (clk40='1' and clk40'event)  then
         s_CHOKEMASK <= CHOKEMASK;
         s_ERRORMASK <= ERRORMASK;
         CHOKE_s2  <= CHOKE and CHOKEMASK;
         ERROR_s2  <= ERROR and ERRORMASK;
	 
         s_FAKEERROR <= FAKEERROR;
         s_FAKECHOKE <= FAKECHOKE;
       end if;
 end process;
--
--
-- process(clk40, reset) is
-- begin
--    if(rising_edge(clk40)) then
--       if(reset = '1') then
--          ERROR_s1 <= (others=>'0');
--          ERROR_s2 <= (others=>'0');
--       else
--          ERROR_s1 <= s_ERROR;
--          ERROR_s2 <= ERROR_s1;
--       end if;
--    end if;
-- end process;
--

   P1: PROCESS(clk40,s_ECRST,s_BCRST,startRUN)
   begin
       if(clk40='1' and clk40'event)  then
	 if startRUN ='1' then --FROM USB
	    if(s_ECRST='1' and s_BCRST='1')then --SOB
	       s_BURST<='1';
	    elsif (s_BCRST='0' and s_ECRST='1')  then --EOB
	       s_BURST <='0';
	    else
	       s_BURST <= s_BURST;
	    end if;	
	 else
	    s_BURST<='0';
	 end if;
     end if;	
   end PROCESS;

 PError: PROCESS(clk40,s_ECRST,s_BCRST)
 begin
   if(clk40='1' and clk40'event)  then
     if (s_ECRST='1' and s_BCRST='1' and s_BURST = '1')  then --sob without eob
       s_BURSTERROR <= "100000";
     elsif (s_ECRST='1' and s_BCRST='1' and s_BURST = '0')  then --good sob
       s_BURSTERROR <= "000000";
     else
       s_BURSTERROR  <=s_BURSTERROR;
     end if;
    end if;      
   end PROCESS;


 

 
   CHOKE_P: PROCESS(reset,clk40,CHOKE_s2,s_FAKECHOKE)
   begin
      if reset ='1' then 
	 
	 FSMChoke <= Idle;

      elsif rising_edge(clk40) then
	 
	 case FSMChoke is
	    
	    when idle =>
	       if activateCHOKE ='1' then --FROM USB
		  if (CHOKE_s2 or s_FAKECHOKE) = "00000000000000"   then
		     FSMChoke <= Idle;
		  else
		     FSMChoke <= Chokestate;
		  end if;
	       else
		  FSMChoke <= Idle;
	       end if;
	       
	    when Chokestate =>
	       if activateCHOKE ='1' then --FROM USB
		  if (CHOKE_s2 or s_FAKECHOKE) = "00000000000000"  then
		     FSMChoke <= Dead_time0;
		  else
		     FSMChoke <= Chokestate;
		  end if;
	       else
		  FSMChoke <= Idle;
	       end if;

	    when Dead_time0 =>
	       
	       if activateCHOKE ='1' then --FROM USB
		  if (CHOKE_s2 or s_FAKECHOKE) = "00000000000000"  then
		     FSMChoke <= Dead_time1;
		  else
		     FSMChoke <= Chokestate;
		  end if;
	       else
		  FSMChoke <= Idle;
	       end if;
	       
	    when Dead_time1 =>
	      if activateCHOKE ='1' then --FROM USB
	        if (CHOKE_s2 or s_FAKECHOKE) = "00000000000000"  then
		     FSMChoke <= Dead_time2;
		  else
		     FSMChoke <= Chokestate;
		  end if;
	       else
		  FSMChoke <= Idle;
	       end if;

         when Dead_time2 =>
           if activateCHOKE ='1' then --FROM USB
	        if (CHOKE_s2 or s_FAKECHOKE) = "00000000000000"  then
		     FSMChoke <= Dead_time3;
		else
		     FSMChoke <= Chokestate;
	       end if;

	    else
                FSMChoke <= Idle;
	    end if;

	 when Dead_time3 =>
           if activateCHOKE ='1' then --FROM USB
	        if (CHOKE_s2 or s_FAKECHOKE) = "00000000000000"  then
		   FSMChoke <= Idle;
		  else
		     FSMChoke <= Chokestate;
		  end if;
	       else
		  FSMChoke <= Idle;
	       end if;
	 end case;
      end if;
   end PROCESS;

-- Output depends on the current state
   process (FSMChoke)
   begin
      s_CHOKE_ON  <='0';
      s_CHOKE_OFF <='1';
      case FSMChoke is
	 when idle =>
	    s_CHOKE_ON  <='0';
	    s_CHOKE_OFF <='1';
	 when Chokestate =>
	    s_CHOKE_ON  <='1';
	    s_CHOKE_OFF <='0';
	 when Dead_time0 =>
	    s_CHOKE_ON  <='1';
	    s_CHOKE_OFF <='0';
	 when Dead_time1 =>
	    s_CHOKE_ON  <='1';
	    s_CHOKE_OFF <='0';
	 when Dead_time2 =>
	    s_CHOKE_ON  <='1';
	    s_CHOKE_OFF <='0';
	 when Dead_time3 =>
	    s_CHOKE_ON  <='1';
	    s_CHOKE_OFF <='0';
      end case;
   end process;

   ERROR_P: PROCESS(reset,clk40,ERROR_s2, s_FAKEERROR)
   begin
      if reset ='1' then 
	 
	 FSMERROR <= Idle;

      elsif rising_edge(clk40) then
	 
	 case FSMERROR is
	    
	    when idle =>
	       if activateERROR ='1' then --FROM USB
		  if (ERROR_s2 or s_FAKEERROR) = "00000000000000"  then
		     FSMERROR <= Idle;
		  else
		     FSMERROR <= ERRORstate;
		  end if;
	       else
		  FSMERROR <= Idle;
	       end if;
	       
	    when ERRORstate =>
	       if activateERROR ='1' then --FROM USB
		  if (ERROR_s2 or s_FAKEERROR) = "00000000000000" then
		     FSMERROR <= Dead_time0;
		  else
		     FSMERROR <= ERRORstate;
		  end if;
	       else
		  FSMERROR <= Idle;
	       end if;
	       
	    when Dead_time0 =>
	       
	       FSMERROR <= Dead_time1;
	       
	    when Dead_time1 =>
	       
	       FSMERROR <= Idle;
	       
	 end case;
      end if;
   end PROCESS;

-- Output depends on the current state
   process (FSMERROR)
   begin
      s_ERROR_ON  <='0';
      s_ERROR_OFF <='1';
      case FSMERROR is
	 when idle =>
	    s_ERROR_ON  <='0';
	    s_ERROR_OFF <='1';
	 when ERRORstate =>
	    s_ERROR_ON  <='1';
	    s_ERROR_OFF <='0';
	 when Dead_time0 =>
	    s_ERROR_ON  <='1';
	    s_ERROR_OFF <='0';
	 when Dead_time1 =>
	    s_ERROR_ON  <='1';
	    s_ERROR_OFF <='0';
      end case;
   end process;



 ERROR_ON       <= s_ERROR_ON   ;
 ERROR_OFF      <= s_ERROR_OFF  ;
 CHOKE_ON       <= s_CHOKE_ON   ;
 CHOKE_OFF      <= s_CHOKE_OFF  ;
 BURST    	<= s_BURST      ;
 BURSTERROR     <= s_BURSTERROR ;
 Led1           <= s_BURST      ;
 Led3           <= not(s_BURST) ; --Led of EOB
 CHOKE_signal   <= CHOKE_s2     ;
 ERROR_signal   <= ERROR_s2     ;



END RTL;
