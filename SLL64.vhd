library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
		shift_left(unsigned(X),1) when "01",
		shift_left(unsigned(X),2) when "10",
		shift_left(unsigned(X),3) when "11",
		X when others;
		
		
		with ShiftCount (3 downto 2) select b <=
		shift_left(unsigned(a),1) when "01",
		shift_left(unsigned(a),2) when "10",
		shift_left(unsigned(a),3) when "11",
		a when others;
		
		with ShiftCount (1 downto 0) select Y <=
		shift_left(unsigned(b),1) when "01",
		shift_left(unsigned(b),2) when "10",
		shift_left(unsigned(b),3) when "11",
		b when others;

end architecture rtl;
