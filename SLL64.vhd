library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;	
use IEEE.NUMERIC_STD.all; 

Entity SLL64 is -- Shift Left Logical
Generic ( N : natural := 64 );
Port ( X : in std_logic_vector( N-1 downto 0 );
			Y : out std_logic_vector( N-1 downto 0 );
		ShiftCount : in unsigned( integer(ceil(log2(real(N))))-1 downto 0 ) );
End Entity SLL64;

architecture rtl of SLL64 is
signal a, b : std_logic_vector(N-1 downto 0);
begin
	with ShiftCount (5 downto 4) select a <=
    	std_logic_vector(unsigned(X) sll 16) when "01",
    	std_logic_vector(unsigned(X) sll 32) when "10",
    	std_logic_vector(unsigned(X) sll 48) when "11",
	X when others;

	with ShiftCount (3 downto 2) select b <=
   	std_logic_vector(unsigned(a) sll 4) when "01",
    	std_logic_vector(unsigned(a) sll 8) when "10",
    	std_logic_vector(unsigned(a) sll 12) when "11",
	a when others;

	with ShiftCount (1 downto 0) select Y <=
    	std_logic_vector(unsigned(b) sll 1) when "01",
    	std_logic_vector(unsigned(b) sll 2) when "10",
    	std_logic_vector(unsigned(b) sll 3) when "11",
	b when others;

end architecture rtl;
