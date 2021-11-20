LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY nbit_rshift_reg IS generic (N: integer);
	PORT(
		RST	: IN	STD_LOGIC;
		D		: IN	STD_LOGIC_VECTOR (N-1 downto 0);
		W : IN STD_LOGIC;
		LOAD, SHIFT	: IN	STD_LOGIC;
		CLK		: IN	STD_LOGIC;
		Q, QBar	: OUT	STD_LOGIC_VECTOR (N-1 downto 0)
		);
END nbit_rshift_reg;

architecture rtl of nbit_rshift_reg is
	signal value_int: STD_LOGIC_VECTOR (N-1 downto 0);
begin
	reg_ff: for i in 0 to N-2 generate
	begin
		reg: entity work.shift_enARdFF_2 PORT MAP ( i_resetBar => RST,
												    i_shiftd => value_int(i+1),
												    i_loadd  => D(i),
													i_shift => shift,
													i_load => load,
													i_clock => CLK,
													o_q => value_int(i),
													o_qBar => qBar(i)
													);

	END generate;

							regn_1: entity work.shift_enARdFF_2 PORT MAP (i_resetBar => RST,
														     i_shiftd => W,
														     i_loadd  => D(n-1),
														     i_shift => shift,
														     i_load => load,
														     i_clock => CLK,
														     o_q => value_int(n-1),
														     o_qBar => qBar(n-1)
															);


	Q <= value_int;
		
end architecture rtl;
