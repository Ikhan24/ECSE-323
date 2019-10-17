-- Group 38
-- Authors: Tamim Sujat, Intesar Khan 
-- File: VGA Circuit 

LIBRARY IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
LIBRARY lpm;
USE lpm.lpm_components.all; 


entity g38_VGA is 
port ( clock    : in std_logic; -- 50MHz 
rst : in std_logic; -- reset 
BLANKING : out std_logic; -- blank display when zero 
ROW      : out unsigned(9 downto 0); -- line 0 to 599 
COLUMN   : out unsigned(9 downto 0); -- column 0 to 799 
HSYNC    : out std_logic; -- horizontal sync signal 
VSYNC   : out std_logic); -- vertical sync signal 
end g38_VGA;


architecture A of g38_VGA is 

signal count_h: std_logic_vector (10 downto 0);
signal count_v: std_logic_vector (9 downto 0);
signal clear_h, clear_v : std_logic;

signal int_count_hor : integer range 0 to 1039;
signal int_count_ver : integer range 0 to 665;


begin
counter1 : lpm_counter
		generic map (LPM_WIDTH => 11)
		port map ( clock => clock, aclr => rst, sclr => clear_h, q => count_h);

with count_h select
clear_h <= '1' when "10000001111", -- 1039
			'0' when others;
		
counter2 : lpm_counter
		generic map(LPM_WIDTH => 10)
		port map (clock => clock, aclr => rst, sclr =>clear_v, q =>count_v, cnt_en => clear_h);
	
with count_v select
clear_v <= '1' when "1010011001", --665
			'0' when others;
			
int_count_hor <= to_integer(unsigned(count_h));
int_count_ver <= to_integer(unsigned(count_v));		
		
ROW <= to_unsigned(599,10) when (((int_count_ver) > to_unsigned(642,10)) or ((int_count_ver) < to_unsigned(43,10)))
		else
		((int_count_ver) - to_unsigned(43,10));
		
COLUMN <= to_unsigned(799,10) when (((int_count_hor) > to_unsigned(975,10)) or ((int_count_hor) < to_unsigned(176,10)))
		 else
		 ((int_count_hor)- to_unsigned(176,10));
		 
VSYNC <= '1' when int_count_ver > to_unsigned(6,10)
			else
			'0';
			
HSYNC <= '1' when int_count_hor > to_unsigned(120,10)
			else
			'0';
			
BLANKING <= '0' when (((int_count_ver) > to_unsigned(642,10)) or ((int_count_ver) < to_unsigned(43,10)) 
				or ((int_count_hor) > to_unsigned(975,10)) or ((int_count_hor) < to_unsigned(176,10))) 
				else
				'1';
				
end A;
