--------------------------------------------------------------------
-- Name:	Brian Yarbrough
-- Date:	13 Jan 15
-- File:	vga.vhd
-- Lab 01
--	Crs:	ECE 383
--
-- Purp: controls for VGA protocol
--			
-- Documentation:	referenced Dr. Coulston's code. Resulted in:
--						1. Changing from instantiated timers to hardcoded
--						2. Use of h_complete signal
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

use work.dviPass_parts.all;	

entity vga is
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
end vga;


architecture Behavioral of vga is


	-- signal declarations
	signal v_count, h_count: unsigned (9 downto 0) := "0000000000";
	signal rs, gs, bs, rscope, gscope, bscope: STD_LOGIC_VECTOR (7 downto 0);
	signal line_roll, v_blank, h_blank, h_complete: std_logic;

	
begin

rs <= ext_RGB(23 downto 16) when mode = '1' else rscope;
gs <= ext_RGB(15 downto 8)	when mode = '1' else gscope;
bs <= ext_RGB(7 downto 0)	when mode = '1' else bscope;

-----------------------------------------------------------
-- Instance of scopeFace
------------------------------------------------------------
	Inst_scopeFace: scopeFace
		PORT MAP(row		=> v_count,
					column	=> h_count,
					r		=> rscope,
					g 		=> gscope,
					b		=>	bscope
				); 
					
-------------------------------------------------------------------
			
------------------------ Sync and Blank ---------------------------
---- columns ------------------------------------------------------
	process(clk)
	begin
		if(rising_edge(clk)) then
			if reset = '0' then
				h_sync <= '1';
				h_blank <= '0';
			elsif (h_count < 640) then --active video
				h_sync <= '1';
				h_blank	<=	'0';
			elsif (h_count > 639 and h_count < 656) then --front porch
				h_sync <= '1';
				h_blank <= '1';
			elsif (h_count > 655 and h_count < 752) then --sync
				h_sync <= '0';
				h_blank <= '1';
			elsif (h_count > 751) and (h_count < 800) then --back porch
				h_sync <= '1';
				h_blank <= '1';
			else
				h_sync <= '1';
				h_blank	<=	'0';
			end if;
		end if;
	end process;
	
---- rows --------------------------------------------------------
	process(clk)
	begin
		if(rising_edge(clk)) then	
			if reset = '0' then
				v_sync <= '1';
				v_blank <= '0';
			elsif (v_count < 480) then	--active video
				v_sync <= '1';
				v_blank <= '0';
			elsif (v_count > 479 and v_count < 490) then--front porch
				v_sync <= '1';
				v_blank <= '1';				
			elsif (v_count > 489 and v_count < 492) then --sync
				v_sync <= '0';
				v_blank <= '1';
			elsif (v_count > 491) and (v_count < 525) then --back porch
				v_sync <= '1';
				v_blank <= '1';
			else
				v_sync <= '1';
				v_blank <= '0';
			end if;
		end if;
	end process;

---- counters -------------------------------------------------
	
	process(clk) --rollover at 800 columns
	begin
		if(rising_edge(clk)) then
			if reset = '0' then
				h_count <= (others => '0');
			elsif h_count < 799 then
				h_count <= h_count + 1;
			else
				h_count <= (others => '0');
			end if;				
		end if;
	end process;
	
	process(clk)	--rollover at 525 rows
	begin
		if(rising_edge(clk)) then
			if reset = '0' then
				v_count <= (others => '0');
			elsif (v_count < 524) and (h_complete = '1') then
				v_count <= v_count + 1;
			elsif (v_count = 524) and (h_complete = '1') then
				v_count <= (others => '0');
			end if;
		end if;
	end process;
	
	h_complete <= '1' when (h_count = 799) else '0';
	
---- connect -------------------------------------------------
	
	--connect signals
	row <=	v_count;
	column <=	h_count;
	blank <= '1' when (h_blank = '1') or (v_blank = '1') else '0';
	
	--colors only on during active video
	r <= rs when h_blank = '0' and v_blank = '0' else "00000000";
	g <= gs when h_blank = '0' and v_blank = '0' else "00000000";
	b <= bs when h_blank = '0' and v_blank = '0' else "00000000";

end Behavioral;