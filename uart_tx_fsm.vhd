LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY uart_tx_fsm IS
  PORT (CLK, RST: IN STD_LOGIC;
  		  TDRE, BITCOUNT9, BCLK_EDGE: IN STD_LOGIC;
  		  CLR_BIT_COUNT, ENABLE_BIT_COUNT: OUT STD_LOGIC;
  		  SHIFT_TSR, LD_TSR, START: OUT STD_LOGIC;
  		  SET_TDRE: OUT STD_LOGIC);
END uart_tx_fsm;

ARCHITECTURE struct of uart_tx_fsm IS
SIGNAL S1, S1_NXT, S0, S0_NXT: STD_LOGIC; -- State Variable
BEGIN
-- Declare the state flip flops
  s1_dFF: entity work.enardFF_2 PORT MAP(i_D => S1_NXT,
                                       i_resetBar => rst,
                                       o_Q => S1,
                                       i_clock => clk,
                                       i_enable => '1');

  s0_dFF: entity work.enardFF_2 PORT MAP(i_D => S0_NXT,
                                         i_resetBar => rst,
                                         o_Q => S0,
                                         i_clock => clk,
                                         i_enable => '1');

  -- Declare next states
  S0_NXT     <= (not S0 and not S1 and not TDRE) or (S0 and not BCLK_EDGE);
  S1_NXT     <= (S0 and BCLK_EDGE) or (S1 and (not BCLK_EDGE or not BITCOUNT9));

  -- Declare Outputs
  CLR_BIT_COUNT <= S1 and BCLK_EDGE and BITCOUNT9;
  ENABLE_BIT_COUNT <= S1 and BCLK_EDGE and not BITCOUNT9;
  SHIFT_TSR <= S1 and BCLK_EDGE and not BITCOUNT9;
  LD_TSR <= (not S0 and not S1) and not TDRE;
  SET_TDRE <= (not S0 and not S1) and not TDRE;
  START <= S0 and BCLK_EDGE; 
END ARCHITECTURE struct;
