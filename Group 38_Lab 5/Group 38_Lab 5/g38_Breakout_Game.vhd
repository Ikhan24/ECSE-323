-- Group 38
-- Authors: Tamim Sujat, Intesar Khan 
-- File: Breakout Game Circuit

LIBRARY ieee;
USE ieee.std_logic_1164.all;
LIBRARY lpm;
USE lpm.lpm_components.all;
use ieee.numeric_std.all;

entity g38_Breakout_Game is 
port ( clock1    : in std_logic; 
		 rst1 : in std_logic; 
		 rst_Center : in std_logic;
       R, G, B  : out std_logic_vector(3 downto 0);
		 Paddle1_left : in std_logic;
		 Paddle1_right : in std_logic;
		 life: std_logic_vector(2 downto 0);
       HSYNC1    : out std_logic; 
       VSYNC1   : out std_logic
		); 
end g38_Breakout_Game ;

architecture A5 of g38_Breakout_Game  is 

signal BLANKING1 :  std_logic;

signal ascii_T : std_logic_vector(6 downto 0);
signal text_col_T : unsigned(5 downto 0);
signal text_row_T : unsigned(4 downto 0);
signal font_row_T : std_logic_vector(3 downto 0); 
signal font_col_T : std_logic_vector(2 downto 0); 
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
signal count3 : std_logic_vector(2 downto 0);   
signal clear3 : std_logic;
signal clear_Ball : std_logic;
signal enableLine : std_logic;
signal enableLine1 : std_logic;
signal rst : std_logic;
signal BallRowF : std_logic;
signal BallColF : std_logic;
signal ball_row : std_logic_vector(9 downto 0);
signal ball_col : std_logic_vector(9 downto 0);
signal temp_row : integer range 0 to 20; 
signal blocks : std_logic_vector(59 downto 0);
signal intColumn : integer range 0 to 800;
signal intRow : integer range 0 to 600;

signal BallContactLeft : std_logic := '0';
signal BallContactRight : std_logic := '0';
signal BallContactTop : std_logic := '0';
signal BallContactBottom : std_logic := '0';
signal BallContactPaddle1 : std_logic := '0';

signal Paddle1_now : std_logic_vector(9 downto 0);
signal Paddle1_enable : std_logic;
signal Paddle1 : std_logic;

signal level_T : std_logic_vector(2 downto 0) ;
signal life_T : std_logic_vector(2 downto 0) ;
signal life_enable:std_logic := '0';

signal score_enable: std_logic;

signal rst_life : std_logic := '0';
signal rst_level : std_logic := '0';

signal STOP : std_logic := '0';
signal lifeCounter : integer range 0 to 21 ;


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
	enableLine <= '1' when count1= "1111111111111111" else
					  '0';
	clear1 <='1' when count1 = "1111111111111111" or rst = '1'  or STOP = '1' else
				'0';
				 		 
	
	counter2: lpm_counter
	generic map(LPM_WIDTH => 16)
	port map(clock => clock1, sclr => clear2, q=>count2, cnt_en => enableLine);
		clear2 <='1' when count2 = "1111111111111111" or rst = '1'  or STOP = '1' else
				 '0';
	
	counter3: lpm_counter
	generic map(LPM_WIDTH => 3)
	port map(clock => clock1, sclr => clear3, q=>count3, cnt_en => enableLine);
		enableLine1 <= '1' when count3 = "111" else
							'0';
		clear3 <='1' when count3 = "111" or rst = '1' or STOP = '1' else
				 '0';
				 
				
	ballRow: lpm_counter
		generic map(LPM_WIDTH => 10)
		port map(clock => clock1, sclr => rst1, sload => clear_Ball, data=> "0011100110", q=>ball_row, cnt_en => enableLine1, updown =>BallRowF);
	 
	ballCol: lpm_counter
		generic map(LPM_WIDTH => 10)
		port map(clock => clock1, sclr => rst1, sload => clear_Ball, data => "0101011110", q=>ball_col, cnt_en => enableLine1, updown =>BallColF);
		
	paddle: lpm_counter
	generic map(LPM_WIDTH => 10)
	port map(clock=>clock1, sclr =>rst1, sload => clear_Ball, data => "0101011110", q=>Paddle1_now, cnt_en => (Paddle1_enable and enableLine), updown=>Paddle1);
		
	score: lpm_counter
	generic map(LPM_WIDTH => 16)
	port map(clock => clock1, sclr => rst1, sload =>clear_Ball, data => "0000000000000000" ,q=>score_T, cnt_en => score_enable);				

		

Alpha : process(clock1)


