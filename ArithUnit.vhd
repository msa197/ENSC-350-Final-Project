library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

entity ArithUnit is
		generic (width : integer := 64);
		port (
				A, B				:		in		std_logic_vector(width-1 downto 0);
				NotA, AddSub, ExtWord		:		in		std_logic;
				AltBu, AltB 			:		out 	std_logic;
				Y				:		out	std_logic_vector(width-1 downto 0);
end entity ArithUnit;



architecture Adder64 of ArithUnit is 
signal Aout, Bout, S : std_logic_vector(width-1 downto 0);
signal C : std_logic_vector(width downto 0);
signal Ovfl, Cout, Zero : std_logic;
begin
	Aout <= (A and not NotA) or (not A and NotA);
	Bout <= (B and not AddSub) or (not B and AddSub);
	C(0) <= AddSub;
	x0: entity ExU.Adder 
	port map(A, B, C(0),S, C(64));
	
	
	Ovfl <= C(63) xor C(64);
	Zero <= S(width-1 downto 0) nor S(width-1 downto 0); -- not sure if this is correct, 64 bit input NOR
	
	Y <= (S and not ExtWord) or (not s and ExtWord);-- not sure what to do with the sign extension
	
end architecture Adder64;
