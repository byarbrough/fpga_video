--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.ALL;

package dviPass_parts is	

-------------- input ----------------
component video is
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
	end component;
	
component vga is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           h_sync : out  STD_LOGIC;
           v_sync : out  STD_LOGIC;
           blank : out  STD_LOGIC;
           r : out  STD_LOGIC_VECTOR (7 downto 0);
           g : out  STD_LOGIC_VECTOR (7 downto 0);
           b : out  STD_LOGIC_VECTOR (7 downto 0);
			  ext_RGB : in std_logic_vector(23 downto 0);
			  mode : in std_logic;
           row : out  unsigned (9 downto 0);
           column : out  unsigned (9 downto 0));
			  
end component;

component scopeFace is
    Port ( row : in  unsigned (9 downto 0);
           column : in  unsigned (9 downto 0);
           r : out  STD_LOGIC_VECTOR (7 downto 0);
           g : out  STD_LOGIC_VECTOR (7 downto 0);
           b : out  STD_LOGIC_VECTOR (7 downto 0));
end component;

	component dvid is
		Port ( clk       : in  STD_LOGIC;
           clk_n     : in  STD_LOGIC;
           clk_pixel : in  STD_LOGIC;
           red_p     : in  STD_LOGIC_VECTOR (7 downto 0);
           green_p   : in  STD_LOGIC_VECTOR (7 downto 0);
           blue_p    : in  STD_LOGIC_VECTOR (7 downto 0);
           blank     : in  STD_LOGIC;
           hsync     : in  STD_LOGIC;
           vsync     : in  STD_LOGIC;
           red_s     : out STD_LOGIC;
           green_s   : out STD_LOGIC;
           blue_s    : out STD_LOGIC;
           clock_s   : out STD_LOGIC);
	end component;

----------- output -------------

component dvi_in is
    Port ( clk      : in  STD_LOGIC;
           hdmi_clk_p : in  STD_LOGIC;
           hdmi_clk_n : in  STD_LOGIC;
           hdmi_c0_p  : in  STD_LOGIC;
           hdmi_c0_n  : in  STD_LOGIC;
           hdmi_c1_p  : in  STD_LOGIC;
           hdmi_c1_n  : in  STD_LOGIC;
           hdmi_c2_p  : in  STD_LOGIC;
           hdmi_c2_n  : in  STD_LOGIC;
           hdmi_sclk  : in  STD_LOGIC; -- originally inout
           hdmi_sdat  : in  STD_LOGIC; -- originally inout
                      
           red        : out std_logic_vector(7 downto 0); --2 downto 0
           green      : out std_logic_vector(7 downto 0); -- 2 downto 0
           blue       : out std_logic_vector(7 downto 0); -- 1 downto 0
           hsync      : out std_logic;
           vsync      : out std_logic
		  );
end component;


end dviPass_parts;