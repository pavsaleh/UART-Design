LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY bcd_decoder Is
  PORT (i_hex: IN STD_LOGIC_VECTOR(3 downto 0);
        o_bcd1, o_bcd0: OUT STD_LOGIC_VECTOR(3 downto 0));
END bcd_decoder;

ARCHITECTURE struct of bcd_decoder IS
begin
  o_bcd0(0) <= i_hex(0);
  o_bcd0(1) <= (not i_hex(3) and i_hex(1)) or (i_hex(3) and i_hex(2) and not i_hex(1));
  o_bcd0(2) <= (not i_hex(3) and i_hex(2)) or (i_hex(3) and i_hex(2) and i_hex(1));
  o_bcd0(3) <= i_hex(3) and not i_hex(2) and not i_hex(1);

  o_bcd1(0) <= (i_hex(3) and i_hex(2)) or (i_hex(3) and i_hex(1));
  o_bcd1(1) <= '0';
  o_bcd1(2) <= '0';
  o_bcd1(3) <= '0';
end architecture struct;