variable intBallRow : integer range 0 to 600;
variable intBallCol : integer range 0 to 800;
variable numRowBlocks : integer range 0 to 5; 
variable intPaddle1 : integer range 0 to 800;


	
	begin
	temp_row <= to_integer(text_row_T);

	if(rising_edge(clock1))then
				
				if(BLANKING1 = '1')then
					intColumn <=to_integer(column_T);
					intROW <= to_integer(row_T);
					intBallRow := to_integer(unsigned(ball_row))+20;
					intBallCol := to_integer(unsigned(ball_col))+20;
					intPaddle1 := to_integer(unsigned(Paddle1_now))+80;
					
					if (temp_row >= 17) then
						if (font_bit_T = '1') then
								R<= R_T;
								G<= G_T;
								B<= B_T;
						
						else 
								R<="0000";
								G<="0000";
								B<="0000";
					end if;
					
					
					
				else 
				
							if(intColumn > 16) and (intColumn < 784) and (intRow> 16) then 
												R<="0000";
												G<= "0000";
												B<= "0000";
											
											
											
--Block output
											for i in 0 to 59 loop
												if(blocks(i)='1') then
													numRowBlocks := i/12; 
													
													if(numRowBlocks = 0) then
														if(i*64+16 < intColumn) and ((i+1)*64+16 > intColumn) and (16*(numRowBlocks+1) < intRow) and (48*(numRowBlocks+1) > intRow) then
															R <= "1111";
															G<= "1111";
															B<= "0000";
														end if;
		
		
													elsif(numRowBlocks > 0) then
														if((i-numRowBlocks*12)*64+16 < intColumn) and (((i-numRowBlocks*12)+1)*64+16 > intColumn) and (32*(numRowBlocks)+16 < intRow) and (32*(numRowBlocks+1)+16 > intRow) then
															R <= "1111";
															G<= "1111";
															B<= "0000";
														end if;
													
													end if;
												elsif(blocks(i)='0') then
													numRowBlocks := i/12; 
													if(numRowBlocks = 0) then
														if(i*64+16 < intColumn) and ((i+1)*64+16 > intColumn) and (16*(numRowBlocks+1) < intRow) and (48*(numRowBlocks+1) > intRow) then
															R <= "0000";
															G<= "0000";
															B<= "0000";
														end if;
		
													elsif(numRowBlocks > 0) then
														if((i-numRowBlocks*12)*64+16 < intColumn) and (((i-numRowBlocks*12)+1)*64+16 > intColumn) and (32*(numRowBlocks)+16 < intRow) and (32*(numRowBlocks+1)+16 > intRow) then
															R <= "0000";
															G<= "0000";
															B<= "0000";
														end if;
													
													end if;
												
												end if;	
											end loop;
--Ball output 
									
											if (intBallCol-4 < intColumn) and (intColumn < intBallCol+4) and (intRow >intBallRow-4) and (intRow < intBallRow+4) then
												R<= "1111";
												G<= "1111";
												B<= "1111";
											end if;

--Paddle1 output  											
											if(intPaddle1-64 < intColumn) and (intColumn< intPaddle1+64) and (intRow >528) and (intRow < 544) then
												R<= "1111";
												G<= "0000";
												B<= "0000";
											end if;

							else
--wall ouput  
											if(intColumn>=0) and (intColumn<16) and (intRow > 16) then
												R<= "0000";
												G<= "0000";
												B<= "1111";
											elsif(intColumn > 784) and (intColumn <= 800) and (intRow > 16) then
												R<= "0000";
												G<= "0000";
												B<= "1111"; 
												
											elsif(intRow>=0) and (intRow <= 16) then
												R<= "0000";
												G<= "0000";
												B<= "1111";		
											else 
												R<="0000";
												G<= "0000";
												B<= "0000";
											
											end if;	
							
							
							end if;
				end if;
			
				
end if; 
			
end if;
					
end process; 		

	
				
ballMotion : process(clock1)
begin

if(rising_edge(clock1)) then

		if(rst_Center = '1') or (rst_life = '1') then
			clear_Ball <= '1';
		else 
			clear_Ball <='0';
			
		end if;

		if(rst_Center = '1') or (rst_life = '1')then
				
					BallColF <= '1';
					
				
				elsif(ball_col = "1011110111") or (BallContactLeft = '1') then
					BallColF <= '0';
					
				elsif(ball_col = "0000000000") or (BallContactRight = '1') then
				
					BallColF <= '1';
				end if;
				
				
				if(rst_Center = '1') or (rst_life = '1') then
				
					BallRowF <= '1';
					
				elsif (BallContactTop = '1')  or (BallContactPaddle1='1') then
					BallRowF <= '0';
					
				elsif(ball_row = "0000000000") or (BallContactBottom='1')then
				
					BallRowF <= '1';
				elsif((ball_row = "1000000111")) then
					BallRowF <= '0';
					
				end if;
end if;

end process ballMotion;	


