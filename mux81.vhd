LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity mux81 is generic (N: integer);
                port (I7, I6, I5, I4, I3, I2, I1, I0: in STD_LOGIC_VECTOR (N-1 downto 0);
                      S: in STD_LOGIC_VECTOR (2 downto 0);
                      Y: out STD_LOGIC_VECTOR (N-1 downto 0));
end mux81;

architecture rtl of mux81 is
  signal s2Bar_mux_out, s2_mux_out:STD_LOGIC_VECTOR(N-1 downto 0);
  begin
    muxS2Bar: entity work.mux41 generic map (N => N)
                                   port map (I3 => I3,
                                             I2 => I2,
                                             I1 => I1,
                                             I0 => I0,
                                             S1 => S(1),
                                             S0 => S(0),
                                              Y => s2Bar_mux_out);

    muxS2    : entity work.mux41 generic map (N => N)
                                    port map (I3 => I7,
                                              I2 => I6,
                                              I1 => I5,
                                              I0 => I4,
                                              S1 => S(1),
                                              S0 => S(0),
                                              Y => s2_mux_out);

   mux:       entity work.mux21 generic map (N => N)
                                   port map (I1 => s2_mux_out,
                                             I0 => s2Bar_mux_out,
                                             S0  => S(2),
                                             Y  => Y);
end architecture rtl;
