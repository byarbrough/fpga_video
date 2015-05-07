----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:34:54 04/13/2015 
-- Design Name: 
-- Module Name:    dvi_pass - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

use work.dviPass_parts.all;	

entity dvi_pass is
	Port (
		-- from 383
		clk 			: in  STD_LOGIC;
		reset 		: in  STD_LOGIC;
		tmds 			: out  STD_LOGIC_VECTOR (3 downto 0);
		tmdsb 		: out  STD_LOGIC_VECTOR (3 downto 0);
		-- from hampster
		hdmi_clk_p 	: in  STD_LOGIC;
		hdmi_clk_n 	: in  STD_LOGIC;
		hdmi_c0_p  	: in  STD_LOGIC;
		hdmi_c0_n  	: in  STD_LOGIC;
		hdmi_c1_p  	: in  STD_LOGIC;
		hdmi_c1_n  	: in  STD_LOGIC;
		hdmi_c2_p  	: in  STD_LOGIC;
		hdmi_c2_n  	: in  STD_LOGIC;
		hdmi_sclk  	: in  STD_LOGIC;
		hdmi_sdat  	: in  STD_LOGIC;
		
		btn			: in  std_logic_vector(3 downto 0);
		led       	: out std_logic_vector(4 downto 0);
		switch		: in std_logic_vector(2 downto 0));
		
		
end dvi_pass;

architecture Behavioral of dvi_pass is

signal red_s, green_s, blue_s: STD_LOGIC_VECTOR(7 downto 0);
signal vsync_s, hsync_s, clk32 : std_logic;
signal rgb : std_logic_vector(23 downto 0);

begin



output_vid: video port map( 
		clk => clk,
		reset => reset,
		tmds => tmds,
		tmdsb => tmdsb,
		hsync_in	=> hsync_s,
		vsync_in => vsync_s,
		hsync_out => open,
		vsync_out => open,
		row => open, 
		column => open,
		ext_RGB => rgb,
		mode => switch(2)
	);
	
input_sig: dvi_in port map (
		clk      	=> clk,
		hdmi_clk_p 	=> hdmi_clk_p,
		hdmi_clk_n 	=> hdmi_clk_n,
		hdmi_c0_p  	=> hdmi_c0_p,
		hdmi_c0_n 	=> hdmi_c0_n,
		hdmi_c1_p  	=> hdmi_c1_p,
		hdmi_c1_n  	=> hdmi_c1_n,
		hdmi_c2_p 	=> hdmi_c2_p,
		hdmi_c2_n  	=> hdmi_c2_n,
		hdmi_sclk  	=> hdmi_sclk,
		hdmi_sdat  	=> hdmi_sdat,
					 
		red        => red_s,
		green      => green_s,
		blue       => blue_s,
		hsync      => hsync_s,
		vsync      => vsync_s,

		btn       => btn,
		led		 => led(3 downto 0)
	);
	
manipulate: manipulator port map(
		clk		=> clk,
		reset		=> reset,
      switch	=> switch,
		rin		=> red_s, 
		gin		=> green_s,
		bin		=> blue_s,
		rout		=> rgb(23 downto 16),
		gout		=> rgb(15 downto 8), 
		bout		=> rgb(7 downto 0)
	);
	
	
	led(4) <= clk32;


end Behavioral;

