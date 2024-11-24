library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decoder is
    port (
        instruction : in STD_LOGIC_VECTOR (7 downto 0);
        op : out STD_LOGIC_VECTOR (3 downto 0);
        reg_x1 : out STD_LOGIC_VECTOR (1 downto 0);
        reg_x2 : out STD_LOGIC_VECTOR (1 downto 0)
    );
end entity decoder;

architecture Behaviour of decoder is
begin

    op <= instruction (7 downto 4);    
    reg_x1 <= instruction(3 downto 2);
    reg_x2 <= instruction (1 downto 0);

end architecture Behaviour;