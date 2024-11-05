library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux is
    port (
        sel : in STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
        a : in STD_LOGIC;
        b : in STD_LOGIC;
        c : in STD_LOGIC;
        d : in STD_LOGIC;
        selected : out STD_LOGIC 
    );
end entity mux;

architecture Behaviour of mux is
begin

    selected <= a when sel = "00" else 
                b when sel = "01" else 
                c when sel = "10" else 
                d when sel = "11" else
                '1';
                                    
end architecture Behaviour;