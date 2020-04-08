library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity ExecUnit is
Generic ( N : natural := 64 );
Port ( A, B : in std_logic_vector( N-1 downto 0 );
			NotA : in std_logic := '0';
			FuncClass, LogicFN, ShiftFN : in std_logic_vector( 1 downto 0 );
			AddnSub, ExtWord : in std_logic := '0';
			Y : out std_logic_vector( N-1 downto 0 );
			Zero, AltB, AltBu : out std_logic );
End Entity ExecUnit;

architecture rtl of ShiftUnit is
begin
signal LogicOut, ArithOut, ShiftOut : std_logic_vector(N-1 downto 0);

		x0: entity work.LogicUnit
		port map(A, B, LogicFN, LogicOut);
		
		x1: entity work.ArithUnit
		port map(A, B, NotA, AddnSub, ExtWord, AltBu, AltB, ArithOut, Cout, Ovfl, Zero);
		
		x2: entity work.ShiftUnit
		port map(A, B, ArithOut, ShiftOut, ShiftFN, ExtWord);
		
		with FuncClass select Y <=
			AltB when "01",  -- unsure about "0...0"
			ShiftOut when "10",
			LogicOut when "11",
			AltBu when others; -- unsure about "0...0"



end architecture rtl;