-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "09/30/2016 10:59:14"
                                                            
-- Vhdl Test Bench template for design  :  g38_16_4_Encoder
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;
Use Ieee.numeric_std.all;                                

ENTITY g38_16_4_Encoder_vhd_tst IS
END g38_16_4_Encoder_vhd_tst;
ARCHITECTURE g38_16_4_Encoder_arch OF g38_16_4_Encoder_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL Block_col : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL Code : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL Error : STD_LOGIC;
COMPONENT G_38_16_4_Encoder
	PORT (
	Block_col : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	Code : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	Error : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : G_38_16_4_Encoder
	PORT MAP (
-- list connections between master ports and signals
	Block_col => Block_col,
	Code => Code,
	Error => Error
	);
                                          
always: PROCESS 
BEGIN                                                         
FOR i IN 0 to 15 LOOP
	Block_col <= std_logic_vector (to_unsigned(0,16));
	Block_col(i) <= '1';
	WAIT FOR 10 ns;
	
END LOOP; -- end the i loop

	Block_col <= "0000000000000000";
	wait FOR 10 ns;
	Block_col <= "1111111111111111";
	wait for 10 ns;
	Block_col <= "0000000000001000";
   wait for 15 ns;
	Block_col <= "0000000000001010";
	
WAIT;                                                        
END PROCESS always;                                           
END g38_16_4_Encoder_arch;
