LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity mux41 is generic (N: integer);
                port (I3, I2, I1, I0: in STD_LOGIC_VECTOR (N-1 downto 0);
                      S1, S0: in STD_LOGIC;
                      Y: out STD_LOGIC_VECTOR (N-1 downto 0));
end mux41;

architecture rtl of mux41 is
  signal s1_bar, s0_bar: STD_LOGIC;
  signal s_i3, s_i2, s_i1, s_i0: STD_LOGIC_VECTOR(N-1 downto 0);
  begin
    s1_bar <= not s1;
    s0_bar <= not s0;

    mux: for i in 0 to N-1 generate
      s_i3(i) <= s1 and s0 and I3(i);
      s_i2(i) <= s1 and s0_bar and I2(i);
      s_i1(i) <= s1_bar and s0 and I1(i);
      s_i0(i) <= s1_bar and s0_bar and I0(i);

      Y(i) <= s_i3(i) or s_i2(i) or s_i1(i) or s_i0(i);
    end generate;
end architecture rtl;
