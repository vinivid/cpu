library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg is
    generic (
        number_of_bits : INTEGER := 8
    );
    port (
        clk : in STD_LOGIC;
        enable : in STD_LOGIC;
        reset : in STD_LOGIC;
        d : in STD_LOGIC_VECTOR (number_of_bits - 1 downto 0);
        q : out STD_LOGIC_VECTOR (number_of_bits - 1 downto 0)
    );
end entity reg;

architecture Behaviour of reg is
begin

    process (clk)
    begin
        if (rising_edge(clk)) then
            if (reset = '1') then
                q <= (others => '0');
            elsif (enable = '1') then 
                q <= d;
            end if;
        end if;
    end process;

end architecture Behaviour;