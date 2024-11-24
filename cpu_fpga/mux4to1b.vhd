library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux4to1b is
    port (
        selector : in STD_LOGIC_VECTOR (1 downto 0);
        a : in STD_LOGIC;
        b : in STD_LOGIC;
        c : in STD_LOGIC;
        d : in STD_LOGIC;
        mux_out : out STD_LOGIC
    );
end entity mux4to1b;

architecture Behaviour of mux4to1b is
begin

    mux_out <= a when selector = "00" else 
               b when selector = "01" else 
               c when selector = "10" else 
               d when selector = "11" else
               '0';
                                    
end architecture Behaviour;