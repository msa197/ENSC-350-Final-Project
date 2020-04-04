library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

entity Adder is
	generic (N : natural := 64);
	port (A, B : in	std_logic_vector(N-1 downto 0);
		Y : out std_logic_vector(N-1 downto 0);
		Cin : in std_logic;
		Cout, Ovfl : out std_logic);
end entity Adder;

architecture rtl of Adder is
signal g,p : std_logic_vector(N-1 downto 0);
signal C : std_logic_vector(N downto 0);
begin
	g <= A and B;
	p <= A xor B;
	C(0) <= Cin;

	carry: for i in N-1 downto 0 generate
	begin
		C(i+1) <= g(i) or (p(i) and C(i));
		Y(i) <= C(i) xor p(i);
	end generate carry;
	
	Cout <= C(N);
	Ovfl <= C(N) xor C(N-1);
end architecture rtl;


		