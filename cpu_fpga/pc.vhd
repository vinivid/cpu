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
    signal count_buffer : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
begin

    --Não é necessario que o program counter esteja abilitado para que ele de um jump
    --Isso facilita mais na unidade de controle
    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then 
                count_buffer <= (others => '0');
            elsif jump_enable = '1' then 
                count_buffer <= jump_addres;
            elsif enable = '1'  then
                count_buffer <= std_logic_vector(unsigned(count_buffer) + 1);
            end if;
        end if;
    end process;

    adrres_out <= count_buffer;
    
end architecture Behaviour;