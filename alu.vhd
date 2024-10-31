library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
    port (
        clk : in STD_LOGIC;
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

    process (clk)
    begin
        if (rising_edge(clk)) then
            case op is
                when "000" =>
                    if (result = "00000000") then 
                        flags(0) <= '1';
                    else 
                        flags(0) <= '0';
                    end if;
            
                    flags(1) <= result(7);
                    flags(2) <= carry(8);
                    flags(3) <= carry(8) xor carry(7);
            
                    r <= result;
                when "001" =>
                    if (result = "00000000") then 
                        flags(0) <= '1';
                    else 
                        flags(0) <= '0';
                    end if;
            
                    flags(1) <= result(7);
                    flags(2) <= carry(8);
                    flags(3) <= carry(8) xor carry(7);

                    r <= result;
                when "010" =>
                    if (a_and_b = "00000000") then 
                        flags(0) <= '1';
                    else 
                        flags(0) <= '0';
                    end if;
            
                    flags(1) <= a_and_b(7);
                    flags(2) <= '0';
                    flags(3) <= '0';

                    r <= a_and_b;
                when "011" =>
                    if (a_or_b = "00000000") then 
                        flags(0) <= '1';
                    else 
                        flags(0) <= '0';
                    end if;
            
                    flags(1) <= a_or_b(7);
                    flags(2) <= '0';
                    flags(3) <= '0';

                    r <= a_or_b;
                when "100" =>
                    if (not_a = "00000000") then 
                        flags(0) <= '1';
                    else 
                        flags(0) <= '0';
                    end if;
            
                    flags(1) <= not_a(7);
                    flags(2) <= '0';
                    flags(3) <= '0';
                    
                    r <= not_a;
                when others =>
                    r <= "00000000";

                    flags(0) <= '0';
                    flags(1) <= '0';
                    flags(2) <= '0';
                    flags(3) <= '0';
            end case;
        end if;
    end process;    
end architecture Behaviour;