library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity SRL64 is -- Shift Right Logical
Generic ( N : natural := 64 );
Port ( X : in std_logic_vector( N-1 downto 0 );
Y : out std_logic_vector( N-1 downto 0 );
ShiftCount : in unsigned( integer(ceil(log2(real(N))))-1 downto 0 ) );
End Entity SRL64;

architecture rtl of SRL64 is
begin
signal a, b : std_logic_vector(N-1 downto 0);

		
		with ShiftCount (5 down to 4) select a <=
		shift_right(unsigned(X),1) when "01",
		shift_right(unsigned(X),2) when "10",
		shift_right(unsigned(X),3) when "11",
		X when others;
		
		
		with ShiftCount (3 down to 2) select b <=
		shift_right(unsigned(a),1) when "01",
		shift_right(unsigned(a),2) when "10",
		shift_right(unsigned(a),3) when "11",
		a when others;
		
		with ShiftCount (1 down to 0) select Y <=
		shift_right(unsigned(b),1) when "01",
		shift_right(unsigned(b),2) when "10",
		shift_right(unsigned(b),3) when "11",
		b when others;

end architecture rtl;