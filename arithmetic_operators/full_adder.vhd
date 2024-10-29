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
    signal first_xor : STD_LOGIC;
    signal x1_c_and : STD_LOGIC;
    signal a_b_and : STD_LOGIC;
begin
    
    first_xor <= a xor b;
    x1_c_and <= first_xor and cin;
    a_b_and <= a and b;

    q <= first_xor xor cin;
    cout <= first_xor or a_b_and;
    
end architecture Behaviour;