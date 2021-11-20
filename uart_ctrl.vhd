LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------------------------------
-- CONTROL REGISTER MAPPING
-- 7   - TIE: Transmit Interrupt Enable
-- 6   - RIE: Receive Interrupt Enable
-- 5   - RSVD: (FUTURE USE)
-- 4   - RSVD: (FUTURE USE)
-- 3   - RSVD: (FUTURE USE) 
-- 2:0 - SEL[2:0]: Baud Rate Selector
--------------------------------------------------------------------------------

ENTITY uart_ctrl IS
  PORT (CLK, RST: IN STD_LOGIC;
  		RIE, TIE: OUT STD_LOGIC;
  		SEL: OUT STD_LOGIC_VECTOR(2 downto 0);
  		LD_CTRL: IN STD_LOGIC;
  		CTRL_IN: IN STD_LOGIC_VECTOR;
  		SCCR: OUT STD_LOGIC_VECTOR(7 downto 0));
END uart_ctrl;

ARCHITECTURE struct of uart_ctrl IS
SIGNAL SCCR_ENABLE, SCCR_C: STD_LOGIC_VECTOR (7 downto 0);
BEGIN
	SCCR_REG: ENTITY work.nbit_reg generic map (N => 8)
									  port map (i_resetBar => rst,
                                                i_load => LD_CTRL,
                                      		    i_clock => clk,
                                      		    i_Value => CTRL_IN,
                                      		    o_Value	=> SCCR_c);

	TIE <= SCCR_c(7);
	RIE <= SCCR_c(6);
	SEL <= SCCR_c(2 downto 0);
	SCCR <= SCCR_C;
END ARCHITECTURE struct;