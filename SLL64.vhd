library ieee;
use ieee.std_logic_1164.all;
use IEEE.MATH_REAL.ALL;
use ieee.numeric_std.all;

Entity SLL64 is -- Shift Left Logical
Generic ( N : natural := 64 );
Port ( X : in std_logic_vector( N-1 downto 0 );
Y : out std_logic_vector( N-1 downto 0 );
ShiftCount : in unsigned( integer(ceil(log2(real(N))))-1 downto 0 ) );
End Entity SLL64;

architecture rtl of SLL64 is
signal a, b, c : unsigned(N-1 downto 0);
begin

		
	with ShiftCount (5 downto 4) select a <= -- first level shifts by 0,16,32,48
	shift_left(unsigned(X),16) when "01",
	shift_left(unsigned(X),32) when "10",
	shift_left(unsigned(X),48) when "11",
	unsigned(X) when others;
		
	with ShiftCount (3 downto 2) select b <= -- second level shifts by 0,4,8,12
	shift_left(unsigned(a),4) when "01",
	shift_left(unsigned(a),8) when "10",
	shift_left(unsigned(a),12) when "11",
	a when others;
		
	with ShiftCount (1 downto 0) select c <= -- third level shifts by 0,1,2,3
	shift_left(unsigned(b),1) when "01",
	shift_left(unsigned(b),2) when "10",
	shift_left(unsigned(b),3) when "11",
	b when others;

	Y <= std_logic_vector(c); -- convert back to std_logic

end architecture rtl;
