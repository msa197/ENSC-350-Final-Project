library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LogicUnit is
generic (N : natural := 64);
port (A,B : in std_logic_vector(N-1 downto 0);
	LogicFN : in std_logic_vector(1 downto 0); 
	Y : out std_logic_vector(N-1 downto 0));
end entity LogicUnit;

architecture rtl of LogicUnit is
begin
	with LogicFN select Y <=		--multiplexing A and B, using LogicFN to determine which logical output to output
		(A xor B) when "01",
		(A or B) when "10",
		(A and B) when "11",
		B when others; 			-- Ouput is B when LogicFN is "00"
end architecture rtl;
