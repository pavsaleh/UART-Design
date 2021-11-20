LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------------------------------
-- Address Decoding Table
-- ADDR[1:0] | R/Wbar | Action
--   00      |   0    | DATA_BUS <- RDR
--   00      |   1    | TDR <- DATA_BUS
--   01      |   0    | DATA_BUS <- SCSR
--   01      |   1    | DATA_BUS <- Z
--   1d      |   0    | DATA_BUS <- SCCR
--   1d      |   1    | SCCR <- DATA_BUS
--------------------------------------------------------------------------------

ENTITY uart_bus_decoder IS
  PORT (ADDR: IN STD_LOGIC_VECTOR (1 downto 0);
  		R: IN STD_LOGIC;
  		UART_SEL: IN STD_LOGIC;
  		DATA_BUS: INOUT STD_LOGIC_VECTOR (7 downto 0);
  	    LD_TDR, LD_SCCR, RD_RDR: OUT STD_LOGIC;
  	    DATA_OUT: OUT STD_LOGIC_VECTOR(7 downto 0);
  	    DATA_IN_SCCR, DATA_IN_RDR, DATA_IN_SCSR: IN STD_LOGIC_VECTOR (7 downto 0));
END uart_bus_decoder;

ARCHITECTURE struct of uart_bus_decoder IS
SIGNAL LD_SCCR2, LD_SCCR3: STD_LOGIC;
SIGNAL OUT_TMP: STD_LOGIC_VECTOR (7 downto 0);
SIGNAL WRITE, READ: STD_LOGIC;
BEGIN
	WRITE <= not R and UART_SEL;
	READ  <= R and UART_SEL;
	in_decoder: ENTITY work.decoder24 port map (EN => WRITE,
	                                             A => ADDR,
	                                             Y0 => LD_TDR,
	                                             Y2 => LD_SCCR2,
	                                             Y3 => LD_SCCR3);
	LD_SCCR <= LD_SCCR2 or LD_SCCR3;
	in_tristate: ENTITY work.tristate_buffer generic map(N => 8)
	                                            port map(EN => WRITE,
	                                                     X => DATA_BUS,
	                                                     Y => DATA_OUT);
	                                            

	out_mux: ENTITY work.mux41 GENERIC MAP (N => 8)
								  PORT MAP (I0 => DATA_IN_RDR,
								  		    I1 => DATA_IN_SCSR,
								  		    I2 => DATA_IN_SCCR,
								  		    I3 => DATA_IN_SCCR,
								  		    S1 => ADDR(1),
								  		    S0 => ADDR(0),
								  		    Y => OUT_TMP);

	out_tristate: ENTITY work.tristate_buffer GENERIC MAP (N => 8)
												 PORT MAP (EN => READ,
												 	       X => OUT_TMP,
												 	       Y => DATA_BUS);

	RD_RDR <= READ and not ADDR(0) and not ADDR(1);
END ARCHITECTURE struct;
