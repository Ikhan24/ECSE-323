-- Group 38
-- Authors: Tamim Sujat, Intesar Khan 
-- File: Text Address Generator Circuit 




LIBRARY IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
LIBRARY lpm;
USE lpm.lpm_components.all; 

entity g38_Text_Address_Generator is
	port ( 
	ROW      : in unsigned(9 downto 0); -- line 0 to 599 
	COLUMN   : in unsigned(9 downto 0); -- column 0 to 799 
	font_row : out std_logic_vector (3 downto 0); 
	font_col : out std_logic_vector (2 downto 0);  
	text_row : out unsigned (4 downto 0);
	text_col : out unsigned(5 downto 0) ); 
	end g38_Text_Address_Generator;
	
Architecture A of g38_Text_Address_Generator IS 
	begin 
	text_row <= ROW(9 downto 5);
	text_col <= COLUMN (9 downto 4); 
	font_row <= std_logic_vector(ROW(4 downto 1)); 
	font_col <= std_logic_vector (COLUMN(3 downto 1)); 
	
	end A; 
	
	