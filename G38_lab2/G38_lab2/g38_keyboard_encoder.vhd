--
-- entity name: g38_keyboard_encoder
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


entity g38_keyboard_encoder is
port ( keys: in std_logic_vector(63 downto 0);
ASCII_CODE : out std_logic_vector(6 downto 0));
end g38_keyboard_encoder;

Architecture inzy of g38_keyboard_encoder is
signal M1: std_logic_vector(5 downto 0);

component G_38_64_6_encoder
	port ( inputs : in std_logic_vector(63 downto 0);
	code1 : out std_logic_vector(5 downto 0);
	ERROR1: out std_logic);
	end component;


begin 
Gate1: G_38_64_6_encoder port map( inputs=> keys, code1=> M1);

ASCII_CODE <= 	"10" & M1 (4 downto 0) when M1(5) = '1' else
					"01" & M1 (4 downto 0) when M1(5) = '0' else
					"1111111";
					
end inzy;
