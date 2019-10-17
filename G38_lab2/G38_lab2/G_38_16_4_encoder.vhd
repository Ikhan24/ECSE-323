LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all; 

LIBRARY work;

ENTITY G_38_16_4_Encoder is

PORT
	(
		Block_col :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		Code : Out std_logic_VECTOR(3 downto 0); 
		Error : OUT std_logic
		);
		
END G_38_16_4_Encoder;

ARCHITECTURE encoder_arch OF G_38_16_4_Encoder IS
BEGIN 
Code  <= "0000" when Block_col(0)='1' else
         "0001" when Block_col(1)='1' else
			"0010" when Block_col(2)='1' else
			"0011" when Block_col(3)='1' else 
			"0100" when Block_col(4)='1' else 
			"0101" when Block_col(5)='1' else 
			"0110" when Block_col(6)='1' else 
			"0111" when Block_col(7)='1' else 
			"1000" when Block_col(8)='1' else 
			"1001" when Block_col(9)='1' else 
		   "1010" when Block_col(10)='1' else 
		   "1011" when Block_col(11)='1' else 
			"1100" when Block_col(12)='1' else 
			"1101" when Block_col(13)='1' else 
			"1110" when Block_col(14)='1' else 
			"1111" when Block_col(15)='1' else 
			"0000";
Error <= '1' when Block_col = "0000000000000000" else
         '0';
END encoder_arch;
			