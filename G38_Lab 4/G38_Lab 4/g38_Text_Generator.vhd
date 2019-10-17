library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_logic_unsigned.all;


entity g38_Text_Generator is
	port(	text_row		: in std_logic_vector(4 downto 0);  
			text_col		: in std_logic_vector(5 downto 0);  
			score			: in std_logic_vector(15 downto 0); 
			level			: in std_logic_vector(2 downto 0); 
			life			: in std_logic_vector(2 downto 0); 
			ASCII			: out std_logic_vector(6 downto 0); 
			R, G, B		: out std_logic_vector (3 downto 0)
			);			
end g38_Text_Generator;

Architecture arch2 of g38_Text_Generator is

--Function for 16 bit binary to bcd converter from lecture slides
function to_bcd (bin : std_logic_vector((15) downto 0)) return std_logic_vector is
	variable i : integer := 0;
	variable j : integer := 1;
	variable bcd : std_logic_vector((19) downto 0) := (others => '0');
	variable bint : std_logic_vector((15) downto 0) := bin;
	begin
		for i in 0 to 15 loop
			bcd((19) downto 1) := bcd((18) downto 0); --shift the bcd bits
			bcd(0) := bint(15);
			
			bint((15) downto 1) := bint((14) downto 0); --shift the input bits
			bint(0) := '0';
			
			loop1: for j in 1 to 5 loop   -- for each BCD digit add 3 if it is greater than 4
						if(i < 15 and bcd(((4*j)-1) downto ((4*j)-4)) > "0100") then
								bcd(((4*j)-1) downto ((4*j)-4)) := std_logic_vector(unsigned(bcd(((4*j)-1) downto ((4*j)-4)) + "0011"));
						end if;
			end loop loop1; 
		end loop;
	return bcd;
end to_bcd;

--new BCD signal declaration				
Signal BCD_score : std_logic_vector(19 downto 0);
 
Begin

BCD_score <=	to_bcd(score); --conversion of score to BCD	

