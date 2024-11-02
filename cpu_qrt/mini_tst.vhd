library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mini_tst is
    port (
        ac : in STD_LOGIC_VECTOR (2 downto 0);
        enable : in STD_LOGIC;
        q : out STD_LOGIC_VECTOR (2 downto 0)
    );
end entity mini_tst;

architecture Behaviour of mini_tst is
begin
    q <= ac when enable = '1' else
        "100" when enable = '1';
end architecture Behaviour;