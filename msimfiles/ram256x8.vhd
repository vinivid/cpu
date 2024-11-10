LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;

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

	impure function read_mem return memory is 
		file text_file : text open read_mode is "programa.hex";
		variable ram_content : memory;
		variable text_line : line;
	begin
		for i in 0 to 255 loop
			readline(text_file, text_line);
			hread(text_line, ram_content(i));
		end loop;
		  
		return ram_content;
	end function;

	signal mem : memory := read_mem;
begin

	process (clk)
	begin
		if rising_edge(clk) then
			if Mwe = '1' then
				mem(to_integer(unsigned(address))) <= data;			
			end if;
		end if;
	end process;

	q <= mem(to_integer(unsigned(address)));
end Behaviour;