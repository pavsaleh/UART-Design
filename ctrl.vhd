LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ctrl IS
  PORT (CLK, RST: IN STD_LOGIC;
  		IRQ: IN STD_LOGIC;
  		TRAFFIC_STATE: IN STD_LOGIC_VECTOR (1 downto 0);
  		DATA_BUS: INOUT STD_LOGIC_VECTOR (7 downto 0);
  		ADDR: OUT STD_LOGIC_VECTOR(1 downto 0);
		R_WBar, UART_SEL: OUT STD_LOGIC);
END ctrl;

ARCHITECTURE struct of ctrl is 
SIGNAL CHAR_CNT6, STATE_CHANGE, INC_CHAR_CNT, CLR_CHAR_CNT, SETUP_SEL: STD_LOGIC;
SIGNAL CHAR_COUNT: STD_LOGIC_VECTOR (2 downto 0);
SIGNAL LST_STATE: STD_LOGIC_VECTOR (1 downto 0);
SIGNAL CHAR_OUT: STD_LOGIC_VECTOR(7 downto 0);
BEGIN
	fsm: entity work.ctrl_fsm port map (CLK => CLK,
										RST => RST,
  										IRQ => IRQ, 
  										CHAR_CNT6 => CHAR_CNT6, 
  										STATE_CHANGE => STATE_CHANGE,
  										INC_CHAR_CNT => INC_CHAR_CNT, 
  										CLR_CHAR_CNT => CLR_CHAR_CNT,
  										SETUP_SEL => SETUP_SEL,
  										R_WBar => R_WBar,
  										UART_SEL => UART_SEL);

	char_counter: ENTITY work.nbit_counter generic map (N => 3)
                                         port map (i_pLoadValue => (others => '0'),
                                                   i_load => CLR_CHAR_CNT,
                                                   i_enable => INC_CHAR_CNT,
                                                   i_clk => CLK,
                                                   i_rst => rst,
                                                   o_value => CHAR_COUNT);
    CHAR_CNT6 <= CHAR_COUNT(2) and CHAR_COUNT(1);

    char_lut: entity work.charout_mux port map (Char_sel => CHAR_COUNT,
          										Word_sel => LST_STATE,
           										Char_out => CHAR_OUT);

    state_ff: entity work.nbit_reg GENERIC MAP (N => 2)
    								  PORT MAP(i_resetBar => rst,
    			 							   i_load => '1',
											   i_clock => clk,
											   i_Value	=> TRAFFIC_STATE,
											   o_Value	=> LST_STATE);

    STATE_CHANGE <= (LST_STATE(1) xor TRAFFIC_STATE(1)) or (LST_STATE(0) xor TRAFFIC_STATE(0));


    data_bus_mux: entity work.mux21 GENERIC MAP (N => 8)
    								   PORT MAP (I1 => x"80",
    								   			 I0 => CHAR_OUT,
    								   			 S0 => SETUP_SEL,
    								   			 Y  => DATA_BUS);

    addr_bus_mux: entity work.mux21 GENERIC MAP (N => 2)
    								   PORT MAP (I1 => "10",
    								   			 I0 => "00",
    								   			 S0 => SETUP_SEL,
    								   			 Y  => ADDR);



end ARCHITECTURE struct;
