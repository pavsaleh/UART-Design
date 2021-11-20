LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY project_wrap is
	PORT (
		CLOCK_50: IN STD_LOGIC;
		SW: IN STD_LOGIC_VECTOR(15 downto 0);
		KEY: IN STD_LOGIC_VECTOR(3 downto 0);
		HEX1, HEX0: OUT STD_LOGIC_VECTOR (6 downto 0);
        LEDR, LEDG: OUT STD_LOGIC_VECTOR(2 downto 0);
        UART_TXD: OUT STD_LOGIC;
        UART_RXD: IN STD_LOGIC
	);
END project_wrap;

ARCHITECTURE struct OF project_wrap is
SIGNAL bcd_led0, bcd_led1: STD_LOGIC_VECTOR(3 downto 0);
signal tcl_clk: STD_LOGIC;
BEGIN
	project: entity work.traffic_light_w_uart port map (        
		GReset => SW(15), 
        GClock => CLOCK_50,
        tlc_clk => tcl_clk,
        MSC => SW(7 downto 4), SSC => SW(3 downto 0),
        SSCS => KEY(0),
        MSTL => LEDR(2 downto 0), SSTL => LEDG(2 downto 0),
        BCD1 => bcd_led0, BCD2 => bcd_led1,
        RxD => UART_RXD, TxD => UART_TXD
     );

	clk_divider: entity work.clk_div port map (clock_25MHz => CLOCK_50,
											   clock_1Hz => tcl_clk);

	led1: entity work.dec_7seg port map(i_hexDigit => bcd_led1,
                                 o_segment_a=> HEX1(0),
                                 o_segment_b=> HEX1(1),
                                 o_segment_c=> HEX1(2),
                                 o_segment_d=> HEX1(3),
                                 o_segment_e=> HEX1(4),
                                 o_segment_f=> HEX1(5),
                                 o_segment_g=> HEX1(6));

    led0: entity work.dec_7seg port map(i_hexDigit => bcd_led0,
                                 o_segment_a=> HEX0(0),
                                 o_segment_b=> HEX0(1),
                                 o_segment_c=> HEX0(2),
                                 o_segment_d=> HEX0(3),
                                 o_segment_e=> HEX0(4),
                                 o_segment_f=> HEX0(5),
                                 o_segment_g=> HEX0(6));
END ARCHITECTURE struct;