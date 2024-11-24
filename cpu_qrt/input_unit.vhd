library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity input_unit is
    port (
        clk : in STD_LOGIC;
        send_push : in STD_LOGIC;
        inp : in STD_LOGIC_VECTOR(7 downto 0);
        go_next : out STD_LOGIC := '0';
        inp_v : out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity input_unit;

architecture Behaviour of input_unit is
    component roll_over is
        generic (
            count_to : INTEGER
        );
        port (
            reset : in STD_LOGIC;
            enable : in STD_LOGIC;
            clk : in STD_LOGIC;
            roll_out : out STD_LOGIC
        );
    end component;

    signal pushed : STD_LOGIC := '0';
    signal counted : STD_LOGIC := '0';
begin
    --Não é neccasrio fazer isso porém fica mais legivel o código geral
    inp_v <= inp;
    
    roll_counter: roll_over
     generic map(
        count_to => 4
    )
     port map(
        reset => send_push,
        enable => pushed,
        clk => clk,
        roll_out => counted
    );

    process (clk)
    begin
        if rising_edge(clk) then 
            if send_push = '1' then
                pushed <= '1';
            elsif counted = '1' then 
                pushed <= '0';
            end if;
        end if;
    end process;

    go_next <= counted;
    
end architecture Behaviour;