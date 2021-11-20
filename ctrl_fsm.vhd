LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ctrl_fsm IS
  PORT (CLK, RST: IN STD_LOGIC;
  		IRQ, CHAR_CNT6, STATE_CHANGE: IN STD_LOGIC;
  		INC_CHAR_CNT, CLR_CHAR_CNT: OUT STD_LOGIC;
  		SETUP_SEL, R_WBar, UART_SEL: OUT STD_LOGIC);
END ctrl_fsm;

ARCHITECTURE struct of ctrl_fsm is 
SIGNAL S0, S0_NXT, S1, S1_NXT: STD_LOGIC;
BEGIN

  s0_dFF: entity work.enardFF_2 PORT MAP(i_D => S0_NXT,
                                         i_resetBar => rst,
                                         o_Q => S0,
                                         i_clock => clk,
                                         i_enable => '1');

  s1_dFF: entity work.enardFF_2 PORT MAP(i_D => S1_NXT,
                                         i_resetBar => rst,
                                         o_Q => S1,
                                         i_clock => clk,
                                         i_enable => '1');

  S0_NXT <= S1 or (not S0) or STATE_CHANGE or (not IRQ) or CHAR_CNT6;
  S1_NXT <= S0 and (not STATE_CHANGE) and IRQ and (not CHAR_CNT6);

  SETUP_SEL <= (not S0 and not S1);
  R_WBAR <= '0';--(not S0) or S1;
  UART_SEL <= (not S0) or S1;
  INC_CHAR_CNT <= S1;
  CLR_CHAR_CNT <= (S0 and STATE_CHANGE);

END ARCHITECTURE struct;