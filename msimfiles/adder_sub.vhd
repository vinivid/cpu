library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder_sub is
    port (
        a : in STD_LOGIC;
        b : in STD_LOGIC;
        cin : in STD_LOGIC;
        a_b : in STD_LOGIC;
        q : out STD_LOGIC;
        cout : out STD_LOGIC
    );
end entity adder_sub;

architecture Behaviour of adder_sub is
    --t_b é o verdadeiro b que sera utilizado na soma/subtração
    --Ele é necessario para o xor de quando for subtração
    signal t_b : STD_LOGIC;
    signal a_xor_b : STD_LOGIC;
    signal axb_and_cin : STD_LOGIC;
    signal a_and_b : STD_LOGIC;
begin
    t_b <= b xor a_b;

    a_xor_b <= a xor t_b;
    axb_and_cin <= a_xor_b and cin;
    a_and_b <= a and t_b;

    q <= a_xor_b xor cin;
    cout <= axb_and_cin or a_and_b;
    
end architecture Behaviour;