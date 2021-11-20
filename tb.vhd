LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY tb IS
END tb;

ARCHITECTURE bg_tb of tb is 
signal rst,clk: STD_LOGIC := '0';
signal sel: STD_LOGIC_VECTOR (2 downto 0) := "000";
signal Bclkx8, Bclk: STD_LOGIC;
BEGIN
	dut: entity work.baud_generator port map(rst,clk, sel, Bclkx8, Bclk);

	clock: clk <= '1' after 20ns when clk = '0' else
			      '0' after 20ns when clk = '1';

	process is BEGIN
	wait for 20ns;
	rst <= '1';
	wait for 1000000000ns;
	end process;
end architecture;


ARCHITECTURE rx_tb of tb IS 
SIGNAL CLK, RST, Bclkx8: STD_LOGIC := '0';
SIGNAL RxD:  STD_LOGIC := '1';
SIGNAL RDR:  STD_LOGIC_VECTOR (7 downto 0);
SIGNAL RDRF: STD_LOGIC := '0';
SIGNAL SET_FE, SET_OE, SET_RDRF: STD_LOGIC;

BEGIN
	dut: entity work.uart_rx port map(clk, rst, RxD, RDR, RDRF, SET_FE, SET_OE, SET_RDRF, Bclkx8);

	clock: clk <= '1' after 5ns when clk = '0' else
			      '0' after 5ns when clk = '1';
	

	stimulus: process is 
	BEGIN
		wait for 40ns;
		rst <= '1';
		
		wait for 120ns;

		-- Normal Frame
		RxD <= '0'; -- Start Bit
		wait for 80ns;
		-- 01010101
		RxD <= '1'; wait for 80ns; -- LSB
		RxD <= '0'; wait for 80ns;
		RxD <= '1'; wait for 80ns;
		RxD <= '0'; wait for 80ns;
		RxD <= '1'; wait for 80ns;
		RxD <= '0'; wait for 80ns;
		RxD <= '1'; wait for 80ns;
		RxD <= '0'; wait for 80ns; -- MSB
		-- End bit
		RxD <= '1';  wait until (SET_RDRF = '1'); wait for 80 ns; RDRF <= '1'; wait for 240ns;

		-- Overrun Frame
		RxD <= '0'; -- Start Bit
		wait for 80ns;
		-- 01010101
		RxD <= '1'; wait for 80ns; -- LSB
		RxD <= '1'; wait for 80ns;
		RxD <= '1'; wait for 80ns;
		RxD <= '1'; wait for 80ns;
		RxD <= '1'; wait for 80ns;
		RxD <= '1'; wait for 80ns;
		RxD <= '1'; wait for 80ns;
		RxD <= '1'; wait for 80ns; -- MSB
		-- End bit
		RxD <= '1';  wait for 400ns; RDRF <= '0'; wait for 240ns;


		-- Bad Framing
		RxD <= '0'; -- Start Bit
		wait for 80ns;
		-- 01010111
		RxD <= '1'; wait for 80ns; -- LSB
		RxD <= '1'; wait for 80ns;
		RxD <= '1'; wait for 80ns;
		RxD <= '0'; wait for 80ns;
		RxD <= '1'; wait for 80ns;
		RxD <= '0'; wait for 80ns;
		RxD <= '1'; wait for 80ns;
		RxD <= '0'; wait for 80ns; -- MSB
		-- End bit
		RxD <= '0'; wait for 240ns;
	end process stimulus;
end architecture rx_tb;


