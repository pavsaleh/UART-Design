LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY uart_rx IS
  PORT (CLK, RST: IN STD_LOGIC;
  		  RxD: IN STD_LOGIC;
        RDR: OUT STD_LOGIC_VECTOR (7 downto 0);
        RDRF: IN STD_LOGIC;
  		  SET_FE, SET_OE, SET_RDRF: OUT STD_LOGIC;
        Bclkx8: IN STD_LOGIC);
END uart_rx;

ARCHITECTURE struct of uart_rx IS
SIGNAL CLR_CLK_COUNT, CLR_BIT_COUNT, ENABLE_CLK_COUNT, ENABLE_BIT_COUNT: STD_LOGIC;
SIGNAL SHIFT_RSR, LD_RDR: STD_LOGIC;
SIGNAL CLK_COUNT3, CLK_COUNT7, BIT_COUNT8, lst_bclkBar, BCLK_EDGE: STD_LOGIC;
SIGNAL CLK_COUNT: STD_LOGIC_VECTOR(2 downto 0);
SIGNAL BIT_COUNT: STD_LOGIC_VECTOR(3 downto 0);
SIGNAL RSR_VALUE: STD_LOGIC_VECTOR(7 downto 0);
BEGIN
  fsm: ENTITY work.uart_rx_fsm port map (CLK => clk,
                                         RST => rst,
  		                                   RxD => RxD,
                                         CLK_COUNT3 => CLK_COUNT3,
                                         CLK_COUNT7 => CLK_COUNT7,
                                         BIT_COUNT8 => BIT_COUNT8,
                                         RDRF => RDRF,
  		                                   CLR_CLK_COUNT => CLR_CLK_COUNT,
                                         CLR_BIT_COUNT => CLR_BIT_COUNT,
                                         ENABLE_CLK_COUNT => ENABLE_CLK_COUNT,
                                         ENABLE_BIT_COUNT => ENABLE_BIT_COUNT,
  		                                   SHIFT_RSR => SHIFT_RSR,
                                         LD_RDR => LD_RDR,
  		                                   SET_FE => SET_FE,
                                         SET_OE => SET_OE,
                                         SET_RDRF => SET_RDRF, 
                                         BCLK_EDGE => BCLK_EDGE);

  clk_counter: ENTITY work.nbit_counter generic map (N => 3)
                                         port map (i_pLoadValue => "000",
                                                   i_load => CLR_CLK_COUNT,
                                                   i_enable => ENABLE_CLK_COUNT,
                                                   i_clk => clk,
                                                   i_rst => rst,
                                                   o_value => clk_count);
  CLK_COUNT3 <= clk_count(1) and clk_count(0);
  CLK_COUNT7 <= clk_count(2) and clk_count(1) and clk_count(0);

  bit_counter: ENTITY work.nbit_counter generic map (N => 4)
                                        port map (i_pLoadValue => "0000",
                                                  i_load => CLR_BIT_COUNT,
                                                  i_enable => ENABLE_BIT_COUNT,
                                                  i_clk => clk,
                                                  i_rst => rst,
                                                  o_value => bit_count);
  BIT_COUNT8 <= bit_count(3);

  rsr: ENTITY work.nbit_rshift_reg generic map (N => 8)
                                      port map (RST   => RST,
                                                CLK   => CLK,
                                       		      D     => "00000000",
                                       		      LOAD  => '0',
                                                W     => RxD,
                                                SHIFT => SHIFT_RSR,
                                       		      Q     => RSR_VALUE);

  rdr_reg: ENTITY work.nbit_reg generic map (N => 8)
                                   port map (i_resetBar => rst,
                                             i_load => LD_RDR,
                                      		   i_clock => clk,
                                      		   i_Value => RSR_VALUE,
                                      		   o_Value	=> RDR);

  BCLK_FF: ENTITY work.enardff_2 port map (i_resetBar => rst,
                                           i_d => BCLKx8,
                                           i_enable => '1',
                                           i_clock => clk,
                                           o_qBar => lst_bclkBar);

  BCLK_EDGE <= lst_bclkBar and BCLKx8;
END ARCHITECTURE struct;
