library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--A unica diferença da unidade de output para uma registradora é que a unidade
--de output é inicializada com 0
entity output_unit is
    port (
        output_enable : in STD_LOGIC;
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        data_to_output : in STD_LOGIC_VECTOR (7 downto 0);
        data_output : OUT STD_LOGIC_VECTOR (7 downto 0)
    );
end entity output_unit;

architecture Behaviour of output_unit is
    --É a registradora que guarda o dado que deve ser mostrado nas leds
    signal data : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
begin

    process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                data <= (others => '0');
            elsif output_enable = '1'  then
                data <= data_to_output;
            end if;
        end if;        
    end process;

    data_output <= data;
    
end architecture Behaviour;