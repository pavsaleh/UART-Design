LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY uart_top is 
	port (clk, rst: IN STD_LOGIC;
		  RxD: IN STD_LOGIC;
		  TxD: OUT STD_LOGIC;
		  Data_Bus: INOUT STD_LOGIC_VECTOR (7 downto 0);
		  addr: IN STD_LOGIC_VECTOR (1 downto 0);
		  R_WBar, UART_SEL: IN STD_LOGIC;
		  IRQ: OUT STD_LOGIC);
END uart_top;


ARCHITECTURE struct of uart_top is
SIGNAL Bclk, Bclkx8: STD_LOGIC;
SIGNAL LD_TDR, LD_SCCR, RD_RDR: STD_LOGIC;
SIGNAL BUS_IN: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL BUS_OUT_SCCR, BUS_OUT_RDR, BUS_OUT_SCSR: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL RX_SET_FE, RX_SET_OE, RX_SET_RDRF, TX_SET_TDRE: STD_LOGIC;
SIGNAL TIE, RIE: STD_LOGIC;
SIGNAL SEL: STD_LOGIC_VECTOR (2 downto 0);
BEGIN
	bus_decoder: ENTITY work.uart_bus_decoder port map (ADDR => ADDR,
														R => R_WBar,
														UART_SEL => UART_SEL,
														DATA_BUS => Data_Bus,
														LD_TDR => LD_TDR,
														LD_SCCR => LD_SCCR,
														RD_RDR => RD_RDR,
														DATA_OUT => BUS_IN,
														DATA_IN_SCCR => BUS_OUT_SCCR,
														DATA_IN_RDR => BUS_OUT_RDR,
														DATA_IN_SCSR => BUS_OUT_SCSR
														);

	int_gen: ENTITY work.uart_int port map(CLK => CLK,
										   RST => RST,
										   RX_SET_FE => RX_SET_FE,
										   RX_SET_OE => RX_SET_OE,
										   RX_SET_RDRF => RX_SET_RDRF,
										   TX_SET_TDRE => TX_SET_TDRE,
										   TIE => TIE,
										   RIE => RIE,
										   IRQ => IRQ,
										   SCSR => BUS_OUT_SCSR,
										   RX_CLR_FE => RD_RDR,
										   RX_CLR_OE => RD_RDR,
										   RX_CLR_RDRF => RD_RDR,
										   TX_CLR_TDRE => LD_TDR);

	ctrl_reg: ENTITY work.uart_ctrl port map (CLK => clk,
											  RST => RST,
											  RIE => RIE,
											  TIE => TIE,
											  SEL => SEL,
											  LD_CTRL => LD_SCCR,
											  CTRL_IN => BUS_IN,
											  SCCR => BUS_OUT_SCCR);

	baud_generator: ENTITY work.baud_generator port map(clk => clk,
														 rst => rst,
														 Bclkx8 => Bclkx8,
														 Bclk   => Bclk,
														 SEL => SEL);

	rx: ENTITY work.uart_rx port map (CLK => clk,
									  RST => RST,
									  RxD => RxD,
									  RDR => BUS_OUT_RDR,
									  RDRF => BUS_OUT_SCSR(6),
									  SET_FE => RX_SET_FE,
									  SET_OE => RX_SET_OE,
									  SET_RDRF => RX_SET_RDRF,
									  Bclkx8 => Bclkx8
									  );

	tx: ENTITY work.uart_tx port map (CLK => clk,
									  RST => RST,
									  TxD => TxD,
									  TDR => BUS_IN,
									  LD_TDR => LD_TDR,
									  TDRE => BUS_OUT_SCSR(7),
									  SET_TDRE => TX_SET_TDRE,
									  Bclk => Bclk);
END ARCHITECTURE struct;