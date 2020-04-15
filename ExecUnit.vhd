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

architecture rtl of ExecUnit is
signal LogicOut, S, ArithOut, ShiftOut : std_logic_vector(N-1 downto 0); -- S unused but needed in port map
signal Cout, Ovfl : std_logic;
signal AltBExt, AltBuExt : std_logic; -- useful temporary signals
begin

		x0: entity work.LogicUnit
		port map(A, B, LogicFN, LogicOut);
		
		x1: entity work.ArithUnit
		port map(A, B, NotA, AddnSub, ExtWord, AltBuExt, AltBExt, ArithOut, S, Cout, Ovfl, Zero);
		
		x2: entity work.ShiftUnit
		port map(A, B, ArithOut, ShiftOut, ShiftFN, ExtWord);
		
		AltB <= AltBExt;
		AltBu <= AltBuExt;

		with FuncClass select Y <=
			63x"0" & AltBExt when "01",  -- pad with 63 zeros
			ShiftOut when "10",
			LogicOut when "11",
			63x"0" & AltBuExt when others; 

end architecture rtl;
