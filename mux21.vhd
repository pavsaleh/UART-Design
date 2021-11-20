LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity mux21 is generic (N: integer);
                port (I1, I0: in STD_LOGIC_VECTOR (N-1 downto 0);
                      S0: in STD_LOGIC;
                      Y: out STD_LOGIC_VECTOR (N-1 downto 0));
end mux21;

architecture rtl of mux21 is
  signal s0_bar: STD_LOGIC;
  signal s_i1, s_i0: STD_LOGIC_VECTOR(N-1 downto 0);
  begin
    s0_bar <= not s0;

    mux: for i in 0 to N-1 generate
      s_i1(i) <= s0 and I1(i);
      s_i0(i) <= s0_bar and I0(i);

      Y(i) <= s_i1(i) or s_i0(i);
    end generate;
end architecture rtl;
