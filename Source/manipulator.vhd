----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:18:42 04/27/2015 
-- Design Name: 
-- Module Name:    manipulator - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity manipulator is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           switch : in  STD_LOGIC_VECTOR (2 downto 0);
           rin, gin, bin : in std_logic_vector( 7 downto 0);
           rout, gout, bout : out std_logic_vector( 7 downto 0));
end manipulator;

architecture Behavioral of manipulator is

signal grayscale : unsigned(15 downto 0);
signal r2, g2, b2 : unsigned(15 downto 0);

begin

---------------------------------------
-- swtich2	switch1	switch0	effect
--		0			x			x			disengaged
-- 	1			0			0			throughput
--		1			0			1			grayscalce
--		1			1			0			inverse color
--		1			1			1			mono color
--------------------------------------------
process (clk)
begin
	if rising_edge(clk) then
		if switch = "100" then
			rout <= rin;
			gout <= gin;
			bout <= bin;
		elsif switch = "101" then --grayscale
			r2 <= unsigned(rin) * unsigned(rin);
			g2 <= unsigned(gin) * unsigned(bin);
			b2 <= unsigned(gin) * unsigned(bin);
			grayscale <= r2 + g2 + b2;
			rout <= std_logic_vector(grayscale(15 downto 8) ror 3);
			gout <= std_logic_vector(grayscale(15 downto 8) ror 3);
			bout <= std_logic_vector(grayscale(15 downto 8) ror 3);
		elsif switch = "110" then --inverse color
			rout <= not rin;
			gout <= not gin;
			bout <= not bin;
		elsif switch = "111" then -- mono color
			if rin(7) = '1' and gin(7) = '1' then
				rout <= "11111111";
				gout <= "11111111";
				bout <= "11111111";
			elsif rin(7) = '1' and bin(7) = '1' then
				rout <= "11111111";
				gout <= "11111111";
				bout <= "11111111";
			elsif gin(7) = '1' and bin(7) = '1' then
				rout <= "11111111";
				gout <= "11111111";
				bout <= "11111111";
			else
				rout <= "00000000";
				gout <= "00000000";
				bout <= "00000000";
			end if;
		end if;
	end if;
end process;

end Behavioral;

