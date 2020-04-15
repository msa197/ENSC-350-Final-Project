library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity ShiftUnit is
Generic ( N : natural := 64 );
Port ( A, B, C : in std_logic_vector( N-1 downto 0 );
		Y : out std_logic_vector( N-1 downto 0 );
		ShiftFN : in std_logic_vector( 1 downto 0 );
		ExtWord : in std_logic );
End Entity ShiftUnit;

architecture rtl of ShiftUnit is
signal ASelect : std_logic;
signal Aout, Aswap : std_logic_vector(N-1 downto 0);
signal ShiftCount : unsigned(5 downto 0);
signal LLout, RLout, RAout : std_logic_vector(N-1 downto 0);
signal Bout, Cout, Dout, Eout : std_logic_vector(N-1 downto 0);
begin

		ASelect <= ShiftFN(1) and ExtWord;
		
		Aswap(N-1 downto 32) <= A(31 downto 0);
		Aswap(31 downto 0) <= A(31 downto 0);
		
		with ASelect select Aout <=
			Aswap when '1',
			A when others;
		
		with ExtWord select ShiftCount <= 
			resize(unsigned(B(4 downto 0)),6) when '1', -- extract 5 LSBs (32-bit)
			unsigned(B(5 downto 0)) when others;  -- extract 6 LSBs

			
		x0: entity work.SLL64
		port map(Aout, LLout, ShiftCount);
		
		x1: entity work.SRL64
		port map(Aout, RLout, ShiftCount);
		
		x2: entity work.SRA64
		port map(Aout, RAout, ShiftCount);
		
		with ShiftFN(0) select Bout <=
			RAout when '1',
			RLout when others;
		
		with ShiftFN(0) select Cout <=
			LLout when '1',
			C when others;
			
		with ExtWord select Dout <=
			std_logic_vector(resize(signed(Bout(N-1 downto 32)),N)) when '1', -- sgn ext by resizing signed value
			Bout when others;
		
		with ExtWord select Eout <=
			std_logic_vector(resize(signed(Cout(31 downto 0)),N)) when '1', 
			Cout when others;
			
		with ShiftFN(1) select Y <=
			Dout when '1',
			Eout when others;

end architecture rtl;
