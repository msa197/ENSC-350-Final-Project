library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

entity ArithUnit is
		generic (width : integer := 64);
		port (
				A, B				:	in	std_logic_vector(width-1 downto 0);
				NotA, AddSub, ExtWord		:	in	std_logic;
				AltBu, AltB 			:	out 	std_logic;
				Y				:	out	std_logic_vector(width-1 downto 0));
end entity ArithUnit;


architecture rtl of ArithUnit is 
signal Aout, Bout, S : std_logic_vector(width-1 downto 0);
signal C : std_logic_vector(width downto 0);
signal Cin, Ovfl, Cout, Zero : std_logic;
begin
	Aout <= (A and not NotA) or (not A and NotA);
	Bout <= (B and not AddSub) or (not B and AddSub);
	Cin <= AddSub;
	x0: entity work.Adder 
	port map(A, B, S, Cin, Cout, Ovfl);
	
	Zero <= S(width-1 downto 0) nor S(width-1 downto 0); -- not sure if this is correct, 64 bit input NOR
	
	Y <= (S and not ExtWord) or (not s and ExtWord);-- not sure what to do with the sign extension
	
	-- unsigned A less than B 
	if (Zero==1) then 
		AltBu=0;
	elseif (Cout==0) then
		AltBu=0;
	else 
		AltBu=1;
	end if;
	
	-- signed A less than B
	if (Zero==1) then 
		AltB=0;
	elseif (Ovfl==0) then
		AltB=0;
	else 
		AltB=1;
	end if;
	
	
end architecture rtl;
