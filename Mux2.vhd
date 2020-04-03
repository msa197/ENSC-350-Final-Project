library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

entity Mux2 is
		generic (width : integer := 64);
		port (
				SEL : in std_logic;
				D0 : in std_logic_vector(width-1 downto 0);
				D1	: in std_logic_vector(width-1 downto 0);
				Y : out std_logic_vector(width-1 downto 0);
end entity Mux2;



architecture Behavioral of Mux2 is 

begin 
	Y <= D0 when (SEL = '0') else D1;
end Behavioral
