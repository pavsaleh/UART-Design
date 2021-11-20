LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY full_adder IS
	PORT (
		a, b, c_in: IN STD_LOGIC;
		s, c_out: OUT STD_LOGIC
		);
END full_adder;

ARCHITECTURE LogicFunction OF full_adder IS
	signal tmp_1, tmp_2, tmp_3 : std_logic;
BEGIN
	tmp_1 <= a xor b;
	s <= c_in xor tmp_1;

	tmp_2 <= a and b;
	tmp_3 <= tmp_1 and c_in;
	c_out <= tmp_2 or tmp_3;
END LogicFunction;