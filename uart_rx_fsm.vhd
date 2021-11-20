LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY uart_rx_fsm IS
  PORT (CLK, RST: IN STD_LOGIC;
  		  RxD, CLK_COUNT3, CLK_COUNT7, BIT_COUNT8, RDRF, BCLK_EDGE: IN STD_LOGIC;
  		  CLR_CLK_COUNT, CLR_BIT_COUNT, ENABLE_CLK_COUNT, ENABLE_BIT_COUNT: OUT STD_LOGIC;
  		  SHIFT_RSR, LD_RDR: OUT STD_LOGIC;
  		  SET_FE, SET_OE, SET_RDRF: OUT STD_LOGIC);
END uart_rx_fsm;

ARCHITECTURE struct of uart_rx_fsm IS
SIGNAL S1, S1_NXT, S0, S0_NXT: STD_LOGIC;
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
  S0_NXT     <= (not S1 and not S0 and not RxD) or (S0 and (not BCLK_EDGE or (not RxD and not CLK_COUNT3)));
  S1_NXT     <= (S0 and BCLK_EDGE and not RxD and CLK_COUNT3) or (S1 and (not BCLK_EDGE or not CLK_COUNT7 or not BIT_COUNT8));

  -- Declare Outputs
  CLR_CLK_COUNT <= (S0 and BCLK_EDGE and (RxD or CLK_COUNT3)) or (S1 and BCLK_EDGE and CLK_COUNT7);
  CLR_BIT_COUNT <= (S1 and BCLK_EDGE and CLK_COUNT7 and BIT_COUNT8);
  ENABLE_CLK_COUNT <= (S1 and BCLK_EDGE) or (S0 and BCLK_EDGE and not RxD and not CLK_COUNT3);
  ENABLE_BIT_COUNT <= (S1 and BCLK_EDGE and CLK_COUNT7 and not BIT_COUNT8);
  SHIFT_RSR <= S1 and BCLK_EDGE and CLK_COUNT7 and not BIT_COUNT8;
  LD_RDR <= S1 and BCLK_EDGE and CLK_COUNT7 and BIT_COUNT8 and not RDRF and RxD;
  SET_FE <= S1 and BCLK_EDGE and CLK_COUNT7 and BIT_COUNT8 and not RDRF and not RxD;
  SET_OE <= S1 and BCLK_EDGE and CLK_COUNT7 and BIT_COUNT8 and RDRF;
  SET_RDRF <= S1 and BCLK_EDGE and CLK_COUNT7 and BIT_COUNT8;
END ARCHITECTURE struct;
