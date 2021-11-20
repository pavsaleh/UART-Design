LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY nbit_down_counter IS
  GENERIC (N: INTEGER);
  PORT (i_pLoadValue: IN STD_LOGIC_VECTOR(N-1 downto 0);
        i_load, i_enable: IN STD_LOGIC;
        i_clk, i_rst: IN STD_LOGIC;
        o_value: OUT STD_LOGIC_VECTOR(N-1 downto 0));
        --o_done: OUT STD_LOGIC);
END nbit_down_counter;

ARCHITECTURE struct OF nbit_down_counter IS
SIGNAL reg_in, reg_out, adder_out: STD_LOGIC_VECTOR (N-1 downto 0);
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
                                         y => (others => '0'), 
                                         c_i => '1',
                                         s_o => adder_out);

  o_Value <= reg_out;
  reg_en <= i_enable or i_load;

 -- zero <= nor reg_out;

  --o_done <= zero;
END ARCHITECTURE struct;