ARCHITECTURE int_tb of tb is
SIGNAL CLK, RST, UART_SEL: STD_LOGIC := '0';
SIGNAL RX_SET_FE, RX_CLR_FE, RX_SET_OE, RX_CLR_OE, RX_SET_RDRF, RX_CLR_RDRF: STD_LOGIC := '0';
SIGNAL TX_SET_TDRE, TX_CLR_TDRE: STD_LOGIC := '0';
SIGNAL RIE, TIE: STD_LOGIC := '0';
SIGNAL IRQ:  STD_LOGIC;
SIGNAL SCSR: STD_LOGIC_VECTOR(7 downto 0);
BEGIN
	--dut: entity work.uart_int port map(CLK, RST, RX_SET_FE, RX_CLR_FE, RX_SET_OE, RX_CLR_OE, RX_SET_RDRF, RX_CLR_RDRF, TX_SET_TDRE, TX_CLR_TDRE, RIE, TIE, IRQ, SCSR, "00", '0', UART_SEL);

	clock: clk <= '1' after 50ns when clk = '0' else
			      '0' after 50ns when clk = '1';

	stimulus: process is
	BEGIN
		wait for 50ns;
		rst <= '1';
		wait for 50ns;

		 RX_SET_FE <= '1';  wait for 100ns; RX_SET_FE <= '0';
		 RX_SET_OE <= '1';  wait for 100ns; RX_SET_OE <= '0';
		 RX_SET_RDRF <= '1';wait for 100ns; RX_SET_RDRF <= '0';
		 TX_SET_TDRE <= '1';wait for 100ns; TX_SET_TDRE <= '0';

		 RX_CLR_FE <= '1';  wait for 100ns; RX_CLR_FE <= '0';
		 RX_CLR_OE <= '1';  wait for 100ns; RX_CLR_OE <= '0';
		 RX_CLR_RDRF <= '1';wait for 100ns; RX_CLR_RDRF <= '0';
		 TX_CLR_TDRE <= '1';wait for 100ns; TX_CLR_TDRE <= '0';

		 wait for 100ns;
		 RIE <= '1'; TIE <='0';
		 RX_SET_FE <= '1';  wait for 100ns; RX_SET_FE <= '0';
		 RX_SET_OE <= '1';  wait for 100ns; RX_SET_OE <= '0';
		 RX_SET_RDRF <= '1';wait for 100ns; RX_SET_RDRF <= '0';
		 TX_SET_TDRE <= '1';wait for 100ns; TX_SET_TDRE <= '0';

		 RX_CLR_FE <= '1';  wait for 100ns; RX_CLR_FE <= '0';
		 RX_CLR_OE <= '1';  wait for 100ns; RX_CLR_OE <= '0';
		 RX_CLR_RDRF <= '1';wait for 100ns; RX_CLR_RDRF <= '0';
		 TX_CLR_TDRE <= '1';wait for 100ns; TX_CLR_TDRE <= '0';

		 wait for 100ns;
		 RIE <= '0'; TIE <= '1';
		 RX_SET_FE <= '1';  wait for 100ns; RX_SET_FE <= '0';
		 RX_SET_OE <= '1';  wait for 100ns; RX_SET_OE <= '0';
		 RX_SET_RDRF <= '1';wait for 100ns; RX_SET_RDRF <= '0';
		 TX_SET_TDRE <= '1';wait for 100ns; TX_SET_TDRE <= '0';

		 RX_CLR_FE <= '1';  wait for 100ns; RX_CLR_FE <= '0';
		 RX_CLR_OE <= '1';  wait for 100ns; RX_CLR_OE <= '0';
		 RX_CLR_RDRF <= '1';wait for 100ns; RX_CLR_RDRF <= '0';
		 TX_CLR_TDRE <= '1';wait for 100ns; TX_CLR_TDRE <= '0';

	END PROCESS stimulus;
END ARCHITECTURE int_tb;


architecture tx_tb of tb is
signal clk, rst, bclk: STD_LOGIC := '0';
signal TxD: STD_LOGIC;
signal TDR: STD_LOGIC_VECTOR (7 downto 0) := "00000000";
signal LD_TDR, TDRE: STD_LOGIC := '1';
signal SET_TDRE: STD_LOGIC;
BEGIN
	dut: entity work.uart_tx port map (clk, rst, TxD, TDR, LD_TDR, TDRE, SET_TDRE, BCLK);


	clock: clk <= '1' after 25ns when clk = '0' else
			      '0' after 25ns when clk = '1';

	Baud_clock: bclk <= '1' after 100ns when bclk = '0' else
			            '0' after 100ns when bclk = '1';

	stimulus: process is
	BEGIN
		wait for 50 ns;
		RST <= '1';
		wait for 50 ns;
		LD_TDR <= '1';
		TDR <= "01010101";

		wait for 100ns;
		TDRE <= '0';
		LD_TDR <= '0';

		wait for 100ns;
		TDRE <= '1';

		wait for 1000ns;
	end process stimulus;
end architecture tx_tb;

architecture rxtx_test of tb is
SIGNAL 	clk, rst, UART_SEL: STD_LOGIC := '0';
SIGNAL	RxD: STD_LOGIC;
SIGNAL	TxD: STD_LOGIC;
SIGNAL	Data_Bus: STD_LOGIC_VECTOR (7 downto 0):= "00000000";
SIGNAL	addr: STD_LOGIC_VECTOR (1 downto 0) := "00";
SIGNAL	R_WBar: STD_LOGIC := '0';
SIGNAL	IRQ: STD_LOGIC;

