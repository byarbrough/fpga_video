----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

use work.dviPass_parts.all;	



entity video is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           tmds : out  STD_LOGIC_VECTOR (3 downto 0);
           tmdsb : out  STD_LOGIC_VECTOR (3 downto 0);
			  hsync_in : in std_logic;
			  vsync_in : in std_logic;
			  hsync_out : out std_logic;
			  vsync_out : out std_logic;
			  row: out unsigned(9 downto 0);
			  column: out unsigned(9 downto 0);
			  ext_RGB : in std_logic_vector(23 downto 0);
			  mode	: in std_logic);
end video;



architecture structure of video is



	signal red, green, blue: STD_LOGIC_VECTOR(7 downto 0);
	signal pixel_clk, serialize_clk, serialize_clk_n, blank, hsync_vga, vsync_vga, hsync_dvi, vsync_dvi: STD_LOGIC;
	signal n_reset, clock_s, red_s, green_s, blue_s: STD_LOGIC;


begin

	--addition for lab 3
	--v_synch_sw <= not v_sync;
	
	--mux for select
	hsync_dvi <= hsync_in when mode = '1' else hsync_vga;
	vsync_dvi <= vsync_in when mode = '1' else vsync_vga;
	hsync_out <= hsync_vga;
	vsync_out <= vsync_vga;
	
	------------------------------------------------------------------------------
	-- The reset for the digital clock manager is active high (see page 7) here:
	-- http://www.xilinx.com/support/documentation/application_notes/xapp462.pdf
	-- However, the logical choice for a reset on the Digilent Atlys board is the 
	-- red button labeledl "RESET" connected to pin T15, is nominally logic 1 and 
	-- pulled logic 0 when is pressed. 	Hence, we need to invert the reset.
	------------------------------------------------------------------------------
	n_reset <= not reset;

	------------------------------------------------------------------------------
	-- The digital clock manager is a built-in function on the Spartan 6 chip.
	-- Consequently you will need to include UNISIM.VComponents.all; at the top.
	-- This clock divider creates a 12.5Mhz pixel clock from 100MHz clock. 
	------------------------------------------------------------------------------
	inst_DCM_pixel: DCM
	generic map(	CLKFX_MULTIPLY => 2,
						CLKFX_DIVIDE   => 8,
						CLK_FEEDBACK   => "1X")
	port map(		clkin => clk,
						rst   => n_reset,
						clkfx => pixel_clk,
						clkfx180 => open);

	------------------------------------------------------------------------------
	-- This clock divider creates HDMI serial output clock
	------------------------------------------------------------------------------
    inst_DCM_serialize: DCM
    generic map(	CLKFX_MULTIPLY => 10, -- 5x speed of pixel clock
						CLKFX_DIVIDE   => 8,
						CLK_FEEDBACK   => "1X")
    port map(		clkin => clk,
						rst   => n_reset,
						clkfx => serialize_clk,
						clkfx180 => serialize_clk_n);

	------------------------------------------------------------------------------
	-- H and V synch are used to interface to the DVID module
	------------------------------------------------------------------------------
	Inst_vga: vga
		PORT MAP(	clk => pixel_clk,
						reset => reset,
						h_sync => hsync_vga,
						v_sync => vsync_vga,
						blank => blank,
						r => red,
						g => green,
						b => blue,
						row => row,
						column => column,
						ext_RGB => ext_RGB,
						mode => mode
					);
					
	------------------------------------------------------------------------------
	-- This module was provided to us free of charge.  It converts a VGA signal
	-- into DVID/HDMI signal.
	------------------------------------------------------------------------------	 
    Inst_dvid: dvid 
		port map(	clk       => serialize_clk,
						clk_n     => serialize_clk_n, 
						clk_pixel => pixel_clk,
						red_p     => red,
						green_p   => green,
						blue_p    => blue,
						blank     => blank,
						hsync     => hsync_dvi,
						vsync     => vsync_dvi,
						red_s     => red_s,
						green_s   => green_s,
						blue_s    => blue_s,
						clock_s   => clock_s
					);

	------------------------------------------------------------------------------
	-- This HDMI signals are high speed so buffer to insure signal integrity.
	------------------------------------------------------------------------------
	OBUFDS_blue  : OBUFDS port map
        ( O  => TMDS(0), OB => TMDSB(0), I  => blue_s  );
	OBUFDS_red   : OBUFDS port map
        ( O  => TMDS(1), OB => TMDSB(1), I  => green_s );
	OBUFDS_green : OBUFDS port map
        ( O  => TMDS(2), OB => TMDSB(2), I  => red_s   );
	OBUFDS_clock : OBUFDS port map
        ( O  => TMDS(3), OB => TMDSB(3), I  => clock_s );

end structure;