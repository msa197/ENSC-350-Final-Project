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
begin
signal ASelect : std_logic;
singal Aout, Aswap : std_logic_vector(N-1 downto 0);
signal ShiftCount : std_logic_vector(5 downto 0);
singal LLout, RLout, RAout : std_logic_vector(N-1 downto 0);
signal Bout, Cout, Dout, Eout : std_logic_vector(N-1 downto 0);
begin

		ASelect <= ShiftFN(1) and ExtWord;
		
		Aswap(N-1 downto 32) <= A(31 downto 0);
		Aswap(31 downto 0) <= A(N-1 downto 32);
		
		with ASelect select Aout <=
			Aswap when "1",
			A when others;
		
		ShiftCount <= B(5 downto 0);  -- Not sure if extraction is correct
		
			
		x0: entity work.SLL64
		port map(Aout, LLout, ShiftCount);
		
		x1: entity work.SRL64
		port map(Aout, RLout, ShiftCount);
		
		x2: entity work.SRA64
		port map(Aout, RAout, ShiftCount);
		
		with ShiftFN(0) select Bout <=
			RAout when "1",
			RLout when others;
		
		with ShiftFN(0) select Cout <=
			LLout when "1",
			C when others;
			
		with ExtWord select Dout <=
			(1 to 32 => Bout(31)) & Bout(31 downto 0) when "1", --unsure about upper sign ext
			Bout when others;
		
		with ExtWord select Eout <=
			(1 to 32 => Cout(31)) & Cout(31 downto 0) when "1", --unsure about lower sign ext
			Cout when others;
			
		with ShiftFN(1) select Y <=
			Dout when "1",
			Eout when others;

end architecture rtl;