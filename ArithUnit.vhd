library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

entity ArithUnit is
		generic (N : integer := 64);
		port (
				A, B				:	in	std_logic_vector(N-1 downto 0);
				NotA, AddnSub, ExtWord		:	in	std_logic;
				AltBu, AltB 			:	out 	std_logic;
				Y				:	out	std_logic_vector(N-1 downto 0);
				Cout, Ovfl, Zero		:	out 	std_logic);
end entity ArithUnit;


architecture rtl of ArithUnit is 
signal Aout, Bout, S : std_logic_vector(N-1 downto 0);
begin
	Aout <= (A and not NotA) or (not A and NotA);
	Bout <= (B and not AddnSub) or (not B and AddnSub);

	-- 64 bit adder
	x0: entity work.Adder 
	port map(A, B, S, AddnSub, Cout, Ovfl);
	
	Zero <= nor S; 
	
	Y <= (S and not ExtWord) or (S(63 downto 32) <= (others => S(32)) and ExtWord);-- not sure what to do with the sign extension
	
	-- unsigned A less than B 
	AltBu <= not Cout;
	
	-- signed A less than B
	AltB <= S(N-1) xor Ovfl;
	
end architecture rtl;
