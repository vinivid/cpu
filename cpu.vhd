library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cpu is
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC       
    );
end entity cpu;

architecture Behaviour of cpu is
    component control_unit is
        port (
            instruction : in STD_LOGIC_VECTOR (7 downto 0);
            clk : in STD_LOGIC;
            control_mask : out STD_LOGIC_VECTOR (16 downto 0)
        );
    end component;

    component pc is
        port (
            clk : in STD_LOGIC;
            enable : in STD_LOGIC;
            reset : in STD_LOGIC;
            jump_enable : in STD_LOGIC;
            jump_addres : in STD_LOGIC_VECTOR(7 downto 0);
            adrres_out : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component ram256x8 is
        port (
            address	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            clk : IN STD_LOGIC;
            data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            Mwe : IN STD_LOGIC;
            q : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
        );
    end component;

    component reg is
        generic (
            number_of_bits : INTEGER := 8
        );
        port (
            clk : in STD_LOGIC;
            enable : in STD_LOGIC;
            reset : in STD_LOGIC;
            d : in STD_LOGIC_VECTOR (number_of_bits - 1 downto 0);
            q : out STD_LOGIC_VECTOR (number_of_bits - 1 downto 0)
        );
    end component;

    signal control : STD_LOGIC_VECTOR(16 downto 0);
    signal address : STD_LOGIC_VECTOR(7 downto 0);
    signal value_from_mem : STD_LOGIC_VECTOR(7 downto 0);
    signal IR_val : STD_LOGIC_VECTOR(7 downto 0);
begin
    
    cu: control_unit
     port map(
        instruction => IR_val,
        clk => clk,
        control_mask => control
    );

    ram256x8_main: ram256x8
     port map(
        address => address,
        clk => clk,
        data => "00000000",
        Mwe => '0',
        q => value_from_mem
    );

    program_counter: pc
     port map(
        clk => clk,
        enable => control(16),
        reset => reset,
        jump_enable => '0',
        jump_addres => "00000000",
        adrres_out => address
    );

    IR: reg
     generic map(
        number_of_bits => 8
    )
     port map(
        clk => clk,
        enable => control(15),
        reset => '0',
        d => value_from_mem,
        q => IR_val
    );
    
end architecture Behaviour;