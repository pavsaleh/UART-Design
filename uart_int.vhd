LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------------------------------
-- INTERRUPT REGISTER MAPPING
-- 7 - TDRE: Transmit Data Register Empty
-- 6 - RDRF: Receive Data Register Full
-- 5 - RSVD (FUTURE USE)
-- 4 - RSVD (FUTURE USE)
-- 3 - RSVD (FUTURE USE)
-- 2 - RSVD (FUTURE USE)
-- 1 - RX_OE: Overrun Empty
-- 0 - RX_FE: Framing Error
--------------------------------------------------------------------------------

ENTITY uart_int IS
  PORT (CLK, RST: IN STD_LOGIC;
  		RX_SET_FE, RX_CLR_FE, RX_SET_OE, RX_CLR_OE, RX_SET_RDRF, RX_CLR_RDRF: IN STD_LOGIC;
  		TX_SET_TDRE, TX_CLR_TDRE: IN STD_LOGIC;
  		RIE, TIE: IN STD_LOGIC;
  		IRQ: OUT STD_LOGIC;
  		SCSR: OUT STD_LOGIC_VECTOR(7 downto 0));
END uart_int;

ARCHITECTURE struct of uart_int IS
SIGNAL SCSR_ENABLE, SCSR_C: STD_LOGIC_VECTOR (7 downto 0);
SIGNAL LD_SCSR: STD_LOGIC;
SIGNAL RDR_READ, TDR_WRITE, TDR_WRITE_DELAY: STD_LOGIC;
BEGIN
	SCSR_ENABLE(7) <= (SCSR_C(7) or TX_SET_TDRE) and not TX_CLR_TDRE;-- and not TDR_WRITE_DELAY;
	SCSR7: entity work.enARdFF_2
	GENERIC MAP (RST_VALUE => '1')
  	PORT MAP (i_resetBar => RST,
  			  i_d => SCSR_ENABLE(7),
  			  i_enable => '1',
  			  i_clock => CLK,
  			  o_q => SCSR_C(7));

	SCSR_ENABLE(6) <= (SCSR_C(6) or RX_SET_RDRF) and not RX_CLR_RDRF;-- or RDR_READ);
	SCSR6: entity work.enARdFF_2
	GENERIC MAP (RST_VALUE => '0')
  	PORT MAP (i_resetBar => RST,
  			  i_d => SCSR_ENABLE(6),
  			  i_enable => '1',
  			  i_clock => CLK,
  			  o_q => SCSR_C(6));

	SCSR_ENABLE(5) <= '0';
	SCSR5: entity work.enARdFF_2
	GENERIC MAP (RST_VALUE => '0')
  	PORT MAP (i_resetBar => RST,
  			  i_d => SCSR_ENABLE(5),
  			  i_enable => '1',
  			  i_clock => CLK,
  			  o_q => SCSR_C(5));

	SCSR_ENABLE(4) <= '0';
	SCSR4: entity work.enARdFF_2
    GENERIC MAP (RST_VALUE => '0')
  	PORT MAP (i_resetBar => RST,
  			  i_d => SCSR_ENABLE(4),
  			  i_enable => '1',
  			  i_clock => CLK,
  			  o_q => SCSR_C(4));

	SCSR_ENABLE(3) <= '0';
	SCSR3: entity work.enARdFF_2
    GENERIC MAP (RST_VALUE => '0')
  	PORT MAP (i_resetBar => RST,
  			  i_d => SCSR_ENABLE(3),
  			  i_enable => '1',
  			  i_clock => CLK,
  			  o_q => SCSR_C(3));

	SCSR_ENABLE(2) <= '0';
	SCSR2: entity work.enARdFF_2
    GENERIC MAP (RST_VALUE => '0')
  	PORT MAP (i_resetBar => RST,
  			  i_d => SCSR_ENABLE(2),
  			  i_enable => '1',
  			  i_clock => CLK,
  			  o_q => SCSR_C(2));

	SCSR_ENABLE(1) <= (SCSR_C(1) or RX_SET_OE) and not RX_CLR_OE;
	SCSR1: entity work.enARdFF_2
    GENERIC MAP (RST_VALUE => '0')
  	PORT MAP (i_resetBar => RST,
  			  i_d => SCSR_ENABLE(1),
  			  i_enable => '1',
  			  i_clock => CLK,
  			  o_q => SCSR_C(1));

	SCSR_ENABLE(0) <= (SCSR_C(0) or RX_SET_FE) and not RX_CLR_FE;
	SCSR0: entity work.enARdFF_2
    GENERIC MAP (RST_VALUE => '0')
  	PORT MAP (i_resetBar => RST,
  			  i_d => SCSR_ENABLE(0),
  			  i_enable => '1',
  			  i_clock => CLK,
  			  o_q => SCSR_C(0));

	IRQ <= (TIE and SCSR_C(7)) or (RIE and (SCSR_C(6) or SCSR_C(1)));
	SCSR <= SCSR_C;
END ARCHITECTURE struct;
