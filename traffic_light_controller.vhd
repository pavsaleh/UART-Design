LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY traffic_light_controller IS
  PORT (GClock, GReset: IN STD_LOGIC;
        MSC, SSC : IN STD_LOGIC_VECTOR(3 downto 0);
        SSCS: IN STD_LOGIC;
        MSTL, SSTL: OUT STD_LOGIC_VECTOR (2 downto 0);
        BCD1, BCD2: OUT STD_LOGIC_VECTOR (3 downto 0);
        STATE_INFO: OUT STD_LOGIC_VECTOR (1 downto 0));
END traffic_light_controller;

ARCHITECTURE struct OF traffic_light_controller IS
SIGNAL MT, ST: STD_LOGIC_VECTOR (3 downto 0);
SIGNAL MSC_load, MT_load, SSC_load, SST_load: STD_LOGIC;
SIGNAL MSC_enable, MT_enable, SSC_enable, SST_enable: STD_LOGIC;
SIGNAL MSC_done, MT_done, SSC_done, SST_done: STD_LOGIC;
SIGNAL MSC_count, MT_count, SSC_count, SST_count, TIMER_out: STD_LOGIC_VECTOR (3 downto 0);
SIGNAL TIMER_SELECT: STD_LOGIC_VECTOR (1 downto 0);
begin
  -- TODO: Populate this block
  fsm_controller: ENTITY work.traffic_light_fsm (struct_r) PORT MAP (CLK => GClock,
                                                     RST => GReset,
                                                     SSCS => SSCS,
                                                     MSC_DONE => MSC_DONE,
                                                     MSC_ENABLE => MSC_ENABLE,
                                                     MSC_LOAD => MSC_LOAD,
                                                     MT_DONE => MT_DONE,
                                                     MT_ENABLE => MT_ENABLE,
                                                     MT_LOAD => MT_LOAD,
                                                     SSC_DONE => SSC_DONE,
                                                     SSC_ENABLE => SSC_ENABLE,
                                                     SSC_LOAD => SSC_LOAD,
                                                     SST_DONE => SST_DONE,
                                                     SST_ENABLE => SST_ENABLE,
                                                     SST_LOAD => SST_LOAD,
                                                     TIMER_SELECT => TIMER_SELECT,
                                                     MSTL => MSTL,
                                                     SSTL => SSTL,
                                                     STATE_INFO => STATE_INFO
                                                     );

  mst_timer: ENTITY work.nbit_timer GENERIC MAP (N => 4)
                           PORT MAP (i_pLoadValue => MSC,
                                     i_load => MSC_load,
                                     i_enable => MSC_enable,
                                     i_clk => GClock,
                                     i_rst => GReset,
                                     o_value => MSC_count,
                                     o_done => MSC_done);

  mt_timer: ENTITY work.nbit_timer GENERIC MAP (N => 4)
                           PORT MAP (i_pLoadValue => MT,
                                     i_load => MT_load,
                                     i_enable => MT_enable,
                                     i_clk => GClock,
                                     i_rst => GReset,
                                     o_value => MT_count,
                                     o_done => MT_done);

  ssc_timer: ENTITY work.nbit_timer GENERIC MAP (N => 4)
                             PORT MAP (i_pLoadValue => SSC,
                                       i_load => SSC_load,
                                       i_enable => SSC_enable,
                                       i_clk => GClock,
                                       i_rst => GReset,
                                       o_value => SSC_count,
                                       o_done => SSC_done);

  sst_timer: ENTITY work.nbit_timer GENERIC MAP (N => 4)
                            PORT MAP (i_pLoadValue => ST,
                                      i_load => SST_load,
                                      i_enable => SST_enable,
                                      i_clk => GClock,
                                      i_rst => GReset,
                                      o_value => SST_count,
                                      o_done => SST_done);

  timer_mux: ENTITY work.mux41 GENERIC MAP (N => 4)
                             PORT MAP (I0 => MSC_count,
                                       I1 => MT_count,
                                       I2 => SSC_count,
                                       I3 => SST_count,
                                       S0 => timer_select(0),
                                       S1 => timer_select(1),
                                       Y  => timer_out);

  bcd: ENTITY work.bcd_decoder PORT MAP (i_hex => timer_out,
                                         o_bcd0 => BCD1,
                                         o_bcd1 => BCD2);

  ST <= "0011";
  MT <= "0110";
END ARCHITECTURE struct;