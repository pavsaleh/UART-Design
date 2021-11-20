LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity baud_generator is
                port (rst,clk: in STD_LOGIC;
                      sel: in STD_LOGIC_VECTOR (2 downto 0);
                      Bclkx8, Bclk: out STD_LOGIC);
end baud_generator;

ARCHITECTURE struct of baud_generator is
SIGNAL clk_25, clk_div41: STD_LOGIC;
SIGNAL clk_div_tmp: STD_LOGIC_VECTOR (7 downto 0);
SIGNAL Bclkx8_tmp: STD_LOGIC_VECTOR (0 downto 0);
begin

  div_2_25: ENTITY work.single_freq_div port map (
    i_resetBar => rst,
    i_clk => clk,
    o_clk2 => clk_25);
  div41: entity work.freq_div41 port map (i_resetBar => rst,
                                          i_clk => clk_25,
                                          o_clkdiv => clk_div41);
  clkdiv: entity work.freq_div port map  (i_resetBar => rst,
  		                                    i_clk => clk_div41,
  		                                    o_clkdiv => clk_div_tmp);
  mux:    entity work.mux81 generic map (N => 1)
                               port map (I7 => clk_div_tmp(7 downto 7),
                                         I6 => clk_div_tmp(6 downto 6),
                                         I5 => clk_div_tmp(5 downto 5),
                                         I4 => clk_div_tmp(4 downto 4),
                                         I3 => clk_div_tmp(3 downto 3),
                                         I2 => clk_div_tmp(2 downto 2),
                                         I1 => clk_div_tmp(1 downto 1),
                                         I0 => clk_div_tmp(0 downto 0),
                                         S  => sel,
                                         Y  => Bclkx8_tmp);
  Bclkx8 <= Bclkx8_tmp(0);
  div8: entity work.freq_div8 port map (i_resetBar => rst,
                                          i_clk => Bclkx8_tmp(0),
                                          o_clkdiv => Bclk);
end architecture struct;
