-- entity name: g38_7__ALTERA_segment_decoder
--
-- Copyright (C) 2016 your name
-- Version 1.0
-- Author: Tamim Sujat, Intesarul Khan
-- Date: October 06, 2016


library ieee; -- allows use of the std_logic_vector type
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library lpm;
use lpm.lpm_components.all;
use IEEE.STD_logic_unsigned.all;

entity g38_7_ALTERA_segment_decoder is
	port (inputs: in std_logic_vector(9 downto 0);
				outputs : out std_logic_vector(6 downto 0)); 
end g38_7_ALTERA_segment_decoder;

architecture bdf_type of g38_7_ALTERA_segment_decoder is 
	signal bus1  :  std_logic_vector(6 downto 0);
	
	component g38_keyboard_encoder
		port ( keys: in std_logic_vector(63 downto 0);
		ASCII_CODE : out std_logic_vector(6 downto 0));
	end component;
	
	component  g38_7_segment_decoder 
		port ( asci_code: in std_logic_vector(6 downto 0);
		 segments: out std_logic_vector(6 downto 0));
	end component;
	
	begin
	Gate1: g38_keyboard_encoder port map (keys=>"00000000000000000000000000000000000000" & inputs & "0000000000000000", ASCII_CODE=>bus1);
	Gate2: g38_7_segment_decoder port map (asci_code=>bus1, segments=>outputs);




end bdf_type;
	
	


