LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY traffic_light_w_uart  is 
	port(        
		GReset,  GClock, tlc_clk: IN STD_LOGIC;
		MSC, SSC: IN STD_LOGIC_VECTOR(3 downto 0);
        SSCS: IN STD_LOGIC;
        MSTL, SSTL: OUT STD_LOGIC_VECTOR (2 downto 0);
        BCD1, BCD2: OUT STD_LOGIC_VECTOR (3 downto 0);
        RxD: IN STD_LOGIC;
        TxD: OUT STD_LOGIC
     );
END traffic_light_w_uart;

ARCHITECTURE struct OF traffic_light_w_uart IS
SIGNAL uart_clk, RST: STD_LOGIC;
SIGNAL IRQ: STD_LOGIC;
SIGNAL STATE_INFO: STD_LOGIC_VECTOR (1 downto 0);
SIGNAL DATA_BUS: STD_LOGIC_VECTOR (7 downto 0);
SIGNAL ADDR: STD_LOGIC_VECTOR(1 downto 0);
SIGNAL R_WBar, UART_SEL: STD_LOGIC;
begin
    uart_fsm: ENTITY work.ctrl PORT MAP (CLK => GClock,
                                         RST => GReset,
                                         IRQ => IRQ,
                                         TRAFFIC_STATE => STATE_INFO,
                                         DATA_BUS => DATA_BUS,
                                         ADDR => ADDR,
                                         R_WBar => R_WBAR,
                                         UART_SEL => UART_SEL);

    uart:  entity work.uart_top port map (clk => GClock,--uart_clk,
    									  rst => GReset,
    									  RxD => RxD, 
    									  TxD => TxD, 
    									  Data_Bus => DATA_BUS, 
    									  addr => ADDR, 
    									  R_WBar => R_WBAR, 
    									  UART_SEL => UART_SEL, 
    									  IRQ => IRQ);

    tlc: ENTITY work.traffic_light_controller  PORT map(GClock => tlc_clk, 
                                                        GReset => GReset,
                                                        MSC => MSC, SSC => SSC,
                                                        SSCS => SSCS,
                                                        MSTL => MSTL, SSTL => SSTL,
                                                        BCD1 => BCD1, BCD2 => BCD2,
                                                        STATE_INFO => STATE_INFO);

    --clk_div: ENTITY work.clk_div port map (clock_25MHz => GClock,
    									   --clock_25MHz => uart_clk,
    --									   clock_10KHz   => tlc_clk);
END ARCHITECTURE struct;