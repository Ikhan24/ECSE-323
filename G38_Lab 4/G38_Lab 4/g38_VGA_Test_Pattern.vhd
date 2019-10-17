LIBRARY ieee;
LIBRARY lpm;
USE ieee.std_logic_1164.all;
USE lpm.lpm_components.all;
use ieee.numeric_std.all;

entity g38_VGA_TEST_PATTERN is 
port ( clock1    : in std_logic; -- 50MHz 
		 rst1 : in std_logic; -- reset 
       R, G, B  : out std_logic_vector(3 downto 0); -- colors 
		 level_T : std_logic_vector(2 downto 0);
		 life_T : std_logic_vector(2 downto 0);
       HSYNC1    : out std_logic; -- horizontal sync signal
       VSYNC1   : out std_logic
		 ); -- vertical sync signal 
end g38_VGA_TEST_PATTERN;

architecture A4 of g38_VGA_TEST_PATTERN is 
 
signal BLANKING1 :  std_logic;

signal ascii_T : std_logic_vector(6 downto 0);
signal text_col_T : unsigned(5 downto 0);
signal text_row_T : unsigned(4 downto 0);
signal font_row_T : std_logic_vector(3 downto 0); -- 0-15 row address in single character
signal font_col_T : std_logic_vector(2 downto 0); -- 0-7 column address in single character
signal row_T : unsigned(9 downto 0);
signal column_T : unsigned(9 downto 0);
signal R_T, G_T, B_T  : std_logic_vector(3 downto 0);
signal score_T : std_logic_vector(15 downto 0);
signal font_bit_T : std_logic;
signal clkA_T: std_logic;
signal count1 : std_logic_vector(15 downto 0);
signal clear1 : std_logic;
signal count2 : std_logic_vector(15 downto 0);
signal clear2 : std_logic;
signal count3 : std_logic_vector(15 downto 0);
signal enableLine : std_logic;
signal rst : std_logic;
 
component g38_VGA 
	port(	clock : in std_logic; -- 50MHz
			rst : in std_logic; -- reset
			BLANKING : out std_logic; -- blank display when zero
			ROW : out unsigned(9 downto 0); -- line 0 to 599
			COLUMN : out unsigned(9 downto 0); -- column 0 to 799
			HSYNC : out std_logic; -- horizontal sync signal
			VSYNC : out std_logic);
end component;

component g38_Text_Generator 
	port(text_row : in unsigned(4 downto 0);
	  text_col : in unsigned(5 downto 0);
	  score : in std_logic_vector(15 downto 0);
	  level : in std_logic_vector(2 downto 0);
	  life : in std_logic_vector(2 downto 0);
	  R, G, B  : out std_logic_vector(3 downto 0);
	  ASCII : out std_logic_vector(6 downto 0));
end component; 

component fontROM 
	generic(
		addrWidth: integer := 11;
		dataWidth: integer := 8
	);
	port(
		clkA: in std_logic;
		char_code : in std_logic_vector(6 downto 0); -- 7-bit ASCII character code
		font_row : in std_logic_vector(3 downto 0); -- 0-15 row address in single character
		font_col : in std_logic_vector(2 downto 0); -- 0-7 column address in single character
		font_bit : out std_logic -- pixel value at the given row and column for the selected character code
	);
end component; 

component g38_Text_Address_Generator 
	port ( ROW : in unsigned(9 downto 0); -- line 0 to 599
		 COLUMN : in unsigned(9 downto 0); -- column 0 to 799
		 text_row : out unsigned(4 downto 0);
		 text_col : out unsigned(5 downto 0);
		 font_row : out std_logic_vector(3 downto 0);
		 font_col : out std_logic_vector(2 downto 0)
		);
end component; 

begin 
VGA : g38_VGA port map(clock=>clock1,rst=>rst1, BLANKING=>BLANKING1, ROW=>row_T, COLUMN=>column_T,HSYNC=>HSYNC1,VSYNC=>VSYNC1);
Text_Address : g38_Text_Address_Generator port map (ROW=>row_T, COLUMN=>column_T, font_row=>font_row_T, font_col=>font_col_T,text_row=>text_row_T,text_col=>text_col_T);
Text_Generator : g38_Text_Generator port map(text_col=>text_col_T,text_row=>text_row_T,ASCII=>ascii_T,R=>R_T,G=>G_T,B=>B_T,score=>score_T,level=>level_T,life=>life_T);

ROM : fontROM port map(clkA=>clock1,font_col=>font_col_T,font_row=>font_row_T,char_code=>ascii_T,font_bit=>font_bit_T); 

counter1: lpm_counter
	generic map(LPM_WIDTH =>16)
	port map(clock => clock1, sclr => clear1, q => count1);
	with count1 select 
	enableLine <= '1' when "1111111111111111",
					  '0' when others;
	clear1 <='1' when count1 = "1111111111111111" or rst = '1' else
				'0';
				 
	
			 
	
	counter2: lpm_counter
	generic map(LPM_WIDTH => 16)
	port map(clock => clock1, sclr => clear2, q=>count2, cnt_en => enableLine);
		clear2 <='1' when count2 = "1111111111111111" or rst = '1' else
				 '0';
				 

				
	A : process(clock1)
	begin
	
	if (font_bit_T = '1')then 
	R<= R_T;
	G<= G_T;
	B<= B_T;
	score_T <= count2;
	else 
		score_T <= count2;
		R<="0000";
		G<="0000";
		B<="0000";
	end if;
	end process; 



end A4;