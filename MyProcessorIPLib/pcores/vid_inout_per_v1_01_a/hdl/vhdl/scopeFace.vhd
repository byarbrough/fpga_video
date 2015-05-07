--------------------------------------------------------------------
-- Name:	Brian Yarbrough
-- Date:	13 Jan 15
-- File:	scopeFace.vhd
-- Lab 01
--	Crs:	ECE 383
--
-- Purp: controls RGB values, based on screen position
--			
-- Documentation:	None
--
-- Academic Integrity Statement: I certify that, while others may have 
-- assisted me in brain storming, debugging and validating this program, 
-- the program itself is my own work. I understand that submitting code 
-- which is the work of other individuals is a violation of the honor   
-- code.  I also understand that if I knowingly give my original work to 
-- another individual is also a violation of the honor code. 
-------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity scopeFace is
    Port ( row : in  unsigned (9 downto 0);
           column : in  unsigned (9 downto 0);
           r : out  STD_LOGIC_VECTOR (7 downto 0);
           g : out  STD_LOGIC_VECTOR (7 downto 0);
           b : out  STD_LOGIC_VECTOR (7 downto 0));
end scopeFace;

architecture Behavioral of scopeFace is

type color_type is (white, black, red, green, blue, yellow, magenta, cyan);
signal pixcol: color_type;

begin
	
	pixcol <= 
				red when row < 160 else
				blue when row > 230 else
				green;
			
			
		--assign color values
		process (column)
		begin
			case pixcol is
				when white =>
					r <= "11111111";
					g <= "11111111";
					b <= "11111111";
				when black =>
					r <= "00000000";
					g <= "00000000";
					b <= "00000000";
				when red =>
					r <= "11111111";
					g <= "00000000";
					b <= "00000000";
				when green =>
					r <= "00000000";
					g <= "11111111";
					b <= "00000000";
				when blue =>
					r <= "00000000";
					g <= "00000000";
					b <= "11111111";
				when yellow =>
					r <= "11111111";
					g <= "11111111";
					b <= "00000000";
				when magenta =>
					r <= "11111111";
					g <= "00000000";
					b <= "11111111";
				when cyan =>
					r <= "00000000";
					g <= "11111111";
					b <= "11111111";
				when others =>
					r <= "00000000";
					g <= "00000000";
					b <= "00000000";
			end case;
		end process;
	
end Behavioral;

