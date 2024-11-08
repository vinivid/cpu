LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram256x8 is
	port
	(
		address	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clk : IN STD_LOGIC;
		data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		Mwe : IN STD_LOGIC;
		q : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
end ram256x8;

architecture Behaviour OF ram256x8 is
	type memory is array(0 to 255) of STD_LOGIC_VECTOR(7 downto 0);
	signal mem : memory;
begin

	process (clk)
	begin
		if rising_edge(clk) then
			if Mwe = '1' then
				mem(to_integer(unsigned(address))) <= data;
			else 
				q <= mem(to_integer(unsigned(address)));			
			end if;
		end if;
	end process;
end Behaviour;