process_other_col : process(text_row, text_col, BCD_score, level, life)
	begin
		if ( (to_integer(unsigned(text_row))) /= 17 )
			then
				ASCII	<= "0000000";
				R	<=	"0000";
				G	<=	"0000";
				B	<=	"0000";
			else
				case (to_integer(unsigned(text_col))) is 
					--SCORE in RED 
					when 1 => 		ASCII	<= "1010011";	--S
										R	<=	"1111";
										G	<=	"0000";
										B	<=	"0000";
					when 2 =>		ASCII	<= "1000011";	--C
										R	<=	"1111";
										G	<=	"0000";
										B	<=	"0000";
					when 3 =>		ASCII	<= "1001111";	--O
										R	<=	"1111";
										G	<=	"0000";
										B	<=	"0000";
					when 4 =>		ASCII	<= "1010010";	--R
										R	<=	"1111";
										G	<=	"0000";
										B	<=	"0000";
					when 5 => 		ASCII	<= "1000101";	--E
										R	<=	"1111";
										G	<=	"0000";
										B	<=	"0000";
					when 6 =>		ASCII	<= "0111010";	--:
										R	<=	"1111";
										G	<=	"0000";
										B	<=	"0000";					
					--score value in WHITE
					when 9 =>		case (to_integer(unsigned(BCD_score(19 downto 16)))) is
											when 0 =>	ASCII <= "0110000";  
											when 1 =>	ASCII <= "0110001";
											when 2 =>	ASCII <= "0110010";
											when 3 =>	ASCII <= "0110011";
											when 4 =>	ASCII <= "0110100";
											when 5 =>	ASCII <= "0110101";
											when 6 =>	ASCII <= "0110110";
											when 7 =>	ASCII <= "0110111";
											when 8 =>	ASCII <= "0111000";
											when 9 =>	ASCII <= "0111001";
											when others => ASCII <= "0000000";
										end case;
										R	<=	"1111";
										G	<=	"1111";
										B	<=	"1111";
					when 10 =>		case (to_integer(unsigned(BCD_score(15 downto 12)))) is
											when 0 =>	ASCII <= "0110000";  
											when 1 =>	ASCII <= "0110001";
											when 2 =>	ASCII <= "0110010";
											when 3 =>	ASCII <= "0110011";
											when 4 =>	ASCII <= "0110100";
											when 5 =>	ASCII <= "0110101";
											when 6 =>	ASCII <= "0110110";
											when 7 =>	ASCII <= "0110111";
											when 8 =>	ASCII <= "0111000";
											when 9 =>	ASCII <= "0111001";
											when others => ASCII <= "0000000";
										end case;
										R	<=	"1111";
										G	<=	"1111";
										B	<=	"1111";
										
					when 11 =>		case (to_integer(unsigned(BCD_score(11 downto 8)))) is
											when 0 =>	ASCII <= "0110000";  
											when 1 =>	ASCII <= "0110001";
											when 2 =>	ASCII <= "0110010";
											when 3 =>	ASCII <= "0110011";
											when 4 =>	ASCII <= "0110100";
											when 5 =>	ASCII <= "0110101";
											when 6 =>	ASCII <= "0110110";
											when 7 =>	ASCII <= "0110111";
											when 8 =>	ASCII <= "0111000";
											when 9 =>	ASCII <= "0111001";
											when others => ASCII <= "0000000";
										end case;
										R	<=	"1111";
										G	<=	"1111";
										B	<=	"1111";
					when 12 =>		case (to_integer(unsigned(BCD_score(7 downto 4)))) is
											when 0 =>	ASCII <= "0110000";  
											when 1 =>	ASCII <= "0110001";
											when 2 =>	ASCII <= "0110010";
											when 3 =>	ASCII <= "0110011";
											when 4 =>	ASCII <= "0110100";
											when 5 =>	ASCII <= "0110101";
											when 6 =>	ASCII <= "0110110";
											when 7 =>	ASCII <= "0110111";
											when 8 =>	ASCII <= "0111000";
											when 9 =>	ASCII <= "0111001";
											when others => ASCII <= "0000000";
										end case;
										R	<=	"1111";
										G	<=	"1111";
										B	<=	"1111";
					when 13 =>		case (to_integer(unsigned(BCD_score(3 downto 0)))) is
											when 0 =>	ASCII <= "0110000";  
											when 1 =>	ASCII <= "0110001";
											when 2 =>	ASCII <= "0110010";
											when 3 =>	ASCII <= "0110011";
											when 4 =>	ASCII <= "0110100";
											when 5 =>	ASCII <= "0110101";
											when 6 =>	ASCII <= "0110110";
											when 7 =>	ASCII <= "0110111";
											when 8 =>	ASCII <= "0111000";
											when 9 =>	ASCII <= "0111001";
											when others => ASCII <= "0000000";
										end case;
										R	<=	"1111";
										G	<=	"1111";
										B	<=	"1111";
					
					--LEVEL in YELLOW
					when 16|20 =>	ASCII	<= "1001100";	--L
										R	<=	"1111";
										G	<=	"1111";
										B	<=	"0000";
					when 17|19 =>	ASCII	<= "1000101";	--E
										R	<=	"1111";
										G	<=	"1111";
										B	<=	"0000";
					when 18 =>		ASCII	<= "1010110";	--V
										R	<=	"1111";
										G	<=	"1111";
										B	<=	"0000"; 
					when 21 =>		ASCII	<= "0111010";	--:
										R	<=	"1111";
										G	<=	"1111";
										B	<=	"0000";
										
					-- current level value in WHITE		
					when 22 =>		case (to_integer(unsigned(level))) is
											when 0 =>	ASCII <= "0110000";  
											when 1 =>	ASCII <= "0110001";
											when 2 =>	ASCII <= "0110010";
											when 3 =>	ASCII <= "0110011";
											when 4 =>	ASCII <= "0110100";
											when 5 =>	ASCII <= "0110101";
											when 6 =>	ASCII <= "0110110";
											when 7 =>	ASCII <= "0110111";
											when others => ASCII <= "0000000";
										end case;
										R	<=	"1111";
										G	<=	"1111";
										B	<=	"1111";
										
					-- Life represented in the color - pink 
					when 25 =>		case (to_integer(unsigned(life))) is
											when 7 =>		ASCII <= "0000011";
											when others => ASCII <= "0000000";
										end case;
										R	<=	"1111";
										G	<=	"0000";
										B	<=	"1111";
					when 26 =>		case (to_integer(unsigned(life))) is
											when 7|6 =>		ASCII <= "0000011";
											when others => ASCII <= "0000000";
										end case;
										R	<=	"1111";
										G	<=	"0000";
										B	<=	"1111";
					when 27 =>		case (to_integer(unsigned(life))) is
											when 7|6|5 =>	ASCII <= "0000011";
											when others => ASCII <= "0000000";
										end case;
										R	<=	"1111";
										G	<=	"0000";
										B	<=	"1111";					
					when 28 =>		case (to_integer(unsigned(life))) is
											when 7|6|5|4 =>	ASCII <= "0000011";
											when others => 	ASCII <= "0000000";
										end case;
										R	<=	"1111";
										G	<=	"0000";
										B	<=	"1111";		
					when 29 =>		case (to_integer(unsigned(life))) is
											when 7|6|5|4|3 =>	ASCII <= "0000011";
											when others =>		ASCII <= "0000000";
										end case;
										R	<=	"1111";
										G	<=	"0000";
										B	<=	"1111";
					when 30 =>		case (to_integer(unsigned(life))) is
											when 7|6|5|4|3|2 =>	ASCII <= "0000011";
											when others =>			ASCII <= "0000000";
										end case;
										R	<=	"1111";
										G	<=	"0000";
										B	<=	"1111";
					when 31 =>		case (to_integer(unsigned(life))) is
											when 7|6|5|4|3|2|1 => 	ASCII <= "0000011";
											when others =>				ASCII <= "0000000";
										end case;
										R	<=	"1111";
										G	<=	"0000";
										B	<=	"1111";
										
					--other values for  Space and BLACK
					when others => 	ASCII	<= "0000000";
											R	<=	"0000";
											G	<=	"0000";
											B	<=	"0000"; 	
				end case;
		end if;
	end process;
End arch2;