Paddle1Control : process(clock1)
begin

if(rising_edge(clock1)) then

	Paddle1_enable<= '0';
	
	if(Paddle1_left = '0') and (Paddle1_now > "0000000000") then
		Paddle1_enable <='1';
		Paddle1 <= '0';
	elsif(Paddle1_right='0') and (Paddle1_now < "1001111111")then
		Paddle1_enable <= '1';
		Paddle1 <= '1';
	end if;
end if;
end process Paddle1Control;


BlockBreaking : process(clock1)
variable intBallRow1 : integer range 0 to 600;
variable intBallCol1 : integer range 0 to 800;
variable intBallRowTrue1 : integer range 0 to 600;
variable intBallColTrue1 : integer range 0 to 800;
variable intPaddle11: integer range 0 to 800;
variable intPaddle1True1: integer range 0 to 800;
variable tempIndex : integer range 0 to 59;


variable lifeCounterR : integer range 0 to 21;
begin

if(rising_edge(clock1)) then
BallContactBottom <='0';
BallContactLeft <= '0';
BallContactRight <= '0';
BallContactTop <= '0';
BallContactPaddle1 <='0';
score_enable <='0';
rst_life <= '0';
life_enable <= '0';

lifeCounterR := lifeCounter; 
	if(rst_Center = '1') then
		blocks <= (others => '1');
		lifeCounterR :=21;
		level_T <="001";
		STOP <= '0';
	elsif(rst_level = '1') then
		blocks<=(others =>'1');
	end if;
	
	rst_level <= '0';
	
	
	intBallRow1 := to_integer(unsigned(ball_row))+20;
	intBallCol1 := to_integer(unsigned(ball_col))+20;
	intPaddle11 := to_integer(unsigned(Paddle1_now))+80;
	
	intBallRowTrue1 := (intBallRow1-4);
	intBallColTrue1 :=(intBallCol1-4);
	intPaddle1True1 :=(intPaddle11-16);
	
----Condition: Ball hit the lower side of a block
			if((intBallRowTrue1=48) or (intBallRowTrue1=80) or (intBallRowTrue1=112) or (intBallRowTrue1=144) or (intBallRowTrue1=176)) and (BallRowF='0') then
				tempIndex := (intBallRowTrue1-16-1)/32*12+((intBallCol1-4-16)/64); 
				if(blocks(tempIndex)= '1') then
					blocks(tempIndex) <= '0';
					BallContactBottom <='1';
					score_enable <='1';
			   end if;
----Condition: Ball hit the upper side of a block
			elsif((intBallRowTrue1=48) or (intBallRowTrue1=80) or (intBallRowTrue1=112) or (intBallRowTrue1=144)) and (BallRowF='1') then	
				tempIndex := (intBallRowTrue1-16)/32*12+((intBallCol1-4-16)/64); 
				if(blocks(tempIndex)= '1') then
					blocks(tempIndex) <= '0';
					BallContactTop <='1';
					score_enable <='1';
			   end if;
----Condition: Ball hit the right side of a block		
			elsif (((intBallColTrue1 -16)mod 64 ) = 0) and (intBallRowTrue1<=176) and (BallColF = '0')then
			
				tempIndex := ((intBallColTrue1-16-1)/64)+((intBallRowTrue1-16-1)/32*12);
				if(blocks(tempIndex)= '1') then
					blocks(tempIndex) <= '0';
					BallContactRight <='1';
					score_enable <='1';
			   end if;
----Condition: Ball hit the left side of a block
			elsif (((intBallColTrue1 -16)mod 64 ) = 0) and (intBallRowTrue1<=176) and (BallColF = '1')then
			
				tempIndex := ((intBallColTrue1-16)/64)+((intBallRowTrue1-16-1)/32*12);
				if(blocks(tempIndex)= '1') then
					blocks(tempIndex) <= '0';
					BallContactLeft <='1';
					score_enable <='1';
			   end if;
----Condition: Ball hit the the Paddle
			elsif (intBallRowTrue1 = 524) and (intBallColTrue1<intPaddle1True1+64) and(intBallColTrue1 > intPaddle1True1-64) then
				BallContactPaddle1 <='1';
				score_enable <='1';
				
				elsif((ball_row = "1000000111")) then
				if(lifeCounterR = 3) then
					STOP <= '1';
				end if;

				lifeCounterR := lifeCounterR - 1;			
			rst_life <='1';
			end if;
				lifeCounter <= lifeCounterR;
				life_T <= std_logic_vector(to_unsigned(lifeCounterR/3, 3));
			if ((to_integer(unsigned(blocks))) = 0) then
				level_T <= std_logic_vector( unsigned(level_T) + 1 );
				rst_level <= '1';
				end if;
		
end if;
	
end process BlockBreaking;



end A5;