LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY traffic_light_fsm IS
  PORT (CLK, RST: IN STD_LOGIC;
  		SSCS: IN STD_LOGIC;
  		MSC_DONE, MT_DONE, SSC_DONE, SST_DONE: IN STD_LOGIC;
  		MSC_ENABLE, MT_ENABLE, SSC_ENABLE, SST_ENABLE: OUT STD_LOGIC;
  		MSC_LOAD, MT_LOAD, SSC_LOAD, SST_LOAD: OUT STD_LOGIC;
  		TIMER_SELECT: OUT STD_LOGIC_VECTOR (1 downto 0);
  		MSTL, SSTL: OUT STD_LOGIC_VECTOR (2 downto 0);
      STATE_INFO: OUT STD_LOGIC_VECTOR(1 downto 0));
END traffic_light_fsm;

ARCHITECTURE struct of traffic_light_fsm IS
SIGNAL S2, S1, S0, S2_NXT, S1_NXT, S0_NXT: STD_LOGIC;
SIGNAL x_0, x_1, x_2, x_3, X: STD_LOGIC_VECTOR(0 downto 0);
BEGIN
	-- Declare the state flip flops
	s2_dFF: entity work.enardFF_2  PORT MAP (i_resetBar => rst,
        	                                 i_D => S2_NXT,
            	                             o_Q => S2,
                    	                     i_clock => clk,
                	                         i_enable => '1');

  	s1_dFF: entity work.enardFF_2 PORT MAP(i_D => S1_NXT,
    	                                   i_resetBar => rst,
        	                               o_Q => S1,
            	                           i_clock => clk,
                	                       i_enable => '1');

  	s0_dFF: entity work.enardFF_2 PORT MAP(i_D => S0_NXT,
                                           i_resetBar => rst,
     	                                   o_Q => S0,
                                           i_clock => clk,
                                           i_enable => '1');

	-- Declare next states
	--S2_NXT     <= (MT_DONE and not S2 and S1 and S0) or (S2 and ((not SST_DONE and S0) or (not S1)));
	S2_NXT <= (not X(0) and S2) or (X(0) and (S2 xor S1)) or (X(0) and S2  and S1 and not S0);
	--S1_NXT     <= (not S2 and S1 and not S0) or (S2 and S1 and not S0) or (not S2 and not S1 and S0 and MSC_DONE and SSCS) or (not S2 and S1 and S0 and not MT_DONE) or (S2 and not S1 and S0 and SSC_DONE) or (S2 and S1 and S0 and not SST_DONE);
	S1_NXT <= (not X(0) and S1) or (X(0) and (S1 xor S0));
	--S0_NXT     <= (not S0) or ((not S2) and (not S1) and not (MSC_DONE and SSCS)) or ((not S2) and S1 and (not MT_DONE)) or (S2 and (not S1) and (not SSC_DONE)) or (S2 and S1 and (not SST_DONE));
    S0_NXT <= (not X(0)) or (X(0) and not S0);
	-- Declare Outputs
	MSTL(1) <= not S2 and not S1;
	MSTL(2) <= not S2 and S1;
	MSTL(0) <= S2;

	SSTL(2) <= S2 and not S1;
	SSTL(1) <= S2 and S1;
	SSTL(0) <= not S2;

	MSC_LOAD    <= not S2   and not S1 and not S0;
	MSC_ENABLE  <= not S2   and not S1 and S0;
	MT_LOAD     <= not S2   and     S1 and not S0;
	MT_ENABLE   <= not S2   and     S1 and S0;
	SSC_LOAD    <=     S2   and not S1 and not S0;
	SSC_ENABLE  <=     S2   and not S1 and S0;
	SST_LOAD    <=     S2   and     S1 and not S0;
	SST_ENABLE  <=     S2   and     S1 and S0;

	TIMER_SELECT(1) <= S2;
	TIMER_SELECT(0) <= S1;

  STATE_INFO <= (1 => S2, 0 => S1);

-- Helper mux
	x_0(0) <= MSC_DONE and SSCS;
	x_1(0) <= MT_DONE;
	x_2(0) <= SSC_DONE;
	x_3(0) <= SST_DONE;
	mux: ENTITY work.mux41 GENERIC MAP (N => 1)
	PORT MAP (I0 => x_0,
          I1 => x_1,
          I2 => x_2,
          I3 => x_3,
          S1 => S1,
          S0 => S0,
          Y  => X);

END ARCHITECTURE struct;

ARCHITECTURE struct_r of traffic_light_fsm IS
SIGNAL S1, S1_NXT, S0, S0_NXT: STD_LOGIC;
SIGNAL x_0, x_1, x_2, x_3, X: STD_LOGIC_VECTOR(0 downto 0);
BEGIN
-- Declare the state flip flops
  s1_dFF: entity work.enardFF_2 PORT MAP(i_D => S1_NXT,
                                       i_resetBar => rst,
                                       o_Q => S1,
                                       i_clock => clk,
                                       i_enable => '1');

  s0_dFF: entity work.enardFF_2 PORT MAP(i_D => S0_NXT,
                                         i_resetBar => rst,
                                       o_Q => S0,
                                         i_clock => clk,
                                         i_enable => '1');

-- Declare next states
S1_NXT     <= (not X(0) and S1) or (X(0) and (S1 xnor S0));
S0_NXT     <= X(0) xor S0;

-- Declare Outputs
MSTL(1) <= not S1 and not S0;
MSTL(2) <= not S1 and S0;
MSTL(0) <= S1;

SSTL(2) <= S1 and not S0;
SSTL(1) <= S1 and S0;
SSTL(0) <= not S1;

MSC_LOAD   <= S1 or S0;
MSC_ENABLE <= '1';
MT_LOAD    <= S1 or not S0;
MT_ENABLE  <= '1';
SSC_LOAD   <= not S1 or S0;
SSC_ENABLE <= '1';
SST_LOAD    <= not S1 or not S0;
SST_ENABLE  <='1';

TIMER_SELECT(1) <= S1;
TIMER_SELECT(0) <= S0;

STATE_INFO <= (1 => S1, 0 => S0);

-- Helper mux
x_0(0) <= MSC_DONE and SSCS;
x_1(0) <= MT_DONE;
x_2(0) <= SSC_DONE;
x_3(0) <= SST_DONE;
mux: ENTITY work.mux41 GENERIC MAP (N => 1)
PORT MAP (I0 => x_0,
          I1 => x_1,
          I2 => x_2,
          I3 => x_3,
          S1 => S1,
          S0 => S0,
          Y  => X);
END ARCHITECTURE struct_r;
