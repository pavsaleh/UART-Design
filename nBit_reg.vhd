LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY nBit_reg IS
  GENERIC (N: integer);
	PORT(
		i_resetBar, i_load	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(N-1 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(N-1 downto 0));
END nBit_reg;

ARCHITECTURE rtl OF nbit_reg IS
	SIGNAL int_Value, int_notValue : STD_LOGIC_VECTOR(N-1 downto 0);
BEGIN

reg_ff: for i in 0 to N-1 generate
  reg: entity work.enARdFF_2
  	PORT MAP (i_resetBar => i_resetBar,
  			  i_d => i_Value(i),
  			  i_enable => i_load,
  			  i_clock => i_clock,
  			  o_q => int_Value(i),
  	      o_qBar => int_notValue(i));
end generate reg_ff;

  o_value <= int_value;

END rtl;
