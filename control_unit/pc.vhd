library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pc is
    port (
        clk : in STD_LOGIC;
        enable : in STD_LOGIC;
        reset : in STD_LOGIC;
        jump_enable : in STD_LOGIC;
        jump_addres : in STD_LOGIC_VECTOR(7 downto 0);
        adrres_out : out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity pc;

architecture Behaviour of pc is
    signal count_buffer : STD_LOGIC_VECTOR(7 downto 0);
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if enable = '1'  then
                if jump_enable = '1' then 
                    count_buffer <= jump_addres;
                else
                    count_buffer <= std_logic_vector(unsigned(count_buffer) + 1);
                end if;
            elsif reset = '1' then 
                count_buffer <= (others => '0');
            end if;
        end if;
    end process;

    adrres_out <= count_buffer;
    
end architecture Behaviour;