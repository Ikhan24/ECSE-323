--
-- entity name: g38_64_6_encoder
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

entity G_38_64_6_encoder is
port ( inputs : in std_logic_vector(63 downto 0);
code1 : out std_logic_vector(5 downto 0);
ERROR1: out std_logic);
end G_38_64_6_encoder;

Architecture bdf_type of G_38_64_6_encoder is
	SIGNAL M1 : STD_LOGIC_VECTOR (3 downto 0);
	SIGNAL M2 : STD_LOGIC_VECTOR (3 downto 0);
	SIGNAL M3 : STD_LOGIC_VECTOR (3 downto 0);
	SIGNAL M4 : STD_LOGIC_VECTOR (3 downto 0);
   SIGNAL E1 : STD_LOGIC_vector (3 downto 0);
	
	
component G_38_16_4_Encoder
	PORT  
	(	Block_col :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		Code : Out std_logic_VECTOR(3 downto 0); 
		Error : OUT std_logic
		);
end component;

Begin 
	Encod1: G_38_16_4_Encoder Port Map (block_col => inputs(15 downto 0), Code => M1(3  downto 0),Error => E1(0));
	Encod2: G_38_16_4_Encoder Port Map (block_col => inputs(31 downto 16),Code => M2(3 downto 0),Error => E1(1));
	Encod3: G_38_16_4_Encoder Port Map (block_col => inputs(47 downto 32),Code => M3(3 downto 0),Error => E1(2));
	Encod4: G_38_16_4_Encoder Port Map (block_col => inputs(63 downto 48),Code => M4(3 downto 0),Error => E1(3));
	

	code1 <= "000000" + M1 when E1(0) = '0' else
				"010000" + M2 when E1(1) = '0' else
				"100000" + M3 when E1(2) = '0' else
				"110000" + M4 when E1(3) = '0' else
				"000000" ;
	
	Error1 <= '0' when E1(0) = '0' else
				'0' when E1(1) = '0' else
				'0' when E1(2) = '0' else
				'0' when E1(3) = '0' else
				'1';
				
END bdf_type;


