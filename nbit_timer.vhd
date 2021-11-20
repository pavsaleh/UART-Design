LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY nbit_timer IS
  GENERIC (N: INTEGER);
  PORT (i_pLoadValue: IN STD_LOGIC_VECTOR(N-1 downto 0);
        i_load, i_enable: IN STD_LOGIC;
        i_clk, i_rst: IN STD_LOGIC;
        o_value: OUT STD_LOGIC_VECTOR(N-1 downto 0);
        o_done: OUT STD_LOGIC);
END nbit_timer;

ARCHITECTURE struct OF nbit_timer IS
SIGNAL reg_in, reg_out, adder_out: STD_LOGIC_VECTOR (N-1 downto 0);
SIGNAL or_tmp: STD_LOGIC_VECTOR (N-1 downto 0);
SIGNAL zero: STD_LOGIC;
SIGNAL reg_en: STD_LOGIC;
begin
  mux: ENTITY work.mux21 GENERIC MAP (N => N)
                            PORT MAP (I0 => adder_out,
                                      I1 => i_pLoadValue,
                                      S0 => i_load,
                                      Y  => reg_in);
  reg: ENTITY work.nbit_reg GENERIC MAP (N => N)
                               PORT MAP (i_resetBar => i_rst,
                                         i_load => reg_en,
                                         i_clock => i_clk,
                                         i_value => reg_in,
                                         o_value => reg_out);
  add: ENTITY work.nbit_rca GENERIC MAP (N => N)
                               PORT MAP (x => reg_out,
                                         y => (others => '1'), -- -1
                                         c_i => '0',
                                         s_o => adder_out);

  o_Value <= reg_out;
  reg_en <= (i_enable and not zero) or i_load;

  or_tmp(0) <= reg_out(0); -- reg_out(0) or 0 
  or_loop : for i in 1 to n-1 generate
    or_tmp(i) <= reg_out(i) or or_tmp(i-1); -- (x(n-1) or (x(n-2) or (x(n-3) or (... (x(1) or x(0)))))-- this takes the all of everything, since Quartus doesn't like using: or (reg_out)
  end generate or_loop;
  zero <= not or_tmp(n-1);
  o_done <= zero;
END ARCHITECTURE struct;
