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
    signal add_sub : STD_LOGIC := '0';
begin
    --Como a instrução de subtração é em 1 podemos colocar a operação como o primeiro bit da operação ja q
    --Ela vai ser feita de qualquer forma
    add_sub <= op(0);

    ads : for i in 0 to 7 generate
        adsx: adder_sub
         port map(
            a => a(i),
            b => b(i),
            cin => carry(i),
            a_b => add_sub,
            q => result(i),
            cout => carry(i + 1)
        );
    end generate;

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
            
                    flags(1) <= '0';
                    flags(2) <= '0';
                    flags(3) <= '0';
            
                    r <= result;
                when "001" =>
                    if (result = "00000000") then 
                        flags(0) <= '1';
                    else 
                        flags(0) <= '0';
                    end if;
            
                    flags(1) <= '0';
                    flags(2) <= '0';
                    flags(3) <= '0';

                    r <= result;
                when others =>
                    r <= "00000000";
            end case;
        end if;
    end process;    
end architecture Behaviour;