LIBRARY IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
LIBRARY lpm;
USE lpm.lpm_components.all; 


entity g38_VGA_Test_Pattern is 
port ( clock    : in std_logic; -- 50MHz 
rst : in std_logic; -- reset 
R, G, B  : out std_logic_vector(3 downto 0); -- colors 
HSYNC    : out std_logic; -- horizontal sync signal 
VSYNC   : out std_logic); -- vertical sync signal 
end g38_VGA_Test_Pattern;


Architecture A of g38_VGA_Test_Pattern IS 	

SIGNAL COLUMN: unsigned(9 downto 0);

component g38_VGA
port ( clock    : in std_logic; -- 50MHz 
rst : in std_logic; -- reset 
BLANKING : out std_logic; -- blank display when zero 
ROW      : out unsigned(9 downto 0); -- line 0 to 599 
COLUMN   : out unsigned(9 downto 0); -- column 0 to 799 
HSYNC    : out std_logic; -- horizontal sync signal 
VSYNC   : out std_logic); -- vertical sync signal 
end component;

BEGIN
	comp1: g38_VGA port map (clock => clock, 
		rst => rst,
HSYNC   =>HSYNC, 
VSYNC  =>VSYNC,
COLUMN => COLUMN
	);
	pro1: process(COLUMN)
	BEGIN 
		IF((COLUMN>0 AND COLUMN<100) OR (COLUMN>99 AND COLUMN<200) OR
				(COLUMN>399 AND COLUMN<500) OR (COLUMN>499 AND COLUMN<600)) THEN
					R<= "1111";
		ELSE R<= "0000";
		END IF;
	END PROCESS;
									
	pro2: process(COLUMN)
	BEGIN 
		IF((COLUMN>0 AND COLUMN<100) OR (COLUMN>99 AND COLUMN<200)
				OR (COLUMN>199 AND COLUMN<300) OR (COLUMN>299 AND COLUMN<400)) THEN
					G<="1111";
		ELSE G<= "0000";
		END IF;
	END PROCESS;								

	pro3: process(COLUMN)
	BEGIN 
		IF((COLUMN>0 AND COLUMN<100) OR (COLUMN>199 AND COLUMN<300)
				OR (COLUMN>399 AND COLUMN<500) OR (COLUMN>599 AND COLUMN<700)) THEN
					B<="1111";
		ELSE B<= "0000";
		END IF;
	END PROCESS;

End A;