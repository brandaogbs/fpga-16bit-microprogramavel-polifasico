LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY CLOCK_DIV is
	PORT(CLK_IN, RST				: IN STD_LOGIC;
		  CLK_OUT					: OUT STD_LOGIC);
END CLOCK_DIV;


ARCHITECTURE BEHAVIOR OF CLOCK_DIV IS	 

	SIGNAL SLOW_COUNT: STD_LOGIC_VECTOR(27 DOWNTO 0);

	BEGIN

	PROCESS(CLK_IN, RST)
				BEGIN
				
					IF(RST = '0') THEN
						SLOW_COUNT <= x"0000000";
	
					ELSIF (RISING_EDGE(CLK_IN)) THEN
	
						SLOW_COUNT <= SLOW_COUNT + 1;
					
					END IF;
	END PROCESS;
	
	CLK_OUT <= SLOW_COUNT(26);
	
END BEHAVIOR;