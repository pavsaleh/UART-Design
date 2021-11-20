LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY char_lut IS
  PORT (char_sel: IN STD_LOGIC_VECTOR(2 downto 0);
  		state_sel: IN STD_LOGIC_VECTOR (1 downto 0);
        char_out: OUT STD_LOGIC_VECTOR (7 downto 0));
END char_lut;