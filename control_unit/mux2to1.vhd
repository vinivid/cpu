library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux2to1 is
    generic (
        in_out_size : INTEGER := 8
    );
    port (
        selector : in STD_LOGIC;
        a : in STD_LOGIC_VECTOR(in_out_size - 1 downto 0);
        b : in STD_LOGIC_VECTOR(in_out_size - 1 downto 0);
        mux_out : out STD_LOGIC_VECTOR(in_out_size - 1 downto 0)  
    );
end entity mux2to1;

architecture Behaviour of mux2to1 is
begin
    
    mux_out <= a when selector = '0' else 
               b when selector = '1' else
               (others => '0');
    
end architecture Behaviour;