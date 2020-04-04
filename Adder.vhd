library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

entity BLAN is
	generic (N : natural := 64);
	port( Gi,Pi : in std_logic_vector(N-1 downto 0);
		Go,Po : out std_logic_vector(N-1 downto 0));
end entity BLAN;

architecture BrentKung of BLAN is
signal recurGi,recurPi : std_logic_vector(N/2-1 downto 0);
signal recurGo,recurPo : std_logic_vector(N/2-1 downto 0);
begin
	RecurCase: if (N>2) generate
		Go(0) <= Gi(0);
		Po(0) <= Pi(0);

		UpperMerge: for i in N/2-1 downto 0 generate
		begin
			recurGi(i) <= Gi(i*2+1) or (Pi(i*2+1) and Gi(i*2));
			recurPi(i) <= Pi(i*2+1) and Pi(i*2);
		end generate UpperMerge;

		recur: entity work.BLAN(BrentKung)
		generic map (N/2)
		port map (recurGi,recurPi,recurGo,recurPo);

		LowerMerge: for i in N/2-2 downto 0 generate
		begin
			Go(i*2+2) <= Gi(i*2+2) or (Pi(i*2+2) and recurGo(i));
			Go(i*2+1) <= recurGo(i);
			Po(i*2+2) <= Pi(i*2+2) and recurPo(i);
			Po(i*2+1) <= recurPo(i);
		end generate LowerMerge;

		Go(N-1) <= recurGo(N/2-1);
		Po(N-1) <= recurPo(N/2-1);
	end generate RecurCase;

	BaseCase: if (N=2) generate
		Go(0) <= Gi(0);
		Po(0) <= Pi(0);
		Go(1) <= Gi(1) or (Pi(1) and Gi(0));
		Po(1) <= Pi(1) and Pi(0);
	end generate BaseCase;
end architecture BrentKung;

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

architecture structural of Adder is
signal gi, pi, go, po : std_logic_vector(N-1 downto 0);
signal C : std_logic_vector(N downto 0);
begin
	gi <= A and B;
	pi <= A xor B;
	C(0) <= Cin;

	BLAnet: entity work.BLAN(BrentKung)
	port map(gi,pi,go,po);

	output: for i in N-1 downto 0 generate
	begin
		C(i+1) <= go(i) or (po(i) and C(0));
		Y(i) <= C(i) xor pi(i);
	end generate output;
	
	Cout <= C(N);
	Ovfl <= C(N) xor C(N-1);
end architecture structural;


		