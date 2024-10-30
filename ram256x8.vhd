library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram256x8 is
	port (
		address : IN STD_LOGIC_VECTOR (7 downto 0) := "00000";
		clock : IN STD_LOGIC;
		data : IN STD_LOGIC_VECTOR (7 downto 0);
		wren : IN STD_LOGIC;
		q : OUT STD_LOGIc_VECTOR (7 downto 0)
	);
end entity ram256x8;

architecture Behaviour of ram256x8 is

type mem is array(0 to 255) of STD_LOGIC_VECTOR (7 downto 0);
signal mem_array : mem;

begin

process (clock)
begin
	if (rising_edge(clock)) then 
		if (wren = '1') then
			mem_array (to_integer(unsigned(address))) <= data;
		end if;
	end if;
end process;

q <= mem_array (to_integer(unsigned(address)));

end architecture;