library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity roll_over is
    generic (
        count_to : INTEGER
    );
    port (
        reset : in STD_LOGIC;
        enable : in STD_LOGIC;
        clk : in STD_LOGIC;
        roll_out : out STD_LOGIC
    );
end entity roll_over;

architecture Behaviour of roll_over is
    signal count : integer range 0 to count_to;
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then 
                count <= 0;
                roll_out <= '0'; 
            elsif enable = '1' then
                if count = count_to then
                    count <= 0;
                    roll_out <= '1';
                else
                    count <= count + 1;
                    roll_out <= '0'; 
                end if;
            else
                count <= 0;
                roll_out <= '0';
            end if;
        end if;
    end process;
    
end architecture Behaviour;