library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux4to1 is
    generic (
        in_out_size : INTEGER := 8
    );
    port (
        selector : in STD_LOGIC_VECTOR(1 downto 0);
        a : in STD_LOGIC_VECTOR(in_out_size - 1 downto 0);
        b : in STD_LOGIC_VECTOR(in_out_size - 1 downto 0);
        c : in STD_LOGIC_VECTOR(in_out_size - 1 downto 0);
        d : in STD_LOGIC_VECTOR(in_out_size - 1 downto 0);
        mux_out : out STD_LOGIC_VECTOR(in_out_size - 1 downto 0) 
    );
end entity mux4to1;

architecture Behaviour of mux4to1 is
begin

    mux_out <= a when selector = "00" else 
               b when selector = "01" else 
               c when selector = "10" else 
               d when selector = "11" else
               (others => '0');
                                    
end architecture Behaviour;