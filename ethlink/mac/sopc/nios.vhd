--megafunction wizard: %Altera SOPC Builder%
--GENERATION: STANDARD
--VERSION: WM1.0


--Legal Notice: (C)2014 Altera Corporation. All rights reserved.  Your
--use of Altera Corporation's design tools, logic functions and other
--software and tools, and its AMPP partner logic functions, and any
--output files any of the foregoing (including device programming or
--simulation files), and any associated documentation or information are
--expressly subject to the terms and conditions of the Altera Program
--License Subscription Agreement or other applicable license agreement,
--including, without limitation, that your use is for the sole purpose
--of programming logic devices manufactured by Altera and sold by Altera
--or its authorized distributors.  Please refer to the applicable
--agreement for further details.


-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity cpu_jtag_debug_module_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_data_master_debugaccess : IN STD_LOGIC;
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_instruction_master_read : IN STD_LOGIC;
                 signal cpu_jtag_debug_module_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_jtag_debug_module_resetrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_data_master_requests_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_instruction_master_granted_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_instruction_master_qualified_request_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_instruction_master_requests_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_address : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
                 signal cpu_jtag_debug_module_begintransfer : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_jtag_debug_module_chipselect : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_debugaccess : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_jtag_debug_module_reset_n : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_resetrequest_from_sa : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_write : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_cpu_jtag_debug_module_end_xfer : OUT STD_LOGIC
              );
end entity cpu_jtag_debug_module_arbitrator;


architecture europa of cpu_jtag_debug_module_arbitrator is
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_instruction_master_arbiterlock :  STD_LOGIC;
                signal cpu_instruction_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_instruction_master_continuerequest :  STD_LOGIC;
                signal cpu_instruction_master_saved_grant_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_jtag_debug_module_allgrants :  STD_LOGIC;
                signal cpu_jtag_debug_module_allow_new_arb_cycle :  STD_LOGIC;
                signal cpu_jtag_debug_module_any_bursting_master_saved_grant :  STD_LOGIC;
                signal cpu_jtag_debug_module_any_continuerequest :  STD_LOGIC;
                signal cpu_jtag_debug_module_arb_addend :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_arb_counter_enable :  STD_LOGIC;
                signal cpu_jtag_debug_module_arb_share_counter :  STD_LOGIC;
                signal cpu_jtag_debug_module_arb_share_counter_next_value :  STD_LOGIC;
                signal cpu_jtag_debug_module_arb_share_set_values :  STD_LOGIC;
                signal cpu_jtag_debug_module_arb_winner :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_arbitration_holdoff_internal :  STD_LOGIC;
                signal cpu_jtag_debug_module_beginbursttransfer_internal :  STD_LOGIC;
                signal cpu_jtag_debug_module_begins_xfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_chosen_master_double_vector :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cpu_jtag_debug_module_chosen_master_rot_left :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_end_xfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_firsttransfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_grant_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_in_a_read_cycle :  STD_LOGIC;
                signal cpu_jtag_debug_module_in_a_write_cycle :  STD_LOGIC;
                signal cpu_jtag_debug_module_master_qreq_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_non_bursting_master_requests :  STD_LOGIC;
                signal cpu_jtag_debug_module_reg_firsttransfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_saved_chosen_master_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_slavearbiterlockenable :  STD_LOGIC;
                signal cpu_jtag_debug_module_slavearbiterlockenable2 :  STD_LOGIC;
                signal cpu_jtag_debug_module_unreg_firsttransfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_waits_for_read :  STD_LOGIC;
                signal cpu_jtag_debug_module_waits_for_write :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_cpu_jtag_debug_module :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_cpu_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_cpu_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_data_master_requests_cpu_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_instruction_master_granted_cpu_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_instruction_master_qualified_request_cpu_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_instruction_master_requests_cpu_jtag_debug_module :  STD_LOGIC;
                signal last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module :  STD_LOGIC;
                signal last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module :  STD_LOGIC;
                signal shifted_address_to_cpu_jtag_debug_module_from_cpu_data_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal shifted_address_to_cpu_jtag_debug_module_from_cpu_instruction_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal wait_for_cpu_jtag_debug_module_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT cpu_jtag_debug_module_end_xfer;
    end if;

  end process;

  cpu_jtag_debug_module_begins_xfer <= NOT d1_reasons_to_wait AND ((internal_cpu_data_master_qualified_request_cpu_jtag_debug_module OR internal_cpu_instruction_master_qualified_request_cpu_jtag_debug_module));
  --assign cpu_jtag_debug_module_readdata_from_sa = cpu_jtag_debug_module_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  cpu_jtag_debug_module_readdata_from_sa <= cpu_jtag_debug_module_readdata;
  internal_cpu_data_master_requests_cpu_jtag_debug_module <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(13 DOWNTO 11) & std_logic_vector'("00000000000")) = std_logic_vector'("00000000000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --cpu_jtag_debug_module_arb_share_counter set values, which is an e_mux
  cpu_jtag_debug_module_arb_share_set_values <= std_logic'('1');
  --cpu_jtag_debug_module_non_bursting_master_requests mux, which is an e_mux
  cpu_jtag_debug_module_non_bursting_master_requests <= ((internal_cpu_data_master_requests_cpu_jtag_debug_module OR internal_cpu_instruction_master_requests_cpu_jtag_debug_module) OR internal_cpu_data_master_requests_cpu_jtag_debug_module) OR internal_cpu_instruction_master_requests_cpu_jtag_debug_module;
  --cpu_jtag_debug_module_any_bursting_master_saved_grant mux, which is an e_mux
  cpu_jtag_debug_module_any_bursting_master_saved_grant <= std_logic'('0');
  --cpu_jtag_debug_module_arb_share_counter_next_value assignment, which is an e_assign
  cpu_jtag_debug_module_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_jtag_debug_module_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_jtag_debug_module_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(cpu_jtag_debug_module_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_jtag_debug_module_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --cpu_jtag_debug_module_allgrants all slave grants, which is an e_mux
  cpu_jtag_debug_module_allgrants <= (((or_reduce(cpu_jtag_debug_module_grant_vector)) OR (or_reduce(cpu_jtag_debug_module_grant_vector))) OR (or_reduce(cpu_jtag_debug_module_grant_vector))) OR (or_reduce(cpu_jtag_debug_module_grant_vector));
  --cpu_jtag_debug_module_end_xfer assignment, which is an e_assign
  cpu_jtag_debug_module_end_xfer <= NOT ((cpu_jtag_debug_module_waits_for_read OR cpu_jtag_debug_module_waits_for_write));
  --end_xfer_arb_share_counter_term_cpu_jtag_debug_module arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_cpu_jtag_debug_module <= cpu_jtag_debug_module_end_xfer AND (((NOT cpu_jtag_debug_module_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --cpu_jtag_debug_module_arb_share_counter arbitration counter enable, which is an e_assign
  cpu_jtag_debug_module_arb_counter_enable <= ((end_xfer_arb_share_counter_term_cpu_jtag_debug_module AND cpu_jtag_debug_module_allgrants)) OR ((end_xfer_arb_share_counter_term_cpu_jtag_debug_module AND NOT cpu_jtag_debug_module_non_bursting_master_requests));
  --cpu_jtag_debug_module_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_jtag_debug_module_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(cpu_jtag_debug_module_arb_counter_enable) = '1' then 
        cpu_jtag_debug_module_arb_share_counter <= cpu_jtag_debug_module_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu_jtag_debug_module_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_jtag_debug_module_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((or_reduce(cpu_jtag_debug_module_master_qreq_vector) AND end_xfer_arb_share_counter_term_cpu_jtag_debug_module)) OR ((end_xfer_arb_share_counter_term_cpu_jtag_debug_module AND NOT cpu_jtag_debug_module_non_bursting_master_requests)))) = '1' then 
        cpu_jtag_debug_module_slavearbiterlockenable <= cpu_jtag_debug_module_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master cpu/jtag_debug_module arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= cpu_jtag_debug_module_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --cpu_jtag_debug_module_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  cpu_jtag_debug_module_slavearbiterlockenable2 <= cpu_jtag_debug_module_arb_share_counter_next_value;
  --cpu/data_master cpu/jtag_debug_module arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= cpu_jtag_debug_module_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --cpu/instruction_master cpu/jtag_debug_module arbiterlock, which is an e_assign
  cpu_instruction_master_arbiterlock <= cpu_jtag_debug_module_slavearbiterlockenable AND cpu_instruction_master_continuerequest;
  --cpu/instruction_master cpu/jtag_debug_module arbiterlock2, which is an e_assign
  cpu_instruction_master_arbiterlock2 <= cpu_jtag_debug_module_slavearbiterlockenable2 AND cpu_instruction_master_continuerequest;
  --cpu/instruction_master granted cpu/jtag_debug_module last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_instruction_master_saved_grant_cpu_jtag_debug_module) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((cpu_jtag_debug_module_arbitration_holdoff_internal OR NOT internal_cpu_instruction_master_requests_cpu_jtag_debug_module))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module))))));
    end if;

  end process;

  --cpu_instruction_master_continuerequest continued request, which is an e_mux
  cpu_instruction_master_continuerequest <= last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module AND internal_cpu_instruction_master_requests_cpu_jtag_debug_module;
  --cpu_jtag_debug_module_any_continuerequest at least one master continues requesting, which is an e_mux
  cpu_jtag_debug_module_any_continuerequest <= cpu_instruction_master_continuerequest OR cpu_data_master_continuerequest;
  internal_cpu_data_master_qualified_request_cpu_jtag_debug_module <= internal_cpu_data_master_requests_cpu_jtag_debug_module AND NOT (((((NOT cpu_data_master_waitrequest) AND cpu_data_master_write)) OR cpu_instruction_master_arbiterlock));
  --cpu_jtag_debug_module_writedata mux, which is an e_mux
  cpu_jtag_debug_module_writedata <= cpu_data_master_writedata;
  internal_cpu_instruction_master_requests_cpu_jtag_debug_module <= ((to_std_logic(((Std_Logic_Vector'(cpu_instruction_master_address_to_slave(13 DOWNTO 11) & std_logic_vector'("00000000000")) = std_logic_vector'("00000000000000")))) AND (cpu_instruction_master_read))) AND cpu_instruction_master_read;
  --cpu/data_master granted cpu/jtag_debug_module last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_data_master_saved_grant_cpu_jtag_debug_module) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((cpu_jtag_debug_module_arbitration_holdoff_internal OR NOT internal_cpu_data_master_requests_cpu_jtag_debug_module))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module))))));
    end if;

  end process;

  --cpu_data_master_continuerequest continued request, which is an e_mux
  cpu_data_master_continuerequest <= last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module AND internal_cpu_data_master_requests_cpu_jtag_debug_module;
  internal_cpu_instruction_master_qualified_request_cpu_jtag_debug_module <= internal_cpu_instruction_master_requests_cpu_jtag_debug_module AND NOT (cpu_data_master_arbiterlock);
  --allow new arb cycle for cpu/jtag_debug_module, which is an e_assign
  cpu_jtag_debug_module_allow_new_arb_cycle <= NOT cpu_data_master_arbiterlock AND NOT cpu_instruction_master_arbiterlock;
  --cpu/instruction_master assignment into master qualified-requests vector for cpu/jtag_debug_module, which is an e_assign
  cpu_jtag_debug_module_master_qreq_vector(0) <= internal_cpu_instruction_master_qualified_request_cpu_jtag_debug_module;
  --cpu/instruction_master grant cpu/jtag_debug_module, which is an e_assign
  internal_cpu_instruction_master_granted_cpu_jtag_debug_module <= cpu_jtag_debug_module_grant_vector(0);
  --cpu/instruction_master saved-grant cpu/jtag_debug_module, which is an e_assign
  cpu_instruction_master_saved_grant_cpu_jtag_debug_module <= cpu_jtag_debug_module_arb_winner(0) AND internal_cpu_instruction_master_requests_cpu_jtag_debug_module;
  --cpu/data_master assignment into master qualified-requests vector for cpu/jtag_debug_module, which is an e_assign
  cpu_jtag_debug_module_master_qreq_vector(1) <= internal_cpu_data_master_qualified_request_cpu_jtag_debug_module;
  --cpu/data_master grant cpu/jtag_debug_module, which is an e_assign
  internal_cpu_data_master_granted_cpu_jtag_debug_module <= cpu_jtag_debug_module_grant_vector(1);
  --cpu/data_master saved-grant cpu/jtag_debug_module, which is an e_assign
  cpu_data_master_saved_grant_cpu_jtag_debug_module <= cpu_jtag_debug_module_arb_winner(1) AND internal_cpu_data_master_requests_cpu_jtag_debug_module;
  --cpu/jtag_debug_module chosen-master double-vector, which is an e_assign
  cpu_jtag_debug_module_chosen_master_double_vector <= A_EXT (((std_logic_vector'("0") & ((cpu_jtag_debug_module_master_qreq_vector & cpu_jtag_debug_module_master_qreq_vector))) AND (((std_logic_vector'("0") & (Std_Logic_Vector'(NOT cpu_jtag_debug_module_master_qreq_vector & NOT cpu_jtag_debug_module_master_qreq_vector))) + (std_logic_vector'("000") & (cpu_jtag_debug_module_arb_addend))))), 4);
  --stable onehot encoding of arb winner
  cpu_jtag_debug_module_arb_winner <= A_WE_StdLogicVector((std_logic'(((cpu_jtag_debug_module_allow_new_arb_cycle AND or_reduce(cpu_jtag_debug_module_grant_vector)))) = '1'), cpu_jtag_debug_module_grant_vector, cpu_jtag_debug_module_saved_chosen_master_vector);
  --saved cpu_jtag_debug_module_grant_vector, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_jtag_debug_module_saved_chosen_master_vector <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(cpu_jtag_debug_module_allow_new_arb_cycle) = '1' then 
        cpu_jtag_debug_module_saved_chosen_master_vector <= A_WE_StdLogicVector((std_logic'(or_reduce(cpu_jtag_debug_module_grant_vector)) = '1'), cpu_jtag_debug_module_grant_vector, cpu_jtag_debug_module_saved_chosen_master_vector);
      end if;
    end if;

  end process;

  --onehot encoding of chosen master
  cpu_jtag_debug_module_grant_vector <= Std_Logic_Vector'(A_ToStdLogicVector(((cpu_jtag_debug_module_chosen_master_double_vector(1) OR cpu_jtag_debug_module_chosen_master_double_vector(3)))) & A_ToStdLogicVector(((cpu_jtag_debug_module_chosen_master_double_vector(0) OR cpu_jtag_debug_module_chosen_master_double_vector(2)))));
  --cpu/jtag_debug_module chosen master rotated left, which is an e_assign
  cpu_jtag_debug_module_chosen_master_rot_left <= A_EXT (A_WE_StdLogicVector((((A_SLL(cpu_jtag_debug_module_arb_winner,std_logic_vector'("00000000000000000000000000000001")))) /= std_logic_vector'("00")), (std_logic_vector'("000000000000000000000000000000") & ((A_SLL(cpu_jtag_debug_module_arb_winner,std_logic_vector'("00000000000000000000000000000001"))))), std_logic_vector'("00000000000000000000000000000001")), 2);
  --cpu/jtag_debug_module's addend for next-master-grant
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_jtag_debug_module_arb_addend <= std_logic_vector'("01");
    elsif clk'event and clk = '1' then
      if std_logic'(or_reduce(cpu_jtag_debug_module_grant_vector)) = '1' then 
        cpu_jtag_debug_module_arb_addend <= A_WE_StdLogicVector((std_logic'(cpu_jtag_debug_module_end_xfer) = '1'), cpu_jtag_debug_module_chosen_master_rot_left, cpu_jtag_debug_module_grant_vector);
      end if;
    end if;

  end process;

  cpu_jtag_debug_module_begintransfer <= cpu_jtag_debug_module_begins_xfer;
  --cpu_jtag_debug_module_reset_n assignment, which is an e_assign
  cpu_jtag_debug_module_reset_n <= reset_n;
  --assign cpu_jtag_debug_module_resetrequest_from_sa = cpu_jtag_debug_module_resetrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  cpu_jtag_debug_module_resetrequest_from_sa <= cpu_jtag_debug_module_resetrequest;
  cpu_jtag_debug_module_chipselect <= internal_cpu_data_master_granted_cpu_jtag_debug_module OR internal_cpu_instruction_master_granted_cpu_jtag_debug_module;
  --cpu_jtag_debug_module_firsttransfer first transaction, which is an e_assign
  cpu_jtag_debug_module_firsttransfer <= A_WE_StdLogic((std_logic'(cpu_jtag_debug_module_begins_xfer) = '1'), cpu_jtag_debug_module_unreg_firsttransfer, cpu_jtag_debug_module_reg_firsttransfer);
  --cpu_jtag_debug_module_unreg_firsttransfer first transaction, which is an e_assign
  cpu_jtag_debug_module_unreg_firsttransfer <= NOT ((cpu_jtag_debug_module_slavearbiterlockenable AND cpu_jtag_debug_module_any_continuerequest));
  --cpu_jtag_debug_module_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_jtag_debug_module_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(cpu_jtag_debug_module_begins_xfer) = '1' then 
        cpu_jtag_debug_module_reg_firsttransfer <= cpu_jtag_debug_module_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --cpu_jtag_debug_module_beginbursttransfer_internal begin burst transfer, which is an e_assign
  cpu_jtag_debug_module_beginbursttransfer_internal <= cpu_jtag_debug_module_begins_xfer;
  --cpu_jtag_debug_module_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  cpu_jtag_debug_module_arbitration_holdoff_internal <= cpu_jtag_debug_module_begins_xfer AND cpu_jtag_debug_module_firsttransfer;
  --cpu_jtag_debug_module_write assignment, which is an e_mux
  cpu_jtag_debug_module_write <= internal_cpu_data_master_granted_cpu_jtag_debug_module AND cpu_data_master_write;
  shifted_address_to_cpu_jtag_debug_module_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --cpu_jtag_debug_module_address mux, which is an e_mux
  cpu_jtag_debug_module_address <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_cpu_jtag_debug_module)) = '1'), (A_SRL(shifted_address_to_cpu_jtag_debug_module_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010"))), (A_SRL(shifted_address_to_cpu_jtag_debug_module_from_cpu_instruction_master,std_logic_vector'("00000000000000000000000000000010")))), 9);
  shifted_address_to_cpu_jtag_debug_module_from_cpu_instruction_master <= cpu_instruction_master_address_to_slave;
  --d1_cpu_jtag_debug_module_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_cpu_jtag_debug_module_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_cpu_jtag_debug_module_end_xfer <= cpu_jtag_debug_module_end_xfer;
    end if;

  end process;

  --cpu_jtag_debug_module_waits_for_read in a cycle, which is an e_mux
  cpu_jtag_debug_module_waits_for_read <= cpu_jtag_debug_module_in_a_read_cycle AND cpu_jtag_debug_module_begins_xfer;
  --cpu_jtag_debug_module_in_a_read_cycle assignment, which is an e_assign
  cpu_jtag_debug_module_in_a_read_cycle <= ((internal_cpu_data_master_granted_cpu_jtag_debug_module AND cpu_data_master_read)) OR ((internal_cpu_instruction_master_granted_cpu_jtag_debug_module AND cpu_instruction_master_read));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= cpu_jtag_debug_module_in_a_read_cycle;
  --cpu_jtag_debug_module_waits_for_write in a cycle, which is an e_mux
  cpu_jtag_debug_module_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_jtag_debug_module_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --cpu_jtag_debug_module_in_a_write_cycle assignment, which is an e_assign
  cpu_jtag_debug_module_in_a_write_cycle <= internal_cpu_data_master_granted_cpu_jtag_debug_module AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= cpu_jtag_debug_module_in_a_write_cycle;
  wait_for_cpu_jtag_debug_module_counter <= std_logic'('0');
  --cpu_jtag_debug_module_byteenable byte enable port mux, which is an e_mux
  cpu_jtag_debug_module_byteenable <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_cpu_jtag_debug_module)) = '1'), (std_logic_vector'("0000000000000000000000000000") & (cpu_data_master_byteenable)), -SIGNED(std_logic_vector'("00000000000000000000000000000001"))), 4);
  --debugaccess mux, which is an e_mux
  cpu_jtag_debug_module_debugaccess <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_cpu_jtag_debug_module)) = '1'), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_debugaccess))), std_logic_vector'("00000000000000000000000000000000")));
  --vhdl renameroo for output signals
  cpu_data_master_granted_cpu_jtag_debug_module <= internal_cpu_data_master_granted_cpu_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_cpu_jtag_debug_module <= internal_cpu_data_master_qualified_request_cpu_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_data_master_requests_cpu_jtag_debug_module <= internal_cpu_data_master_requests_cpu_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_instruction_master_granted_cpu_jtag_debug_module <= internal_cpu_instruction_master_granted_cpu_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_instruction_master_qualified_request_cpu_jtag_debug_module <= internal_cpu_instruction_master_qualified_request_cpu_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_instruction_master_requests_cpu_jtag_debug_module <= internal_cpu_instruction_master_requests_cpu_jtag_debug_module;
--synthesis translate_off
    --cpu/jtag_debug_module enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_data_master_granted_cpu_jtag_debug_module))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_instruction_master_granted_cpu_jtag_debug_module))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line, now);
          write(write_line, string'(": "));
          write(write_line, string'("> 1 of grant signals are active simultaneously"));
          write(output, write_line.all);
          deallocate (write_line);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --saved_grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line1 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_data_master_saved_grant_cpu_jtag_debug_module))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_saved_grant_cpu_jtag_debug_module))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line1, now);
          write(write_line1, string'(": "));
          write(write_line1, string'("> 1 of saved_grant signals are active simultaneously"));
          write(output, write_line1.all);
          deallocate (write_line1);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity cpu_data_master_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_granted_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_data_master_granted_iobusMAC_0_slave : IN STD_LOGIC;
                 signal cpu_data_master_granted_iobusMAC_1_slave : IN STD_LOGIC;
                 signal cpu_data_master_granted_iobusMAC_2_slave : IN STD_LOGIC;
                 signal cpu_data_master_granted_iobusMAC_3_slave : IN STD_LOGIC;
                 signal cpu_data_master_granted_iobusMAC_4_slave : IN STD_LOGIC;
                 signal cpu_data_master_granted_iobusMAC_5_slave : IN STD_LOGIC;
                 signal cpu_data_master_granted_iobusMAC_6_slave : IN STD_LOGIC;
                 signal cpu_data_master_granted_iobusMAC_7_slave : IN STD_LOGIC;
                 signal cpu_data_master_granted_iobusMDIO_0_slave : IN STD_LOGIC;
                 signal cpu_data_master_granted_iobusMDIO_1_slave : IN STD_LOGIC;
                 signal cpu_data_master_granted_iobusMDIO_2_slave : IN STD_LOGIC;
                 signal cpu_data_master_granted_iobusMDIO_3_slave : IN STD_LOGIC;
                 signal cpu_data_master_granted_iobusMDIO_4_slave : IN STD_LOGIC;
                 signal cpu_data_master_granted_iobusMDIO_5_slave : IN STD_LOGIC;
                 signal cpu_data_master_granted_iobusMDIO_6_slave : IN STD_LOGIC;
                 signal cpu_data_master_granted_iobusMDIO_7_slave : IN STD_LOGIC;
                 signal cpu_data_master_granted_iobusREGFILE_0_slave : IN STD_LOGIC;
                 signal cpu_data_master_granted_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_data_master_granted_mem_s1 : IN STD_LOGIC;
                 signal cpu_data_master_granted_rs232_uart_s1 : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMAC_0_slave : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMAC_1_slave : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMAC_2_slave : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMAC_3_slave : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMAC_4_slave : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMAC_5_slave : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMAC_6_slave : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMAC_7_slave : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMDIO_0_slave : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMDIO_1_slave : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMDIO_2_slave : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMDIO_3_slave : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMDIO_4_slave : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMDIO_5_slave : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMDIO_6_slave : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMDIO_7_slave : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusREGFILE_0_slave : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_mem_s1 : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_rs232_uart_s1 : IN STD_LOGIC;
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_0_slave : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_0_slave_shift_register : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_1_slave : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_1_slave_shift_register : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_2_slave : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_2_slave_shift_register : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_3_slave : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_3_slave_shift_register : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_4_slave : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_4_slave_shift_register : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_5_slave : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_5_slave_shift_register : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_6_slave : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_6_slave_shift_register : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_7_slave : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_7_slave_shift_register : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_0_slave : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_0_slave_shift_register : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_1_slave : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_1_slave_shift_register : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_2_slave : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_2_slave_shift_register : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_3_slave : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_3_slave_shift_register : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_4_slave : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_4_slave_shift_register : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_5_slave : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_5_slave_shift_register : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_6_slave : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_6_slave_shift_register : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_7_slave : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_7_slave_shift_register : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusREGFILE_0_slave : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusREGFILE_0_slave_shift_register : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_mem_s1 : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_rs232_uart_s1 : IN STD_LOGIC;
                 signal cpu_data_master_requests_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_data_master_requests_iobusMAC_0_slave : IN STD_LOGIC;
                 signal cpu_data_master_requests_iobusMAC_1_slave : IN STD_LOGIC;
                 signal cpu_data_master_requests_iobusMAC_2_slave : IN STD_LOGIC;
                 signal cpu_data_master_requests_iobusMAC_3_slave : IN STD_LOGIC;
                 signal cpu_data_master_requests_iobusMAC_4_slave : IN STD_LOGIC;
                 signal cpu_data_master_requests_iobusMAC_5_slave : IN STD_LOGIC;
                 signal cpu_data_master_requests_iobusMAC_6_slave : IN STD_LOGIC;
                 signal cpu_data_master_requests_iobusMAC_7_slave : IN STD_LOGIC;
                 signal cpu_data_master_requests_iobusMDIO_0_slave : IN STD_LOGIC;
                 signal cpu_data_master_requests_iobusMDIO_1_slave : IN STD_LOGIC;
                 signal cpu_data_master_requests_iobusMDIO_2_slave : IN STD_LOGIC;
                 signal cpu_data_master_requests_iobusMDIO_3_slave : IN STD_LOGIC;
                 signal cpu_data_master_requests_iobusMDIO_4_slave : IN STD_LOGIC;
                 signal cpu_data_master_requests_iobusMDIO_5_slave : IN STD_LOGIC;
                 signal cpu_data_master_requests_iobusMDIO_6_slave : IN STD_LOGIC;
                 signal cpu_data_master_requests_iobusMDIO_7_slave : IN STD_LOGIC;
                 signal cpu_data_master_requests_iobusREGFILE_0_slave : IN STD_LOGIC;
                 signal cpu_data_master_requests_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_data_master_requests_mem_s1 : IN STD_LOGIC;
                 signal cpu_data_master_requests_rs232_uart_s1 : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_cpu_jtag_debug_module_end_xfer : IN STD_LOGIC;
                 signal d1_iobusMAC_0_slave_end_xfer : IN STD_LOGIC;
                 signal d1_iobusMAC_1_slave_end_xfer : IN STD_LOGIC;
                 signal d1_iobusMAC_2_slave_end_xfer : IN STD_LOGIC;
                 signal d1_iobusMAC_3_slave_end_xfer : IN STD_LOGIC;
                 signal d1_iobusMAC_4_slave_end_xfer : IN STD_LOGIC;
                 signal d1_iobusMAC_5_slave_end_xfer : IN STD_LOGIC;
                 signal d1_iobusMAC_6_slave_end_xfer : IN STD_LOGIC;
                 signal d1_iobusMAC_7_slave_end_xfer : IN STD_LOGIC;
                 signal d1_iobusMDIO_0_slave_end_xfer : IN STD_LOGIC;
                 signal d1_iobusMDIO_1_slave_end_xfer : IN STD_LOGIC;
                 signal d1_iobusMDIO_2_slave_end_xfer : IN STD_LOGIC;
                 signal d1_iobusMDIO_3_slave_end_xfer : IN STD_LOGIC;
                 signal d1_iobusMDIO_4_slave_end_xfer : IN STD_LOGIC;
                 signal d1_iobusMDIO_5_slave_end_xfer : IN STD_LOGIC;
                 signal d1_iobusMDIO_6_slave_end_xfer : IN STD_LOGIC;
                 signal d1_iobusMDIO_7_slave_end_xfer : IN STD_LOGIC;
                 signal d1_iobusREGFILE_0_slave_end_xfer : IN STD_LOGIC;
                 signal d1_jtag_uart_avalon_jtag_slave_end_xfer : IN STD_LOGIC;
                 signal d1_mem_s1_end_xfer : IN STD_LOGIC;
                 signal d1_rs232_uart_s1_end_xfer : IN STD_LOGIC;
                 signal iobusMAC_0_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_0_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal iobusMAC_1_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_1_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal iobusMAC_2_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_2_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal iobusMAC_3_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_3_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal iobusMAC_4_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_4_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal iobusMAC_5_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_5_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal iobusMAC_6_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_6_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal iobusMAC_7_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_7_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal iobusMDIO_0_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_0_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal iobusMDIO_1_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_1_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal iobusMDIO_2_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_2_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal iobusMDIO_3_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_3_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal iobusMDIO_4_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_4_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal iobusMDIO_5_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_5_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal iobusMDIO_6_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_6_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal iobusMDIO_7_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_7_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal iobusREGFILE_0_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusREGFILE_0_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_irq_from_sa : IN STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_avalon_jtag_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal mem_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal registered_cpu_data_master_read_data_valid_mem_s1 : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal rs232_uart_s1_irq_from_sa : IN STD_LOGIC;
                 signal rs232_uart_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

              -- outputs:
                 signal cpu_data_master_address_to_slave : OUT STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_irq : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_data_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_data_master_waitrequest : OUT STD_LOGIC
              );
end entity cpu_data_master_arbitrator;


architecture europa of cpu_data_master_arbitrator is
                signal cpu_data_master_run :  STD_LOGIC;
                signal internal_cpu_data_master_address_to_slave :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal internal_cpu_data_master_waitrequest :  STD_LOGIC;
                signal p1_registered_cpu_data_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal r_0 :  STD_LOGIC;
                signal r_1 :  STD_LOGIC;
                signal r_2 :  STD_LOGIC;
                signal r_3 :  STD_LOGIC;
                signal r_4 :  STD_LOGIC;
                signal registered_cpu_data_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);

begin

  --r_0 master_run cascaded wait assignment, which is an e_assign
  r_0 <= Vector_To_Std_Logic((((((((((((((((((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_qualified_request_cpu_jtag_debug_module OR NOT cpu_data_master_requests_cpu_jtag_debug_module)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_granted_cpu_jtag_debug_module OR NOT cpu_data_master_qualified_request_cpu_jtag_debug_module)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_cpu_jtag_debug_module OR NOT cpu_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_cpu_jtag_debug_module OR NOT cpu_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_iobusMAC_0_slave OR cpu_data_master_read_data_valid_iobusMAC_0_slave) OR NOT cpu_data_master_requests_iobusMAC_0_slave)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_data_master_qualified_request_iobusMAC_0_slave OR NOT cpu_data_master_read) OR ((cpu_data_master_read_data_valid_iobusMAC_0_slave AND cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_iobusMAC_0_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT iobusMAC_0_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_iobusMAC_1_slave OR cpu_data_master_read_data_valid_iobusMAC_1_slave) OR NOT cpu_data_master_requests_iobusMAC_1_slave)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_data_master_qualified_request_iobusMAC_1_slave OR NOT cpu_data_master_read) OR ((cpu_data_master_read_data_valid_iobusMAC_1_slave AND cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_iobusMAC_1_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT iobusMAC_1_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_iobusMAC_2_slave OR cpu_data_master_read_data_valid_iobusMAC_2_slave) OR NOT cpu_data_master_requests_iobusMAC_2_slave)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_data_master_qualified_request_iobusMAC_2_slave OR NOT cpu_data_master_read) OR ((cpu_data_master_read_data_valid_iobusMAC_2_slave AND cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_iobusMAC_2_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT iobusMAC_2_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_iobusMAC_3_slave OR cpu_data_master_read_data_valid_iobusMAC_3_slave) OR NOT cpu_data_master_requests_iobusMAC_3_slave)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_data_master_qualified_request_iobusMAC_3_slave OR NOT cpu_data_master_read) OR ((cpu_data_master_read_data_valid_iobusMAC_3_slave AND cpu_data_master_read)))))))));
  --cascaded wait assignment, which is an e_assign
  cpu_data_master_run <= (((r_0 AND r_1) AND r_2) AND r_3) AND r_4;
  --r_1 master_run cascaded wait assignment, which is an e_assign
  r_1 <= Vector_To_Std_Logic(((((((((((((((((((((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_iobusMAC_3_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT iobusMAC_3_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_iobusMAC_4_slave OR cpu_data_master_read_data_valid_iobusMAC_4_slave) OR NOT cpu_data_master_requests_iobusMAC_4_slave)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_data_master_qualified_request_iobusMAC_4_slave OR NOT cpu_data_master_read) OR ((cpu_data_master_read_data_valid_iobusMAC_4_slave AND cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_iobusMAC_4_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT iobusMAC_4_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_iobusMAC_5_slave OR cpu_data_master_read_data_valid_iobusMAC_5_slave) OR NOT cpu_data_master_requests_iobusMAC_5_slave)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_data_master_qualified_request_iobusMAC_5_slave OR NOT cpu_data_master_read) OR ((cpu_data_master_read_data_valid_iobusMAC_5_slave AND cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_iobusMAC_5_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT iobusMAC_5_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_iobusMAC_6_slave OR cpu_data_master_read_data_valid_iobusMAC_6_slave) OR NOT cpu_data_master_requests_iobusMAC_6_slave)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_data_master_qualified_request_iobusMAC_6_slave OR NOT cpu_data_master_read) OR ((cpu_data_master_read_data_valid_iobusMAC_6_slave AND cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_iobusMAC_6_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT iobusMAC_6_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_iobusMAC_7_slave OR cpu_data_master_read_data_valid_iobusMAC_7_slave) OR NOT cpu_data_master_requests_iobusMAC_7_slave)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_data_master_qualified_request_iobusMAC_7_slave OR NOT cpu_data_master_read) OR ((cpu_data_master_read_data_valid_iobusMAC_7_slave AND cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_iobusMAC_7_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT iobusMAC_7_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_iobusMDIO_0_slave OR cpu_data_master_read_data_valid_iobusMDIO_0_slave) OR NOT cpu_data_master_requests_iobusMDIO_0_slave)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_data_master_qualified_request_iobusMDIO_0_slave OR NOT cpu_data_master_read) OR ((cpu_data_master_read_data_valid_iobusMDIO_0_slave AND cpu_data_master_read)))))))));
  --r_2 master_run cascaded wait assignment, which is an e_assign
  r_2 <= Vector_To_Std_Logic(((((((((((((((((((((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_iobusMDIO_0_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT iobusMDIO_0_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_iobusMDIO_1_slave OR cpu_data_master_read_data_valid_iobusMDIO_1_slave) OR NOT cpu_data_master_requests_iobusMDIO_1_slave)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_data_master_qualified_request_iobusMDIO_1_slave OR NOT cpu_data_master_read) OR ((cpu_data_master_read_data_valid_iobusMDIO_1_slave AND cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_iobusMDIO_1_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT iobusMDIO_1_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_iobusMDIO_2_slave OR cpu_data_master_read_data_valid_iobusMDIO_2_slave) OR NOT cpu_data_master_requests_iobusMDIO_2_slave)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_data_master_qualified_request_iobusMDIO_2_slave OR NOT cpu_data_master_read) OR ((cpu_data_master_read_data_valid_iobusMDIO_2_slave AND cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_iobusMDIO_2_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT iobusMDIO_2_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_iobusMDIO_3_slave OR cpu_data_master_read_data_valid_iobusMDIO_3_slave) OR NOT cpu_data_master_requests_iobusMDIO_3_slave)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_data_master_qualified_request_iobusMDIO_3_slave OR NOT cpu_data_master_read) OR ((cpu_data_master_read_data_valid_iobusMDIO_3_slave AND cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_iobusMDIO_3_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT iobusMDIO_3_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_iobusMDIO_4_slave OR cpu_data_master_read_data_valid_iobusMDIO_4_slave) OR NOT cpu_data_master_requests_iobusMDIO_4_slave)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_data_master_qualified_request_iobusMDIO_4_slave OR NOT cpu_data_master_read) OR ((cpu_data_master_read_data_valid_iobusMDIO_4_slave AND cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_iobusMDIO_4_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT iobusMDIO_4_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_iobusMDIO_5_slave OR cpu_data_master_read_data_valid_iobusMDIO_5_slave) OR NOT cpu_data_master_requests_iobusMDIO_5_slave)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_data_master_qualified_request_iobusMDIO_5_slave OR NOT cpu_data_master_read) OR ((cpu_data_master_read_data_valid_iobusMDIO_5_slave AND cpu_data_master_read)))))))));
  --r_3 master_run cascaded wait assignment, which is an e_assign
  r_3 <= Vector_To_Std_Logic(((((((((((((((((((((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_iobusMDIO_5_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT iobusMDIO_5_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_iobusMDIO_6_slave OR cpu_data_master_read_data_valid_iobusMDIO_6_slave) OR NOT cpu_data_master_requests_iobusMDIO_6_slave)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_data_master_qualified_request_iobusMDIO_6_slave OR NOT cpu_data_master_read) OR ((cpu_data_master_read_data_valid_iobusMDIO_6_slave AND cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_iobusMDIO_6_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT iobusMDIO_6_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_iobusMDIO_7_slave OR cpu_data_master_read_data_valid_iobusMDIO_7_slave) OR NOT cpu_data_master_requests_iobusMDIO_7_slave)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_data_master_qualified_request_iobusMDIO_7_slave OR NOT cpu_data_master_read) OR ((cpu_data_master_read_data_valid_iobusMDIO_7_slave AND cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_iobusMDIO_7_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT iobusMDIO_7_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_iobusREGFILE_0_slave OR cpu_data_master_read_data_valid_iobusREGFILE_0_slave) OR NOT cpu_data_master_requests_iobusREGFILE_0_slave)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_data_master_qualified_request_iobusREGFILE_0_slave OR NOT cpu_data_master_read) OR ((cpu_data_master_read_data_valid_iobusREGFILE_0_slave AND cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_iobusREGFILE_0_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT iobusREGFILE_0_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave OR NOT cpu_data_master_requests_jtag_uart_avalon_jtag_slave)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT jtag_uart_avalon_jtag_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT jtag_uart_avalon_jtag_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_mem_s1 OR registered_cpu_data_master_read_data_valid_mem_s1) OR NOT cpu_data_master_requests_mem_s1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_granted_mem_s1 OR NOT cpu_data_master_qualified_request_mem_s1)))))));
  --r_4 master_run cascaded wait assignment, which is an e_assign
  r_4 <= Vector_To_Std_Logic((((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((NOT cpu_data_master_qualified_request_mem_s1 OR NOT cpu_data_master_read) OR ((registered_cpu_data_master_read_data_valid_mem_s1 AND cpu_data_master_read))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_mem_s1 OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_rs232_uart_s1 OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_rs232_uart_s1 OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))));
  --optimize select-logic by passing only those address bits which matter.
  internal_cpu_data_master_address_to_slave <= cpu_data_master_address(13 DOWNTO 0);
  --cpu/data_master readdata mux, which is an e_mux
  cpu_data_master_readdata <= (((((((((((((((((((((A_REP(NOT cpu_data_master_requests_cpu_jtag_debug_module, 32) OR cpu_jtag_debug_module_readdata_from_sa)) AND ((A_REP(NOT cpu_data_master_requests_iobusMAC_0_slave, 32) OR registered_cpu_data_master_readdata))) AND ((A_REP(NOT cpu_data_master_requests_iobusMAC_1_slave, 32) OR registered_cpu_data_master_readdata))) AND ((A_REP(NOT cpu_data_master_requests_iobusMAC_2_slave, 32) OR registered_cpu_data_master_readdata))) AND ((A_REP(NOT cpu_data_master_requests_iobusMAC_3_slave, 32) OR registered_cpu_data_master_readdata))) AND ((A_REP(NOT cpu_data_master_requests_iobusMAC_4_slave, 32) OR registered_cpu_data_master_readdata))) AND ((A_REP(NOT cpu_data_master_requests_iobusMAC_5_slave, 32) OR registered_cpu_data_master_readdata))) AND ((A_REP(NOT cpu_data_master_requests_iobusMAC_6_slave, 32) OR registered_cpu_data_master_readdata))) AND ((A_REP(NOT cpu_data_master_requests_iobusMAC_7_slave, 32) OR registered_cpu_data_master_readdata))) AND ((A_REP(NOT cpu_data_master_requests_iobusMDIO_0_slave, 32) OR registered_cpu_data_master_readdata))) AND ((A_REP(NOT cpu_data_master_requests_iobusMDIO_1_slave, 32) OR registered_cpu_data_master_readdata))) AND ((A_REP(NOT cpu_data_master_requests_iobusMDIO_2_slave, 32) OR registered_cpu_data_master_readdata))) AND ((A_REP(NOT cpu_data_master_requests_iobusMDIO_3_slave, 32) OR registered_cpu_data_master_readdata))) AND ((A_REP(NOT cpu_data_master_requests_iobusMDIO_4_slave, 32) OR registered_cpu_data_master_readdata))) AND ((A_REP(NOT cpu_data_master_requests_iobusMDIO_5_slave, 32) OR registered_cpu_data_master_readdata))) AND ((A_REP(NOT cpu_data_master_requests_iobusMDIO_6_slave, 32) OR registered_cpu_data_master_readdata))) AND ((A_REP(NOT cpu_data_master_requests_iobusMDIO_7_slave, 32) OR registered_cpu_data_master_readdata))) AND ((A_REP(NOT cpu_data_master_requests_iobusREGFILE_0_slave, 32) OR registered_cpu_data_master_readdata))) AND ((A_REP(NOT cpu_data_master_requests_jtag_uart_avalon_jtag_slave, 32) OR registered_cpu_data_master_readdata))) AND ((A_REP(NOT cpu_data_master_requests_mem_s1, 32) OR mem_s1_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_rs232_uart_s1, 32) OR (std_logic_vector'("0000000000000000") & (rs232_uart_s1_readdata_from_sa))));
  --actual waitrequest port, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_data_master_waitrequest <= Vector_To_Std_Logic(NOT std_logic_vector'("00000000000000000000000000000000"));
    elsif clk'event and clk = '1' then
      internal_cpu_data_master_waitrequest <= Vector_To_Std_Logic(NOT (A_WE_StdLogicVector((std_logic'((NOT ((cpu_data_master_read OR cpu_data_master_write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_run AND internal_cpu_data_master_waitrequest))))))));
    end if;

  end process;

  --unpredictable registered wait state incoming data, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      registered_cpu_data_master_readdata <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      registered_cpu_data_master_readdata <= p1_registered_cpu_data_master_readdata;
    end if;

  end process;

  --registered readdata mux, which is an e_mux
  p1_registered_cpu_data_master_readdata <= ((((((((((((((((((A_REP(NOT cpu_data_master_requests_iobusMAC_0_slave, 32) OR iobusMAC_0_slave_readdata_from_sa)) AND ((A_REP(NOT cpu_data_master_requests_iobusMAC_1_slave, 32) OR iobusMAC_1_slave_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_iobusMAC_2_slave, 32) OR iobusMAC_2_slave_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_iobusMAC_3_slave, 32) OR iobusMAC_3_slave_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_iobusMAC_4_slave, 32) OR iobusMAC_4_slave_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_iobusMAC_5_slave, 32) OR iobusMAC_5_slave_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_iobusMAC_6_slave, 32) OR iobusMAC_6_slave_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_iobusMAC_7_slave, 32) OR iobusMAC_7_slave_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_iobusMDIO_0_slave, 32) OR iobusMDIO_0_slave_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_iobusMDIO_1_slave, 32) OR iobusMDIO_1_slave_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_iobusMDIO_2_slave, 32) OR iobusMDIO_2_slave_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_iobusMDIO_3_slave, 32) OR iobusMDIO_3_slave_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_iobusMDIO_4_slave, 32) OR iobusMDIO_4_slave_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_iobusMDIO_5_slave, 32) OR iobusMDIO_5_slave_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_iobusMDIO_6_slave, 32) OR iobusMDIO_6_slave_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_iobusMDIO_7_slave, 32) OR iobusMDIO_7_slave_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_iobusREGFILE_0_slave, 32) OR iobusREGFILE_0_slave_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_jtag_uart_avalon_jtag_slave, 32) OR jtag_uart_avalon_jtag_slave_readdata_from_sa));
  --irq assign, which is an e_assign
  cpu_data_master_irq <= Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(rs232_uart_s1_irq_from_sa) & A_ToStdLogicVector(jtag_uart_avalon_jtag_slave_irq_from_sa));
  --vhdl renameroo for output signals
  cpu_data_master_address_to_slave <= internal_cpu_data_master_address_to_slave;
  --vhdl renameroo for output signals
  cpu_data_master_waitrequest <= internal_cpu_data_master_waitrequest;

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity cpu_instruction_master_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_instruction_master_address : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_instruction_master_granted_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_instruction_master_granted_mem_s1 : IN STD_LOGIC;
                 signal cpu_instruction_master_qualified_request_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_instruction_master_qualified_request_mem_s1 : IN STD_LOGIC;
                 signal cpu_instruction_master_read : IN STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_mem_s1 : IN STD_LOGIC;
                 signal cpu_instruction_master_requests_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_instruction_master_requests_mem_s1 : IN STD_LOGIC;
                 signal cpu_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_cpu_jtag_debug_module_end_xfer : IN STD_LOGIC;
                 signal d1_mem_s1_end_xfer : IN STD_LOGIC;
                 signal mem_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_instruction_master_address_to_slave : OUT STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_instruction_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_instruction_master_waitrequest : OUT STD_LOGIC
              );
end entity cpu_instruction_master_arbitrator;


architecture europa of cpu_instruction_master_arbitrator is
                signal active_and_waiting_last_time :  STD_LOGIC;
                signal cpu_instruction_master_address_last_time :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal cpu_instruction_master_read_last_time :  STD_LOGIC;
                signal cpu_instruction_master_run :  STD_LOGIC;
                signal internal_cpu_instruction_master_address_to_slave :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal internal_cpu_instruction_master_waitrequest :  STD_LOGIC;
                signal r_0 :  STD_LOGIC;
                signal r_3 :  STD_LOGIC;
                signal r_4 :  STD_LOGIC;

begin

  --r_0 master_run cascaded wait assignment, which is an e_assign
  r_0 <= Vector_To_Std_Logic((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_instruction_master_qualified_request_cpu_jtag_debug_module OR NOT cpu_instruction_master_requests_cpu_jtag_debug_module)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_instruction_master_granted_cpu_jtag_debug_module OR NOT cpu_instruction_master_qualified_request_cpu_jtag_debug_module)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_instruction_master_qualified_request_cpu_jtag_debug_module OR NOT cpu_instruction_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_cpu_jtag_debug_module_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_read)))))))));
  --cascaded wait assignment, which is an e_assign
  cpu_instruction_master_run <= (r_0 AND r_3) AND r_4;
  --r_3 master_run cascaded wait assignment, which is an e_assign
  r_3 <= Vector_To_Std_Logic((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_instruction_master_qualified_request_mem_s1 OR cpu_instruction_master_read_data_valid_mem_s1) OR NOT cpu_instruction_master_requests_mem_s1)))))));
  --r_4 master_run cascaded wait assignment, which is an e_assign
  r_4 <= ((cpu_instruction_master_granted_mem_s1 OR NOT cpu_instruction_master_qualified_request_mem_s1)) AND (((NOT cpu_instruction_master_qualified_request_mem_s1 OR NOT cpu_instruction_master_read) OR ((cpu_instruction_master_read_data_valid_mem_s1 AND cpu_instruction_master_read))));
  --optimize select-logic by passing only those address bits which matter.
  internal_cpu_instruction_master_address_to_slave <= cpu_instruction_master_address(13 DOWNTO 0);
  --cpu/instruction_master readdata mux, which is an e_mux
  cpu_instruction_master_readdata <= ((A_REP(NOT cpu_instruction_master_requests_cpu_jtag_debug_module, 32) OR cpu_jtag_debug_module_readdata_from_sa)) AND ((A_REP(NOT cpu_instruction_master_requests_mem_s1, 32) OR mem_s1_readdata_from_sa));
  --actual waitrequest port, which is an e_assign
  internal_cpu_instruction_master_waitrequest <= NOT cpu_instruction_master_run;
  --vhdl renameroo for output signals
  cpu_instruction_master_address_to_slave <= internal_cpu_instruction_master_address_to_slave;
  --vhdl renameroo for output signals
  cpu_instruction_master_waitrequest <= internal_cpu_instruction_master_waitrequest;
--synthesis translate_off
    --cpu_instruction_master_address check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        cpu_instruction_master_address_last_time <= std_logic_vector'("00000000000000");
      elsif clk'event and clk = '1' then
        cpu_instruction_master_address_last_time <= cpu_instruction_master_address;
      end if;

    end process;

    --cpu/instruction_master waited last time, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        active_and_waiting_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        active_and_waiting_last_time <= internal_cpu_instruction_master_waitrequest AND (cpu_instruction_master_read);
      end if;

    end process;

    --cpu_instruction_master_address matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line2 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((cpu_instruction_master_address /= cpu_instruction_master_address_last_time))))) = '1' then 
          write(write_line2, now);
          write(write_line2, string'(": "));
          write(write_line2, string'("cpu_instruction_master_address did not heed wait!!!"));
          write(output, write_line2.all);
          deallocate (write_line2);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --cpu_instruction_master_read check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        cpu_instruction_master_read_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        cpu_instruction_master_read_last_time <= cpu_instruction_master_read;
      end if;

    end process;

    --cpu_instruction_master_read matches last port_name, which is an e_process
    process (clk)
    VARIABLE write_line3 : line;
    begin
      if clk'event and clk = '1' then
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((std_logic'(cpu_instruction_master_read) /= std_logic'(cpu_instruction_master_read_last_time)))))) = '1' then 
          write(write_line3, now);
          write(write_line3, string'(": "));
          write(write_line3, string'("cpu_instruction_master_read did not heed wait!!!"));
          write(output, write_line3.all);
          deallocate (write_line3);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rdv_fifo_for_cpu_data_master_to_iobusMAC_0_slave_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_data_master_to_iobusMAC_0_slave_module;


architecture europa of rdv_fifo_for_cpu_data_master_to_iobusMAC_0_slave_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (1 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_0;
  empty <= NOT(full_0);
  full_1 <= std_logic'('0');
  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 2);
  one_count_minus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 2);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("000000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 2);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity iobusMAC_0_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_0_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_0_slave_readdatavalid : IN STD_LOGIC;
                 signal iobusMAC_0_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_iobusMAC_0_slave : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMAC_0_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_0_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_0_slave_shift_register : OUT STD_LOGIC;
                 signal cpu_data_master_requests_iobusMAC_0_slave : OUT STD_LOGIC;
                 signal d1_iobusMAC_0_slave_end_xfer : OUT STD_LOGIC;
                 signal iobusMAC_0_slave_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal iobusMAC_0_slave_read : OUT STD_LOGIC;
                 signal iobusMAC_0_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_0_slave_reset : OUT STD_LOGIC;
                 signal iobusMAC_0_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal iobusMAC_0_slave_write : OUT STD_LOGIC;
                 signal iobusMAC_0_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity iobusMAC_0_slave_arbitrator;


architecture europa of iobusMAC_0_slave_arbitrator is
component rdv_fifo_for_cpu_data_master_to_iobusMAC_0_slave_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_data_master_to_iobusMAC_0_slave_module;

                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_empty_iobusMAC_0_slave :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_output_from_iobusMAC_0_slave :  STD_LOGIC;
                signal cpu_data_master_saved_grant_iobusMAC_0_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_iobusMAC_0_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_iobusMAC_0_slave :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_iobusMAC_0_slave :  STD_LOGIC;
                signal internal_cpu_data_master_read_data_valid_iobusMAC_0_slave_shift_register :  STD_LOGIC;
                signal internal_cpu_data_master_requests_iobusMAC_0_slave :  STD_LOGIC;
                signal internal_iobusMAC_0_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMAC_0_slave_allgrants :  STD_LOGIC;
                signal iobusMAC_0_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal iobusMAC_0_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal iobusMAC_0_slave_any_continuerequest :  STD_LOGIC;
                signal iobusMAC_0_slave_arb_counter_enable :  STD_LOGIC;
                signal iobusMAC_0_slave_arb_share_counter :  STD_LOGIC;
                signal iobusMAC_0_slave_arb_share_counter_next_value :  STD_LOGIC;
                signal iobusMAC_0_slave_arb_share_set_values :  STD_LOGIC;
                signal iobusMAC_0_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal iobusMAC_0_slave_begins_xfer :  STD_LOGIC;
                signal iobusMAC_0_slave_end_xfer :  STD_LOGIC;
                signal iobusMAC_0_slave_firsttransfer :  STD_LOGIC;
                signal iobusMAC_0_slave_grant_vector :  STD_LOGIC;
                signal iobusMAC_0_slave_in_a_read_cycle :  STD_LOGIC;
                signal iobusMAC_0_slave_in_a_write_cycle :  STD_LOGIC;
                signal iobusMAC_0_slave_master_qreq_vector :  STD_LOGIC;
                signal iobusMAC_0_slave_move_on_to_next_transaction :  STD_LOGIC;
                signal iobusMAC_0_slave_non_bursting_master_requests :  STD_LOGIC;
                signal iobusMAC_0_slave_readdatavalid_from_sa :  STD_LOGIC;
                signal iobusMAC_0_slave_reg_firsttransfer :  STD_LOGIC;
                signal iobusMAC_0_slave_slavearbiterlockenable :  STD_LOGIC;
                signal iobusMAC_0_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal iobusMAC_0_slave_unreg_firsttransfer :  STD_LOGIC;
                signal iobusMAC_0_slave_waits_for_read :  STD_LOGIC;
                signal iobusMAC_0_slave_waits_for_write :  STD_LOGIC;
                signal module_input :  STD_LOGIC;
                signal module_input1 :  STD_LOGIC;
                signal module_input2 :  STD_LOGIC;
                signal shifted_address_to_iobusMAC_0_slave_from_cpu_data_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal wait_for_iobusMAC_0_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT iobusMAC_0_slave_end_xfer;
    end if;

  end process;

  iobusMAC_0_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_iobusMAC_0_slave);
  --assign iobusMAC_0_slave_readdata_from_sa = iobusMAC_0_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMAC_0_slave_readdata_from_sa <= iobusMAC_0_slave_readdata;
  internal_cpu_data_master_requests_iobusMAC_0_slave <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(13 DOWNTO 6) & std_logic_vector'("000000")) = std_logic_vector'("00100001000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign iobusMAC_0_slave_waitrequest_from_sa = iobusMAC_0_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_iobusMAC_0_slave_waitrequest_from_sa <= iobusMAC_0_slave_waitrequest;
  --assign iobusMAC_0_slave_readdatavalid_from_sa = iobusMAC_0_slave_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMAC_0_slave_readdatavalid_from_sa <= iobusMAC_0_slave_readdatavalid;
  --iobusMAC_0_slave_arb_share_counter set values, which is an e_mux
  iobusMAC_0_slave_arb_share_set_values <= std_logic'('1');
  --iobusMAC_0_slave_non_bursting_master_requests mux, which is an e_mux
  iobusMAC_0_slave_non_bursting_master_requests <= internal_cpu_data_master_requests_iobusMAC_0_slave;
  --iobusMAC_0_slave_any_bursting_master_saved_grant mux, which is an e_mux
  iobusMAC_0_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --iobusMAC_0_slave_arb_share_counter_next_value assignment, which is an e_assign
  iobusMAC_0_slave_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(iobusMAC_0_slave_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMAC_0_slave_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(iobusMAC_0_slave_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMAC_0_slave_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --iobusMAC_0_slave_allgrants all slave grants, which is an e_mux
  iobusMAC_0_slave_allgrants <= iobusMAC_0_slave_grant_vector;
  --iobusMAC_0_slave_end_xfer assignment, which is an e_assign
  iobusMAC_0_slave_end_xfer <= NOT ((iobusMAC_0_slave_waits_for_read OR iobusMAC_0_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_iobusMAC_0_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_iobusMAC_0_slave <= iobusMAC_0_slave_end_xfer AND (((NOT iobusMAC_0_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --iobusMAC_0_slave_arb_share_counter arbitration counter enable, which is an e_assign
  iobusMAC_0_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_iobusMAC_0_slave AND iobusMAC_0_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_iobusMAC_0_slave AND NOT iobusMAC_0_slave_non_bursting_master_requests));
  --iobusMAC_0_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_0_slave_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMAC_0_slave_arb_counter_enable) = '1' then 
        iobusMAC_0_slave_arb_share_counter <= iobusMAC_0_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --iobusMAC_0_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_0_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((iobusMAC_0_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_iobusMAC_0_slave)) OR ((end_xfer_arb_share_counter_term_iobusMAC_0_slave AND NOT iobusMAC_0_slave_non_bursting_master_requests)))) = '1' then 
        iobusMAC_0_slave_slavearbiterlockenable <= iobusMAC_0_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master iobusMAC_0/slave arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= iobusMAC_0_slave_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --iobusMAC_0_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  iobusMAC_0_slave_slavearbiterlockenable2 <= iobusMAC_0_slave_arb_share_counter_next_value;
  --cpu/data_master iobusMAC_0/slave arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= iobusMAC_0_slave_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --iobusMAC_0_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  iobusMAC_0_slave_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_iobusMAC_0_slave <= internal_cpu_data_master_requests_iobusMAC_0_slave AND NOT ((((cpu_data_master_read AND ((NOT cpu_data_master_waitrequest OR (internal_cpu_data_master_read_data_valid_iobusMAC_0_slave_shift_register))))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))));
  --unique name for iobusMAC_0_slave_move_on_to_next_transaction, which is an e_assign
  iobusMAC_0_slave_move_on_to_next_transaction <= iobusMAC_0_slave_readdatavalid_from_sa;
  --rdv_fifo_for_cpu_data_master_to_iobusMAC_0_slave, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_data_master_to_iobusMAC_0_slave : rdv_fifo_for_cpu_data_master_to_iobusMAC_0_slave_module
    port map(
      data_out => cpu_data_master_rdv_fifo_output_from_iobusMAC_0_slave,
      empty => open,
      fifo_contains_ones_n => cpu_data_master_rdv_fifo_empty_iobusMAC_0_slave,
      full => open,
      clear_fifo => module_input,
      clk => clk,
      data_in => internal_cpu_data_master_granted_iobusMAC_0_slave,
      read => iobusMAC_0_slave_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input1,
      write => module_input2
    );

  module_input <= std_logic'('0');
  module_input1 <= std_logic'('0');
  module_input2 <= in_a_read_cycle AND NOT iobusMAC_0_slave_waits_for_read;

  internal_cpu_data_master_read_data_valid_iobusMAC_0_slave_shift_register <= NOT cpu_data_master_rdv_fifo_empty_iobusMAC_0_slave;
  --local readdatavalid cpu_data_master_read_data_valid_iobusMAC_0_slave, which is an e_mux
  cpu_data_master_read_data_valid_iobusMAC_0_slave <= iobusMAC_0_slave_readdatavalid_from_sa;
  --iobusMAC_0_slave_writedata mux, which is an e_mux
  iobusMAC_0_slave_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_iobusMAC_0_slave <= internal_cpu_data_master_qualified_request_iobusMAC_0_slave;
  --cpu/data_master saved-grant iobusMAC_0/slave, which is an e_assign
  cpu_data_master_saved_grant_iobusMAC_0_slave <= internal_cpu_data_master_requests_iobusMAC_0_slave;
  --allow new arb cycle for iobusMAC_0/slave, which is an e_assign
  iobusMAC_0_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  iobusMAC_0_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  iobusMAC_0_slave_master_qreq_vector <= std_logic'('1');
  --~iobusMAC_0_slave_reset assignment, which is an e_assign
  iobusMAC_0_slave_reset <= NOT reset_n;
  --iobusMAC_0_slave_firsttransfer first transaction, which is an e_assign
  iobusMAC_0_slave_firsttransfer <= A_WE_StdLogic((std_logic'(iobusMAC_0_slave_begins_xfer) = '1'), iobusMAC_0_slave_unreg_firsttransfer, iobusMAC_0_slave_reg_firsttransfer);
  --iobusMAC_0_slave_unreg_firsttransfer first transaction, which is an e_assign
  iobusMAC_0_slave_unreg_firsttransfer <= NOT ((iobusMAC_0_slave_slavearbiterlockenable AND iobusMAC_0_slave_any_continuerequest));
  --iobusMAC_0_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_0_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMAC_0_slave_begins_xfer) = '1' then 
        iobusMAC_0_slave_reg_firsttransfer <= iobusMAC_0_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --iobusMAC_0_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  iobusMAC_0_slave_beginbursttransfer_internal <= iobusMAC_0_slave_begins_xfer;
  --iobusMAC_0_slave_read assignment, which is an e_mux
  iobusMAC_0_slave_read <= internal_cpu_data_master_granted_iobusMAC_0_slave AND cpu_data_master_read;
  --iobusMAC_0_slave_write assignment, which is an e_mux
  iobusMAC_0_slave_write <= internal_cpu_data_master_granted_iobusMAC_0_slave AND cpu_data_master_write;
  shifted_address_to_iobusMAC_0_slave_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --iobusMAC_0_slave_address mux, which is an e_mux
  iobusMAC_0_slave_address <= A_EXT (A_SRL(shifted_address_to_iobusMAC_0_slave_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 4);
  --d1_iobusMAC_0_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_iobusMAC_0_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_iobusMAC_0_slave_end_xfer <= iobusMAC_0_slave_end_xfer;
    end if;

  end process;

  --iobusMAC_0_slave_waits_for_read in a cycle, which is an e_mux
  iobusMAC_0_slave_waits_for_read <= iobusMAC_0_slave_in_a_read_cycle AND internal_iobusMAC_0_slave_waitrequest_from_sa;
  --iobusMAC_0_slave_in_a_read_cycle assignment, which is an e_assign
  iobusMAC_0_slave_in_a_read_cycle <= internal_cpu_data_master_granted_iobusMAC_0_slave AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= iobusMAC_0_slave_in_a_read_cycle;
  --iobusMAC_0_slave_waits_for_write in a cycle, which is an e_mux
  iobusMAC_0_slave_waits_for_write <= iobusMAC_0_slave_in_a_write_cycle AND internal_iobusMAC_0_slave_waitrequest_from_sa;
  --iobusMAC_0_slave_in_a_write_cycle assignment, which is an e_assign
  iobusMAC_0_slave_in_a_write_cycle <= internal_cpu_data_master_granted_iobusMAC_0_slave AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= iobusMAC_0_slave_in_a_write_cycle;
  wait_for_iobusMAC_0_slave_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_iobusMAC_0_slave <= internal_cpu_data_master_granted_iobusMAC_0_slave;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_iobusMAC_0_slave <= internal_cpu_data_master_qualified_request_iobusMAC_0_slave;
  --vhdl renameroo for output signals
  cpu_data_master_read_data_valid_iobusMAC_0_slave_shift_register <= internal_cpu_data_master_read_data_valid_iobusMAC_0_slave_shift_register;
  --vhdl renameroo for output signals
  cpu_data_master_requests_iobusMAC_0_slave <= internal_cpu_data_master_requests_iobusMAC_0_slave;
  --vhdl renameroo for output signals
  iobusMAC_0_slave_waitrequest_from_sa <= internal_iobusMAC_0_slave_waitrequest_from_sa;
--synthesis translate_off
    --iobusMAC_0/slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rdv_fifo_for_cpu_data_master_to_iobusMAC_1_slave_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_data_master_to_iobusMAC_1_slave_module;


architecture europa of rdv_fifo_for_cpu_data_master_to_iobusMAC_1_slave_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (1 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_0;
  empty <= NOT(full_0);
  full_1 <= std_logic'('0');
  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 2);
  one_count_minus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 2);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("000000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 2);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity iobusMAC_1_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_1_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_1_slave_readdatavalid : IN STD_LOGIC;
                 signal iobusMAC_1_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_iobusMAC_1_slave : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMAC_1_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_1_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_1_slave_shift_register : OUT STD_LOGIC;
                 signal cpu_data_master_requests_iobusMAC_1_slave : OUT STD_LOGIC;
                 signal d1_iobusMAC_1_slave_end_xfer : OUT STD_LOGIC;
                 signal iobusMAC_1_slave_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal iobusMAC_1_slave_read : OUT STD_LOGIC;
                 signal iobusMAC_1_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_1_slave_reset : OUT STD_LOGIC;
                 signal iobusMAC_1_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal iobusMAC_1_slave_write : OUT STD_LOGIC;
                 signal iobusMAC_1_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity iobusMAC_1_slave_arbitrator;


architecture europa of iobusMAC_1_slave_arbitrator is
component rdv_fifo_for_cpu_data_master_to_iobusMAC_1_slave_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_data_master_to_iobusMAC_1_slave_module;

                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_empty_iobusMAC_1_slave :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_output_from_iobusMAC_1_slave :  STD_LOGIC;
                signal cpu_data_master_saved_grant_iobusMAC_1_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_iobusMAC_1_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_iobusMAC_1_slave :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_iobusMAC_1_slave :  STD_LOGIC;
                signal internal_cpu_data_master_read_data_valid_iobusMAC_1_slave_shift_register :  STD_LOGIC;
                signal internal_cpu_data_master_requests_iobusMAC_1_slave :  STD_LOGIC;
                signal internal_iobusMAC_1_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMAC_1_slave_allgrants :  STD_LOGIC;
                signal iobusMAC_1_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal iobusMAC_1_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal iobusMAC_1_slave_any_continuerequest :  STD_LOGIC;
                signal iobusMAC_1_slave_arb_counter_enable :  STD_LOGIC;
                signal iobusMAC_1_slave_arb_share_counter :  STD_LOGIC;
                signal iobusMAC_1_slave_arb_share_counter_next_value :  STD_LOGIC;
                signal iobusMAC_1_slave_arb_share_set_values :  STD_LOGIC;
                signal iobusMAC_1_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal iobusMAC_1_slave_begins_xfer :  STD_LOGIC;
                signal iobusMAC_1_slave_end_xfer :  STD_LOGIC;
                signal iobusMAC_1_slave_firsttransfer :  STD_LOGIC;
                signal iobusMAC_1_slave_grant_vector :  STD_LOGIC;
                signal iobusMAC_1_slave_in_a_read_cycle :  STD_LOGIC;
                signal iobusMAC_1_slave_in_a_write_cycle :  STD_LOGIC;
                signal iobusMAC_1_slave_master_qreq_vector :  STD_LOGIC;
                signal iobusMAC_1_slave_move_on_to_next_transaction :  STD_LOGIC;
                signal iobusMAC_1_slave_non_bursting_master_requests :  STD_LOGIC;
                signal iobusMAC_1_slave_readdatavalid_from_sa :  STD_LOGIC;
                signal iobusMAC_1_slave_reg_firsttransfer :  STD_LOGIC;
                signal iobusMAC_1_slave_slavearbiterlockenable :  STD_LOGIC;
                signal iobusMAC_1_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal iobusMAC_1_slave_unreg_firsttransfer :  STD_LOGIC;
                signal iobusMAC_1_slave_waits_for_read :  STD_LOGIC;
                signal iobusMAC_1_slave_waits_for_write :  STD_LOGIC;
                signal module_input3 :  STD_LOGIC;
                signal module_input4 :  STD_LOGIC;
                signal module_input5 :  STD_LOGIC;
                signal shifted_address_to_iobusMAC_1_slave_from_cpu_data_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal wait_for_iobusMAC_1_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT iobusMAC_1_slave_end_xfer;
    end if;

  end process;

  iobusMAC_1_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_iobusMAC_1_slave);
  --assign iobusMAC_1_slave_readdata_from_sa = iobusMAC_1_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMAC_1_slave_readdata_from_sa <= iobusMAC_1_slave_readdata;
  internal_cpu_data_master_requests_iobusMAC_1_slave <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(13 DOWNTO 6) & std_logic_vector'("000000")) = std_logic_vector'("00100010000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign iobusMAC_1_slave_waitrequest_from_sa = iobusMAC_1_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_iobusMAC_1_slave_waitrequest_from_sa <= iobusMAC_1_slave_waitrequest;
  --assign iobusMAC_1_slave_readdatavalid_from_sa = iobusMAC_1_slave_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMAC_1_slave_readdatavalid_from_sa <= iobusMAC_1_slave_readdatavalid;
  --iobusMAC_1_slave_arb_share_counter set values, which is an e_mux
  iobusMAC_1_slave_arb_share_set_values <= std_logic'('1');
  --iobusMAC_1_slave_non_bursting_master_requests mux, which is an e_mux
  iobusMAC_1_slave_non_bursting_master_requests <= internal_cpu_data_master_requests_iobusMAC_1_slave;
  --iobusMAC_1_slave_any_bursting_master_saved_grant mux, which is an e_mux
  iobusMAC_1_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --iobusMAC_1_slave_arb_share_counter_next_value assignment, which is an e_assign
  iobusMAC_1_slave_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(iobusMAC_1_slave_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMAC_1_slave_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(iobusMAC_1_slave_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMAC_1_slave_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --iobusMAC_1_slave_allgrants all slave grants, which is an e_mux
  iobusMAC_1_slave_allgrants <= iobusMAC_1_slave_grant_vector;
  --iobusMAC_1_slave_end_xfer assignment, which is an e_assign
  iobusMAC_1_slave_end_xfer <= NOT ((iobusMAC_1_slave_waits_for_read OR iobusMAC_1_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_iobusMAC_1_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_iobusMAC_1_slave <= iobusMAC_1_slave_end_xfer AND (((NOT iobusMAC_1_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --iobusMAC_1_slave_arb_share_counter arbitration counter enable, which is an e_assign
  iobusMAC_1_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_iobusMAC_1_slave AND iobusMAC_1_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_iobusMAC_1_slave AND NOT iobusMAC_1_slave_non_bursting_master_requests));
  --iobusMAC_1_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_1_slave_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMAC_1_slave_arb_counter_enable) = '1' then 
        iobusMAC_1_slave_arb_share_counter <= iobusMAC_1_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --iobusMAC_1_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_1_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((iobusMAC_1_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_iobusMAC_1_slave)) OR ((end_xfer_arb_share_counter_term_iobusMAC_1_slave AND NOT iobusMAC_1_slave_non_bursting_master_requests)))) = '1' then 
        iobusMAC_1_slave_slavearbiterlockenable <= iobusMAC_1_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master iobusMAC_1/slave arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= iobusMAC_1_slave_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --iobusMAC_1_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  iobusMAC_1_slave_slavearbiterlockenable2 <= iobusMAC_1_slave_arb_share_counter_next_value;
  --cpu/data_master iobusMAC_1/slave arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= iobusMAC_1_slave_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --iobusMAC_1_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  iobusMAC_1_slave_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_iobusMAC_1_slave <= internal_cpu_data_master_requests_iobusMAC_1_slave AND NOT ((((cpu_data_master_read AND ((NOT cpu_data_master_waitrequest OR (internal_cpu_data_master_read_data_valid_iobusMAC_1_slave_shift_register))))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))));
  --unique name for iobusMAC_1_slave_move_on_to_next_transaction, which is an e_assign
  iobusMAC_1_slave_move_on_to_next_transaction <= iobusMAC_1_slave_readdatavalid_from_sa;
  --rdv_fifo_for_cpu_data_master_to_iobusMAC_1_slave, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_data_master_to_iobusMAC_1_slave : rdv_fifo_for_cpu_data_master_to_iobusMAC_1_slave_module
    port map(
      data_out => cpu_data_master_rdv_fifo_output_from_iobusMAC_1_slave,
      empty => open,
      fifo_contains_ones_n => cpu_data_master_rdv_fifo_empty_iobusMAC_1_slave,
      full => open,
      clear_fifo => module_input3,
      clk => clk,
      data_in => internal_cpu_data_master_granted_iobusMAC_1_slave,
      read => iobusMAC_1_slave_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input4,
      write => module_input5
    );

  module_input3 <= std_logic'('0');
  module_input4 <= std_logic'('0');
  module_input5 <= in_a_read_cycle AND NOT iobusMAC_1_slave_waits_for_read;

  internal_cpu_data_master_read_data_valid_iobusMAC_1_slave_shift_register <= NOT cpu_data_master_rdv_fifo_empty_iobusMAC_1_slave;
  --local readdatavalid cpu_data_master_read_data_valid_iobusMAC_1_slave, which is an e_mux
  cpu_data_master_read_data_valid_iobusMAC_1_slave <= iobusMAC_1_slave_readdatavalid_from_sa;
  --iobusMAC_1_slave_writedata mux, which is an e_mux
  iobusMAC_1_slave_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_iobusMAC_1_slave <= internal_cpu_data_master_qualified_request_iobusMAC_1_slave;
  --cpu/data_master saved-grant iobusMAC_1/slave, which is an e_assign
  cpu_data_master_saved_grant_iobusMAC_1_slave <= internal_cpu_data_master_requests_iobusMAC_1_slave;
  --allow new arb cycle for iobusMAC_1/slave, which is an e_assign
  iobusMAC_1_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  iobusMAC_1_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  iobusMAC_1_slave_master_qreq_vector <= std_logic'('1');
  --~iobusMAC_1_slave_reset assignment, which is an e_assign
  iobusMAC_1_slave_reset <= NOT reset_n;
  --iobusMAC_1_slave_firsttransfer first transaction, which is an e_assign
  iobusMAC_1_slave_firsttransfer <= A_WE_StdLogic((std_logic'(iobusMAC_1_slave_begins_xfer) = '1'), iobusMAC_1_slave_unreg_firsttransfer, iobusMAC_1_slave_reg_firsttransfer);
  --iobusMAC_1_slave_unreg_firsttransfer first transaction, which is an e_assign
  iobusMAC_1_slave_unreg_firsttransfer <= NOT ((iobusMAC_1_slave_slavearbiterlockenable AND iobusMAC_1_slave_any_continuerequest));
  --iobusMAC_1_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_1_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMAC_1_slave_begins_xfer) = '1' then 
        iobusMAC_1_slave_reg_firsttransfer <= iobusMAC_1_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --iobusMAC_1_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  iobusMAC_1_slave_beginbursttransfer_internal <= iobusMAC_1_slave_begins_xfer;
  --iobusMAC_1_slave_read assignment, which is an e_mux
  iobusMAC_1_slave_read <= internal_cpu_data_master_granted_iobusMAC_1_slave AND cpu_data_master_read;
  --iobusMAC_1_slave_write assignment, which is an e_mux
  iobusMAC_1_slave_write <= internal_cpu_data_master_granted_iobusMAC_1_slave AND cpu_data_master_write;
  shifted_address_to_iobusMAC_1_slave_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --iobusMAC_1_slave_address mux, which is an e_mux
  iobusMAC_1_slave_address <= A_EXT (A_SRL(shifted_address_to_iobusMAC_1_slave_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 4);
  --d1_iobusMAC_1_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_iobusMAC_1_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_iobusMAC_1_slave_end_xfer <= iobusMAC_1_slave_end_xfer;
    end if;

  end process;

  --iobusMAC_1_slave_waits_for_read in a cycle, which is an e_mux
  iobusMAC_1_slave_waits_for_read <= iobusMAC_1_slave_in_a_read_cycle AND internal_iobusMAC_1_slave_waitrequest_from_sa;
  --iobusMAC_1_slave_in_a_read_cycle assignment, which is an e_assign
  iobusMAC_1_slave_in_a_read_cycle <= internal_cpu_data_master_granted_iobusMAC_1_slave AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= iobusMAC_1_slave_in_a_read_cycle;
  --iobusMAC_1_slave_waits_for_write in a cycle, which is an e_mux
  iobusMAC_1_slave_waits_for_write <= iobusMAC_1_slave_in_a_write_cycle AND internal_iobusMAC_1_slave_waitrequest_from_sa;
  --iobusMAC_1_slave_in_a_write_cycle assignment, which is an e_assign
  iobusMAC_1_slave_in_a_write_cycle <= internal_cpu_data_master_granted_iobusMAC_1_slave AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= iobusMAC_1_slave_in_a_write_cycle;
  wait_for_iobusMAC_1_slave_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_iobusMAC_1_slave <= internal_cpu_data_master_granted_iobusMAC_1_slave;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_iobusMAC_1_slave <= internal_cpu_data_master_qualified_request_iobusMAC_1_slave;
  --vhdl renameroo for output signals
  cpu_data_master_read_data_valid_iobusMAC_1_slave_shift_register <= internal_cpu_data_master_read_data_valid_iobusMAC_1_slave_shift_register;
  --vhdl renameroo for output signals
  cpu_data_master_requests_iobusMAC_1_slave <= internal_cpu_data_master_requests_iobusMAC_1_slave;
  --vhdl renameroo for output signals
  iobusMAC_1_slave_waitrequest_from_sa <= internal_iobusMAC_1_slave_waitrequest_from_sa;
--synthesis translate_off
    --iobusMAC_1/slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rdv_fifo_for_cpu_data_master_to_iobusMAC_2_slave_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_data_master_to_iobusMAC_2_slave_module;


architecture europa of rdv_fifo_for_cpu_data_master_to_iobusMAC_2_slave_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (1 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_0;
  empty <= NOT(full_0);
  full_1 <= std_logic'('0');
  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 2);
  one_count_minus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 2);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("000000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 2);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity iobusMAC_2_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_2_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_2_slave_readdatavalid : IN STD_LOGIC;
                 signal iobusMAC_2_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_iobusMAC_2_slave : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMAC_2_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_2_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_2_slave_shift_register : OUT STD_LOGIC;
                 signal cpu_data_master_requests_iobusMAC_2_slave : OUT STD_LOGIC;
                 signal d1_iobusMAC_2_slave_end_xfer : OUT STD_LOGIC;
                 signal iobusMAC_2_slave_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal iobusMAC_2_slave_read : OUT STD_LOGIC;
                 signal iobusMAC_2_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_2_slave_reset : OUT STD_LOGIC;
                 signal iobusMAC_2_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal iobusMAC_2_slave_write : OUT STD_LOGIC;
                 signal iobusMAC_2_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity iobusMAC_2_slave_arbitrator;


architecture europa of iobusMAC_2_slave_arbitrator is
component rdv_fifo_for_cpu_data_master_to_iobusMAC_2_slave_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_data_master_to_iobusMAC_2_slave_module;

                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_empty_iobusMAC_2_slave :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_output_from_iobusMAC_2_slave :  STD_LOGIC;
                signal cpu_data_master_saved_grant_iobusMAC_2_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_iobusMAC_2_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_iobusMAC_2_slave :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_iobusMAC_2_slave :  STD_LOGIC;
                signal internal_cpu_data_master_read_data_valid_iobusMAC_2_slave_shift_register :  STD_LOGIC;
                signal internal_cpu_data_master_requests_iobusMAC_2_slave :  STD_LOGIC;
                signal internal_iobusMAC_2_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMAC_2_slave_allgrants :  STD_LOGIC;
                signal iobusMAC_2_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal iobusMAC_2_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal iobusMAC_2_slave_any_continuerequest :  STD_LOGIC;
                signal iobusMAC_2_slave_arb_counter_enable :  STD_LOGIC;
                signal iobusMAC_2_slave_arb_share_counter :  STD_LOGIC;
                signal iobusMAC_2_slave_arb_share_counter_next_value :  STD_LOGIC;
                signal iobusMAC_2_slave_arb_share_set_values :  STD_LOGIC;
                signal iobusMAC_2_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal iobusMAC_2_slave_begins_xfer :  STD_LOGIC;
                signal iobusMAC_2_slave_end_xfer :  STD_LOGIC;
                signal iobusMAC_2_slave_firsttransfer :  STD_LOGIC;
                signal iobusMAC_2_slave_grant_vector :  STD_LOGIC;
                signal iobusMAC_2_slave_in_a_read_cycle :  STD_LOGIC;
                signal iobusMAC_2_slave_in_a_write_cycle :  STD_LOGIC;
                signal iobusMAC_2_slave_master_qreq_vector :  STD_LOGIC;
                signal iobusMAC_2_slave_move_on_to_next_transaction :  STD_LOGIC;
                signal iobusMAC_2_slave_non_bursting_master_requests :  STD_LOGIC;
                signal iobusMAC_2_slave_readdatavalid_from_sa :  STD_LOGIC;
                signal iobusMAC_2_slave_reg_firsttransfer :  STD_LOGIC;
                signal iobusMAC_2_slave_slavearbiterlockenable :  STD_LOGIC;
                signal iobusMAC_2_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal iobusMAC_2_slave_unreg_firsttransfer :  STD_LOGIC;
                signal iobusMAC_2_slave_waits_for_read :  STD_LOGIC;
                signal iobusMAC_2_slave_waits_for_write :  STD_LOGIC;
                signal module_input6 :  STD_LOGIC;
                signal module_input7 :  STD_LOGIC;
                signal module_input8 :  STD_LOGIC;
                signal shifted_address_to_iobusMAC_2_slave_from_cpu_data_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal wait_for_iobusMAC_2_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT iobusMAC_2_slave_end_xfer;
    end if;

  end process;

  iobusMAC_2_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_iobusMAC_2_slave);
  --assign iobusMAC_2_slave_readdata_from_sa = iobusMAC_2_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMAC_2_slave_readdata_from_sa <= iobusMAC_2_slave_readdata;
  internal_cpu_data_master_requests_iobusMAC_2_slave <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(13 DOWNTO 6) & std_logic_vector'("000000")) = std_logic_vector'("00100011000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign iobusMAC_2_slave_waitrequest_from_sa = iobusMAC_2_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_iobusMAC_2_slave_waitrequest_from_sa <= iobusMAC_2_slave_waitrequest;
  --assign iobusMAC_2_slave_readdatavalid_from_sa = iobusMAC_2_slave_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMAC_2_slave_readdatavalid_from_sa <= iobusMAC_2_slave_readdatavalid;
  --iobusMAC_2_slave_arb_share_counter set values, which is an e_mux
  iobusMAC_2_slave_arb_share_set_values <= std_logic'('1');
  --iobusMAC_2_slave_non_bursting_master_requests mux, which is an e_mux
  iobusMAC_2_slave_non_bursting_master_requests <= internal_cpu_data_master_requests_iobusMAC_2_slave;
  --iobusMAC_2_slave_any_bursting_master_saved_grant mux, which is an e_mux
  iobusMAC_2_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --iobusMAC_2_slave_arb_share_counter_next_value assignment, which is an e_assign
  iobusMAC_2_slave_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(iobusMAC_2_slave_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMAC_2_slave_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(iobusMAC_2_slave_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMAC_2_slave_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --iobusMAC_2_slave_allgrants all slave grants, which is an e_mux
  iobusMAC_2_slave_allgrants <= iobusMAC_2_slave_grant_vector;
  --iobusMAC_2_slave_end_xfer assignment, which is an e_assign
  iobusMAC_2_slave_end_xfer <= NOT ((iobusMAC_2_slave_waits_for_read OR iobusMAC_2_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_iobusMAC_2_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_iobusMAC_2_slave <= iobusMAC_2_slave_end_xfer AND (((NOT iobusMAC_2_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --iobusMAC_2_slave_arb_share_counter arbitration counter enable, which is an e_assign
  iobusMAC_2_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_iobusMAC_2_slave AND iobusMAC_2_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_iobusMAC_2_slave AND NOT iobusMAC_2_slave_non_bursting_master_requests));
  --iobusMAC_2_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_2_slave_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMAC_2_slave_arb_counter_enable) = '1' then 
        iobusMAC_2_slave_arb_share_counter <= iobusMAC_2_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --iobusMAC_2_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_2_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((iobusMAC_2_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_iobusMAC_2_slave)) OR ((end_xfer_arb_share_counter_term_iobusMAC_2_slave AND NOT iobusMAC_2_slave_non_bursting_master_requests)))) = '1' then 
        iobusMAC_2_slave_slavearbiterlockenable <= iobusMAC_2_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master iobusMAC_2/slave arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= iobusMAC_2_slave_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --iobusMAC_2_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  iobusMAC_2_slave_slavearbiterlockenable2 <= iobusMAC_2_slave_arb_share_counter_next_value;
  --cpu/data_master iobusMAC_2/slave arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= iobusMAC_2_slave_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --iobusMAC_2_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  iobusMAC_2_slave_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_iobusMAC_2_slave <= internal_cpu_data_master_requests_iobusMAC_2_slave AND NOT ((((cpu_data_master_read AND ((NOT cpu_data_master_waitrequest OR (internal_cpu_data_master_read_data_valid_iobusMAC_2_slave_shift_register))))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))));
  --unique name for iobusMAC_2_slave_move_on_to_next_transaction, which is an e_assign
  iobusMAC_2_slave_move_on_to_next_transaction <= iobusMAC_2_slave_readdatavalid_from_sa;
  --rdv_fifo_for_cpu_data_master_to_iobusMAC_2_slave, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_data_master_to_iobusMAC_2_slave : rdv_fifo_for_cpu_data_master_to_iobusMAC_2_slave_module
    port map(
      data_out => cpu_data_master_rdv_fifo_output_from_iobusMAC_2_slave,
      empty => open,
      fifo_contains_ones_n => cpu_data_master_rdv_fifo_empty_iobusMAC_2_slave,
      full => open,
      clear_fifo => module_input6,
      clk => clk,
      data_in => internal_cpu_data_master_granted_iobusMAC_2_slave,
      read => iobusMAC_2_slave_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input7,
      write => module_input8
    );

  module_input6 <= std_logic'('0');
  module_input7 <= std_logic'('0');
  module_input8 <= in_a_read_cycle AND NOT iobusMAC_2_slave_waits_for_read;

  internal_cpu_data_master_read_data_valid_iobusMAC_2_slave_shift_register <= NOT cpu_data_master_rdv_fifo_empty_iobusMAC_2_slave;
  --local readdatavalid cpu_data_master_read_data_valid_iobusMAC_2_slave, which is an e_mux
  cpu_data_master_read_data_valid_iobusMAC_2_slave <= iobusMAC_2_slave_readdatavalid_from_sa;
  --iobusMAC_2_slave_writedata mux, which is an e_mux
  iobusMAC_2_slave_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_iobusMAC_2_slave <= internal_cpu_data_master_qualified_request_iobusMAC_2_slave;
  --cpu/data_master saved-grant iobusMAC_2/slave, which is an e_assign
  cpu_data_master_saved_grant_iobusMAC_2_slave <= internal_cpu_data_master_requests_iobusMAC_2_slave;
  --allow new arb cycle for iobusMAC_2/slave, which is an e_assign
  iobusMAC_2_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  iobusMAC_2_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  iobusMAC_2_slave_master_qreq_vector <= std_logic'('1');
  --~iobusMAC_2_slave_reset assignment, which is an e_assign
  iobusMAC_2_slave_reset <= NOT reset_n;
  --iobusMAC_2_slave_firsttransfer first transaction, which is an e_assign
  iobusMAC_2_slave_firsttransfer <= A_WE_StdLogic((std_logic'(iobusMAC_2_slave_begins_xfer) = '1'), iobusMAC_2_slave_unreg_firsttransfer, iobusMAC_2_slave_reg_firsttransfer);
  --iobusMAC_2_slave_unreg_firsttransfer first transaction, which is an e_assign
  iobusMAC_2_slave_unreg_firsttransfer <= NOT ((iobusMAC_2_slave_slavearbiterlockenable AND iobusMAC_2_slave_any_continuerequest));
  --iobusMAC_2_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_2_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMAC_2_slave_begins_xfer) = '1' then 
        iobusMAC_2_slave_reg_firsttransfer <= iobusMAC_2_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --iobusMAC_2_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  iobusMAC_2_slave_beginbursttransfer_internal <= iobusMAC_2_slave_begins_xfer;
  --iobusMAC_2_slave_read assignment, which is an e_mux
  iobusMAC_2_slave_read <= internal_cpu_data_master_granted_iobusMAC_2_slave AND cpu_data_master_read;
  --iobusMAC_2_slave_write assignment, which is an e_mux
  iobusMAC_2_slave_write <= internal_cpu_data_master_granted_iobusMAC_2_slave AND cpu_data_master_write;
  shifted_address_to_iobusMAC_2_slave_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --iobusMAC_2_slave_address mux, which is an e_mux
  iobusMAC_2_slave_address <= A_EXT (A_SRL(shifted_address_to_iobusMAC_2_slave_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 4);
  --d1_iobusMAC_2_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_iobusMAC_2_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_iobusMAC_2_slave_end_xfer <= iobusMAC_2_slave_end_xfer;
    end if;

  end process;

  --iobusMAC_2_slave_waits_for_read in a cycle, which is an e_mux
  iobusMAC_2_slave_waits_for_read <= iobusMAC_2_slave_in_a_read_cycle AND internal_iobusMAC_2_slave_waitrequest_from_sa;
  --iobusMAC_2_slave_in_a_read_cycle assignment, which is an e_assign
  iobusMAC_2_slave_in_a_read_cycle <= internal_cpu_data_master_granted_iobusMAC_2_slave AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= iobusMAC_2_slave_in_a_read_cycle;
  --iobusMAC_2_slave_waits_for_write in a cycle, which is an e_mux
  iobusMAC_2_slave_waits_for_write <= iobusMAC_2_slave_in_a_write_cycle AND internal_iobusMAC_2_slave_waitrequest_from_sa;
  --iobusMAC_2_slave_in_a_write_cycle assignment, which is an e_assign
  iobusMAC_2_slave_in_a_write_cycle <= internal_cpu_data_master_granted_iobusMAC_2_slave AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= iobusMAC_2_slave_in_a_write_cycle;
  wait_for_iobusMAC_2_slave_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_iobusMAC_2_slave <= internal_cpu_data_master_granted_iobusMAC_2_slave;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_iobusMAC_2_slave <= internal_cpu_data_master_qualified_request_iobusMAC_2_slave;
  --vhdl renameroo for output signals
  cpu_data_master_read_data_valid_iobusMAC_2_slave_shift_register <= internal_cpu_data_master_read_data_valid_iobusMAC_2_slave_shift_register;
  --vhdl renameroo for output signals
  cpu_data_master_requests_iobusMAC_2_slave <= internal_cpu_data_master_requests_iobusMAC_2_slave;
  --vhdl renameroo for output signals
  iobusMAC_2_slave_waitrequest_from_sa <= internal_iobusMAC_2_slave_waitrequest_from_sa;
--synthesis translate_off
    --iobusMAC_2/slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rdv_fifo_for_cpu_data_master_to_iobusMAC_3_slave_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_data_master_to_iobusMAC_3_slave_module;


architecture europa of rdv_fifo_for_cpu_data_master_to_iobusMAC_3_slave_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (1 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_0;
  empty <= NOT(full_0);
  full_1 <= std_logic'('0');
  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 2);
  one_count_minus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 2);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("000000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 2);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity iobusMAC_3_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_3_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_3_slave_readdatavalid : IN STD_LOGIC;
                 signal iobusMAC_3_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_iobusMAC_3_slave : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMAC_3_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_3_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_3_slave_shift_register : OUT STD_LOGIC;
                 signal cpu_data_master_requests_iobusMAC_3_slave : OUT STD_LOGIC;
                 signal d1_iobusMAC_3_slave_end_xfer : OUT STD_LOGIC;
                 signal iobusMAC_3_slave_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal iobusMAC_3_slave_read : OUT STD_LOGIC;
                 signal iobusMAC_3_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_3_slave_reset : OUT STD_LOGIC;
                 signal iobusMAC_3_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal iobusMAC_3_slave_write : OUT STD_LOGIC;
                 signal iobusMAC_3_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity iobusMAC_3_slave_arbitrator;


architecture europa of iobusMAC_3_slave_arbitrator is
component rdv_fifo_for_cpu_data_master_to_iobusMAC_3_slave_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_data_master_to_iobusMAC_3_slave_module;

                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_empty_iobusMAC_3_slave :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_output_from_iobusMAC_3_slave :  STD_LOGIC;
                signal cpu_data_master_saved_grant_iobusMAC_3_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_iobusMAC_3_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_iobusMAC_3_slave :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_iobusMAC_3_slave :  STD_LOGIC;
                signal internal_cpu_data_master_read_data_valid_iobusMAC_3_slave_shift_register :  STD_LOGIC;
                signal internal_cpu_data_master_requests_iobusMAC_3_slave :  STD_LOGIC;
                signal internal_iobusMAC_3_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMAC_3_slave_allgrants :  STD_LOGIC;
                signal iobusMAC_3_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal iobusMAC_3_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal iobusMAC_3_slave_any_continuerequest :  STD_LOGIC;
                signal iobusMAC_3_slave_arb_counter_enable :  STD_LOGIC;
                signal iobusMAC_3_slave_arb_share_counter :  STD_LOGIC;
                signal iobusMAC_3_slave_arb_share_counter_next_value :  STD_LOGIC;
                signal iobusMAC_3_slave_arb_share_set_values :  STD_LOGIC;
                signal iobusMAC_3_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal iobusMAC_3_slave_begins_xfer :  STD_LOGIC;
                signal iobusMAC_3_slave_end_xfer :  STD_LOGIC;
                signal iobusMAC_3_slave_firsttransfer :  STD_LOGIC;
                signal iobusMAC_3_slave_grant_vector :  STD_LOGIC;
                signal iobusMAC_3_slave_in_a_read_cycle :  STD_LOGIC;
                signal iobusMAC_3_slave_in_a_write_cycle :  STD_LOGIC;
                signal iobusMAC_3_slave_master_qreq_vector :  STD_LOGIC;
                signal iobusMAC_3_slave_move_on_to_next_transaction :  STD_LOGIC;
                signal iobusMAC_3_slave_non_bursting_master_requests :  STD_LOGIC;
                signal iobusMAC_3_slave_readdatavalid_from_sa :  STD_LOGIC;
                signal iobusMAC_3_slave_reg_firsttransfer :  STD_LOGIC;
                signal iobusMAC_3_slave_slavearbiterlockenable :  STD_LOGIC;
                signal iobusMAC_3_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal iobusMAC_3_slave_unreg_firsttransfer :  STD_LOGIC;
                signal iobusMAC_3_slave_waits_for_read :  STD_LOGIC;
                signal iobusMAC_3_slave_waits_for_write :  STD_LOGIC;
                signal module_input10 :  STD_LOGIC;
                signal module_input11 :  STD_LOGIC;
                signal module_input9 :  STD_LOGIC;
                signal shifted_address_to_iobusMAC_3_slave_from_cpu_data_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal wait_for_iobusMAC_3_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT iobusMAC_3_slave_end_xfer;
    end if;

  end process;

  iobusMAC_3_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_iobusMAC_3_slave);
  --assign iobusMAC_3_slave_readdata_from_sa = iobusMAC_3_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMAC_3_slave_readdata_from_sa <= iobusMAC_3_slave_readdata;
  internal_cpu_data_master_requests_iobusMAC_3_slave <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(13 DOWNTO 6) & std_logic_vector'("000000")) = std_logic_vector'("00100100000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign iobusMAC_3_slave_waitrequest_from_sa = iobusMAC_3_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_iobusMAC_3_slave_waitrequest_from_sa <= iobusMAC_3_slave_waitrequest;
  --assign iobusMAC_3_slave_readdatavalid_from_sa = iobusMAC_3_slave_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMAC_3_slave_readdatavalid_from_sa <= iobusMAC_3_slave_readdatavalid;
  --iobusMAC_3_slave_arb_share_counter set values, which is an e_mux
  iobusMAC_3_slave_arb_share_set_values <= std_logic'('1');
  --iobusMAC_3_slave_non_bursting_master_requests mux, which is an e_mux
  iobusMAC_3_slave_non_bursting_master_requests <= internal_cpu_data_master_requests_iobusMAC_3_slave;
  --iobusMAC_3_slave_any_bursting_master_saved_grant mux, which is an e_mux
  iobusMAC_3_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --iobusMAC_3_slave_arb_share_counter_next_value assignment, which is an e_assign
  iobusMAC_3_slave_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(iobusMAC_3_slave_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMAC_3_slave_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(iobusMAC_3_slave_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMAC_3_slave_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --iobusMAC_3_slave_allgrants all slave grants, which is an e_mux
  iobusMAC_3_slave_allgrants <= iobusMAC_3_slave_grant_vector;
  --iobusMAC_3_slave_end_xfer assignment, which is an e_assign
  iobusMAC_3_slave_end_xfer <= NOT ((iobusMAC_3_slave_waits_for_read OR iobusMAC_3_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_iobusMAC_3_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_iobusMAC_3_slave <= iobusMAC_3_slave_end_xfer AND (((NOT iobusMAC_3_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --iobusMAC_3_slave_arb_share_counter arbitration counter enable, which is an e_assign
  iobusMAC_3_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_iobusMAC_3_slave AND iobusMAC_3_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_iobusMAC_3_slave AND NOT iobusMAC_3_slave_non_bursting_master_requests));
  --iobusMAC_3_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_3_slave_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMAC_3_slave_arb_counter_enable) = '1' then 
        iobusMAC_3_slave_arb_share_counter <= iobusMAC_3_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --iobusMAC_3_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_3_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((iobusMAC_3_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_iobusMAC_3_slave)) OR ((end_xfer_arb_share_counter_term_iobusMAC_3_slave AND NOT iobusMAC_3_slave_non_bursting_master_requests)))) = '1' then 
        iobusMAC_3_slave_slavearbiterlockenable <= iobusMAC_3_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master iobusMAC_3/slave arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= iobusMAC_3_slave_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --iobusMAC_3_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  iobusMAC_3_slave_slavearbiterlockenable2 <= iobusMAC_3_slave_arb_share_counter_next_value;
  --cpu/data_master iobusMAC_3/slave arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= iobusMAC_3_slave_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --iobusMAC_3_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  iobusMAC_3_slave_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_iobusMAC_3_slave <= internal_cpu_data_master_requests_iobusMAC_3_slave AND NOT ((((cpu_data_master_read AND ((NOT cpu_data_master_waitrequest OR (internal_cpu_data_master_read_data_valid_iobusMAC_3_slave_shift_register))))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))));
  --unique name for iobusMAC_3_slave_move_on_to_next_transaction, which is an e_assign
  iobusMAC_3_slave_move_on_to_next_transaction <= iobusMAC_3_slave_readdatavalid_from_sa;
  --rdv_fifo_for_cpu_data_master_to_iobusMAC_3_slave, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_data_master_to_iobusMAC_3_slave : rdv_fifo_for_cpu_data_master_to_iobusMAC_3_slave_module
    port map(
      data_out => cpu_data_master_rdv_fifo_output_from_iobusMAC_3_slave,
      empty => open,
      fifo_contains_ones_n => cpu_data_master_rdv_fifo_empty_iobusMAC_3_slave,
      full => open,
      clear_fifo => module_input9,
      clk => clk,
      data_in => internal_cpu_data_master_granted_iobusMAC_3_slave,
      read => iobusMAC_3_slave_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input10,
      write => module_input11
    );

  module_input9 <= std_logic'('0');
  module_input10 <= std_logic'('0');
  module_input11 <= in_a_read_cycle AND NOT iobusMAC_3_slave_waits_for_read;

  internal_cpu_data_master_read_data_valid_iobusMAC_3_slave_shift_register <= NOT cpu_data_master_rdv_fifo_empty_iobusMAC_3_slave;
  --local readdatavalid cpu_data_master_read_data_valid_iobusMAC_3_slave, which is an e_mux
  cpu_data_master_read_data_valid_iobusMAC_3_slave <= iobusMAC_3_slave_readdatavalid_from_sa;
  --iobusMAC_3_slave_writedata mux, which is an e_mux
  iobusMAC_3_slave_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_iobusMAC_3_slave <= internal_cpu_data_master_qualified_request_iobusMAC_3_slave;
  --cpu/data_master saved-grant iobusMAC_3/slave, which is an e_assign
  cpu_data_master_saved_grant_iobusMAC_3_slave <= internal_cpu_data_master_requests_iobusMAC_3_slave;
  --allow new arb cycle for iobusMAC_3/slave, which is an e_assign
  iobusMAC_3_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  iobusMAC_3_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  iobusMAC_3_slave_master_qreq_vector <= std_logic'('1');
  --~iobusMAC_3_slave_reset assignment, which is an e_assign
  iobusMAC_3_slave_reset <= NOT reset_n;
  --iobusMAC_3_slave_firsttransfer first transaction, which is an e_assign
  iobusMAC_3_slave_firsttransfer <= A_WE_StdLogic((std_logic'(iobusMAC_3_slave_begins_xfer) = '1'), iobusMAC_3_slave_unreg_firsttransfer, iobusMAC_3_slave_reg_firsttransfer);
  --iobusMAC_3_slave_unreg_firsttransfer first transaction, which is an e_assign
  iobusMAC_3_slave_unreg_firsttransfer <= NOT ((iobusMAC_3_slave_slavearbiterlockenable AND iobusMAC_3_slave_any_continuerequest));
  --iobusMAC_3_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_3_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMAC_3_slave_begins_xfer) = '1' then 
        iobusMAC_3_slave_reg_firsttransfer <= iobusMAC_3_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --iobusMAC_3_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  iobusMAC_3_slave_beginbursttransfer_internal <= iobusMAC_3_slave_begins_xfer;
  --iobusMAC_3_slave_read assignment, which is an e_mux
  iobusMAC_3_slave_read <= internal_cpu_data_master_granted_iobusMAC_3_slave AND cpu_data_master_read;
  --iobusMAC_3_slave_write assignment, which is an e_mux
  iobusMAC_3_slave_write <= internal_cpu_data_master_granted_iobusMAC_3_slave AND cpu_data_master_write;
  shifted_address_to_iobusMAC_3_slave_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --iobusMAC_3_slave_address mux, which is an e_mux
  iobusMAC_3_slave_address <= A_EXT (A_SRL(shifted_address_to_iobusMAC_3_slave_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 4);
  --d1_iobusMAC_3_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_iobusMAC_3_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_iobusMAC_3_slave_end_xfer <= iobusMAC_3_slave_end_xfer;
    end if;

  end process;

  --iobusMAC_3_slave_waits_for_read in a cycle, which is an e_mux
  iobusMAC_3_slave_waits_for_read <= iobusMAC_3_slave_in_a_read_cycle AND internal_iobusMAC_3_slave_waitrequest_from_sa;
  --iobusMAC_3_slave_in_a_read_cycle assignment, which is an e_assign
  iobusMAC_3_slave_in_a_read_cycle <= internal_cpu_data_master_granted_iobusMAC_3_slave AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= iobusMAC_3_slave_in_a_read_cycle;
  --iobusMAC_3_slave_waits_for_write in a cycle, which is an e_mux
  iobusMAC_3_slave_waits_for_write <= iobusMAC_3_slave_in_a_write_cycle AND internal_iobusMAC_3_slave_waitrequest_from_sa;
  --iobusMAC_3_slave_in_a_write_cycle assignment, which is an e_assign
  iobusMAC_3_slave_in_a_write_cycle <= internal_cpu_data_master_granted_iobusMAC_3_slave AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= iobusMAC_3_slave_in_a_write_cycle;
  wait_for_iobusMAC_3_slave_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_iobusMAC_3_slave <= internal_cpu_data_master_granted_iobusMAC_3_slave;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_iobusMAC_3_slave <= internal_cpu_data_master_qualified_request_iobusMAC_3_slave;
  --vhdl renameroo for output signals
  cpu_data_master_read_data_valid_iobusMAC_3_slave_shift_register <= internal_cpu_data_master_read_data_valid_iobusMAC_3_slave_shift_register;
  --vhdl renameroo for output signals
  cpu_data_master_requests_iobusMAC_3_slave <= internal_cpu_data_master_requests_iobusMAC_3_slave;
  --vhdl renameroo for output signals
  iobusMAC_3_slave_waitrequest_from_sa <= internal_iobusMAC_3_slave_waitrequest_from_sa;
--synthesis translate_off
    --iobusMAC_3/slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rdv_fifo_for_cpu_data_master_to_iobusMAC_4_slave_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_data_master_to_iobusMAC_4_slave_module;


architecture europa of rdv_fifo_for_cpu_data_master_to_iobusMAC_4_slave_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (1 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_0;
  empty <= NOT(full_0);
  full_1 <= std_logic'('0');
  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 2);
  one_count_minus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 2);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("000000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 2);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity iobusMAC_4_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_4_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_4_slave_readdatavalid : IN STD_LOGIC;
                 signal iobusMAC_4_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_iobusMAC_4_slave : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMAC_4_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_4_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_4_slave_shift_register : OUT STD_LOGIC;
                 signal cpu_data_master_requests_iobusMAC_4_slave : OUT STD_LOGIC;
                 signal d1_iobusMAC_4_slave_end_xfer : OUT STD_LOGIC;
                 signal iobusMAC_4_slave_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal iobusMAC_4_slave_read : OUT STD_LOGIC;
                 signal iobusMAC_4_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_4_slave_reset : OUT STD_LOGIC;
                 signal iobusMAC_4_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal iobusMAC_4_slave_write : OUT STD_LOGIC;
                 signal iobusMAC_4_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity iobusMAC_4_slave_arbitrator;


architecture europa of iobusMAC_4_slave_arbitrator is
component rdv_fifo_for_cpu_data_master_to_iobusMAC_4_slave_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_data_master_to_iobusMAC_4_slave_module;

                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_empty_iobusMAC_4_slave :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_output_from_iobusMAC_4_slave :  STD_LOGIC;
                signal cpu_data_master_saved_grant_iobusMAC_4_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_iobusMAC_4_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_iobusMAC_4_slave :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_iobusMAC_4_slave :  STD_LOGIC;
                signal internal_cpu_data_master_read_data_valid_iobusMAC_4_slave_shift_register :  STD_LOGIC;
                signal internal_cpu_data_master_requests_iobusMAC_4_slave :  STD_LOGIC;
                signal internal_iobusMAC_4_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMAC_4_slave_allgrants :  STD_LOGIC;
                signal iobusMAC_4_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal iobusMAC_4_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal iobusMAC_4_slave_any_continuerequest :  STD_LOGIC;
                signal iobusMAC_4_slave_arb_counter_enable :  STD_LOGIC;
                signal iobusMAC_4_slave_arb_share_counter :  STD_LOGIC;
                signal iobusMAC_4_slave_arb_share_counter_next_value :  STD_LOGIC;
                signal iobusMAC_4_slave_arb_share_set_values :  STD_LOGIC;
                signal iobusMAC_4_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal iobusMAC_4_slave_begins_xfer :  STD_LOGIC;
                signal iobusMAC_4_slave_end_xfer :  STD_LOGIC;
                signal iobusMAC_4_slave_firsttransfer :  STD_LOGIC;
                signal iobusMAC_4_slave_grant_vector :  STD_LOGIC;
                signal iobusMAC_4_slave_in_a_read_cycle :  STD_LOGIC;
                signal iobusMAC_4_slave_in_a_write_cycle :  STD_LOGIC;
                signal iobusMAC_4_slave_master_qreq_vector :  STD_LOGIC;
                signal iobusMAC_4_slave_move_on_to_next_transaction :  STD_LOGIC;
                signal iobusMAC_4_slave_non_bursting_master_requests :  STD_LOGIC;
                signal iobusMAC_4_slave_readdatavalid_from_sa :  STD_LOGIC;
                signal iobusMAC_4_slave_reg_firsttransfer :  STD_LOGIC;
                signal iobusMAC_4_slave_slavearbiterlockenable :  STD_LOGIC;
                signal iobusMAC_4_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal iobusMAC_4_slave_unreg_firsttransfer :  STD_LOGIC;
                signal iobusMAC_4_slave_waits_for_read :  STD_LOGIC;
                signal iobusMAC_4_slave_waits_for_write :  STD_LOGIC;
                signal module_input12 :  STD_LOGIC;
                signal module_input13 :  STD_LOGIC;
                signal module_input14 :  STD_LOGIC;
                signal shifted_address_to_iobusMAC_4_slave_from_cpu_data_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal wait_for_iobusMAC_4_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT iobusMAC_4_slave_end_xfer;
    end if;

  end process;

  iobusMAC_4_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_iobusMAC_4_slave);
  --assign iobusMAC_4_slave_readdata_from_sa = iobusMAC_4_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMAC_4_slave_readdata_from_sa <= iobusMAC_4_slave_readdata;
  internal_cpu_data_master_requests_iobusMAC_4_slave <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(13 DOWNTO 6) & std_logic_vector'("000000")) = std_logic_vector'("00100101000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign iobusMAC_4_slave_waitrequest_from_sa = iobusMAC_4_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_iobusMAC_4_slave_waitrequest_from_sa <= iobusMAC_4_slave_waitrequest;
  --assign iobusMAC_4_slave_readdatavalid_from_sa = iobusMAC_4_slave_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMAC_4_slave_readdatavalid_from_sa <= iobusMAC_4_slave_readdatavalid;
  --iobusMAC_4_slave_arb_share_counter set values, which is an e_mux
  iobusMAC_4_slave_arb_share_set_values <= std_logic'('1');
  --iobusMAC_4_slave_non_bursting_master_requests mux, which is an e_mux
  iobusMAC_4_slave_non_bursting_master_requests <= internal_cpu_data_master_requests_iobusMAC_4_slave;
  --iobusMAC_4_slave_any_bursting_master_saved_grant mux, which is an e_mux
  iobusMAC_4_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --iobusMAC_4_slave_arb_share_counter_next_value assignment, which is an e_assign
  iobusMAC_4_slave_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(iobusMAC_4_slave_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMAC_4_slave_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(iobusMAC_4_slave_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMAC_4_slave_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --iobusMAC_4_slave_allgrants all slave grants, which is an e_mux
  iobusMAC_4_slave_allgrants <= iobusMAC_4_slave_grant_vector;
  --iobusMAC_4_slave_end_xfer assignment, which is an e_assign
  iobusMAC_4_slave_end_xfer <= NOT ((iobusMAC_4_slave_waits_for_read OR iobusMAC_4_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_iobusMAC_4_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_iobusMAC_4_slave <= iobusMAC_4_slave_end_xfer AND (((NOT iobusMAC_4_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --iobusMAC_4_slave_arb_share_counter arbitration counter enable, which is an e_assign
  iobusMAC_4_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_iobusMAC_4_slave AND iobusMAC_4_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_iobusMAC_4_slave AND NOT iobusMAC_4_slave_non_bursting_master_requests));
  --iobusMAC_4_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_4_slave_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMAC_4_slave_arb_counter_enable) = '1' then 
        iobusMAC_4_slave_arb_share_counter <= iobusMAC_4_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --iobusMAC_4_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_4_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((iobusMAC_4_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_iobusMAC_4_slave)) OR ((end_xfer_arb_share_counter_term_iobusMAC_4_slave AND NOT iobusMAC_4_slave_non_bursting_master_requests)))) = '1' then 
        iobusMAC_4_slave_slavearbiterlockenable <= iobusMAC_4_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master iobusMAC_4/slave arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= iobusMAC_4_slave_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --iobusMAC_4_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  iobusMAC_4_slave_slavearbiterlockenable2 <= iobusMAC_4_slave_arb_share_counter_next_value;
  --cpu/data_master iobusMAC_4/slave arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= iobusMAC_4_slave_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --iobusMAC_4_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  iobusMAC_4_slave_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_iobusMAC_4_slave <= internal_cpu_data_master_requests_iobusMAC_4_slave AND NOT ((((cpu_data_master_read AND ((NOT cpu_data_master_waitrequest OR (internal_cpu_data_master_read_data_valid_iobusMAC_4_slave_shift_register))))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))));
  --unique name for iobusMAC_4_slave_move_on_to_next_transaction, which is an e_assign
  iobusMAC_4_slave_move_on_to_next_transaction <= iobusMAC_4_slave_readdatavalid_from_sa;
  --rdv_fifo_for_cpu_data_master_to_iobusMAC_4_slave, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_data_master_to_iobusMAC_4_slave : rdv_fifo_for_cpu_data_master_to_iobusMAC_4_slave_module
    port map(
      data_out => cpu_data_master_rdv_fifo_output_from_iobusMAC_4_slave,
      empty => open,
      fifo_contains_ones_n => cpu_data_master_rdv_fifo_empty_iobusMAC_4_slave,
      full => open,
      clear_fifo => module_input12,
      clk => clk,
      data_in => internal_cpu_data_master_granted_iobusMAC_4_slave,
      read => iobusMAC_4_slave_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input13,
      write => module_input14
    );

  module_input12 <= std_logic'('0');
  module_input13 <= std_logic'('0');
  module_input14 <= in_a_read_cycle AND NOT iobusMAC_4_slave_waits_for_read;

  internal_cpu_data_master_read_data_valid_iobusMAC_4_slave_shift_register <= NOT cpu_data_master_rdv_fifo_empty_iobusMAC_4_slave;
  --local readdatavalid cpu_data_master_read_data_valid_iobusMAC_4_slave, which is an e_mux
  cpu_data_master_read_data_valid_iobusMAC_4_slave <= iobusMAC_4_slave_readdatavalid_from_sa;
  --iobusMAC_4_slave_writedata mux, which is an e_mux
  iobusMAC_4_slave_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_iobusMAC_4_slave <= internal_cpu_data_master_qualified_request_iobusMAC_4_slave;
  --cpu/data_master saved-grant iobusMAC_4/slave, which is an e_assign
  cpu_data_master_saved_grant_iobusMAC_4_slave <= internal_cpu_data_master_requests_iobusMAC_4_slave;
  --allow new arb cycle for iobusMAC_4/slave, which is an e_assign
  iobusMAC_4_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  iobusMAC_4_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  iobusMAC_4_slave_master_qreq_vector <= std_logic'('1');
  --~iobusMAC_4_slave_reset assignment, which is an e_assign
  iobusMAC_4_slave_reset <= NOT reset_n;
  --iobusMAC_4_slave_firsttransfer first transaction, which is an e_assign
  iobusMAC_4_slave_firsttransfer <= A_WE_StdLogic((std_logic'(iobusMAC_4_slave_begins_xfer) = '1'), iobusMAC_4_slave_unreg_firsttransfer, iobusMAC_4_slave_reg_firsttransfer);
  --iobusMAC_4_slave_unreg_firsttransfer first transaction, which is an e_assign
  iobusMAC_4_slave_unreg_firsttransfer <= NOT ((iobusMAC_4_slave_slavearbiterlockenable AND iobusMAC_4_slave_any_continuerequest));
  --iobusMAC_4_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_4_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMAC_4_slave_begins_xfer) = '1' then 
        iobusMAC_4_slave_reg_firsttransfer <= iobusMAC_4_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --iobusMAC_4_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  iobusMAC_4_slave_beginbursttransfer_internal <= iobusMAC_4_slave_begins_xfer;
  --iobusMAC_4_slave_read assignment, which is an e_mux
  iobusMAC_4_slave_read <= internal_cpu_data_master_granted_iobusMAC_4_slave AND cpu_data_master_read;
  --iobusMAC_4_slave_write assignment, which is an e_mux
  iobusMAC_4_slave_write <= internal_cpu_data_master_granted_iobusMAC_4_slave AND cpu_data_master_write;
  shifted_address_to_iobusMAC_4_slave_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --iobusMAC_4_slave_address mux, which is an e_mux
  iobusMAC_4_slave_address <= A_EXT (A_SRL(shifted_address_to_iobusMAC_4_slave_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 4);
  --d1_iobusMAC_4_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_iobusMAC_4_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_iobusMAC_4_slave_end_xfer <= iobusMAC_4_slave_end_xfer;
    end if;

  end process;

  --iobusMAC_4_slave_waits_for_read in a cycle, which is an e_mux
  iobusMAC_4_slave_waits_for_read <= iobusMAC_4_slave_in_a_read_cycle AND internal_iobusMAC_4_slave_waitrequest_from_sa;
  --iobusMAC_4_slave_in_a_read_cycle assignment, which is an e_assign
  iobusMAC_4_slave_in_a_read_cycle <= internal_cpu_data_master_granted_iobusMAC_4_slave AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= iobusMAC_4_slave_in_a_read_cycle;
  --iobusMAC_4_slave_waits_for_write in a cycle, which is an e_mux
  iobusMAC_4_slave_waits_for_write <= iobusMAC_4_slave_in_a_write_cycle AND internal_iobusMAC_4_slave_waitrequest_from_sa;
  --iobusMAC_4_slave_in_a_write_cycle assignment, which is an e_assign
  iobusMAC_4_slave_in_a_write_cycle <= internal_cpu_data_master_granted_iobusMAC_4_slave AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= iobusMAC_4_slave_in_a_write_cycle;
  wait_for_iobusMAC_4_slave_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_iobusMAC_4_slave <= internal_cpu_data_master_granted_iobusMAC_4_slave;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_iobusMAC_4_slave <= internal_cpu_data_master_qualified_request_iobusMAC_4_slave;
  --vhdl renameroo for output signals
  cpu_data_master_read_data_valid_iobusMAC_4_slave_shift_register <= internal_cpu_data_master_read_data_valid_iobusMAC_4_slave_shift_register;
  --vhdl renameroo for output signals
  cpu_data_master_requests_iobusMAC_4_slave <= internal_cpu_data_master_requests_iobusMAC_4_slave;
  --vhdl renameroo for output signals
  iobusMAC_4_slave_waitrequest_from_sa <= internal_iobusMAC_4_slave_waitrequest_from_sa;
--synthesis translate_off
    --iobusMAC_4/slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rdv_fifo_for_cpu_data_master_to_iobusMAC_5_slave_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_data_master_to_iobusMAC_5_slave_module;


architecture europa of rdv_fifo_for_cpu_data_master_to_iobusMAC_5_slave_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (1 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_0;
  empty <= NOT(full_0);
  full_1 <= std_logic'('0');
  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 2);
  one_count_minus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 2);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("000000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 2);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity iobusMAC_5_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_5_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_5_slave_readdatavalid : IN STD_LOGIC;
                 signal iobusMAC_5_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_iobusMAC_5_slave : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMAC_5_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_5_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_5_slave_shift_register : OUT STD_LOGIC;
                 signal cpu_data_master_requests_iobusMAC_5_slave : OUT STD_LOGIC;
                 signal d1_iobusMAC_5_slave_end_xfer : OUT STD_LOGIC;
                 signal iobusMAC_5_slave_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal iobusMAC_5_slave_read : OUT STD_LOGIC;
                 signal iobusMAC_5_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_5_slave_reset : OUT STD_LOGIC;
                 signal iobusMAC_5_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal iobusMAC_5_slave_write : OUT STD_LOGIC;
                 signal iobusMAC_5_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity iobusMAC_5_slave_arbitrator;


architecture europa of iobusMAC_5_slave_arbitrator is
component rdv_fifo_for_cpu_data_master_to_iobusMAC_5_slave_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_data_master_to_iobusMAC_5_slave_module;

                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_empty_iobusMAC_5_slave :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_output_from_iobusMAC_5_slave :  STD_LOGIC;
                signal cpu_data_master_saved_grant_iobusMAC_5_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_iobusMAC_5_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_iobusMAC_5_slave :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_iobusMAC_5_slave :  STD_LOGIC;
                signal internal_cpu_data_master_read_data_valid_iobusMAC_5_slave_shift_register :  STD_LOGIC;
                signal internal_cpu_data_master_requests_iobusMAC_5_slave :  STD_LOGIC;
                signal internal_iobusMAC_5_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMAC_5_slave_allgrants :  STD_LOGIC;
                signal iobusMAC_5_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal iobusMAC_5_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal iobusMAC_5_slave_any_continuerequest :  STD_LOGIC;
                signal iobusMAC_5_slave_arb_counter_enable :  STD_LOGIC;
                signal iobusMAC_5_slave_arb_share_counter :  STD_LOGIC;
                signal iobusMAC_5_slave_arb_share_counter_next_value :  STD_LOGIC;
                signal iobusMAC_5_slave_arb_share_set_values :  STD_LOGIC;
                signal iobusMAC_5_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal iobusMAC_5_slave_begins_xfer :  STD_LOGIC;
                signal iobusMAC_5_slave_end_xfer :  STD_LOGIC;
                signal iobusMAC_5_slave_firsttransfer :  STD_LOGIC;
                signal iobusMAC_5_slave_grant_vector :  STD_LOGIC;
                signal iobusMAC_5_slave_in_a_read_cycle :  STD_LOGIC;
                signal iobusMAC_5_slave_in_a_write_cycle :  STD_LOGIC;
                signal iobusMAC_5_slave_master_qreq_vector :  STD_LOGIC;
                signal iobusMAC_5_slave_move_on_to_next_transaction :  STD_LOGIC;
                signal iobusMAC_5_slave_non_bursting_master_requests :  STD_LOGIC;
                signal iobusMAC_5_slave_readdatavalid_from_sa :  STD_LOGIC;
                signal iobusMAC_5_slave_reg_firsttransfer :  STD_LOGIC;
                signal iobusMAC_5_slave_slavearbiterlockenable :  STD_LOGIC;
                signal iobusMAC_5_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal iobusMAC_5_slave_unreg_firsttransfer :  STD_LOGIC;
                signal iobusMAC_5_slave_waits_for_read :  STD_LOGIC;
                signal iobusMAC_5_slave_waits_for_write :  STD_LOGIC;
                signal module_input15 :  STD_LOGIC;
                signal module_input16 :  STD_LOGIC;
                signal module_input17 :  STD_LOGIC;
                signal shifted_address_to_iobusMAC_5_slave_from_cpu_data_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal wait_for_iobusMAC_5_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT iobusMAC_5_slave_end_xfer;
    end if;

  end process;

  iobusMAC_5_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_iobusMAC_5_slave);
  --assign iobusMAC_5_slave_readdata_from_sa = iobusMAC_5_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMAC_5_slave_readdata_from_sa <= iobusMAC_5_slave_readdata;
  internal_cpu_data_master_requests_iobusMAC_5_slave <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(13 DOWNTO 6) & std_logic_vector'("000000")) = std_logic_vector'("00100110000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign iobusMAC_5_slave_waitrequest_from_sa = iobusMAC_5_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_iobusMAC_5_slave_waitrequest_from_sa <= iobusMAC_5_slave_waitrequest;
  --assign iobusMAC_5_slave_readdatavalid_from_sa = iobusMAC_5_slave_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMAC_5_slave_readdatavalid_from_sa <= iobusMAC_5_slave_readdatavalid;
  --iobusMAC_5_slave_arb_share_counter set values, which is an e_mux
  iobusMAC_5_slave_arb_share_set_values <= std_logic'('1');
  --iobusMAC_5_slave_non_bursting_master_requests mux, which is an e_mux
  iobusMAC_5_slave_non_bursting_master_requests <= internal_cpu_data_master_requests_iobusMAC_5_slave;
  --iobusMAC_5_slave_any_bursting_master_saved_grant mux, which is an e_mux
  iobusMAC_5_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --iobusMAC_5_slave_arb_share_counter_next_value assignment, which is an e_assign
  iobusMAC_5_slave_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(iobusMAC_5_slave_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMAC_5_slave_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(iobusMAC_5_slave_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMAC_5_slave_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --iobusMAC_5_slave_allgrants all slave grants, which is an e_mux
  iobusMAC_5_slave_allgrants <= iobusMAC_5_slave_grant_vector;
  --iobusMAC_5_slave_end_xfer assignment, which is an e_assign
  iobusMAC_5_slave_end_xfer <= NOT ((iobusMAC_5_slave_waits_for_read OR iobusMAC_5_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_iobusMAC_5_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_iobusMAC_5_slave <= iobusMAC_5_slave_end_xfer AND (((NOT iobusMAC_5_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --iobusMAC_5_slave_arb_share_counter arbitration counter enable, which is an e_assign
  iobusMAC_5_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_iobusMAC_5_slave AND iobusMAC_5_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_iobusMAC_5_slave AND NOT iobusMAC_5_slave_non_bursting_master_requests));
  --iobusMAC_5_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_5_slave_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMAC_5_slave_arb_counter_enable) = '1' then 
        iobusMAC_5_slave_arb_share_counter <= iobusMAC_5_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --iobusMAC_5_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_5_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((iobusMAC_5_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_iobusMAC_5_slave)) OR ((end_xfer_arb_share_counter_term_iobusMAC_5_slave AND NOT iobusMAC_5_slave_non_bursting_master_requests)))) = '1' then 
        iobusMAC_5_slave_slavearbiterlockenable <= iobusMAC_5_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master iobusMAC_5/slave arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= iobusMAC_5_slave_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --iobusMAC_5_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  iobusMAC_5_slave_slavearbiterlockenable2 <= iobusMAC_5_slave_arb_share_counter_next_value;
  --cpu/data_master iobusMAC_5/slave arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= iobusMAC_5_slave_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --iobusMAC_5_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  iobusMAC_5_slave_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_iobusMAC_5_slave <= internal_cpu_data_master_requests_iobusMAC_5_slave AND NOT ((((cpu_data_master_read AND ((NOT cpu_data_master_waitrequest OR (internal_cpu_data_master_read_data_valid_iobusMAC_5_slave_shift_register))))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))));
  --unique name for iobusMAC_5_slave_move_on_to_next_transaction, which is an e_assign
  iobusMAC_5_slave_move_on_to_next_transaction <= iobusMAC_5_slave_readdatavalid_from_sa;
  --rdv_fifo_for_cpu_data_master_to_iobusMAC_5_slave, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_data_master_to_iobusMAC_5_slave : rdv_fifo_for_cpu_data_master_to_iobusMAC_5_slave_module
    port map(
      data_out => cpu_data_master_rdv_fifo_output_from_iobusMAC_5_slave,
      empty => open,
      fifo_contains_ones_n => cpu_data_master_rdv_fifo_empty_iobusMAC_5_slave,
      full => open,
      clear_fifo => module_input15,
      clk => clk,
      data_in => internal_cpu_data_master_granted_iobusMAC_5_slave,
      read => iobusMAC_5_slave_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input16,
      write => module_input17
    );

  module_input15 <= std_logic'('0');
  module_input16 <= std_logic'('0');
  module_input17 <= in_a_read_cycle AND NOT iobusMAC_5_slave_waits_for_read;

  internal_cpu_data_master_read_data_valid_iobusMAC_5_slave_shift_register <= NOT cpu_data_master_rdv_fifo_empty_iobusMAC_5_slave;
  --local readdatavalid cpu_data_master_read_data_valid_iobusMAC_5_slave, which is an e_mux
  cpu_data_master_read_data_valid_iobusMAC_5_slave <= iobusMAC_5_slave_readdatavalid_from_sa;
  --iobusMAC_5_slave_writedata mux, which is an e_mux
  iobusMAC_5_slave_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_iobusMAC_5_slave <= internal_cpu_data_master_qualified_request_iobusMAC_5_slave;
  --cpu/data_master saved-grant iobusMAC_5/slave, which is an e_assign
  cpu_data_master_saved_grant_iobusMAC_5_slave <= internal_cpu_data_master_requests_iobusMAC_5_slave;
  --allow new arb cycle for iobusMAC_5/slave, which is an e_assign
  iobusMAC_5_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  iobusMAC_5_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  iobusMAC_5_slave_master_qreq_vector <= std_logic'('1');
  --~iobusMAC_5_slave_reset assignment, which is an e_assign
  iobusMAC_5_slave_reset <= NOT reset_n;
  --iobusMAC_5_slave_firsttransfer first transaction, which is an e_assign
  iobusMAC_5_slave_firsttransfer <= A_WE_StdLogic((std_logic'(iobusMAC_5_slave_begins_xfer) = '1'), iobusMAC_5_slave_unreg_firsttransfer, iobusMAC_5_slave_reg_firsttransfer);
  --iobusMAC_5_slave_unreg_firsttransfer first transaction, which is an e_assign
  iobusMAC_5_slave_unreg_firsttransfer <= NOT ((iobusMAC_5_slave_slavearbiterlockenable AND iobusMAC_5_slave_any_continuerequest));
  --iobusMAC_5_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_5_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMAC_5_slave_begins_xfer) = '1' then 
        iobusMAC_5_slave_reg_firsttransfer <= iobusMAC_5_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --iobusMAC_5_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  iobusMAC_5_slave_beginbursttransfer_internal <= iobusMAC_5_slave_begins_xfer;
  --iobusMAC_5_slave_read assignment, which is an e_mux
  iobusMAC_5_slave_read <= internal_cpu_data_master_granted_iobusMAC_5_slave AND cpu_data_master_read;
  --iobusMAC_5_slave_write assignment, which is an e_mux
  iobusMAC_5_slave_write <= internal_cpu_data_master_granted_iobusMAC_5_slave AND cpu_data_master_write;
  shifted_address_to_iobusMAC_5_slave_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --iobusMAC_5_slave_address mux, which is an e_mux
  iobusMAC_5_slave_address <= A_EXT (A_SRL(shifted_address_to_iobusMAC_5_slave_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 4);
  --d1_iobusMAC_5_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_iobusMAC_5_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_iobusMAC_5_slave_end_xfer <= iobusMAC_5_slave_end_xfer;
    end if;

  end process;

  --iobusMAC_5_slave_waits_for_read in a cycle, which is an e_mux
  iobusMAC_5_slave_waits_for_read <= iobusMAC_5_slave_in_a_read_cycle AND internal_iobusMAC_5_slave_waitrequest_from_sa;
  --iobusMAC_5_slave_in_a_read_cycle assignment, which is an e_assign
  iobusMAC_5_slave_in_a_read_cycle <= internal_cpu_data_master_granted_iobusMAC_5_slave AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= iobusMAC_5_slave_in_a_read_cycle;
  --iobusMAC_5_slave_waits_for_write in a cycle, which is an e_mux
  iobusMAC_5_slave_waits_for_write <= iobusMAC_5_slave_in_a_write_cycle AND internal_iobusMAC_5_slave_waitrequest_from_sa;
  --iobusMAC_5_slave_in_a_write_cycle assignment, which is an e_assign
  iobusMAC_5_slave_in_a_write_cycle <= internal_cpu_data_master_granted_iobusMAC_5_slave AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= iobusMAC_5_slave_in_a_write_cycle;
  wait_for_iobusMAC_5_slave_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_iobusMAC_5_slave <= internal_cpu_data_master_granted_iobusMAC_5_slave;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_iobusMAC_5_slave <= internal_cpu_data_master_qualified_request_iobusMAC_5_slave;
  --vhdl renameroo for output signals
  cpu_data_master_read_data_valid_iobusMAC_5_slave_shift_register <= internal_cpu_data_master_read_data_valid_iobusMAC_5_slave_shift_register;
  --vhdl renameroo for output signals
  cpu_data_master_requests_iobusMAC_5_slave <= internal_cpu_data_master_requests_iobusMAC_5_slave;
  --vhdl renameroo for output signals
  iobusMAC_5_slave_waitrequest_from_sa <= internal_iobusMAC_5_slave_waitrequest_from_sa;
--synthesis translate_off
    --iobusMAC_5/slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rdv_fifo_for_cpu_data_master_to_iobusMAC_6_slave_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_data_master_to_iobusMAC_6_slave_module;


architecture europa of rdv_fifo_for_cpu_data_master_to_iobusMAC_6_slave_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (1 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_0;
  empty <= NOT(full_0);
  full_1 <= std_logic'('0');
  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 2);
  one_count_minus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 2);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("000000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 2);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity iobusMAC_6_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_6_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_6_slave_readdatavalid : IN STD_LOGIC;
                 signal iobusMAC_6_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_iobusMAC_6_slave : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMAC_6_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_6_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_6_slave_shift_register : OUT STD_LOGIC;
                 signal cpu_data_master_requests_iobusMAC_6_slave : OUT STD_LOGIC;
                 signal d1_iobusMAC_6_slave_end_xfer : OUT STD_LOGIC;
                 signal iobusMAC_6_slave_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal iobusMAC_6_slave_read : OUT STD_LOGIC;
                 signal iobusMAC_6_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_6_slave_reset : OUT STD_LOGIC;
                 signal iobusMAC_6_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal iobusMAC_6_slave_write : OUT STD_LOGIC;
                 signal iobusMAC_6_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity iobusMAC_6_slave_arbitrator;


architecture europa of iobusMAC_6_slave_arbitrator is
component rdv_fifo_for_cpu_data_master_to_iobusMAC_6_slave_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_data_master_to_iobusMAC_6_slave_module;

                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_empty_iobusMAC_6_slave :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_output_from_iobusMAC_6_slave :  STD_LOGIC;
                signal cpu_data_master_saved_grant_iobusMAC_6_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_iobusMAC_6_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_iobusMAC_6_slave :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_iobusMAC_6_slave :  STD_LOGIC;
                signal internal_cpu_data_master_read_data_valid_iobusMAC_6_slave_shift_register :  STD_LOGIC;
                signal internal_cpu_data_master_requests_iobusMAC_6_slave :  STD_LOGIC;
                signal internal_iobusMAC_6_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMAC_6_slave_allgrants :  STD_LOGIC;
                signal iobusMAC_6_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal iobusMAC_6_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal iobusMAC_6_slave_any_continuerequest :  STD_LOGIC;
                signal iobusMAC_6_slave_arb_counter_enable :  STD_LOGIC;
                signal iobusMAC_6_slave_arb_share_counter :  STD_LOGIC;
                signal iobusMAC_6_slave_arb_share_counter_next_value :  STD_LOGIC;
                signal iobusMAC_6_slave_arb_share_set_values :  STD_LOGIC;
                signal iobusMAC_6_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal iobusMAC_6_slave_begins_xfer :  STD_LOGIC;
                signal iobusMAC_6_slave_end_xfer :  STD_LOGIC;
                signal iobusMAC_6_slave_firsttransfer :  STD_LOGIC;
                signal iobusMAC_6_slave_grant_vector :  STD_LOGIC;
                signal iobusMAC_6_slave_in_a_read_cycle :  STD_LOGIC;
                signal iobusMAC_6_slave_in_a_write_cycle :  STD_LOGIC;
                signal iobusMAC_6_slave_master_qreq_vector :  STD_LOGIC;
                signal iobusMAC_6_slave_move_on_to_next_transaction :  STD_LOGIC;
                signal iobusMAC_6_slave_non_bursting_master_requests :  STD_LOGIC;
                signal iobusMAC_6_slave_readdatavalid_from_sa :  STD_LOGIC;
                signal iobusMAC_6_slave_reg_firsttransfer :  STD_LOGIC;
                signal iobusMAC_6_slave_slavearbiterlockenable :  STD_LOGIC;
                signal iobusMAC_6_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal iobusMAC_6_slave_unreg_firsttransfer :  STD_LOGIC;
                signal iobusMAC_6_slave_waits_for_read :  STD_LOGIC;
                signal iobusMAC_6_slave_waits_for_write :  STD_LOGIC;
                signal module_input18 :  STD_LOGIC;
                signal module_input19 :  STD_LOGIC;
                signal module_input20 :  STD_LOGIC;
                signal shifted_address_to_iobusMAC_6_slave_from_cpu_data_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal wait_for_iobusMAC_6_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT iobusMAC_6_slave_end_xfer;
    end if;

  end process;

  iobusMAC_6_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_iobusMAC_6_slave);
  --assign iobusMAC_6_slave_readdata_from_sa = iobusMAC_6_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMAC_6_slave_readdata_from_sa <= iobusMAC_6_slave_readdata;
  internal_cpu_data_master_requests_iobusMAC_6_slave <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(13 DOWNTO 6) & std_logic_vector'("000000")) = std_logic_vector'("00100111000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign iobusMAC_6_slave_waitrequest_from_sa = iobusMAC_6_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_iobusMAC_6_slave_waitrequest_from_sa <= iobusMAC_6_slave_waitrequest;
  --assign iobusMAC_6_slave_readdatavalid_from_sa = iobusMAC_6_slave_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMAC_6_slave_readdatavalid_from_sa <= iobusMAC_6_slave_readdatavalid;
  --iobusMAC_6_slave_arb_share_counter set values, which is an e_mux
  iobusMAC_6_slave_arb_share_set_values <= std_logic'('1');
  --iobusMAC_6_slave_non_bursting_master_requests mux, which is an e_mux
  iobusMAC_6_slave_non_bursting_master_requests <= internal_cpu_data_master_requests_iobusMAC_6_slave;
  --iobusMAC_6_slave_any_bursting_master_saved_grant mux, which is an e_mux
  iobusMAC_6_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --iobusMAC_6_slave_arb_share_counter_next_value assignment, which is an e_assign
  iobusMAC_6_slave_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(iobusMAC_6_slave_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMAC_6_slave_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(iobusMAC_6_slave_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMAC_6_slave_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --iobusMAC_6_slave_allgrants all slave grants, which is an e_mux
  iobusMAC_6_slave_allgrants <= iobusMAC_6_slave_grant_vector;
  --iobusMAC_6_slave_end_xfer assignment, which is an e_assign
  iobusMAC_6_slave_end_xfer <= NOT ((iobusMAC_6_slave_waits_for_read OR iobusMAC_6_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_iobusMAC_6_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_iobusMAC_6_slave <= iobusMAC_6_slave_end_xfer AND (((NOT iobusMAC_6_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --iobusMAC_6_slave_arb_share_counter arbitration counter enable, which is an e_assign
  iobusMAC_6_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_iobusMAC_6_slave AND iobusMAC_6_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_iobusMAC_6_slave AND NOT iobusMAC_6_slave_non_bursting_master_requests));
  --iobusMAC_6_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_6_slave_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMAC_6_slave_arb_counter_enable) = '1' then 
        iobusMAC_6_slave_arb_share_counter <= iobusMAC_6_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --iobusMAC_6_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_6_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((iobusMAC_6_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_iobusMAC_6_slave)) OR ((end_xfer_arb_share_counter_term_iobusMAC_6_slave AND NOT iobusMAC_6_slave_non_bursting_master_requests)))) = '1' then 
        iobusMAC_6_slave_slavearbiterlockenable <= iobusMAC_6_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master iobusMAC_6/slave arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= iobusMAC_6_slave_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --iobusMAC_6_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  iobusMAC_6_slave_slavearbiterlockenable2 <= iobusMAC_6_slave_arb_share_counter_next_value;
  --cpu/data_master iobusMAC_6/slave arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= iobusMAC_6_slave_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --iobusMAC_6_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  iobusMAC_6_slave_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_iobusMAC_6_slave <= internal_cpu_data_master_requests_iobusMAC_6_slave AND NOT ((((cpu_data_master_read AND ((NOT cpu_data_master_waitrequest OR (internal_cpu_data_master_read_data_valid_iobusMAC_6_slave_shift_register))))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))));
  --unique name for iobusMAC_6_slave_move_on_to_next_transaction, which is an e_assign
  iobusMAC_6_slave_move_on_to_next_transaction <= iobusMAC_6_slave_readdatavalid_from_sa;
  --rdv_fifo_for_cpu_data_master_to_iobusMAC_6_slave, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_data_master_to_iobusMAC_6_slave : rdv_fifo_for_cpu_data_master_to_iobusMAC_6_slave_module
    port map(
      data_out => cpu_data_master_rdv_fifo_output_from_iobusMAC_6_slave,
      empty => open,
      fifo_contains_ones_n => cpu_data_master_rdv_fifo_empty_iobusMAC_6_slave,
      full => open,
      clear_fifo => module_input18,
      clk => clk,
      data_in => internal_cpu_data_master_granted_iobusMAC_6_slave,
      read => iobusMAC_6_slave_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input19,
      write => module_input20
    );

  module_input18 <= std_logic'('0');
  module_input19 <= std_logic'('0');
  module_input20 <= in_a_read_cycle AND NOT iobusMAC_6_slave_waits_for_read;

  internal_cpu_data_master_read_data_valid_iobusMAC_6_slave_shift_register <= NOT cpu_data_master_rdv_fifo_empty_iobusMAC_6_slave;
  --local readdatavalid cpu_data_master_read_data_valid_iobusMAC_6_slave, which is an e_mux
  cpu_data_master_read_data_valid_iobusMAC_6_slave <= iobusMAC_6_slave_readdatavalid_from_sa;
  --iobusMAC_6_slave_writedata mux, which is an e_mux
  iobusMAC_6_slave_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_iobusMAC_6_slave <= internal_cpu_data_master_qualified_request_iobusMAC_6_slave;
  --cpu/data_master saved-grant iobusMAC_6/slave, which is an e_assign
  cpu_data_master_saved_grant_iobusMAC_6_slave <= internal_cpu_data_master_requests_iobusMAC_6_slave;
  --allow new arb cycle for iobusMAC_6/slave, which is an e_assign
  iobusMAC_6_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  iobusMAC_6_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  iobusMAC_6_slave_master_qreq_vector <= std_logic'('1');
  --~iobusMAC_6_slave_reset assignment, which is an e_assign
  iobusMAC_6_slave_reset <= NOT reset_n;
  --iobusMAC_6_slave_firsttransfer first transaction, which is an e_assign
  iobusMAC_6_slave_firsttransfer <= A_WE_StdLogic((std_logic'(iobusMAC_6_slave_begins_xfer) = '1'), iobusMAC_6_slave_unreg_firsttransfer, iobusMAC_6_slave_reg_firsttransfer);
  --iobusMAC_6_slave_unreg_firsttransfer first transaction, which is an e_assign
  iobusMAC_6_slave_unreg_firsttransfer <= NOT ((iobusMAC_6_slave_slavearbiterlockenable AND iobusMAC_6_slave_any_continuerequest));
  --iobusMAC_6_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_6_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMAC_6_slave_begins_xfer) = '1' then 
        iobusMAC_6_slave_reg_firsttransfer <= iobusMAC_6_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --iobusMAC_6_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  iobusMAC_6_slave_beginbursttransfer_internal <= iobusMAC_6_slave_begins_xfer;
  --iobusMAC_6_slave_read assignment, which is an e_mux
  iobusMAC_6_slave_read <= internal_cpu_data_master_granted_iobusMAC_6_slave AND cpu_data_master_read;
  --iobusMAC_6_slave_write assignment, which is an e_mux
  iobusMAC_6_slave_write <= internal_cpu_data_master_granted_iobusMAC_6_slave AND cpu_data_master_write;
  shifted_address_to_iobusMAC_6_slave_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --iobusMAC_6_slave_address mux, which is an e_mux
  iobusMAC_6_slave_address <= A_EXT (A_SRL(shifted_address_to_iobusMAC_6_slave_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 4);
  --d1_iobusMAC_6_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_iobusMAC_6_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_iobusMAC_6_slave_end_xfer <= iobusMAC_6_slave_end_xfer;
    end if;

  end process;

  --iobusMAC_6_slave_waits_for_read in a cycle, which is an e_mux
  iobusMAC_6_slave_waits_for_read <= iobusMAC_6_slave_in_a_read_cycle AND internal_iobusMAC_6_slave_waitrequest_from_sa;
  --iobusMAC_6_slave_in_a_read_cycle assignment, which is an e_assign
  iobusMAC_6_slave_in_a_read_cycle <= internal_cpu_data_master_granted_iobusMAC_6_slave AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= iobusMAC_6_slave_in_a_read_cycle;
  --iobusMAC_6_slave_waits_for_write in a cycle, which is an e_mux
  iobusMAC_6_slave_waits_for_write <= iobusMAC_6_slave_in_a_write_cycle AND internal_iobusMAC_6_slave_waitrequest_from_sa;
  --iobusMAC_6_slave_in_a_write_cycle assignment, which is an e_assign
  iobusMAC_6_slave_in_a_write_cycle <= internal_cpu_data_master_granted_iobusMAC_6_slave AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= iobusMAC_6_slave_in_a_write_cycle;
  wait_for_iobusMAC_6_slave_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_iobusMAC_6_slave <= internal_cpu_data_master_granted_iobusMAC_6_slave;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_iobusMAC_6_slave <= internal_cpu_data_master_qualified_request_iobusMAC_6_slave;
  --vhdl renameroo for output signals
  cpu_data_master_read_data_valid_iobusMAC_6_slave_shift_register <= internal_cpu_data_master_read_data_valid_iobusMAC_6_slave_shift_register;
  --vhdl renameroo for output signals
  cpu_data_master_requests_iobusMAC_6_slave <= internal_cpu_data_master_requests_iobusMAC_6_slave;
  --vhdl renameroo for output signals
  iobusMAC_6_slave_waitrequest_from_sa <= internal_iobusMAC_6_slave_waitrequest_from_sa;
--synthesis translate_off
    --iobusMAC_6/slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rdv_fifo_for_cpu_data_master_to_iobusMAC_7_slave_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_data_master_to_iobusMAC_7_slave_module;


architecture europa of rdv_fifo_for_cpu_data_master_to_iobusMAC_7_slave_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (1 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_0;
  empty <= NOT(full_0);
  full_1 <= std_logic'('0');
  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 2);
  one_count_minus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 2);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("000000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 2);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity iobusMAC_7_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_7_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_7_slave_readdatavalid : IN STD_LOGIC;
                 signal iobusMAC_7_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_iobusMAC_7_slave : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMAC_7_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_7_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMAC_7_slave_shift_register : OUT STD_LOGIC;
                 signal cpu_data_master_requests_iobusMAC_7_slave : OUT STD_LOGIC;
                 signal d1_iobusMAC_7_slave_end_xfer : OUT STD_LOGIC;
                 signal iobusMAC_7_slave_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal iobusMAC_7_slave_read : OUT STD_LOGIC;
                 signal iobusMAC_7_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMAC_7_slave_reset : OUT STD_LOGIC;
                 signal iobusMAC_7_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal iobusMAC_7_slave_write : OUT STD_LOGIC;
                 signal iobusMAC_7_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity iobusMAC_7_slave_arbitrator;


architecture europa of iobusMAC_7_slave_arbitrator is
component rdv_fifo_for_cpu_data_master_to_iobusMAC_7_slave_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_data_master_to_iobusMAC_7_slave_module;

                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_empty_iobusMAC_7_slave :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_output_from_iobusMAC_7_slave :  STD_LOGIC;
                signal cpu_data_master_saved_grant_iobusMAC_7_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_iobusMAC_7_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_iobusMAC_7_slave :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_iobusMAC_7_slave :  STD_LOGIC;
                signal internal_cpu_data_master_read_data_valid_iobusMAC_7_slave_shift_register :  STD_LOGIC;
                signal internal_cpu_data_master_requests_iobusMAC_7_slave :  STD_LOGIC;
                signal internal_iobusMAC_7_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMAC_7_slave_allgrants :  STD_LOGIC;
                signal iobusMAC_7_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal iobusMAC_7_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal iobusMAC_7_slave_any_continuerequest :  STD_LOGIC;
                signal iobusMAC_7_slave_arb_counter_enable :  STD_LOGIC;
                signal iobusMAC_7_slave_arb_share_counter :  STD_LOGIC;
                signal iobusMAC_7_slave_arb_share_counter_next_value :  STD_LOGIC;
                signal iobusMAC_7_slave_arb_share_set_values :  STD_LOGIC;
                signal iobusMAC_7_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal iobusMAC_7_slave_begins_xfer :  STD_LOGIC;
                signal iobusMAC_7_slave_end_xfer :  STD_LOGIC;
                signal iobusMAC_7_slave_firsttransfer :  STD_LOGIC;
                signal iobusMAC_7_slave_grant_vector :  STD_LOGIC;
                signal iobusMAC_7_slave_in_a_read_cycle :  STD_LOGIC;
                signal iobusMAC_7_slave_in_a_write_cycle :  STD_LOGIC;
                signal iobusMAC_7_slave_master_qreq_vector :  STD_LOGIC;
                signal iobusMAC_7_slave_move_on_to_next_transaction :  STD_LOGIC;
                signal iobusMAC_7_slave_non_bursting_master_requests :  STD_LOGIC;
                signal iobusMAC_7_slave_readdatavalid_from_sa :  STD_LOGIC;
                signal iobusMAC_7_slave_reg_firsttransfer :  STD_LOGIC;
                signal iobusMAC_7_slave_slavearbiterlockenable :  STD_LOGIC;
                signal iobusMAC_7_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal iobusMAC_7_slave_unreg_firsttransfer :  STD_LOGIC;
                signal iobusMAC_7_slave_waits_for_read :  STD_LOGIC;
                signal iobusMAC_7_slave_waits_for_write :  STD_LOGIC;
                signal module_input21 :  STD_LOGIC;
                signal module_input22 :  STD_LOGIC;
                signal module_input23 :  STD_LOGIC;
                signal shifted_address_to_iobusMAC_7_slave_from_cpu_data_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal wait_for_iobusMAC_7_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT iobusMAC_7_slave_end_xfer;
    end if;

  end process;

  iobusMAC_7_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_iobusMAC_7_slave);
  --assign iobusMAC_7_slave_readdata_from_sa = iobusMAC_7_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMAC_7_slave_readdata_from_sa <= iobusMAC_7_slave_readdata;
  internal_cpu_data_master_requests_iobusMAC_7_slave <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(13 DOWNTO 6) & std_logic_vector'("000000")) = std_logic_vector'("00101000000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign iobusMAC_7_slave_waitrequest_from_sa = iobusMAC_7_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_iobusMAC_7_slave_waitrequest_from_sa <= iobusMAC_7_slave_waitrequest;
  --assign iobusMAC_7_slave_readdatavalid_from_sa = iobusMAC_7_slave_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMAC_7_slave_readdatavalid_from_sa <= iobusMAC_7_slave_readdatavalid;
  --iobusMAC_7_slave_arb_share_counter set values, which is an e_mux
  iobusMAC_7_slave_arb_share_set_values <= std_logic'('1');
  --iobusMAC_7_slave_non_bursting_master_requests mux, which is an e_mux
  iobusMAC_7_slave_non_bursting_master_requests <= internal_cpu_data_master_requests_iobusMAC_7_slave;
  --iobusMAC_7_slave_any_bursting_master_saved_grant mux, which is an e_mux
  iobusMAC_7_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --iobusMAC_7_slave_arb_share_counter_next_value assignment, which is an e_assign
  iobusMAC_7_slave_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(iobusMAC_7_slave_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMAC_7_slave_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(iobusMAC_7_slave_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMAC_7_slave_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --iobusMAC_7_slave_allgrants all slave grants, which is an e_mux
  iobusMAC_7_slave_allgrants <= iobusMAC_7_slave_grant_vector;
  --iobusMAC_7_slave_end_xfer assignment, which is an e_assign
  iobusMAC_7_slave_end_xfer <= NOT ((iobusMAC_7_slave_waits_for_read OR iobusMAC_7_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_iobusMAC_7_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_iobusMAC_7_slave <= iobusMAC_7_slave_end_xfer AND (((NOT iobusMAC_7_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --iobusMAC_7_slave_arb_share_counter arbitration counter enable, which is an e_assign
  iobusMAC_7_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_iobusMAC_7_slave AND iobusMAC_7_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_iobusMAC_7_slave AND NOT iobusMAC_7_slave_non_bursting_master_requests));
  --iobusMAC_7_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_7_slave_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMAC_7_slave_arb_counter_enable) = '1' then 
        iobusMAC_7_slave_arb_share_counter <= iobusMAC_7_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --iobusMAC_7_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_7_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((iobusMAC_7_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_iobusMAC_7_slave)) OR ((end_xfer_arb_share_counter_term_iobusMAC_7_slave AND NOT iobusMAC_7_slave_non_bursting_master_requests)))) = '1' then 
        iobusMAC_7_slave_slavearbiterlockenable <= iobusMAC_7_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master iobusMAC_7/slave arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= iobusMAC_7_slave_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --iobusMAC_7_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  iobusMAC_7_slave_slavearbiterlockenable2 <= iobusMAC_7_slave_arb_share_counter_next_value;
  --cpu/data_master iobusMAC_7/slave arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= iobusMAC_7_slave_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --iobusMAC_7_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  iobusMAC_7_slave_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_iobusMAC_7_slave <= internal_cpu_data_master_requests_iobusMAC_7_slave AND NOT ((((cpu_data_master_read AND ((NOT cpu_data_master_waitrequest OR (internal_cpu_data_master_read_data_valid_iobusMAC_7_slave_shift_register))))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))));
  --unique name for iobusMAC_7_slave_move_on_to_next_transaction, which is an e_assign
  iobusMAC_7_slave_move_on_to_next_transaction <= iobusMAC_7_slave_readdatavalid_from_sa;
  --rdv_fifo_for_cpu_data_master_to_iobusMAC_7_slave, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_data_master_to_iobusMAC_7_slave : rdv_fifo_for_cpu_data_master_to_iobusMAC_7_slave_module
    port map(
      data_out => cpu_data_master_rdv_fifo_output_from_iobusMAC_7_slave,
      empty => open,
      fifo_contains_ones_n => cpu_data_master_rdv_fifo_empty_iobusMAC_7_slave,
      full => open,
      clear_fifo => module_input21,
      clk => clk,
      data_in => internal_cpu_data_master_granted_iobusMAC_7_slave,
      read => iobusMAC_7_slave_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input22,
      write => module_input23
    );

  module_input21 <= std_logic'('0');
  module_input22 <= std_logic'('0');
  module_input23 <= in_a_read_cycle AND NOT iobusMAC_7_slave_waits_for_read;

  internal_cpu_data_master_read_data_valid_iobusMAC_7_slave_shift_register <= NOT cpu_data_master_rdv_fifo_empty_iobusMAC_7_slave;
  --local readdatavalid cpu_data_master_read_data_valid_iobusMAC_7_slave, which is an e_mux
  cpu_data_master_read_data_valid_iobusMAC_7_slave <= iobusMAC_7_slave_readdatavalid_from_sa;
  --iobusMAC_7_slave_writedata mux, which is an e_mux
  iobusMAC_7_slave_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_iobusMAC_7_slave <= internal_cpu_data_master_qualified_request_iobusMAC_7_slave;
  --cpu/data_master saved-grant iobusMAC_7/slave, which is an e_assign
  cpu_data_master_saved_grant_iobusMAC_7_slave <= internal_cpu_data_master_requests_iobusMAC_7_slave;
  --allow new arb cycle for iobusMAC_7/slave, which is an e_assign
  iobusMAC_7_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  iobusMAC_7_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  iobusMAC_7_slave_master_qreq_vector <= std_logic'('1');
  --~iobusMAC_7_slave_reset assignment, which is an e_assign
  iobusMAC_7_slave_reset <= NOT reset_n;
  --iobusMAC_7_slave_firsttransfer first transaction, which is an e_assign
  iobusMAC_7_slave_firsttransfer <= A_WE_StdLogic((std_logic'(iobusMAC_7_slave_begins_xfer) = '1'), iobusMAC_7_slave_unreg_firsttransfer, iobusMAC_7_slave_reg_firsttransfer);
  --iobusMAC_7_slave_unreg_firsttransfer first transaction, which is an e_assign
  iobusMAC_7_slave_unreg_firsttransfer <= NOT ((iobusMAC_7_slave_slavearbiterlockenable AND iobusMAC_7_slave_any_continuerequest));
  --iobusMAC_7_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMAC_7_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMAC_7_slave_begins_xfer) = '1' then 
        iobusMAC_7_slave_reg_firsttransfer <= iobusMAC_7_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --iobusMAC_7_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  iobusMAC_7_slave_beginbursttransfer_internal <= iobusMAC_7_slave_begins_xfer;
  --iobusMAC_7_slave_read assignment, which is an e_mux
  iobusMAC_7_slave_read <= internal_cpu_data_master_granted_iobusMAC_7_slave AND cpu_data_master_read;
  --iobusMAC_7_slave_write assignment, which is an e_mux
  iobusMAC_7_slave_write <= internal_cpu_data_master_granted_iobusMAC_7_slave AND cpu_data_master_write;
  shifted_address_to_iobusMAC_7_slave_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --iobusMAC_7_slave_address mux, which is an e_mux
  iobusMAC_7_slave_address <= A_EXT (A_SRL(shifted_address_to_iobusMAC_7_slave_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 4);
  --d1_iobusMAC_7_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_iobusMAC_7_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_iobusMAC_7_slave_end_xfer <= iobusMAC_7_slave_end_xfer;
    end if;

  end process;

  --iobusMAC_7_slave_waits_for_read in a cycle, which is an e_mux
  iobusMAC_7_slave_waits_for_read <= iobusMAC_7_slave_in_a_read_cycle AND internal_iobusMAC_7_slave_waitrequest_from_sa;
  --iobusMAC_7_slave_in_a_read_cycle assignment, which is an e_assign
  iobusMAC_7_slave_in_a_read_cycle <= internal_cpu_data_master_granted_iobusMAC_7_slave AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= iobusMAC_7_slave_in_a_read_cycle;
  --iobusMAC_7_slave_waits_for_write in a cycle, which is an e_mux
  iobusMAC_7_slave_waits_for_write <= iobusMAC_7_slave_in_a_write_cycle AND internal_iobusMAC_7_slave_waitrequest_from_sa;
  --iobusMAC_7_slave_in_a_write_cycle assignment, which is an e_assign
  iobusMAC_7_slave_in_a_write_cycle <= internal_cpu_data_master_granted_iobusMAC_7_slave AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= iobusMAC_7_slave_in_a_write_cycle;
  wait_for_iobusMAC_7_slave_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_iobusMAC_7_slave <= internal_cpu_data_master_granted_iobusMAC_7_slave;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_iobusMAC_7_slave <= internal_cpu_data_master_qualified_request_iobusMAC_7_slave;
  --vhdl renameroo for output signals
  cpu_data_master_read_data_valid_iobusMAC_7_slave_shift_register <= internal_cpu_data_master_read_data_valid_iobusMAC_7_slave_shift_register;
  --vhdl renameroo for output signals
  cpu_data_master_requests_iobusMAC_7_slave <= internal_cpu_data_master_requests_iobusMAC_7_slave;
  --vhdl renameroo for output signals
  iobusMAC_7_slave_waitrequest_from_sa <= internal_iobusMAC_7_slave_waitrequest_from_sa;
--synthesis translate_off
    --iobusMAC_7/slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rdv_fifo_for_cpu_data_master_to_iobusMDIO_0_slave_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_data_master_to_iobusMDIO_0_slave_module;


architecture europa of rdv_fifo_for_cpu_data_master_to_iobusMDIO_0_slave_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (1 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_0;
  empty <= NOT(full_0);
  full_1 <= std_logic'('0');
  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 2);
  one_count_minus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 2);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("000000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 2);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity iobusMDIO_0_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_0_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_0_slave_readdatavalid : IN STD_LOGIC;
                 signal iobusMDIO_0_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_iobusMDIO_0_slave : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMDIO_0_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_0_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_0_slave_shift_register : OUT STD_LOGIC;
                 signal cpu_data_master_requests_iobusMDIO_0_slave : OUT STD_LOGIC;
                 signal d1_iobusMDIO_0_slave_end_xfer : OUT STD_LOGIC;
                 signal iobusMDIO_0_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal iobusMDIO_0_slave_read : OUT STD_LOGIC;
                 signal iobusMDIO_0_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_0_slave_reset : OUT STD_LOGIC;
                 signal iobusMDIO_0_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal iobusMDIO_0_slave_write : OUT STD_LOGIC;
                 signal iobusMDIO_0_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity iobusMDIO_0_slave_arbitrator;


architecture europa of iobusMDIO_0_slave_arbitrator is
component rdv_fifo_for_cpu_data_master_to_iobusMDIO_0_slave_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_data_master_to_iobusMDIO_0_slave_module;

                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_empty_iobusMDIO_0_slave :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_output_from_iobusMDIO_0_slave :  STD_LOGIC;
                signal cpu_data_master_saved_grant_iobusMDIO_0_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_iobusMDIO_0_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_iobusMDIO_0_slave :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_iobusMDIO_0_slave :  STD_LOGIC;
                signal internal_cpu_data_master_read_data_valid_iobusMDIO_0_slave_shift_register :  STD_LOGIC;
                signal internal_cpu_data_master_requests_iobusMDIO_0_slave :  STD_LOGIC;
                signal internal_iobusMDIO_0_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMDIO_0_slave_allgrants :  STD_LOGIC;
                signal iobusMDIO_0_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal iobusMDIO_0_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal iobusMDIO_0_slave_any_continuerequest :  STD_LOGIC;
                signal iobusMDIO_0_slave_arb_counter_enable :  STD_LOGIC;
                signal iobusMDIO_0_slave_arb_share_counter :  STD_LOGIC;
                signal iobusMDIO_0_slave_arb_share_counter_next_value :  STD_LOGIC;
                signal iobusMDIO_0_slave_arb_share_set_values :  STD_LOGIC;
                signal iobusMDIO_0_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal iobusMDIO_0_slave_begins_xfer :  STD_LOGIC;
                signal iobusMDIO_0_slave_end_xfer :  STD_LOGIC;
                signal iobusMDIO_0_slave_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_0_slave_grant_vector :  STD_LOGIC;
                signal iobusMDIO_0_slave_in_a_read_cycle :  STD_LOGIC;
                signal iobusMDIO_0_slave_in_a_write_cycle :  STD_LOGIC;
                signal iobusMDIO_0_slave_master_qreq_vector :  STD_LOGIC;
                signal iobusMDIO_0_slave_move_on_to_next_transaction :  STD_LOGIC;
                signal iobusMDIO_0_slave_non_bursting_master_requests :  STD_LOGIC;
                signal iobusMDIO_0_slave_readdatavalid_from_sa :  STD_LOGIC;
                signal iobusMDIO_0_slave_reg_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_0_slave_slavearbiterlockenable :  STD_LOGIC;
                signal iobusMDIO_0_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal iobusMDIO_0_slave_unreg_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_0_slave_waits_for_read :  STD_LOGIC;
                signal iobusMDIO_0_slave_waits_for_write :  STD_LOGIC;
                signal module_input24 :  STD_LOGIC;
                signal module_input25 :  STD_LOGIC;
                signal module_input26 :  STD_LOGIC;
                signal shifted_address_to_iobusMDIO_0_slave_from_cpu_data_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal wait_for_iobusMDIO_0_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT iobusMDIO_0_slave_end_xfer;
    end if;

  end process;

  iobusMDIO_0_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_iobusMDIO_0_slave);
  --assign iobusMDIO_0_slave_readdata_from_sa = iobusMDIO_0_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMDIO_0_slave_readdata_from_sa <= iobusMDIO_0_slave_readdata;
  internal_cpu_data_master_requests_iobusMDIO_0_slave <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(13 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("00101100000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign iobusMDIO_0_slave_waitrequest_from_sa = iobusMDIO_0_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_iobusMDIO_0_slave_waitrequest_from_sa <= iobusMDIO_0_slave_waitrequest;
  --assign iobusMDIO_0_slave_readdatavalid_from_sa = iobusMDIO_0_slave_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMDIO_0_slave_readdatavalid_from_sa <= iobusMDIO_0_slave_readdatavalid;
  --iobusMDIO_0_slave_arb_share_counter set values, which is an e_mux
  iobusMDIO_0_slave_arb_share_set_values <= std_logic'('1');
  --iobusMDIO_0_slave_non_bursting_master_requests mux, which is an e_mux
  iobusMDIO_0_slave_non_bursting_master_requests <= internal_cpu_data_master_requests_iobusMDIO_0_slave;
  --iobusMDIO_0_slave_any_bursting_master_saved_grant mux, which is an e_mux
  iobusMDIO_0_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --iobusMDIO_0_slave_arb_share_counter_next_value assignment, which is an e_assign
  iobusMDIO_0_slave_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(iobusMDIO_0_slave_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMDIO_0_slave_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(iobusMDIO_0_slave_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMDIO_0_slave_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --iobusMDIO_0_slave_allgrants all slave grants, which is an e_mux
  iobusMDIO_0_slave_allgrants <= iobusMDIO_0_slave_grant_vector;
  --iobusMDIO_0_slave_end_xfer assignment, which is an e_assign
  iobusMDIO_0_slave_end_xfer <= NOT ((iobusMDIO_0_slave_waits_for_read OR iobusMDIO_0_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_iobusMDIO_0_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_iobusMDIO_0_slave <= iobusMDIO_0_slave_end_xfer AND (((NOT iobusMDIO_0_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --iobusMDIO_0_slave_arb_share_counter arbitration counter enable, which is an e_assign
  iobusMDIO_0_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_iobusMDIO_0_slave AND iobusMDIO_0_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_iobusMDIO_0_slave AND NOT iobusMDIO_0_slave_non_bursting_master_requests));
  --iobusMDIO_0_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_0_slave_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMDIO_0_slave_arb_counter_enable) = '1' then 
        iobusMDIO_0_slave_arb_share_counter <= iobusMDIO_0_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --iobusMDIO_0_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_0_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((iobusMDIO_0_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_iobusMDIO_0_slave)) OR ((end_xfer_arb_share_counter_term_iobusMDIO_0_slave AND NOT iobusMDIO_0_slave_non_bursting_master_requests)))) = '1' then 
        iobusMDIO_0_slave_slavearbiterlockenable <= iobusMDIO_0_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master iobusMDIO_0/slave arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= iobusMDIO_0_slave_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --iobusMDIO_0_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  iobusMDIO_0_slave_slavearbiterlockenable2 <= iobusMDIO_0_slave_arb_share_counter_next_value;
  --cpu/data_master iobusMDIO_0/slave arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= iobusMDIO_0_slave_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --iobusMDIO_0_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  iobusMDIO_0_slave_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_iobusMDIO_0_slave <= internal_cpu_data_master_requests_iobusMDIO_0_slave AND NOT ((((cpu_data_master_read AND ((NOT cpu_data_master_waitrequest OR (internal_cpu_data_master_read_data_valid_iobusMDIO_0_slave_shift_register))))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))));
  --unique name for iobusMDIO_0_slave_move_on_to_next_transaction, which is an e_assign
  iobusMDIO_0_slave_move_on_to_next_transaction <= iobusMDIO_0_slave_readdatavalid_from_sa;
  --rdv_fifo_for_cpu_data_master_to_iobusMDIO_0_slave, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_data_master_to_iobusMDIO_0_slave : rdv_fifo_for_cpu_data_master_to_iobusMDIO_0_slave_module
    port map(
      data_out => cpu_data_master_rdv_fifo_output_from_iobusMDIO_0_slave,
      empty => open,
      fifo_contains_ones_n => cpu_data_master_rdv_fifo_empty_iobusMDIO_0_slave,
      full => open,
      clear_fifo => module_input24,
      clk => clk,
      data_in => internal_cpu_data_master_granted_iobusMDIO_0_slave,
      read => iobusMDIO_0_slave_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input25,
      write => module_input26
    );

  module_input24 <= std_logic'('0');
  module_input25 <= std_logic'('0');
  module_input26 <= in_a_read_cycle AND NOT iobusMDIO_0_slave_waits_for_read;

  internal_cpu_data_master_read_data_valid_iobusMDIO_0_slave_shift_register <= NOT cpu_data_master_rdv_fifo_empty_iobusMDIO_0_slave;
  --local readdatavalid cpu_data_master_read_data_valid_iobusMDIO_0_slave, which is an e_mux
  cpu_data_master_read_data_valid_iobusMDIO_0_slave <= iobusMDIO_0_slave_readdatavalid_from_sa;
  --iobusMDIO_0_slave_writedata mux, which is an e_mux
  iobusMDIO_0_slave_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_iobusMDIO_0_slave <= internal_cpu_data_master_qualified_request_iobusMDIO_0_slave;
  --cpu/data_master saved-grant iobusMDIO_0/slave, which is an e_assign
  cpu_data_master_saved_grant_iobusMDIO_0_slave <= internal_cpu_data_master_requests_iobusMDIO_0_slave;
  --allow new arb cycle for iobusMDIO_0/slave, which is an e_assign
  iobusMDIO_0_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  iobusMDIO_0_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  iobusMDIO_0_slave_master_qreq_vector <= std_logic'('1');
  --~iobusMDIO_0_slave_reset assignment, which is an e_assign
  iobusMDIO_0_slave_reset <= NOT reset_n;
  --iobusMDIO_0_slave_firsttransfer first transaction, which is an e_assign
  iobusMDIO_0_slave_firsttransfer <= A_WE_StdLogic((std_logic'(iobusMDIO_0_slave_begins_xfer) = '1'), iobusMDIO_0_slave_unreg_firsttransfer, iobusMDIO_0_slave_reg_firsttransfer);
  --iobusMDIO_0_slave_unreg_firsttransfer first transaction, which is an e_assign
  iobusMDIO_0_slave_unreg_firsttransfer <= NOT ((iobusMDIO_0_slave_slavearbiterlockenable AND iobusMDIO_0_slave_any_continuerequest));
  --iobusMDIO_0_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_0_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMDIO_0_slave_begins_xfer) = '1' then 
        iobusMDIO_0_slave_reg_firsttransfer <= iobusMDIO_0_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --iobusMDIO_0_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  iobusMDIO_0_slave_beginbursttransfer_internal <= iobusMDIO_0_slave_begins_xfer;
  --iobusMDIO_0_slave_read assignment, which is an e_mux
  iobusMDIO_0_slave_read <= internal_cpu_data_master_granted_iobusMDIO_0_slave AND cpu_data_master_read;
  --iobusMDIO_0_slave_write assignment, which is an e_mux
  iobusMDIO_0_slave_write <= internal_cpu_data_master_granted_iobusMDIO_0_slave AND cpu_data_master_write;
  shifted_address_to_iobusMDIO_0_slave_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --iobusMDIO_0_slave_address mux, which is an e_mux
  iobusMDIO_0_slave_address <= A_EXT (A_SRL(shifted_address_to_iobusMDIO_0_slave_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_iobusMDIO_0_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_iobusMDIO_0_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_iobusMDIO_0_slave_end_xfer <= iobusMDIO_0_slave_end_xfer;
    end if;

  end process;

  --iobusMDIO_0_slave_waits_for_read in a cycle, which is an e_mux
  iobusMDIO_0_slave_waits_for_read <= iobusMDIO_0_slave_in_a_read_cycle AND internal_iobusMDIO_0_slave_waitrequest_from_sa;
  --iobusMDIO_0_slave_in_a_read_cycle assignment, which is an e_assign
  iobusMDIO_0_slave_in_a_read_cycle <= internal_cpu_data_master_granted_iobusMDIO_0_slave AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= iobusMDIO_0_slave_in_a_read_cycle;
  --iobusMDIO_0_slave_waits_for_write in a cycle, which is an e_mux
  iobusMDIO_0_slave_waits_for_write <= iobusMDIO_0_slave_in_a_write_cycle AND internal_iobusMDIO_0_slave_waitrequest_from_sa;
  --iobusMDIO_0_slave_in_a_write_cycle assignment, which is an e_assign
  iobusMDIO_0_slave_in_a_write_cycle <= internal_cpu_data_master_granted_iobusMDIO_0_slave AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= iobusMDIO_0_slave_in_a_write_cycle;
  wait_for_iobusMDIO_0_slave_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_iobusMDIO_0_slave <= internal_cpu_data_master_granted_iobusMDIO_0_slave;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_iobusMDIO_0_slave <= internal_cpu_data_master_qualified_request_iobusMDIO_0_slave;
  --vhdl renameroo for output signals
  cpu_data_master_read_data_valid_iobusMDIO_0_slave_shift_register <= internal_cpu_data_master_read_data_valid_iobusMDIO_0_slave_shift_register;
  --vhdl renameroo for output signals
  cpu_data_master_requests_iobusMDIO_0_slave <= internal_cpu_data_master_requests_iobusMDIO_0_slave;
  --vhdl renameroo for output signals
  iobusMDIO_0_slave_waitrequest_from_sa <= internal_iobusMDIO_0_slave_waitrequest_from_sa;
--synthesis translate_off
    --iobusMDIO_0/slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rdv_fifo_for_cpu_data_master_to_iobusMDIO_1_slave_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_data_master_to_iobusMDIO_1_slave_module;


architecture europa of rdv_fifo_for_cpu_data_master_to_iobusMDIO_1_slave_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (1 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_0;
  empty <= NOT(full_0);
  full_1 <= std_logic'('0');
  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 2);
  one_count_minus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 2);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("000000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 2);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity iobusMDIO_1_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_1_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_1_slave_readdatavalid : IN STD_LOGIC;
                 signal iobusMDIO_1_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_iobusMDIO_1_slave : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMDIO_1_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_1_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_1_slave_shift_register : OUT STD_LOGIC;
                 signal cpu_data_master_requests_iobusMDIO_1_slave : OUT STD_LOGIC;
                 signal d1_iobusMDIO_1_slave_end_xfer : OUT STD_LOGIC;
                 signal iobusMDIO_1_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal iobusMDIO_1_slave_read : OUT STD_LOGIC;
                 signal iobusMDIO_1_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_1_slave_reset : OUT STD_LOGIC;
                 signal iobusMDIO_1_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal iobusMDIO_1_slave_write : OUT STD_LOGIC;
                 signal iobusMDIO_1_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity iobusMDIO_1_slave_arbitrator;


architecture europa of iobusMDIO_1_slave_arbitrator is
component rdv_fifo_for_cpu_data_master_to_iobusMDIO_1_slave_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_data_master_to_iobusMDIO_1_slave_module;

                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_empty_iobusMDIO_1_slave :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_output_from_iobusMDIO_1_slave :  STD_LOGIC;
                signal cpu_data_master_saved_grant_iobusMDIO_1_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_iobusMDIO_1_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_iobusMDIO_1_slave :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_iobusMDIO_1_slave :  STD_LOGIC;
                signal internal_cpu_data_master_read_data_valid_iobusMDIO_1_slave_shift_register :  STD_LOGIC;
                signal internal_cpu_data_master_requests_iobusMDIO_1_slave :  STD_LOGIC;
                signal internal_iobusMDIO_1_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMDIO_1_slave_allgrants :  STD_LOGIC;
                signal iobusMDIO_1_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal iobusMDIO_1_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal iobusMDIO_1_slave_any_continuerequest :  STD_LOGIC;
                signal iobusMDIO_1_slave_arb_counter_enable :  STD_LOGIC;
                signal iobusMDIO_1_slave_arb_share_counter :  STD_LOGIC;
                signal iobusMDIO_1_slave_arb_share_counter_next_value :  STD_LOGIC;
                signal iobusMDIO_1_slave_arb_share_set_values :  STD_LOGIC;
                signal iobusMDIO_1_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal iobusMDIO_1_slave_begins_xfer :  STD_LOGIC;
                signal iobusMDIO_1_slave_end_xfer :  STD_LOGIC;
                signal iobusMDIO_1_slave_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_1_slave_grant_vector :  STD_LOGIC;
                signal iobusMDIO_1_slave_in_a_read_cycle :  STD_LOGIC;
                signal iobusMDIO_1_slave_in_a_write_cycle :  STD_LOGIC;
                signal iobusMDIO_1_slave_master_qreq_vector :  STD_LOGIC;
                signal iobusMDIO_1_slave_move_on_to_next_transaction :  STD_LOGIC;
                signal iobusMDIO_1_slave_non_bursting_master_requests :  STD_LOGIC;
                signal iobusMDIO_1_slave_readdatavalid_from_sa :  STD_LOGIC;
                signal iobusMDIO_1_slave_reg_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_1_slave_slavearbiterlockenable :  STD_LOGIC;
                signal iobusMDIO_1_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal iobusMDIO_1_slave_unreg_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_1_slave_waits_for_read :  STD_LOGIC;
                signal iobusMDIO_1_slave_waits_for_write :  STD_LOGIC;
                signal module_input27 :  STD_LOGIC;
                signal module_input28 :  STD_LOGIC;
                signal module_input29 :  STD_LOGIC;
                signal shifted_address_to_iobusMDIO_1_slave_from_cpu_data_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal wait_for_iobusMDIO_1_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT iobusMDIO_1_slave_end_xfer;
    end if;

  end process;

  iobusMDIO_1_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_iobusMDIO_1_slave);
  --assign iobusMDIO_1_slave_readdata_from_sa = iobusMDIO_1_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMDIO_1_slave_readdata_from_sa <= iobusMDIO_1_slave_readdata;
  internal_cpu_data_master_requests_iobusMDIO_1_slave <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(13 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("00101100010000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign iobusMDIO_1_slave_waitrequest_from_sa = iobusMDIO_1_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_iobusMDIO_1_slave_waitrequest_from_sa <= iobusMDIO_1_slave_waitrequest;
  --assign iobusMDIO_1_slave_readdatavalid_from_sa = iobusMDIO_1_slave_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMDIO_1_slave_readdatavalid_from_sa <= iobusMDIO_1_slave_readdatavalid;
  --iobusMDIO_1_slave_arb_share_counter set values, which is an e_mux
  iobusMDIO_1_slave_arb_share_set_values <= std_logic'('1');
  --iobusMDIO_1_slave_non_bursting_master_requests mux, which is an e_mux
  iobusMDIO_1_slave_non_bursting_master_requests <= internal_cpu_data_master_requests_iobusMDIO_1_slave;
  --iobusMDIO_1_slave_any_bursting_master_saved_grant mux, which is an e_mux
  iobusMDIO_1_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --iobusMDIO_1_slave_arb_share_counter_next_value assignment, which is an e_assign
  iobusMDIO_1_slave_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(iobusMDIO_1_slave_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMDIO_1_slave_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(iobusMDIO_1_slave_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMDIO_1_slave_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --iobusMDIO_1_slave_allgrants all slave grants, which is an e_mux
  iobusMDIO_1_slave_allgrants <= iobusMDIO_1_slave_grant_vector;
  --iobusMDIO_1_slave_end_xfer assignment, which is an e_assign
  iobusMDIO_1_slave_end_xfer <= NOT ((iobusMDIO_1_slave_waits_for_read OR iobusMDIO_1_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_iobusMDIO_1_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_iobusMDIO_1_slave <= iobusMDIO_1_slave_end_xfer AND (((NOT iobusMDIO_1_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --iobusMDIO_1_slave_arb_share_counter arbitration counter enable, which is an e_assign
  iobusMDIO_1_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_iobusMDIO_1_slave AND iobusMDIO_1_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_iobusMDIO_1_slave AND NOT iobusMDIO_1_slave_non_bursting_master_requests));
  --iobusMDIO_1_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_1_slave_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMDIO_1_slave_arb_counter_enable) = '1' then 
        iobusMDIO_1_slave_arb_share_counter <= iobusMDIO_1_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --iobusMDIO_1_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_1_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((iobusMDIO_1_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_iobusMDIO_1_slave)) OR ((end_xfer_arb_share_counter_term_iobusMDIO_1_slave AND NOT iobusMDIO_1_slave_non_bursting_master_requests)))) = '1' then 
        iobusMDIO_1_slave_slavearbiterlockenable <= iobusMDIO_1_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master iobusMDIO_1/slave arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= iobusMDIO_1_slave_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --iobusMDIO_1_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  iobusMDIO_1_slave_slavearbiterlockenable2 <= iobusMDIO_1_slave_arb_share_counter_next_value;
  --cpu/data_master iobusMDIO_1/slave arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= iobusMDIO_1_slave_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --iobusMDIO_1_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  iobusMDIO_1_slave_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_iobusMDIO_1_slave <= internal_cpu_data_master_requests_iobusMDIO_1_slave AND NOT ((((cpu_data_master_read AND ((NOT cpu_data_master_waitrequest OR (internal_cpu_data_master_read_data_valid_iobusMDIO_1_slave_shift_register))))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))));
  --unique name for iobusMDIO_1_slave_move_on_to_next_transaction, which is an e_assign
  iobusMDIO_1_slave_move_on_to_next_transaction <= iobusMDIO_1_slave_readdatavalid_from_sa;
  --rdv_fifo_for_cpu_data_master_to_iobusMDIO_1_slave, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_data_master_to_iobusMDIO_1_slave : rdv_fifo_for_cpu_data_master_to_iobusMDIO_1_slave_module
    port map(
      data_out => cpu_data_master_rdv_fifo_output_from_iobusMDIO_1_slave,
      empty => open,
      fifo_contains_ones_n => cpu_data_master_rdv_fifo_empty_iobusMDIO_1_slave,
      full => open,
      clear_fifo => module_input27,
      clk => clk,
      data_in => internal_cpu_data_master_granted_iobusMDIO_1_slave,
      read => iobusMDIO_1_slave_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input28,
      write => module_input29
    );

  module_input27 <= std_logic'('0');
  module_input28 <= std_logic'('0');
  module_input29 <= in_a_read_cycle AND NOT iobusMDIO_1_slave_waits_for_read;

  internal_cpu_data_master_read_data_valid_iobusMDIO_1_slave_shift_register <= NOT cpu_data_master_rdv_fifo_empty_iobusMDIO_1_slave;
  --local readdatavalid cpu_data_master_read_data_valid_iobusMDIO_1_slave, which is an e_mux
  cpu_data_master_read_data_valid_iobusMDIO_1_slave <= iobusMDIO_1_slave_readdatavalid_from_sa;
  --iobusMDIO_1_slave_writedata mux, which is an e_mux
  iobusMDIO_1_slave_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_iobusMDIO_1_slave <= internal_cpu_data_master_qualified_request_iobusMDIO_1_slave;
  --cpu/data_master saved-grant iobusMDIO_1/slave, which is an e_assign
  cpu_data_master_saved_grant_iobusMDIO_1_slave <= internal_cpu_data_master_requests_iobusMDIO_1_slave;
  --allow new arb cycle for iobusMDIO_1/slave, which is an e_assign
  iobusMDIO_1_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  iobusMDIO_1_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  iobusMDIO_1_slave_master_qreq_vector <= std_logic'('1');
  --~iobusMDIO_1_slave_reset assignment, which is an e_assign
  iobusMDIO_1_slave_reset <= NOT reset_n;
  --iobusMDIO_1_slave_firsttransfer first transaction, which is an e_assign
  iobusMDIO_1_slave_firsttransfer <= A_WE_StdLogic((std_logic'(iobusMDIO_1_slave_begins_xfer) = '1'), iobusMDIO_1_slave_unreg_firsttransfer, iobusMDIO_1_slave_reg_firsttransfer);
  --iobusMDIO_1_slave_unreg_firsttransfer first transaction, which is an e_assign
  iobusMDIO_1_slave_unreg_firsttransfer <= NOT ((iobusMDIO_1_slave_slavearbiterlockenable AND iobusMDIO_1_slave_any_continuerequest));
  --iobusMDIO_1_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_1_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMDIO_1_slave_begins_xfer) = '1' then 
        iobusMDIO_1_slave_reg_firsttransfer <= iobusMDIO_1_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --iobusMDIO_1_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  iobusMDIO_1_slave_beginbursttransfer_internal <= iobusMDIO_1_slave_begins_xfer;
  --iobusMDIO_1_slave_read assignment, which is an e_mux
  iobusMDIO_1_slave_read <= internal_cpu_data_master_granted_iobusMDIO_1_slave AND cpu_data_master_read;
  --iobusMDIO_1_slave_write assignment, which is an e_mux
  iobusMDIO_1_slave_write <= internal_cpu_data_master_granted_iobusMDIO_1_slave AND cpu_data_master_write;
  shifted_address_to_iobusMDIO_1_slave_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --iobusMDIO_1_slave_address mux, which is an e_mux
  iobusMDIO_1_slave_address <= A_EXT (A_SRL(shifted_address_to_iobusMDIO_1_slave_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_iobusMDIO_1_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_iobusMDIO_1_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_iobusMDIO_1_slave_end_xfer <= iobusMDIO_1_slave_end_xfer;
    end if;

  end process;

  --iobusMDIO_1_slave_waits_for_read in a cycle, which is an e_mux
  iobusMDIO_1_slave_waits_for_read <= iobusMDIO_1_slave_in_a_read_cycle AND internal_iobusMDIO_1_slave_waitrequest_from_sa;
  --iobusMDIO_1_slave_in_a_read_cycle assignment, which is an e_assign
  iobusMDIO_1_slave_in_a_read_cycle <= internal_cpu_data_master_granted_iobusMDIO_1_slave AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= iobusMDIO_1_slave_in_a_read_cycle;
  --iobusMDIO_1_slave_waits_for_write in a cycle, which is an e_mux
  iobusMDIO_1_slave_waits_for_write <= iobusMDIO_1_slave_in_a_write_cycle AND internal_iobusMDIO_1_slave_waitrequest_from_sa;
  --iobusMDIO_1_slave_in_a_write_cycle assignment, which is an e_assign
  iobusMDIO_1_slave_in_a_write_cycle <= internal_cpu_data_master_granted_iobusMDIO_1_slave AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= iobusMDIO_1_slave_in_a_write_cycle;
  wait_for_iobusMDIO_1_slave_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_iobusMDIO_1_slave <= internal_cpu_data_master_granted_iobusMDIO_1_slave;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_iobusMDIO_1_slave <= internal_cpu_data_master_qualified_request_iobusMDIO_1_slave;
  --vhdl renameroo for output signals
  cpu_data_master_read_data_valid_iobusMDIO_1_slave_shift_register <= internal_cpu_data_master_read_data_valid_iobusMDIO_1_slave_shift_register;
  --vhdl renameroo for output signals
  cpu_data_master_requests_iobusMDIO_1_slave <= internal_cpu_data_master_requests_iobusMDIO_1_slave;
  --vhdl renameroo for output signals
  iobusMDIO_1_slave_waitrequest_from_sa <= internal_iobusMDIO_1_slave_waitrequest_from_sa;
--synthesis translate_off
    --iobusMDIO_1/slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rdv_fifo_for_cpu_data_master_to_iobusMDIO_2_slave_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_data_master_to_iobusMDIO_2_slave_module;


architecture europa of rdv_fifo_for_cpu_data_master_to_iobusMDIO_2_slave_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (1 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_0;
  empty <= NOT(full_0);
  full_1 <= std_logic'('0');
  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 2);
  one_count_minus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 2);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("000000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 2);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity iobusMDIO_2_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_2_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_2_slave_readdatavalid : IN STD_LOGIC;
                 signal iobusMDIO_2_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_iobusMDIO_2_slave : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMDIO_2_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_2_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_2_slave_shift_register : OUT STD_LOGIC;
                 signal cpu_data_master_requests_iobusMDIO_2_slave : OUT STD_LOGIC;
                 signal d1_iobusMDIO_2_slave_end_xfer : OUT STD_LOGIC;
                 signal iobusMDIO_2_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal iobusMDIO_2_slave_read : OUT STD_LOGIC;
                 signal iobusMDIO_2_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_2_slave_reset : OUT STD_LOGIC;
                 signal iobusMDIO_2_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal iobusMDIO_2_slave_write : OUT STD_LOGIC;
                 signal iobusMDIO_2_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity iobusMDIO_2_slave_arbitrator;


architecture europa of iobusMDIO_2_slave_arbitrator is
component rdv_fifo_for_cpu_data_master_to_iobusMDIO_2_slave_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_data_master_to_iobusMDIO_2_slave_module;

                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_empty_iobusMDIO_2_slave :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_output_from_iobusMDIO_2_slave :  STD_LOGIC;
                signal cpu_data_master_saved_grant_iobusMDIO_2_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_iobusMDIO_2_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_iobusMDIO_2_slave :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_iobusMDIO_2_slave :  STD_LOGIC;
                signal internal_cpu_data_master_read_data_valid_iobusMDIO_2_slave_shift_register :  STD_LOGIC;
                signal internal_cpu_data_master_requests_iobusMDIO_2_slave :  STD_LOGIC;
                signal internal_iobusMDIO_2_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMDIO_2_slave_allgrants :  STD_LOGIC;
                signal iobusMDIO_2_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal iobusMDIO_2_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal iobusMDIO_2_slave_any_continuerequest :  STD_LOGIC;
                signal iobusMDIO_2_slave_arb_counter_enable :  STD_LOGIC;
                signal iobusMDIO_2_slave_arb_share_counter :  STD_LOGIC;
                signal iobusMDIO_2_slave_arb_share_counter_next_value :  STD_LOGIC;
                signal iobusMDIO_2_slave_arb_share_set_values :  STD_LOGIC;
                signal iobusMDIO_2_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal iobusMDIO_2_slave_begins_xfer :  STD_LOGIC;
                signal iobusMDIO_2_slave_end_xfer :  STD_LOGIC;
                signal iobusMDIO_2_slave_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_2_slave_grant_vector :  STD_LOGIC;
                signal iobusMDIO_2_slave_in_a_read_cycle :  STD_LOGIC;
                signal iobusMDIO_2_slave_in_a_write_cycle :  STD_LOGIC;
                signal iobusMDIO_2_slave_master_qreq_vector :  STD_LOGIC;
                signal iobusMDIO_2_slave_move_on_to_next_transaction :  STD_LOGIC;
                signal iobusMDIO_2_slave_non_bursting_master_requests :  STD_LOGIC;
                signal iobusMDIO_2_slave_readdatavalid_from_sa :  STD_LOGIC;
                signal iobusMDIO_2_slave_reg_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_2_slave_slavearbiterlockenable :  STD_LOGIC;
                signal iobusMDIO_2_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal iobusMDIO_2_slave_unreg_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_2_slave_waits_for_read :  STD_LOGIC;
                signal iobusMDIO_2_slave_waits_for_write :  STD_LOGIC;
                signal module_input30 :  STD_LOGIC;
                signal module_input31 :  STD_LOGIC;
                signal module_input32 :  STD_LOGIC;
                signal shifted_address_to_iobusMDIO_2_slave_from_cpu_data_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal wait_for_iobusMDIO_2_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT iobusMDIO_2_slave_end_xfer;
    end if;

  end process;

  iobusMDIO_2_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_iobusMDIO_2_slave);
  --assign iobusMDIO_2_slave_readdata_from_sa = iobusMDIO_2_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMDIO_2_slave_readdata_from_sa <= iobusMDIO_2_slave_readdata;
  internal_cpu_data_master_requests_iobusMDIO_2_slave <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(13 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("00101100100000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign iobusMDIO_2_slave_waitrequest_from_sa = iobusMDIO_2_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_iobusMDIO_2_slave_waitrequest_from_sa <= iobusMDIO_2_slave_waitrequest;
  --assign iobusMDIO_2_slave_readdatavalid_from_sa = iobusMDIO_2_slave_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMDIO_2_slave_readdatavalid_from_sa <= iobusMDIO_2_slave_readdatavalid;
  --iobusMDIO_2_slave_arb_share_counter set values, which is an e_mux
  iobusMDIO_2_slave_arb_share_set_values <= std_logic'('1');
  --iobusMDIO_2_slave_non_bursting_master_requests mux, which is an e_mux
  iobusMDIO_2_slave_non_bursting_master_requests <= internal_cpu_data_master_requests_iobusMDIO_2_slave;
  --iobusMDIO_2_slave_any_bursting_master_saved_grant mux, which is an e_mux
  iobusMDIO_2_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --iobusMDIO_2_slave_arb_share_counter_next_value assignment, which is an e_assign
  iobusMDIO_2_slave_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(iobusMDIO_2_slave_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMDIO_2_slave_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(iobusMDIO_2_slave_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMDIO_2_slave_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --iobusMDIO_2_slave_allgrants all slave grants, which is an e_mux
  iobusMDIO_2_slave_allgrants <= iobusMDIO_2_slave_grant_vector;
  --iobusMDIO_2_slave_end_xfer assignment, which is an e_assign
  iobusMDIO_2_slave_end_xfer <= NOT ((iobusMDIO_2_slave_waits_for_read OR iobusMDIO_2_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_iobusMDIO_2_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_iobusMDIO_2_slave <= iobusMDIO_2_slave_end_xfer AND (((NOT iobusMDIO_2_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --iobusMDIO_2_slave_arb_share_counter arbitration counter enable, which is an e_assign
  iobusMDIO_2_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_iobusMDIO_2_slave AND iobusMDIO_2_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_iobusMDIO_2_slave AND NOT iobusMDIO_2_slave_non_bursting_master_requests));
  --iobusMDIO_2_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_2_slave_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMDIO_2_slave_arb_counter_enable) = '1' then 
        iobusMDIO_2_slave_arb_share_counter <= iobusMDIO_2_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --iobusMDIO_2_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_2_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((iobusMDIO_2_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_iobusMDIO_2_slave)) OR ((end_xfer_arb_share_counter_term_iobusMDIO_2_slave AND NOT iobusMDIO_2_slave_non_bursting_master_requests)))) = '1' then 
        iobusMDIO_2_slave_slavearbiterlockenable <= iobusMDIO_2_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master iobusMDIO_2/slave arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= iobusMDIO_2_slave_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --iobusMDIO_2_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  iobusMDIO_2_slave_slavearbiterlockenable2 <= iobusMDIO_2_slave_arb_share_counter_next_value;
  --cpu/data_master iobusMDIO_2/slave arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= iobusMDIO_2_slave_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --iobusMDIO_2_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  iobusMDIO_2_slave_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_iobusMDIO_2_slave <= internal_cpu_data_master_requests_iobusMDIO_2_slave AND NOT ((((cpu_data_master_read AND ((NOT cpu_data_master_waitrequest OR (internal_cpu_data_master_read_data_valid_iobusMDIO_2_slave_shift_register))))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))));
  --unique name for iobusMDIO_2_slave_move_on_to_next_transaction, which is an e_assign
  iobusMDIO_2_slave_move_on_to_next_transaction <= iobusMDIO_2_slave_readdatavalid_from_sa;
  --rdv_fifo_for_cpu_data_master_to_iobusMDIO_2_slave, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_data_master_to_iobusMDIO_2_slave : rdv_fifo_for_cpu_data_master_to_iobusMDIO_2_slave_module
    port map(
      data_out => cpu_data_master_rdv_fifo_output_from_iobusMDIO_2_slave,
      empty => open,
      fifo_contains_ones_n => cpu_data_master_rdv_fifo_empty_iobusMDIO_2_slave,
      full => open,
      clear_fifo => module_input30,
      clk => clk,
      data_in => internal_cpu_data_master_granted_iobusMDIO_2_slave,
      read => iobusMDIO_2_slave_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input31,
      write => module_input32
    );

  module_input30 <= std_logic'('0');
  module_input31 <= std_logic'('0');
  module_input32 <= in_a_read_cycle AND NOT iobusMDIO_2_slave_waits_for_read;

  internal_cpu_data_master_read_data_valid_iobusMDIO_2_slave_shift_register <= NOT cpu_data_master_rdv_fifo_empty_iobusMDIO_2_slave;
  --local readdatavalid cpu_data_master_read_data_valid_iobusMDIO_2_slave, which is an e_mux
  cpu_data_master_read_data_valid_iobusMDIO_2_slave <= iobusMDIO_2_slave_readdatavalid_from_sa;
  --iobusMDIO_2_slave_writedata mux, which is an e_mux
  iobusMDIO_2_slave_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_iobusMDIO_2_slave <= internal_cpu_data_master_qualified_request_iobusMDIO_2_slave;
  --cpu/data_master saved-grant iobusMDIO_2/slave, which is an e_assign
  cpu_data_master_saved_grant_iobusMDIO_2_slave <= internal_cpu_data_master_requests_iobusMDIO_2_slave;
  --allow new arb cycle for iobusMDIO_2/slave, which is an e_assign
  iobusMDIO_2_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  iobusMDIO_2_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  iobusMDIO_2_slave_master_qreq_vector <= std_logic'('1');
  --~iobusMDIO_2_slave_reset assignment, which is an e_assign
  iobusMDIO_2_slave_reset <= NOT reset_n;
  --iobusMDIO_2_slave_firsttransfer first transaction, which is an e_assign
  iobusMDIO_2_slave_firsttransfer <= A_WE_StdLogic((std_logic'(iobusMDIO_2_slave_begins_xfer) = '1'), iobusMDIO_2_slave_unreg_firsttransfer, iobusMDIO_2_slave_reg_firsttransfer);
  --iobusMDIO_2_slave_unreg_firsttransfer first transaction, which is an e_assign
  iobusMDIO_2_slave_unreg_firsttransfer <= NOT ((iobusMDIO_2_slave_slavearbiterlockenable AND iobusMDIO_2_slave_any_continuerequest));
  --iobusMDIO_2_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_2_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMDIO_2_slave_begins_xfer) = '1' then 
        iobusMDIO_2_slave_reg_firsttransfer <= iobusMDIO_2_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --iobusMDIO_2_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  iobusMDIO_2_slave_beginbursttransfer_internal <= iobusMDIO_2_slave_begins_xfer;
  --iobusMDIO_2_slave_read assignment, which is an e_mux
  iobusMDIO_2_slave_read <= internal_cpu_data_master_granted_iobusMDIO_2_slave AND cpu_data_master_read;
  --iobusMDIO_2_slave_write assignment, which is an e_mux
  iobusMDIO_2_slave_write <= internal_cpu_data_master_granted_iobusMDIO_2_slave AND cpu_data_master_write;
  shifted_address_to_iobusMDIO_2_slave_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --iobusMDIO_2_slave_address mux, which is an e_mux
  iobusMDIO_2_slave_address <= A_EXT (A_SRL(shifted_address_to_iobusMDIO_2_slave_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_iobusMDIO_2_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_iobusMDIO_2_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_iobusMDIO_2_slave_end_xfer <= iobusMDIO_2_slave_end_xfer;
    end if;

  end process;

  --iobusMDIO_2_slave_waits_for_read in a cycle, which is an e_mux
  iobusMDIO_2_slave_waits_for_read <= iobusMDIO_2_slave_in_a_read_cycle AND internal_iobusMDIO_2_slave_waitrequest_from_sa;
  --iobusMDIO_2_slave_in_a_read_cycle assignment, which is an e_assign
  iobusMDIO_2_slave_in_a_read_cycle <= internal_cpu_data_master_granted_iobusMDIO_2_slave AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= iobusMDIO_2_slave_in_a_read_cycle;
  --iobusMDIO_2_slave_waits_for_write in a cycle, which is an e_mux
  iobusMDIO_2_slave_waits_for_write <= iobusMDIO_2_slave_in_a_write_cycle AND internal_iobusMDIO_2_slave_waitrequest_from_sa;
  --iobusMDIO_2_slave_in_a_write_cycle assignment, which is an e_assign
  iobusMDIO_2_slave_in_a_write_cycle <= internal_cpu_data_master_granted_iobusMDIO_2_slave AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= iobusMDIO_2_slave_in_a_write_cycle;
  wait_for_iobusMDIO_2_slave_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_iobusMDIO_2_slave <= internal_cpu_data_master_granted_iobusMDIO_2_slave;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_iobusMDIO_2_slave <= internal_cpu_data_master_qualified_request_iobusMDIO_2_slave;
  --vhdl renameroo for output signals
  cpu_data_master_read_data_valid_iobusMDIO_2_slave_shift_register <= internal_cpu_data_master_read_data_valid_iobusMDIO_2_slave_shift_register;
  --vhdl renameroo for output signals
  cpu_data_master_requests_iobusMDIO_2_slave <= internal_cpu_data_master_requests_iobusMDIO_2_slave;
  --vhdl renameroo for output signals
  iobusMDIO_2_slave_waitrequest_from_sa <= internal_iobusMDIO_2_slave_waitrequest_from_sa;
--synthesis translate_off
    --iobusMDIO_2/slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rdv_fifo_for_cpu_data_master_to_iobusMDIO_3_slave_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_data_master_to_iobusMDIO_3_slave_module;


architecture europa of rdv_fifo_for_cpu_data_master_to_iobusMDIO_3_slave_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (1 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_0;
  empty <= NOT(full_0);
  full_1 <= std_logic'('0');
  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 2);
  one_count_minus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 2);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("000000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 2);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity iobusMDIO_3_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_3_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_3_slave_readdatavalid : IN STD_LOGIC;
                 signal iobusMDIO_3_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_iobusMDIO_3_slave : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMDIO_3_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_3_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_3_slave_shift_register : OUT STD_LOGIC;
                 signal cpu_data_master_requests_iobusMDIO_3_slave : OUT STD_LOGIC;
                 signal d1_iobusMDIO_3_slave_end_xfer : OUT STD_LOGIC;
                 signal iobusMDIO_3_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal iobusMDIO_3_slave_read : OUT STD_LOGIC;
                 signal iobusMDIO_3_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_3_slave_reset : OUT STD_LOGIC;
                 signal iobusMDIO_3_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal iobusMDIO_3_slave_write : OUT STD_LOGIC;
                 signal iobusMDIO_3_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity iobusMDIO_3_slave_arbitrator;


architecture europa of iobusMDIO_3_slave_arbitrator is
component rdv_fifo_for_cpu_data_master_to_iobusMDIO_3_slave_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_data_master_to_iobusMDIO_3_slave_module;

                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_empty_iobusMDIO_3_slave :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_output_from_iobusMDIO_3_slave :  STD_LOGIC;
                signal cpu_data_master_saved_grant_iobusMDIO_3_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_iobusMDIO_3_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_iobusMDIO_3_slave :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_iobusMDIO_3_slave :  STD_LOGIC;
                signal internal_cpu_data_master_read_data_valid_iobusMDIO_3_slave_shift_register :  STD_LOGIC;
                signal internal_cpu_data_master_requests_iobusMDIO_3_slave :  STD_LOGIC;
                signal internal_iobusMDIO_3_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMDIO_3_slave_allgrants :  STD_LOGIC;
                signal iobusMDIO_3_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal iobusMDIO_3_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal iobusMDIO_3_slave_any_continuerequest :  STD_LOGIC;
                signal iobusMDIO_3_slave_arb_counter_enable :  STD_LOGIC;
                signal iobusMDIO_3_slave_arb_share_counter :  STD_LOGIC;
                signal iobusMDIO_3_slave_arb_share_counter_next_value :  STD_LOGIC;
                signal iobusMDIO_3_slave_arb_share_set_values :  STD_LOGIC;
                signal iobusMDIO_3_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal iobusMDIO_3_slave_begins_xfer :  STD_LOGIC;
                signal iobusMDIO_3_slave_end_xfer :  STD_LOGIC;
                signal iobusMDIO_3_slave_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_3_slave_grant_vector :  STD_LOGIC;
                signal iobusMDIO_3_slave_in_a_read_cycle :  STD_LOGIC;
                signal iobusMDIO_3_slave_in_a_write_cycle :  STD_LOGIC;
                signal iobusMDIO_3_slave_master_qreq_vector :  STD_LOGIC;
                signal iobusMDIO_3_slave_move_on_to_next_transaction :  STD_LOGIC;
                signal iobusMDIO_3_slave_non_bursting_master_requests :  STD_LOGIC;
                signal iobusMDIO_3_slave_readdatavalid_from_sa :  STD_LOGIC;
                signal iobusMDIO_3_slave_reg_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_3_slave_slavearbiterlockenable :  STD_LOGIC;
                signal iobusMDIO_3_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal iobusMDIO_3_slave_unreg_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_3_slave_waits_for_read :  STD_LOGIC;
                signal iobusMDIO_3_slave_waits_for_write :  STD_LOGIC;
                signal module_input33 :  STD_LOGIC;
                signal module_input34 :  STD_LOGIC;
                signal module_input35 :  STD_LOGIC;
                signal shifted_address_to_iobusMDIO_3_slave_from_cpu_data_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal wait_for_iobusMDIO_3_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT iobusMDIO_3_slave_end_xfer;
    end if;

  end process;

  iobusMDIO_3_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_iobusMDIO_3_slave);
  --assign iobusMDIO_3_slave_readdata_from_sa = iobusMDIO_3_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMDIO_3_slave_readdata_from_sa <= iobusMDIO_3_slave_readdata;
  internal_cpu_data_master_requests_iobusMDIO_3_slave <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(13 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("00101100110000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign iobusMDIO_3_slave_waitrequest_from_sa = iobusMDIO_3_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_iobusMDIO_3_slave_waitrequest_from_sa <= iobusMDIO_3_slave_waitrequest;
  --assign iobusMDIO_3_slave_readdatavalid_from_sa = iobusMDIO_3_slave_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMDIO_3_slave_readdatavalid_from_sa <= iobusMDIO_3_slave_readdatavalid;
  --iobusMDIO_3_slave_arb_share_counter set values, which is an e_mux
  iobusMDIO_3_slave_arb_share_set_values <= std_logic'('1');
  --iobusMDIO_3_slave_non_bursting_master_requests mux, which is an e_mux
  iobusMDIO_3_slave_non_bursting_master_requests <= internal_cpu_data_master_requests_iobusMDIO_3_slave;
  --iobusMDIO_3_slave_any_bursting_master_saved_grant mux, which is an e_mux
  iobusMDIO_3_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --iobusMDIO_3_slave_arb_share_counter_next_value assignment, which is an e_assign
  iobusMDIO_3_slave_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(iobusMDIO_3_slave_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMDIO_3_slave_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(iobusMDIO_3_slave_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMDIO_3_slave_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --iobusMDIO_3_slave_allgrants all slave grants, which is an e_mux
  iobusMDIO_3_slave_allgrants <= iobusMDIO_3_slave_grant_vector;
  --iobusMDIO_3_slave_end_xfer assignment, which is an e_assign
  iobusMDIO_3_slave_end_xfer <= NOT ((iobusMDIO_3_slave_waits_for_read OR iobusMDIO_3_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_iobusMDIO_3_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_iobusMDIO_3_slave <= iobusMDIO_3_slave_end_xfer AND (((NOT iobusMDIO_3_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --iobusMDIO_3_slave_arb_share_counter arbitration counter enable, which is an e_assign
  iobusMDIO_3_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_iobusMDIO_3_slave AND iobusMDIO_3_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_iobusMDIO_3_slave AND NOT iobusMDIO_3_slave_non_bursting_master_requests));
  --iobusMDIO_3_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_3_slave_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMDIO_3_slave_arb_counter_enable) = '1' then 
        iobusMDIO_3_slave_arb_share_counter <= iobusMDIO_3_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --iobusMDIO_3_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_3_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((iobusMDIO_3_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_iobusMDIO_3_slave)) OR ((end_xfer_arb_share_counter_term_iobusMDIO_3_slave AND NOT iobusMDIO_3_slave_non_bursting_master_requests)))) = '1' then 
        iobusMDIO_3_slave_slavearbiterlockenable <= iobusMDIO_3_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master iobusMDIO_3/slave arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= iobusMDIO_3_slave_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --iobusMDIO_3_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  iobusMDIO_3_slave_slavearbiterlockenable2 <= iobusMDIO_3_slave_arb_share_counter_next_value;
  --cpu/data_master iobusMDIO_3/slave arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= iobusMDIO_3_slave_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --iobusMDIO_3_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  iobusMDIO_3_slave_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_iobusMDIO_3_slave <= internal_cpu_data_master_requests_iobusMDIO_3_slave AND NOT ((((cpu_data_master_read AND ((NOT cpu_data_master_waitrequest OR (internal_cpu_data_master_read_data_valid_iobusMDIO_3_slave_shift_register))))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))));
  --unique name for iobusMDIO_3_slave_move_on_to_next_transaction, which is an e_assign
  iobusMDIO_3_slave_move_on_to_next_transaction <= iobusMDIO_3_slave_readdatavalid_from_sa;
  --rdv_fifo_for_cpu_data_master_to_iobusMDIO_3_slave, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_data_master_to_iobusMDIO_3_slave : rdv_fifo_for_cpu_data_master_to_iobusMDIO_3_slave_module
    port map(
      data_out => cpu_data_master_rdv_fifo_output_from_iobusMDIO_3_slave,
      empty => open,
      fifo_contains_ones_n => cpu_data_master_rdv_fifo_empty_iobusMDIO_3_slave,
      full => open,
      clear_fifo => module_input33,
      clk => clk,
      data_in => internal_cpu_data_master_granted_iobusMDIO_3_slave,
      read => iobusMDIO_3_slave_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input34,
      write => module_input35
    );

  module_input33 <= std_logic'('0');
  module_input34 <= std_logic'('0');
  module_input35 <= in_a_read_cycle AND NOT iobusMDIO_3_slave_waits_for_read;

  internal_cpu_data_master_read_data_valid_iobusMDIO_3_slave_shift_register <= NOT cpu_data_master_rdv_fifo_empty_iobusMDIO_3_slave;
  --local readdatavalid cpu_data_master_read_data_valid_iobusMDIO_3_slave, which is an e_mux
  cpu_data_master_read_data_valid_iobusMDIO_3_slave <= iobusMDIO_3_slave_readdatavalid_from_sa;
  --iobusMDIO_3_slave_writedata mux, which is an e_mux
  iobusMDIO_3_slave_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_iobusMDIO_3_slave <= internal_cpu_data_master_qualified_request_iobusMDIO_3_slave;
  --cpu/data_master saved-grant iobusMDIO_3/slave, which is an e_assign
  cpu_data_master_saved_grant_iobusMDIO_3_slave <= internal_cpu_data_master_requests_iobusMDIO_3_slave;
  --allow new arb cycle for iobusMDIO_3/slave, which is an e_assign
  iobusMDIO_3_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  iobusMDIO_3_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  iobusMDIO_3_slave_master_qreq_vector <= std_logic'('1');
  --~iobusMDIO_3_slave_reset assignment, which is an e_assign
  iobusMDIO_3_slave_reset <= NOT reset_n;
  --iobusMDIO_3_slave_firsttransfer first transaction, which is an e_assign
  iobusMDIO_3_slave_firsttransfer <= A_WE_StdLogic((std_logic'(iobusMDIO_3_slave_begins_xfer) = '1'), iobusMDIO_3_slave_unreg_firsttransfer, iobusMDIO_3_slave_reg_firsttransfer);
  --iobusMDIO_3_slave_unreg_firsttransfer first transaction, which is an e_assign
  iobusMDIO_3_slave_unreg_firsttransfer <= NOT ((iobusMDIO_3_slave_slavearbiterlockenable AND iobusMDIO_3_slave_any_continuerequest));
  --iobusMDIO_3_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_3_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMDIO_3_slave_begins_xfer) = '1' then 
        iobusMDIO_3_slave_reg_firsttransfer <= iobusMDIO_3_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --iobusMDIO_3_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  iobusMDIO_3_slave_beginbursttransfer_internal <= iobusMDIO_3_slave_begins_xfer;
  --iobusMDIO_3_slave_read assignment, which is an e_mux
  iobusMDIO_3_slave_read <= internal_cpu_data_master_granted_iobusMDIO_3_slave AND cpu_data_master_read;
  --iobusMDIO_3_slave_write assignment, which is an e_mux
  iobusMDIO_3_slave_write <= internal_cpu_data_master_granted_iobusMDIO_3_slave AND cpu_data_master_write;
  shifted_address_to_iobusMDIO_3_slave_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --iobusMDIO_3_slave_address mux, which is an e_mux
  iobusMDIO_3_slave_address <= A_EXT (A_SRL(shifted_address_to_iobusMDIO_3_slave_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_iobusMDIO_3_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_iobusMDIO_3_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_iobusMDIO_3_slave_end_xfer <= iobusMDIO_3_slave_end_xfer;
    end if;

  end process;

  --iobusMDIO_3_slave_waits_for_read in a cycle, which is an e_mux
  iobusMDIO_3_slave_waits_for_read <= iobusMDIO_3_slave_in_a_read_cycle AND internal_iobusMDIO_3_slave_waitrequest_from_sa;
  --iobusMDIO_3_slave_in_a_read_cycle assignment, which is an e_assign
  iobusMDIO_3_slave_in_a_read_cycle <= internal_cpu_data_master_granted_iobusMDIO_3_slave AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= iobusMDIO_3_slave_in_a_read_cycle;
  --iobusMDIO_3_slave_waits_for_write in a cycle, which is an e_mux
  iobusMDIO_3_slave_waits_for_write <= iobusMDIO_3_slave_in_a_write_cycle AND internal_iobusMDIO_3_slave_waitrequest_from_sa;
  --iobusMDIO_3_slave_in_a_write_cycle assignment, which is an e_assign
  iobusMDIO_3_slave_in_a_write_cycle <= internal_cpu_data_master_granted_iobusMDIO_3_slave AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= iobusMDIO_3_slave_in_a_write_cycle;
  wait_for_iobusMDIO_3_slave_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_iobusMDIO_3_slave <= internal_cpu_data_master_granted_iobusMDIO_3_slave;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_iobusMDIO_3_slave <= internal_cpu_data_master_qualified_request_iobusMDIO_3_slave;
  --vhdl renameroo for output signals
  cpu_data_master_read_data_valid_iobusMDIO_3_slave_shift_register <= internal_cpu_data_master_read_data_valid_iobusMDIO_3_slave_shift_register;
  --vhdl renameroo for output signals
  cpu_data_master_requests_iobusMDIO_3_slave <= internal_cpu_data_master_requests_iobusMDIO_3_slave;
  --vhdl renameroo for output signals
  iobusMDIO_3_slave_waitrequest_from_sa <= internal_iobusMDIO_3_slave_waitrequest_from_sa;
--synthesis translate_off
    --iobusMDIO_3/slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rdv_fifo_for_cpu_data_master_to_iobusMDIO_4_slave_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_data_master_to_iobusMDIO_4_slave_module;


architecture europa of rdv_fifo_for_cpu_data_master_to_iobusMDIO_4_slave_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (1 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_0;
  empty <= NOT(full_0);
  full_1 <= std_logic'('0');
  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 2);
  one_count_minus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 2);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("000000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 2);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity iobusMDIO_4_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_4_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_4_slave_readdatavalid : IN STD_LOGIC;
                 signal iobusMDIO_4_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_iobusMDIO_4_slave : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMDIO_4_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_4_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_4_slave_shift_register : OUT STD_LOGIC;
                 signal cpu_data_master_requests_iobusMDIO_4_slave : OUT STD_LOGIC;
                 signal d1_iobusMDIO_4_slave_end_xfer : OUT STD_LOGIC;
                 signal iobusMDIO_4_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal iobusMDIO_4_slave_read : OUT STD_LOGIC;
                 signal iobusMDIO_4_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_4_slave_reset : OUT STD_LOGIC;
                 signal iobusMDIO_4_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal iobusMDIO_4_slave_write : OUT STD_LOGIC;
                 signal iobusMDIO_4_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity iobusMDIO_4_slave_arbitrator;


architecture europa of iobusMDIO_4_slave_arbitrator is
component rdv_fifo_for_cpu_data_master_to_iobusMDIO_4_slave_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_data_master_to_iobusMDIO_4_slave_module;

                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_empty_iobusMDIO_4_slave :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_output_from_iobusMDIO_4_slave :  STD_LOGIC;
                signal cpu_data_master_saved_grant_iobusMDIO_4_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_iobusMDIO_4_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_iobusMDIO_4_slave :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_iobusMDIO_4_slave :  STD_LOGIC;
                signal internal_cpu_data_master_read_data_valid_iobusMDIO_4_slave_shift_register :  STD_LOGIC;
                signal internal_cpu_data_master_requests_iobusMDIO_4_slave :  STD_LOGIC;
                signal internal_iobusMDIO_4_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMDIO_4_slave_allgrants :  STD_LOGIC;
                signal iobusMDIO_4_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal iobusMDIO_4_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal iobusMDIO_4_slave_any_continuerequest :  STD_LOGIC;
                signal iobusMDIO_4_slave_arb_counter_enable :  STD_LOGIC;
                signal iobusMDIO_4_slave_arb_share_counter :  STD_LOGIC;
                signal iobusMDIO_4_slave_arb_share_counter_next_value :  STD_LOGIC;
                signal iobusMDIO_4_slave_arb_share_set_values :  STD_LOGIC;
                signal iobusMDIO_4_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal iobusMDIO_4_slave_begins_xfer :  STD_LOGIC;
                signal iobusMDIO_4_slave_end_xfer :  STD_LOGIC;
                signal iobusMDIO_4_slave_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_4_slave_grant_vector :  STD_LOGIC;
                signal iobusMDIO_4_slave_in_a_read_cycle :  STD_LOGIC;
                signal iobusMDIO_4_slave_in_a_write_cycle :  STD_LOGIC;
                signal iobusMDIO_4_slave_master_qreq_vector :  STD_LOGIC;
                signal iobusMDIO_4_slave_move_on_to_next_transaction :  STD_LOGIC;
                signal iobusMDIO_4_slave_non_bursting_master_requests :  STD_LOGIC;
                signal iobusMDIO_4_slave_readdatavalid_from_sa :  STD_LOGIC;
                signal iobusMDIO_4_slave_reg_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_4_slave_slavearbiterlockenable :  STD_LOGIC;
                signal iobusMDIO_4_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal iobusMDIO_4_slave_unreg_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_4_slave_waits_for_read :  STD_LOGIC;
                signal iobusMDIO_4_slave_waits_for_write :  STD_LOGIC;
                signal module_input36 :  STD_LOGIC;
                signal module_input37 :  STD_LOGIC;
                signal module_input38 :  STD_LOGIC;
                signal shifted_address_to_iobusMDIO_4_slave_from_cpu_data_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal wait_for_iobusMDIO_4_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT iobusMDIO_4_slave_end_xfer;
    end if;

  end process;

  iobusMDIO_4_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_iobusMDIO_4_slave);
  --assign iobusMDIO_4_slave_readdata_from_sa = iobusMDIO_4_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMDIO_4_slave_readdata_from_sa <= iobusMDIO_4_slave_readdata;
  internal_cpu_data_master_requests_iobusMDIO_4_slave <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(13 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("00101101000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign iobusMDIO_4_slave_waitrequest_from_sa = iobusMDIO_4_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_iobusMDIO_4_slave_waitrequest_from_sa <= iobusMDIO_4_slave_waitrequest;
  --assign iobusMDIO_4_slave_readdatavalid_from_sa = iobusMDIO_4_slave_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMDIO_4_slave_readdatavalid_from_sa <= iobusMDIO_4_slave_readdatavalid;
  --iobusMDIO_4_slave_arb_share_counter set values, which is an e_mux
  iobusMDIO_4_slave_arb_share_set_values <= std_logic'('1');
  --iobusMDIO_4_slave_non_bursting_master_requests mux, which is an e_mux
  iobusMDIO_4_slave_non_bursting_master_requests <= internal_cpu_data_master_requests_iobusMDIO_4_slave;
  --iobusMDIO_4_slave_any_bursting_master_saved_grant mux, which is an e_mux
  iobusMDIO_4_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --iobusMDIO_4_slave_arb_share_counter_next_value assignment, which is an e_assign
  iobusMDIO_4_slave_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(iobusMDIO_4_slave_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMDIO_4_slave_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(iobusMDIO_4_slave_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMDIO_4_slave_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --iobusMDIO_4_slave_allgrants all slave grants, which is an e_mux
  iobusMDIO_4_slave_allgrants <= iobusMDIO_4_slave_grant_vector;
  --iobusMDIO_4_slave_end_xfer assignment, which is an e_assign
  iobusMDIO_4_slave_end_xfer <= NOT ((iobusMDIO_4_slave_waits_for_read OR iobusMDIO_4_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_iobusMDIO_4_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_iobusMDIO_4_slave <= iobusMDIO_4_slave_end_xfer AND (((NOT iobusMDIO_4_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --iobusMDIO_4_slave_arb_share_counter arbitration counter enable, which is an e_assign
  iobusMDIO_4_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_iobusMDIO_4_slave AND iobusMDIO_4_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_iobusMDIO_4_slave AND NOT iobusMDIO_4_slave_non_bursting_master_requests));
  --iobusMDIO_4_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_4_slave_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMDIO_4_slave_arb_counter_enable) = '1' then 
        iobusMDIO_4_slave_arb_share_counter <= iobusMDIO_4_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --iobusMDIO_4_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_4_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((iobusMDIO_4_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_iobusMDIO_4_slave)) OR ((end_xfer_arb_share_counter_term_iobusMDIO_4_slave AND NOT iobusMDIO_4_slave_non_bursting_master_requests)))) = '1' then 
        iobusMDIO_4_slave_slavearbiterlockenable <= iobusMDIO_4_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master iobusMDIO_4/slave arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= iobusMDIO_4_slave_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --iobusMDIO_4_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  iobusMDIO_4_slave_slavearbiterlockenable2 <= iobusMDIO_4_slave_arb_share_counter_next_value;
  --cpu/data_master iobusMDIO_4/slave arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= iobusMDIO_4_slave_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --iobusMDIO_4_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  iobusMDIO_4_slave_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_iobusMDIO_4_slave <= internal_cpu_data_master_requests_iobusMDIO_4_slave AND NOT ((((cpu_data_master_read AND ((NOT cpu_data_master_waitrequest OR (internal_cpu_data_master_read_data_valid_iobusMDIO_4_slave_shift_register))))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))));
  --unique name for iobusMDIO_4_slave_move_on_to_next_transaction, which is an e_assign
  iobusMDIO_4_slave_move_on_to_next_transaction <= iobusMDIO_4_slave_readdatavalid_from_sa;
  --rdv_fifo_for_cpu_data_master_to_iobusMDIO_4_slave, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_data_master_to_iobusMDIO_4_slave : rdv_fifo_for_cpu_data_master_to_iobusMDIO_4_slave_module
    port map(
      data_out => cpu_data_master_rdv_fifo_output_from_iobusMDIO_4_slave,
      empty => open,
      fifo_contains_ones_n => cpu_data_master_rdv_fifo_empty_iobusMDIO_4_slave,
      full => open,
      clear_fifo => module_input36,
      clk => clk,
      data_in => internal_cpu_data_master_granted_iobusMDIO_4_slave,
      read => iobusMDIO_4_slave_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input37,
      write => module_input38
    );

  module_input36 <= std_logic'('0');
  module_input37 <= std_logic'('0');
  module_input38 <= in_a_read_cycle AND NOT iobusMDIO_4_slave_waits_for_read;

  internal_cpu_data_master_read_data_valid_iobusMDIO_4_slave_shift_register <= NOT cpu_data_master_rdv_fifo_empty_iobusMDIO_4_slave;
  --local readdatavalid cpu_data_master_read_data_valid_iobusMDIO_4_slave, which is an e_mux
  cpu_data_master_read_data_valid_iobusMDIO_4_slave <= iobusMDIO_4_slave_readdatavalid_from_sa;
  --iobusMDIO_4_slave_writedata mux, which is an e_mux
  iobusMDIO_4_slave_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_iobusMDIO_4_slave <= internal_cpu_data_master_qualified_request_iobusMDIO_4_slave;
  --cpu/data_master saved-grant iobusMDIO_4/slave, which is an e_assign
  cpu_data_master_saved_grant_iobusMDIO_4_slave <= internal_cpu_data_master_requests_iobusMDIO_4_slave;
  --allow new arb cycle for iobusMDIO_4/slave, which is an e_assign
  iobusMDIO_4_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  iobusMDIO_4_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  iobusMDIO_4_slave_master_qreq_vector <= std_logic'('1');
  --~iobusMDIO_4_slave_reset assignment, which is an e_assign
  iobusMDIO_4_slave_reset <= NOT reset_n;
  --iobusMDIO_4_slave_firsttransfer first transaction, which is an e_assign
  iobusMDIO_4_slave_firsttransfer <= A_WE_StdLogic((std_logic'(iobusMDIO_4_slave_begins_xfer) = '1'), iobusMDIO_4_slave_unreg_firsttransfer, iobusMDIO_4_slave_reg_firsttransfer);
  --iobusMDIO_4_slave_unreg_firsttransfer first transaction, which is an e_assign
  iobusMDIO_4_slave_unreg_firsttransfer <= NOT ((iobusMDIO_4_slave_slavearbiterlockenable AND iobusMDIO_4_slave_any_continuerequest));
  --iobusMDIO_4_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_4_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMDIO_4_slave_begins_xfer) = '1' then 
        iobusMDIO_4_slave_reg_firsttransfer <= iobusMDIO_4_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --iobusMDIO_4_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  iobusMDIO_4_slave_beginbursttransfer_internal <= iobusMDIO_4_slave_begins_xfer;
  --iobusMDIO_4_slave_read assignment, which is an e_mux
  iobusMDIO_4_slave_read <= internal_cpu_data_master_granted_iobusMDIO_4_slave AND cpu_data_master_read;
  --iobusMDIO_4_slave_write assignment, which is an e_mux
  iobusMDIO_4_slave_write <= internal_cpu_data_master_granted_iobusMDIO_4_slave AND cpu_data_master_write;
  shifted_address_to_iobusMDIO_4_slave_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --iobusMDIO_4_slave_address mux, which is an e_mux
  iobusMDIO_4_slave_address <= A_EXT (A_SRL(shifted_address_to_iobusMDIO_4_slave_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_iobusMDIO_4_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_iobusMDIO_4_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_iobusMDIO_4_slave_end_xfer <= iobusMDIO_4_slave_end_xfer;
    end if;

  end process;

  --iobusMDIO_4_slave_waits_for_read in a cycle, which is an e_mux
  iobusMDIO_4_slave_waits_for_read <= iobusMDIO_4_slave_in_a_read_cycle AND internal_iobusMDIO_4_slave_waitrequest_from_sa;
  --iobusMDIO_4_slave_in_a_read_cycle assignment, which is an e_assign
  iobusMDIO_4_slave_in_a_read_cycle <= internal_cpu_data_master_granted_iobusMDIO_4_slave AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= iobusMDIO_4_slave_in_a_read_cycle;
  --iobusMDIO_4_slave_waits_for_write in a cycle, which is an e_mux
  iobusMDIO_4_slave_waits_for_write <= iobusMDIO_4_slave_in_a_write_cycle AND internal_iobusMDIO_4_slave_waitrequest_from_sa;
  --iobusMDIO_4_slave_in_a_write_cycle assignment, which is an e_assign
  iobusMDIO_4_slave_in_a_write_cycle <= internal_cpu_data_master_granted_iobusMDIO_4_slave AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= iobusMDIO_4_slave_in_a_write_cycle;
  wait_for_iobusMDIO_4_slave_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_iobusMDIO_4_slave <= internal_cpu_data_master_granted_iobusMDIO_4_slave;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_iobusMDIO_4_slave <= internal_cpu_data_master_qualified_request_iobusMDIO_4_slave;
  --vhdl renameroo for output signals
  cpu_data_master_read_data_valid_iobusMDIO_4_slave_shift_register <= internal_cpu_data_master_read_data_valid_iobusMDIO_4_slave_shift_register;
  --vhdl renameroo for output signals
  cpu_data_master_requests_iobusMDIO_4_slave <= internal_cpu_data_master_requests_iobusMDIO_4_slave;
  --vhdl renameroo for output signals
  iobusMDIO_4_slave_waitrequest_from_sa <= internal_iobusMDIO_4_slave_waitrequest_from_sa;
--synthesis translate_off
    --iobusMDIO_4/slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rdv_fifo_for_cpu_data_master_to_iobusMDIO_5_slave_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_data_master_to_iobusMDIO_5_slave_module;


architecture europa of rdv_fifo_for_cpu_data_master_to_iobusMDIO_5_slave_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (1 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_0;
  empty <= NOT(full_0);
  full_1 <= std_logic'('0');
  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 2);
  one_count_minus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 2);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("000000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 2);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity iobusMDIO_5_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_5_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_5_slave_readdatavalid : IN STD_LOGIC;
                 signal iobusMDIO_5_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_iobusMDIO_5_slave : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMDIO_5_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_5_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_5_slave_shift_register : OUT STD_LOGIC;
                 signal cpu_data_master_requests_iobusMDIO_5_slave : OUT STD_LOGIC;
                 signal d1_iobusMDIO_5_slave_end_xfer : OUT STD_LOGIC;
                 signal iobusMDIO_5_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal iobusMDIO_5_slave_read : OUT STD_LOGIC;
                 signal iobusMDIO_5_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_5_slave_reset : OUT STD_LOGIC;
                 signal iobusMDIO_5_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal iobusMDIO_5_slave_write : OUT STD_LOGIC;
                 signal iobusMDIO_5_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity iobusMDIO_5_slave_arbitrator;


architecture europa of iobusMDIO_5_slave_arbitrator is
component rdv_fifo_for_cpu_data_master_to_iobusMDIO_5_slave_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_data_master_to_iobusMDIO_5_slave_module;

                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_empty_iobusMDIO_5_slave :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_output_from_iobusMDIO_5_slave :  STD_LOGIC;
                signal cpu_data_master_saved_grant_iobusMDIO_5_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_iobusMDIO_5_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_iobusMDIO_5_slave :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_iobusMDIO_5_slave :  STD_LOGIC;
                signal internal_cpu_data_master_read_data_valid_iobusMDIO_5_slave_shift_register :  STD_LOGIC;
                signal internal_cpu_data_master_requests_iobusMDIO_5_slave :  STD_LOGIC;
                signal internal_iobusMDIO_5_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMDIO_5_slave_allgrants :  STD_LOGIC;
                signal iobusMDIO_5_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal iobusMDIO_5_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal iobusMDIO_5_slave_any_continuerequest :  STD_LOGIC;
                signal iobusMDIO_5_slave_arb_counter_enable :  STD_LOGIC;
                signal iobusMDIO_5_slave_arb_share_counter :  STD_LOGIC;
                signal iobusMDIO_5_slave_arb_share_counter_next_value :  STD_LOGIC;
                signal iobusMDIO_5_slave_arb_share_set_values :  STD_LOGIC;
                signal iobusMDIO_5_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal iobusMDIO_5_slave_begins_xfer :  STD_LOGIC;
                signal iobusMDIO_5_slave_end_xfer :  STD_LOGIC;
                signal iobusMDIO_5_slave_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_5_slave_grant_vector :  STD_LOGIC;
                signal iobusMDIO_5_slave_in_a_read_cycle :  STD_LOGIC;
                signal iobusMDIO_5_slave_in_a_write_cycle :  STD_LOGIC;
                signal iobusMDIO_5_slave_master_qreq_vector :  STD_LOGIC;
                signal iobusMDIO_5_slave_move_on_to_next_transaction :  STD_LOGIC;
                signal iobusMDIO_5_slave_non_bursting_master_requests :  STD_LOGIC;
                signal iobusMDIO_5_slave_readdatavalid_from_sa :  STD_LOGIC;
                signal iobusMDIO_5_slave_reg_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_5_slave_slavearbiterlockenable :  STD_LOGIC;
                signal iobusMDIO_5_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal iobusMDIO_5_slave_unreg_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_5_slave_waits_for_read :  STD_LOGIC;
                signal iobusMDIO_5_slave_waits_for_write :  STD_LOGIC;
                signal module_input39 :  STD_LOGIC;
                signal module_input40 :  STD_LOGIC;
                signal module_input41 :  STD_LOGIC;
                signal shifted_address_to_iobusMDIO_5_slave_from_cpu_data_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal wait_for_iobusMDIO_5_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT iobusMDIO_5_slave_end_xfer;
    end if;

  end process;

  iobusMDIO_5_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_iobusMDIO_5_slave);
  --assign iobusMDIO_5_slave_readdata_from_sa = iobusMDIO_5_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMDIO_5_slave_readdata_from_sa <= iobusMDIO_5_slave_readdata;
  internal_cpu_data_master_requests_iobusMDIO_5_slave <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(13 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("00101101010000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign iobusMDIO_5_slave_waitrequest_from_sa = iobusMDIO_5_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_iobusMDIO_5_slave_waitrequest_from_sa <= iobusMDIO_5_slave_waitrequest;
  --assign iobusMDIO_5_slave_readdatavalid_from_sa = iobusMDIO_5_slave_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMDIO_5_slave_readdatavalid_from_sa <= iobusMDIO_5_slave_readdatavalid;
  --iobusMDIO_5_slave_arb_share_counter set values, which is an e_mux
  iobusMDIO_5_slave_arb_share_set_values <= std_logic'('1');
  --iobusMDIO_5_slave_non_bursting_master_requests mux, which is an e_mux
  iobusMDIO_5_slave_non_bursting_master_requests <= internal_cpu_data_master_requests_iobusMDIO_5_slave;
  --iobusMDIO_5_slave_any_bursting_master_saved_grant mux, which is an e_mux
  iobusMDIO_5_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --iobusMDIO_5_slave_arb_share_counter_next_value assignment, which is an e_assign
  iobusMDIO_5_slave_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(iobusMDIO_5_slave_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMDIO_5_slave_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(iobusMDIO_5_slave_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMDIO_5_slave_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --iobusMDIO_5_slave_allgrants all slave grants, which is an e_mux
  iobusMDIO_5_slave_allgrants <= iobusMDIO_5_slave_grant_vector;
  --iobusMDIO_5_slave_end_xfer assignment, which is an e_assign
  iobusMDIO_5_slave_end_xfer <= NOT ((iobusMDIO_5_slave_waits_for_read OR iobusMDIO_5_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_iobusMDIO_5_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_iobusMDIO_5_slave <= iobusMDIO_5_slave_end_xfer AND (((NOT iobusMDIO_5_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --iobusMDIO_5_slave_arb_share_counter arbitration counter enable, which is an e_assign
  iobusMDIO_5_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_iobusMDIO_5_slave AND iobusMDIO_5_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_iobusMDIO_5_slave AND NOT iobusMDIO_5_slave_non_bursting_master_requests));
  --iobusMDIO_5_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_5_slave_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMDIO_5_slave_arb_counter_enable) = '1' then 
        iobusMDIO_5_slave_arb_share_counter <= iobusMDIO_5_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --iobusMDIO_5_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_5_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((iobusMDIO_5_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_iobusMDIO_5_slave)) OR ((end_xfer_arb_share_counter_term_iobusMDIO_5_slave AND NOT iobusMDIO_5_slave_non_bursting_master_requests)))) = '1' then 
        iobusMDIO_5_slave_slavearbiterlockenable <= iobusMDIO_5_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master iobusMDIO_5/slave arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= iobusMDIO_5_slave_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --iobusMDIO_5_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  iobusMDIO_5_slave_slavearbiterlockenable2 <= iobusMDIO_5_slave_arb_share_counter_next_value;
  --cpu/data_master iobusMDIO_5/slave arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= iobusMDIO_5_slave_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --iobusMDIO_5_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  iobusMDIO_5_slave_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_iobusMDIO_5_slave <= internal_cpu_data_master_requests_iobusMDIO_5_slave AND NOT ((((cpu_data_master_read AND ((NOT cpu_data_master_waitrequest OR (internal_cpu_data_master_read_data_valid_iobusMDIO_5_slave_shift_register))))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))));
  --unique name for iobusMDIO_5_slave_move_on_to_next_transaction, which is an e_assign
  iobusMDIO_5_slave_move_on_to_next_transaction <= iobusMDIO_5_slave_readdatavalid_from_sa;
  --rdv_fifo_for_cpu_data_master_to_iobusMDIO_5_slave, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_data_master_to_iobusMDIO_5_slave : rdv_fifo_for_cpu_data_master_to_iobusMDIO_5_slave_module
    port map(
      data_out => cpu_data_master_rdv_fifo_output_from_iobusMDIO_5_slave,
      empty => open,
      fifo_contains_ones_n => cpu_data_master_rdv_fifo_empty_iobusMDIO_5_slave,
      full => open,
      clear_fifo => module_input39,
      clk => clk,
      data_in => internal_cpu_data_master_granted_iobusMDIO_5_slave,
      read => iobusMDIO_5_slave_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input40,
      write => module_input41
    );

  module_input39 <= std_logic'('0');
  module_input40 <= std_logic'('0');
  module_input41 <= in_a_read_cycle AND NOT iobusMDIO_5_slave_waits_for_read;

  internal_cpu_data_master_read_data_valid_iobusMDIO_5_slave_shift_register <= NOT cpu_data_master_rdv_fifo_empty_iobusMDIO_5_slave;
  --local readdatavalid cpu_data_master_read_data_valid_iobusMDIO_5_slave, which is an e_mux
  cpu_data_master_read_data_valid_iobusMDIO_5_slave <= iobusMDIO_5_slave_readdatavalid_from_sa;
  --iobusMDIO_5_slave_writedata mux, which is an e_mux
  iobusMDIO_5_slave_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_iobusMDIO_5_slave <= internal_cpu_data_master_qualified_request_iobusMDIO_5_slave;
  --cpu/data_master saved-grant iobusMDIO_5/slave, which is an e_assign
  cpu_data_master_saved_grant_iobusMDIO_5_slave <= internal_cpu_data_master_requests_iobusMDIO_5_slave;
  --allow new arb cycle for iobusMDIO_5/slave, which is an e_assign
  iobusMDIO_5_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  iobusMDIO_5_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  iobusMDIO_5_slave_master_qreq_vector <= std_logic'('1');
  --~iobusMDIO_5_slave_reset assignment, which is an e_assign
  iobusMDIO_5_slave_reset <= NOT reset_n;
  --iobusMDIO_5_slave_firsttransfer first transaction, which is an e_assign
  iobusMDIO_5_slave_firsttransfer <= A_WE_StdLogic((std_logic'(iobusMDIO_5_slave_begins_xfer) = '1'), iobusMDIO_5_slave_unreg_firsttransfer, iobusMDIO_5_slave_reg_firsttransfer);
  --iobusMDIO_5_slave_unreg_firsttransfer first transaction, which is an e_assign
  iobusMDIO_5_slave_unreg_firsttransfer <= NOT ((iobusMDIO_5_slave_slavearbiterlockenable AND iobusMDIO_5_slave_any_continuerequest));
  --iobusMDIO_5_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_5_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMDIO_5_slave_begins_xfer) = '1' then 
        iobusMDIO_5_slave_reg_firsttransfer <= iobusMDIO_5_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --iobusMDIO_5_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  iobusMDIO_5_slave_beginbursttransfer_internal <= iobusMDIO_5_slave_begins_xfer;
  --iobusMDIO_5_slave_read assignment, which is an e_mux
  iobusMDIO_5_slave_read <= internal_cpu_data_master_granted_iobusMDIO_5_slave AND cpu_data_master_read;
  --iobusMDIO_5_slave_write assignment, which is an e_mux
  iobusMDIO_5_slave_write <= internal_cpu_data_master_granted_iobusMDIO_5_slave AND cpu_data_master_write;
  shifted_address_to_iobusMDIO_5_slave_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --iobusMDIO_5_slave_address mux, which is an e_mux
  iobusMDIO_5_slave_address <= A_EXT (A_SRL(shifted_address_to_iobusMDIO_5_slave_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_iobusMDIO_5_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_iobusMDIO_5_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_iobusMDIO_5_slave_end_xfer <= iobusMDIO_5_slave_end_xfer;
    end if;

  end process;

  --iobusMDIO_5_slave_waits_for_read in a cycle, which is an e_mux
  iobusMDIO_5_slave_waits_for_read <= iobusMDIO_5_slave_in_a_read_cycle AND internal_iobusMDIO_5_slave_waitrequest_from_sa;
  --iobusMDIO_5_slave_in_a_read_cycle assignment, which is an e_assign
  iobusMDIO_5_slave_in_a_read_cycle <= internal_cpu_data_master_granted_iobusMDIO_5_slave AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= iobusMDIO_5_slave_in_a_read_cycle;
  --iobusMDIO_5_slave_waits_for_write in a cycle, which is an e_mux
  iobusMDIO_5_slave_waits_for_write <= iobusMDIO_5_slave_in_a_write_cycle AND internal_iobusMDIO_5_slave_waitrequest_from_sa;
  --iobusMDIO_5_slave_in_a_write_cycle assignment, which is an e_assign
  iobusMDIO_5_slave_in_a_write_cycle <= internal_cpu_data_master_granted_iobusMDIO_5_slave AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= iobusMDIO_5_slave_in_a_write_cycle;
  wait_for_iobusMDIO_5_slave_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_iobusMDIO_5_slave <= internal_cpu_data_master_granted_iobusMDIO_5_slave;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_iobusMDIO_5_slave <= internal_cpu_data_master_qualified_request_iobusMDIO_5_slave;
  --vhdl renameroo for output signals
  cpu_data_master_read_data_valid_iobusMDIO_5_slave_shift_register <= internal_cpu_data_master_read_data_valid_iobusMDIO_5_slave_shift_register;
  --vhdl renameroo for output signals
  cpu_data_master_requests_iobusMDIO_5_slave <= internal_cpu_data_master_requests_iobusMDIO_5_slave;
  --vhdl renameroo for output signals
  iobusMDIO_5_slave_waitrequest_from_sa <= internal_iobusMDIO_5_slave_waitrequest_from_sa;
--synthesis translate_off
    --iobusMDIO_5/slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rdv_fifo_for_cpu_data_master_to_iobusMDIO_6_slave_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_data_master_to_iobusMDIO_6_slave_module;


architecture europa of rdv_fifo_for_cpu_data_master_to_iobusMDIO_6_slave_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (1 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_0;
  empty <= NOT(full_0);
  full_1 <= std_logic'('0');
  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 2);
  one_count_minus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 2);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("000000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 2);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity iobusMDIO_6_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_6_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_6_slave_readdatavalid : IN STD_LOGIC;
                 signal iobusMDIO_6_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_iobusMDIO_6_slave : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMDIO_6_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_6_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_6_slave_shift_register : OUT STD_LOGIC;
                 signal cpu_data_master_requests_iobusMDIO_6_slave : OUT STD_LOGIC;
                 signal d1_iobusMDIO_6_slave_end_xfer : OUT STD_LOGIC;
                 signal iobusMDIO_6_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal iobusMDIO_6_slave_read : OUT STD_LOGIC;
                 signal iobusMDIO_6_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_6_slave_reset : OUT STD_LOGIC;
                 signal iobusMDIO_6_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal iobusMDIO_6_slave_write : OUT STD_LOGIC;
                 signal iobusMDIO_6_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity iobusMDIO_6_slave_arbitrator;


architecture europa of iobusMDIO_6_slave_arbitrator is
component rdv_fifo_for_cpu_data_master_to_iobusMDIO_6_slave_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_data_master_to_iobusMDIO_6_slave_module;

                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_empty_iobusMDIO_6_slave :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_output_from_iobusMDIO_6_slave :  STD_LOGIC;
                signal cpu_data_master_saved_grant_iobusMDIO_6_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_iobusMDIO_6_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_iobusMDIO_6_slave :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_iobusMDIO_6_slave :  STD_LOGIC;
                signal internal_cpu_data_master_read_data_valid_iobusMDIO_6_slave_shift_register :  STD_LOGIC;
                signal internal_cpu_data_master_requests_iobusMDIO_6_slave :  STD_LOGIC;
                signal internal_iobusMDIO_6_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMDIO_6_slave_allgrants :  STD_LOGIC;
                signal iobusMDIO_6_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal iobusMDIO_6_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal iobusMDIO_6_slave_any_continuerequest :  STD_LOGIC;
                signal iobusMDIO_6_slave_arb_counter_enable :  STD_LOGIC;
                signal iobusMDIO_6_slave_arb_share_counter :  STD_LOGIC;
                signal iobusMDIO_6_slave_arb_share_counter_next_value :  STD_LOGIC;
                signal iobusMDIO_6_slave_arb_share_set_values :  STD_LOGIC;
                signal iobusMDIO_6_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal iobusMDIO_6_slave_begins_xfer :  STD_LOGIC;
                signal iobusMDIO_6_slave_end_xfer :  STD_LOGIC;
                signal iobusMDIO_6_slave_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_6_slave_grant_vector :  STD_LOGIC;
                signal iobusMDIO_6_slave_in_a_read_cycle :  STD_LOGIC;
                signal iobusMDIO_6_slave_in_a_write_cycle :  STD_LOGIC;
                signal iobusMDIO_6_slave_master_qreq_vector :  STD_LOGIC;
                signal iobusMDIO_6_slave_move_on_to_next_transaction :  STD_LOGIC;
                signal iobusMDIO_6_slave_non_bursting_master_requests :  STD_LOGIC;
                signal iobusMDIO_6_slave_readdatavalid_from_sa :  STD_LOGIC;
                signal iobusMDIO_6_slave_reg_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_6_slave_slavearbiterlockenable :  STD_LOGIC;
                signal iobusMDIO_6_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal iobusMDIO_6_slave_unreg_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_6_slave_waits_for_read :  STD_LOGIC;
                signal iobusMDIO_6_slave_waits_for_write :  STD_LOGIC;
                signal module_input42 :  STD_LOGIC;
                signal module_input43 :  STD_LOGIC;
                signal module_input44 :  STD_LOGIC;
                signal shifted_address_to_iobusMDIO_6_slave_from_cpu_data_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal wait_for_iobusMDIO_6_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT iobusMDIO_6_slave_end_xfer;
    end if;

  end process;

  iobusMDIO_6_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_iobusMDIO_6_slave);
  --assign iobusMDIO_6_slave_readdata_from_sa = iobusMDIO_6_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMDIO_6_slave_readdata_from_sa <= iobusMDIO_6_slave_readdata;
  internal_cpu_data_master_requests_iobusMDIO_6_slave <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(13 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("00101101100000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign iobusMDIO_6_slave_waitrequest_from_sa = iobusMDIO_6_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_iobusMDIO_6_slave_waitrequest_from_sa <= iobusMDIO_6_slave_waitrequest;
  --assign iobusMDIO_6_slave_readdatavalid_from_sa = iobusMDIO_6_slave_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMDIO_6_slave_readdatavalid_from_sa <= iobusMDIO_6_slave_readdatavalid;
  --iobusMDIO_6_slave_arb_share_counter set values, which is an e_mux
  iobusMDIO_6_slave_arb_share_set_values <= std_logic'('1');
  --iobusMDIO_6_slave_non_bursting_master_requests mux, which is an e_mux
  iobusMDIO_6_slave_non_bursting_master_requests <= internal_cpu_data_master_requests_iobusMDIO_6_slave;
  --iobusMDIO_6_slave_any_bursting_master_saved_grant mux, which is an e_mux
  iobusMDIO_6_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --iobusMDIO_6_slave_arb_share_counter_next_value assignment, which is an e_assign
  iobusMDIO_6_slave_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(iobusMDIO_6_slave_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMDIO_6_slave_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(iobusMDIO_6_slave_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMDIO_6_slave_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --iobusMDIO_6_slave_allgrants all slave grants, which is an e_mux
  iobusMDIO_6_slave_allgrants <= iobusMDIO_6_slave_grant_vector;
  --iobusMDIO_6_slave_end_xfer assignment, which is an e_assign
  iobusMDIO_6_slave_end_xfer <= NOT ((iobusMDIO_6_slave_waits_for_read OR iobusMDIO_6_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_iobusMDIO_6_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_iobusMDIO_6_slave <= iobusMDIO_6_slave_end_xfer AND (((NOT iobusMDIO_6_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --iobusMDIO_6_slave_arb_share_counter arbitration counter enable, which is an e_assign
  iobusMDIO_6_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_iobusMDIO_6_slave AND iobusMDIO_6_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_iobusMDIO_6_slave AND NOT iobusMDIO_6_slave_non_bursting_master_requests));
  --iobusMDIO_6_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_6_slave_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMDIO_6_slave_arb_counter_enable) = '1' then 
        iobusMDIO_6_slave_arb_share_counter <= iobusMDIO_6_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --iobusMDIO_6_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_6_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((iobusMDIO_6_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_iobusMDIO_6_slave)) OR ((end_xfer_arb_share_counter_term_iobusMDIO_6_slave AND NOT iobusMDIO_6_slave_non_bursting_master_requests)))) = '1' then 
        iobusMDIO_6_slave_slavearbiterlockenable <= iobusMDIO_6_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master iobusMDIO_6/slave arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= iobusMDIO_6_slave_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --iobusMDIO_6_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  iobusMDIO_6_slave_slavearbiterlockenable2 <= iobusMDIO_6_slave_arb_share_counter_next_value;
  --cpu/data_master iobusMDIO_6/slave arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= iobusMDIO_6_slave_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --iobusMDIO_6_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  iobusMDIO_6_slave_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_iobusMDIO_6_slave <= internal_cpu_data_master_requests_iobusMDIO_6_slave AND NOT ((((cpu_data_master_read AND ((NOT cpu_data_master_waitrequest OR (internal_cpu_data_master_read_data_valid_iobusMDIO_6_slave_shift_register))))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))));
  --unique name for iobusMDIO_6_slave_move_on_to_next_transaction, which is an e_assign
  iobusMDIO_6_slave_move_on_to_next_transaction <= iobusMDIO_6_slave_readdatavalid_from_sa;
  --rdv_fifo_for_cpu_data_master_to_iobusMDIO_6_slave, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_data_master_to_iobusMDIO_6_slave : rdv_fifo_for_cpu_data_master_to_iobusMDIO_6_slave_module
    port map(
      data_out => cpu_data_master_rdv_fifo_output_from_iobusMDIO_6_slave,
      empty => open,
      fifo_contains_ones_n => cpu_data_master_rdv_fifo_empty_iobusMDIO_6_slave,
      full => open,
      clear_fifo => module_input42,
      clk => clk,
      data_in => internal_cpu_data_master_granted_iobusMDIO_6_slave,
      read => iobusMDIO_6_slave_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input43,
      write => module_input44
    );

  module_input42 <= std_logic'('0');
  module_input43 <= std_logic'('0');
  module_input44 <= in_a_read_cycle AND NOT iobusMDIO_6_slave_waits_for_read;

  internal_cpu_data_master_read_data_valid_iobusMDIO_6_slave_shift_register <= NOT cpu_data_master_rdv_fifo_empty_iobusMDIO_6_slave;
  --local readdatavalid cpu_data_master_read_data_valid_iobusMDIO_6_slave, which is an e_mux
  cpu_data_master_read_data_valid_iobusMDIO_6_slave <= iobusMDIO_6_slave_readdatavalid_from_sa;
  --iobusMDIO_6_slave_writedata mux, which is an e_mux
  iobusMDIO_6_slave_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_iobusMDIO_6_slave <= internal_cpu_data_master_qualified_request_iobusMDIO_6_slave;
  --cpu/data_master saved-grant iobusMDIO_6/slave, which is an e_assign
  cpu_data_master_saved_grant_iobusMDIO_6_slave <= internal_cpu_data_master_requests_iobusMDIO_6_slave;
  --allow new arb cycle for iobusMDIO_6/slave, which is an e_assign
  iobusMDIO_6_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  iobusMDIO_6_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  iobusMDIO_6_slave_master_qreq_vector <= std_logic'('1');
  --~iobusMDIO_6_slave_reset assignment, which is an e_assign
  iobusMDIO_6_slave_reset <= NOT reset_n;
  --iobusMDIO_6_slave_firsttransfer first transaction, which is an e_assign
  iobusMDIO_6_slave_firsttransfer <= A_WE_StdLogic((std_logic'(iobusMDIO_6_slave_begins_xfer) = '1'), iobusMDIO_6_slave_unreg_firsttransfer, iobusMDIO_6_slave_reg_firsttransfer);
  --iobusMDIO_6_slave_unreg_firsttransfer first transaction, which is an e_assign
  iobusMDIO_6_slave_unreg_firsttransfer <= NOT ((iobusMDIO_6_slave_slavearbiterlockenable AND iobusMDIO_6_slave_any_continuerequest));
  --iobusMDIO_6_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_6_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMDIO_6_slave_begins_xfer) = '1' then 
        iobusMDIO_6_slave_reg_firsttransfer <= iobusMDIO_6_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --iobusMDIO_6_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  iobusMDIO_6_slave_beginbursttransfer_internal <= iobusMDIO_6_slave_begins_xfer;
  --iobusMDIO_6_slave_read assignment, which is an e_mux
  iobusMDIO_6_slave_read <= internal_cpu_data_master_granted_iobusMDIO_6_slave AND cpu_data_master_read;
  --iobusMDIO_6_slave_write assignment, which is an e_mux
  iobusMDIO_6_slave_write <= internal_cpu_data_master_granted_iobusMDIO_6_slave AND cpu_data_master_write;
  shifted_address_to_iobusMDIO_6_slave_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --iobusMDIO_6_slave_address mux, which is an e_mux
  iobusMDIO_6_slave_address <= A_EXT (A_SRL(shifted_address_to_iobusMDIO_6_slave_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_iobusMDIO_6_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_iobusMDIO_6_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_iobusMDIO_6_slave_end_xfer <= iobusMDIO_6_slave_end_xfer;
    end if;

  end process;

  --iobusMDIO_6_slave_waits_for_read in a cycle, which is an e_mux
  iobusMDIO_6_slave_waits_for_read <= iobusMDIO_6_slave_in_a_read_cycle AND internal_iobusMDIO_6_slave_waitrequest_from_sa;
  --iobusMDIO_6_slave_in_a_read_cycle assignment, which is an e_assign
  iobusMDIO_6_slave_in_a_read_cycle <= internal_cpu_data_master_granted_iobusMDIO_6_slave AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= iobusMDIO_6_slave_in_a_read_cycle;
  --iobusMDIO_6_slave_waits_for_write in a cycle, which is an e_mux
  iobusMDIO_6_slave_waits_for_write <= iobusMDIO_6_slave_in_a_write_cycle AND internal_iobusMDIO_6_slave_waitrequest_from_sa;
  --iobusMDIO_6_slave_in_a_write_cycle assignment, which is an e_assign
  iobusMDIO_6_slave_in_a_write_cycle <= internal_cpu_data_master_granted_iobusMDIO_6_slave AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= iobusMDIO_6_slave_in_a_write_cycle;
  wait_for_iobusMDIO_6_slave_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_iobusMDIO_6_slave <= internal_cpu_data_master_granted_iobusMDIO_6_slave;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_iobusMDIO_6_slave <= internal_cpu_data_master_qualified_request_iobusMDIO_6_slave;
  --vhdl renameroo for output signals
  cpu_data_master_read_data_valid_iobusMDIO_6_slave_shift_register <= internal_cpu_data_master_read_data_valid_iobusMDIO_6_slave_shift_register;
  --vhdl renameroo for output signals
  cpu_data_master_requests_iobusMDIO_6_slave <= internal_cpu_data_master_requests_iobusMDIO_6_slave;
  --vhdl renameroo for output signals
  iobusMDIO_6_slave_waitrequest_from_sa <= internal_iobusMDIO_6_slave_waitrequest_from_sa;
--synthesis translate_off
    --iobusMDIO_6/slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rdv_fifo_for_cpu_data_master_to_iobusMDIO_7_slave_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_data_master_to_iobusMDIO_7_slave_module;


architecture europa of rdv_fifo_for_cpu_data_master_to_iobusMDIO_7_slave_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (1 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_0;
  empty <= NOT(full_0);
  full_1 <= std_logic'('0');
  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 2);
  one_count_minus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 2);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("000000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 2);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity iobusMDIO_7_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_7_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_7_slave_readdatavalid : IN STD_LOGIC;
                 signal iobusMDIO_7_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_iobusMDIO_7_slave : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusMDIO_7_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_7_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusMDIO_7_slave_shift_register : OUT STD_LOGIC;
                 signal cpu_data_master_requests_iobusMDIO_7_slave : OUT STD_LOGIC;
                 signal d1_iobusMDIO_7_slave_end_xfer : OUT STD_LOGIC;
                 signal iobusMDIO_7_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal iobusMDIO_7_slave_read : OUT STD_LOGIC;
                 signal iobusMDIO_7_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusMDIO_7_slave_reset : OUT STD_LOGIC;
                 signal iobusMDIO_7_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal iobusMDIO_7_slave_write : OUT STD_LOGIC;
                 signal iobusMDIO_7_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity iobusMDIO_7_slave_arbitrator;


architecture europa of iobusMDIO_7_slave_arbitrator is
component rdv_fifo_for_cpu_data_master_to_iobusMDIO_7_slave_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_data_master_to_iobusMDIO_7_slave_module;

                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_empty_iobusMDIO_7_slave :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_output_from_iobusMDIO_7_slave :  STD_LOGIC;
                signal cpu_data_master_saved_grant_iobusMDIO_7_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_iobusMDIO_7_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_iobusMDIO_7_slave :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_iobusMDIO_7_slave :  STD_LOGIC;
                signal internal_cpu_data_master_read_data_valid_iobusMDIO_7_slave_shift_register :  STD_LOGIC;
                signal internal_cpu_data_master_requests_iobusMDIO_7_slave :  STD_LOGIC;
                signal internal_iobusMDIO_7_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMDIO_7_slave_allgrants :  STD_LOGIC;
                signal iobusMDIO_7_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal iobusMDIO_7_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal iobusMDIO_7_slave_any_continuerequest :  STD_LOGIC;
                signal iobusMDIO_7_slave_arb_counter_enable :  STD_LOGIC;
                signal iobusMDIO_7_slave_arb_share_counter :  STD_LOGIC;
                signal iobusMDIO_7_slave_arb_share_counter_next_value :  STD_LOGIC;
                signal iobusMDIO_7_slave_arb_share_set_values :  STD_LOGIC;
                signal iobusMDIO_7_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal iobusMDIO_7_slave_begins_xfer :  STD_LOGIC;
                signal iobusMDIO_7_slave_end_xfer :  STD_LOGIC;
                signal iobusMDIO_7_slave_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_7_slave_grant_vector :  STD_LOGIC;
                signal iobusMDIO_7_slave_in_a_read_cycle :  STD_LOGIC;
                signal iobusMDIO_7_slave_in_a_write_cycle :  STD_LOGIC;
                signal iobusMDIO_7_slave_master_qreq_vector :  STD_LOGIC;
                signal iobusMDIO_7_slave_move_on_to_next_transaction :  STD_LOGIC;
                signal iobusMDIO_7_slave_non_bursting_master_requests :  STD_LOGIC;
                signal iobusMDIO_7_slave_readdatavalid_from_sa :  STD_LOGIC;
                signal iobusMDIO_7_slave_reg_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_7_slave_slavearbiterlockenable :  STD_LOGIC;
                signal iobusMDIO_7_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal iobusMDIO_7_slave_unreg_firsttransfer :  STD_LOGIC;
                signal iobusMDIO_7_slave_waits_for_read :  STD_LOGIC;
                signal iobusMDIO_7_slave_waits_for_write :  STD_LOGIC;
                signal module_input45 :  STD_LOGIC;
                signal module_input46 :  STD_LOGIC;
                signal module_input47 :  STD_LOGIC;
                signal shifted_address_to_iobusMDIO_7_slave_from_cpu_data_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal wait_for_iobusMDIO_7_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT iobusMDIO_7_slave_end_xfer;
    end if;

  end process;

  iobusMDIO_7_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_iobusMDIO_7_slave);
  --assign iobusMDIO_7_slave_readdata_from_sa = iobusMDIO_7_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMDIO_7_slave_readdata_from_sa <= iobusMDIO_7_slave_readdata;
  internal_cpu_data_master_requests_iobusMDIO_7_slave <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(13 DOWNTO 4) & std_logic_vector'("0000")) = std_logic_vector'("00101101110000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign iobusMDIO_7_slave_waitrequest_from_sa = iobusMDIO_7_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_iobusMDIO_7_slave_waitrequest_from_sa <= iobusMDIO_7_slave_waitrequest;
  --assign iobusMDIO_7_slave_readdatavalid_from_sa = iobusMDIO_7_slave_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusMDIO_7_slave_readdatavalid_from_sa <= iobusMDIO_7_slave_readdatavalid;
  --iobusMDIO_7_slave_arb_share_counter set values, which is an e_mux
  iobusMDIO_7_slave_arb_share_set_values <= std_logic'('1');
  --iobusMDIO_7_slave_non_bursting_master_requests mux, which is an e_mux
  iobusMDIO_7_slave_non_bursting_master_requests <= internal_cpu_data_master_requests_iobusMDIO_7_slave;
  --iobusMDIO_7_slave_any_bursting_master_saved_grant mux, which is an e_mux
  iobusMDIO_7_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --iobusMDIO_7_slave_arb_share_counter_next_value assignment, which is an e_assign
  iobusMDIO_7_slave_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(iobusMDIO_7_slave_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMDIO_7_slave_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(iobusMDIO_7_slave_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusMDIO_7_slave_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --iobusMDIO_7_slave_allgrants all slave grants, which is an e_mux
  iobusMDIO_7_slave_allgrants <= iobusMDIO_7_slave_grant_vector;
  --iobusMDIO_7_slave_end_xfer assignment, which is an e_assign
  iobusMDIO_7_slave_end_xfer <= NOT ((iobusMDIO_7_slave_waits_for_read OR iobusMDIO_7_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_iobusMDIO_7_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_iobusMDIO_7_slave <= iobusMDIO_7_slave_end_xfer AND (((NOT iobusMDIO_7_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --iobusMDIO_7_slave_arb_share_counter arbitration counter enable, which is an e_assign
  iobusMDIO_7_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_iobusMDIO_7_slave AND iobusMDIO_7_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_iobusMDIO_7_slave AND NOT iobusMDIO_7_slave_non_bursting_master_requests));
  --iobusMDIO_7_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_7_slave_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMDIO_7_slave_arb_counter_enable) = '1' then 
        iobusMDIO_7_slave_arb_share_counter <= iobusMDIO_7_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --iobusMDIO_7_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_7_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((iobusMDIO_7_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_iobusMDIO_7_slave)) OR ((end_xfer_arb_share_counter_term_iobusMDIO_7_slave AND NOT iobusMDIO_7_slave_non_bursting_master_requests)))) = '1' then 
        iobusMDIO_7_slave_slavearbiterlockenable <= iobusMDIO_7_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master iobusMDIO_7/slave arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= iobusMDIO_7_slave_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --iobusMDIO_7_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  iobusMDIO_7_slave_slavearbiterlockenable2 <= iobusMDIO_7_slave_arb_share_counter_next_value;
  --cpu/data_master iobusMDIO_7/slave arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= iobusMDIO_7_slave_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --iobusMDIO_7_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  iobusMDIO_7_slave_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_iobusMDIO_7_slave <= internal_cpu_data_master_requests_iobusMDIO_7_slave AND NOT ((((cpu_data_master_read AND ((NOT cpu_data_master_waitrequest OR (internal_cpu_data_master_read_data_valid_iobusMDIO_7_slave_shift_register))))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))));
  --unique name for iobusMDIO_7_slave_move_on_to_next_transaction, which is an e_assign
  iobusMDIO_7_slave_move_on_to_next_transaction <= iobusMDIO_7_slave_readdatavalid_from_sa;
  --rdv_fifo_for_cpu_data_master_to_iobusMDIO_7_slave, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_data_master_to_iobusMDIO_7_slave : rdv_fifo_for_cpu_data_master_to_iobusMDIO_7_slave_module
    port map(
      data_out => cpu_data_master_rdv_fifo_output_from_iobusMDIO_7_slave,
      empty => open,
      fifo_contains_ones_n => cpu_data_master_rdv_fifo_empty_iobusMDIO_7_slave,
      full => open,
      clear_fifo => module_input45,
      clk => clk,
      data_in => internal_cpu_data_master_granted_iobusMDIO_7_slave,
      read => iobusMDIO_7_slave_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input46,
      write => module_input47
    );

  module_input45 <= std_logic'('0');
  module_input46 <= std_logic'('0');
  module_input47 <= in_a_read_cycle AND NOT iobusMDIO_7_slave_waits_for_read;

  internal_cpu_data_master_read_data_valid_iobusMDIO_7_slave_shift_register <= NOT cpu_data_master_rdv_fifo_empty_iobusMDIO_7_slave;
  --local readdatavalid cpu_data_master_read_data_valid_iobusMDIO_7_slave, which is an e_mux
  cpu_data_master_read_data_valid_iobusMDIO_7_slave <= iobusMDIO_7_slave_readdatavalid_from_sa;
  --iobusMDIO_7_slave_writedata mux, which is an e_mux
  iobusMDIO_7_slave_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_iobusMDIO_7_slave <= internal_cpu_data_master_qualified_request_iobusMDIO_7_slave;
  --cpu/data_master saved-grant iobusMDIO_7/slave, which is an e_assign
  cpu_data_master_saved_grant_iobusMDIO_7_slave <= internal_cpu_data_master_requests_iobusMDIO_7_slave;
  --allow new arb cycle for iobusMDIO_7/slave, which is an e_assign
  iobusMDIO_7_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  iobusMDIO_7_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  iobusMDIO_7_slave_master_qreq_vector <= std_logic'('1');
  --~iobusMDIO_7_slave_reset assignment, which is an e_assign
  iobusMDIO_7_slave_reset <= NOT reset_n;
  --iobusMDIO_7_slave_firsttransfer first transaction, which is an e_assign
  iobusMDIO_7_slave_firsttransfer <= A_WE_StdLogic((std_logic'(iobusMDIO_7_slave_begins_xfer) = '1'), iobusMDIO_7_slave_unreg_firsttransfer, iobusMDIO_7_slave_reg_firsttransfer);
  --iobusMDIO_7_slave_unreg_firsttransfer first transaction, which is an e_assign
  iobusMDIO_7_slave_unreg_firsttransfer <= NOT ((iobusMDIO_7_slave_slavearbiterlockenable AND iobusMDIO_7_slave_any_continuerequest));
  --iobusMDIO_7_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusMDIO_7_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusMDIO_7_slave_begins_xfer) = '1' then 
        iobusMDIO_7_slave_reg_firsttransfer <= iobusMDIO_7_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --iobusMDIO_7_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  iobusMDIO_7_slave_beginbursttransfer_internal <= iobusMDIO_7_slave_begins_xfer;
  --iobusMDIO_7_slave_read assignment, which is an e_mux
  iobusMDIO_7_slave_read <= internal_cpu_data_master_granted_iobusMDIO_7_slave AND cpu_data_master_read;
  --iobusMDIO_7_slave_write assignment, which is an e_mux
  iobusMDIO_7_slave_write <= internal_cpu_data_master_granted_iobusMDIO_7_slave AND cpu_data_master_write;
  shifted_address_to_iobusMDIO_7_slave_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --iobusMDIO_7_slave_address mux, which is an e_mux
  iobusMDIO_7_slave_address <= A_EXT (A_SRL(shifted_address_to_iobusMDIO_7_slave_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 2);
  --d1_iobusMDIO_7_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_iobusMDIO_7_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_iobusMDIO_7_slave_end_xfer <= iobusMDIO_7_slave_end_xfer;
    end if;

  end process;

  --iobusMDIO_7_slave_waits_for_read in a cycle, which is an e_mux
  iobusMDIO_7_slave_waits_for_read <= iobusMDIO_7_slave_in_a_read_cycle AND internal_iobusMDIO_7_slave_waitrequest_from_sa;
  --iobusMDIO_7_slave_in_a_read_cycle assignment, which is an e_assign
  iobusMDIO_7_slave_in_a_read_cycle <= internal_cpu_data_master_granted_iobusMDIO_7_slave AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= iobusMDIO_7_slave_in_a_read_cycle;
  --iobusMDIO_7_slave_waits_for_write in a cycle, which is an e_mux
  iobusMDIO_7_slave_waits_for_write <= iobusMDIO_7_slave_in_a_write_cycle AND internal_iobusMDIO_7_slave_waitrequest_from_sa;
  --iobusMDIO_7_slave_in_a_write_cycle assignment, which is an e_assign
  iobusMDIO_7_slave_in_a_write_cycle <= internal_cpu_data_master_granted_iobusMDIO_7_slave AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= iobusMDIO_7_slave_in_a_write_cycle;
  wait_for_iobusMDIO_7_slave_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_iobusMDIO_7_slave <= internal_cpu_data_master_granted_iobusMDIO_7_slave;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_iobusMDIO_7_slave <= internal_cpu_data_master_qualified_request_iobusMDIO_7_slave;
  --vhdl renameroo for output signals
  cpu_data_master_read_data_valid_iobusMDIO_7_slave_shift_register <= internal_cpu_data_master_read_data_valid_iobusMDIO_7_slave_shift_register;
  --vhdl renameroo for output signals
  cpu_data_master_requests_iobusMDIO_7_slave <= internal_cpu_data_master_requests_iobusMDIO_7_slave;
  --vhdl renameroo for output signals
  iobusMDIO_7_slave_waitrequest_from_sa <= internal_iobusMDIO_7_slave_waitrequest_from_sa;
--synthesis translate_off
    --iobusMDIO_7/slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rdv_fifo_for_cpu_data_master_to_iobusREGFILE_0_slave_module is 
        port (
              -- inputs:
                 signal clear_fifo : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sync_reset : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC;
                 signal empty : OUT STD_LOGIC;
                 signal fifo_contains_ones_n : OUT STD_LOGIC;
                 signal full : OUT STD_LOGIC
              );
end entity rdv_fifo_for_cpu_data_master_to_iobusREGFILE_0_slave_module;


architecture europa of rdv_fifo_for_cpu_data_master_to_iobusREGFILE_0_slave_module is
                signal full_0 :  STD_LOGIC;
                signal full_1 :  STD_LOGIC;
                signal how_many_ones :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_minus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal one_count_plus_one :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p0_full_0 :  STD_LOGIC;
                signal p0_stage_0 :  STD_LOGIC;
                signal stage_0 :  STD_LOGIC;
                signal updated_one_count :  STD_LOGIC_VECTOR (1 DOWNTO 0);

begin

  data_out <= stage_0;
  full <= full_0;
  empty <= NOT(full_0);
  full_1 <= std_logic'('0');
  --data_0, which is an e_mux
  p0_stage_0 <= A_WE_StdLogic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((full_1 AND NOT clear_fifo))))) = std_logic_vector'("00000000000000000000000000000000"))), data_in, data_in);
  --data_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      stage_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'(((sync_reset AND full_0) AND NOT((((to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(full_1))) = std_logic_vector'("00000000000000000000000000000000")))) AND read) AND write))))) = '1' then 
          stage_0 <= std_logic'('0');
        else
          stage_0 <= p0_stage_0;
        end if;
      end if;
    end if;

  end process;

  --control_0, which is an e_mux
  p0_full_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((read AND NOT(write)))))) = std_logic_vector'("00000000000000000000000000000000"))), std_logic_vector'("00000000000000000000000000000001"), std_logic_vector'("00000000000000000000000000000000")));
  --control_reg_0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      full_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(((clear_fifo OR ((read XOR write))) OR ((write AND NOT(full_0))))) = '1' then 
        if std_logic'((clear_fifo AND NOT write)) = '1' then 
          full_0 <= std_logic'('0');
        else
          full_0 <= p0_full_0;
        end if;
      end if;
    end if;

  end process;

  one_count_plus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) + std_logic_vector'("000000000000000000000000000000001")), 2);
  one_count_minus_one <= A_EXT (((std_logic_vector'("0000000000000000000000000000000") & (how_many_ones)) - std_logic_vector'("000000000000000000000000000000001")), 2);
  --updated_one_count, which is an e_mux
  updated_one_count <= A_EXT (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND NOT(write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("000000000000000000000000000000") & (A_WE_StdLogicVector((std_logic'(((((clear_fifo OR sync_reset)) AND write))) = '1'), (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(data_in))), A_WE_StdLogicVector((std_logic'(((((read AND (data_in)) AND write) AND (stage_0)))) = '1'), how_many_ones, A_WE_StdLogicVector((std_logic'(((write AND (data_in)))) = '1'), one_count_plus_one, A_WE_StdLogicVector((std_logic'(((read AND (stage_0)))) = '1'), one_count_minus_one, how_many_ones))))))), 2);
  --counts how many ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      how_many_ones <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        how_many_ones <= updated_one_count;
      end if;
    end if;

  end process;

  --this fifo contains ones in the data pipeline, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      fifo_contains_ones_n <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'((((clear_fifo OR sync_reset) OR read) OR write)) = '1' then 
        fifo_contains_ones_n <= NOT (or_reduce(updated_one_count));
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity iobusREGFILE_0_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusREGFILE_0_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusREGFILE_0_slave_readdatavalid : IN STD_LOGIC;
                 signal iobusREGFILE_0_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_iobusREGFILE_0_slave : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_iobusREGFILE_0_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusREGFILE_0_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_iobusREGFILE_0_slave_shift_register : OUT STD_LOGIC;
                 signal cpu_data_master_requests_iobusREGFILE_0_slave : OUT STD_LOGIC;
                 signal d1_iobusREGFILE_0_slave_end_xfer : OUT STD_LOGIC;
                 signal iobusREGFILE_0_slave_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal iobusREGFILE_0_slave_read : OUT STD_LOGIC;
                 signal iobusREGFILE_0_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal iobusREGFILE_0_slave_reset : OUT STD_LOGIC;
                 signal iobusREGFILE_0_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal iobusREGFILE_0_slave_write : OUT STD_LOGIC;
                 signal iobusREGFILE_0_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity iobusREGFILE_0_slave_arbitrator;


architecture europa of iobusREGFILE_0_slave_arbitrator is
component rdv_fifo_for_cpu_data_master_to_iobusREGFILE_0_slave_module is 
           port (
                 -- inputs:
                    signal clear_fifo : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sync_reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC;
                    signal empty : OUT STD_LOGIC;
                    signal fifo_contains_ones_n : OUT STD_LOGIC;
                    signal full : OUT STD_LOGIC
                 );
end component rdv_fifo_for_cpu_data_master_to_iobusREGFILE_0_slave_module;

                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_empty_iobusREGFILE_0_slave :  STD_LOGIC;
                signal cpu_data_master_rdv_fifo_output_from_iobusREGFILE_0_slave :  STD_LOGIC;
                signal cpu_data_master_saved_grant_iobusREGFILE_0_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_iobusREGFILE_0_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_iobusREGFILE_0_slave :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_iobusREGFILE_0_slave :  STD_LOGIC;
                signal internal_cpu_data_master_read_data_valid_iobusREGFILE_0_slave_shift_register :  STD_LOGIC;
                signal internal_cpu_data_master_requests_iobusREGFILE_0_slave :  STD_LOGIC;
                signal internal_iobusREGFILE_0_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusREGFILE_0_slave_allgrants :  STD_LOGIC;
                signal iobusREGFILE_0_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal iobusREGFILE_0_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal iobusREGFILE_0_slave_any_continuerequest :  STD_LOGIC;
                signal iobusREGFILE_0_slave_arb_counter_enable :  STD_LOGIC;
                signal iobusREGFILE_0_slave_arb_share_counter :  STD_LOGIC;
                signal iobusREGFILE_0_slave_arb_share_counter_next_value :  STD_LOGIC;
                signal iobusREGFILE_0_slave_arb_share_set_values :  STD_LOGIC;
                signal iobusREGFILE_0_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal iobusREGFILE_0_slave_begins_xfer :  STD_LOGIC;
                signal iobusREGFILE_0_slave_end_xfer :  STD_LOGIC;
                signal iobusREGFILE_0_slave_firsttransfer :  STD_LOGIC;
                signal iobusREGFILE_0_slave_grant_vector :  STD_LOGIC;
                signal iobusREGFILE_0_slave_in_a_read_cycle :  STD_LOGIC;
                signal iobusREGFILE_0_slave_in_a_write_cycle :  STD_LOGIC;
                signal iobusREGFILE_0_slave_master_qreq_vector :  STD_LOGIC;
                signal iobusREGFILE_0_slave_move_on_to_next_transaction :  STD_LOGIC;
                signal iobusREGFILE_0_slave_non_bursting_master_requests :  STD_LOGIC;
                signal iobusREGFILE_0_slave_readdatavalid_from_sa :  STD_LOGIC;
                signal iobusREGFILE_0_slave_reg_firsttransfer :  STD_LOGIC;
                signal iobusREGFILE_0_slave_slavearbiterlockenable :  STD_LOGIC;
                signal iobusREGFILE_0_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal iobusREGFILE_0_slave_unreg_firsttransfer :  STD_LOGIC;
                signal iobusREGFILE_0_slave_waits_for_read :  STD_LOGIC;
                signal iobusREGFILE_0_slave_waits_for_write :  STD_LOGIC;
                signal module_input48 :  STD_LOGIC;
                signal module_input49 :  STD_LOGIC;
                signal module_input50 :  STD_LOGIC;
                signal shifted_address_to_iobusREGFILE_0_slave_from_cpu_data_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal wait_for_iobusREGFILE_0_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT iobusREGFILE_0_slave_end_xfer;
    end if;

  end process;

  iobusREGFILE_0_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_iobusREGFILE_0_slave);
  --assign iobusREGFILE_0_slave_readdata_from_sa = iobusREGFILE_0_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusREGFILE_0_slave_readdata_from_sa <= iobusREGFILE_0_slave_readdata;
  internal_cpu_data_master_requests_iobusREGFILE_0_slave <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(13 DOWNTO 6) & std_logic_vector'("000000")) = std_logic_vector'("01000000000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign iobusREGFILE_0_slave_waitrequest_from_sa = iobusREGFILE_0_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_iobusREGFILE_0_slave_waitrequest_from_sa <= iobusREGFILE_0_slave_waitrequest;
  --assign iobusREGFILE_0_slave_readdatavalid_from_sa = iobusREGFILE_0_slave_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  iobusREGFILE_0_slave_readdatavalid_from_sa <= iobusREGFILE_0_slave_readdatavalid;
  --iobusREGFILE_0_slave_arb_share_counter set values, which is an e_mux
  iobusREGFILE_0_slave_arb_share_set_values <= std_logic'('1');
  --iobusREGFILE_0_slave_non_bursting_master_requests mux, which is an e_mux
  iobusREGFILE_0_slave_non_bursting_master_requests <= internal_cpu_data_master_requests_iobusREGFILE_0_slave;
  --iobusREGFILE_0_slave_any_bursting_master_saved_grant mux, which is an e_mux
  iobusREGFILE_0_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --iobusREGFILE_0_slave_arb_share_counter_next_value assignment, which is an e_assign
  iobusREGFILE_0_slave_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(iobusREGFILE_0_slave_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusREGFILE_0_slave_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(iobusREGFILE_0_slave_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(iobusREGFILE_0_slave_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --iobusREGFILE_0_slave_allgrants all slave grants, which is an e_mux
  iobusREGFILE_0_slave_allgrants <= iobusREGFILE_0_slave_grant_vector;
  --iobusREGFILE_0_slave_end_xfer assignment, which is an e_assign
  iobusREGFILE_0_slave_end_xfer <= NOT ((iobusREGFILE_0_slave_waits_for_read OR iobusREGFILE_0_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_iobusREGFILE_0_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_iobusREGFILE_0_slave <= iobusREGFILE_0_slave_end_xfer AND (((NOT iobusREGFILE_0_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --iobusREGFILE_0_slave_arb_share_counter arbitration counter enable, which is an e_assign
  iobusREGFILE_0_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_iobusREGFILE_0_slave AND iobusREGFILE_0_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_iobusREGFILE_0_slave AND NOT iobusREGFILE_0_slave_non_bursting_master_requests));
  --iobusREGFILE_0_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusREGFILE_0_slave_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusREGFILE_0_slave_arb_counter_enable) = '1' then 
        iobusREGFILE_0_slave_arb_share_counter <= iobusREGFILE_0_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --iobusREGFILE_0_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusREGFILE_0_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((iobusREGFILE_0_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_iobusREGFILE_0_slave)) OR ((end_xfer_arb_share_counter_term_iobusREGFILE_0_slave AND NOT iobusREGFILE_0_slave_non_bursting_master_requests)))) = '1' then 
        iobusREGFILE_0_slave_slavearbiterlockenable <= iobusREGFILE_0_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master iobusREGFILE_0/slave arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= iobusREGFILE_0_slave_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --iobusREGFILE_0_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  iobusREGFILE_0_slave_slavearbiterlockenable2 <= iobusREGFILE_0_slave_arb_share_counter_next_value;
  --cpu/data_master iobusREGFILE_0/slave arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= iobusREGFILE_0_slave_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --iobusREGFILE_0_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  iobusREGFILE_0_slave_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_iobusREGFILE_0_slave <= internal_cpu_data_master_requests_iobusREGFILE_0_slave AND NOT ((((cpu_data_master_read AND ((NOT cpu_data_master_waitrequest OR (internal_cpu_data_master_read_data_valid_iobusREGFILE_0_slave_shift_register))))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))));
  --unique name for iobusREGFILE_0_slave_move_on_to_next_transaction, which is an e_assign
  iobusREGFILE_0_slave_move_on_to_next_transaction <= iobusREGFILE_0_slave_readdatavalid_from_sa;
  --rdv_fifo_for_cpu_data_master_to_iobusREGFILE_0_slave, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_cpu_data_master_to_iobusREGFILE_0_slave : rdv_fifo_for_cpu_data_master_to_iobusREGFILE_0_slave_module
    port map(
      data_out => cpu_data_master_rdv_fifo_output_from_iobusREGFILE_0_slave,
      empty => open,
      fifo_contains_ones_n => cpu_data_master_rdv_fifo_empty_iobusREGFILE_0_slave,
      full => open,
      clear_fifo => module_input48,
      clk => clk,
      data_in => internal_cpu_data_master_granted_iobusREGFILE_0_slave,
      read => iobusREGFILE_0_slave_move_on_to_next_transaction,
      reset_n => reset_n,
      sync_reset => module_input49,
      write => module_input50
    );

  module_input48 <= std_logic'('0');
  module_input49 <= std_logic'('0');
  module_input50 <= in_a_read_cycle AND NOT iobusREGFILE_0_slave_waits_for_read;

  internal_cpu_data_master_read_data_valid_iobusREGFILE_0_slave_shift_register <= NOT cpu_data_master_rdv_fifo_empty_iobusREGFILE_0_slave;
  --local readdatavalid cpu_data_master_read_data_valid_iobusREGFILE_0_slave, which is an e_mux
  cpu_data_master_read_data_valid_iobusREGFILE_0_slave <= iobusREGFILE_0_slave_readdatavalid_from_sa;
  --iobusREGFILE_0_slave_writedata mux, which is an e_mux
  iobusREGFILE_0_slave_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_iobusREGFILE_0_slave <= internal_cpu_data_master_qualified_request_iobusREGFILE_0_slave;
  --cpu/data_master saved-grant iobusREGFILE_0/slave, which is an e_assign
  cpu_data_master_saved_grant_iobusREGFILE_0_slave <= internal_cpu_data_master_requests_iobusREGFILE_0_slave;
  --allow new arb cycle for iobusREGFILE_0/slave, which is an e_assign
  iobusREGFILE_0_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  iobusREGFILE_0_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  iobusREGFILE_0_slave_master_qreq_vector <= std_logic'('1');
  --~iobusREGFILE_0_slave_reset assignment, which is an e_assign
  iobusREGFILE_0_slave_reset <= NOT reset_n;
  --iobusREGFILE_0_slave_firsttransfer first transaction, which is an e_assign
  iobusREGFILE_0_slave_firsttransfer <= A_WE_StdLogic((std_logic'(iobusREGFILE_0_slave_begins_xfer) = '1'), iobusREGFILE_0_slave_unreg_firsttransfer, iobusREGFILE_0_slave_reg_firsttransfer);
  --iobusREGFILE_0_slave_unreg_firsttransfer first transaction, which is an e_assign
  iobusREGFILE_0_slave_unreg_firsttransfer <= NOT ((iobusREGFILE_0_slave_slavearbiterlockenable AND iobusREGFILE_0_slave_any_continuerequest));
  --iobusREGFILE_0_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      iobusREGFILE_0_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(iobusREGFILE_0_slave_begins_xfer) = '1' then 
        iobusREGFILE_0_slave_reg_firsttransfer <= iobusREGFILE_0_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --iobusREGFILE_0_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  iobusREGFILE_0_slave_beginbursttransfer_internal <= iobusREGFILE_0_slave_begins_xfer;
  --iobusREGFILE_0_slave_read assignment, which is an e_mux
  iobusREGFILE_0_slave_read <= internal_cpu_data_master_granted_iobusREGFILE_0_slave AND cpu_data_master_read;
  --iobusREGFILE_0_slave_write assignment, which is an e_mux
  iobusREGFILE_0_slave_write <= internal_cpu_data_master_granted_iobusREGFILE_0_slave AND cpu_data_master_write;
  shifted_address_to_iobusREGFILE_0_slave_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --iobusREGFILE_0_slave_address mux, which is an e_mux
  iobusREGFILE_0_slave_address <= A_EXT (A_SRL(shifted_address_to_iobusREGFILE_0_slave_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 4);
  --d1_iobusREGFILE_0_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_iobusREGFILE_0_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_iobusREGFILE_0_slave_end_xfer <= iobusREGFILE_0_slave_end_xfer;
    end if;

  end process;

  --iobusREGFILE_0_slave_waits_for_read in a cycle, which is an e_mux
  iobusREGFILE_0_slave_waits_for_read <= iobusREGFILE_0_slave_in_a_read_cycle AND internal_iobusREGFILE_0_slave_waitrequest_from_sa;
  --iobusREGFILE_0_slave_in_a_read_cycle assignment, which is an e_assign
  iobusREGFILE_0_slave_in_a_read_cycle <= internal_cpu_data_master_granted_iobusREGFILE_0_slave AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= iobusREGFILE_0_slave_in_a_read_cycle;
  --iobusREGFILE_0_slave_waits_for_write in a cycle, which is an e_mux
  iobusREGFILE_0_slave_waits_for_write <= iobusREGFILE_0_slave_in_a_write_cycle AND internal_iobusREGFILE_0_slave_waitrequest_from_sa;
  --iobusREGFILE_0_slave_in_a_write_cycle assignment, which is an e_assign
  iobusREGFILE_0_slave_in_a_write_cycle <= internal_cpu_data_master_granted_iobusREGFILE_0_slave AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= iobusREGFILE_0_slave_in_a_write_cycle;
  wait_for_iobusREGFILE_0_slave_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_iobusREGFILE_0_slave <= internal_cpu_data_master_granted_iobusREGFILE_0_slave;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_iobusREGFILE_0_slave <= internal_cpu_data_master_qualified_request_iobusREGFILE_0_slave;
  --vhdl renameroo for output signals
  cpu_data_master_read_data_valid_iobusREGFILE_0_slave_shift_register <= internal_cpu_data_master_read_data_valid_iobusREGFILE_0_slave_shift_register;
  --vhdl renameroo for output signals
  cpu_data_master_requests_iobusREGFILE_0_slave <= internal_cpu_data_master_requests_iobusREGFILE_0_slave;
  --vhdl renameroo for output signals
  iobusREGFILE_0_slave_waitrequest_from_sa <= internal_iobusREGFILE_0_slave_waitrequest_from_sa;
--synthesis translate_off
    --iobusREGFILE_0/slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity jtag_uart_avalon_jtag_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_avalon_jtag_slave_dataavailable : IN STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_irq : IN STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_avalon_jtag_slave_readyfordata : IN STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                 signal cpu_data_master_requests_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                 signal d1_jtag_uart_avalon_jtag_slave_end_xfer : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_address : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_chipselect : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_dataavailable_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_irq_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_read_n : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_avalon_jtag_slave_readyfordata_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_reset_n : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_write_n : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
end entity jtag_uart_avalon_jtag_slave_arbitrator;


architecture europa of jtag_uart_avalon_jtag_slave_arbitrator is
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal internal_jtag_uart_avalon_jtag_slave_waitrequest_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_allgrants :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_any_continuerequest :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_arb_counter_enable :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_arb_share_counter :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_arb_share_counter_next_value :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_arb_share_set_values :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_begins_xfer :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_end_xfer :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_firsttransfer :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_grant_vector :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_in_a_read_cycle :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_in_a_write_cycle :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_master_qreq_vector :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_non_bursting_master_requests :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_reg_firsttransfer :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_slavearbiterlockenable :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_unreg_firsttransfer :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_waits_for_read :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_jtag_uart_avalon_jtag_slave_from_cpu_data_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal wait_for_jtag_uart_avalon_jtag_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT jtag_uart_avalon_jtag_slave_end_xfer;
    end if;

  end process;

  jtag_uart_avalon_jtag_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave);
  --assign jtag_uart_avalon_jtag_slave_readdata_from_sa = jtag_uart_avalon_jtag_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_avalon_jtag_slave_readdata_from_sa <= jtag_uart_avalon_jtag_slave_readdata;
  internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(13 DOWNTO 3) & std_logic_vector'("000")) = std_logic_vector'("00100000000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign jtag_uart_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_avalon_jtag_slave_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_avalon_jtag_slave_dataavailable_from_sa <= jtag_uart_avalon_jtag_slave_dataavailable;
  --assign jtag_uart_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_avalon_jtag_slave_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_avalon_jtag_slave_readyfordata_from_sa <= jtag_uart_avalon_jtag_slave_readyfordata;
  --assign jtag_uart_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_avalon_jtag_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_jtag_uart_avalon_jtag_slave_waitrequest_from_sa <= jtag_uart_avalon_jtag_slave_waitrequest;
  --jtag_uart_avalon_jtag_slave_arb_share_counter set values, which is an e_mux
  jtag_uart_avalon_jtag_slave_arb_share_set_values <= std_logic'('1');
  --jtag_uart_avalon_jtag_slave_non_bursting_master_requests mux, which is an e_mux
  jtag_uart_avalon_jtag_slave_non_bursting_master_requests <= internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave;
  --jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant mux, which is an e_mux
  jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --jtag_uart_avalon_jtag_slave_arb_share_counter_next_value assignment, which is an e_assign
  jtag_uart_avalon_jtag_slave_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(jtag_uart_avalon_jtag_slave_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(jtag_uart_avalon_jtag_slave_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(jtag_uart_avalon_jtag_slave_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(jtag_uart_avalon_jtag_slave_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --jtag_uart_avalon_jtag_slave_allgrants all slave grants, which is an e_mux
  jtag_uart_avalon_jtag_slave_allgrants <= jtag_uart_avalon_jtag_slave_grant_vector;
  --jtag_uart_avalon_jtag_slave_end_xfer assignment, which is an e_assign
  jtag_uart_avalon_jtag_slave_end_xfer <= NOT ((jtag_uart_avalon_jtag_slave_waits_for_read OR jtag_uart_avalon_jtag_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave <= jtag_uart_avalon_jtag_slave_end_xfer AND (((NOT jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --jtag_uart_avalon_jtag_slave_arb_share_counter arbitration counter enable, which is an e_assign
  jtag_uart_avalon_jtag_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave AND jtag_uart_avalon_jtag_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave AND NOT jtag_uart_avalon_jtag_slave_non_bursting_master_requests));
  --jtag_uart_avalon_jtag_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_avalon_jtag_slave_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(jtag_uart_avalon_jtag_slave_arb_counter_enable) = '1' then 
        jtag_uart_avalon_jtag_slave_arb_share_counter <= jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --jtag_uart_avalon_jtag_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_avalon_jtag_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((jtag_uart_avalon_jtag_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave)) OR ((end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave AND NOT jtag_uart_avalon_jtag_slave_non_bursting_master_requests)))) = '1' then 
        jtag_uart_avalon_jtag_slave_slavearbiterlockenable <= jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master jtag_uart/avalon_jtag_slave arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= jtag_uart_avalon_jtag_slave_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 <= jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
  --cpu/data_master jtag_uart/avalon_jtag_slave arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --jtag_uart_avalon_jtag_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  jtag_uart_avalon_jtag_slave_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave AND NOT ((((cpu_data_master_read AND (NOT cpu_data_master_waitrequest))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))));
  --jtag_uart_avalon_jtag_slave_writedata mux, which is an e_mux
  jtag_uart_avalon_jtag_slave_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  --cpu/data_master saved-grant jtag_uart/avalon_jtag_slave, which is an e_assign
  cpu_data_master_saved_grant_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave;
  --allow new arb cycle for jtag_uart/avalon_jtag_slave, which is an e_assign
  jtag_uart_avalon_jtag_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  jtag_uart_avalon_jtag_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  jtag_uart_avalon_jtag_slave_master_qreq_vector <= std_logic'('1');
  --jtag_uart_avalon_jtag_slave_reset_n assignment, which is an e_assign
  jtag_uart_avalon_jtag_slave_reset_n <= reset_n;
  jtag_uart_avalon_jtag_slave_chipselect <= internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave;
  --jtag_uart_avalon_jtag_slave_firsttransfer first transaction, which is an e_assign
  jtag_uart_avalon_jtag_slave_firsttransfer <= A_WE_StdLogic((std_logic'(jtag_uart_avalon_jtag_slave_begins_xfer) = '1'), jtag_uart_avalon_jtag_slave_unreg_firsttransfer, jtag_uart_avalon_jtag_slave_reg_firsttransfer);
  --jtag_uart_avalon_jtag_slave_unreg_firsttransfer first transaction, which is an e_assign
  jtag_uart_avalon_jtag_slave_unreg_firsttransfer <= NOT ((jtag_uart_avalon_jtag_slave_slavearbiterlockenable AND jtag_uart_avalon_jtag_slave_any_continuerequest));
  --jtag_uart_avalon_jtag_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_avalon_jtag_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(jtag_uart_avalon_jtag_slave_begins_xfer) = '1' then 
        jtag_uart_avalon_jtag_slave_reg_firsttransfer <= jtag_uart_avalon_jtag_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --jtag_uart_avalon_jtag_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  jtag_uart_avalon_jtag_slave_beginbursttransfer_internal <= jtag_uart_avalon_jtag_slave_begins_xfer;
  --~jtag_uart_avalon_jtag_slave_read_n assignment, which is an e_mux
  jtag_uart_avalon_jtag_slave_read_n <= NOT ((internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave AND cpu_data_master_read));
  --~jtag_uart_avalon_jtag_slave_write_n assignment, which is an e_mux
  jtag_uart_avalon_jtag_slave_write_n <= NOT ((internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave AND cpu_data_master_write));
  shifted_address_to_jtag_uart_avalon_jtag_slave_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --jtag_uart_avalon_jtag_slave_address mux, which is an e_mux
  jtag_uart_avalon_jtag_slave_address <= Vector_To_Std_Logic(A_SRL(shifted_address_to_jtag_uart_avalon_jtag_slave_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")));
  --d1_jtag_uart_avalon_jtag_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_jtag_uart_avalon_jtag_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_jtag_uart_avalon_jtag_slave_end_xfer <= jtag_uart_avalon_jtag_slave_end_xfer;
    end if;

  end process;

  --jtag_uart_avalon_jtag_slave_waits_for_read in a cycle, which is an e_mux
  jtag_uart_avalon_jtag_slave_waits_for_read <= jtag_uart_avalon_jtag_slave_in_a_read_cycle AND internal_jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  --jtag_uart_avalon_jtag_slave_in_a_read_cycle assignment, which is an e_assign
  jtag_uart_avalon_jtag_slave_in_a_read_cycle <= internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= jtag_uart_avalon_jtag_slave_in_a_read_cycle;
  --jtag_uart_avalon_jtag_slave_waits_for_write in a cycle, which is an e_mux
  jtag_uart_avalon_jtag_slave_waits_for_write <= jtag_uart_avalon_jtag_slave_in_a_write_cycle AND internal_jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  --jtag_uart_avalon_jtag_slave_in_a_write_cycle assignment, which is an e_assign
  jtag_uart_avalon_jtag_slave_in_a_write_cycle <= internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= jtag_uart_avalon_jtag_slave_in_a_write_cycle;
  wait_for_jtag_uart_avalon_jtag_slave_counter <= std_logic'('0');
  --assign jtag_uart_avalon_jtag_slave_irq_from_sa = jtag_uart_avalon_jtag_slave_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_avalon_jtag_slave_irq_from_sa <= jtag_uart_avalon_jtag_slave_irq;
  --vhdl renameroo for output signals
  cpu_data_master_granted_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  --vhdl renameroo for output signals
  cpu_data_master_requests_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave;
  --vhdl renameroo for output signals
  jtag_uart_avalon_jtag_slave_waitrequest_from_sa <= internal_jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
--synthesis translate_off
    --jtag_uart/avalon_jtag_slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity mem_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_instruction_master_read : IN STD_LOGIC;
                 signal mem_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_mem_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_mem_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_mem_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_requests_mem_s1 : OUT STD_LOGIC;
                 signal cpu_instruction_master_granted_mem_s1 : OUT STD_LOGIC;
                 signal cpu_instruction_master_qualified_request_mem_s1 : OUT STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_mem_s1 : OUT STD_LOGIC;
                 signal cpu_instruction_master_requests_mem_s1 : OUT STD_LOGIC;
                 signal d1_mem_s1_end_xfer : OUT STD_LOGIC;
                 signal mem_s1_address : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
                 signal mem_s1_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal mem_s1_chipselect : OUT STD_LOGIC;
                 signal mem_s1_clken : OUT STD_LOGIC;
                 signal mem_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal mem_s1_write : OUT STD_LOGIC;
                 signal mem_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal registered_cpu_data_master_read_data_valid_mem_s1 : OUT STD_LOGIC
              );
end entity mem_s1_arbitrator;


architecture europa of mem_s1_arbitrator is
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_mem_s1_shift_register :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_mem_s1_shift_register_in :  STD_LOGIC;
                signal cpu_data_master_saved_grant_mem_s1 :  STD_LOGIC;
                signal cpu_instruction_master_arbiterlock :  STD_LOGIC;
                signal cpu_instruction_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_instruction_master_continuerequest :  STD_LOGIC;
                signal cpu_instruction_master_read_data_valid_mem_s1_shift_register :  STD_LOGIC;
                signal cpu_instruction_master_read_data_valid_mem_s1_shift_register_in :  STD_LOGIC;
                signal cpu_instruction_master_saved_grant_mem_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_mem_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_mem_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_mem_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_requests_mem_s1 :  STD_LOGIC;
                signal internal_cpu_instruction_master_granted_mem_s1 :  STD_LOGIC;
                signal internal_cpu_instruction_master_qualified_request_mem_s1 :  STD_LOGIC;
                signal internal_cpu_instruction_master_requests_mem_s1 :  STD_LOGIC;
                signal last_cycle_cpu_data_master_granted_slave_mem_s1 :  STD_LOGIC;
                signal last_cycle_cpu_instruction_master_granted_slave_mem_s1 :  STD_LOGIC;
                signal mem_s1_allgrants :  STD_LOGIC;
                signal mem_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal mem_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal mem_s1_any_continuerequest :  STD_LOGIC;
                signal mem_s1_arb_addend :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal mem_s1_arb_counter_enable :  STD_LOGIC;
                signal mem_s1_arb_share_counter :  STD_LOGIC;
                signal mem_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal mem_s1_arb_share_set_values :  STD_LOGIC;
                signal mem_s1_arb_winner :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal mem_s1_arbitration_holdoff_internal :  STD_LOGIC;
                signal mem_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal mem_s1_begins_xfer :  STD_LOGIC;
                signal mem_s1_chosen_master_double_vector :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal mem_s1_chosen_master_rot_left :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal mem_s1_end_xfer :  STD_LOGIC;
                signal mem_s1_firsttransfer :  STD_LOGIC;
                signal mem_s1_grant_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal mem_s1_in_a_read_cycle :  STD_LOGIC;
                signal mem_s1_in_a_write_cycle :  STD_LOGIC;
                signal mem_s1_master_qreq_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal mem_s1_non_bursting_master_requests :  STD_LOGIC;
                signal mem_s1_reg_firsttransfer :  STD_LOGIC;
                signal mem_s1_saved_chosen_master_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal mem_s1_slavearbiterlockenable :  STD_LOGIC;
                signal mem_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal mem_s1_unreg_firsttransfer :  STD_LOGIC;
                signal mem_s1_waits_for_read :  STD_LOGIC;
                signal mem_s1_waits_for_write :  STD_LOGIC;
                signal p1_cpu_data_master_read_data_valid_mem_s1_shift_register :  STD_LOGIC;
                signal p1_cpu_instruction_master_read_data_valid_mem_s1_shift_register :  STD_LOGIC;
                signal shifted_address_to_mem_s1_from_cpu_data_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal shifted_address_to_mem_s1_from_cpu_instruction_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal wait_for_mem_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT mem_s1_end_xfer;
    end if;

  end process;

  mem_s1_begins_xfer <= NOT d1_reasons_to_wait AND ((internal_cpu_data_master_qualified_request_mem_s1 OR internal_cpu_instruction_master_qualified_request_mem_s1));
  --assign mem_s1_readdata_from_sa = mem_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  mem_s1_readdata_from_sa <= mem_s1_readdata;
  internal_cpu_data_master_requests_mem_s1 <= to_std_logic(((Std_Logic_Vector'(A_ToStdLogicVector(cpu_data_master_address_to_slave(13)) & std_logic_vector'("0000000000000")) = std_logic_vector'("10000000000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --registered rdv signal_name registered_cpu_data_master_read_data_valid_mem_s1 assignment, which is an e_assign
  registered_cpu_data_master_read_data_valid_mem_s1 <= cpu_data_master_read_data_valid_mem_s1_shift_register_in;
  --mem_s1_arb_share_counter set values, which is an e_mux
  mem_s1_arb_share_set_values <= std_logic'('1');
  --mem_s1_non_bursting_master_requests mux, which is an e_mux
  mem_s1_non_bursting_master_requests <= ((internal_cpu_data_master_requests_mem_s1 OR internal_cpu_instruction_master_requests_mem_s1) OR internal_cpu_data_master_requests_mem_s1) OR internal_cpu_instruction_master_requests_mem_s1;
  --mem_s1_any_bursting_master_saved_grant mux, which is an e_mux
  mem_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --mem_s1_arb_share_counter_next_value assignment, which is an e_assign
  mem_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(mem_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(mem_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(mem_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(mem_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --mem_s1_allgrants all slave grants, which is an e_mux
  mem_s1_allgrants <= (((or_reduce(mem_s1_grant_vector)) OR (or_reduce(mem_s1_grant_vector))) OR (or_reduce(mem_s1_grant_vector))) OR (or_reduce(mem_s1_grant_vector));
  --mem_s1_end_xfer assignment, which is an e_assign
  mem_s1_end_xfer <= NOT ((mem_s1_waits_for_read OR mem_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_mem_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_mem_s1 <= mem_s1_end_xfer AND (((NOT mem_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --mem_s1_arb_share_counter arbitration counter enable, which is an e_assign
  mem_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_mem_s1 AND mem_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_mem_s1 AND NOT mem_s1_non_bursting_master_requests));
  --mem_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      mem_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(mem_s1_arb_counter_enable) = '1' then 
        mem_s1_arb_share_counter <= mem_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --mem_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      mem_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((or_reduce(mem_s1_master_qreq_vector) AND end_xfer_arb_share_counter_term_mem_s1)) OR ((end_xfer_arb_share_counter_term_mem_s1 AND NOT mem_s1_non_bursting_master_requests)))) = '1' then 
        mem_s1_slavearbiterlockenable <= mem_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master mem/s1 arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= mem_s1_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --mem_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  mem_s1_slavearbiterlockenable2 <= mem_s1_arb_share_counter_next_value;
  --cpu/data_master mem/s1 arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= mem_s1_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --cpu/instruction_master mem/s1 arbiterlock, which is an e_assign
  cpu_instruction_master_arbiterlock <= mem_s1_slavearbiterlockenable AND cpu_instruction_master_continuerequest;
  --cpu/instruction_master mem/s1 arbiterlock2, which is an e_assign
  cpu_instruction_master_arbiterlock2 <= mem_s1_slavearbiterlockenable2 AND cpu_instruction_master_continuerequest;
  --cpu/instruction_master granted mem/s1 last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_instruction_master_granted_slave_mem_s1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_instruction_master_granted_slave_mem_s1 <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_instruction_master_saved_grant_mem_s1) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((mem_s1_arbitration_holdoff_internal OR NOT internal_cpu_instruction_master_requests_mem_s1))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_instruction_master_granted_slave_mem_s1))))));
    end if;

  end process;

  --cpu_instruction_master_continuerequest continued request, which is an e_mux
  cpu_instruction_master_continuerequest <= last_cycle_cpu_instruction_master_granted_slave_mem_s1 AND internal_cpu_instruction_master_requests_mem_s1;
  --mem_s1_any_continuerequest at least one master continues requesting, which is an e_mux
  mem_s1_any_continuerequest <= cpu_instruction_master_continuerequest OR cpu_data_master_continuerequest;
  internal_cpu_data_master_qualified_request_mem_s1 <= internal_cpu_data_master_requests_mem_s1 AND NOT (((((cpu_data_master_read AND (cpu_data_master_read_data_valid_mem_s1_shift_register))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))) OR cpu_instruction_master_arbiterlock));
  --cpu_data_master_read_data_valid_mem_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  cpu_data_master_read_data_valid_mem_s1_shift_register_in <= ((internal_cpu_data_master_granted_mem_s1 AND cpu_data_master_read) AND NOT mem_s1_waits_for_read) AND NOT (cpu_data_master_read_data_valid_mem_s1_shift_register);
  --shift register p1 cpu_data_master_read_data_valid_mem_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  p1_cpu_data_master_read_data_valid_mem_s1_shift_register <= Vector_To_Std_Logic(Std_Logic_Vector'(A_ToStdLogicVector(cpu_data_master_read_data_valid_mem_s1_shift_register) & A_ToStdLogicVector(cpu_data_master_read_data_valid_mem_s1_shift_register_in)));
  --cpu_data_master_read_data_valid_mem_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_data_master_read_data_valid_mem_s1_shift_register <= std_logic'('0');
    elsif clk'event and clk = '1' then
      cpu_data_master_read_data_valid_mem_s1_shift_register <= p1_cpu_data_master_read_data_valid_mem_s1_shift_register;
    end if;

  end process;

  --local readdatavalid cpu_data_master_read_data_valid_mem_s1, which is an e_mux
  cpu_data_master_read_data_valid_mem_s1 <= cpu_data_master_read_data_valid_mem_s1_shift_register;
  --mem_s1_writedata mux, which is an e_mux
  mem_s1_writedata <= cpu_data_master_writedata;
  --mux mem_s1_clken, which is an e_mux
  mem_s1_clken <= std_logic'('1');
  internal_cpu_instruction_master_requests_mem_s1 <= ((to_std_logic(((Std_Logic_Vector'(A_ToStdLogicVector(cpu_instruction_master_address_to_slave(13)) & std_logic_vector'("0000000000000")) = std_logic_vector'("10000000000000")))) AND (cpu_instruction_master_read))) AND cpu_instruction_master_read;
  --cpu/data_master granted mem/s1 last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_data_master_granted_slave_mem_s1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      last_cycle_cpu_data_master_granted_slave_mem_s1 <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_data_master_saved_grant_mem_s1) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((mem_s1_arbitration_holdoff_internal OR NOT internal_cpu_data_master_requests_mem_s1))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_data_master_granted_slave_mem_s1))))));
    end if;

  end process;

  --cpu_data_master_continuerequest continued request, which is an e_mux
  cpu_data_master_continuerequest <= last_cycle_cpu_data_master_granted_slave_mem_s1 AND internal_cpu_data_master_requests_mem_s1;
  internal_cpu_instruction_master_qualified_request_mem_s1 <= internal_cpu_instruction_master_requests_mem_s1 AND NOT ((((cpu_instruction_master_read AND (cpu_instruction_master_read_data_valid_mem_s1_shift_register))) OR cpu_data_master_arbiterlock));
  --cpu_instruction_master_read_data_valid_mem_s1_shift_register_in mux for readlatency shift register, which is an e_mux
  cpu_instruction_master_read_data_valid_mem_s1_shift_register_in <= ((internal_cpu_instruction_master_granted_mem_s1 AND cpu_instruction_master_read) AND NOT mem_s1_waits_for_read) AND NOT (cpu_instruction_master_read_data_valid_mem_s1_shift_register);
  --shift register p1 cpu_instruction_master_read_data_valid_mem_s1_shift_register in if flush, otherwise shift left, which is an e_mux
  p1_cpu_instruction_master_read_data_valid_mem_s1_shift_register <= Vector_To_Std_Logic(Std_Logic_Vector'(A_ToStdLogicVector(cpu_instruction_master_read_data_valid_mem_s1_shift_register) & A_ToStdLogicVector(cpu_instruction_master_read_data_valid_mem_s1_shift_register_in)));
  --cpu_instruction_master_read_data_valid_mem_s1_shift_register for remembering which master asked for a fixed latency read, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_instruction_master_read_data_valid_mem_s1_shift_register <= std_logic'('0');
    elsif clk'event and clk = '1' then
      cpu_instruction_master_read_data_valid_mem_s1_shift_register <= p1_cpu_instruction_master_read_data_valid_mem_s1_shift_register;
    end if;

  end process;

  --local readdatavalid cpu_instruction_master_read_data_valid_mem_s1, which is an e_mux
  cpu_instruction_master_read_data_valid_mem_s1 <= cpu_instruction_master_read_data_valid_mem_s1_shift_register;
  --allow new arb cycle for mem/s1, which is an e_assign
  mem_s1_allow_new_arb_cycle <= NOT cpu_data_master_arbiterlock AND NOT cpu_instruction_master_arbiterlock;
  --cpu/instruction_master assignment into master qualified-requests vector for mem/s1, which is an e_assign
  mem_s1_master_qreq_vector(0) <= internal_cpu_instruction_master_qualified_request_mem_s1;
  --cpu/instruction_master grant mem/s1, which is an e_assign
  internal_cpu_instruction_master_granted_mem_s1 <= mem_s1_grant_vector(0);
  --cpu/instruction_master saved-grant mem/s1, which is an e_assign
  cpu_instruction_master_saved_grant_mem_s1 <= mem_s1_arb_winner(0) AND internal_cpu_instruction_master_requests_mem_s1;
  --cpu/data_master assignment into master qualified-requests vector for mem/s1, which is an e_assign
  mem_s1_master_qreq_vector(1) <= internal_cpu_data_master_qualified_request_mem_s1;
  --cpu/data_master grant mem/s1, which is an e_assign
  internal_cpu_data_master_granted_mem_s1 <= mem_s1_grant_vector(1);
  --cpu/data_master saved-grant mem/s1, which is an e_assign
  cpu_data_master_saved_grant_mem_s1 <= mem_s1_arb_winner(1) AND internal_cpu_data_master_requests_mem_s1;
  --mem/s1 chosen-master double-vector, which is an e_assign
  mem_s1_chosen_master_double_vector <= A_EXT (((std_logic_vector'("0") & ((mem_s1_master_qreq_vector & mem_s1_master_qreq_vector))) AND (((std_logic_vector'("0") & (Std_Logic_Vector'(NOT mem_s1_master_qreq_vector & NOT mem_s1_master_qreq_vector))) + (std_logic_vector'("000") & (mem_s1_arb_addend))))), 4);
  --stable onehot encoding of arb winner
  mem_s1_arb_winner <= A_WE_StdLogicVector((std_logic'(((mem_s1_allow_new_arb_cycle AND or_reduce(mem_s1_grant_vector)))) = '1'), mem_s1_grant_vector, mem_s1_saved_chosen_master_vector);
  --saved mem_s1_grant_vector, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      mem_s1_saved_chosen_master_vector <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(mem_s1_allow_new_arb_cycle) = '1' then 
        mem_s1_saved_chosen_master_vector <= A_WE_StdLogicVector((std_logic'(or_reduce(mem_s1_grant_vector)) = '1'), mem_s1_grant_vector, mem_s1_saved_chosen_master_vector);
      end if;
    end if;

  end process;

  --onehot encoding of chosen master
  mem_s1_grant_vector <= Std_Logic_Vector'(A_ToStdLogicVector(((mem_s1_chosen_master_double_vector(1) OR mem_s1_chosen_master_double_vector(3)))) & A_ToStdLogicVector(((mem_s1_chosen_master_double_vector(0) OR mem_s1_chosen_master_double_vector(2)))));
  --mem/s1 chosen master rotated left, which is an e_assign
  mem_s1_chosen_master_rot_left <= A_EXT (A_WE_StdLogicVector((((A_SLL(mem_s1_arb_winner,std_logic_vector'("00000000000000000000000000000001")))) /= std_logic_vector'("00")), (std_logic_vector'("000000000000000000000000000000") & ((A_SLL(mem_s1_arb_winner,std_logic_vector'("00000000000000000000000000000001"))))), std_logic_vector'("00000000000000000000000000000001")), 2);
  --mem/s1's addend for next-master-grant
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      mem_s1_arb_addend <= std_logic_vector'("01");
    elsif clk'event and clk = '1' then
      if std_logic'(or_reduce(mem_s1_grant_vector)) = '1' then 
        mem_s1_arb_addend <= A_WE_StdLogicVector((std_logic'(mem_s1_end_xfer) = '1'), mem_s1_chosen_master_rot_left, mem_s1_grant_vector);
      end if;
    end if;

  end process;

  mem_s1_chipselect <= internal_cpu_data_master_granted_mem_s1 OR internal_cpu_instruction_master_granted_mem_s1;
  --mem_s1_firsttransfer first transaction, which is an e_assign
  mem_s1_firsttransfer <= A_WE_StdLogic((std_logic'(mem_s1_begins_xfer) = '1'), mem_s1_unreg_firsttransfer, mem_s1_reg_firsttransfer);
  --mem_s1_unreg_firsttransfer first transaction, which is an e_assign
  mem_s1_unreg_firsttransfer <= NOT ((mem_s1_slavearbiterlockenable AND mem_s1_any_continuerequest));
  --mem_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      mem_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(mem_s1_begins_xfer) = '1' then 
        mem_s1_reg_firsttransfer <= mem_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --mem_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  mem_s1_beginbursttransfer_internal <= mem_s1_begins_xfer;
  --mem_s1_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  mem_s1_arbitration_holdoff_internal <= mem_s1_begins_xfer AND mem_s1_firsttransfer;
  --mem_s1_write assignment, which is an e_mux
  mem_s1_write <= internal_cpu_data_master_granted_mem_s1 AND cpu_data_master_write;
  shifted_address_to_mem_s1_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --mem_s1_address mux, which is an e_mux
  mem_s1_address <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_mem_s1)) = '1'), (A_SRL(shifted_address_to_mem_s1_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010"))), (A_SRL(shifted_address_to_mem_s1_from_cpu_instruction_master,std_logic_vector'("00000000000000000000000000000010")))), 11);
  shifted_address_to_mem_s1_from_cpu_instruction_master <= cpu_instruction_master_address_to_slave;
  --d1_mem_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_mem_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_mem_s1_end_xfer <= mem_s1_end_xfer;
    end if;

  end process;

  --mem_s1_waits_for_read in a cycle, which is an e_mux
  mem_s1_waits_for_read <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(mem_s1_in_a_read_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --mem_s1_in_a_read_cycle assignment, which is an e_assign
  mem_s1_in_a_read_cycle <= ((internal_cpu_data_master_granted_mem_s1 AND cpu_data_master_read)) OR ((internal_cpu_instruction_master_granted_mem_s1 AND cpu_instruction_master_read));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= mem_s1_in_a_read_cycle;
  --mem_s1_waits_for_write in a cycle, which is an e_mux
  mem_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(mem_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --mem_s1_in_a_write_cycle assignment, which is an e_assign
  mem_s1_in_a_write_cycle <= internal_cpu_data_master_granted_mem_s1 AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= mem_s1_in_a_write_cycle;
  wait_for_mem_s1_counter <= std_logic'('0');
  --mem_s1_byteenable byte enable port mux, which is an e_mux
  mem_s1_byteenable <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_mem_s1)) = '1'), (std_logic_vector'("0000000000000000000000000000") & (cpu_data_master_byteenable)), -SIGNED(std_logic_vector'("00000000000000000000000000000001"))), 4);
  --vhdl renameroo for output signals
  cpu_data_master_granted_mem_s1 <= internal_cpu_data_master_granted_mem_s1;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_mem_s1 <= internal_cpu_data_master_qualified_request_mem_s1;
  --vhdl renameroo for output signals
  cpu_data_master_requests_mem_s1 <= internal_cpu_data_master_requests_mem_s1;
  --vhdl renameroo for output signals
  cpu_instruction_master_granted_mem_s1 <= internal_cpu_instruction_master_granted_mem_s1;
  --vhdl renameroo for output signals
  cpu_instruction_master_qualified_request_mem_s1 <= internal_cpu_instruction_master_qualified_request_mem_s1;
  --vhdl renameroo for output signals
  cpu_instruction_master_requests_mem_s1 <= internal_cpu_instruction_master_requests_mem_s1;
--synthesis translate_off
    --mem/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

    --grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line4 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_data_master_granted_mem_s1))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_instruction_master_granted_mem_s1))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line4, now);
          write(write_line4, string'(": "));
          write(write_line4, string'("> 1 of grant signals are active simultaneously"));
          write(output, write_line4.all);
          deallocate (write_line4);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --saved_grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line5 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_data_master_saved_grant_mem_s1))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_saved_grant_mem_s1))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line5, now);
          write(write_line5, string'(": "));
          write(write_line5, string'("> 1 of saved_grant signals are active simultaneously"));
          write(output, write_line5.all);
          deallocate (write_line5);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity rs232_uart_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;
                 signal rs232_uart_s1_dataavailable : IN STD_LOGIC;
                 signal rs232_uart_s1_irq : IN STD_LOGIC;
                 signal rs232_uart_s1_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal rs232_uart_s1_readyfordata : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_rs232_uart_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_rs232_uart_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_rs232_uart_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_requests_rs232_uart_s1 : OUT STD_LOGIC;
                 signal d1_rs232_uart_s1_end_xfer : OUT STD_LOGIC;
                 signal rs232_uart_s1_address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
                 signal rs232_uart_s1_begintransfer : OUT STD_LOGIC;
                 signal rs232_uart_s1_chipselect : OUT STD_LOGIC;
                 signal rs232_uart_s1_dataavailable_from_sa : OUT STD_LOGIC;
                 signal rs232_uart_s1_irq_from_sa : OUT STD_LOGIC;
                 signal rs232_uart_s1_read_n : OUT STD_LOGIC;
                 signal rs232_uart_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal rs232_uart_s1_readyfordata_from_sa : OUT STD_LOGIC;
                 signal rs232_uart_s1_reset_n : OUT STD_LOGIC;
                 signal rs232_uart_s1_write_n : OUT STD_LOGIC;
                 signal rs232_uart_s1_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
              );
end entity rs232_uart_s1_arbitrator;


architecture europa of rs232_uart_s1_arbitrator is
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_rs232_uart_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_rs232_uart_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_rs232_uart_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_rs232_uart_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_requests_rs232_uart_s1 :  STD_LOGIC;
                signal rs232_uart_s1_allgrants :  STD_LOGIC;
                signal rs232_uart_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal rs232_uart_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal rs232_uart_s1_any_continuerequest :  STD_LOGIC;
                signal rs232_uart_s1_arb_counter_enable :  STD_LOGIC;
                signal rs232_uart_s1_arb_share_counter :  STD_LOGIC;
                signal rs232_uart_s1_arb_share_counter_next_value :  STD_LOGIC;
                signal rs232_uart_s1_arb_share_set_values :  STD_LOGIC;
                signal rs232_uart_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal rs232_uart_s1_begins_xfer :  STD_LOGIC;
                signal rs232_uart_s1_end_xfer :  STD_LOGIC;
                signal rs232_uart_s1_firsttransfer :  STD_LOGIC;
                signal rs232_uart_s1_grant_vector :  STD_LOGIC;
                signal rs232_uart_s1_in_a_read_cycle :  STD_LOGIC;
                signal rs232_uart_s1_in_a_write_cycle :  STD_LOGIC;
                signal rs232_uart_s1_master_qreq_vector :  STD_LOGIC;
                signal rs232_uart_s1_non_bursting_master_requests :  STD_LOGIC;
                signal rs232_uart_s1_reg_firsttransfer :  STD_LOGIC;
                signal rs232_uart_s1_slavearbiterlockenable :  STD_LOGIC;
                signal rs232_uart_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal rs232_uart_s1_unreg_firsttransfer :  STD_LOGIC;
                signal rs232_uart_s1_waits_for_read :  STD_LOGIC;
                signal rs232_uart_s1_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_rs232_uart_s1_from_cpu_data_master :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal wait_for_rs232_uart_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      d1_reasons_to_wait <= NOT rs232_uart_s1_end_xfer;
    end if;

  end process;

  rs232_uart_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_rs232_uart_s1);
  --assign rs232_uart_s1_readdata_from_sa = rs232_uart_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  rs232_uart_s1_readdata_from_sa <= rs232_uart_s1_readdata;
  internal_cpu_data_master_requests_rs232_uart_s1 <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(13 DOWNTO 5) & std_logic_vector'("00000")) = std_logic_vector'("00100000100000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign rs232_uart_s1_dataavailable_from_sa = rs232_uart_s1_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  rs232_uart_s1_dataavailable_from_sa <= rs232_uart_s1_dataavailable;
  --assign rs232_uart_s1_readyfordata_from_sa = rs232_uart_s1_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  rs232_uart_s1_readyfordata_from_sa <= rs232_uart_s1_readyfordata;
  --rs232_uart_s1_arb_share_counter set values, which is an e_mux
  rs232_uart_s1_arb_share_set_values <= std_logic'('1');
  --rs232_uart_s1_non_bursting_master_requests mux, which is an e_mux
  rs232_uart_s1_non_bursting_master_requests <= internal_cpu_data_master_requests_rs232_uart_s1;
  --rs232_uart_s1_any_bursting_master_saved_grant mux, which is an e_mux
  rs232_uart_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --rs232_uart_s1_arb_share_counter_next_value assignment, which is an e_assign
  rs232_uart_s1_arb_share_counter_next_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(rs232_uart_s1_firsttransfer) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(rs232_uart_s1_arb_share_set_values))) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(rs232_uart_s1_arb_share_counter) = '1'), (((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(rs232_uart_s1_arb_share_counter))) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))));
  --rs232_uart_s1_allgrants all slave grants, which is an e_mux
  rs232_uart_s1_allgrants <= rs232_uart_s1_grant_vector;
  --rs232_uart_s1_end_xfer assignment, which is an e_assign
  rs232_uart_s1_end_xfer <= NOT ((rs232_uart_s1_waits_for_read OR rs232_uart_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_rs232_uart_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_rs232_uart_s1 <= rs232_uart_s1_end_xfer AND (((NOT rs232_uart_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --rs232_uart_s1_arb_share_counter arbitration counter enable, which is an e_assign
  rs232_uart_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_rs232_uart_s1 AND rs232_uart_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_rs232_uart_s1 AND NOT rs232_uart_s1_non_bursting_master_requests));
  --rs232_uart_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      rs232_uart_s1_arb_share_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'(rs232_uart_s1_arb_counter_enable) = '1' then 
        rs232_uart_s1_arb_share_counter <= rs232_uart_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --rs232_uart_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      rs232_uart_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((rs232_uart_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_rs232_uart_s1)) OR ((end_xfer_arb_share_counter_term_rs232_uart_s1 AND NOT rs232_uart_s1_non_bursting_master_requests)))) = '1' then 
        rs232_uart_s1_slavearbiterlockenable <= rs232_uart_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu/data_master rs232_uart/s1 arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= rs232_uart_s1_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --rs232_uart_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  rs232_uart_s1_slavearbiterlockenable2 <= rs232_uart_s1_arb_share_counter_next_value;
  --cpu/data_master rs232_uart/s1 arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= rs232_uart_s1_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --rs232_uart_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  rs232_uart_s1_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_rs232_uart_s1 <= internal_cpu_data_master_requests_rs232_uart_s1;
  --rs232_uart_s1_writedata mux, which is an e_mux
  rs232_uart_s1_writedata <= cpu_data_master_writedata (15 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_data_master_granted_rs232_uart_s1 <= internal_cpu_data_master_qualified_request_rs232_uart_s1;
  --cpu/data_master saved-grant rs232_uart/s1, which is an e_assign
  cpu_data_master_saved_grant_rs232_uart_s1 <= internal_cpu_data_master_requests_rs232_uart_s1;
  --allow new arb cycle for rs232_uart/s1, which is an e_assign
  rs232_uart_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  rs232_uart_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  rs232_uart_s1_master_qreq_vector <= std_logic'('1');
  rs232_uart_s1_begintransfer <= rs232_uart_s1_begins_xfer;
  --rs232_uart_s1_reset_n assignment, which is an e_assign
  rs232_uart_s1_reset_n <= reset_n;
  rs232_uart_s1_chipselect <= internal_cpu_data_master_granted_rs232_uart_s1;
  --rs232_uart_s1_firsttransfer first transaction, which is an e_assign
  rs232_uart_s1_firsttransfer <= A_WE_StdLogic((std_logic'(rs232_uart_s1_begins_xfer) = '1'), rs232_uart_s1_unreg_firsttransfer, rs232_uart_s1_reg_firsttransfer);
  --rs232_uart_s1_unreg_firsttransfer first transaction, which is an e_assign
  rs232_uart_s1_unreg_firsttransfer <= NOT ((rs232_uart_s1_slavearbiterlockenable AND rs232_uart_s1_any_continuerequest));
  --rs232_uart_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      rs232_uart_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(rs232_uart_s1_begins_xfer) = '1' then 
        rs232_uart_s1_reg_firsttransfer <= rs232_uart_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --rs232_uart_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  rs232_uart_s1_beginbursttransfer_internal <= rs232_uart_s1_begins_xfer;
  --~rs232_uart_s1_read_n assignment, which is an e_mux
  rs232_uart_s1_read_n <= NOT ((internal_cpu_data_master_granted_rs232_uart_s1 AND cpu_data_master_read));
  --~rs232_uart_s1_write_n assignment, which is an e_mux
  rs232_uart_s1_write_n <= NOT ((internal_cpu_data_master_granted_rs232_uart_s1 AND cpu_data_master_write));
  shifted_address_to_rs232_uart_s1_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --rs232_uart_s1_address mux, which is an e_mux
  rs232_uart_s1_address <= A_EXT (A_SRL(shifted_address_to_rs232_uart_s1_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")), 3);
  --d1_rs232_uart_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_rs232_uart_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      d1_rs232_uart_s1_end_xfer <= rs232_uart_s1_end_xfer;
    end if;

  end process;

  --rs232_uart_s1_waits_for_read in a cycle, which is an e_mux
  rs232_uart_s1_waits_for_read <= rs232_uart_s1_in_a_read_cycle AND rs232_uart_s1_begins_xfer;
  --rs232_uart_s1_in_a_read_cycle assignment, which is an e_assign
  rs232_uart_s1_in_a_read_cycle <= internal_cpu_data_master_granted_rs232_uart_s1 AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= rs232_uart_s1_in_a_read_cycle;
  --rs232_uart_s1_waits_for_write in a cycle, which is an e_mux
  rs232_uart_s1_waits_for_write <= rs232_uart_s1_in_a_write_cycle AND rs232_uart_s1_begins_xfer;
  --rs232_uart_s1_in_a_write_cycle assignment, which is an e_assign
  rs232_uart_s1_in_a_write_cycle <= internal_cpu_data_master_granted_rs232_uart_s1 AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= rs232_uart_s1_in_a_write_cycle;
  wait_for_rs232_uart_s1_counter <= std_logic'('0');
  --assign rs232_uart_s1_irq_from_sa = rs232_uart_s1_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  rs232_uart_s1_irq_from_sa <= rs232_uart_s1_irq;
  --vhdl renameroo for output signals
  cpu_data_master_granted_rs232_uart_s1 <= internal_cpu_data_master_granted_rs232_uart_s1;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_rs232_uart_s1 <= internal_cpu_data_master_qualified_request_rs232_uart_s1;
  --vhdl renameroo for output signals
  cpu_data_master_requests_rs232_uart_s1 <= internal_cpu_data_master_requests_rs232_uart_s1;
--synthesis translate_off
    --rs232_uart/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        enable_nonzero_assertions <= std_logic'('1');
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity nios_reset_clk1_domain_synch_module is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC
              );
end entity nios_reset_clk1_domain_synch_module;


architecture europa of nios_reset_clk1_domain_synch_module is
                signal data_in_d1 :  STD_LOGIC;
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of data_in_d1 : signal is "{-from ""*""} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101";
attribute ALTERA_ATTRIBUTE of data_out : signal is "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101";

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      data_in_d1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      data_in_d1 <= data_in;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      data_out <= std_logic'('0');
    elsif clk'event and clk = '1' then
      data_out <= data_in_d1;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity nios is 
        port (
              -- 1) global signals:
                 signal clk1 : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- the_iobusMAC_0
                 signal s_address_from_the_iobusMAC_0 : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal s_clk_from_the_iobusMAC_0 : OUT STD_LOGIC;
                 signal s_read_from_the_iobusMAC_0 : OUT STD_LOGIC;
                 signal s_readdata_to_the_iobusMAC_0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s_readdatavalid_to_the_iobusMAC_0 : IN STD_LOGIC;
                 signal s_rst_from_the_iobusMAC_0 : OUT STD_LOGIC;
                 signal s_waitrequest_to_the_iobusMAC_0 : IN STD_LOGIC;
                 signal s_write_from_the_iobusMAC_0 : OUT STD_LOGIC;
                 signal s_writedata_from_the_iobusMAC_0 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- the_iobusMAC_1
                 signal s_address_from_the_iobusMAC_1 : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal s_clk_from_the_iobusMAC_1 : OUT STD_LOGIC;
                 signal s_read_from_the_iobusMAC_1 : OUT STD_LOGIC;
                 signal s_readdata_to_the_iobusMAC_1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s_readdatavalid_to_the_iobusMAC_1 : IN STD_LOGIC;
                 signal s_rst_from_the_iobusMAC_1 : OUT STD_LOGIC;
                 signal s_waitrequest_to_the_iobusMAC_1 : IN STD_LOGIC;
                 signal s_write_from_the_iobusMAC_1 : OUT STD_LOGIC;
                 signal s_writedata_from_the_iobusMAC_1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- the_iobusMAC_2
                 signal s_address_from_the_iobusMAC_2 : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal s_clk_from_the_iobusMAC_2 : OUT STD_LOGIC;
                 signal s_read_from_the_iobusMAC_2 : OUT STD_LOGIC;
                 signal s_readdata_to_the_iobusMAC_2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s_readdatavalid_to_the_iobusMAC_2 : IN STD_LOGIC;
                 signal s_rst_from_the_iobusMAC_2 : OUT STD_LOGIC;
                 signal s_waitrequest_to_the_iobusMAC_2 : IN STD_LOGIC;
                 signal s_write_from_the_iobusMAC_2 : OUT STD_LOGIC;
                 signal s_writedata_from_the_iobusMAC_2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- the_iobusMAC_3
                 signal s_address_from_the_iobusMAC_3 : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal s_clk_from_the_iobusMAC_3 : OUT STD_LOGIC;
                 signal s_read_from_the_iobusMAC_3 : OUT STD_LOGIC;
                 signal s_readdata_to_the_iobusMAC_3 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s_readdatavalid_to_the_iobusMAC_3 : IN STD_LOGIC;
                 signal s_rst_from_the_iobusMAC_3 : OUT STD_LOGIC;
                 signal s_waitrequest_to_the_iobusMAC_3 : IN STD_LOGIC;
                 signal s_write_from_the_iobusMAC_3 : OUT STD_LOGIC;
                 signal s_writedata_from_the_iobusMAC_3 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- the_iobusMAC_4
                 signal s_address_from_the_iobusMAC_4 : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal s_clk_from_the_iobusMAC_4 : OUT STD_LOGIC;
                 signal s_read_from_the_iobusMAC_4 : OUT STD_LOGIC;
                 signal s_readdata_to_the_iobusMAC_4 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s_readdatavalid_to_the_iobusMAC_4 : IN STD_LOGIC;
                 signal s_rst_from_the_iobusMAC_4 : OUT STD_LOGIC;
                 signal s_waitrequest_to_the_iobusMAC_4 : IN STD_LOGIC;
                 signal s_write_from_the_iobusMAC_4 : OUT STD_LOGIC;
                 signal s_writedata_from_the_iobusMAC_4 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- the_iobusMAC_5
                 signal s_address_from_the_iobusMAC_5 : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal s_clk_from_the_iobusMAC_5 : OUT STD_LOGIC;
                 signal s_read_from_the_iobusMAC_5 : OUT STD_LOGIC;
                 signal s_readdata_to_the_iobusMAC_5 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s_readdatavalid_to_the_iobusMAC_5 : IN STD_LOGIC;
                 signal s_rst_from_the_iobusMAC_5 : OUT STD_LOGIC;
                 signal s_waitrequest_to_the_iobusMAC_5 : IN STD_LOGIC;
                 signal s_write_from_the_iobusMAC_5 : OUT STD_LOGIC;
                 signal s_writedata_from_the_iobusMAC_5 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- the_iobusMAC_6
                 signal s_address_from_the_iobusMAC_6 : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal s_clk_from_the_iobusMAC_6 : OUT STD_LOGIC;
                 signal s_read_from_the_iobusMAC_6 : OUT STD_LOGIC;
                 signal s_readdata_to_the_iobusMAC_6 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s_readdatavalid_to_the_iobusMAC_6 : IN STD_LOGIC;
                 signal s_rst_from_the_iobusMAC_6 : OUT STD_LOGIC;
                 signal s_waitrequest_to_the_iobusMAC_6 : IN STD_LOGIC;
                 signal s_write_from_the_iobusMAC_6 : OUT STD_LOGIC;
                 signal s_writedata_from_the_iobusMAC_6 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- the_iobusMAC_7
                 signal s_address_from_the_iobusMAC_7 : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal s_clk_from_the_iobusMAC_7 : OUT STD_LOGIC;
                 signal s_read_from_the_iobusMAC_7 : OUT STD_LOGIC;
                 signal s_readdata_to_the_iobusMAC_7 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s_readdatavalid_to_the_iobusMAC_7 : IN STD_LOGIC;
                 signal s_rst_from_the_iobusMAC_7 : OUT STD_LOGIC;
                 signal s_waitrequest_to_the_iobusMAC_7 : IN STD_LOGIC;
                 signal s_write_from_the_iobusMAC_7 : OUT STD_LOGIC;
                 signal s_writedata_from_the_iobusMAC_7 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- the_iobusMDIO_0
                 signal s_address_from_the_iobusMDIO_0 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal s_clk_from_the_iobusMDIO_0 : OUT STD_LOGIC;
                 signal s_read_from_the_iobusMDIO_0 : OUT STD_LOGIC;
                 signal s_readdata_to_the_iobusMDIO_0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s_readdatavalid_to_the_iobusMDIO_0 : IN STD_LOGIC;
                 signal s_rst_from_the_iobusMDIO_0 : OUT STD_LOGIC;
                 signal s_waitrequest_to_the_iobusMDIO_0 : IN STD_LOGIC;
                 signal s_write_from_the_iobusMDIO_0 : OUT STD_LOGIC;
                 signal s_writedata_from_the_iobusMDIO_0 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- the_iobusMDIO_1
                 signal s_address_from_the_iobusMDIO_1 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal s_clk_from_the_iobusMDIO_1 : OUT STD_LOGIC;
                 signal s_read_from_the_iobusMDIO_1 : OUT STD_LOGIC;
                 signal s_readdata_to_the_iobusMDIO_1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s_readdatavalid_to_the_iobusMDIO_1 : IN STD_LOGIC;
                 signal s_rst_from_the_iobusMDIO_1 : OUT STD_LOGIC;
                 signal s_waitrequest_to_the_iobusMDIO_1 : IN STD_LOGIC;
                 signal s_write_from_the_iobusMDIO_1 : OUT STD_LOGIC;
                 signal s_writedata_from_the_iobusMDIO_1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- the_iobusMDIO_2
                 signal s_address_from_the_iobusMDIO_2 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal s_clk_from_the_iobusMDIO_2 : OUT STD_LOGIC;
                 signal s_read_from_the_iobusMDIO_2 : OUT STD_LOGIC;
                 signal s_readdata_to_the_iobusMDIO_2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s_readdatavalid_to_the_iobusMDIO_2 : IN STD_LOGIC;
                 signal s_rst_from_the_iobusMDIO_2 : OUT STD_LOGIC;
                 signal s_waitrequest_to_the_iobusMDIO_2 : IN STD_LOGIC;
                 signal s_write_from_the_iobusMDIO_2 : OUT STD_LOGIC;
                 signal s_writedata_from_the_iobusMDIO_2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- the_iobusMDIO_3
                 signal s_address_from_the_iobusMDIO_3 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal s_clk_from_the_iobusMDIO_3 : OUT STD_LOGIC;
                 signal s_read_from_the_iobusMDIO_3 : OUT STD_LOGIC;
                 signal s_readdata_to_the_iobusMDIO_3 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s_readdatavalid_to_the_iobusMDIO_3 : IN STD_LOGIC;
                 signal s_rst_from_the_iobusMDIO_3 : OUT STD_LOGIC;
                 signal s_waitrequest_to_the_iobusMDIO_3 : IN STD_LOGIC;
                 signal s_write_from_the_iobusMDIO_3 : OUT STD_LOGIC;
                 signal s_writedata_from_the_iobusMDIO_3 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- the_iobusMDIO_4
                 signal s_address_from_the_iobusMDIO_4 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal s_clk_from_the_iobusMDIO_4 : OUT STD_LOGIC;
                 signal s_read_from_the_iobusMDIO_4 : OUT STD_LOGIC;
                 signal s_readdata_to_the_iobusMDIO_4 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s_readdatavalid_to_the_iobusMDIO_4 : IN STD_LOGIC;
                 signal s_rst_from_the_iobusMDIO_4 : OUT STD_LOGIC;
                 signal s_waitrequest_to_the_iobusMDIO_4 : IN STD_LOGIC;
                 signal s_write_from_the_iobusMDIO_4 : OUT STD_LOGIC;
                 signal s_writedata_from_the_iobusMDIO_4 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- the_iobusMDIO_5
                 signal s_address_from_the_iobusMDIO_5 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal s_clk_from_the_iobusMDIO_5 : OUT STD_LOGIC;
                 signal s_read_from_the_iobusMDIO_5 : OUT STD_LOGIC;
                 signal s_readdata_to_the_iobusMDIO_5 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s_readdatavalid_to_the_iobusMDIO_5 : IN STD_LOGIC;
                 signal s_rst_from_the_iobusMDIO_5 : OUT STD_LOGIC;
                 signal s_waitrequest_to_the_iobusMDIO_5 : IN STD_LOGIC;
                 signal s_write_from_the_iobusMDIO_5 : OUT STD_LOGIC;
                 signal s_writedata_from_the_iobusMDIO_5 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- the_iobusMDIO_6
                 signal s_address_from_the_iobusMDIO_6 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal s_clk_from_the_iobusMDIO_6 : OUT STD_LOGIC;
                 signal s_read_from_the_iobusMDIO_6 : OUT STD_LOGIC;
                 signal s_readdata_to_the_iobusMDIO_6 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s_readdatavalid_to_the_iobusMDIO_6 : IN STD_LOGIC;
                 signal s_rst_from_the_iobusMDIO_6 : OUT STD_LOGIC;
                 signal s_waitrequest_to_the_iobusMDIO_6 : IN STD_LOGIC;
                 signal s_write_from_the_iobusMDIO_6 : OUT STD_LOGIC;
                 signal s_writedata_from_the_iobusMDIO_6 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- the_iobusMDIO_7
                 signal s_address_from_the_iobusMDIO_7 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal s_clk_from_the_iobusMDIO_7 : OUT STD_LOGIC;
                 signal s_read_from_the_iobusMDIO_7 : OUT STD_LOGIC;
                 signal s_readdata_to_the_iobusMDIO_7 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s_readdatavalid_to_the_iobusMDIO_7 : IN STD_LOGIC;
                 signal s_rst_from_the_iobusMDIO_7 : OUT STD_LOGIC;
                 signal s_waitrequest_to_the_iobusMDIO_7 : IN STD_LOGIC;
                 signal s_write_from_the_iobusMDIO_7 : OUT STD_LOGIC;
                 signal s_writedata_from_the_iobusMDIO_7 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- the_iobusREGFILE_0
                 signal s_address_from_the_iobusREGFILE_0 : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal s_clk_from_the_iobusREGFILE_0 : OUT STD_LOGIC;
                 signal s_read_from_the_iobusREGFILE_0 : OUT STD_LOGIC;
                 signal s_readdata_to_the_iobusREGFILE_0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal s_readdatavalid_to_the_iobusREGFILE_0 : IN STD_LOGIC;
                 signal s_rst_from_the_iobusREGFILE_0 : OUT STD_LOGIC;
                 signal s_waitrequest_to_the_iobusREGFILE_0 : IN STD_LOGIC;
                 signal s_write_from_the_iobusREGFILE_0 : OUT STD_LOGIC;
                 signal s_writedata_from_the_iobusREGFILE_0 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

              -- the_rs232_uart
                 signal rxd_to_the_rs232_uart : IN STD_LOGIC;
                 signal txd_from_the_rs232_uart : OUT STD_LOGIC
              );
end entity nios;


architecture europa of nios is
component cpu_jtag_debug_module_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_data_master_debugaccess : IN STD_LOGIC;
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_instruction_master_read : IN STD_LOGIC;
                    signal cpu_jtag_debug_module_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_jtag_debug_module_resetrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_data_master_requests_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_instruction_master_granted_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_instruction_master_qualified_request_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_instruction_master_requests_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_address : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
                    signal cpu_jtag_debug_module_begintransfer : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_jtag_debug_module_chipselect : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_debugaccess : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_jtag_debug_module_reset_n : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_resetrequest_from_sa : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_write : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_cpu_jtag_debug_module_end_xfer : OUT STD_LOGIC
                 );
end component cpu_jtag_debug_module_arbitrator;

component cpu_data_master_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_granted_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_data_master_granted_iobusMAC_0_slave : IN STD_LOGIC;
                    signal cpu_data_master_granted_iobusMAC_1_slave : IN STD_LOGIC;
                    signal cpu_data_master_granted_iobusMAC_2_slave : IN STD_LOGIC;
                    signal cpu_data_master_granted_iobusMAC_3_slave : IN STD_LOGIC;
                    signal cpu_data_master_granted_iobusMAC_4_slave : IN STD_LOGIC;
                    signal cpu_data_master_granted_iobusMAC_5_slave : IN STD_LOGIC;
                    signal cpu_data_master_granted_iobusMAC_6_slave : IN STD_LOGIC;
                    signal cpu_data_master_granted_iobusMAC_7_slave : IN STD_LOGIC;
                    signal cpu_data_master_granted_iobusMDIO_0_slave : IN STD_LOGIC;
                    signal cpu_data_master_granted_iobusMDIO_1_slave : IN STD_LOGIC;
                    signal cpu_data_master_granted_iobusMDIO_2_slave : IN STD_LOGIC;
                    signal cpu_data_master_granted_iobusMDIO_3_slave : IN STD_LOGIC;
                    signal cpu_data_master_granted_iobusMDIO_4_slave : IN STD_LOGIC;
                    signal cpu_data_master_granted_iobusMDIO_5_slave : IN STD_LOGIC;
                    signal cpu_data_master_granted_iobusMDIO_6_slave : IN STD_LOGIC;
                    signal cpu_data_master_granted_iobusMDIO_7_slave : IN STD_LOGIC;
                    signal cpu_data_master_granted_iobusREGFILE_0_slave : IN STD_LOGIC;
                    signal cpu_data_master_granted_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_data_master_granted_mem_s1 : IN STD_LOGIC;
                    signal cpu_data_master_granted_rs232_uart_s1 : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMAC_0_slave : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMAC_1_slave : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMAC_2_slave : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMAC_3_slave : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMAC_4_slave : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMAC_5_slave : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMAC_6_slave : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMAC_7_slave : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMDIO_0_slave : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMDIO_1_slave : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMDIO_2_slave : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMDIO_3_slave : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMDIO_4_slave : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMDIO_5_slave : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMDIO_6_slave : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMDIO_7_slave : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusREGFILE_0_slave : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_mem_s1 : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_rs232_uart_s1 : IN STD_LOGIC;
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_0_slave : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_0_slave_shift_register : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_1_slave : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_1_slave_shift_register : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_2_slave : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_2_slave_shift_register : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_3_slave : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_3_slave_shift_register : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_4_slave : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_4_slave_shift_register : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_5_slave : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_5_slave_shift_register : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_6_slave : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_6_slave_shift_register : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_7_slave : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_7_slave_shift_register : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_0_slave : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_0_slave_shift_register : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_1_slave : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_1_slave_shift_register : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_2_slave : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_2_slave_shift_register : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_3_slave : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_3_slave_shift_register : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_4_slave : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_4_slave_shift_register : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_5_slave : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_5_slave_shift_register : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_6_slave : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_6_slave_shift_register : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_7_slave : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_7_slave_shift_register : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusREGFILE_0_slave : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusREGFILE_0_slave_shift_register : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_mem_s1 : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_rs232_uart_s1 : IN STD_LOGIC;
                    signal cpu_data_master_requests_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_data_master_requests_iobusMAC_0_slave : IN STD_LOGIC;
                    signal cpu_data_master_requests_iobusMAC_1_slave : IN STD_LOGIC;
                    signal cpu_data_master_requests_iobusMAC_2_slave : IN STD_LOGIC;
                    signal cpu_data_master_requests_iobusMAC_3_slave : IN STD_LOGIC;
                    signal cpu_data_master_requests_iobusMAC_4_slave : IN STD_LOGIC;
                    signal cpu_data_master_requests_iobusMAC_5_slave : IN STD_LOGIC;
                    signal cpu_data_master_requests_iobusMAC_6_slave : IN STD_LOGIC;
                    signal cpu_data_master_requests_iobusMAC_7_slave : IN STD_LOGIC;
                    signal cpu_data_master_requests_iobusMDIO_0_slave : IN STD_LOGIC;
                    signal cpu_data_master_requests_iobusMDIO_1_slave : IN STD_LOGIC;
                    signal cpu_data_master_requests_iobusMDIO_2_slave : IN STD_LOGIC;
                    signal cpu_data_master_requests_iobusMDIO_3_slave : IN STD_LOGIC;
                    signal cpu_data_master_requests_iobusMDIO_4_slave : IN STD_LOGIC;
                    signal cpu_data_master_requests_iobusMDIO_5_slave : IN STD_LOGIC;
                    signal cpu_data_master_requests_iobusMDIO_6_slave : IN STD_LOGIC;
                    signal cpu_data_master_requests_iobusMDIO_7_slave : IN STD_LOGIC;
                    signal cpu_data_master_requests_iobusREGFILE_0_slave : IN STD_LOGIC;
                    signal cpu_data_master_requests_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_data_master_requests_mem_s1 : IN STD_LOGIC;
                    signal cpu_data_master_requests_rs232_uart_s1 : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_cpu_jtag_debug_module_end_xfer : IN STD_LOGIC;
                    signal d1_iobusMAC_0_slave_end_xfer : IN STD_LOGIC;
                    signal d1_iobusMAC_1_slave_end_xfer : IN STD_LOGIC;
                    signal d1_iobusMAC_2_slave_end_xfer : IN STD_LOGIC;
                    signal d1_iobusMAC_3_slave_end_xfer : IN STD_LOGIC;
                    signal d1_iobusMAC_4_slave_end_xfer : IN STD_LOGIC;
                    signal d1_iobusMAC_5_slave_end_xfer : IN STD_LOGIC;
                    signal d1_iobusMAC_6_slave_end_xfer : IN STD_LOGIC;
                    signal d1_iobusMAC_7_slave_end_xfer : IN STD_LOGIC;
                    signal d1_iobusMDIO_0_slave_end_xfer : IN STD_LOGIC;
                    signal d1_iobusMDIO_1_slave_end_xfer : IN STD_LOGIC;
                    signal d1_iobusMDIO_2_slave_end_xfer : IN STD_LOGIC;
                    signal d1_iobusMDIO_3_slave_end_xfer : IN STD_LOGIC;
                    signal d1_iobusMDIO_4_slave_end_xfer : IN STD_LOGIC;
                    signal d1_iobusMDIO_5_slave_end_xfer : IN STD_LOGIC;
                    signal d1_iobusMDIO_6_slave_end_xfer : IN STD_LOGIC;
                    signal d1_iobusMDIO_7_slave_end_xfer : IN STD_LOGIC;
                    signal d1_iobusREGFILE_0_slave_end_xfer : IN STD_LOGIC;
                    signal d1_jtag_uart_avalon_jtag_slave_end_xfer : IN STD_LOGIC;
                    signal d1_mem_s1_end_xfer : IN STD_LOGIC;
                    signal d1_rs232_uart_s1_end_xfer : IN STD_LOGIC;
                    signal iobusMAC_0_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_0_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal iobusMAC_1_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_1_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal iobusMAC_2_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_2_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal iobusMAC_3_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_3_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal iobusMAC_4_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_4_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal iobusMAC_5_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_5_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal iobusMAC_6_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_6_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal iobusMAC_7_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_7_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal iobusMDIO_0_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_0_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal iobusMDIO_1_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_1_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal iobusMDIO_2_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_2_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal iobusMDIO_3_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_3_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal iobusMDIO_4_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_4_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal iobusMDIO_5_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_5_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal iobusMDIO_6_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_6_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal iobusMDIO_7_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_7_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal iobusREGFILE_0_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusREGFILE_0_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_irq_from_sa : IN STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_avalon_jtag_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal mem_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal registered_cpu_data_master_read_data_valid_mem_s1 : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal rs232_uart_s1_irq_from_sa : IN STD_LOGIC;
                    signal rs232_uart_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal cpu_data_master_address_to_slave : OUT STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_irq : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_data_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_data_master_waitrequest : OUT STD_LOGIC
                 );
end component cpu_data_master_arbitrator;

component cpu_instruction_master_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_instruction_master_address : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_instruction_master_granted_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_instruction_master_granted_mem_s1 : IN STD_LOGIC;
                    signal cpu_instruction_master_qualified_request_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_instruction_master_qualified_request_mem_s1 : IN STD_LOGIC;
                    signal cpu_instruction_master_read : IN STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_mem_s1 : IN STD_LOGIC;
                    signal cpu_instruction_master_requests_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_instruction_master_requests_mem_s1 : IN STD_LOGIC;
                    signal cpu_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_cpu_jtag_debug_module_end_xfer : IN STD_LOGIC;
                    signal d1_mem_s1_end_xfer : IN STD_LOGIC;
                    signal mem_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_instruction_master_address_to_slave : OUT STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_instruction_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_instruction_master_waitrequest : OUT STD_LOGIC
                 );
end component cpu_instruction_master_arbitrator;

component cpu is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal d_irq : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d_waitrequest : IN STD_LOGIC;
                    signal i_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal i_waitrequest : IN STD_LOGIC;
                    signal jtag_debug_module_address : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
                    signal jtag_debug_module_begintransfer : IN STD_LOGIC;
                    signal jtag_debug_module_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal jtag_debug_module_debugaccess : IN STD_LOGIC;
                    signal jtag_debug_module_select : IN STD_LOGIC;
                    signal jtag_debug_module_write : IN STD_LOGIC;
                    signal jtag_debug_module_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal d_address : OUT STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal d_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal d_read : OUT STD_LOGIC;
                    signal d_write : OUT STD_LOGIC;
                    signal d_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal i_address : OUT STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal i_read : OUT STD_LOGIC;
                    signal jtag_debug_module_debugaccess_to_roms : OUT STD_LOGIC;
                    signal jtag_debug_module_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_debug_module_resetrequest : OUT STD_LOGIC
                 );
end component cpu;

component iobusMAC_0_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_0_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_0_slave_readdatavalid : IN STD_LOGIC;
                    signal iobusMAC_0_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_iobusMAC_0_slave : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMAC_0_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_0_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_0_slave_shift_register : OUT STD_LOGIC;
                    signal cpu_data_master_requests_iobusMAC_0_slave : OUT STD_LOGIC;
                    signal d1_iobusMAC_0_slave_end_xfer : OUT STD_LOGIC;
                    signal iobusMAC_0_slave_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal iobusMAC_0_slave_read : OUT STD_LOGIC;
                    signal iobusMAC_0_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_0_slave_reset : OUT STD_LOGIC;
                    signal iobusMAC_0_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal iobusMAC_0_slave_write : OUT STD_LOGIC;
                    signal iobusMAC_0_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMAC_0_slave_arbitrator;

component iobusMAC_0 is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal mmaddress : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal mmread : IN STD_LOGIC;
                    signal mmwrite : IN STD_LOGIC;
                    signal mmwritedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rst : IN STD_LOGIC;
                    signal s_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid : IN STD_LOGIC;
                    signal s_waitrequest : IN STD_LOGIC;

                 -- outputs:
                    signal mmreaddata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal mmreaddatavalid : OUT STD_LOGIC;
                    signal mmwaitrequest : OUT STD_LOGIC;
                    signal s_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal s_clk : OUT STD_LOGIC;
                    signal s_read : OUT STD_LOGIC;
                    signal s_rst : OUT STD_LOGIC;
                    signal s_write : OUT STD_LOGIC;
                    signal s_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMAC_0;

component iobusMAC_1_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_1_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_1_slave_readdatavalid : IN STD_LOGIC;
                    signal iobusMAC_1_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_iobusMAC_1_slave : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMAC_1_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_1_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_1_slave_shift_register : OUT STD_LOGIC;
                    signal cpu_data_master_requests_iobusMAC_1_slave : OUT STD_LOGIC;
                    signal d1_iobusMAC_1_slave_end_xfer : OUT STD_LOGIC;
                    signal iobusMAC_1_slave_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal iobusMAC_1_slave_read : OUT STD_LOGIC;
                    signal iobusMAC_1_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_1_slave_reset : OUT STD_LOGIC;
                    signal iobusMAC_1_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal iobusMAC_1_slave_write : OUT STD_LOGIC;
                    signal iobusMAC_1_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMAC_1_slave_arbitrator;

component iobusMAC_1 is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal mmaddress : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal mmread : IN STD_LOGIC;
                    signal mmwrite : IN STD_LOGIC;
                    signal mmwritedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rst : IN STD_LOGIC;
                    signal s_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid : IN STD_LOGIC;
                    signal s_waitrequest : IN STD_LOGIC;

                 -- outputs:
                    signal mmreaddata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal mmreaddatavalid : OUT STD_LOGIC;
                    signal mmwaitrequest : OUT STD_LOGIC;
                    signal s_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal s_clk : OUT STD_LOGIC;
                    signal s_read : OUT STD_LOGIC;
                    signal s_rst : OUT STD_LOGIC;
                    signal s_write : OUT STD_LOGIC;
                    signal s_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMAC_1;

component iobusMAC_2_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_2_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_2_slave_readdatavalid : IN STD_LOGIC;
                    signal iobusMAC_2_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_iobusMAC_2_slave : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMAC_2_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_2_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_2_slave_shift_register : OUT STD_LOGIC;
                    signal cpu_data_master_requests_iobusMAC_2_slave : OUT STD_LOGIC;
                    signal d1_iobusMAC_2_slave_end_xfer : OUT STD_LOGIC;
                    signal iobusMAC_2_slave_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal iobusMAC_2_slave_read : OUT STD_LOGIC;
                    signal iobusMAC_2_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_2_slave_reset : OUT STD_LOGIC;
                    signal iobusMAC_2_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal iobusMAC_2_slave_write : OUT STD_LOGIC;
                    signal iobusMAC_2_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMAC_2_slave_arbitrator;

component iobusMAC_2 is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal mmaddress : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal mmread : IN STD_LOGIC;
                    signal mmwrite : IN STD_LOGIC;
                    signal mmwritedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rst : IN STD_LOGIC;
                    signal s_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid : IN STD_LOGIC;
                    signal s_waitrequest : IN STD_LOGIC;

                 -- outputs:
                    signal mmreaddata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal mmreaddatavalid : OUT STD_LOGIC;
                    signal mmwaitrequest : OUT STD_LOGIC;
                    signal s_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal s_clk : OUT STD_LOGIC;
                    signal s_read : OUT STD_LOGIC;
                    signal s_rst : OUT STD_LOGIC;
                    signal s_write : OUT STD_LOGIC;
                    signal s_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMAC_2;

component iobusMAC_3_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_3_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_3_slave_readdatavalid : IN STD_LOGIC;
                    signal iobusMAC_3_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_iobusMAC_3_slave : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMAC_3_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_3_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_3_slave_shift_register : OUT STD_LOGIC;
                    signal cpu_data_master_requests_iobusMAC_3_slave : OUT STD_LOGIC;
                    signal d1_iobusMAC_3_slave_end_xfer : OUT STD_LOGIC;
                    signal iobusMAC_3_slave_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal iobusMAC_3_slave_read : OUT STD_LOGIC;
                    signal iobusMAC_3_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_3_slave_reset : OUT STD_LOGIC;
                    signal iobusMAC_3_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal iobusMAC_3_slave_write : OUT STD_LOGIC;
                    signal iobusMAC_3_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMAC_3_slave_arbitrator;

component iobusMAC_3 is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal mmaddress : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal mmread : IN STD_LOGIC;
                    signal mmwrite : IN STD_LOGIC;
                    signal mmwritedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rst : IN STD_LOGIC;
                    signal s_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid : IN STD_LOGIC;
                    signal s_waitrequest : IN STD_LOGIC;

                 -- outputs:
                    signal mmreaddata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal mmreaddatavalid : OUT STD_LOGIC;
                    signal mmwaitrequest : OUT STD_LOGIC;
                    signal s_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal s_clk : OUT STD_LOGIC;
                    signal s_read : OUT STD_LOGIC;
                    signal s_rst : OUT STD_LOGIC;
                    signal s_write : OUT STD_LOGIC;
                    signal s_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMAC_3;

component iobusMAC_4_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_4_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_4_slave_readdatavalid : IN STD_LOGIC;
                    signal iobusMAC_4_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_iobusMAC_4_slave : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMAC_4_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_4_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_4_slave_shift_register : OUT STD_LOGIC;
                    signal cpu_data_master_requests_iobusMAC_4_slave : OUT STD_LOGIC;
                    signal d1_iobusMAC_4_slave_end_xfer : OUT STD_LOGIC;
                    signal iobusMAC_4_slave_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal iobusMAC_4_slave_read : OUT STD_LOGIC;
                    signal iobusMAC_4_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_4_slave_reset : OUT STD_LOGIC;
                    signal iobusMAC_4_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal iobusMAC_4_slave_write : OUT STD_LOGIC;
                    signal iobusMAC_4_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMAC_4_slave_arbitrator;

component iobusMAC_4 is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal mmaddress : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal mmread : IN STD_LOGIC;
                    signal mmwrite : IN STD_LOGIC;
                    signal mmwritedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rst : IN STD_LOGIC;
                    signal s_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid : IN STD_LOGIC;
                    signal s_waitrequest : IN STD_LOGIC;

                 -- outputs:
                    signal mmreaddata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal mmreaddatavalid : OUT STD_LOGIC;
                    signal mmwaitrequest : OUT STD_LOGIC;
                    signal s_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal s_clk : OUT STD_LOGIC;
                    signal s_read : OUT STD_LOGIC;
                    signal s_rst : OUT STD_LOGIC;
                    signal s_write : OUT STD_LOGIC;
                    signal s_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMAC_4;

component iobusMAC_5_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_5_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_5_slave_readdatavalid : IN STD_LOGIC;
                    signal iobusMAC_5_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_iobusMAC_5_slave : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMAC_5_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_5_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_5_slave_shift_register : OUT STD_LOGIC;
                    signal cpu_data_master_requests_iobusMAC_5_slave : OUT STD_LOGIC;
                    signal d1_iobusMAC_5_slave_end_xfer : OUT STD_LOGIC;
                    signal iobusMAC_5_slave_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal iobusMAC_5_slave_read : OUT STD_LOGIC;
                    signal iobusMAC_5_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_5_slave_reset : OUT STD_LOGIC;
                    signal iobusMAC_5_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal iobusMAC_5_slave_write : OUT STD_LOGIC;
                    signal iobusMAC_5_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMAC_5_slave_arbitrator;

component iobusMAC_5 is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal mmaddress : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal mmread : IN STD_LOGIC;
                    signal mmwrite : IN STD_LOGIC;
                    signal mmwritedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rst : IN STD_LOGIC;
                    signal s_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid : IN STD_LOGIC;
                    signal s_waitrequest : IN STD_LOGIC;

                 -- outputs:
                    signal mmreaddata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal mmreaddatavalid : OUT STD_LOGIC;
                    signal mmwaitrequest : OUT STD_LOGIC;
                    signal s_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal s_clk : OUT STD_LOGIC;
                    signal s_read : OUT STD_LOGIC;
                    signal s_rst : OUT STD_LOGIC;
                    signal s_write : OUT STD_LOGIC;
                    signal s_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMAC_5;

component iobusMAC_6_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_6_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_6_slave_readdatavalid : IN STD_LOGIC;
                    signal iobusMAC_6_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_iobusMAC_6_slave : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMAC_6_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_6_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_6_slave_shift_register : OUT STD_LOGIC;
                    signal cpu_data_master_requests_iobusMAC_6_slave : OUT STD_LOGIC;
                    signal d1_iobusMAC_6_slave_end_xfer : OUT STD_LOGIC;
                    signal iobusMAC_6_slave_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal iobusMAC_6_slave_read : OUT STD_LOGIC;
                    signal iobusMAC_6_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_6_slave_reset : OUT STD_LOGIC;
                    signal iobusMAC_6_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal iobusMAC_6_slave_write : OUT STD_LOGIC;
                    signal iobusMAC_6_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMAC_6_slave_arbitrator;

component iobusMAC_6 is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal mmaddress : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal mmread : IN STD_LOGIC;
                    signal mmwrite : IN STD_LOGIC;
                    signal mmwritedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rst : IN STD_LOGIC;
                    signal s_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid : IN STD_LOGIC;
                    signal s_waitrequest : IN STD_LOGIC;

                 -- outputs:
                    signal mmreaddata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal mmreaddatavalid : OUT STD_LOGIC;
                    signal mmwaitrequest : OUT STD_LOGIC;
                    signal s_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal s_clk : OUT STD_LOGIC;
                    signal s_read : OUT STD_LOGIC;
                    signal s_rst : OUT STD_LOGIC;
                    signal s_write : OUT STD_LOGIC;
                    signal s_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMAC_6;

component iobusMAC_7_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_7_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_7_slave_readdatavalid : IN STD_LOGIC;
                    signal iobusMAC_7_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_iobusMAC_7_slave : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMAC_7_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_7_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMAC_7_slave_shift_register : OUT STD_LOGIC;
                    signal cpu_data_master_requests_iobusMAC_7_slave : OUT STD_LOGIC;
                    signal d1_iobusMAC_7_slave_end_xfer : OUT STD_LOGIC;
                    signal iobusMAC_7_slave_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal iobusMAC_7_slave_read : OUT STD_LOGIC;
                    signal iobusMAC_7_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMAC_7_slave_reset : OUT STD_LOGIC;
                    signal iobusMAC_7_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal iobusMAC_7_slave_write : OUT STD_LOGIC;
                    signal iobusMAC_7_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMAC_7_slave_arbitrator;

component iobusMAC_7 is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal mmaddress : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal mmread : IN STD_LOGIC;
                    signal mmwrite : IN STD_LOGIC;
                    signal mmwritedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rst : IN STD_LOGIC;
                    signal s_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid : IN STD_LOGIC;
                    signal s_waitrequest : IN STD_LOGIC;

                 -- outputs:
                    signal mmreaddata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal mmreaddatavalid : OUT STD_LOGIC;
                    signal mmwaitrequest : OUT STD_LOGIC;
                    signal s_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal s_clk : OUT STD_LOGIC;
                    signal s_read : OUT STD_LOGIC;
                    signal s_rst : OUT STD_LOGIC;
                    signal s_write : OUT STD_LOGIC;
                    signal s_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMAC_7;

component iobusMDIO_0_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_0_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_0_slave_readdatavalid : IN STD_LOGIC;
                    signal iobusMDIO_0_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_iobusMDIO_0_slave : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMDIO_0_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_0_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_0_slave_shift_register : OUT STD_LOGIC;
                    signal cpu_data_master_requests_iobusMDIO_0_slave : OUT STD_LOGIC;
                    signal d1_iobusMDIO_0_slave_end_xfer : OUT STD_LOGIC;
                    signal iobusMDIO_0_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal iobusMDIO_0_slave_read : OUT STD_LOGIC;
                    signal iobusMDIO_0_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_0_slave_reset : OUT STD_LOGIC;
                    signal iobusMDIO_0_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal iobusMDIO_0_slave_write : OUT STD_LOGIC;
                    signal iobusMDIO_0_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMDIO_0_slave_arbitrator;

component iobusMDIO_0 is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal mmaddress : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal mmread : IN STD_LOGIC;
                    signal mmwrite : IN STD_LOGIC;
                    signal mmwritedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rst : IN STD_LOGIC;
                    signal s_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid : IN STD_LOGIC;
                    signal s_waitrequest : IN STD_LOGIC;

                 -- outputs:
                    signal mmreaddata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal mmreaddatavalid : OUT STD_LOGIC;
                    signal mmwaitrequest : OUT STD_LOGIC;
                    signal s_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal s_clk : OUT STD_LOGIC;
                    signal s_read : OUT STD_LOGIC;
                    signal s_rst : OUT STD_LOGIC;
                    signal s_write : OUT STD_LOGIC;
                    signal s_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMDIO_0;

component iobusMDIO_1_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_1_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_1_slave_readdatavalid : IN STD_LOGIC;
                    signal iobusMDIO_1_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_iobusMDIO_1_slave : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMDIO_1_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_1_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_1_slave_shift_register : OUT STD_LOGIC;
                    signal cpu_data_master_requests_iobusMDIO_1_slave : OUT STD_LOGIC;
                    signal d1_iobusMDIO_1_slave_end_xfer : OUT STD_LOGIC;
                    signal iobusMDIO_1_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal iobusMDIO_1_slave_read : OUT STD_LOGIC;
                    signal iobusMDIO_1_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_1_slave_reset : OUT STD_LOGIC;
                    signal iobusMDIO_1_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal iobusMDIO_1_slave_write : OUT STD_LOGIC;
                    signal iobusMDIO_1_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMDIO_1_slave_arbitrator;

component iobusMDIO_1 is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal mmaddress : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal mmread : IN STD_LOGIC;
                    signal mmwrite : IN STD_LOGIC;
                    signal mmwritedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rst : IN STD_LOGIC;
                    signal s_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid : IN STD_LOGIC;
                    signal s_waitrequest : IN STD_LOGIC;

                 -- outputs:
                    signal mmreaddata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal mmreaddatavalid : OUT STD_LOGIC;
                    signal mmwaitrequest : OUT STD_LOGIC;
                    signal s_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal s_clk : OUT STD_LOGIC;
                    signal s_read : OUT STD_LOGIC;
                    signal s_rst : OUT STD_LOGIC;
                    signal s_write : OUT STD_LOGIC;
                    signal s_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMDIO_1;

component iobusMDIO_2_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_2_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_2_slave_readdatavalid : IN STD_LOGIC;
                    signal iobusMDIO_2_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_iobusMDIO_2_slave : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMDIO_2_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_2_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_2_slave_shift_register : OUT STD_LOGIC;
                    signal cpu_data_master_requests_iobusMDIO_2_slave : OUT STD_LOGIC;
                    signal d1_iobusMDIO_2_slave_end_xfer : OUT STD_LOGIC;
                    signal iobusMDIO_2_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal iobusMDIO_2_slave_read : OUT STD_LOGIC;
                    signal iobusMDIO_2_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_2_slave_reset : OUT STD_LOGIC;
                    signal iobusMDIO_2_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal iobusMDIO_2_slave_write : OUT STD_LOGIC;
                    signal iobusMDIO_2_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMDIO_2_slave_arbitrator;

component iobusMDIO_2 is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal mmaddress : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal mmread : IN STD_LOGIC;
                    signal mmwrite : IN STD_LOGIC;
                    signal mmwritedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rst : IN STD_LOGIC;
                    signal s_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid : IN STD_LOGIC;
                    signal s_waitrequest : IN STD_LOGIC;

                 -- outputs:
                    signal mmreaddata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal mmreaddatavalid : OUT STD_LOGIC;
                    signal mmwaitrequest : OUT STD_LOGIC;
                    signal s_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal s_clk : OUT STD_LOGIC;
                    signal s_read : OUT STD_LOGIC;
                    signal s_rst : OUT STD_LOGIC;
                    signal s_write : OUT STD_LOGIC;
                    signal s_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMDIO_2;

component iobusMDIO_3_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_3_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_3_slave_readdatavalid : IN STD_LOGIC;
                    signal iobusMDIO_3_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_iobusMDIO_3_slave : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMDIO_3_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_3_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_3_slave_shift_register : OUT STD_LOGIC;
                    signal cpu_data_master_requests_iobusMDIO_3_slave : OUT STD_LOGIC;
                    signal d1_iobusMDIO_3_slave_end_xfer : OUT STD_LOGIC;
                    signal iobusMDIO_3_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal iobusMDIO_3_slave_read : OUT STD_LOGIC;
                    signal iobusMDIO_3_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_3_slave_reset : OUT STD_LOGIC;
                    signal iobusMDIO_3_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal iobusMDIO_3_slave_write : OUT STD_LOGIC;
                    signal iobusMDIO_3_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMDIO_3_slave_arbitrator;

component iobusMDIO_3 is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal mmaddress : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal mmread : IN STD_LOGIC;
                    signal mmwrite : IN STD_LOGIC;
                    signal mmwritedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rst : IN STD_LOGIC;
                    signal s_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid : IN STD_LOGIC;
                    signal s_waitrequest : IN STD_LOGIC;

                 -- outputs:
                    signal mmreaddata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal mmreaddatavalid : OUT STD_LOGIC;
                    signal mmwaitrequest : OUT STD_LOGIC;
                    signal s_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal s_clk : OUT STD_LOGIC;
                    signal s_read : OUT STD_LOGIC;
                    signal s_rst : OUT STD_LOGIC;
                    signal s_write : OUT STD_LOGIC;
                    signal s_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMDIO_3;

component iobusMDIO_4_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_4_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_4_slave_readdatavalid : IN STD_LOGIC;
                    signal iobusMDIO_4_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_iobusMDIO_4_slave : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMDIO_4_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_4_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_4_slave_shift_register : OUT STD_LOGIC;
                    signal cpu_data_master_requests_iobusMDIO_4_slave : OUT STD_LOGIC;
                    signal d1_iobusMDIO_4_slave_end_xfer : OUT STD_LOGIC;
                    signal iobusMDIO_4_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal iobusMDIO_4_slave_read : OUT STD_LOGIC;
                    signal iobusMDIO_4_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_4_slave_reset : OUT STD_LOGIC;
                    signal iobusMDIO_4_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal iobusMDIO_4_slave_write : OUT STD_LOGIC;
                    signal iobusMDIO_4_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMDIO_4_slave_arbitrator;

component iobusMDIO_4 is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal mmaddress : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal mmread : IN STD_LOGIC;
                    signal mmwrite : IN STD_LOGIC;
                    signal mmwritedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rst : IN STD_LOGIC;
                    signal s_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid : IN STD_LOGIC;
                    signal s_waitrequest : IN STD_LOGIC;

                 -- outputs:
                    signal mmreaddata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal mmreaddatavalid : OUT STD_LOGIC;
                    signal mmwaitrequest : OUT STD_LOGIC;
                    signal s_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal s_clk : OUT STD_LOGIC;
                    signal s_read : OUT STD_LOGIC;
                    signal s_rst : OUT STD_LOGIC;
                    signal s_write : OUT STD_LOGIC;
                    signal s_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMDIO_4;

component iobusMDIO_5_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_5_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_5_slave_readdatavalid : IN STD_LOGIC;
                    signal iobusMDIO_5_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_iobusMDIO_5_slave : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMDIO_5_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_5_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_5_slave_shift_register : OUT STD_LOGIC;
                    signal cpu_data_master_requests_iobusMDIO_5_slave : OUT STD_LOGIC;
                    signal d1_iobusMDIO_5_slave_end_xfer : OUT STD_LOGIC;
                    signal iobusMDIO_5_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal iobusMDIO_5_slave_read : OUT STD_LOGIC;
                    signal iobusMDIO_5_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_5_slave_reset : OUT STD_LOGIC;
                    signal iobusMDIO_5_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal iobusMDIO_5_slave_write : OUT STD_LOGIC;
                    signal iobusMDIO_5_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMDIO_5_slave_arbitrator;

component iobusMDIO_5 is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal mmaddress : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal mmread : IN STD_LOGIC;
                    signal mmwrite : IN STD_LOGIC;
                    signal mmwritedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rst : IN STD_LOGIC;
                    signal s_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid : IN STD_LOGIC;
                    signal s_waitrequest : IN STD_LOGIC;

                 -- outputs:
                    signal mmreaddata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal mmreaddatavalid : OUT STD_LOGIC;
                    signal mmwaitrequest : OUT STD_LOGIC;
                    signal s_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal s_clk : OUT STD_LOGIC;
                    signal s_read : OUT STD_LOGIC;
                    signal s_rst : OUT STD_LOGIC;
                    signal s_write : OUT STD_LOGIC;
                    signal s_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMDIO_5;

component iobusMDIO_6_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_6_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_6_slave_readdatavalid : IN STD_LOGIC;
                    signal iobusMDIO_6_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_iobusMDIO_6_slave : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMDIO_6_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_6_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_6_slave_shift_register : OUT STD_LOGIC;
                    signal cpu_data_master_requests_iobusMDIO_6_slave : OUT STD_LOGIC;
                    signal d1_iobusMDIO_6_slave_end_xfer : OUT STD_LOGIC;
                    signal iobusMDIO_6_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal iobusMDIO_6_slave_read : OUT STD_LOGIC;
                    signal iobusMDIO_6_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_6_slave_reset : OUT STD_LOGIC;
                    signal iobusMDIO_6_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal iobusMDIO_6_slave_write : OUT STD_LOGIC;
                    signal iobusMDIO_6_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMDIO_6_slave_arbitrator;

component iobusMDIO_6 is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal mmaddress : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal mmread : IN STD_LOGIC;
                    signal mmwrite : IN STD_LOGIC;
                    signal mmwritedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rst : IN STD_LOGIC;
                    signal s_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid : IN STD_LOGIC;
                    signal s_waitrequest : IN STD_LOGIC;

                 -- outputs:
                    signal mmreaddata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal mmreaddatavalid : OUT STD_LOGIC;
                    signal mmwaitrequest : OUT STD_LOGIC;
                    signal s_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal s_clk : OUT STD_LOGIC;
                    signal s_read : OUT STD_LOGIC;
                    signal s_rst : OUT STD_LOGIC;
                    signal s_write : OUT STD_LOGIC;
                    signal s_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMDIO_6;

component iobusMDIO_7_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_7_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_7_slave_readdatavalid : IN STD_LOGIC;
                    signal iobusMDIO_7_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_iobusMDIO_7_slave : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusMDIO_7_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_7_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusMDIO_7_slave_shift_register : OUT STD_LOGIC;
                    signal cpu_data_master_requests_iobusMDIO_7_slave : OUT STD_LOGIC;
                    signal d1_iobusMDIO_7_slave_end_xfer : OUT STD_LOGIC;
                    signal iobusMDIO_7_slave_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal iobusMDIO_7_slave_read : OUT STD_LOGIC;
                    signal iobusMDIO_7_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusMDIO_7_slave_reset : OUT STD_LOGIC;
                    signal iobusMDIO_7_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal iobusMDIO_7_slave_write : OUT STD_LOGIC;
                    signal iobusMDIO_7_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMDIO_7_slave_arbitrator;

component iobusMDIO_7 is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal mmaddress : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal mmread : IN STD_LOGIC;
                    signal mmwrite : IN STD_LOGIC;
                    signal mmwritedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rst : IN STD_LOGIC;
                    signal s_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid : IN STD_LOGIC;
                    signal s_waitrequest : IN STD_LOGIC;

                 -- outputs:
                    signal mmreaddata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal mmreaddatavalid : OUT STD_LOGIC;
                    signal mmwaitrequest : OUT STD_LOGIC;
                    signal s_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal s_clk : OUT STD_LOGIC;
                    signal s_read : OUT STD_LOGIC;
                    signal s_rst : OUT STD_LOGIC;
                    signal s_write : OUT STD_LOGIC;
                    signal s_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusMDIO_7;

component iobusREGFILE_0_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusREGFILE_0_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusREGFILE_0_slave_readdatavalid : IN STD_LOGIC;
                    signal iobusREGFILE_0_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_iobusREGFILE_0_slave : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_iobusREGFILE_0_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusREGFILE_0_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_iobusREGFILE_0_slave_shift_register : OUT STD_LOGIC;
                    signal cpu_data_master_requests_iobusREGFILE_0_slave : OUT STD_LOGIC;
                    signal d1_iobusREGFILE_0_slave_end_xfer : OUT STD_LOGIC;
                    signal iobusREGFILE_0_slave_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal iobusREGFILE_0_slave_read : OUT STD_LOGIC;
                    signal iobusREGFILE_0_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal iobusREGFILE_0_slave_reset : OUT STD_LOGIC;
                    signal iobusREGFILE_0_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal iobusREGFILE_0_slave_write : OUT STD_LOGIC;
                    signal iobusREGFILE_0_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusREGFILE_0_slave_arbitrator;

component iobusREGFILE_0 is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal mmaddress : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal mmread : IN STD_LOGIC;
                    signal mmwrite : IN STD_LOGIC;
                    signal mmwritedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal rst : IN STD_LOGIC;
                    signal s_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid : IN STD_LOGIC;
                    signal s_waitrequest : IN STD_LOGIC;

                 -- outputs:
                    signal mmreaddata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal mmreaddatavalid : OUT STD_LOGIC;
                    signal mmwaitrequest : OUT STD_LOGIC;
                    signal s_address : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal s_clk : OUT STD_LOGIC;
                    signal s_read : OUT STD_LOGIC;
                    signal s_rst : OUT STD_LOGIC;
                    signal s_write : OUT STD_LOGIC;
                    signal s_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component iobusREGFILE_0;

component jtag_uart_avalon_jtag_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_avalon_jtag_slave_dataavailable : IN STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_irq : IN STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_avalon_jtag_slave_readyfordata : IN STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                    signal cpu_data_master_requests_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                    signal d1_jtag_uart_avalon_jtag_slave_end_xfer : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_address : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_chipselect : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_dataavailable_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_irq_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_read_n : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_avalon_jtag_slave_readyfordata_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_reset_n : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_write_n : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component jtag_uart_avalon_jtag_slave_arbitrator;

component jtag_uart is 
           port (
                 -- inputs:
                    signal av_address : IN STD_LOGIC;
                    signal av_chipselect : IN STD_LOGIC;
                    signal av_read_n : IN STD_LOGIC;
                    signal av_write_n : IN STD_LOGIC;
                    signal av_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal rst_n : IN STD_LOGIC;

                 -- outputs:
                    signal av_irq : OUT STD_LOGIC;
                    signal av_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal av_waitrequest : OUT STD_LOGIC;
                    signal dataavailable : OUT STD_LOGIC;
                    signal readyfordata : OUT STD_LOGIC
                 );
end component jtag_uart;

component mem_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_instruction_master_read : IN STD_LOGIC;
                    signal mem_s1_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_mem_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_mem_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_mem_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_requests_mem_s1 : OUT STD_LOGIC;
                    signal cpu_instruction_master_granted_mem_s1 : OUT STD_LOGIC;
                    signal cpu_instruction_master_qualified_request_mem_s1 : OUT STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_mem_s1 : OUT STD_LOGIC;
                    signal cpu_instruction_master_requests_mem_s1 : OUT STD_LOGIC;
                    signal d1_mem_s1_end_xfer : OUT STD_LOGIC;
                    signal mem_s1_address : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
                    signal mem_s1_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal mem_s1_chipselect : OUT STD_LOGIC;
                    signal mem_s1_clken : OUT STD_LOGIC;
                    signal mem_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal mem_s1_write : OUT STD_LOGIC;
                    signal mem_s1_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal registered_cpu_data_master_read_data_valid_mem_s1 : OUT STD_LOGIC
                 );
end component mem_s1_arbitrator;

component mem is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (10 DOWNTO 0);
                    signal byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal clken : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- outputs:
                    signal readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component mem;

component rs232_uart_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (13 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;
                    signal rs232_uart_s1_dataavailable : IN STD_LOGIC;
                    signal rs232_uart_s1_irq : IN STD_LOGIC;
                    signal rs232_uart_s1_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal rs232_uart_s1_readyfordata : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_rs232_uart_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_rs232_uart_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_rs232_uart_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_requests_rs232_uart_s1 : OUT STD_LOGIC;
                    signal d1_rs232_uart_s1_end_xfer : OUT STD_LOGIC;
                    signal rs232_uart_s1_address : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal rs232_uart_s1_begintransfer : OUT STD_LOGIC;
                    signal rs232_uart_s1_chipselect : OUT STD_LOGIC;
                    signal rs232_uart_s1_dataavailable_from_sa : OUT STD_LOGIC;
                    signal rs232_uart_s1_irq_from_sa : OUT STD_LOGIC;
                    signal rs232_uart_s1_read_n : OUT STD_LOGIC;
                    signal rs232_uart_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal rs232_uart_s1_readyfordata_from_sa : OUT STD_LOGIC;
                    signal rs232_uart_s1_reset_n : OUT STD_LOGIC;
                    signal rs232_uart_s1_write_n : OUT STD_LOGIC;
                    signal rs232_uart_s1_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component rs232_uart_s1_arbitrator;

component rs232_uart is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
                    signal begintransfer : IN STD_LOGIC;
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal read_n : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal rxd : IN STD_LOGIC;
                    signal write_n : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal dataavailable : OUT STD_LOGIC;
                    signal irq : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal readyfordata : OUT STD_LOGIC;
                    signal txd : OUT STD_LOGIC
                 );
end component rs232_uart;

component nios_reset_clk1_domain_synch_module is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC
                 );
end component nios_reset_clk1_domain_synch_module;

                signal clk1_reset_n :  STD_LOGIC;
                signal cpu_data_master_address :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal cpu_data_master_address_to_slave :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal cpu_data_master_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cpu_data_master_debugaccess :  STD_LOGIC;
                signal cpu_data_master_granted_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_data_master_granted_iobusMAC_0_slave :  STD_LOGIC;
                signal cpu_data_master_granted_iobusMAC_1_slave :  STD_LOGIC;
                signal cpu_data_master_granted_iobusMAC_2_slave :  STD_LOGIC;
                signal cpu_data_master_granted_iobusMAC_3_slave :  STD_LOGIC;
                signal cpu_data_master_granted_iobusMAC_4_slave :  STD_LOGIC;
                signal cpu_data_master_granted_iobusMAC_5_slave :  STD_LOGIC;
                signal cpu_data_master_granted_iobusMAC_6_slave :  STD_LOGIC;
                signal cpu_data_master_granted_iobusMAC_7_slave :  STD_LOGIC;
                signal cpu_data_master_granted_iobusMDIO_0_slave :  STD_LOGIC;
                signal cpu_data_master_granted_iobusMDIO_1_slave :  STD_LOGIC;
                signal cpu_data_master_granted_iobusMDIO_2_slave :  STD_LOGIC;
                signal cpu_data_master_granted_iobusMDIO_3_slave :  STD_LOGIC;
                signal cpu_data_master_granted_iobusMDIO_4_slave :  STD_LOGIC;
                signal cpu_data_master_granted_iobusMDIO_5_slave :  STD_LOGIC;
                signal cpu_data_master_granted_iobusMDIO_6_slave :  STD_LOGIC;
                signal cpu_data_master_granted_iobusMDIO_7_slave :  STD_LOGIC;
                signal cpu_data_master_granted_iobusREGFILE_0_slave :  STD_LOGIC;
                signal cpu_data_master_granted_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_data_master_granted_mem_s1 :  STD_LOGIC;
                signal cpu_data_master_granted_rs232_uart_s1 :  STD_LOGIC;
                signal cpu_data_master_irq :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_data_master_qualified_request_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_data_master_qualified_request_iobusMAC_0_slave :  STD_LOGIC;
                signal cpu_data_master_qualified_request_iobusMAC_1_slave :  STD_LOGIC;
                signal cpu_data_master_qualified_request_iobusMAC_2_slave :  STD_LOGIC;
                signal cpu_data_master_qualified_request_iobusMAC_3_slave :  STD_LOGIC;
                signal cpu_data_master_qualified_request_iobusMAC_4_slave :  STD_LOGIC;
                signal cpu_data_master_qualified_request_iobusMAC_5_slave :  STD_LOGIC;
                signal cpu_data_master_qualified_request_iobusMAC_6_slave :  STD_LOGIC;
                signal cpu_data_master_qualified_request_iobusMAC_7_slave :  STD_LOGIC;
                signal cpu_data_master_qualified_request_iobusMDIO_0_slave :  STD_LOGIC;
                signal cpu_data_master_qualified_request_iobusMDIO_1_slave :  STD_LOGIC;
                signal cpu_data_master_qualified_request_iobusMDIO_2_slave :  STD_LOGIC;
                signal cpu_data_master_qualified_request_iobusMDIO_3_slave :  STD_LOGIC;
                signal cpu_data_master_qualified_request_iobusMDIO_4_slave :  STD_LOGIC;
                signal cpu_data_master_qualified_request_iobusMDIO_5_slave :  STD_LOGIC;
                signal cpu_data_master_qualified_request_iobusMDIO_6_slave :  STD_LOGIC;
                signal cpu_data_master_qualified_request_iobusMDIO_7_slave :  STD_LOGIC;
                signal cpu_data_master_qualified_request_iobusREGFILE_0_slave :  STD_LOGIC;
                signal cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_data_master_qualified_request_mem_s1 :  STD_LOGIC;
                signal cpu_data_master_qualified_request_rs232_uart_s1 :  STD_LOGIC;
                signal cpu_data_master_read :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMAC_0_slave :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMAC_0_slave_shift_register :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMAC_1_slave :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMAC_1_slave_shift_register :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMAC_2_slave :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMAC_2_slave_shift_register :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMAC_3_slave :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMAC_3_slave_shift_register :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMAC_4_slave :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMAC_4_slave_shift_register :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMAC_5_slave :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMAC_5_slave_shift_register :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMAC_6_slave :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMAC_6_slave_shift_register :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMAC_7_slave :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMAC_7_slave_shift_register :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMDIO_0_slave :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMDIO_0_slave_shift_register :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMDIO_1_slave :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMDIO_1_slave_shift_register :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMDIO_2_slave :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMDIO_2_slave_shift_register :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMDIO_3_slave :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMDIO_3_slave_shift_register :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMDIO_4_slave :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMDIO_4_slave_shift_register :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMDIO_5_slave :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMDIO_5_slave_shift_register :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMDIO_6_slave :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMDIO_6_slave_shift_register :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMDIO_7_slave :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusMDIO_7_slave_shift_register :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusREGFILE_0_slave :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_iobusREGFILE_0_slave_shift_register :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_mem_s1 :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_rs232_uart_s1 :  STD_LOGIC;
                signal cpu_data_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_data_master_requests_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_data_master_requests_iobusMAC_0_slave :  STD_LOGIC;
                signal cpu_data_master_requests_iobusMAC_1_slave :  STD_LOGIC;
                signal cpu_data_master_requests_iobusMAC_2_slave :  STD_LOGIC;
                signal cpu_data_master_requests_iobusMAC_3_slave :  STD_LOGIC;
                signal cpu_data_master_requests_iobusMAC_4_slave :  STD_LOGIC;
                signal cpu_data_master_requests_iobusMAC_5_slave :  STD_LOGIC;
                signal cpu_data_master_requests_iobusMAC_6_slave :  STD_LOGIC;
                signal cpu_data_master_requests_iobusMAC_7_slave :  STD_LOGIC;
                signal cpu_data_master_requests_iobusMDIO_0_slave :  STD_LOGIC;
                signal cpu_data_master_requests_iobusMDIO_1_slave :  STD_LOGIC;
                signal cpu_data_master_requests_iobusMDIO_2_slave :  STD_LOGIC;
                signal cpu_data_master_requests_iobusMDIO_3_slave :  STD_LOGIC;
                signal cpu_data_master_requests_iobusMDIO_4_slave :  STD_LOGIC;
                signal cpu_data_master_requests_iobusMDIO_5_slave :  STD_LOGIC;
                signal cpu_data_master_requests_iobusMDIO_6_slave :  STD_LOGIC;
                signal cpu_data_master_requests_iobusMDIO_7_slave :  STD_LOGIC;
                signal cpu_data_master_requests_iobusREGFILE_0_slave :  STD_LOGIC;
                signal cpu_data_master_requests_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_data_master_requests_mem_s1 :  STD_LOGIC;
                signal cpu_data_master_requests_rs232_uart_s1 :  STD_LOGIC;
                signal cpu_data_master_waitrequest :  STD_LOGIC;
                signal cpu_data_master_write :  STD_LOGIC;
                signal cpu_data_master_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_instruction_master_address :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal cpu_instruction_master_address_to_slave :  STD_LOGIC_VECTOR (13 DOWNTO 0);
                signal cpu_instruction_master_granted_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_instruction_master_granted_mem_s1 :  STD_LOGIC;
                signal cpu_instruction_master_qualified_request_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_instruction_master_qualified_request_mem_s1 :  STD_LOGIC;
                signal cpu_instruction_master_read :  STD_LOGIC;
                signal cpu_instruction_master_read_data_valid_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_instruction_master_read_data_valid_mem_s1 :  STD_LOGIC;
                signal cpu_instruction_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_instruction_master_requests_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_instruction_master_requests_mem_s1 :  STD_LOGIC;
                signal cpu_instruction_master_waitrequest :  STD_LOGIC;
                signal cpu_jtag_debug_module_address :  STD_LOGIC_VECTOR (8 DOWNTO 0);
                signal cpu_jtag_debug_module_begintransfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cpu_jtag_debug_module_chipselect :  STD_LOGIC;
                signal cpu_jtag_debug_module_debugaccess :  STD_LOGIC;
                signal cpu_jtag_debug_module_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_jtag_debug_module_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_jtag_debug_module_reset_n :  STD_LOGIC;
                signal cpu_jtag_debug_module_resetrequest :  STD_LOGIC;
                signal cpu_jtag_debug_module_resetrequest_from_sa :  STD_LOGIC;
                signal cpu_jtag_debug_module_write :  STD_LOGIC;
                signal cpu_jtag_debug_module_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal d1_cpu_jtag_debug_module_end_xfer :  STD_LOGIC;
                signal d1_iobusMAC_0_slave_end_xfer :  STD_LOGIC;
                signal d1_iobusMAC_1_slave_end_xfer :  STD_LOGIC;
                signal d1_iobusMAC_2_slave_end_xfer :  STD_LOGIC;
                signal d1_iobusMAC_3_slave_end_xfer :  STD_LOGIC;
                signal d1_iobusMAC_4_slave_end_xfer :  STD_LOGIC;
                signal d1_iobusMAC_5_slave_end_xfer :  STD_LOGIC;
                signal d1_iobusMAC_6_slave_end_xfer :  STD_LOGIC;
                signal d1_iobusMAC_7_slave_end_xfer :  STD_LOGIC;
                signal d1_iobusMDIO_0_slave_end_xfer :  STD_LOGIC;
                signal d1_iobusMDIO_1_slave_end_xfer :  STD_LOGIC;
                signal d1_iobusMDIO_2_slave_end_xfer :  STD_LOGIC;
                signal d1_iobusMDIO_3_slave_end_xfer :  STD_LOGIC;
                signal d1_iobusMDIO_4_slave_end_xfer :  STD_LOGIC;
                signal d1_iobusMDIO_5_slave_end_xfer :  STD_LOGIC;
                signal d1_iobusMDIO_6_slave_end_xfer :  STD_LOGIC;
                signal d1_iobusMDIO_7_slave_end_xfer :  STD_LOGIC;
                signal d1_iobusREGFILE_0_slave_end_xfer :  STD_LOGIC;
                signal d1_jtag_uart_avalon_jtag_slave_end_xfer :  STD_LOGIC;
                signal d1_mem_s1_end_xfer :  STD_LOGIC;
                signal d1_rs232_uart_s1_end_xfer :  STD_LOGIC;
                signal internal_s_address_from_the_iobusMAC_0 :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal internal_s_address_from_the_iobusMAC_1 :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal internal_s_address_from_the_iobusMAC_2 :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal internal_s_address_from_the_iobusMAC_3 :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal internal_s_address_from_the_iobusMAC_4 :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal internal_s_address_from_the_iobusMAC_5 :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal internal_s_address_from_the_iobusMAC_6 :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal internal_s_address_from_the_iobusMAC_7 :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal internal_s_address_from_the_iobusMDIO_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_s_address_from_the_iobusMDIO_1 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_s_address_from_the_iobusMDIO_2 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_s_address_from_the_iobusMDIO_3 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_s_address_from_the_iobusMDIO_4 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_s_address_from_the_iobusMDIO_5 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_s_address_from_the_iobusMDIO_6 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_s_address_from_the_iobusMDIO_7 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_s_address_from_the_iobusREGFILE_0 :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal internal_s_clk_from_the_iobusMAC_0 :  STD_LOGIC;
                signal internal_s_clk_from_the_iobusMAC_1 :  STD_LOGIC;
                signal internal_s_clk_from_the_iobusMAC_2 :  STD_LOGIC;
                signal internal_s_clk_from_the_iobusMAC_3 :  STD_LOGIC;
                signal internal_s_clk_from_the_iobusMAC_4 :  STD_LOGIC;
                signal internal_s_clk_from_the_iobusMAC_5 :  STD_LOGIC;
                signal internal_s_clk_from_the_iobusMAC_6 :  STD_LOGIC;
                signal internal_s_clk_from_the_iobusMAC_7 :  STD_LOGIC;
                signal internal_s_clk_from_the_iobusMDIO_0 :  STD_LOGIC;
                signal internal_s_clk_from_the_iobusMDIO_1 :  STD_LOGIC;
                signal internal_s_clk_from_the_iobusMDIO_2 :  STD_LOGIC;
                signal internal_s_clk_from_the_iobusMDIO_3 :  STD_LOGIC;
                signal internal_s_clk_from_the_iobusMDIO_4 :  STD_LOGIC;
                signal internal_s_clk_from_the_iobusMDIO_5 :  STD_LOGIC;
                signal internal_s_clk_from_the_iobusMDIO_6 :  STD_LOGIC;
                signal internal_s_clk_from_the_iobusMDIO_7 :  STD_LOGIC;
                signal internal_s_clk_from_the_iobusREGFILE_0 :  STD_LOGIC;
                signal internal_s_read_from_the_iobusMAC_0 :  STD_LOGIC;
                signal internal_s_read_from_the_iobusMAC_1 :  STD_LOGIC;
                signal internal_s_read_from_the_iobusMAC_2 :  STD_LOGIC;
                signal internal_s_read_from_the_iobusMAC_3 :  STD_LOGIC;
                signal internal_s_read_from_the_iobusMAC_4 :  STD_LOGIC;
                signal internal_s_read_from_the_iobusMAC_5 :  STD_LOGIC;
                signal internal_s_read_from_the_iobusMAC_6 :  STD_LOGIC;
                signal internal_s_read_from_the_iobusMAC_7 :  STD_LOGIC;
                signal internal_s_read_from_the_iobusMDIO_0 :  STD_LOGIC;
                signal internal_s_read_from_the_iobusMDIO_1 :  STD_LOGIC;
                signal internal_s_read_from_the_iobusMDIO_2 :  STD_LOGIC;
                signal internal_s_read_from_the_iobusMDIO_3 :  STD_LOGIC;
                signal internal_s_read_from_the_iobusMDIO_4 :  STD_LOGIC;
                signal internal_s_read_from_the_iobusMDIO_5 :  STD_LOGIC;
                signal internal_s_read_from_the_iobusMDIO_6 :  STD_LOGIC;
                signal internal_s_read_from_the_iobusMDIO_7 :  STD_LOGIC;
                signal internal_s_read_from_the_iobusREGFILE_0 :  STD_LOGIC;
                signal internal_s_rst_from_the_iobusMAC_0 :  STD_LOGIC;
                signal internal_s_rst_from_the_iobusMAC_1 :  STD_LOGIC;
                signal internal_s_rst_from_the_iobusMAC_2 :  STD_LOGIC;
                signal internal_s_rst_from_the_iobusMAC_3 :  STD_LOGIC;
                signal internal_s_rst_from_the_iobusMAC_4 :  STD_LOGIC;
                signal internal_s_rst_from_the_iobusMAC_5 :  STD_LOGIC;
                signal internal_s_rst_from_the_iobusMAC_6 :  STD_LOGIC;
                signal internal_s_rst_from_the_iobusMAC_7 :  STD_LOGIC;
                signal internal_s_rst_from_the_iobusMDIO_0 :  STD_LOGIC;
                signal internal_s_rst_from_the_iobusMDIO_1 :  STD_LOGIC;
                signal internal_s_rst_from_the_iobusMDIO_2 :  STD_LOGIC;
                signal internal_s_rst_from_the_iobusMDIO_3 :  STD_LOGIC;
                signal internal_s_rst_from_the_iobusMDIO_4 :  STD_LOGIC;
                signal internal_s_rst_from_the_iobusMDIO_5 :  STD_LOGIC;
                signal internal_s_rst_from_the_iobusMDIO_6 :  STD_LOGIC;
                signal internal_s_rst_from_the_iobusMDIO_7 :  STD_LOGIC;
                signal internal_s_rst_from_the_iobusREGFILE_0 :  STD_LOGIC;
                signal internal_s_write_from_the_iobusMAC_0 :  STD_LOGIC;
                signal internal_s_write_from_the_iobusMAC_1 :  STD_LOGIC;
                signal internal_s_write_from_the_iobusMAC_2 :  STD_LOGIC;
                signal internal_s_write_from_the_iobusMAC_3 :  STD_LOGIC;
                signal internal_s_write_from_the_iobusMAC_4 :  STD_LOGIC;
                signal internal_s_write_from_the_iobusMAC_5 :  STD_LOGIC;
                signal internal_s_write_from_the_iobusMAC_6 :  STD_LOGIC;
                signal internal_s_write_from_the_iobusMAC_7 :  STD_LOGIC;
                signal internal_s_write_from_the_iobusMDIO_0 :  STD_LOGIC;
                signal internal_s_write_from_the_iobusMDIO_1 :  STD_LOGIC;
                signal internal_s_write_from_the_iobusMDIO_2 :  STD_LOGIC;
                signal internal_s_write_from_the_iobusMDIO_3 :  STD_LOGIC;
                signal internal_s_write_from_the_iobusMDIO_4 :  STD_LOGIC;
                signal internal_s_write_from_the_iobusMDIO_5 :  STD_LOGIC;
                signal internal_s_write_from_the_iobusMDIO_6 :  STD_LOGIC;
                signal internal_s_write_from_the_iobusMDIO_7 :  STD_LOGIC;
                signal internal_s_write_from_the_iobusREGFILE_0 :  STD_LOGIC;
                signal internal_s_writedata_from_the_iobusMAC_0 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_s_writedata_from_the_iobusMAC_1 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_s_writedata_from_the_iobusMAC_2 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_s_writedata_from_the_iobusMAC_3 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_s_writedata_from_the_iobusMAC_4 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_s_writedata_from_the_iobusMAC_5 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_s_writedata_from_the_iobusMAC_6 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_s_writedata_from_the_iobusMAC_7 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_s_writedata_from_the_iobusMDIO_0 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_s_writedata_from_the_iobusMDIO_1 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_s_writedata_from_the_iobusMDIO_2 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_s_writedata_from_the_iobusMDIO_3 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_s_writedata_from_the_iobusMDIO_4 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_s_writedata_from_the_iobusMDIO_5 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_s_writedata_from_the_iobusMDIO_6 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_s_writedata_from_the_iobusMDIO_7 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_s_writedata_from_the_iobusREGFILE_0 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal internal_txd_from_the_rs232_uart :  STD_LOGIC;
                signal iobusMAC_0_slave_address :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal iobusMAC_0_slave_read :  STD_LOGIC;
                signal iobusMAC_0_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_0_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_0_slave_readdatavalid :  STD_LOGIC;
                signal iobusMAC_0_slave_reset :  STD_LOGIC;
                signal iobusMAC_0_slave_waitrequest :  STD_LOGIC;
                signal iobusMAC_0_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMAC_0_slave_write :  STD_LOGIC;
                signal iobusMAC_0_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_1_slave_address :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal iobusMAC_1_slave_read :  STD_LOGIC;
                signal iobusMAC_1_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_1_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_1_slave_readdatavalid :  STD_LOGIC;
                signal iobusMAC_1_slave_reset :  STD_LOGIC;
                signal iobusMAC_1_slave_waitrequest :  STD_LOGIC;
                signal iobusMAC_1_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMAC_1_slave_write :  STD_LOGIC;
                signal iobusMAC_1_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_2_slave_address :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal iobusMAC_2_slave_read :  STD_LOGIC;
                signal iobusMAC_2_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_2_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_2_slave_readdatavalid :  STD_LOGIC;
                signal iobusMAC_2_slave_reset :  STD_LOGIC;
                signal iobusMAC_2_slave_waitrequest :  STD_LOGIC;
                signal iobusMAC_2_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMAC_2_slave_write :  STD_LOGIC;
                signal iobusMAC_2_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_3_slave_address :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal iobusMAC_3_slave_read :  STD_LOGIC;
                signal iobusMAC_3_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_3_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_3_slave_readdatavalid :  STD_LOGIC;
                signal iobusMAC_3_slave_reset :  STD_LOGIC;
                signal iobusMAC_3_slave_waitrequest :  STD_LOGIC;
                signal iobusMAC_3_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMAC_3_slave_write :  STD_LOGIC;
                signal iobusMAC_3_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_4_slave_address :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal iobusMAC_4_slave_read :  STD_LOGIC;
                signal iobusMAC_4_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_4_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_4_slave_readdatavalid :  STD_LOGIC;
                signal iobusMAC_4_slave_reset :  STD_LOGIC;
                signal iobusMAC_4_slave_waitrequest :  STD_LOGIC;
                signal iobusMAC_4_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMAC_4_slave_write :  STD_LOGIC;
                signal iobusMAC_4_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_5_slave_address :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal iobusMAC_5_slave_read :  STD_LOGIC;
                signal iobusMAC_5_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_5_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_5_slave_readdatavalid :  STD_LOGIC;
                signal iobusMAC_5_slave_reset :  STD_LOGIC;
                signal iobusMAC_5_slave_waitrequest :  STD_LOGIC;
                signal iobusMAC_5_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMAC_5_slave_write :  STD_LOGIC;
                signal iobusMAC_5_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_6_slave_address :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal iobusMAC_6_slave_read :  STD_LOGIC;
                signal iobusMAC_6_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_6_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_6_slave_readdatavalid :  STD_LOGIC;
                signal iobusMAC_6_slave_reset :  STD_LOGIC;
                signal iobusMAC_6_slave_waitrequest :  STD_LOGIC;
                signal iobusMAC_6_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMAC_6_slave_write :  STD_LOGIC;
                signal iobusMAC_6_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_7_slave_address :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal iobusMAC_7_slave_read :  STD_LOGIC;
                signal iobusMAC_7_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_7_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMAC_7_slave_readdatavalid :  STD_LOGIC;
                signal iobusMAC_7_slave_reset :  STD_LOGIC;
                signal iobusMAC_7_slave_waitrequest :  STD_LOGIC;
                signal iobusMAC_7_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMAC_7_slave_write :  STD_LOGIC;
                signal iobusMAC_7_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_0_slave_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal iobusMDIO_0_slave_read :  STD_LOGIC;
                signal iobusMDIO_0_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_0_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_0_slave_readdatavalid :  STD_LOGIC;
                signal iobusMDIO_0_slave_reset :  STD_LOGIC;
                signal iobusMDIO_0_slave_waitrequest :  STD_LOGIC;
                signal iobusMDIO_0_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMDIO_0_slave_write :  STD_LOGIC;
                signal iobusMDIO_0_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_1_slave_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal iobusMDIO_1_slave_read :  STD_LOGIC;
                signal iobusMDIO_1_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_1_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_1_slave_readdatavalid :  STD_LOGIC;
                signal iobusMDIO_1_slave_reset :  STD_LOGIC;
                signal iobusMDIO_1_slave_waitrequest :  STD_LOGIC;
                signal iobusMDIO_1_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMDIO_1_slave_write :  STD_LOGIC;
                signal iobusMDIO_1_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_2_slave_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal iobusMDIO_2_slave_read :  STD_LOGIC;
                signal iobusMDIO_2_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_2_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_2_slave_readdatavalid :  STD_LOGIC;
                signal iobusMDIO_2_slave_reset :  STD_LOGIC;
                signal iobusMDIO_2_slave_waitrequest :  STD_LOGIC;
                signal iobusMDIO_2_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMDIO_2_slave_write :  STD_LOGIC;
                signal iobusMDIO_2_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_3_slave_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal iobusMDIO_3_slave_read :  STD_LOGIC;
                signal iobusMDIO_3_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_3_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_3_slave_readdatavalid :  STD_LOGIC;
                signal iobusMDIO_3_slave_reset :  STD_LOGIC;
                signal iobusMDIO_3_slave_waitrequest :  STD_LOGIC;
                signal iobusMDIO_3_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMDIO_3_slave_write :  STD_LOGIC;
                signal iobusMDIO_3_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_4_slave_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal iobusMDIO_4_slave_read :  STD_LOGIC;
                signal iobusMDIO_4_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_4_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_4_slave_readdatavalid :  STD_LOGIC;
                signal iobusMDIO_4_slave_reset :  STD_LOGIC;
                signal iobusMDIO_4_slave_waitrequest :  STD_LOGIC;
                signal iobusMDIO_4_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMDIO_4_slave_write :  STD_LOGIC;
                signal iobusMDIO_4_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_5_slave_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal iobusMDIO_5_slave_read :  STD_LOGIC;
                signal iobusMDIO_5_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_5_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_5_slave_readdatavalid :  STD_LOGIC;
                signal iobusMDIO_5_slave_reset :  STD_LOGIC;
                signal iobusMDIO_5_slave_waitrequest :  STD_LOGIC;
                signal iobusMDIO_5_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMDIO_5_slave_write :  STD_LOGIC;
                signal iobusMDIO_5_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_6_slave_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal iobusMDIO_6_slave_read :  STD_LOGIC;
                signal iobusMDIO_6_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_6_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_6_slave_readdatavalid :  STD_LOGIC;
                signal iobusMDIO_6_slave_reset :  STD_LOGIC;
                signal iobusMDIO_6_slave_waitrequest :  STD_LOGIC;
                signal iobusMDIO_6_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMDIO_6_slave_write :  STD_LOGIC;
                signal iobusMDIO_6_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_7_slave_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal iobusMDIO_7_slave_read :  STD_LOGIC;
                signal iobusMDIO_7_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_7_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusMDIO_7_slave_readdatavalid :  STD_LOGIC;
                signal iobusMDIO_7_slave_reset :  STD_LOGIC;
                signal iobusMDIO_7_slave_waitrequest :  STD_LOGIC;
                signal iobusMDIO_7_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusMDIO_7_slave_write :  STD_LOGIC;
                signal iobusMDIO_7_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusREGFILE_0_slave_address :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal iobusREGFILE_0_slave_read :  STD_LOGIC;
                signal iobusREGFILE_0_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusREGFILE_0_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal iobusREGFILE_0_slave_readdatavalid :  STD_LOGIC;
                signal iobusREGFILE_0_slave_reset :  STD_LOGIC;
                signal iobusREGFILE_0_slave_waitrequest :  STD_LOGIC;
                signal iobusREGFILE_0_slave_waitrequest_from_sa :  STD_LOGIC;
                signal iobusREGFILE_0_slave_write :  STD_LOGIC;
                signal iobusREGFILE_0_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal jtag_uart_avalon_jtag_slave_address :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_chipselect :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_dataavailable :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_dataavailable_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_irq :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_irq_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_read_n :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal jtag_uart_avalon_jtag_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal jtag_uart_avalon_jtag_slave_readyfordata :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_readyfordata_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_reset_n :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_waitrequest :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_waitrequest_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_write_n :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal mem_s1_address :  STD_LOGIC_VECTOR (10 DOWNTO 0);
                signal mem_s1_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal mem_s1_chipselect :  STD_LOGIC;
                signal mem_s1_clken :  STD_LOGIC;
                signal mem_s1_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal mem_s1_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal mem_s1_write :  STD_LOGIC;
                signal mem_s1_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal module_input51 :  STD_LOGIC;
                signal registered_cpu_data_master_read_data_valid_mem_s1 :  STD_LOGIC;
                signal reset_n_sources :  STD_LOGIC;
                signal rs232_uart_s1_address :  STD_LOGIC_VECTOR (2 DOWNTO 0);
                signal rs232_uart_s1_begintransfer :  STD_LOGIC;
                signal rs232_uart_s1_chipselect :  STD_LOGIC;
                signal rs232_uart_s1_dataavailable :  STD_LOGIC;
                signal rs232_uart_s1_dataavailable_from_sa :  STD_LOGIC;
                signal rs232_uart_s1_irq :  STD_LOGIC;
                signal rs232_uart_s1_irq_from_sa :  STD_LOGIC;
                signal rs232_uart_s1_read_n :  STD_LOGIC;
                signal rs232_uart_s1_readdata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal rs232_uart_s1_readdata_from_sa :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal rs232_uart_s1_readyfordata :  STD_LOGIC;
                signal rs232_uart_s1_readyfordata_from_sa :  STD_LOGIC;
                signal rs232_uart_s1_reset_n :  STD_LOGIC;
                signal rs232_uart_s1_write_n :  STD_LOGIC;
                signal rs232_uart_s1_writedata :  STD_LOGIC_VECTOR (15 DOWNTO 0);

begin

  --the_cpu_jtag_debug_module, which is an e_instance
  the_cpu_jtag_debug_module : cpu_jtag_debug_module_arbitrator
    port map(
      cpu_data_master_granted_cpu_jtag_debug_module => cpu_data_master_granted_cpu_jtag_debug_module,
      cpu_data_master_qualified_request_cpu_jtag_debug_module => cpu_data_master_qualified_request_cpu_jtag_debug_module,
      cpu_data_master_read_data_valid_cpu_jtag_debug_module => cpu_data_master_read_data_valid_cpu_jtag_debug_module,
      cpu_data_master_requests_cpu_jtag_debug_module => cpu_data_master_requests_cpu_jtag_debug_module,
      cpu_instruction_master_granted_cpu_jtag_debug_module => cpu_instruction_master_granted_cpu_jtag_debug_module,
      cpu_instruction_master_qualified_request_cpu_jtag_debug_module => cpu_instruction_master_qualified_request_cpu_jtag_debug_module,
      cpu_instruction_master_read_data_valid_cpu_jtag_debug_module => cpu_instruction_master_read_data_valid_cpu_jtag_debug_module,
      cpu_instruction_master_requests_cpu_jtag_debug_module => cpu_instruction_master_requests_cpu_jtag_debug_module,
      cpu_jtag_debug_module_address => cpu_jtag_debug_module_address,
      cpu_jtag_debug_module_begintransfer => cpu_jtag_debug_module_begintransfer,
      cpu_jtag_debug_module_byteenable => cpu_jtag_debug_module_byteenable,
      cpu_jtag_debug_module_chipselect => cpu_jtag_debug_module_chipselect,
      cpu_jtag_debug_module_debugaccess => cpu_jtag_debug_module_debugaccess,
      cpu_jtag_debug_module_readdata_from_sa => cpu_jtag_debug_module_readdata_from_sa,
      cpu_jtag_debug_module_reset_n => cpu_jtag_debug_module_reset_n,
      cpu_jtag_debug_module_resetrequest_from_sa => cpu_jtag_debug_module_resetrequest_from_sa,
      cpu_jtag_debug_module_write => cpu_jtag_debug_module_write,
      cpu_jtag_debug_module_writedata => cpu_jtag_debug_module_writedata,
      d1_cpu_jtag_debug_module_end_xfer => d1_cpu_jtag_debug_module_end_xfer,
      clk => clk1,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_byteenable => cpu_data_master_byteenable,
      cpu_data_master_debugaccess => cpu_data_master_debugaccess,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      cpu_instruction_master_address_to_slave => cpu_instruction_master_address_to_slave,
      cpu_instruction_master_read => cpu_instruction_master_read,
      cpu_jtag_debug_module_readdata => cpu_jtag_debug_module_readdata,
      cpu_jtag_debug_module_resetrequest => cpu_jtag_debug_module_resetrequest,
      reset_n => clk1_reset_n
    );


  --the_cpu_data_master, which is an e_instance
  the_cpu_data_master : cpu_data_master_arbitrator
    port map(
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_irq => cpu_data_master_irq,
      cpu_data_master_readdata => cpu_data_master_readdata,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      clk => clk1,
      cpu_data_master_address => cpu_data_master_address,
      cpu_data_master_granted_cpu_jtag_debug_module => cpu_data_master_granted_cpu_jtag_debug_module,
      cpu_data_master_granted_iobusMAC_0_slave => cpu_data_master_granted_iobusMAC_0_slave,
      cpu_data_master_granted_iobusMAC_1_slave => cpu_data_master_granted_iobusMAC_1_slave,
      cpu_data_master_granted_iobusMAC_2_slave => cpu_data_master_granted_iobusMAC_2_slave,
      cpu_data_master_granted_iobusMAC_3_slave => cpu_data_master_granted_iobusMAC_3_slave,
      cpu_data_master_granted_iobusMAC_4_slave => cpu_data_master_granted_iobusMAC_4_slave,
      cpu_data_master_granted_iobusMAC_5_slave => cpu_data_master_granted_iobusMAC_5_slave,
      cpu_data_master_granted_iobusMAC_6_slave => cpu_data_master_granted_iobusMAC_6_slave,
      cpu_data_master_granted_iobusMAC_7_slave => cpu_data_master_granted_iobusMAC_7_slave,
      cpu_data_master_granted_iobusMDIO_0_slave => cpu_data_master_granted_iobusMDIO_0_slave,
      cpu_data_master_granted_iobusMDIO_1_slave => cpu_data_master_granted_iobusMDIO_1_slave,
      cpu_data_master_granted_iobusMDIO_2_slave => cpu_data_master_granted_iobusMDIO_2_slave,
      cpu_data_master_granted_iobusMDIO_3_slave => cpu_data_master_granted_iobusMDIO_3_slave,
      cpu_data_master_granted_iobusMDIO_4_slave => cpu_data_master_granted_iobusMDIO_4_slave,
      cpu_data_master_granted_iobusMDIO_5_slave => cpu_data_master_granted_iobusMDIO_5_slave,
      cpu_data_master_granted_iobusMDIO_6_slave => cpu_data_master_granted_iobusMDIO_6_slave,
      cpu_data_master_granted_iobusMDIO_7_slave => cpu_data_master_granted_iobusMDIO_7_slave,
      cpu_data_master_granted_iobusREGFILE_0_slave => cpu_data_master_granted_iobusREGFILE_0_slave,
      cpu_data_master_granted_jtag_uart_avalon_jtag_slave => cpu_data_master_granted_jtag_uart_avalon_jtag_slave,
      cpu_data_master_granted_mem_s1 => cpu_data_master_granted_mem_s1,
      cpu_data_master_granted_rs232_uart_s1 => cpu_data_master_granted_rs232_uart_s1,
      cpu_data_master_qualified_request_cpu_jtag_debug_module => cpu_data_master_qualified_request_cpu_jtag_debug_module,
      cpu_data_master_qualified_request_iobusMAC_0_slave => cpu_data_master_qualified_request_iobusMAC_0_slave,
      cpu_data_master_qualified_request_iobusMAC_1_slave => cpu_data_master_qualified_request_iobusMAC_1_slave,
      cpu_data_master_qualified_request_iobusMAC_2_slave => cpu_data_master_qualified_request_iobusMAC_2_slave,
      cpu_data_master_qualified_request_iobusMAC_3_slave => cpu_data_master_qualified_request_iobusMAC_3_slave,
      cpu_data_master_qualified_request_iobusMAC_4_slave => cpu_data_master_qualified_request_iobusMAC_4_slave,
      cpu_data_master_qualified_request_iobusMAC_5_slave => cpu_data_master_qualified_request_iobusMAC_5_slave,
      cpu_data_master_qualified_request_iobusMAC_6_slave => cpu_data_master_qualified_request_iobusMAC_6_slave,
      cpu_data_master_qualified_request_iobusMAC_7_slave => cpu_data_master_qualified_request_iobusMAC_7_slave,
      cpu_data_master_qualified_request_iobusMDIO_0_slave => cpu_data_master_qualified_request_iobusMDIO_0_slave,
      cpu_data_master_qualified_request_iobusMDIO_1_slave => cpu_data_master_qualified_request_iobusMDIO_1_slave,
      cpu_data_master_qualified_request_iobusMDIO_2_slave => cpu_data_master_qualified_request_iobusMDIO_2_slave,
      cpu_data_master_qualified_request_iobusMDIO_3_slave => cpu_data_master_qualified_request_iobusMDIO_3_slave,
      cpu_data_master_qualified_request_iobusMDIO_4_slave => cpu_data_master_qualified_request_iobusMDIO_4_slave,
      cpu_data_master_qualified_request_iobusMDIO_5_slave => cpu_data_master_qualified_request_iobusMDIO_5_slave,
      cpu_data_master_qualified_request_iobusMDIO_6_slave => cpu_data_master_qualified_request_iobusMDIO_6_slave,
      cpu_data_master_qualified_request_iobusMDIO_7_slave => cpu_data_master_qualified_request_iobusMDIO_7_slave,
      cpu_data_master_qualified_request_iobusREGFILE_0_slave => cpu_data_master_qualified_request_iobusREGFILE_0_slave,
      cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave => cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave,
      cpu_data_master_qualified_request_mem_s1 => cpu_data_master_qualified_request_mem_s1,
      cpu_data_master_qualified_request_rs232_uart_s1 => cpu_data_master_qualified_request_rs232_uart_s1,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_read_data_valid_cpu_jtag_debug_module => cpu_data_master_read_data_valid_cpu_jtag_debug_module,
      cpu_data_master_read_data_valid_iobusMAC_0_slave => cpu_data_master_read_data_valid_iobusMAC_0_slave,
      cpu_data_master_read_data_valid_iobusMAC_0_slave_shift_register => cpu_data_master_read_data_valid_iobusMAC_0_slave_shift_register,
      cpu_data_master_read_data_valid_iobusMAC_1_slave => cpu_data_master_read_data_valid_iobusMAC_1_slave,
      cpu_data_master_read_data_valid_iobusMAC_1_slave_shift_register => cpu_data_master_read_data_valid_iobusMAC_1_slave_shift_register,
      cpu_data_master_read_data_valid_iobusMAC_2_slave => cpu_data_master_read_data_valid_iobusMAC_2_slave,
      cpu_data_master_read_data_valid_iobusMAC_2_slave_shift_register => cpu_data_master_read_data_valid_iobusMAC_2_slave_shift_register,
      cpu_data_master_read_data_valid_iobusMAC_3_slave => cpu_data_master_read_data_valid_iobusMAC_3_slave,
      cpu_data_master_read_data_valid_iobusMAC_3_slave_shift_register => cpu_data_master_read_data_valid_iobusMAC_3_slave_shift_register,
      cpu_data_master_read_data_valid_iobusMAC_4_slave => cpu_data_master_read_data_valid_iobusMAC_4_slave,
      cpu_data_master_read_data_valid_iobusMAC_4_slave_shift_register => cpu_data_master_read_data_valid_iobusMAC_4_slave_shift_register,
      cpu_data_master_read_data_valid_iobusMAC_5_slave => cpu_data_master_read_data_valid_iobusMAC_5_slave,
      cpu_data_master_read_data_valid_iobusMAC_5_slave_shift_register => cpu_data_master_read_data_valid_iobusMAC_5_slave_shift_register,
      cpu_data_master_read_data_valid_iobusMAC_6_slave => cpu_data_master_read_data_valid_iobusMAC_6_slave,
      cpu_data_master_read_data_valid_iobusMAC_6_slave_shift_register => cpu_data_master_read_data_valid_iobusMAC_6_slave_shift_register,
      cpu_data_master_read_data_valid_iobusMAC_7_slave => cpu_data_master_read_data_valid_iobusMAC_7_slave,
      cpu_data_master_read_data_valid_iobusMAC_7_slave_shift_register => cpu_data_master_read_data_valid_iobusMAC_7_slave_shift_register,
      cpu_data_master_read_data_valid_iobusMDIO_0_slave => cpu_data_master_read_data_valid_iobusMDIO_0_slave,
      cpu_data_master_read_data_valid_iobusMDIO_0_slave_shift_register => cpu_data_master_read_data_valid_iobusMDIO_0_slave_shift_register,
      cpu_data_master_read_data_valid_iobusMDIO_1_slave => cpu_data_master_read_data_valid_iobusMDIO_1_slave,
      cpu_data_master_read_data_valid_iobusMDIO_1_slave_shift_register => cpu_data_master_read_data_valid_iobusMDIO_1_slave_shift_register,
      cpu_data_master_read_data_valid_iobusMDIO_2_slave => cpu_data_master_read_data_valid_iobusMDIO_2_slave,
      cpu_data_master_read_data_valid_iobusMDIO_2_slave_shift_register => cpu_data_master_read_data_valid_iobusMDIO_2_slave_shift_register,
      cpu_data_master_read_data_valid_iobusMDIO_3_slave => cpu_data_master_read_data_valid_iobusMDIO_3_slave,
      cpu_data_master_read_data_valid_iobusMDIO_3_slave_shift_register => cpu_data_master_read_data_valid_iobusMDIO_3_slave_shift_register,
      cpu_data_master_read_data_valid_iobusMDIO_4_slave => cpu_data_master_read_data_valid_iobusMDIO_4_slave,
      cpu_data_master_read_data_valid_iobusMDIO_4_slave_shift_register => cpu_data_master_read_data_valid_iobusMDIO_4_slave_shift_register,
      cpu_data_master_read_data_valid_iobusMDIO_5_slave => cpu_data_master_read_data_valid_iobusMDIO_5_slave,
      cpu_data_master_read_data_valid_iobusMDIO_5_slave_shift_register => cpu_data_master_read_data_valid_iobusMDIO_5_slave_shift_register,
      cpu_data_master_read_data_valid_iobusMDIO_6_slave => cpu_data_master_read_data_valid_iobusMDIO_6_slave,
      cpu_data_master_read_data_valid_iobusMDIO_6_slave_shift_register => cpu_data_master_read_data_valid_iobusMDIO_6_slave_shift_register,
      cpu_data_master_read_data_valid_iobusMDIO_7_slave => cpu_data_master_read_data_valid_iobusMDIO_7_slave,
      cpu_data_master_read_data_valid_iobusMDIO_7_slave_shift_register => cpu_data_master_read_data_valid_iobusMDIO_7_slave_shift_register,
      cpu_data_master_read_data_valid_iobusREGFILE_0_slave => cpu_data_master_read_data_valid_iobusREGFILE_0_slave,
      cpu_data_master_read_data_valid_iobusREGFILE_0_slave_shift_register => cpu_data_master_read_data_valid_iobusREGFILE_0_slave_shift_register,
      cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave => cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave,
      cpu_data_master_read_data_valid_mem_s1 => cpu_data_master_read_data_valid_mem_s1,
      cpu_data_master_read_data_valid_rs232_uart_s1 => cpu_data_master_read_data_valid_rs232_uart_s1,
      cpu_data_master_requests_cpu_jtag_debug_module => cpu_data_master_requests_cpu_jtag_debug_module,
      cpu_data_master_requests_iobusMAC_0_slave => cpu_data_master_requests_iobusMAC_0_slave,
      cpu_data_master_requests_iobusMAC_1_slave => cpu_data_master_requests_iobusMAC_1_slave,
      cpu_data_master_requests_iobusMAC_2_slave => cpu_data_master_requests_iobusMAC_2_slave,
      cpu_data_master_requests_iobusMAC_3_slave => cpu_data_master_requests_iobusMAC_3_slave,
      cpu_data_master_requests_iobusMAC_4_slave => cpu_data_master_requests_iobusMAC_4_slave,
      cpu_data_master_requests_iobusMAC_5_slave => cpu_data_master_requests_iobusMAC_5_slave,
      cpu_data_master_requests_iobusMAC_6_slave => cpu_data_master_requests_iobusMAC_6_slave,
      cpu_data_master_requests_iobusMAC_7_slave => cpu_data_master_requests_iobusMAC_7_slave,
      cpu_data_master_requests_iobusMDIO_0_slave => cpu_data_master_requests_iobusMDIO_0_slave,
      cpu_data_master_requests_iobusMDIO_1_slave => cpu_data_master_requests_iobusMDIO_1_slave,
      cpu_data_master_requests_iobusMDIO_2_slave => cpu_data_master_requests_iobusMDIO_2_slave,
      cpu_data_master_requests_iobusMDIO_3_slave => cpu_data_master_requests_iobusMDIO_3_slave,
      cpu_data_master_requests_iobusMDIO_4_slave => cpu_data_master_requests_iobusMDIO_4_slave,
      cpu_data_master_requests_iobusMDIO_5_slave => cpu_data_master_requests_iobusMDIO_5_slave,
      cpu_data_master_requests_iobusMDIO_6_slave => cpu_data_master_requests_iobusMDIO_6_slave,
      cpu_data_master_requests_iobusMDIO_7_slave => cpu_data_master_requests_iobusMDIO_7_slave,
      cpu_data_master_requests_iobusREGFILE_0_slave => cpu_data_master_requests_iobusREGFILE_0_slave,
      cpu_data_master_requests_jtag_uart_avalon_jtag_slave => cpu_data_master_requests_jtag_uart_avalon_jtag_slave,
      cpu_data_master_requests_mem_s1 => cpu_data_master_requests_mem_s1,
      cpu_data_master_requests_rs232_uart_s1 => cpu_data_master_requests_rs232_uart_s1,
      cpu_data_master_write => cpu_data_master_write,
      cpu_jtag_debug_module_readdata_from_sa => cpu_jtag_debug_module_readdata_from_sa,
      d1_cpu_jtag_debug_module_end_xfer => d1_cpu_jtag_debug_module_end_xfer,
      d1_iobusMAC_0_slave_end_xfer => d1_iobusMAC_0_slave_end_xfer,
      d1_iobusMAC_1_slave_end_xfer => d1_iobusMAC_1_slave_end_xfer,
      d1_iobusMAC_2_slave_end_xfer => d1_iobusMAC_2_slave_end_xfer,
      d1_iobusMAC_3_slave_end_xfer => d1_iobusMAC_3_slave_end_xfer,
      d1_iobusMAC_4_slave_end_xfer => d1_iobusMAC_4_slave_end_xfer,
      d1_iobusMAC_5_slave_end_xfer => d1_iobusMAC_5_slave_end_xfer,
      d1_iobusMAC_6_slave_end_xfer => d1_iobusMAC_6_slave_end_xfer,
      d1_iobusMAC_7_slave_end_xfer => d1_iobusMAC_7_slave_end_xfer,
      d1_iobusMDIO_0_slave_end_xfer => d1_iobusMDIO_0_slave_end_xfer,
      d1_iobusMDIO_1_slave_end_xfer => d1_iobusMDIO_1_slave_end_xfer,
      d1_iobusMDIO_2_slave_end_xfer => d1_iobusMDIO_2_slave_end_xfer,
      d1_iobusMDIO_3_slave_end_xfer => d1_iobusMDIO_3_slave_end_xfer,
      d1_iobusMDIO_4_slave_end_xfer => d1_iobusMDIO_4_slave_end_xfer,
      d1_iobusMDIO_5_slave_end_xfer => d1_iobusMDIO_5_slave_end_xfer,
      d1_iobusMDIO_6_slave_end_xfer => d1_iobusMDIO_6_slave_end_xfer,
      d1_iobusMDIO_7_slave_end_xfer => d1_iobusMDIO_7_slave_end_xfer,
      d1_iobusREGFILE_0_slave_end_xfer => d1_iobusREGFILE_0_slave_end_xfer,
      d1_jtag_uart_avalon_jtag_slave_end_xfer => d1_jtag_uart_avalon_jtag_slave_end_xfer,
      d1_mem_s1_end_xfer => d1_mem_s1_end_xfer,
      d1_rs232_uart_s1_end_xfer => d1_rs232_uart_s1_end_xfer,
      iobusMAC_0_slave_readdata_from_sa => iobusMAC_0_slave_readdata_from_sa,
      iobusMAC_0_slave_waitrequest_from_sa => iobusMAC_0_slave_waitrequest_from_sa,
      iobusMAC_1_slave_readdata_from_sa => iobusMAC_1_slave_readdata_from_sa,
      iobusMAC_1_slave_waitrequest_from_sa => iobusMAC_1_slave_waitrequest_from_sa,
      iobusMAC_2_slave_readdata_from_sa => iobusMAC_2_slave_readdata_from_sa,
      iobusMAC_2_slave_waitrequest_from_sa => iobusMAC_2_slave_waitrequest_from_sa,
      iobusMAC_3_slave_readdata_from_sa => iobusMAC_3_slave_readdata_from_sa,
      iobusMAC_3_slave_waitrequest_from_sa => iobusMAC_3_slave_waitrequest_from_sa,
      iobusMAC_4_slave_readdata_from_sa => iobusMAC_4_slave_readdata_from_sa,
      iobusMAC_4_slave_waitrequest_from_sa => iobusMAC_4_slave_waitrequest_from_sa,
      iobusMAC_5_slave_readdata_from_sa => iobusMAC_5_slave_readdata_from_sa,
      iobusMAC_5_slave_waitrequest_from_sa => iobusMAC_5_slave_waitrequest_from_sa,
      iobusMAC_6_slave_readdata_from_sa => iobusMAC_6_slave_readdata_from_sa,
      iobusMAC_6_slave_waitrequest_from_sa => iobusMAC_6_slave_waitrequest_from_sa,
      iobusMAC_7_slave_readdata_from_sa => iobusMAC_7_slave_readdata_from_sa,
      iobusMAC_7_slave_waitrequest_from_sa => iobusMAC_7_slave_waitrequest_from_sa,
      iobusMDIO_0_slave_readdata_from_sa => iobusMDIO_0_slave_readdata_from_sa,
      iobusMDIO_0_slave_waitrequest_from_sa => iobusMDIO_0_slave_waitrequest_from_sa,
      iobusMDIO_1_slave_readdata_from_sa => iobusMDIO_1_slave_readdata_from_sa,
      iobusMDIO_1_slave_waitrequest_from_sa => iobusMDIO_1_slave_waitrequest_from_sa,
      iobusMDIO_2_slave_readdata_from_sa => iobusMDIO_2_slave_readdata_from_sa,
      iobusMDIO_2_slave_waitrequest_from_sa => iobusMDIO_2_slave_waitrequest_from_sa,
      iobusMDIO_3_slave_readdata_from_sa => iobusMDIO_3_slave_readdata_from_sa,
      iobusMDIO_3_slave_waitrequest_from_sa => iobusMDIO_3_slave_waitrequest_from_sa,
      iobusMDIO_4_slave_readdata_from_sa => iobusMDIO_4_slave_readdata_from_sa,
      iobusMDIO_4_slave_waitrequest_from_sa => iobusMDIO_4_slave_waitrequest_from_sa,
      iobusMDIO_5_slave_readdata_from_sa => iobusMDIO_5_slave_readdata_from_sa,
      iobusMDIO_5_slave_waitrequest_from_sa => iobusMDIO_5_slave_waitrequest_from_sa,
      iobusMDIO_6_slave_readdata_from_sa => iobusMDIO_6_slave_readdata_from_sa,
      iobusMDIO_6_slave_waitrequest_from_sa => iobusMDIO_6_slave_waitrequest_from_sa,
      iobusMDIO_7_slave_readdata_from_sa => iobusMDIO_7_slave_readdata_from_sa,
      iobusMDIO_7_slave_waitrequest_from_sa => iobusMDIO_7_slave_waitrequest_from_sa,
      iobusREGFILE_0_slave_readdata_from_sa => iobusREGFILE_0_slave_readdata_from_sa,
      iobusREGFILE_0_slave_waitrequest_from_sa => iobusREGFILE_0_slave_waitrequest_from_sa,
      jtag_uart_avalon_jtag_slave_irq_from_sa => jtag_uart_avalon_jtag_slave_irq_from_sa,
      jtag_uart_avalon_jtag_slave_readdata_from_sa => jtag_uart_avalon_jtag_slave_readdata_from_sa,
      jtag_uart_avalon_jtag_slave_waitrequest_from_sa => jtag_uart_avalon_jtag_slave_waitrequest_from_sa,
      mem_s1_readdata_from_sa => mem_s1_readdata_from_sa,
      registered_cpu_data_master_read_data_valid_mem_s1 => registered_cpu_data_master_read_data_valid_mem_s1,
      reset_n => clk1_reset_n,
      rs232_uart_s1_irq_from_sa => rs232_uart_s1_irq_from_sa,
      rs232_uart_s1_readdata_from_sa => rs232_uart_s1_readdata_from_sa
    );


  --the_cpu_instruction_master, which is an e_instance
  the_cpu_instruction_master : cpu_instruction_master_arbitrator
    port map(
      cpu_instruction_master_address_to_slave => cpu_instruction_master_address_to_slave,
      cpu_instruction_master_readdata => cpu_instruction_master_readdata,
      cpu_instruction_master_waitrequest => cpu_instruction_master_waitrequest,
      clk => clk1,
      cpu_instruction_master_address => cpu_instruction_master_address,
      cpu_instruction_master_granted_cpu_jtag_debug_module => cpu_instruction_master_granted_cpu_jtag_debug_module,
      cpu_instruction_master_granted_mem_s1 => cpu_instruction_master_granted_mem_s1,
      cpu_instruction_master_qualified_request_cpu_jtag_debug_module => cpu_instruction_master_qualified_request_cpu_jtag_debug_module,
      cpu_instruction_master_qualified_request_mem_s1 => cpu_instruction_master_qualified_request_mem_s1,
      cpu_instruction_master_read => cpu_instruction_master_read,
      cpu_instruction_master_read_data_valid_cpu_jtag_debug_module => cpu_instruction_master_read_data_valid_cpu_jtag_debug_module,
      cpu_instruction_master_read_data_valid_mem_s1 => cpu_instruction_master_read_data_valid_mem_s1,
      cpu_instruction_master_requests_cpu_jtag_debug_module => cpu_instruction_master_requests_cpu_jtag_debug_module,
      cpu_instruction_master_requests_mem_s1 => cpu_instruction_master_requests_mem_s1,
      cpu_jtag_debug_module_readdata_from_sa => cpu_jtag_debug_module_readdata_from_sa,
      d1_cpu_jtag_debug_module_end_xfer => d1_cpu_jtag_debug_module_end_xfer,
      d1_mem_s1_end_xfer => d1_mem_s1_end_xfer,
      mem_s1_readdata_from_sa => mem_s1_readdata_from_sa,
      reset_n => clk1_reset_n
    );


  --the_cpu, which is an e_ptf_instance
  the_cpu : cpu
    port map(
      d_address => cpu_data_master_address,
      d_byteenable => cpu_data_master_byteenable,
      d_read => cpu_data_master_read,
      d_write => cpu_data_master_write,
      d_writedata => cpu_data_master_writedata,
      i_address => cpu_instruction_master_address,
      i_read => cpu_instruction_master_read,
      jtag_debug_module_debugaccess_to_roms => cpu_data_master_debugaccess,
      jtag_debug_module_readdata => cpu_jtag_debug_module_readdata,
      jtag_debug_module_resetrequest => cpu_jtag_debug_module_resetrequest,
      clk => clk1,
      d_irq => cpu_data_master_irq,
      d_readdata => cpu_data_master_readdata,
      d_waitrequest => cpu_data_master_waitrequest,
      i_readdata => cpu_instruction_master_readdata,
      i_waitrequest => cpu_instruction_master_waitrequest,
      jtag_debug_module_address => cpu_jtag_debug_module_address,
      jtag_debug_module_begintransfer => cpu_jtag_debug_module_begintransfer,
      jtag_debug_module_byteenable => cpu_jtag_debug_module_byteenable,
      jtag_debug_module_debugaccess => cpu_jtag_debug_module_debugaccess,
      jtag_debug_module_select => cpu_jtag_debug_module_chipselect,
      jtag_debug_module_write => cpu_jtag_debug_module_write,
      jtag_debug_module_writedata => cpu_jtag_debug_module_writedata,
      reset_n => cpu_jtag_debug_module_reset_n
    );


  --the_iobusMAC_0_slave, which is an e_instance
  the_iobusMAC_0_slave : iobusMAC_0_slave_arbitrator
    port map(
      cpu_data_master_granted_iobusMAC_0_slave => cpu_data_master_granted_iobusMAC_0_slave,
      cpu_data_master_qualified_request_iobusMAC_0_slave => cpu_data_master_qualified_request_iobusMAC_0_slave,
      cpu_data_master_read_data_valid_iobusMAC_0_slave => cpu_data_master_read_data_valid_iobusMAC_0_slave,
      cpu_data_master_read_data_valid_iobusMAC_0_slave_shift_register => cpu_data_master_read_data_valid_iobusMAC_0_slave_shift_register,
      cpu_data_master_requests_iobusMAC_0_slave => cpu_data_master_requests_iobusMAC_0_slave,
      d1_iobusMAC_0_slave_end_xfer => d1_iobusMAC_0_slave_end_xfer,
      iobusMAC_0_slave_address => iobusMAC_0_slave_address,
      iobusMAC_0_slave_read => iobusMAC_0_slave_read,
      iobusMAC_0_slave_readdata_from_sa => iobusMAC_0_slave_readdata_from_sa,
      iobusMAC_0_slave_reset => iobusMAC_0_slave_reset,
      iobusMAC_0_slave_waitrequest_from_sa => iobusMAC_0_slave_waitrequest_from_sa,
      iobusMAC_0_slave_write => iobusMAC_0_slave_write,
      iobusMAC_0_slave_writedata => iobusMAC_0_slave_writedata,
      clk => clk1,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      iobusMAC_0_slave_readdata => iobusMAC_0_slave_readdata,
      iobusMAC_0_slave_readdatavalid => iobusMAC_0_slave_readdatavalid,
      iobusMAC_0_slave_waitrequest => iobusMAC_0_slave_waitrequest,
      reset_n => clk1_reset_n
    );


  --the_iobusMAC_0, which is an e_ptf_instance
  the_iobusMAC_0 : iobusMAC_0
    port map(
      mmreaddata => iobusMAC_0_slave_readdata,
      mmreaddatavalid => iobusMAC_0_slave_readdatavalid,
      mmwaitrequest => iobusMAC_0_slave_waitrequest,
      s_address => internal_s_address_from_the_iobusMAC_0,
      s_clk => internal_s_clk_from_the_iobusMAC_0,
      s_read => internal_s_read_from_the_iobusMAC_0,
      s_rst => internal_s_rst_from_the_iobusMAC_0,
      s_write => internal_s_write_from_the_iobusMAC_0,
      s_writedata => internal_s_writedata_from_the_iobusMAC_0,
      clk => clk1,
      mmaddress => iobusMAC_0_slave_address,
      mmread => iobusMAC_0_slave_read,
      mmwrite => iobusMAC_0_slave_write,
      mmwritedata => iobusMAC_0_slave_writedata,
      rst => iobusMAC_0_slave_reset,
      s_readdata => s_readdata_to_the_iobusMAC_0,
      s_readdatavalid => s_readdatavalid_to_the_iobusMAC_0,
      s_waitrequest => s_waitrequest_to_the_iobusMAC_0
    );


  --the_iobusMAC_1_slave, which is an e_instance
  the_iobusMAC_1_slave : iobusMAC_1_slave_arbitrator
    port map(
      cpu_data_master_granted_iobusMAC_1_slave => cpu_data_master_granted_iobusMAC_1_slave,
      cpu_data_master_qualified_request_iobusMAC_1_slave => cpu_data_master_qualified_request_iobusMAC_1_slave,
      cpu_data_master_read_data_valid_iobusMAC_1_slave => cpu_data_master_read_data_valid_iobusMAC_1_slave,
      cpu_data_master_read_data_valid_iobusMAC_1_slave_shift_register => cpu_data_master_read_data_valid_iobusMAC_1_slave_shift_register,
      cpu_data_master_requests_iobusMAC_1_slave => cpu_data_master_requests_iobusMAC_1_slave,
      d1_iobusMAC_1_slave_end_xfer => d1_iobusMAC_1_slave_end_xfer,
      iobusMAC_1_slave_address => iobusMAC_1_slave_address,
      iobusMAC_1_slave_read => iobusMAC_1_slave_read,
      iobusMAC_1_slave_readdata_from_sa => iobusMAC_1_slave_readdata_from_sa,
      iobusMAC_1_slave_reset => iobusMAC_1_slave_reset,
      iobusMAC_1_slave_waitrequest_from_sa => iobusMAC_1_slave_waitrequest_from_sa,
      iobusMAC_1_slave_write => iobusMAC_1_slave_write,
      iobusMAC_1_slave_writedata => iobusMAC_1_slave_writedata,
      clk => clk1,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      iobusMAC_1_slave_readdata => iobusMAC_1_slave_readdata,
      iobusMAC_1_slave_readdatavalid => iobusMAC_1_slave_readdatavalid,
      iobusMAC_1_slave_waitrequest => iobusMAC_1_slave_waitrequest,
      reset_n => clk1_reset_n
    );


  --the_iobusMAC_1, which is an e_ptf_instance
  the_iobusMAC_1 : iobusMAC_1
    port map(
      mmreaddata => iobusMAC_1_slave_readdata,
      mmreaddatavalid => iobusMAC_1_slave_readdatavalid,
      mmwaitrequest => iobusMAC_1_slave_waitrequest,
      s_address => internal_s_address_from_the_iobusMAC_1,
      s_clk => internal_s_clk_from_the_iobusMAC_1,
      s_read => internal_s_read_from_the_iobusMAC_1,
      s_rst => internal_s_rst_from_the_iobusMAC_1,
      s_write => internal_s_write_from_the_iobusMAC_1,
      s_writedata => internal_s_writedata_from_the_iobusMAC_1,
      clk => clk1,
      mmaddress => iobusMAC_1_slave_address,
      mmread => iobusMAC_1_slave_read,
      mmwrite => iobusMAC_1_slave_write,
      mmwritedata => iobusMAC_1_slave_writedata,
      rst => iobusMAC_1_slave_reset,
      s_readdata => s_readdata_to_the_iobusMAC_1,
      s_readdatavalid => s_readdatavalid_to_the_iobusMAC_1,
      s_waitrequest => s_waitrequest_to_the_iobusMAC_1
    );


  --the_iobusMAC_2_slave, which is an e_instance
  the_iobusMAC_2_slave : iobusMAC_2_slave_arbitrator
    port map(
      cpu_data_master_granted_iobusMAC_2_slave => cpu_data_master_granted_iobusMAC_2_slave,
      cpu_data_master_qualified_request_iobusMAC_2_slave => cpu_data_master_qualified_request_iobusMAC_2_slave,
      cpu_data_master_read_data_valid_iobusMAC_2_slave => cpu_data_master_read_data_valid_iobusMAC_2_slave,
      cpu_data_master_read_data_valid_iobusMAC_2_slave_shift_register => cpu_data_master_read_data_valid_iobusMAC_2_slave_shift_register,
      cpu_data_master_requests_iobusMAC_2_slave => cpu_data_master_requests_iobusMAC_2_slave,
      d1_iobusMAC_2_slave_end_xfer => d1_iobusMAC_2_slave_end_xfer,
      iobusMAC_2_slave_address => iobusMAC_2_slave_address,
      iobusMAC_2_slave_read => iobusMAC_2_slave_read,
      iobusMAC_2_slave_readdata_from_sa => iobusMAC_2_slave_readdata_from_sa,
      iobusMAC_2_slave_reset => iobusMAC_2_slave_reset,
      iobusMAC_2_slave_waitrequest_from_sa => iobusMAC_2_slave_waitrequest_from_sa,
      iobusMAC_2_slave_write => iobusMAC_2_slave_write,
      iobusMAC_2_slave_writedata => iobusMAC_2_slave_writedata,
      clk => clk1,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      iobusMAC_2_slave_readdata => iobusMAC_2_slave_readdata,
      iobusMAC_2_slave_readdatavalid => iobusMAC_2_slave_readdatavalid,
      iobusMAC_2_slave_waitrequest => iobusMAC_2_slave_waitrequest,
      reset_n => clk1_reset_n
    );


  --the_iobusMAC_2, which is an e_ptf_instance
  the_iobusMAC_2 : iobusMAC_2
    port map(
      mmreaddata => iobusMAC_2_slave_readdata,
      mmreaddatavalid => iobusMAC_2_slave_readdatavalid,
      mmwaitrequest => iobusMAC_2_slave_waitrequest,
      s_address => internal_s_address_from_the_iobusMAC_2,
      s_clk => internal_s_clk_from_the_iobusMAC_2,
      s_read => internal_s_read_from_the_iobusMAC_2,
      s_rst => internal_s_rst_from_the_iobusMAC_2,
      s_write => internal_s_write_from_the_iobusMAC_2,
      s_writedata => internal_s_writedata_from_the_iobusMAC_2,
      clk => clk1,
      mmaddress => iobusMAC_2_slave_address,
      mmread => iobusMAC_2_slave_read,
      mmwrite => iobusMAC_2_slave_write,
      mmwritedata => iobusMAC_2_slave_writedata,
      rst => iobusMAC_2_slave_reset,
      s_readdata => s_readdata_to_the_iobusMAC_2,
      s_readdatavalid => s_readdatavalid_to_the_iobusMAC_2,
      s_waitrequest => s_waitrequest_to_the_iobusMAC_2
    );


  --the_iobusMAC_3_slave, which is an e_instance
  the_iobusMAC_3_slave : iobusMAC_3_slave_arbitrator
    port map(
      cpu_data_master_granted_iobusMAC_3_slave => cpu_data_master_granted_iobusMAC_3_slave,
      cpu_data_master_qualified_request_iobusMAC_3_slave => cpu_data_master_qualified_request_iobusMAC_3_slave,
      cpu_data_master_read_data_valid_iobusMAC_3_slave => cpu_data_master_read_data_valid_iobusMAC_3_slave,
      cpu_data_master_read_data_valid_iobusMAC_3_slave_shift_register => cpu_data_master_read_data_valid_iobusMAC_3_slave_shift_register,
      cpu_data_master_requests_iobusMAC_3_slave => cpu_data_master_requests_iobusMAC_3_slave,
      d1_iobusMAC_3_slave_end_xfer => d1_iobusMAC_3_slave_end_xfer,
      iobusMAC_3_slave_address => iobusMAC_3_slave_address,
      iobusMAC_3_slave_read => iobusMAC_3_slave_read,
      iobusMAC_3_slave_readdata_from_sa => iobusMAC_3_slave_readdata_from_sa,
      iobusMAC_3_slave_reset => iobusMAC_3_slave_reset,
      iobusMAC_3_slave_waitrequest_from_sa => iobusMAC_3_slave_waitrequest_from_sa,
      iobusMAC_3_slave_write => iobusMAC_3_slave_write,
      iobusMAC_3_slave_writedata => iobusMAC_3_slave_writedata,
      clk => clk1,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      iobusMAC_3_slave_readdata => iobusMAC_3_slave_readdata,
      iobusMAC_3_slave_readdatavalid => iobusMAC_3_slave_readdatavalid,
      iobusMAC_3_slave_waitrequest => iobusMAC_3_slave_waitrequest,
      reset_n => clk1_reset_n
    );


  --the_iobusMAC_3, which is an e_ptf_instance
  the_iobusMAC_3 : iobusMAC_3
    port map(
      mmreaddata => iobusMAC_3_slave_readdata,
      mmreaddatavalid => iobusMAC_3_slave_readdatavalid,
      mmwaitrequest => iobusMAC_3_slave_waitrequest,
      s_address => internal_s_address_from_the_iobusMAC_3,
      s_clk => internal_s_clk_from_the_iobusMAC_3,
      s_read => internal_s_read_from_the_iobusMAC_3,
      s_rst => internal_s_rst_from_the_iobusMAC_3,
      s_write => internal_s_write_from_the_iobusMAC_3,
      s_writedata => internal_s_writedata_from_the_iobusMAC_3,
      clk => clk1,
      mmaddress => iobusMAC_3_slave_address,
      mmread => iobusMAC_3_slave_read,
      mmwrite => iobusMAC_3_slave_write,
      mmwritedata => iobusMAC_3_slave_writedata,
      rst => iobusMAC_3_slave_reset,
      s_readdata => s_readdata_to_the_iobusMAC_3,
      s_readdatavalid => s_readdatavalid_to_the_iobusMAC_3,
      s_waitrequest => s_waitrequest_to_the_iobusMAC_3
    );


  --the_iobusMAC_4_slave, which is an e_instance
  the_iobusMAC_4_slave : iobusMAC_4_slave_arbitrator
    port map(
      cpu_data_master_granted_iobusMAC_4_slave => cpu_data_master_granted_iobusMAC_4_slave,
      cpu_data_master_qualified_request_iobusMAC_4_slave => cpu_data_master_qualified_request_iobusMAC_4_slave,
      cpu_data_master_read_data_valid_iobusMAC_4_slave => cpu_data_master_read_data_valid_iobusMAC_4_slave,
      cpu_data_master_read_data_valid_iobusMAC_4_slave_shift_register => cpu_data_master_read_data_valid_iobusMAC_4_slave_shift_register,
      cpu_data_master_requests_iobusMAC_4_slave => cpu_data_master_requests_iobusMAC_4_slave,
      d1_iobusMAC_4_slave_end_xfer => d1_iobusMAC_4_slave_end_xfer,
      iobusMAC_4_slave_address => iobusMAC_4_slave_address,
      iobusMAC_4_slave_read => iobusMAC_4_slave_read,
      iobusMAC_4_slave_readdata_from_sa => iobusMAC_4_slave_readdata_from_sa,
      iobusMAC_4_slave_reset => iobusMAC_4_slave_reset,
      iobusMAC_4_slave_waitrequest_from_sa => iobusMAC_4_slave_waitrequest_from_sa,
      iobusMAC_4_slave_write => iobusMAC_4_slave_write,
      iobusMAC_4_slave_writedata => iobusMAC_4_slave_writedata,
      clk => clk1,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      iobusMAC_4_slave_readdata => iobusMAC_4_slave_readdata,
      iobusMAC_4_slave_readdatavalid => iobusMAC_4_slave_readdatavalid,
      iobusMAC_4_slave_waitrequest => iobusMAC_4_slave_waitrequest,
      reset_n => clk1_reset_n
    );


  --the_iobusMAC_4, which is an e_ptf_instance
  the_iobusMAC_4 : iobusMAC_4
    port map(
      mmreaddata => iobusMAC_4_slave_readdata,
      mmreaddatavalid => iobusMAC_4_slave_readdatavalid,
      mmwaitrequest => iobusMAC_4_slave_waitrequest,
      s_address => internal_s_address_from_the_iobusMAC_4,
      s_clk => internal_s_clk_from_the_iobusMAC_4,
      s_read => internal_s_read_from_the_iobusMAC_4,
      s_rst => internal_s_rst_from_the_iobusMAC_4,
      s_write => internal_s_write_from_the_iobusMAC_4,
      s_writedata => internal_s_writedata_from_the_iobusMAC_4,
      clk => clk1,
      mmaddress => iobusMAC_4_slave_address,
      mmread => iobusMAC_4_slave_read,
      mmwrite => iobusMAC_4_slave_write,
      mmwritedata => iobusMAC_4_slave_writedata,
      rst => iobusMAC_4_slave_reset,
      s_readdata => s_readdata_to_the_iobusMAC_4,
      s_readdatavalid => s_readdatavalid_to_the_iobusMAC_4,
      s_waitrequest => s_waitrequest_to_the_iobusMAC_4
    );


  --the_iobusMAC_5_slave, which is an e_instance
  the_iobusMAC_5_slave : iobusMAC_5_slave_arbitrator
    port map(
      cpu_data_master_granted_iobusMAC_5_slave => cpu_data_master_granted_iobusMAC_5_slave,
      cpu_data_master_qualified_request_iobusMAC_5_slave => cpu_data_master_qualified_request_iobusMAC_5_slave,
      cpu_data_master_read_data_valid_iobusMAC_5_slave => cpu_data_master_read_data_valid_iobusMAC_5_slave,
      cpu_data_master_read_data_valid_iobusMAC_5_slave_shift_register => cpu_data_master_read_data_valid_iobusMAC_5_slave_shift_register,
      cpu_data_master_requests_iobusMAC_5_slave => cpu_data_master_requests_iobusMAC_5_slave,
      d1_iobusMAC_5_slave_end_xfer => d1_iobusMAC_5_slave_end_xfer,
      iobusMAC_5_slave_address => iobusMAC_5_slave_address,
      iobusMAC_5_slave_read => iobusMAC_5_slave_read,
      iobusMAC_5_slave_readdata_from_sa => iobusMAC_5_slave_readdata_from_sa,
      iobusMAC_5_slave_reset => iobusMAC_5_slave_reset,
      iobusMAC_5_slave_waitrequest_from_sa => iobusMAC_5_slave_waitrequest_from_sa,
      iobusMAC_5_slave_write => iobusMAC_5_slave_write,
      iobusMAC_5_slave_writedata => iobusMAC_5_slave_writedata,
      clk => clk1,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      iobusMAC_5_slave_readdata => iobusMAC_5_slave_readdata,
      iobusMAC_5_slave_readdatavalid => iobusMAC_5_slave_readdatavalid,
      iobusMAC_5_slave_waitrequest => iobusMAC_5_slave_waitrequest,
      reset_n => clk1_reset_n
    );


  --the_iobusMAC_5, which is an e_ptf_instance
  the_iobusMAC_5 : iobusMAC_5
    port map(
      mmreaddata => iobusMAC_5_slave_readdata,
      mmreaddatavalid => iobusMAC_5_slave_readdatavalid,
      mmwaitrequest => iobusMAC_5_slave_waitrequest,
      s_address => internal_s_address_from_the_iobusMAC_5,
      s_clk => internal_s_clk_from_the_iobusMAC_5,
      s_read => internal_s_read_from_the_iobusMAC_5,
      s_rst => internal_s_rst_from_the_iobusMAC_5,
      s_write => internal_s_write_from_the_iobusMAC_5,
      s_writedata => internal_s_writedata_from_the_iobusMAC_5,
      clk => clk1,
      mmaddress => iobusMAC_5_slave_address,
      mmread => iobusMAC_5_slave_read,
      mmwrite => iobusMAC_5_slave_write,
      mmwritedata => iobusMAC_5_slave_writedata,
      rst => iobusMAC_5_slave_reset,
      s_readdata => s_readdata_to_the_iobusMAC_5,
      s_readdatavalid => s_readdatavalid_to_the_iobusMAC_5,
      s_waitrequest => s_waitrequest_to_the_iobusMAC_5
    );


  --the_iobusMAC_6_slave, which is an e_instance
  the_iobusMAC_6_slave : iobusMAC_6_slave_arbitrator
    port map(
      cpu_data_master_granted_iobusMAC_6_slave => cpu_data_master_granted_iobusMAC_6_slave,
      cpu_data_master_qualified_request_iobusMAC_6_slave => cpu_data_master_qualified_request_iobusMAC_6_slave,
      cpu_data_master_read_data_valid_iobusMAC_6_slave => cpu_data_master_read_data_valid_iobusMAC_6_slave,
      cpu_data_master_read_data_valid_iobusMAC_6_slave_shift_register => cpu_data_master_read_data_valid_iobusMAC_6_slave_shift_register,
      cpu_data_master_requests_iobusMAC_6_slave => cpu_data_master_requests_iobusMAC_6_slave,
      d1_iobusMAC_6_slave_end_xfer => d1_iobusMAC_6_slave_end_xfer,
      iobusMAC_6_slave_address => iobusMAC_6_slave_address,
      iobusMAC_6_slave_read => iobusMAC_6_slave_read,
      iobusMAC_6_slave_readdata_from_sa => iobusMAC_6_slave_readdata_from_sa,
      iobusMAC_6_slave_reset => iobusMAC_6_slave_reset,
      iobusMAC_6_slave_waitrequest_from_sa => iobusMAC_6_slave_waitrequest_from_sa,
      iobusMAC_6_slave_write => iobusMAC_6_slave_write,
      iobusMAC_6_slave_writedata => iobusMAC_6_slave_writedata,
      clk => clk1,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      iobusMAC_6_slave_readdata => iobusMAC_6_slave_readdata,
      iobusMAC_6_slave_readdatavalid => iobusMAC_6_slave_readdatavalid,
      iobusMAC_6_slave_waitrequest => iobusMAC_6_slave_waitrequest,
      reset_n => clk1_reset_n
    );


  --the_iobusMAC_6, which is an e_ptf_instance
  the_iobusMAC_6 : iobusMAC_6
    port map(
      mmreaddata => iobusMAC_6_slave_readdata,
      mmreaddatavalid => iobusMAC_6_slave_readdatavalid,
      mmwaitrequest => iobusMAC_6_slave_waitrequest,
      s_address => internal_s_address_from_the_iobusMAC_6,
      s_clk => internal_s_clk_from_the_iobusMAC_6,
      s_read => internal_s_read_from_the_iobusMAC_6,
      s_rst => internal_s_rst_from_the_iobusMAC_6,
      s_write => internal_s_write_from_the_iobusMAC_6,
      s_writedata => internal_s_writedata_from_the_iobusMAC_6,
      clk => clk1,
      mmaddress => iobusMAC_6_slave_address,
      mmread => iobusMAC_6_slave_read,
      mmwrite => iobusMAC_6_slave_write,
      mmwritedata => iobusMAC_6_slave_writedata,
      rst => iobusMAC_6_slave_reset,
      s_readdata => s_readdata_to_the_iobusMAC_6,
      s_readdatavalid => s_readdatavalid_to_the_iobusMAC_6,
      s_waitrequest => s_waitrequest_to_the_iobusMAC_6
    );


  --the_iobusMAC_7_slave, which is an e_instance
  the_iobusMAC_7_slave : iobusMAC_7_slave_arbitrator
    port map(
      cpu_data_master_granted_iobusMAC_7_slave => cpu_data_master_granted_iobusMAC_7_slave,
      cpu_data_master_qualified_request_iobusMAC_7_slave => cpu_data_master_qualified_request_iobusMAC_7_slave,
      cpu_data_master_read_data_valid_iobusMAC_7_slave => cpu_data_master_read_data_valid_iobusMAC_7_slave,
      cpu_data_master_read_data_valid_iobusMAC_7_slave_shift_register => cpu_data_master_read_data_valid_iobusMAC_7_slave_shift_register,
      cpu_data_master_requests_iobusMAC_7_slave => cpu_data_master_requests_iobusMAC_7_slave,
      d1_iobusMAC_7_slave_end_xfer => d1_iobusMAC_7_slave_end_xfer,
      iobusMAC_7_slave_address => iobusMAC_7_slave_address,
      iobusMAC_7_slave_read => iobusMAC_7_slave_read,
      iobusMAC_7_slave_readdata_from_sa => iobusMAC_7_slave_readdata_from_sa,
      iobusMAC_7_slave_reset => iobusMAC_7_slave_reset,
      iobusMAC_7_slave_waitrequest_from_sa => iobusMAC_7_slave_waitrequest_from_sa,
      iobusMAC_7_slave_write => iobusMAC_7_slave_write,
      iobusMAC_7_slave_writedata => iobusMAC_7_slave_writedata,
      clk => clk1,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      iobusMAC_7_slave_readdata => iobusMAC_7_slave_readdata,
      iobusMAC_7_slave_readdatavalid => iobusMAC_7_slave_readdatavalid,
      iobusMAC_7_slave_waitrequest => iobusMAC_7_slave_waitrequest,
      reset_n => clk1_reset_n
    );


  --the_iobusMAC_7, which is an e_ptf_instance
  the_iobusMAC_7 : iobusMAC_7
    port map(
      mmreaddata => iobusMAC_7_slave_readdata,
      mmreaddatavalid => iobusMAC_7_slave_readdatavalid,
      mmwaitrequest => iobusMAC_7_slave_waitrequest,
      s_address => internal_s_address_from_the_iobusMAC_7,
      s_clk => internal_s_clk_from_the_iobusMAC_7,
      s_read => internal_s_read_from_the_iobusMAC_7,
      s_rst => internal_s_rst_from_the_iobusMAC_7,
      s_write => internal_s_write_from_the_iobusMAC_7,
      s_writedata => internal_s_writedata_from_the_iobusMAC_7,
      clk => clk1,
      mmaddress => iobusMAC_7_slave_address,
      mmread => iobusMAC_7_slave_read,
      mmwrite => iobusMAC_7_slave_write,
      mmwritedata => iobusMAC_7_slave_writedata,
      rst => iobusMAC_7_slave_reset,
      s_readdata => s_readdata_to_the_iobusMAC_7,
      s_readdatavalid => s_readdatavalid_to_the_iobusMAC_7,
      s_waitrequest => s_waitrequest_to_the_iobusMAC_7
    );


  --the_iobusMDIO_0_slave, which is an e_instance
  the_iobusMDIO_0_slave : iobusMDIO_0_slave_arbitrator
    port map(
      cpu_data_master_granted_iobusMDIO_0_slave => cpu_data_master_granted_iobusMDIO_0_slave,
      cpu_data_master_qualified_request_iobusMDIO_0_slave => cpu_data_master_qualified_request_iobusMDIO_0_slave,
      cpu_data_master_read_data_valid_iobusMDIO_0_slave => cpu_data_master_read_data_valid_iobusMDIO_0_slave,
      cpu_data_master_read_data_valid_iobusMDIO_0_slave_shift_register => cpu_data_master_read_data_valid_iobusMDIO_0_slave_shift_register,
      cpu_data_master_requests_iobusMDIO_0_slave => cpu_data_master_requests_iobusMDIO_0_slave,
      d1_iobusMDIO_0_slave_end_xfer => d1_iobusMDIO_0_slave_end_xfer,
      iobusMDIO_0_slave_address => iobusMDIO_0_slave_address,
      iobusMDIO_0_slave_read => iobusMDIO_0_slave_read,
      iobusMDIO_0_slave_readdata_from_sa => iobusMDIO_0_slave_readdata_from_sa,
      iobusMDIO_0_slave_reset => iobusMDIO_0_slave_reset,
      iobusMDIO_0_slave_waitrequest_from_sa => iobusMDIO_0_slave_waitrequest_from_sa,
      iobusMDIO_0_slave_write => iobusMDIO_0_slave_write,
      iobusMDIO_0_slave_writedata => iobusMDIO_0_slave_writedata,
      clk => clk1,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      iobusMDIO_0_slave_readdata => iobusMDIO_0_slave_readdata,
      iobusMDIO_0_slave_readdatavalid => iobusMDIO_0_slave_readdatavalid,
      iobusMDIO_0_slave_waitrequest => iobusMDIO_0_slave_waitrequest,
      reset_n => clk1_reset_n
    );


  --the_iobusMDIO_0, which is an e_ptf_instance
  the_iobusMDIO_0 : iobusMDIO_0
    port map(
      mmreaddata => iobusMDIO_0_slave_readdata,
      mmreaddatavalid => iobusMDIO_0_slave_readdatavalid,
      mmwaitrequest => iobusMDIO_0_slave_waitrequest,
      s_address => internal_s_address_from_the_iobusMDIO_0,
      s_clk => internal_s_clk_from_the_iobusMDIO_0,
      s_read => internal_s_read_from_the_iobusMDIO_0,
      s_rst => internal_s_rst_from_the_iobusMDIO_0,
      s_write => internal_s_write_from_the_iobusMDIO_0,
      s_writedata => internal_s_writedata_from_the_iobusMDIO_0,
      clk => clk1,
      mmaddress => iobusMDIO_0_slave_address,
      mmread => iobusMDIO_0_slave_read,
      mmwrite => iobusMDIO_0_slave_write,
      mmwritedata => iobusMDIO_0_slave_writedata,
      rst => iobusMDIO_0_slave_reset,
      s_readdata => s_readdata_to_the_iobusMDIO_0,
      s_readdatavalid => s_readdatavalid_to_the_iobusMDIO_0,
      s_waitrequest => s_waitrequest_to_the_iobusMDIO_0
    );


  --the_iobusMDIO_1_slave, which is an e_instance
  the_iobusMDIO_1_slave : iobusMDIO_1_slave_arbitrator
    port map(
      cpu_data_master_granted_iobusMDIO_1_slave => cpu_data_master_granted_iobusMDIO_1_slave,
      cpu_data_master_qualified_request_iobusMDIO_1_slave => cpu_data_master_qualified_request_iobusMDIO_1_slave,
      cpu_data_master_read_data_valid_iobusMDIO_1_slave => cpu_data_master_read_data_valid_iobusMDIO_1_slave,
      cpu_data_master_read_data_valid_iobusMDIO_1_slave_shift_register => cpu_data_master_read_data_valid_iobusMDIO_1_slave_shift_register,
      cpu_data_master_requests_iobusMDIO_1_slave => cpu_data_master_requests_iobusMDIO_1_slave,
      d1_iobusMDIO_1_slave_end_xfer => d1_iobusMDIO_1_slave_end_xfer,
      iobusMDIO_1_slave_address => iobusMDIO_1_slave_address,
      iobusMDIO_1_slave_read => iobusMDIO_1_slave_read,
      iobusMDIO_1_slave_readdata_from_sa => iobusMDIO_1_slave_readdata_from_sa,
      iobusMDIO_1_slave_reset => iobusMDIO_1_slave_reset,
      iobusMDIO_1_slave_waitrequest_from_sa => iobusMDIO_1_slave_waitrequest_from_sa,
      iobusMDIO_1_slave_write => iobusMDIO_1_slave_write,
      iobusMDIO_1_slave_writedata => iobusMDIO_1_slave_writedata,
      clk => clk1,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      iobusMDIO_1_slave_readdata => iobusMDIO_1_slave_readdata,
      iobusMDIO_1_slave_readdatavalid => iobusMDIO_1_slave_readdatavalid,
      iobusMDIO_1_slave_waitrequest => iobusMDIO_1_slave_waitrequest,
      reset_n => clk1_reset_n
    );


  --the_iobusMDIO_1, which is an e_ptf_instance
  the_iobusMDIO_1 : iobusMDIO_1
    port map(
      mmreaddata => iobusMDIO_1_slave_readdata,
      mmreaddatavalid => iobusMDIO_1_slave_readdatavalid,
      mmwaitrequest => iobusMDIO_1_slave_waitrequest,
      s_address => internal_s_address_from_the_iobusMDIO_1,
      s_clk => internal_s_clk_from_the_iobusMDIO_1,
      s_read => internal_s_read_from_the_iobusMDIO_1,
      s_rst => internal_s_rst_from_the_iobusMDIO_1,
      s_write => internal_s_write_from_the_iobusMDIO_1,
      s_writedata => internal_s_writedata_from_the_iobusMDIO_1,
      clk => clk1,
      mmaddress => iobusMDIO_1_slave_address,
      mmread => iobusMDIO_1_slave_read,
      mmwrite => iobusMDIO_1_slave_write,
      mmwritedata => iobusMDIO_1_slave_writedata,
      rst => iobusMDIO_1_slave_reset,
      s_readdata => s_readdata_to_the_iobusMDIO_1,
      s_readdatavalid => s_readdatavalid_to_the_iobusMDIO_1,
      s_waitrequest => s_waitrequest_to_the_iobusMDIO_1
    );


  --the_iobusMDIO_2_slave, which is an e_instance
  the_iobusMDIO_2_slave : iobusMDIO_2_slave_arbitrator
    port map(
      cpu_data_master_granted_iobusMDIO_2_slave => cpu_data_master_granted_iobusMDIO_2_slave,
      cpu_data_master_qualified_request_iobusMDIO_2_slave => cpu_data_master_qualified_request_iobusMDIO_2_slave,
      cpu_data_master_read_data_valid_iobusMDIO_2_slave => cpu_data_master_read_data_valid_iobusMDIO_2_slave,
      cpu_data_master_read_data_valid_iobusMDIO_2_slave_shift_register => cpu_data_master_read_data_valid_iobusMDIO_2_slave_shift_register,
      cpu_data_master_requests_iobusMDIO_2_slave => cpu_data_master_requests_iobusMDIO_2_slave,
      d1_iobusMDIO_2_slave_end_xfer => d1_iobusMDIO_2_slave_end_xfer,
      iobusMDIO_2_slave_address => iobusMDIO_2_slave_address,
      iobusMDIO_2_slave_read => iobusMDIO_2_slave_read,
      iobusMDIO_2_slave_readdata_from_sa => iobusMDIO_2_slave_readdata_from_sa,
      iobusMDIO_2_slave_reset => iobusMDIO_2_slave_reset,
      iobusMDIO_2_slave_waitrequest_from_sa => iobusMDIO_2_slave_waitrequest_from_sa,
      iobusMDIO_2_slave_write => iobusMDIO_2_slave_write,
      iobusMDIO_2_slave_writedata => iobusMDIO_2_slave_writedata,
      clk => clk1,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      iobusMDIO_2_slave_readdata => iobusMDIO_2_slave_readdata,
      iobusMDIO_2_slave_readdatavalid => iobusMDIO_2_slave_readdatavalid,
      iobusMDIO_2_slave_waitrequest => iobusMDIO_2_slave_waitrequest,
      reset_n => clk1_reset_n
    );


  --the_iobusMDIO_2, which is an e_ptf_instance
  the_iobusMDIO_2 : iobusMDIO_2
    port map(
      mmreaddata => iobusMDIO_2_slave_readdata,
      mmreaddatavalid => iobusMDIO_2_slave_readdatavalid,
      mmwaitrequest => iobusMDIO_2_slave_waitrequest,
      s_address => internal_s_address_from_the_iobusMDIO_2,
      s_clk => internal_s_clk_from_the_iobusMDIO_2,
      s_read => internal_s_read_from_the_iobusMDIO_2,
      s_rst => internal_s_rst_from_the_iobusMDIO_2,
      s_write => internal_s_write_from_the_iobusMDIO_2,
      s_writedata => internal_s_writedata_from_the_iobusMDIO_2,
      clk => clk1,
      mmaddress => iobusMDIO_2_slave_address,
      mmread => iobusMDIO_2_slave_read,
      mmwrite => iobusMDIO_2_slave_write,
      mmwritedata => iobusMDIO_2_slave_writedata,
      rst => iobusMDIO_2_slave_reset,
      s_readdata => s_readdata_to_the_iobusMDIO_2,
      s_readdatavalid => s_readdatavalid_to_the_iobusMDIO_2,
      s_waitrequest => s_waitrequest_to_the_iobusMDIO_2
    );


  --the_iobusMDIO_3_slave, which is an e_instance
  the_iobusMDIO_3_slave : iobusMDIO_3_slave_arbitrator
    port map(
      cpu_data_master_granted_iobusMDIO_3_slave => cpu_data_master_granted_iobusMDIO_3_slave,
      cpu_data_master_qualified_request_iobusMDIO_3_slave => cpu_data_master_qualified_request_iobusMDIO_3_slave,
      cpu_data_master_read_data_valid_iobusMDIO_3_slave => cpu_data_master_read_data_valid_iobusMDIO_3_slave,
      cpu_data_master_read_data_valid_iobusMDIO_3_slave_shift_register => cpu_data_master_read_data_valid_iobusMDIO_3_slave_shift_register,
      cpu_data_master_requests_iobusMDIO_3_slave => cpu_data_master_requests_iobusMDIO_3_slave,
      d1_iobusMDIO_3_slave_end_xfer => d1_iobusMDIO_3_slave_end_xfer,
      iobusMDIO_3_slave_address => iobusMDIO_3_slave_address,
      iobusMDIO_3_slave_read => iobusMDIO_3_slave_read,
      iobusMDIO_3_slave_readdata_from_sa => iobusMDIO_3_slave_readdata_from_sa,
      iobusMDIO_3_slave_reset => iobusMDIO_3_slave_reset,
      iobusMDIO_3_slave_waitrequest_from_sa => iobusMDIO_3_slave_waitrequest_from_sa,
      iobusMDIO_3_slave_write => iobusMDIO_3_slave_write,
      iobusMDIO_3_slave_writedata => iobusMDIO_3_slave_writedata,
      clk => clk1,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      iobusMDIO_3_slave_readdata => iobusMDIO_3_slave_readdata,
      iobusMDIO_3_slave_readdatavalid => iobusMDIO_3_slave_readdatavalid,
      iobusMDIO_3_slave_waitrequest => iobusMDIO_3_slave_waitrequest,
      reset_n => clk1_reset_n
    );


  --the_iobusMDIO_3, which is an e_ptf_instance
  the_iobusMDIO_3 : iobusMDIO_3
    port map(
      mmreaddata => iobusMDIO_3_slave_readdata,
      mmreaddatavalid => iobusMDIO_3_slave_readdatavalid,
      mmwaitrequest => iobusMDIO_3_slave_waitrequest,
      s_address => internal_s_address_from_the_iobusMDIO_3,
      s_clk => internal_s_clk_from_the_iobusMDIO_3,
      s_read => internal_s_read_from_the_iobusMDIO_3,
      s_rst => internal_s_rst_from_the_iobusMDIO_3,
      s_write => internal_s_write_from_the_iobusMDIO_3,
      s_writedata => internal_s_writedata_from_the_iobusMDIO_3,
      clk => clk1,
      mmaddress => iobusMDIO_3_slave_address,
      mmread => iobusMDIO_3_slave_read,
      mmwrite => iobusMDIO_3_slave_write,
      mmwritedata => iobusMDIO_3_slave_writedata,
      rst => iobusMDIO_3_slave_reset,
      s_readdata => s_readdata_to_the_iobusMDIO_3,
      s_readdatavalid => s_readdatavalid_to_the_iobusMDIO_3,
      s_waitrequest => s_waitrequest_to_the_iobusMDIO_3
    );


  --the_iobusMDIO_4_slave, which is an e_instance
  the_iobusMDIO_4_slave : iobusMDIO_4_slave_arbitrator
    port map(
      cpu_data_master_granted_iobusMDIO_4_slave => cpu_data_master_granted_iobusMDIO_4_slave,
      cpu_data_master_qualified_request_iobusMDIO_4_slave => cpu_data_master_qualified_request_iobusMDIO_4_slave,
      cpu_data_master_read_data_valid_iobusMDIO_4_slave => cpu_data_master_read_data_valid_iobusMDIO_4_slave,
      cpu_data_master_read_data_valid_iobusMDIO_4_slave_shift_register => cpu_data_master_read_data_valid_iobusMDIO_4_slave_shift_register,
      cpu_data_master_requests_iobusMDIO_4_slave => cpu_data_master_requests_iobusMDIO_4_slave,
      d1_iobusMDIO_4_slave_end_xfer => d1_iobusMDIO_4_slave_end_xfer,
      iobusMDIO_4_slave_address => iobusMDIO_4_slave_address,
      iobusMDIO_4_slave_read => iobusMDIO_4_slave_read,
      iobusMDIO_4_slave_readdata_from_sa => iobusMDIO_4_slave_readdata_from_sa,
      iobusMDIO_4_slave_reset => iobusMDIO_4_slave_reset,
      iobusMDIO_4_slave_waitrequest_from_sa => iobusMDIO_4_slave_waitrequest_from_sa,
      iobusMDIO_4_slave_write => iobusMDIO_4_slave_write,
      iobusMDIO_4_slave_writedata => iobusMDIO_4_slave_writedata,
      clk => clk1,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      iobusMDIO_4_slave_readdata => iobusMDIO_4_slave_readdata,
      iobusMDIO_4_slave_readdatavalid => iobusMDIO_4_slave_readdatavalid,
      iobusMDIO_4_slave_waitrequest => iobusMDIO_4_slave_waitrequest,
      reset_n => clk1_reset_n
    );


  --the_iobusMDIO_4, which is an e_ptf_instance
  the_iobusMDIO_4 : iobusMDIO_4
    port map(
      mmreaddata => iobusMDIO_4_slave_readdata,
      mmreaddatavalid => iobusMDIO_4_slave_readdatavalid,
      mmwaitrequest => iobusMDIO_4_slave_waitrequest,
      s_address => internal_s_address_from_the_iobusMDIO_4,
      s_clk => internal_s_clk_from_the_iobusMDIO_4,
      s_read => internal_s_read_from_the_iobusMDIO_4,
      s_rst => internal_s_rst_from_the_iobusMDIO_4,
      s_write => internal_s_write_from_the_iobusMDIO_4,
      s_writedata => internal_s_writedata_from_the_iobusMDIO_4,
      clk => clk1,
      mmaddress => iobusMDIO_4_slave_address,
      mmread => iobusMDIO_4_slave_read,
      mmwrite => iobusMDIO_4_slave_write,
      mmwritedata => iobusMDIO_4_slave_writedata,
      rst => iobusMDIO_4_slave_reset,
      s_readdata => s_readdata_to_the_iobusMDIO_4,
      s_readdatavalid => s_readdatavalid_to_the_iobusMDIO_4,
      s_waitrequest => s_waitrequest_to_the_iobusMDIO_4
    );


  --the_iobusMDIO_5_slave, which is an e_instance
  the_iobusMDIO_5_slave : iobusMDIO_5_slave_arbitrator
    port map(
      cpu_data_master_granted_iobusMDIO_5_slave => cpu_data_master_granted_iobusMDIO_5_slave,
      cpu_data_master_qualified_request_iobusMDIO_5_slave => cpu_data_master_qualified_request_iobusMDIO_5_slave,
      cpu_data_master_read_data_valid_iobusMDIO_5_slave => cpu_data_master_read_data_valid_iobusMDIO_5_slave,
      cpu_data_master_read_data_valid_iobusMDIO_5_slave_shift_register => cpu_data_master_read_data_valid_iobusMDIO_5_slave_shift_register,
      cpu_data_master_requests_iobusMDIO_5_slave => cpu_data_master_requests_iobusMDIO_5_slave,
      d1_iobusMDIO_5_slave_end_xfer => d1_iobusMDIO_5_slave_end_xfer,
      iobusMDIO_5_slave_address => iobusMDIO_5_slave_address,
      iobusMDIO_5_slave_read => iobusMDIO_5_slave_read,
      iobusMDIO_5_slave_readdata_from_sa => iobusMDIO_5_slave_readdata_from_sa,
      iobusMDIO_5_slave_reset => iobusMDIO_5_slave_reset,
      iobusMDIO_5_slave_waitrequest_from_sa => iobusMDIO_5_slave_waitrequest_from_sa,
      iobusMDIO_5_slave_write => iobusMDIO_5_slave_write,
      iobusMDIO_5_slave_writedata => iobusMDIO_5_slave_writedata,
      clk => clk1,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      iobusMDIO_5_slave_readdata => iobusMDIO_5_slave_readdata,
      iobusMDIO_5_slave_readdatavalid => iobusMDIO_5_slave_readdatavalid,
      iobusMDIO_5_slave_waitrequest => iobusMDIO_5_slave_waitrequest,
      reset_n => clk1_reset_n
    );


  --the_iobusMDIO_5, which is an e_ptf_instance
  the_iobusMDIO_5 : iobusMDIO_5
    port map(
      mmreaddata => iobusMDIO_5_slave_readdata,
      mmreaddatavalid => iobusMDIO_5_slave_readdatavalid,
      mmwaitrequest => iobusMDIO_5_slave_waitrequest,
      s_address => internal_s_address_from_the_iobusMDIO_5,
      s_clk => internal_s_clk_from_the_iobusMDIO_5,
      s_read => internal_s_read_from_the_iobusMDIO_5,
      s_rst => internal_s_rst_from_the_iobusMDIO_5,
      s_write => internal_s_write_from_the_iobusMDIO_5,
      s_writedata => internal_s_writedata_from_the_iobusMDIO_5,
      clk => clk1,
      mmaddress => iobusMDIO_5_slave_address,
      mmread => iobusMDIO_5_slave_read,
      mmwrite => iobusMDIO_5_slave_write,
      mmwritedata => iobusMDIO_5_slave_writedata,
      rst => iobusMDIO_5_slave_reset,
      s_readdata => s_readdata_to_the_iobusMDIO_5,
      s_readdatavalid => s_readdatavalid_to_the_iobusMDIO_5,
      s_waitrequest => s_waitrequest_to_the_iobusMDIO_5
    );


  --the_iobusMDIO_6_slave, which is an e_instance
  the_iobusMDIO_6_slave : iobusMDIO_6_slave_arbitrator
    port map(
      cpu_data_master_granted_iobusMDIO_6_slave => cpu_data_master_granted_iobusMDIO_6_slave,
      cpu_data_master_qualified_request_iobusMDIO_6_slave => cpu_data_master_qualified_request_iobusMDIO_6_slave,
      cpu_data_master_read_data_valid_iobusMDIO_6_slave => cpu_data_master_read_data_valid_iobusMDIO_6_slave,
      cpu_data_master_read_data_valid_iobusMDIO_6_slave_shift_register => cpu_data_master_read_data_valid_iobusMDIO_6_slave_shift_register,
      cpu_data_master_requests_iobusMDIO_6_slave => cpu_data_master_requests_iobusMDIO_6_slave,
      d1_iobusMDIO_6_slave_end_xfer => d1_iobusMDIO_6_slave_end_xfer,
      iobusMDIO_6_slave_address => iobusMDIO_6_slave_address,
      iobusMDIO_6_slave_read => iobusMDIO_6_slave_read,
      iobusMDIO_6_slave_readdata_from_sa => iobusMDIO_6_slave_readdata_from_sa,
      iobusMDIO_6_slave_reset => iobusMDIO_6_slave_reset,
      iobusMDIO_6_slave_waitrequest_from_sa => iobusMDIO_6_slave_waitrequest_from_sa,
      iobusMDIO_6_slave_write => iobusMDIO_6_slave_write,
      iobusMDIO_6_slave_writedata => iobusMDIO_6_slave_writedata,
      clk => clk1,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      iobusMDIO_6_slave_readdata => iobusMDIO_6_slave_readdata,
      iobusMDIO_6_slave_readdatavalid => iobusMDIO_6_slave_readdatavalid,
      iobusMDIO_6_slave_waitrequest => iobusMDIO_6_slave_waitrequest,
      reset_n => clk1_reset_n
    );


  --the_iobusMDIO_6, which is an e_ptf_instance
  the_iobusMDIO_6 : iobusMDIO_6
    port map(
      mmreaddata => iobusMDIO_6_slave_readdata,
      mmreaddatavalid => iobusMDIO_6_slave_readdatavalid,
      mmwaitrequest => iobusMDIO_6_slave_waitrequest,
      s_address => internal_s_address_from_the_iobusMDIO_6,
      s_clk => internal_s_clk_from_the_iobusMDIO_6,
      s_read => internal_s_read_from_the_iobusMDIO_6,
      s_rst => internal_s_rst_from_the_iobusMDIO_6,
      s_write => internal_s_write_from_the_iobusMDIO_6,
      s_writedata => internal_s_writedata_from_the_iobusMDIO_6,
      clk => clk1,
      mmaddress => iobusMDIO_6_slave_address,
      mmread => iobusMDIO_6_slave_read,
      mmwrite => iobusMDIO_6_slave_write,
      mmwritedata => iobusMDIO_6_slave_writedata,
      rst => iobusMDIO_6_slave_reset,
      s_readdata => s_readdata_to_the_iobusMDIO_6,
      s_readdatavalid => s_readdatavalid_to_the_iobusMDIO_6,
      s_waitrequest => s_waitrequest_to_the_iobusMDIO_6
    );


  --the_iobusMDIO_7_slave, which is an e_instance
  the_iobusMDIO_7_slave : iobusMDIO_7_slave_arbitrator
    port map(
      cpu_data_master_granted_iobusMDIO_7_slave => cpu_data_master_granted_iobusMDIO_7_slave,
      cpu_data_master_qualified_request_iobusMDIO_7_slave => cpu_data_master_qualified_request_iobusMDIO_7_slave,
      cpu_data_master_read_data_valid_iobusMDIO_7_slave => cpu_data_master_read_data_valid_iobusMDIO_7_slave,
      cpu_data_master_read_data_valid_iobusMDIO_7_slave_shift_register => cpu_data_master_read_data_valid_iobusMDIO_7_slave_shift_register,
      cpu_data_master_requests_iobusMDIO_7_slave => cpu_data_master_requests_iobusMDIO_7_slave,
      d1_iobusMDIO_7_slave_end_xfer => d1_iobusMDIO_7_slave_end_xfer,
      iobusMDIO_7_slave_address => iobusMDIO_7_slave_address,
      iobusMDIO_7_slave_read => iobusMDIO_7_slave_read,
      iobusMDIO_7_slave_readdata_from_sa => iobusMDIO_7_slave_readdata_from_sa,
      iobusMDIO_7_slave_reset => iobusMDIO_7_slave_reset,
      iobusMDIO_7_slave_waitrequest_from_sa => iobusMDIO_7_slave_waitrequest_from_sa,
      iobusMDIO_7_slave_write => iobusMDIO_7_slave_write,
      iobusMDIO_7_slave_writedata => iobusMDIO_7_slave_writedata,
      clk => clk1,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      iobusMDIO_7_slave_readdata => iobusMDIO_7_slave_readdata,
      iobusMDIO_7_slave_readdatavalid => iobusMDIO_7_slave_readdatavalid,
      iobusMDIO_7_slave_waitrequest => iobusMDIO_7_slave_waitrequest,
      reset_n => clk1_reset_n
    );


  --the_iobusMDIO_7, which is an e_ptf_instance
  the_iobusMDIO_7 : iobusMDIO_7
    port map(
      mmreaddata => iobusMDIO_7_slave_readdata,
      mmreaddatavalid => iobusMDIO_7_slave_readdatavalid,
      mmwaitrequest => iobusMDIO_7_slave_waitrequest,
      s_address => internal_s_address_from_the_iobusMDIO_7,
      s_clk => internal_s_clk_from_the_iobusMDIO_7,
      s_read => internal_s_read_from_the_iobusMDIO_7,
      s_rst => internal_s_rst_from_the_iobusMDIO_7,
      s_write => internal_s_write_from_the_iobusMDIO_7,
      s_writedata => internal_s_writedata_from_the_iobusMDIO_7,
      clk => clk1,
      mmaddress => iobusMDIO_7_slave_address,
      mmread => iobusMDIO_7_slave_read,
      mmwrite => iobusMDIO_7_slave_write,
      mmwritedata => iobusMDIO_7_slave_writedata,
      rst => iobusMDIO_7_slave_reset,
      s_readdata => s_readdata_to_the_iobusMDIO_7,
      s_readdatavalid => s_readdatavalid_to_the_iobusMDIO_7,
      s_waitrequest => s_waitrequest_to_the_iobusMDIO_7
    );


  --the_iobusREGFILE_0_slave, which is an e_instance
  the_iobusREGFILE_0_slave : iobusREGFILE_0_slave_arbitrator
    port map(
      cpu_data_master_granted_iobusREGFILE_0_slave => cpu_data_master_granted_iobusREGFILE_0_slave,
      cpu_data_master_qualified_request_iobusREGFILE_0_slave => cpu_data_master_qualified_request_iobusREGFILE_0_slave,
      cpu_data_master_read_data_valid_iobusREGFILE_0_slave => cpu_data_master_read_data_valid_iobusREGFILE_0_slave,
      cpu_data_master_read_data_valid_iobusREGFILE_0_slave_shift_register => cpu_data_master_read_data_valid_iobusREGFILE_0_slave_shift_register,
      cpu_data_master_requests_iobusREGFILE_0_slave => cpu_data_master_requests_iobusREGFILE_0_slave,
      d1_iobusREGFILE_0_slave_end_xfer => d1_iobusREGFILE_0_slave_end_xfer,
      iobusREGFILE_0_slave_address => iobusREGFILE_0_slave_address,
      iobusREGFILE_0_slave_read => iobusREGFILE_0_slave_read,
      iobusREGFILE_0_slave_readdata_from_sa => iobusREGFILE_0_slave_readdata_from_sa,
      iobusREGFILE_0_slave_reset => iobusREGFILE_0_slave_reset,
      iobusREGFILE_0_slave_waitrequest_from_sa => iobusREGFILE_0_slave_waitrequest_from_sa,
      iobusREGFILE_0_slave_write => iobusREGFILE_0_slave_write,
      iobusREGFILE_0_slave_writedata => iobusREGFILE_0_slave_writedata,
      clk => clk1,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      iobusREGFILE_0_slave_readdata => iobusREGFILE_0_slave_readdata,
      iobusREGFILE_0_slave_readdatavalid => iobusREGFILE_0_slave_readdatavalid,
      iobusREGFILE_0_slave_waitrequest => iobusREGFILE_0_slave_waitrequest,
      reset_n => clk1_reset_n
    );


  --the_iobusREGFILE_0, which is an e_ptf_instance
  the_iobusREGFILE_0 : iobusREGFILE_0
    port map(
      mmreaddata => iobusREGFILE_0_slave_readdata,
      mmreaddatavalid => iobusREGFILE_0_slave_readdatavalid,
      mmwaitrequest => iobusREGFILE_0_slave_waitrequest,
      s_address => internal_s_address_from_the_iobusREGFILE_0,
      s_clk => internal_s_clk_from_the_iobusREGFILE_0,
      s_read => internal_s_read_from_the_iobusREGFILE_0,
      s_rst => internal_s_rst_from_the_iobusREGFILE_0,
      s_write => internal_s_write_from_the_iobusREGFILE_0,
      s_writedata => internal_s_writedata_from_the_iobusREGFILE_0,
      clk => clk1,
      mmaddress => iobusREGFILE_0_slave_address,
      mmread => iobusREGFILE_0_slave_read,
      mmwrite => iobusREGFILE_0_slave_write,
      mmwritedata => iobusREGFILE_0_slave_writedata,
      rst => iobusREGFILE_0_slave_reset,
      s_readdata => s_readdata_to_the_iobusREGFILE_0,
      s_readdatavalid => s_readdatavalid_to_the_iobusREGFILE_0,
      s_waitrequest => s_waitrequest_to_the_iobusREGFILE_0
    );


  --the_jtag_uart_avalon_jtag_slave, which is an e_instance
  the_jtag_uart_avalon_jtag_slave : jtag_uart_avalon_jtag_slave_arbitrator
    port map(
      cpu_data_master_granted_jtag_uart_avalon_jtag_slave => cpu_data_master_granted_jtag_uart_avalon_jtag_slave,
      cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave => cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave,
      cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave => cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave,
      cpu_data_master_requests_jtag_uart_avalon_jtag_slave => cpu_data_master_requests_jtag_uart_avalon_jtag_slave,
      d1_jtag_uart_avalon_jtag_slave_end_xfer => d1_jtag_uart_avalon_jtag_slave_end_xfer,
      jtag_uart_avalon_jtag_slave_address => jtag_uart_avalon_jtag_slave_address,
      jtag_uart_avalon_jtag_slave_chipselect => jtag_uart_avalon_jtag_slave_chipselect,
      jtag_uart_avalon_jtag_slave_dataavailable_from_sa => jtag_uart_avalon_jtag_slave_dataavailable_from_sa,
      jtag_uart_avalon_jtag_slave_irq_from_sa => jtag_uart_avalon_jtag_slave_irq_from_sa,
      jtag_uart_avalon_jtag_slave_read_n => jtag_uart_avalon_jtag_slave_read_n,
      jtag_uart_avalon_jtag_slave_readdata_from_sa => jtag_uart_avalon_jtag_slave_readdata_from_sa,
      jtag_uart_avalon_jtag_slave_readyfordata_from_sa => jtag_uart_avalon_jtag_slave_readyfordata_from_sa,
      jtag_uart_avalon_jtag_slave_reset_n => jtag_uart_avalon_jtag_slave_reset_n,
      jtag_uart_avalon_jtag_slave_waitrequest_from_sa => jtag_uart_avalon_jtag_slave_waitrequest_from_sa,
      jtag_uart_avalon_jtag_slave_write_n => jtag_uart_avalon_jtag_slave_write_n,
      jtag_uart_avalon_jtag_slave_writedata => jtag_uart_avalon_jtag_slave_writedata,
      clk => clk1,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      jtag_uart_avalon_jtag_slave_dataavailable => jtag_uart_avalon_jtag_slave_dataavailable,
      jtag_uart_avalon_jtag_slave_irq => jtag_uart_avalon_jtag_slave_irq,
      jtag_uart_avalon_jtag_slave_readdata => jtag_uart_avalon_jtag_slave_readdata,
      jtag_uart_avalon_jtag_slave_readyfordata => jtag_uart_avalon_jtag_slave_readyfordata,
      jtag_uart_avalon_jtag_slave_waitrequest => jtag_uart_avalon_jtag_slave_waitrequest,
      reset_n => clk1_reset_n
    );


  --the_jtag_uart, which is an e_ptf_instance
  the_jtag_uart : jtag_uart
    port map(
      av_irq => jtag_uart_avalon_jtag_slave_irq,
      av_readdata => jtag_uart_avalon_jtag_slave_readdata,
      av_waitrequest => jtag_uart_avalon_jtag_slave_waitrequest,
      dataavailable => jtag_uart_avalon_jtag_slave_dataavailable,
      readyfordata => jtag_uart_avalon_jtag_slave_readyfordata,
      av_address => jtag_uart_avalon_jtag_slave_address,
      av_chipselect => jtag_uart_avalon_jtag_slave_chipselect,
      av_read_n => jtag_uart_avalon_jtag_slave_read_n,
      av_write_n => jtag_uart_avalon_jtag_slave_write_n,
      av_writedata => jtag_uart_avalon_jtag_slave_writedata,
      clk => clk1,
      rst_n => jtag_uart_avalon_jtag_slave_reset_n
    );


  --the_mem_s1, which is an e_instance
  the_mem_s1 : mem_s1_arbitrator
    port map(
      cpu_data_master_granted_mem_s1 => cpu_data_master_granted_mem_s1,
      cpu_data_master_qualified_request_mem_s1 => cpu_data_master_qualified_request_mem_s1,
      cpu_data_master_read_data_valid_mem_s1 => cpu_data_master_read_data_valid_mem_s1,
      cpu_data_master_requests_mem_s1 => cpu_data_master_requests_mem_s1,
      cpu_instruction_master_granted_mem_s1 => cpu_instruction_master_granted_mem_s1,
      cpu_instruction_master_qualified_request_mem_s1 => cpu_instruction_master_qualified_request_mem_s1,
      cpu_instruction_master_read_data_valid_mem_s1 => cpu_instruction_master_read_data_valid_mem_s1,
      cpu_instruction_master_requests_mem_s1 => cpu_instruction_master_requests_mem_s1,
      d1_mem_s1_end_xfer => d1_mem_s1_end_xfer,
      mem_s1_address => mem_s1_address,
      mem_s1_byteenable => mem_s1_byteenable,
      mem_s1_chipselect => mem_s1_chipselect,
      mem_s1_clken => mem_s1_clken,
      mem_s1_readdata_from_sa => mem_s1_readdata_from_sa,
      mem_s1_write => mem_s1_write,
      mem_s1_writedata => mem_s1_writedata,
      registered_cpu_data_master_read_data_valid_mem_s1 => registered_cpu_data_master_read_data_valid_mem_s1,
      clk => clk1,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_byteenable => cpu_data_master_byteenable,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      cpu_instruction_master_address_to_slave => cpu_instruction_master_address_to_slave,
      cpu_instruction_master_read => cpu_instruction_master_read,
      mem_s1_readdata => mem_s1_readdata,
      reset_n => clk1_reset_n
    );


  --the_mem, which is an e_ptf_instance
  the_mem : mem
    port map(
      readdata => mem_s1_readdata,
      address => mem_s1_address,
      byteenable => mem_s1_byteenable,
      chipselect => mem_s1_chipselect,
      clk => clk1,
      clken => mem_s1_clken,
      write => mem_s1_write,
      writedata => mem_s1_writedata
    );


  --the_rs232_uart_s1, which is an e_instance
  the_rs232_uart_s1 : rs232_uart_s1_arbitrator
    port map(
      cpu_data_master_granted_rs232_uart_s1 => cpu_data_master_granted_rs232_uart_s1,
      cpu_data_master_qualified_request_rs232_uart_s1 => cpu_data_master_qualified_request_rs232_uart_s1,
      cpu_data_master_read_data_valid_rs232_uart_s1 => cpu_data_master_read_data_valid_rs232_uart_s1,
      cpu_data_master_requests_rs232_uart_s1 => cpu_data_master_requests_rs232_uart_s1,
      d1_rs232_uart_s1_end_xfer => d1_rs232_uart_s1_end_xfer,
      rs232_uart_s1_address => rs232_uart_s1_address,
      rs232_uart_s1_begintransfer => rs232_uart_s1_begintransfer,
      rs232_uart_s1_chipselect => rs232_uart_s1_chipselect,
      rs232_uart_s1_dataavailable_from_sa => rs232_uart_s1_dataavailable_from_sa,
      rs232_uart_s1_irq_from_sa => rs232_uart_s1_irq_from_sa,
      rs232_uart_s1_read_n => rs232_uart_s1_read_n,
      rs232_uart_s1_readdata_from_sa => rs232_uart_s1_readdata_from_sa,
      rs232_uart_s1_readyfordata_from_sa => rs232_uart_s1_readyfordata_from_sa,
      rs232_uart_s1_reset_n => rs232_uart_s1_reset_n,
      rs232_uart_s1_write_n => rs232_uart_s1_write_n,
      rs232_uart_s1_writedata => rs232_uart_s1_writedata,
      clk => clk1,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      reset_n => clk1_reset_n,
      rs232_uart_s1_dataavailable => rs232_uart_s1_dataavailable,
      rs232_uart_s1_irq => rs232_uart_s1_irq,
      rs232_uart_s1_readdata => rs232_uart_s1_readdata,
      rs232_uart_s1_readyfordata => rs232_uart_s1_readyfordata
    );


  --the_rs232_uart, which is an e_ptf_instance
  the_rs232_uart : rs232_uart
    port map(
      dataavailable => rs232_uart_s1_dataavailable,
      irq => rs232_uart_s1_irq,
      readdata => rs232_uart_s1_readdata,
      readyfordata => rs232_uart_s1_readyfordata,
      txd => internal_txd_from_the_rs232_uart,
      address => rs232_uart_s1_address,
      begintransfer => rs232_uart_s1_begintransfer,
      chipselect => rs232_uart_s1_chipselect,
      clk => clk1,
      read_n => rs232_uart_s1_read_n,
      reset_n => rs232_uart_s1_reset_n,
      rxd => rxd_to_the_rs232_uart,
      write_n => rs232_uart_s1_write_n,
      writedata => rs232_uart_s1_writedata
    );


  --reset is asserted asynchronously and deasserted synchronously
  nios_reset_clk1_domain_synch : nios_reset_clk1_domain_synch_module
    port map(
      data_out => clk1_reset_n,
      clk => clk1,
      data_in => module_input51,
      reset_n => reset_n_sources
    );

  module_input51 <= std_logic'('1');

  --reset sources mux, which is an e_mux
  reset_n_sources <= Vector_To_Std_Logic(NOT (((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT reset_n))) OR std_logic_vector'("00000000000000000000000000000000")) OR (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_jtag_debug_module_resetrequest_from_sa)))) OR (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_jtag_debug_module_resetrequest_from_sa))))));
  --vhdl renameroo for output signals
  s_address_from_the_iobusMAC_0 <= internal_s_address_from_the_iobusMAC_0;
  --vhdl renameroo for output signals
  s_address_from_the_iobusMAC_1 <= internal_s_address_from_the_iobusMAC_1;
  --vhdl renameroo for output signals
  s_address_from_the_iobusMAC_2 <= internal_s_address_from_the_iobusMAC_2;
  --vhdl renameroo for output signals
  s_address_from_the_iobusMAC_3 <= internal_s_address_from_the_iobusMAC_3;
  --vhdl renameroo for output signals
  s_address_from_the_iobusMAC_4 <= internal_s_address_from_the_iobusMAC_4;
  --vhdl renameroo for output signals
  s_address_from_the_iobusMAC_5 <= internal_s_address_from_the_iobusMAC_5;
  --vhdl renameroo for output signals
  s_address_from_the_iobusMAC_6 <= internal_s_address_from_the_iobusMAC_6;
  --vhdl renameroo for output signals
  s_address_from_the_iobusMAC_7 <= internal_s_address_from_the_iobusMAC_7;
  --vhdl renameroo for output signals
  s_address_from_the_iobusMDIO_0 <= internal_s_address_from_the_iobusMDIO_0;
  --vhdl renameroo for output signals
  s_address_from_the_iobusMDIO_1 <= internal_s_address_from_the_iobusMDIO_1;
  --vhdl renameroo for output signals
  s_address_from_the_iobusMDIO_2 <= internal_s_address_from_the_iobusMDIO_2;
  --vhdl renameroo for output signals
  s_address_from_the_iobusMDIO_3 <= internal_s_address_from_the_iobusMDIO_3;
  --vhdl renameroo for output signals
  s_address_from_the_iobusMDIO_4 <= internal_s_address_from_the_iobusMDIO_4;
  --vhdl renameroo for output signals
  s_address_from_the_iobusMDIO_5 <= internal_s_address_from_the_iobusMDIO_5;
  --vhdl renameroo for output signals
  s_address_from_the_iobusMDIO_6 <= internal_s_address_from_the_iobusMDIO_6;
  --vhdl renameroo for output signals
  s_address_from_the_iobusMDIO_7 <= internal_s_address_from_the_iobusMDIO_7;
  --vhdl renameroo for output signals
  s_address_from_the_iobusREGFILE_0 <= internal_s_address_from_the_iobusREGFILE_0;
  --vhdl renameroo for output signals
  s_clk_from_the_iobusMAC_0 <= internal_s_clk_from_the_iobusMAC_0;
  --vhdl renameroo for output signals
  s_clk_from_the_iobusMAC_1 <= internal_s_clk_from_the_iobusMAC_1;
  --vhdl renameroo for output signals
  s_clk_from_the_iobusMAC_2 <= internal_s_clk_from_the_iobusMAC_2;
  --vhdl renameroo for output signals
  s_clk_from_the_iobusMAC_3 <= internal_s_clk_from_the_iobusMAC_3;
  --vhdl renameroo for output signals
  s_clk_from_the_iobusMAC_4 <= internal_s_clk_from_the_iobusMAC_4;
  --vhdl renameroo for output signals
  s_clk_from_the_iobusMAC_5 <= internal_s_clk_from_the_iobusMAC_5;
  --vhdl renameroo for output signals
  s_clk_from_the_iobusMAC_6 <= internal_s_clk_from_the_iobusMAC_6;
  --vhdl renameroo for output signals
  s_clk_from_the_iobusMAC_7 <= internal_s_clk_from_the_iobusMAC_7;
  --vhdl renameroo for output signals
  s_clk_from_the_iobusMDIO_0 <= internal_s_clk_from_the_iobusMDIO_0;
  --vhdl renameroo for output signals
  s_clk_from_the_iobusMDIO_1 <= internal_s_clk_from_the_iobusMDIO_1;
  --vhdl renameroo for output signals
  s_clk_from_the_iobusMDIO_2 <= internal_s_clk_from_the_iobusMDIO_2;
  --vhdl renameroo for output signals
  s_clk_from_the_iobusMDIO_3 <= internal_s_clk_from_the_iobusMDIO_3;
  --vhdl renameroo for output signals
  s_clk_from_the_iobusMDIO_4 <= internal_s_clk_from_the_iobusMDIO_4;
  --vhdl renameroo for output signals
  s_clk_from_the_iobusMDIO_5 <= internal_s_clk_from_the_iobusMDIO_5;
  --vhdl renameroo for output signals
  s_clk_from_the_iobusMDIO_6 <= internal_s_clk_from_the_iobusMDIO_6;
  --vhdl renameroo for output signals
  s_clk_from_the_iobusMDIO_7 <= internal_s_clk_from_the_iobusMDIO_7;
  --vhdl renameroo for output signals
  s_clk_from_the_iobusREGFILE_0 <= internal_s_clk_from_the_iobusREGFILE_0;
  --vhdl renameroo for output signals
  s_read_from_the_iobusMAC_0 <= internal_s_read_from_the_iobusMAC_0;
  --vhdl renameroo for output signals
  s_read_from_the_iobusMAC_1 <= internal_s_read_from_the_iobusMAC_1;
  --vhdl renameroo for output signals
  s_read_from_the_iobusMAC_2 <= internal_s_read_from_the_iobusMAC_2;
  --vhdl renameroo for output signals
  s_read_from_the_iobusMAC_3 <= internal_s_read_from_the_iobusMAC_3;
  --vhdl renameroo for output signals
  s_read_from_the_iobusMAC_4 <= internal_s_read_from_the_iobusMAC_4;
  --vhdl renameroo for output signals
  s_read_from_the_iobusMAC_5 <= internal_s_read_from_the_iobusMAC_5;
  --vhdl renameroo for output signals
  s_read_from_the_iobusMAC_6 <= internal_s_read_from_the_iobusMAC_6;
  --vhdl renameroo for output signals
  s_read_from_the_iobusMAC_7 <= internal_s_read_from_the_iobusMAC_7;
  --vhdl renameroo for output signals
  s_read_from_the_iobusMDIO_0 <= internal_s_read_from_the_iobusMDIO_0;
  --vhdl renameroo for output signals
  s_read_from_the_iobusMDIO_1 <= internal_s_read_from_the_iobusMDIO_1;
  --vhdl renameroo for output signals
  s_read_from_the_iobusMDIO_2 <= internal_s_read_from_the_iobusMDIO_2;
  --vhdl renameroo for output signals
  s_read_from_the_iobusMDIO_3 <= internal_s_read_from_the_iobusMDIO_3;
  --vhdl renameroo for output signals
  s_read_from_the_iobusMDIO_4 <= internal_s_read_from_the_iobusMDIO_4;
  --vhdl renameroo for output signals
  s_read_from_the_iobusMDIO_5 <= internal_s_read_from_the_iobusMDIO_5;
  --vhdl renameroo for output signals
  s_read_from_the_iobusMDIO_6 <= internal_s_read_from_the_iobusMDIO_6;
  --vhdl renameroo for output signals
  s_read_from_the_iobusMDIO_7 <= internal_s_read_from_the_iobusMDIO_7;
  --vhdl renameroo for output signals
  s_read_from_the_iobusREGFILE_0 <= internal_s_read_from_the_iobusREGFILE_0;
  --vhdl renameroo for output signals
  s_rst_from_the_iobusMAC_0 <= internal_s_rst_from_the_iobusMAC_0;
  --vhdl renameroo for output signals
  s_rst_from_the_iobusMAC_1 <= internal_s_rst_from_the_iobusMAC_1;
  --vhdl renameroo for output signals
  s_rst_from_the_iobusMAC_2 <= internal_s_rst_from_the_iobusMAC_2;
  --vhdl renameroo for output signals
  s_rst_from_the_iobusMAC_3 <= internal_s_rst_from_the_iobusMAC_3;
  --vhdl renameroo for output signals
  s_rst_from_the_iobusMAC_4 <= internal_s_rst_from_the_iobusMAC_4;
  --vhdl renameroo for output signals
  s_rst_from_the_iobusMAC_5 <= internal_s_rst_from_the_iobusMAC_5;
  --vhdl renameroo for output signals
  s_rst_from_the_iobusMAC_6 <= internal_s_rst_from_the_iobusMAC_6;
  --vhdl renameroo for output signals
  s_rst_from_the_iobusMAC_7 <= internal_s_rst_from_the_iobusMAC_7;
  --vhdl renameroo for output signals
  s_rst_from_the_iobusMDIO_0 <= internal_s_rst_from_the_iobusMDIO_0;
  --vhdl renameroo for output signals
  s_rst_from_the_iobusMDIO_1 <= internal_s_rst_from_the_iobusMDIO_1;
  --vhdl renameroo for output signals
  s_rst_from_the_iobusMDIO_2 <= internal_s_rst_from_the_iobusMDIO_2;
  --vhdl renameroo for output signals
  s_rst_from_the_iobusMDIO_3 <= internal_s_rst_from_the_iobusMDIO_3;
  --vhdl renameroo for output signals
  s_rst_from_the_iobusMDIO_4 <= internal_s_rst_from_the_iobusMDIO_4;
  --vhdl renameroo for output signals
  s_rst_from_the_iobusMDIO_5 <= internal_s_rst_from_the_iobusMDIO_5;
  --vhdl renameroo for output signals
  s_rst_from_the_iobusMDIO_6 <= internal_s_rst_from_the_iobusMDIO_6;
  --vhdl renameroo for output signals
  s_rst_from_the_iobusMDIO_7 <= internal_s_rst_from_the_iobusMDIO_7;
  --vhdl renameroo for output signals
  s_rst_from_the_iobusREGFILE_0 <= internal_s_rst_from_the_iobusREGFILE_0;
  --vhdl renameroo for output signals
  s_write_from_the_iobusMAC_0 <= internal_s_write_from_the_iobusMAC_0;
  --vhdl renameroo for output signals
  s_write_from_the_iobusMAC_1 <= internal_s_write_from_the_iobusMAC_1;
  --vhdl renameroo for output signals
  s_write_from_the_iobusMAC_2 <= internal_s_write_from_the_iobusMAC_2;
  --vhdl renameroo for output signals
  s_write_from_the_iobusMAC_3 <= internal_s_write_from_the_iobusMAC_3;
  --vhdl renameroo for output signals
  s_write_from_the_iobusMAC_4 <= internal_s_write_from_the_iobusMAC_4;
  --vhdl renameroo for output signals
  s_write_from_the_iobusMAC_5 <= internal_s_write_from_the_iobusMAC_5;
  --vhdl renameroo for output signals
  s_write_from_the_iobusMAC_6 <= internal_s_write_from_the_iobusMAC_6;
  --vhdl renameroo for output signals
  s_write_from_the_iobusMAC_7 <= internal_s_write_from_the_iobusMAC_7;
  --vhdl renameroo for output signals
  s_write_from_the_iobusMDIO_0 <= internal_s_write_from_the_iobusMDIO_0;
  --vhdl renameroo for output signals
  s_write_from_the_iobusMDIO_1 <= internal_s_write_from_the_iobusMDIO_1;
  --vhdl renameroo for output signals
  s_write_from_the_iobusMDIO_2 <= internal_s_write_from_the_iobusMDIO_2;
  --vhdl renameroo for output signals
  s_write_from_the_iobusMDIO_3 <= internal_s_write_from_the_iobusMDIO_3;
  --vhdl renameroo for output signals
  s_write_from_the_iobusMDIO_4 <= internal_s_write_from_the_iobusMDIO_4;
  --vhdl renameroo for output signals
  s_write_from_the_iobusMDIO_5 <= internal_s_write_from_the_iobusMDIO_5;
  --vhdl renameroo for output signals
  s_write_from_the_iobusMDIO_6 <= internal_s_write_from_the_iobusMDIO_6;
  --vhdl renameroo for output signals
  s_write_from_the_iobusMDIO_7 <= internal_s_write_from_the_iobusMDIO_7;
  --vhdl renameroo for output signals
  s_write_from_the_iobusREGFILE_0 <= internal_s_write_from_the_iobusREGFILE_0;
  --vhdl renameroo for output signals
  s_writedata_from_the_iobusMAC_0 <= internal_s_writedata_from_the_iobusMAC_0;
  --vhdl renameroo for output signals
  s_writedata_from_the_iobusMAC_1 <= internal_s_writedata_from_the_iobusMAC_1;
  --vhdl renameroo for output signals
  s_writedata_from_the_iobusMAC_2 <= internal_s_writedata_from_the_iobusMAC_2;
  --vhdl renameroo for output signals
  s_writedata_from_the_iobusMAC_3 <= internal_s_writedata_from_the_iobusMAC_3;
  --vhdl renameroo for output signals
  s_writedata_from_the_iobusMAC_4 <= internal_s_writedata_from_the_iobusMAC_4;
  --vhdl renameroo for output signals
  s_writedata_from_the_iobusMAC_5 <= internal_s_writedata_from_the_iobusMAC_5;
  --vhdl renameroo for output signals
  s_writedata_from_the_iobusMAC_6 <= internal_s_writedata_from_the_iobusMAC_6;
  --vhdl renameroo for output signals
  s_writedata_from_the_iobusMAC_7 <= internal_s_writedata_from_the_iobusMAC_7;
  --vhdl renameroo for output signals
  s_writedata_from_the_iobusMDIO_0 <= internal_s_writedata_from_the_iobusMDIO_0;
  --vhdl renameroo for output signals
  s_writedata_from_the_iobusMDIO_1 <= internal_s_writedata_from_the_iobusMDIO_1;
  --vhdl renameroo for output signals
  s_writedata_from_the_iobusMDIO_2 <= internal_s_writedata_from_the_iobusMDIO_2;
  --vhdl renameroo for output signals
  s_writedata_from_the_iobusMDIO_3 <= internal_s_writedata_from_the_iobusMDIO_3;
  --vhdl renameroo for output signals
  s_writedata_from_the_iobusMDIO_4 <= internal_s_writedata_from_the_iobusMDIO_4;
  --vhdl renameroo for output signals
  s_writedata_from_the_iobusMDIO_5 <= internal_s_writedata_from_the_iobusMDIO_5;
  --vhdl renameroo for output signals
  s_writedata_from_the_iobusMDIO_6 <= internal_s_writedata_from_the_iobusMDIO_6;
  --vhdl renameroo for output signals
  s_writedata_from_the_iobusMDIO_7 <= internal_s_writedata_from_the_iobusMDIO_7;
  --vhdl renameroo for output signals
  s_writedata_from_the_iobusREGFILE_0 <= internal_s_writedata_from_the_iobusREGFILE_0;
  --vhdl renameroo for output signals
  txd_from_the_rs232_uart <= internal_txd_from_the_rs232_uart;

end europa;


--synthesis translate_off

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;



-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add your libraries here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>

entity test_bench is 
end entity test_bench;


architecture europa of test_bench is
component nios is 
           port (
                 -- 1) global signals:
                    signal clk1 : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- the_iobusMAC_0
                    signal s_address_from_the_iobusMAC_0 : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal s_clk_from_the_iobusMAC_0 : OUT STD_LOGIC;
                    signal s_read_from_the_iobusMAC_0 : OUT STD_LOGIC;
                    signal s_readdata_to_the_iobusMAC_0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid_to_the_iobusMAC_0 : IN STD_LOGIC;
                    signal s_rst_from_the_iobusMAC_0 : OUT STD_LOGIC;
                    signal s_waitrequest_to_the_iobusMAC_0 : IN STD_LOGIC;
                    signal s_write_from_the_iobusMAC_0 : OUT STD_LOGIC;
                    signal s_writedata_from_the_iobusMAC_0 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- the_iobusMAC_1
                    signal s_address_from_the_iobusMAC_1 : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal s_clk_from_the_iobusMAC_1 : OUT STD_LOGIC;
                    signal s_read_from_the_iobusMAC_1 : OUT STD_LOGIC;
                    signal s_readdata_to_the_iobusMAC_1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid_to_the_iobusMAC_1 : IN STD_LOGIC;
                    signal s_rst_from_the_iobusMAC_1 : OUT STD_LOGIC;
                    signal s_waitrequest_to_the_iobusMAC_1 : IN STD_LOGIC;
                    signal s_write_from_the_iobusMAC_1 : OUT STD_LOGIC;
                    signal s_writedata_from_the_iobusMAC_1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- the_iobusMAC_2
                    signal s_address_from_the_iobusMAC_2 : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal s_clk_from_the_iobusMAC_2 : OUT STD_LOGIC;
                    signal s_read_from_the_iobusMAC_2 : OUT STD_LOGIC;
                    signal s_readdata_to_the_iobusMAC_2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid_to_the_iobusMAC_2 : IN STD_LOGIC;
                    signal s_rst_from_the_iobusMAC_2 : OUT STD_LOGIC;
                    signal s_waitrequest_to_the_iobusMAC_2 : IN STD_LOGIC;
                    signal s_write_from_the_iobusMAC_2 : OUT STD_LOGIC;
                    signal s_writedata_from_the_iobusMAC_2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- the_iobusMAC_3
                    signal s_address_from_the_iobusMAC_3 : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal s_clk_from_the_iobusMAC_3 : OUT STD_LOGIC;
                    signal s_read_from_the_iobusMAC_3 : OUT STD_LOGIC;
                    signal s_readdata_to_the_iobusMAC_3 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid_to_the_iobusMAC_3 : IN STD_LOGIC;
                    signal s_rst_from_the_iobusMAC_3 : OUT STD_LOGIC;
                    signal s_waitrequest_to_the_iobusMAC_3 : IN STD_LOGIC;
                    signal s_write_from_the_iobusMAC_3 : OUT STD_LOGIC;
                    signal s_writedata_from_the_iobusMAC_3 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- the_iobusMAC_4
                    signal s_address_from_the_iobusMAC_4 : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal s_clk_from_the_iobusMAC_4 : OUT STD_LOGIC;
                    signal s_read_from_the_iobusMAC_4 : OUT STD_LOGIC;
                    signal s_readdata_to_the_iobusMAC_4 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid_to_the_iobusMAC_4 : IN STD_LOGIC;
                    signal s_rst_from_the_iobusMAC_4 : OUT STD_LOGIC;
                    signal s_waitrequest_to_the_iobusMAC_4 : IN STD_LOGIC;
                    signal s_write_from_the_iobusMAC_4 : OUT STD_LOGIC;
                    signal s_writedata_from_the_iobusMAC_4 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- the_iobusMAC_5
                    signal s_address_from_the_iobusMAC_5 : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal s_clk_from_the_iobusMAC_5 : OUT STD_LOGIC;
                    signal s_read_from_the_iobusMAC_5 : OUT STD_LOGIC;
                    signal s_readdata_to_the_iobusMAC_5 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid_to_the_iobusMAC_5 : IN STD_LOGIC;
                    signal s_rst_from_the_iobusMAC_5 : OUT STD_LOGIC;
                    signal s_waitrequest_to_the_iobusMAC_5 : IN STD_LOGIC;
                    signal s_write_from_the_iobusMAC_5 : OUT STD_LOGIC;
                    signal s_writedata_from_the_iobusMAC_5 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- the_iobusMAC_6
                    signal s_address_from_the_iobusMAC_6 : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal s_clk_from_the_iobusMAC_6 : OUT STD_LOGIC;
                    signal s_read_from_the_iobusMAC_6 : OUT STD_LOGIC;
                    signal s_readdata_to_the_iobusMAC_6 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid_to_the_iobusMAC_6 : IN STD_LOGIC;
                    signal s_rst_from_the_iobusMAC_6 : OUT STD_LOGIC;
                    signal s_waitrequest_to_the_iobusMAC_6 : IN STD_LOGIC;
                    signal s_write_from_the_iobusMAC_6 : OUT STD_LOGIC;
                    signal s_writedata_from_the_iobusMAC_6 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- the_iobusMAC_7
                    signal s_address_from_the_iobusMAC_7 : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal s_clk_from_the_iobusMAC_7 : OUT STD_LOGIC;
                    signal s_read_from_the_iobusMAC_7 : OUT STD_LOGIC;
                    signal s_readdata_to_the_iobusMAC_7 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid_to_the_iobusMAC_7 : IN STD_LOGIC;
                    signal s_rst_from_the_iobusMAC_7 : OUT STD_LOGIC;
                    signal s_waitrequest_to_the_iobusMAC_7 : IN STD_LOGIC;
                    signal s_write_from_the_iobusMAC_7 : OUT STD_LOGIC;
                    signal s_writedata_from_the_iobusMAC_7 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- the_iobusMDIO_0
                    signal s_address_from_the_iobusMDIO_0 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal s_clk_from_the_iobusMDIO_0 : OUT STD_LOGIC;
                    signal s_read_from_the_iobusMDIO_0 : OUT STD_LOGIC;
                    signal s_readdata_to_the_iobusMDIO_0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid_to_the_iobusMDIO_0 : IN STD_LOGIC;
                    signal s_rst_from_the_iobusMDIO_0 : OUT STD_LOGIC;
                    signal s_waitrequest_to_the_iobusMDIO_0 : IN STD_LOGIC;
                    signal s_write_from_the_iobusMDIO_0 : OUT STD_LOGIC;
                    signal s_writedata_from_the_iobusMDIO_0 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- the_iobusMDIO_1
                    signal s_address_from_the_iobusMDIO_1 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal s_clk_from_the_iobusMDIO_1 : OUT STD_LOGIC;
                    signal s_read_from_the_iobusMDIO_1 : OUT STD_LOGIC;
                    signal s_readdata_to_the_iobusMDIO_1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid_to_the_iobusMDIO_1 : IN STD_LOGIC;
                    signal s_rst_from_the_iobusMDIO_1 : OUT STD_LOGIC;
                    signal s_waitrequest_to_the_iobusMDIO_1 : IN STD_LOGIC;
                    signal s_write_from_the_iobusMDIO_1 : OUT STD_LOGIC;
                    signal s_writedata_from_the_iobusMDIO_1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- the_iobusMDIO_2
                    signal s_address_from_the_iobusMDIO_2 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal s_clk_from_the_iobusMDIO_2 : OUT STD_LOGIC;
                    signal s_read_from_the_iobusMDIO_2 : OUT STD_LOGIC;
                    signal s_readdata_to_the_iobusMDIO_2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid_to_the_iobusMDIO_2 : IN STD_LOGIC;
                    signal s_rst_from_the_iobusMDIO_2 : OUT STD_LOGIC;
                    signal s_waitrequest_to_the_iobusMDIO_2 : IN STD_LOGIC;
                    signal s_write_from_the_iobusMDIO_2 : OUT STD_LOGIC;
                    signal s_writedata_from_the_iobusMDIO_2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- the_iobusMDIO_3
                    signal s_address_from_the_iobusMDIO_3 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal s_clk_from_the_iobusMDIO_3 : OUT STD_LOGIC;
                    signal s_read_from_the_iobusMDIO_3 : OUT STD_LOGIC;
                    signal s_readdata_to_the_iobusMDIO_3 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid_to_the_iobusMDIO_3 : IN STD_LOGIC;
                    signal s_rst_from_the_iobusMDIO_3 : OUT STD_LOGIC;
                    signal s_waitrequest_to_the_iobusMDIO_3 : IN STD_LOGIC;
                    signal s_write_from_the_iobusMDIO_3 : OUT STD_LOGIC;
                    signal s_writedata_from_the_iobusMDIO_3 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- the_iobusMDIO_4
                    signal s_address_from_the_iobusMDIO_4 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal s_clk_from_the_iobusMDIO_4 : OUT STD_LOGIC;
                    signal s_read_from_the_iobusMDIO_4 : OUT STD_LOGIC;
                    signal s_readdata_to_the_iobusMDIO_4 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid_to_the_iobusMDIO_4 : IN STD_LOGIC;
                    signal s_rst_from_the_iobusMDIO_4 : OUT STD_LOGIC;
                    signal s_waitrequest_to_the_iobusMDIO_4 : IN STD_LOGIC;
                    signal s_write_from_the_iobusMDIO_4 : OUT STD_LOGIC;
                    signal s_writedata_from_the_iobusMDIO_4 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- the_iobusMDIO_5
                    signal s_address_from_the_iobusMDIO_5 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal s_clk_from_the_iobusMDIO_5 : OUT STD_LOGIC;
                    signal s_read_from_the_iobusMDIO_5 : OUT STD_LOGIC;
                    signal s_readdata_to_the_iobusMDIO_5 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid_to_the_iobusMDIO_5 : IN STD_LOGIC;
                    signal s_rst_from_the_iobusMDIO_5 : OUT STD_LOGIC;
                    signal s_waitrequest_to_the_iobusMDIO_5 : IN STD_LOGIC;
                    signal s_write_from_the_iobusMDIO_5 : OUT STD_LOGIC;
                    signal s_writedata_from_the_iobusMDIO_5 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- the_iobusMDIO_6
                    signal s_address_from_the_iobusMDIO_6 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal s_clk_from_the_iobusMDIO_6 : OUT STD_LOGIC;
                    signal s_read_from_the_iobusMDIO_6 : OUT STD_LOGIC;
                    signal s_readdata_to_the_iobusMDIO_6 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid_to_the_iobusMDIO_6 : IN STD_LOGIC;
                    signal s_rst_from_the_iobusMDIO_6 : OUT STD_LOGIC;
                    signal s_waitrequest_to_the_iobusMDIO_6 : IN STD_LOGIC;
                    signal s_write_from_the_iobusMDIO_6 : OUT STD_LOGIC;
                    signal s_writedata_from_the_iobusMDIO_6 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- the_iobusMDIO_7
                    signal s_address_from_the_iobusMDIO_7 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal s_clk_from_the_iobusMDIO_7 : OUT STD_LOGIC;
                    signal s_read_from_the_iobusMDIO_7 : OUT STD_LOGIC;
                    signal s_readdata_to_the_iobusMDIO_7 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid_to_the_iobusMDIO_7 : IN STD_LOGIC;
                    signal s_rst_from_the_iobusMDIO_7 : OUT STD_LOGIC;
                    signal s_waitrequest_to_the_iobusMDIO_7 : IN STD_LOGIC;
                    signal s_write_from_the_iobusMDIO_7 : OUT STD_LOGIC;
                    signal s_writedata_from_the_iobusMDIO_7 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- the_iobusREGFILE_0
                    signal s_address_from_the_iobusREGFILE_0 : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal s_clk_from_the_iobusREGFILE_0 : OUT STD_LOGIC;
                    signal s_read_from_the_iobusREGFILE_0 : OUT STD_LOGIC;
                    signal s_readdata_to_the_iobusREGFILE_0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal s_readdatavalid_to_the_iobusREGFILE_0 : IN STD_LOGIC;
                    signal s_rst_from_the_iobusREGFILE_0 : OUT STD_LOGIC;
                    signal s_waitrequest_to_the_iobusREGFILE_0 : IN STD_LOGIC;
                    signal s_write_from_the_iobusREGFILE_0 : OUT STD_LOGIC;
                    signal s_writedata_from_the_iobusREGFILE_0 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);

                 -- the_rs232_uart
                    signal rxd_to_the_rs232_uart : IN STD_LOGIC;
                    signal txd_from_the_rs232_uart : OUT STD_LOGIC
                 );
end component nios;

                signal clk :  STD_LOGIC;
                signal clk1 :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_dataavailable_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_readyfordata_from_sa :  STD_LOGIC;
                signal reset_n :  STD_LOGIC;
                signal rs232_uart_s1_dataavailable_from_sa :  STD_LOGIC;
                signal rs232_uart_s1_readyfordata_from_sa :  STD_LOGIC;
                signal rxd_to_the_rs232_uart :  STD_LOGIC;
                signal s_address_from_the_iobusMAC_0 :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal s_address_from_the_iobusMAC_1 :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal s_address_from_the_iobusMAC_2 :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal s_address_from_the_iobusMAC_3 :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal s_address_from_the_iobusMAC_4 :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal s_address_from_the_iobusMAC_5 :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal s_address_from_the_iobusMAC_6 :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal s_address_from_the_iobusMAC_7 :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal s_address_from_the_iobusMDIO_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal s_address_from_the_iobusMDIO_1 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal s_address_from_the_iobusMDIO_2 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal s_address_from_the_iobusMDIO_3 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal s_address_from_the_iobusMDIO_4 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal s_address_from_the_iobusMDIO_5 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal s_address_from_the_iobusMDIO_6 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal s_address_from_the_iobusMDIO_7 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal s_address_from_the_iobusREGFILE_0 :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal s_clk_from_the_iobusMAC_0 :  STD_LOGIC;
                signal s_clk_from_the_iobusMAC_1 :  STD_LOGIC;
                signal s_clk_from_the_iobusMAC_2 :  STD_LOGIC;
                signal s_clk_from_the_iobusMAC_3 :  STD_LOGIC;
                signal s_clk_from_the_iobusMAC_4 :  STD_LOGIC;
                signal s_clk_from_the_iobusMAC_5 :  STD_LOGIC;
                signal s_clk_from_the_iobusMAC_6 :  STD_LOGIC;
                signal s_clk_from_the_iobusMAC_7 :  STD_LOGIC;
                signal s_clk_from_the_iobusMDIO_0 :  STD_LOGIC;
                signal s_clk_from_the_iobusMDIO_1 :  STD_LOGIC;
                signal s_clk_from_the_iobusMDIO_2 :  STD_LOGIC;
                signal s_clk_from_the_iobusMDIO_3 :  STD_LOGIC;
                signal s_clk_from_the_iobusMDIO_4 :  STD_LOGIC;
                signal s_clk_from_the_iobusMDIO_5 :  STD_LOGIC;
                signal s_clk_from_the_iobusMDIO_6 :  STD_LOGIC;
                signal s_clk_from_the_iobusMDIO_7 :  STD_LOGIC;
                signal s_clk_from_the_iobusREGFILE_0 :  STD_LOGIC;
                signal s_read_from_the_iobusMAC_0 :  STD_LOGIC;
                signal s_read_from_the_iobusMAC_1 :  STD_LOGIC;
                signal s_read_from_the_iobusMAC_2 :  STD_LOGIC;
                signal s_read_from_the_iobusMAC_3 :  STD_LOGIC;
                signal s_read_from_the_iobusMAC_4 :  STD_LOGIC;
                signal s_read_from_the_iobusMAC_5 :  STD_LOGIC;
                signal s_read_from_the_iobusMAC_6 :  STD_LOGIC;
                signal s_read_from_the_iobusMAC_7 :  STD_LOGIC;
                signal s_read_from_the_iobusMDIO_0 :  STD_LOGIC;
                signal s_read_from_the_iobusMDIO_1 :  STD_LOGIC;
                signal s_read_from_the_iobusMDIO_2 :  STD_LOGIC;
                signal s_read_from_the_iobusMDIO_3 :  STD_LOGIC;
                signal s_read_from_the_iobusMDIO_4 :  STD_LOGIC;
                signal s_read_from_the_iobusMDIO_5 :  STD_LOGIC;
                signal s_read_from_the_iobusMDIO_6 :  STD_LOGIC;
                signal s_read_from_the_iobusMDIO_7 :  STD_LOGIC;
                signal s_read_from_the_iobusREGFILE_0 :  STD_LOGIC;
                signal s_readdata_to_the_iobusMAC_0 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_readdata_to_the_iobusMAC_1 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_readdata_to_the_iobusMAC_2 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_readdata_to_the_iobusMAC_3 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_readdata_to_the_iobusMAC_4 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_readdata_to_the_iobusMAC_5 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_readdata_to_the_iobusMAC_6 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_readdata_to_the_iobusMAC_7 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_readdata_to_the_iobusMDIO_0 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_readdata_to_the_iobusMDIO_1 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_readdata_to_the_iobusMDIO_2 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_readdata_to_the_iobusMDIO_3 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_readdata_to_the_iobusMDIO_4 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_readdata_to_the_iobusMDIO_5 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_readdata_to_the_iobusMDIO_6 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_readdata_to_the_iobusMDIO_7 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_readdata_to_the_iobusREGFILE_0 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_readdatavalid_to_the_iobusMAC_0 :  STD_LOGIC;
                signal s_readdatavalid_to_the_iobusMAC_1 :  STD_LOGIC;
                signal s_readdatavalid_to_the_iobusMAC_2 :  STD_LOGIC;
                signal s_readdatavalid_to_the_iobusMAC_3 :  STD_LOGIC;
                signal s_readdatavalid_to_the_iobusMAC_4 :  STD_LOGIC;
                signal s_readdatavalid_to_the_iobusMAC_5 :  STD_LOGIC;
                signal s_readdatavalid_to_the_iobusMAC_6 :  STD_LOGIC;
                signal s_readdatavalid_to_the_iobusMAC_7 :  STD_LOGIC;
                signal s_readdatavalid_to_the_iobusMDIO_0 :  STD_LOGIC;
                signal s_readdatavalid_to_the_iobusMDIO_1 :  STD_LOGIC;
                signal s_readdatavalid_to_the_iobusMDIO_2 :  STD_LOGIC;
                signal s_readdatavalid_to_the_iobusMDIO_3 :  STD_LOGIC;
                signal s_readdatavalid_to_the_iobusMDIO_4 :  STD_LOGIC;
                signal s_readdatavalid_to_the_iobusMDIO_5 :  STD_LOGIC;
                signal s_readdatavalid_to_the_iobusMDIO_6 :  STD_LOGIC;
                signal s_readdatavalid_to_the_iobusMDIO_7 :  STD_LOGIC;
                signal s_readdatavalid_to_the_iobusREGFILE_0 :  STD_LOGIC;
                signal s_rst_from_the_iobusMAC_0 :  STD_LOGIC;
                signal s_rst_from_the_iobusMAC_1 :  STD_LOGIC;
                signal s_rst_from_the_iobusMAC_2 :  STD_LOGIC;
                signal s_rst_from_the_iobusMAC_3 :  STD_LOGIC;
                signal s_rst_from_the_iobusMAC_4 :  STD_LOGIC;
                signal s_rst_from_the_iobusMAC_5 :  STD_LOGIC;
                signal s_rst_from_the_iobusMAC_6 :  STD_LOGIC;
                signal s_rst_from_the_iobusMAC_7 :  STD_LOGIC;
                signal s_rst_from_the_iobusMDIO_0 :  STD_LOGIC;
                signal s_rst_from_the_iobusMDIO_1 :  STD_LOGIC;
                signal s_rst_from_the_iobusMDIO_2 :  STD_LOGIC;
                signal s_rst_from_the_iobusMDIO_3 :  STD_LOGIC;
                signal s_rst_from_the_iobusMDIO_4 :  STD_LOGIC;
                signal s_rst_from_the_iobusMDIO_5 :  STD_LOGIC;
                signal s_rst_from_the_iobusMDIO_6 :  STD_LOGIC;
                signal s_rst_from_the_iobusMDIO_7 :  STD_LOGIC;
                signal s_rst_from_the_iobusREGFILE_0 :  STD_LOGIC;
                signal s_waitrequest_to_the_iobusMAC_0 :  STD_LOGIC;
                signal s_waitrequest_to_the_iobusMAC_1 :  STD_LOGIC;
                signal s_waitrequest_to_the_iobusMAC_2 :  STD_LOGIC;
                signal s_waitrequest_to_the_iobusMAC_3 :  STD_LOGIC;
                signal s_waitrequest_to_the_iobusMAC_4 :  STD_LOGIC;
                signal s_waitrequest_to_the_iobusMAC_5 :  STD_LOGIC;
                signal s_waitrequest_to_the_iobusMAC_6 :  STD_LOGIC;
                signal s_waitrequest_to_the_iobusMAC_7 :  STD_LOGIC;
                signal s_waitrequest_to_the_iobusMDIO_0 :  STD_LOGIC;
                signal s_waitrequest_to_the_iobusMDIO_1 :  STD_LOGIC;
                signal s_waitrequest_to_the_iobusMDIO_2 :  STD_LOGIC;
                signal s_waitrequest_to_the_iobusMDIO_3 :  STD_LOGIC;
                signal s_waitrequest_to_the_iobusMDIO_4 :  STD_LOGIC;
                signal s_waitrequest_to_the_iobusMDIO_5 :  STD_LOGIC;
                signal s_waitrequest_to_the_iobusMDIO_6 :  STD_LOGIC;
                signal s_waitrequest_to_the_iobusMDIO_7 :  STD_LOGIC;
                signal s_waitrequest_to_the_iobusREGFILE_0 :  STD_LOGIC;
                signal s_write_from_the_iobusMAC_0 :  STD_LOGIC;
                signal s_write_from_the_iobusMAC_1 :  STD_LOGIC;
                signal s_write_from_the_iobusMAC_2 :  STD_LOGIC;
                signal s_write_from_the_iobusMAC_3 :  STD_LOGIC;
                signal s_write_from_the_iobusMAC_4 :  STD_LOGIC;
                signal s_write_from_the_iobusMAC_5 :  STD_LOGIC;
                signal s_write_from_the_iobusMAC_6 :  STD_LOGIC;
                signal s_write_from_the_iobusMAC_7 :  STD_LOGIC;
                signal s_write_from_the_iobusMDIO_0 :  STD_LOGIC;
                signal s_write_from_the_iobusMDIO_1 :  STD_LOGIC;
                signal s_write_from_the_iobusMDIO_2 :  STD_LOGIC;
                signal s_write_from_the_iobusMDIO_3 :  STD_LOGIC;
                signal s_write_from_the_iobusMDIO_4 :  STD_LOGIC;
                signal s_write_from_the_iobusMDIO_5 :  STD_LOGIC;
                signal s_write_from_the_iobusMDIO_6 :  STD_LOGIC;
                signal s_write_from_the_iobusMDIO_7 :  STD_LOGIC;
                signal s_write_from_the_iobusREGFILE_0 :  STD_LOGIC;
                signal s_writedata_from_the_iobusMAC_0 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_writedata_from_the_iobusMAC_1 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_writedata_from_the_iobusMAC_2 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_writedata_from_the_iobusMAC_3 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_writedata_from_the_iobusMAC_4 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_writedata_from_the_iobusMAC_5 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_writedata_from_the_iobusMAC_6 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_writedata_from_the_iobusMAC_7 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_writedata_from_the_iobusMDIO_0 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_writedata_from_the_iobusMDIO_1 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_writedata_from_the_iobusMDIO_2 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_writedata_from_the_iobusMDIO_3 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_writedata_from_the_iobusMDIO_4 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_writedata_from_the_iobusMDIO_5 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_writedata_from_the_iobusMDIO_6 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_writedata_from_the_iobusMDIO_7 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal s_writedata_from_the_iobusREGFILE_0 :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal txd_from_the_rs232_uart :  STD_LOGIC;


-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add your component and signal declaration here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>


begin

  --Set us up the Dut
  DUT : nios
    port map(
      s_address_from_the_iobusMAC_0 => s_address_from_the_iobusMAC_0,
      s_address_from_the_iobusMAC_1 => s_address_from_the_iobusMAC_1,
      s_address_from_the_iobusMAC_2 => s_address_from_the_iobusMAC_2,
      s_address_from_the_iobusMAC_3 => s_address_from_the_iobusMAC_3,
      s_address_from_the_iobusMAC_4 => s_address_from_the_iobusMAC_4,
      s_address_from_the_iobusMAC_5 => s_address_from_the_iobusMAC_5,
      s_address_from_the_iobusMAC_6 => s_address_from_the_iobusMAC_6,
      s_address_from_the_iobusMAC_7 => s_address_from_the_iobusMAC_7,
      s_address_from_the_iobusMDIO_0 => s_address_from_the_iobusMDIO_0,
      s_address_from_the_iobusMDIO_1 => s_address_from_the_iobusMDIO_1,
      s_address_from_the_iobusMDIO_2 => s_address_from_the_iobusMDIO_2,
      s_address_from_the_iobusMDIO_3 => s_address_from_the_iobusMDIO_3,
      s_address_from_the_iobusMDIO_4 => s_address_from_the_iobusMDIO_4,
      s_address_from_the_iobusMDIO_5 => s_address_from_the_iobusMDIO_5,
      s_address_from_the_iobusMDIO_6 => s_address_from_the_iobusMDIO_6,
      s_address_from_the_iobusMDIO_7 => s_address_from_the_iobusMDIO_7,
      s_address_from_the_iobusREGFILE_0 => s_address_from_the_iobusREGFILE_0,
      s_clk_from_the_iobusMAC_0 => s_clk_from_the_iobusMAC_0,
      s_clk_from_the_iobusMAC_1 => s_clk_from_the_iobusMAC_1,
      s_clk_from_the_iobusMAC_2 => s_clk_from_the_iobusMAC_2,
      s_clk_from_the_iobusMAC_3 => s_clk_from_the_iobusMAC_3,
      s_clk_from_the_iobusMAC_4 => s_clk_from_the_iobusMAC_4,
      s_clk_from_the_iobusMAC_5 => s_clk_from_the_iobusMAC_5,
      s_clk_from_the_iobusMAC_6 => s_clk_from_the_iobusMAC_6,
      s_clk_from_the_iobusMAC_7 => s_clk_from_the_iobusMAC_7,
      s_clk_from_the_iobusMDIO_0 => s_clk_from_the_iobusMDIO_0,
      s_clk_from_the_iobusMDIO_1 => s_clk_from_the_iobusMDIO_1,
      s_clk_from_the_iobusMDIO_2 => s_clk_from_the_iobusMDIO_2,
      s_clk_from_the_iobusMDIO_3 => s_clk_from_the_iobusMDIO_3,
      s_clk_from_the_iobusMDIO_4 => s_clk_from_the_iobusMDIO_4,
      s_clk_from_the_iobusMDIO_5 => s_clk_from_the_iobusMDIO_5,
      s_clk_from_the_iobusMDIO_6 => s_clk_from_the_iobusMDIO_6,
      s_clk_from_the_iobusMDIO_7 => s_clk_from_the_iobusMDIO_7,
      s_clk_from_the_iobusREGFILE_0 => s_clk_from_the_iobusREGFILE_0,
      s_read_from_the_iobusMAC_0 => s_read_from_the_iobusMAC_0,
      s_read_from_the_iobusMAC_1 => s_read_from_the_iobusMAC_1,
      s_read_from_the_iobusMAC_2 => s_read_from_the_iobusMAC_2,
      s_read_from_the_iobusMAC_3 => s_read_from_the_iobusMAC_3,
      s_read_from_the_iobusMAC_4 => s_read_from_the_iobusMAC_4,
      s_read_from_the_iobusMAC_5 => s_read_from_the_iobusMAC_5,
      s_read_from_the_iobusMAC_6 => s_read_from_the_iobusMAC_6,
      s_read_from_the_iobusMAC_7 => s_read_from_the_iobusMAC_7,
      s_read_from_the_iobusMDIO_0 => s_read_from_the_iobusMDIO_0,
      s_read_from_the_iobusMDIO_1 => s_read_from_the_iobusMDIO_1,
      s_read_from_the_iobusMDIO_2 => s_read_from_the_iobusMDIO_2,
      s_read_from_the_iobusMDIO_3 => s_read_from_the_iobusMDIO_3,
      s_read_from_the_iobusMDIO_4 => s_read_from_the_iobusMDIO_4,
      s_read_from_the_iobusMDIO_5 => s_read_from_the_iobusMDIO_5,
      s_read_from_the_iobusMDIO_6 => s_read_from_the_iobusMDIO_6,
      s_read_from_the_iobusMDIO_7 => s_read_from_the_iobusMDIO_7,
      s_read_from_the_iobusREGFILE_0 => s_read_from_the_iobusREGFILE_0,
      s_rst_from_the_iobusMAC_0 => s_rst_from_the_iobusMAC_0,
      s_rst_from_the_iobusMAC_1 => s_rst_from_the_iobusMAC_1,
      s_rst_from_the_iobusMAC_2 => s_rst_from_the_iobusMAC_2,
      s_rst_from_the_iobusMAC_3 => s_rst_from_the_iobusMAC_3,
      s_rst_from_the_iobusMAC_4 => s_rst_from_the_iobusMAC_4,
      s_rst_from_the_iobusMAC_5 => s_rst_from_the_iobusMAC_5,
      s_rst_from_the_iobusMAC_6 => s_rst_from_the_iobusMAC_6,
      s_rst_from_the_iobusMAC_7 => s_rst_from_the_iobusMAC_7,
      s_rst_from_the_iobusMDIO_0 => s_rst_from_the_iobusMDIO_0,
      s_rst_from_the_iobusMDIO_1 => s_rst_from_the_iobusMDIO_1,
      s_rst_from_the_iobusMDIO_2 => s_rst_from_the_iobusMDIO_2,
      s_rst_from_the_iobusMDIO_3 => s_rst_from_the_iobusMDIO_3,
      s_rst_from_the_iobusMDIO_4 => s_rst_from_the_iobusMDIO_4,
      s_rst_from_the_iobusMDIO_5 => s_rst_from_the_iobusMDIO_5,
      s_rst_from_the_iobusMDIO_6 => s_rst_from_the_iobusMDIO_6,
      s_rst_from_the_iobusMDIO_7 => s_rst_from_the_iobusMDIO_7,
      s_rst_from_the_iobusREGFILE_0 => s_rst_from_the_iobusREGFILE_0,
      s_write_from_the_iobusMAC_0 => s_write_from_the_iobusMAC_0,
      s_write_from_the_iobusMAC_1 => s_write_from_the_iobusMAC_1,
      s_write_from_the_iobusMAC_2 => s_write_from_the_iobusMAC_2,
      s_write_from_the_iobusMAC_3 => s_write_from_the_iobusMAC_3,
      s_write_from_the_iobusMAC_4 => s_write_from_the_iobusMAC_4,
      s_write_from_the_iobusMAC_5 => s_write_from_the_iobusMAC_5,
      s_write_from_the_iobusMAC_6 => s_write_from_the_iobusMAC_6,
      s_write_from_the_iobusMAC_7 => s_write_from_the_iobusMAC_7,
      s_write_from_the_iobusMDIO_0 => s_write_from_the_iobusMDIO_0,
      s_write_from_the_iobusMDIO_1 => s_write_from_the_iobusMDIO_1,
      s_write_from_the_iobusMDIO_2 => s_write_from_the_iobusMDIO_2,
      s_write_from_the_iobusMDIO_3 => s_write_from_the_iobusMDIO_3,
      s_write_from_the_iobusMDIO_4 => s_write_from_the_iobusMDIO_4,
      s_write_from_the_iobusMDIO_5 => s_write_from_the_iobusMDIO_5,
      s_write_from_the_iobusMDIO_6 => s_write_from_the_iobusMDIO_6,
      s_write_from_the_iobusMDIO_7 => s_write_from_the_iobusMDIO_7,
      s_write_from_the_iobusREGFILE_0 => s_write_from_the_iobusREGFILE_0,
      s_writedata_from_the_iobusMAC_0 => s_writedata_from_the_iobusMAC_0,
      s_writedata_from_the_iobusMAC_1 => s_writedata_from_the_iobusMAC_1,
      s_writedata_from_the_iobusMAC_2 => s_writedata_from_the_iobusMAC_2,
      s_writedata_from_the_iobusMAC_3 => s_writedata_from_the_iobusMAC_3,
      s_writedata_from_the_iobusMAC_4 => s_writedata_from_the_iobusMAC_4,
      s_writedata_from_the_iobusMAC_5 => s_writedata_from_the_iobusMAC_5,
      s_writedata_from_the_iobusMAC_6 => s_writedata_from_the_iobusMAC_6,
      s_writedata_from_the_iobusMAC_7 => s_writedata_from_the_iobusMAC_7,
      s_writedata_from_the_iobusMDIO_0 => s_writedata_from_the_iobusMDIO_0,
      s_writedata_from_the_iobusMDIO_1 => s_writedata_from_the_iobusMDIO_1,
      s_writedata_from_the_iobusMDIO_2 => s_writedata_from_the_iobusMDIO_2,
      s_writedata_from_the_iobusMDIO_3 => s_writedata_from_the_iobusMDIO_3,
      s_writedata_from_the_iobusMDIO_4 => s_writedata_from_the_iobusMDIO_4,
      s_writedata_from_the_iobusMDIO_5 => s_writedata_from_the_iobusMDIO_5,
      s_writedata_from_the_iobusMDIO_6 => s_writedata_from_the_iobusMDIO_6,
      s_writedata_from_the_iobusMDIO_7 => s_writedata_from_the_iobusMDIO_7,
      s_writedata_from_the_iobusREGFILE_0 => s_writedata_from_the_iobusREGFILE_0,
      txd_from_the_rs232_uart => txd_from_the_rs232_uart,
      clk1 => clk1,
      reset_n => reset_n,
      rxd_to_the_rs232_uart => rxd_to_the_rs232_uart,
      s_readdata_to_the_iobusMAC_0 => s_readdata_to_the_iobusMAC_0,
      s_readdata_to_the_iobusMAC_1 => s_readdata_to_the_iobusMAC_1,
      s_readdata_to_the_iobusMAC_2 => s_readdata_to_the_iobusMAC_2,
      s_readdata_to_the_iobusMAC_3 => s_readdata_to_the_iobusMAC_3,
      s_readdata_to_the_iobusMAC_4 => s_readdata_to_the_iobusMAC_4,
      s_readdata_to_the_iobusMAC_5 => s_readdata_to_the_iobusMAC_5,
      s_readdata_to_the_iobusMAC_6 => s_readdata_to_the_iobusMAC_6,
      s_readdata_to_the_iobusMAC_7 => s_readdata_to_the_iobusMAC_7,
      s_readdata_to_the_iobusMDIO_0 => s_readdata_to_the_iobusMDIO_0,
      s_readdata_to_the_iobusMDIO_1 => s_readdata_to_the_iobusMDIO_1,
      s_readdata_to_the_iobusMDIO_2 => s_readdata_to_the_iobusMDIO_2,
      s_readdata_to_the_iobusMDIO_3 => s_readdata_to_the_iobusMDIO_3,
      s_readdata_to_the_iobusMDIO_4 => s_readdata_to_the_iobusMDIO_4,
      s_readdata_to_the_iobusMDIO_5 => s_readdata_to_the_iobusMDIO_5,
      s_readdata_to_the_iobusMDIO_6 => s_readdata_to_the_iobusMDIO_6,
      s_readdata_to_the_iobusMDIO_7 => s_readdata_to_the_iobusMDIO_7,
      s_readdata_to_the_iobusREGFILE_0 => s_readdata_to_the_iobusREGFILE_0,
      s_readdatavalid_to_the_iobusMAC_0 => s_readdatavalid_to_the_iobusMAC_0,
      s_readdatavalid_to_the_iobusMAC_1 => s_readdatavalid_to_the_iobusMAC_1,
      s_readdatavalid_to_the_iobusMAC_2 => s_readdatavalid_to_the_iobusMAC_2,
      s_readdatavalid_to_the_iobusMAC_3 => s_readdatavalid_to_the_iobusMAC_3,
      s_readdatavalid_to_the_iobusMAC_4 => s_readdatavalid_to_the_iobusMAC_4,
      s_readdatavalid_to_the_iobusMAC_5 => s_readdatavalid_to_the_iobusMAC_5,
      s_readdatavalid_to_the_iobusMAC_6 => s_readdatavalid_to_the_iobusMAC_6,
      s_readdatavalid_to_the_iobusMAC_7 => s_readdatavalid_to_the_iobusMAC_7,
      s_readdatavalid_to_the_iobusMDIO_0 => s_readdatavalid_to_the_iobusMDIO_0,
      s_readdatavalid_to_the_iobusMDIO_1 => s_readdatavalid_to_the_iobusMDIO_1,
      s_readdatavalid_to_the_iobusMDIO_2 => s_readdatavalid_to_the_iobusMDIO_2,
      s_readdatavalid_to_the_iobusMDIO_3 => s_readdatavalid_to_the_iobusMDIO_3,
      s_readdatavalid_to_the_iobusMDIO_4 => s_readdatavalid_to_the_iobusMDIO_4,
      s_readdatavalid_to_the_iobusMDIO_5 => s_readdatavalid_to_the_iobusMDIO_5,
      s_readdatavalid_to_the_iobusMDIO_6 => s_readdatavalid_to_the_iobusMDIO_6,
      s_readdatavalid_to_the_iobusMDIO_7 => s_readdatavalid_to_the_iobusMDIO_7,
      s_readdatavalid_to_the_iobusREGFILE_0 => s_readdatavalid_to_the_iobusREGFILE_0,
      s_waitrequest_to_the_iobusMAC_0 => s_waitrequest_to_the_iobusMAC_0,
      s_waitrequest_to_the_iobusMAC_1 => s_waitrequest_to_the_iobusMAC_1,
      s_waitrequest_to_the_iobusMAC_2 => s_waitrequest_to_the_iobusMAC_2,
      s_waitrequest_to_the_iobusMAC_3 => s_waitrequest_to_the_iobusMAC_3,
      s_waitrequest_to_the_iobusMAC_4 => s_waitrequest_to_the_iobusMAC_4,
      s_waitrequest_to_the_iobusMAC_5 => s_waitrequest_to_the_iobusMAC_5,
      s_waitrequest_to_the_iobusMAC_6 => s_waitrequest_to_the_iobusMAC_6,
      s_waitrequest_to_the_iobusMAC_7 => s_waitrequest_to_the_iobusMAC_7,
      s_waitrequest_to_the_iobusMDIO_0 => s_waitrequest_to_the_iobusMDIO_0,
      s_waitrequest_to_the_iobusMDIO_1 => s_waitrequest_to_the_iobusMDIO_1,
      s_waitrequest_to_the_iobusMDIO_2 => s_waitrequest_to_the_iobusMDIO_2,
      s_waitrequest_to_the_iobusMDIO_3 => s_waitrequest_to_the_iobusMDIO_3,
      s_waitrequest_to_the_iobusMDIO_4 => s_waitrequest_to_the_iobusMDIO_4,
      s_waitrequest_to_the_iobusMDIO_5 => s_waitrequest_to_the_iobusMDIO_5,
      s_waitrequest_to_the_iobusMDIO_6 => s_waitrequest_to_the_iobusMDIO_6,
      s_waitrequest_to_the_iobusMDIO_7 => s_waitrequest_to_the_iobusMDIO_7,
      s_waitrequest_to_the_iobusREGFILE_0 => s_waitrequest_to_the_iobusREGFILE_0
    );


  process
  begin
    clk1 <= '0';
    loop
       wait for 10 ns;
       clk1 <= not clk1;
    end loop;
  end process;
  PROCESS
    BEGIN
       reset_n <= '0';
       wait for 200 ns;
       reset_n <= '1'; 
    WAIT;
  END PROCESS;


-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add additional architecture here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>


end europa;



--synthesis translate_on
