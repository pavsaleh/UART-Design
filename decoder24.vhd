LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------------------------------
-- 2-to-4 decoder
-- EN | A  | Y0 | Y1 | Y2 | Y3
--  0 | XX |  0 |  0 |  0 |  0
--  1 | 00 |  1 |  0 |  0 |  0
--  1 | 01 |  0 |  1 |  0 |  0
--  1 | 10 |  0 |  0 |  1 |  0
--  1 | 11 |  0 |  0 |  0 |  1
--------------------------------------------------------------------------------

ENTITY decoder24 IS
  PORT (EN: IN STD_LOGIC;
  		A: IN STD_LOGIC_VECTOR (1 downto 0);
  		Y0, Y1, Y2, Y3: OUT STD_LOGIC);
END decoder24;

ARCHITECTURE struct of decoder24 IS
BEGIN
	Y0 <= EN and (not A(1) and not A(0));
	Y1 <= EN and (not A(1) and     A(0));
	Y2 <= EN and (    A(1) and not A(0));
	Y3 <= EN and (    A(1) and     A(0));
END ARCHITECTURE struct;