BEGIN
	dut: entity work.uart_top port map (clk, rst, RxD, TxD, Data_Bus, addr, R_WBar, UART_SEL, IRQ);

	clock: clk <= '1' after 20ns when clk = '0' else
			      '0' after 20ns when clk = '1';

	RxD <= TxD;

    stimulus: process is
    BEGIN
    	wait for 20ns;
    	rst <= '1';

    	wait for 60ns;
    	UART_SEL <= '1';
    	addr <= "10";
    	R_WBar <= '0';
    	Data_Bus <= "11000000";
    	wait for 40ns;

    	addr <= "00";
    	R_WBar <= '0';
    	Data_Bus <= "00011000";

    	wait for 40ns;
    	UART_SEL <= '0';
    	R_WBar <= '1';

    	wait for 1000ns;
    	UART_SEL <= '1';
    	addr <= "00";
    	R_WBar <= '0';
    	Data_Bus <= "11010111";
    	wait for 40ns;
    	UART_SEL <= '0';
    	R_WBar <= '1';

    	wait for 1000000ns;
    end process;
end architecture rxtx_test;

architecture ctrl_test of tb is 
SIGNAL CLK, RST:STD_LOGIC := '0';
SIGNAL IRQ:STD_LOGIC;
SIGNAL TRAFFIC_STATE:STD_LOGIC_VECTOR (1 downto 0) :=  "00";
SIGNAL DATA_BUS: STD_LOGIC_VECTOR (7 downto 0) := x"00";
SIGNAL ADDR: STD_LOGIC_VECTOR(1 downto 0);
SIGNAL R_WBar, UART_SEL: STD_LOGIC;
BEGIN
	dut: entity work.ctrl PORT map (CLK, RST, IRQ, TRAFFIC_STATE, DATA_BUS, ADDR, R_WBar, UART_SEL);

	clock: clk <= '1' after 20ns when clk = '0' else
			      '0' after 20ns when clk = '1';

	stimulus: process is
	BEGIN
		wait for 20ns;
		rst <= '1';

		wait for 60ns;

		IRQ <= '1';

		wait for 800ns;

		TRAFFIC_STATE <= "01";
		wait for 800ns;

		TRAFFIC_STATE <= "10";
		wait for 800ns;

		TRAFFIC_STATE <= "11";
		wait for 800ns;

		TRAFFIC_STATE <= "00";
		wait for 800ns;

	end process;
end ARCHITECTURE ctrl_test;

architecture uart_ctrl_test of tb is 
SIGNAL CLK, RST:STD_LOGIC := '0';
SIGNAL IRQ:STD_LOGIC;
SIGNAL TRAFFIC_STATE:STD_LOGIC_VECTOR (1 downto 0) :=  "00";
SIGNAL DATA_BUS: STD_LOGIC_VECTOR (7 downto 0) := x"00";
SIGNAL ADDR: STD_LOGIC_VECTOR(1 downto 0);
SIGNAL R_WBar, UART_SEL: STD_LOGIC;
SIGNAL	RxD: STD_LOGIC;
SIGNAL	TxD: STD_LOGIC;
BEGIN
	ctrl_dut:  entity work.ctrl PORT map (CLK, RST, IRQ, TRAFFIC_STATE, DATA_BUS, ADDR, R_WBar, UART_SEL);

	uart_dut:  entity work.uart_top port map (clk, rst, RxD, TxD, Data_Bus, addr, R_WBar, UART_SEL, IRQ);

	RxD <= TxD;

	clock: clk <= '1' after 20ns when clk = '0' else
			      '0' after 20ns when clk = '1';

	stimulus: process is
	BEGIN
		wait for 20ns;
		rst <= '1';

		wait for 1000000ns;
	end process;

end architecture uart_ctrl_test;

architecture whole_test of tb is        
signal GReset,  GClock, tlc_clk: STD_LOGIC := '0';
signal MSC, SSC: STD_LOGIC_VECTOR(3 downto 0) := "0011";
signal SSCS: STD_LOGIC := '0';
signal MSTL, SSTL: STD_LOGIC_VECTOR (2 downto 0);
signal BCD1, BCD2: STD_LOGIC_VECTOR (3 downto 0);
signal RxD: STD_LOGIC;
signal TxD: STD_LOGIC;
BEGIN
	dut: entity work.traffic_light_w_uart port map(GReset,  GClock, tlc_clk, MSC, SSC,SSCS, MSTL, SSTL, BCD1, BCD2, RxD, TxD);

	RxD <= TxD;


	clock: GClock <= '1' after 10ns when GClock = '0' else
			         '0' after 10ns when Gclock = '1';

	clock2: tlc_clk	<= '1' after 1ms when tlc_clk = '0' else 
	                   '0' after 1ms when tlc_clk = '1';
    stimulus: process is 
	BEGIN
		wait for 10ns;
		GReset <= '1';

		wait for 2000000ns;

		SSCS <= '1';
	end process;

end architecture whole_test;