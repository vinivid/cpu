library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
    port (
        a : in STD_LOGIC_VECTOR (7 downto 0);
        b : in STD_LOGIC_VECTOR (7 downto 0);
        op : in STD_LOGIC_VECTOR (2 downto 0);
        r : out STD_LOGIC_VECTOR (7 downto 0);
        flags : out STD_LOGIC_VECTOR (3 downto 0)
    );
end entity alu;

architecture Behaviour of alu is
    component adder_sub is
        port (
            a : in STD_LOGIC;
            b : in STD_LOGIC;
            cin : in STD_LOGIC;
            a_b : in STD_LOGIC;
            q : out STD_LOGIC;
            cout : out STD_LOGIC
        );
    end component;

    signal carry : STD_LOGIC_VECTOR (8 downto 0) := (others => '0');
    signal result : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal a_and_b : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal a_or_b : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal not_a : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');  
begin
    --A operação de subtração tem o ultimo bit 1
    --O somador subtrator fica no modo subtração quando é o sinal 1 de operação
    --Portanto podemos colocar o primeiro sinal do carry como 1 e o modo do somador subtrator
    --como o primeiro bit da operação 
    carry(0) <= op(0);

    ads : for i in 0 to 7 generate
        adsx: adder_sub
         port map(
            a => a(i),
            b => b(i),
            cin => carry(i),
            a_b => op(0),
            q => result(i),
            cout => carry(i + 1)
        );
    end generate;

    a_and_b <= a and b;
    a_or_b <= a or b;
    not_a <= not a;

    r <= result when (op = "000" or op = "001") else 
         a_and_b when (op = "010") else 
         a_or_b when (op = "011") else 
         not_a when (op = "100") else 
         "00000000";
    
    flags(0) <= '1' when ( (op = "000" or op = "001") and result = "00000000") else 
                '1' when (op = "010" and result = "00000000") else 
                '1' when (op = "011" and result = "00000000") else 
                '1' when (op = "100" and result = "00000000") else 
                '0';
    
    flags(1) <= result(7) when (op = "000" or op = "001") else 
                a_and_b(7) when (op = "010") else 
                a_or_b(7) when (op = "011") else 
                not_a(7) when (op = "100") else 
                '0'; 
    
    flags(2) <= carry(8) when (op = "000" or op = "001") else
                '0';
    
    flags(3) <= carry(8) xor carry(7) when (op = "000" or op = "001") else
                '0';
    
end architecture Behaviour;