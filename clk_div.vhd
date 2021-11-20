LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY single_freq_div IS
	PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_clk: IN	STD_LOGIC;
		o_clk2, o_clk2Bar	: OUT	STD_LOGIC);
END single_freq_div;

ARCHITECTURE struct of single_freq_div is
	SIGNAL clk_divBar: STD_LOGIC;
	BEGIN
  	ff: entity work.enARdFF_2 port map (i_resetBar => i_resetBar,
										i_d => clk_divBar,
										i_enable => '1',
										i_clock => i_clk,
										o_q => o_clk2,
										o_qBar => clk_divBar);
	  o_clk2Bar <= clk_divBar;
	END ARCHITECTURE struct;

------------------------------------
-- Divide i_clock up to 8 times
-- o_clkdiv(0): f/2
-- o_clkdiv(1): f/4
-- o_clkdiv(2): f/8
-- o_clkdiv(3): f/16
-- o_clkdiv(4): f/32
-- o_clkdiv(5): f/64
-- o_clkdiv(6): f/128
-- o_clkdiv(7): f/256
------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY freq_div IS
	PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_clk: IN	STD_LOGIC;
		o_clkdiv: OUT	STD_LOGIC_VECTOR (7 downto 0));
END freq_div;

ARCHITECTURE struct of freq_div is
	SIGNAL clk_div_tmp: STD_LOGIC_VECTOR(7 downto 0);
	BEGIN
	c_div1: ENTITY work.single_freq_div port map (i_resetBar => i_resetBar,
												  i_clk => i_clk,
												  o_clk2 => o_clkdiv(0),
												  o_clk2Bar => clk_div_tmp(0));
	c_div: for i in 1 to 7 generate
	BEGIN
		c_divi: ENTITY work.single_freq_div port map (i_resetBar => i_resetBar,
													  i_clk => clk_div_tmp(i-1),
													  o_clk2 => o_clkdiv(i),
													  o_clk2Bar => clk_div_tmp(i));
	END generate c_div;
END ARCHITECTURE struct;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY freq_div8 IS
	PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_clk: IN	STD_LOGIC;
		o_clkdiv: OUT	STD_LOGIC);
END freq_div8;

ARCHITECTURE struct of freq_div8 is
SIGNAL clk_div_tmp2, clk_div_tmp4 : STD_LOGIC;
BEGIN
	c_div2: ENTITY work.single_freq_div port map (i_resetBar => i_resetBar,
												  i_clk => i_clk,
												  o_clk2Bar => clk_div_tmp2);

	c_div4: ENTITY work.single_freq_div port map (i_resetBar => i_resetBar,
												  i_clk => clk_div_tmp2,
												  o_clk2Bar => clk_div_tmp4);

	c_div8: ENTITY work.single_freq_div port map (i_resetBar => i_resetBar,
												  i_clk => clk_div_tmp4,
												  o_clk2 => o_clkdiv);
END ARCHITECTURE struct;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY freq_div41 IS
	PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_clk: IN	STD_LOGIC;
		o_clkdiv: OUT	STD_LOGIC);
END freq_div41;

ARCHITECTURE struct of freq_div41 is
SIGNAL clk_div_tmp: STD_LOGIC;
SIGNAL eq40: STD_LOGIC;
SIGNAL count: STD_LOGIC_VECTOR (5 downto 0);
BEGIN
	counter: entity work.nbit_counter generic map (N => 6)
										 port map (i_pLoadValue => (others => '0'),
										           i_load => eq40,
												   i_enable => '1',
										           i_clk => i_clk,
												   i_rst => i_resetBar,
												   o_value => count);
	eq40 <= count(5) and count(3);
	o_clkdiv <= eq40;
end architecture struct;

--------------------------------------------------------------------------------
-- Title         : Clock Divider Circuit
-- Project       : VHDL Example Programs
-------------------------------------------------------------------------------
-- File          : clk_div.vhd
-- Author        : Rami Abielmona  <rabielmo@site.uottawa.ca>
-- Created       : 2004/10/07
-- Last modified : 2007/09/26
-------------------------------------------------------------------------------
-- Description : This file creates a clock divider circuit using a behavioral approach.
--		 		 The code is extracted from "Rapid Prototyping Of Digital Systems"
--				 by James Hamblen et Michael Furman.
-------------------------------------------------------------------------------
-- Modification history :
-- 2004.10.07 	R. Abielmona		Creation
-- 2007.09.26 	R. Abielmona		Modified copyright notice
-------------------------------------------------------------------------------
-- This file is copyright material of Rami Abielmona, Ph.D., P.Eng., Chief Research
-- Scientist at Larus Technologies.  Permission to make digital or hard copies of part
-- or all of this work for personal or classroom use is granted without fee
-- provided that copies are not made or distributed for profit or commercial
-- advantage and that copies bear this notice and the full citation of this work.
-- Prior permission is required to copy, republish, redistribute or post this work.
-- This notice is adapted from the ACM copyright notice.
--------------------------------------------------------------------------------
library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY clk_div IS

	PORT
	(
		clock_25Mhz				: IN	STD_LOGIC;
		clock_1MHz				: OUT	STD_LOGIC;
		clock_100KHz				: OUT	STD_LOGIC;
		clock_10KHz				: OUT	STD_LOGIC;
		clock_1KHz				: OUT	STD_LOGIC;
		clock_100Hz				: OUT	STD_LOGIC;
		clock_10Hz				: OUT	STD_LOGIC;
		clock_1Hz				: OUT	STD_LOGIC);

