library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
    generic (
        modulo : INTEGER := 4;
        max : INTEGER := 4;
        min : INTEGER := 0
    );
    port (
        clk : in STD_LOGIC;
        enable : in STD_LOGIC;
        reset : in STD_LOGIC;
        roll_over : out STD_LOGIC;
        counter : buffer INTEGER range min to max := min
    );
end entity;

architecture Behaviour of counter is
begin
    process (clk, reset)
    begin
        if (reset =  '1') then
            roll_over <= '0';
            counter <= min;
        elsif (rising_edge(clk)) then
            if (enable = '1') then
                roll_over <= '0';
                if (counter = modulo) then
                    roll_over <= '1'; 
                    counter <= min;
                else 
                    counter <= counter + 1;
                end if;
            else
                roll_over <= '0';
                counter <= counter;
        end if;
    end if;
    end process; 
end architecture;