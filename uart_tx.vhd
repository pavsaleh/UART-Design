LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY uart_tx IS
  PORT (CLK, RST: IN STD_LOGIC;
  		  TxD: OUT STD_LOGIC;
        TDR: IN STD_LOGIC_VECTOR (7 downto 0);
        LD_TDR, TDRE: IN STD_LOGIC;
  		  SET_TDRE: OUT STD_LOGIC;
        BCLK: IN STD_LOGIC);
END uart_tx;

ARCHITECTURE struct of uart_tx IS
SIGNAL BIT_COUNT9, TSR_SHIFT_OUT, BCLK_EDGE, lst_bclkBar: STD_LOGIC;
SIGNAL CLR_BIT_COUNT, ENABLE_BIT_COUNT, SHIFT_TSR, LD_TSR, START, TSR_LOAD: STD_LOGIC;
SIGNAL BIT_COUNT: STD_LOGIC_VECTOR(3 downto 0);
SIGNAL TDR_VALUE: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL TSR_IN, TSR_VALUE: STD_LOGIC_VECTOR(9 downto 0);
SIGNAL PARITY: STD_LOGIC;
BEGIN
  fsm: ENTITY work.uart_tx_fsm port map (CLK => clk,
                                         RST => rst,
                                         TDRE => TDRE,
                                         BITCOUNT9 => BIT_COUNT9,
                                         BCLK_EDGE => BCLK_EDGE,
                                         CLR_BIT_COUNT => CLR_BIT_COUNT,
                                         ENABLE_BIT_COUNT => ENABLE_BIT_COUNT,
                                         SHIFT_TSR => SHIFT_TSR,
                                         LD_TSR => LD_TSR,
                                         START => START,
                                         SET_TDRE => SET_TDRE);

  bit_counter: ENTITY work.nbit_counter generic map (N => 4)
                                         port map (i_pLoadValue => (others => '0'),
                                                   i_load => CLR_BIT_COUNT,
                                                   i_enable => ENABLE_BIT_COUNT,
                                                   i_clk => CLK,
                                                   i_rst => rst,
                                                   o_value => BIT_COUNT);
  BIT_COUNT9 <= bit_count(3) and bit_count(0);

  TSR_LOAD <= LD_TSR or START;
  TSR_IN <= (0 => not START,
             1 => (not START and TDR_VALUE(0)) or (START and TSR_VALUE(1)),
             2 => (not START and TDR_VALUE(1)) or (START and TSR_VALUE(2)),
             3 => (not START and TDR_VALUE(2)) or (START and TSR_VALUE(3)),
             4 => (not START and TDR_VALUE(3)) or (START and TSR_VALUE(4)),
             5 => (not START and TDR_VALUE(4)) or (START and TSR_VALUE(5)),
             6 => (not START and TDR_VALUE(5)) or (START and TSR_VALUE(6)),
             7 => (not START and TDR_VALUE(6)) or (START and TSR_VALUE(7)),
             8 => (not START and TDR_VALUE(7)) or (START and PARITY),
             9 => '1');
  PARITY <= TSR_VALUE(1) xor TSR_VALUE(2) xor TSR_VALUE(3) xor TSR_VALUE(4)
            xor TSR_VALUE(5) xor TSR_VALUE(6) xor TSR_VALUE(7);
  tsr: ENTITY work.nbit_rshift_reg generic map (N => 10)
                                      port map (RST   => RST,
                                                CLK   => CLK,
                                       		      D     => TSR_IN,
                                       		      LOAD  => TSR_LOAD,
                                                W     => '1',
                                                SHIFT => SHIFT_TSR,
                                       		      Q     => TSR_VALUE);

  tdr_reg: ENTITY work.nbit_reg generic map (N => 8)
                                      port map (i_resetBar => rst,
                                                i_load => LD_TDR,
                                      		      i_clock => clk,
                                      		      i_Value => TDR,
                                      		      o_Value	=> TDR_VALUE);

  BCLK_FF: ENTITY work.enardff_2 port map (i_resetBar => rst,
                                           i_d => BCLK,
                                           i_enable => '1',
                                           i_clock => clk,
                                           o_qBar => lst_bclkBar);

  BCLK_EDGE <= lst_bclkBar and BCLK;


  TxD <= TSR_VALUE(0);
END ARCHITECTURE struct;
