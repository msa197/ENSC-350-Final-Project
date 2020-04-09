library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.all;

Entity SRA64 is -- Shift Right Arithmetic
Generic ( N : natural := 64 );
Port ( X : in std_logic_vector( N-1 downto 0 );
Y : out std_logic_vector( N-1 downto 0 );
ShiftCount : in unsigned( integer(ceil(log2(real(N))))-1 downto 0 ) );
End Entity SRA64;

architecture rtl of SRA64 is
signal a, b, c, d : std_logic_vector(N-1 downto 0);
signal count : integer;
begin
	count <= to_integer(ShiftCount);
		
	with ShiftCount (5 downto 4) select a <=
    	std_logic_vector(signed(X) srl 16) when "01",
    	std_logic_vector(signed(X) srl 32) when "10",
    	std_logic_vector(signed(X) srl 48) when "11",
	X when others;

	with ShiftCount (3 downto 2) select b <=
    	std_logic_vector(signed(a) srl 4) when "01",
    	std_logic_vector(signed(a) srl 8) when "10",
    	std_logic_vector(signed(a) srl 12) when "11",
	a when others;

	with ShiftCount (1 downto 0) select c <=
    	std_logic_vector(signed(b) srl 1) when "01",
    	std_logic_vector(signed(b) srl 2) when "10",
    	std_logic_vector(signed(b) srl 3) when "11",
	b when others;
		
	d <= c(N-count downto 0);
	Y(N-1 downto (N-count+1)) <= (others => c(N-count));
	Y(N-count downto 0) <= d;

end architecture rtl;
