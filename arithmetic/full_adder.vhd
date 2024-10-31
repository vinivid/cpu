library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity full_adder is
    port (
        a : in STD_LOGIC;
        b : in STD_LOGIC;
        cin : in STD_LOGIC;
        q : out STD_LOGIC;
        cout : out STD_LOGIC
    );
end entity full_adder;

architecture Behaviour of full_adder is
    signal a_b_xor : STD_LOGIC;
    signal xor1_cin : STD_LOGIC;
    signal a_b_and : STD_LOGIC;
begin
    
    a_b_xor <= a xor b;
    xor1_cin <= xor1_cin and cin;
    a_b_and <= a and b;

    q <= a_b_xor xor cin;
    cout <= 
    
end architecture Behaviour;