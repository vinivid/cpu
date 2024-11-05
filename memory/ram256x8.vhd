LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity ram256x8 is
	port
	(
		address	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock : IN STD_LOGIC  := '1';
		data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren : IN STD_LOGIC ;
		q : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
end ram256x8;


architecture Behaviour OF ram256x8 is
begin

end Behaviour;