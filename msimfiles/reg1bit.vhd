library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg1bit is
    port (
        clk : in STD_LOGIC;
        enable : in STD_LOGIC;
        reset : in STD_LOGIC;
        d : in STD_LOGIC;
        q : out STD_LOGIC
    );
end entity reg1bit;

architecture Behaviour of reg1bit is
begin

    process (clk)
    begin
        if (rising_edge(clk)) then
            if (reset = '1') then
                q <= '0';
            elsif (enable = '1') then 
                q <= d;
            end if;
        end if;
    end process;

end architecture Behaviour;