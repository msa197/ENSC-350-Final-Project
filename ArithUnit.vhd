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
	with NotA select 
	Aout <= A when 0, 
		not A when 1;

	with AddnSub select
	Bout <= B when 0,
		not B when 1;

	-- 64 bit adder
	x0: entity work.Adder 
	port map(Aout, Bout, S, AddnSub, Cout, Ovfl);
	
	Zero <= nor S; 
	
	with ExtWord select
	Y <= S when 0,
	     (S(63 downto 32) <= (others => S(32))) when 1;	

	-- unsigned A less than B 
	AltBu <= not Cout;
	
	-- signed A less than B
	AltB <= S(N-1) xor Ovfl;
	
end architecture rtl;
