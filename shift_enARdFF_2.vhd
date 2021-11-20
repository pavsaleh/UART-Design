LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY shift_enARdFF_2 IS
	PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_shiftd, i_loadd: IN	STD_LOGIC;
		i_shift, i_load	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
END shift_enARdFF_2;

ARCHITECTURE rtl OF shift_enARdFF_2 IS
	SIGNAL enable, d : STD_LOGIC;

BEGIN

oneBitRegister:
	enable <= i_shift or i_load;
	d  <= (i_shiftd and i_shift and not i_load) or (i_loadd and i_load);

						reg: entity work.enARdFF_2 PORT MAP (i_resetBar => i_resetBar,
														     i_d => d,
														     i_enable => enable,
														     i_clock => i_clock,
														     o_q => o_q,
														     o_qBar => o_qBar
																);
END rtl;