END clk_div;

ARCHITECTURE a OF clk_div IS

	SIGNAL	count_1Mhz: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL	count_100Khz, count_10Khz, count_1Khz : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL	count_100hz, count_10hz, count_1hz : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL  clock_1Mhz_int, clock_100Khz_int, clock_10Khz_int, clock_1Khz_int: STD_LOGIC;
	SIGNAL	clock_100hz_int, clock_10Hz_int, clock_1Hz_int : STD_LOGIC;
BEGIN
	PROCESS
	BEGIN
-- Divide by 25
		WAIT UNTIL clock_25Mhz'EVENT and clock_25Mhz = '1';
			IF count_1Mhz < 24 THEN
				count_1Mhz <= count_1Mhz + 1;
			ELSE
				count_1Mhz <= "00000";
			END IF;
			IF count_1Mhz < 12 THEN
				clock_1Mhz_int <= '0';
			ELSE
				clock_1Mhz_int <= '1';
			END IF;

-- Ripple clocks are used in this code to save prescalar hardware
-- Sync all clock prescalar outputs back to master clock signal
			clock_1Mhz <= clock_1Mhz_int;
			clock_100Khz <= clock_100Khz_int;
			clock_10Khz <= clock_10Khz_int;
			clock_1Khz <= clock_1Khz_int;
			clock_100hz <= clock_100hz_int;
			clock_10hz <= clock_10hz_int;
			clock_1hz <= clock_1hz_int;
	END PROCESS;

-- Divide by 10
	PROCESS
	BEGIN
		WAIT UNTIL clock_1Mhz_int'EVENT and clock_1Mhz_int = '1';
			IF count_100Khz /= 4 THEN
				count_100Khz <= count_100Khz + 1;
			ELSE
				count_100khz <= "000";
				clock_100Khz_int <= NOT clock_100Khz_int;
			END IF;
	END PROCESS;

-- Divide by 10
	PROCESS
	BEGIN
		WAIT UNTIL clock_100Khz_int'EVENT and clock_100Khz_int = '1';
			IF count_10Khz /= 4 THEN
				count_10Khz <= count_10Khz + 1;
			ELSE
				count_10khz <= "000";
				clock_10Khz_int <= NOT clock_10Khz_int;
			END IF;
	END PROCESS;

-- Divide by 10
	PROCESS
	BEGIN
		WAIT UNTIL clock_10Khz_int'EVENT and clock_10Khz_int = '1';
			IF count_1Khz /= 4 THEN
				count_1Khz <= count_1Khz + 1;
			ELSE
				count_1khz <= "000";
				clock_1Khz_int <= NOT clock_1Khz_int;
			END IF;
	END PROCESS;

-- Divide by 10
	PROCESS
	BEGIN
		WAIT UNTIL clock_1Khz_int'EVENT and clock_1Khz_int = '1';
			IF count_100hz /= 4 THEN
				count_100hz <= count_100hz + 1;
			ELSE
				count_100hz <= "000";
				clock_100hz_int <= NOT clock_100hz_int;
			END IF;
	END PROCESS;

-- Divide by 10
	PROCESS
	BEGIN
		WAIT UNTIL clock_100hz_int'EVENT and clock_100hz_int = '1';
			IF count_10hz /= 4 THEN
				count_10hz <= count_10hz + 1;
			ELSE
				count_10hz <= "000";
				clock_10hz_int <= NOT clock_10hz_int;
			END IF;
	END PROCESS;

-- Divide by 10
	PROCESS
	BEGIN
		WAIT UNTIL clock_10hz_int'EVENT and clock_10hz_int = '1';
			IF count_1hz /= 4 THEN
				count_1hz <= count_1hz + 1;
			ELSE
				count_1hz <= "000";
				clock_1hz_int <= NOT clock_1hz_int;
			END IF;
	END PROCESS;

END a;
