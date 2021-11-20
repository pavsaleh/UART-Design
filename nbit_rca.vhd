LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY nbit_rca IS
	generic (N : Integer:= 4);
	PORT (
		x, y: IN STD_LOGIC_VECTOR(n-1 downto 0);
		c_i : IN STD_LOGIC;
		s_o : OUT STD_LOGIC_VECTOR(n-1 downto 0);
		c_o, overflow: OUT STD_LOGIC
		);
END nbit_rca;

architecture struct of nbit_rca is
signal c : STD_LOGIC_VECTOR (n-1 downto 0);
begin
	fa0: entity work.full_adder port map (a => x(0),
										  b => y(0),
										  c_in => c_i,
										  s => s_o(0),
										  c_out => c(0));

	adders: for i in 1 to n-1 generate
		fa: entity work.full_adder port map(a => x(i),
											b => y(i),
											c_in => c(i-1),
											s => s_o(i),
											c_out => c(i));
	end generate adders;

	c_o <= c(n-1);
	overflow <= c(n-1) xor c(n-2);
end architecture struct;
