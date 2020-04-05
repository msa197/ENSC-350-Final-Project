library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_misc.all;

entity ArithUnit is
		generic (N : natural := 64);
		port (
				A, B				:	in	std_logic_vector(N-1 downto 0);
				NotA, AddnSub, ExtWord		:	in	std_logic;
				AltBu, AltB 			:	out 	std_logic;
				Y				:	out	std_logic_vector(N-1 downto 0);
				Cout, Ovfl, Zero		:	out 	std_logic);
end entity ArithUnit;


architecture rtl of ArithUnit is 
signal Aout, Bout, S : std_logic_vector(N-1 downto 0);
signal C, O : std_logic;
begin
	with NotA select 
	Aout <= A when '0', 
		not A when others;

	with AddnSub select
	Bout <= B when '0',
		not B when others;

	-- 64 bit adder
	x0: entity work.Adder 
	port map(Aout, Bout, S, AddnSub, C, O);
	
	Zero <= nor_reduce(S); 
	Cout <= C;
	Ovfl <= O;

	with ExtWord select
	Y <= S when '0',
	     (1 to 32 => S(31)) & S(31 downto 0) when others;	
	
	-- unsigned A less than B 
	AltBu <= not C;
	
	-- signed A less than B
	AltB <= S(N-1) xor O;
	
end architecture rtl;
