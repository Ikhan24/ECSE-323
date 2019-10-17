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
-- Generated on "09/22/2016 17:03:54"
                                                            
-- Vhdl Test Bench template for design  :  g38_lab1
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;                                 

ENTITY g38_lab1_vhd_tst IS
END g38_lab1_vhd_tst;
ARCHITECTURE g38_lab1_arch OF g38_lab1_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL A : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL AeqB : STD_LOGIC;
SIGNAL B : STD_LOGIC_VECTOR(5 DOWNTO 0);
COMPONENT g38_lab1
	PORT (
	A : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
	AeqB : OUT STD_LOGIC;
	B : IN STD_LOGIC_VECTOR(5 DOWNTO 0)
	);
END COMPONENT;

BEGIN
i1 : g38_lab1 PORT MAP (A => A,AeqB => AeqB,B => B); --instantiate component being tested
generate_test : PROCESS 
BEGIN
 FOR i IN 0 to 63 LOOP -- loop over all A values 
 A <= std_logic_vector(to_unsigned(i,6)); -- convert the loop variable i to std_logic_vector 
 FOR j IN 0 to 63 LOOP -- loop over all B values 
 B <= std_logic_vector(to_unsigned(j,6)); -- convert the loop variable j to std_logic_vector
WAIT FOR 10 ns; -- suspend process for 10 nanoseconds at the start of each loop
END LOOP; -- end the j loop
END LOOP; -- end the i loop
WAIT; -- we have gone through all possible input patterns, so suspend simulator forever
END PROCESS generate_test;
END g38_lab1_arch;                         
                  
