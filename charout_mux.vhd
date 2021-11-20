library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity charout_mux is
    Port (
           Char_sel : in STD_LOGIC_VECTOR (2 downto 0);
           Word_sel : in STD_LOGIC_VECTOR (1 downto 0);
           Char_out : out  STD_LOGIC_VECTOR (7 downto 0));
end charout_mux;

ARCHITECTURE struct of charout_mux IS
SIGNAL output1, output2, output3, output4: STD_LOGIC_VECTOR (7 downto 0);
BEGIN
    mux1:    entity work.mux81 generic map (N => 8)
                                port map (I7 => (others => '0'),
                                         I6 => (others => '0'),
                                         I5 => x"0d",
                                         I4 => x"72",
                                         I3 => x"53",
                                         I2 => x"5F",
                                         I1 => x"67",
                                         I0 => x"4D",
                                         S  => Char_sel,
                                         Y  => output1);

    mux2:    entity work.mux81 generic map (N => 8)
                                port map (I7 => (others => '0'),
                                         I6 => (others => '0'),
                                         I5 => x"0d",
                                         I4 => x"72",
                                         I3 => x"53",
                                         I2 => x"5F",
                                         I1 => x"79",
                                         I0 => x"4D",
                                         S  => Char_sel,
                                         Y  => output2);
                                         
    mux3:    entity work.mux81 generic map (N => 8)
                                port map (I7 => (others => '0'),
                                         I6 => (others => '0'),
                                         I5 => x"0d",
                                         I4 => x"67",
                                         I3 => x"53",
                                         I2 => x"5F",
                                         I1 => x"72",
                                         I0 => x"4D",
                                         S  => Char_sel,
                                         Y  => output3);

    mux4:    entity work.mux81 generic map (N => 8)
                                port map (I7 => (others => '0'),
                                         I6 => (others => '0'),
                                         I5 => x"0d",
                                         I4 => x"79",
                                         I3 => x"53",
                                         I2 => x"5F",
                                         I1 => x"72",
                                         I0 => x"4D",
                                         S  => Char_sel,
                                         Y  => output4);
    out_mux: ENTITY work.mux41 GENERIC MAP (N => 8)
								port map (I0 => output1,
                                         I1 => output2,
                                         I2 => output3,
                                         I3 => output4,
                                         S1 => Word_sel(1),
                                         S0 => Word_sel(0),
                                         Y => Char_out);
END ARCHITECTURE struct;