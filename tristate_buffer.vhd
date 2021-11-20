LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------------------------------
-- Tristate Buffer
-- EN | X | Y
--  0 | 0 | Z
--  0 | 1 | Z
--  1 | 0 | 0
--  1 | 1 | 1
--------------------------------------------------------------------------------

ENTITY tristate_buffer IS
  GENERIC (N: INTEGER);
  PORT (X: IN STD_LOGIC_VECTOR (N-1 downto 0);
  		Y: OUT STD_LOGIC_VECTOR (N-1 downto 0);
  		EN: IN STD_LOGIC);
END tristate_buffer;

ARCHITECTURE behav of tristate_buffer IS
BEGIN
	Y <= X when EN = '1' else (others => 'Z');
END ARCHITECTURE behav;