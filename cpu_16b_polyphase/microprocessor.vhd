library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use IEEE.STD_LOGIC_SIGNED.ALL;
USE WORK.MICRO_PACK.ALL;

-------------------------------
ENTITY MICROPROCESSOR IS
	PORT(	CLK, RST														: in 	std_logic;
			CLK_LED						  								: out std_logic;
			display_segs1, display_segs2, display_segs3		: out std_logic_vector(6 downto 0);
			display_segs4, display_segs5, display_segs6		: out std_logic_vector(6 downto 0)
			);
END MICROPROCESSOR;
 
-------------------------------

 
ARCHITECTURE BEHAVIOR OF MICROPROCESSOR IS

-- SINAIS

	SIGNAL SLOW_CLOCK  					 : STD_LOGIC; 
	
	SIGNAL IR, PC, ACC					 :	STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	SIGNAL MPC								 :	STD_LOGIC_VECTOR(9 DOWNTO 0);
	
	SIGNAL NEXT_FASE, CURRENT_FASE	 :	TYPE_FASE;

	SIGNAL BUS_ULA1,BUS_ULA2,BUS_EXT3 :	STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	SIGNAL SC								 : std_logic_vector(24 downto 1);

BEGIN

	
					
-- COMPONENTS

-- divisor de clock
		CLK_1						: CLOCK_DIV PORT MAP (CLK, RST, SLOW_CLOCK);
		
		
-- controlador micro
--		CONTROLADOR_MICRO_1	: CONTROLADOR_MICRO PORT MAP (CURRENT_FASE, IR, ACC, MPC, SC);
		

-- display 7 segmentos
		DISPLAY_SEGS_1			: DISPLAY_SEGS PORT MAP (CURRENT_FASE, PC, MPC, BUS_ULA1, BUS_ULA2, BUS_EXT3,
																	 display_segs1, display_segs2, display_segs3,
																	 display_segs4, display_segs5, display_segs6);
 
 		
-- controlador principal
		CONTROLADOR_PRIN_1	: CONTROLADOR_PRIN PORT MAP(clk, NEXT_FASE,RST, SLOW_CLOCK,
									  CURRENT_FASE,PC,BUS_ULA1,BUS_ULA2,BUS_EXT3,MPC,SC);
	


-- 	Process para trocar as fase do microprogramado
fase_change:
		process (current_fase, sc)	

		begin
			-- caso seja loop interno do microporograma
			
			
			
				
					case current_fase is		
					
					when f_reset=>	next_fase <= f_1;
				
					when f_1  	=>	next_fase <= f_2;
		
					when f_2  	=>	next_fase <= f_3;
					
					when f_3  	=>	next_fase <= f_4;
					
					when f_4  	=>	next_fase <= f_5;
					
					when f_5  	=>	
									
									if(SC(24) = '1') then
										next_fase <= f_4;
									else
										next_fase <= f_1;
									end if;
				end case;
			

		end process;


----------------------------------  						
END BEHAVIOR;   