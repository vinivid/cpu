library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decoder is
    port (
        instruction : in STD_LOGIC_VECTOR (7 downto 0);
        enable : in STD_LOGIC;
        op : out STD_LOGIC_VECTOR (3 downto 0);
        reg_x1 : out STD_LOGIC_VECTOR (1 downto 0);
        reg_x2 : out STD_LOGIC_VECTOR (1 downto 0);
        imidiate : out STD_LOGIC
    );
end entity decoder;

architecture Behaviour of decoder is
    constant ADD   : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    constant SUB   : STD_LOGIC_VECTOR (3 downto 0) := "0001";
    constant ANDD  : STD_LOGIC_VECTOR (3 downto 0) := "0010";
    constant ORR   : STD_LOGIC_VECTOR (3 downto 0) := "0011";
    constant NOTT  : STD_LOGIC_VECTOR (3 downto 0) := "0100";
    constant CMP   : STD_LOGIC_VECTOR (3 downto 0) := "0101";
    constant JMP   : STD_LOGIC_VECTOR (3 downto 0) := "0110";
    constant JEQ   : STD_LOGIC_VECTOR (3 downto 0) := "0111";
    constant JGR   : STD_LOGIC_VECTOR (3 downto 0) := "1000";
    constant LOAD  : STD_LOGIC_VECTOR (3 downto 0) := "1001";
    constant STORE : STD_LOGIC_VECTOR (3 downto 0) := "1010";
    constant MOV   : STD_LOGIC_VECTOR (3 downto 0) := "1011";
    constant INN   : STD_LOGIC_VECTOR (3 downto 0) := "1100";
    constant OUTT  : STD_LOGIC_VECTOR (3 downto 0) := "1101";
    constant WAITT : STD_LOGIC_VECTOR (3 downto 0) := "1110";

    signal operation : STD_LOGIC_VECTOR (3 downto 0);
begin
    op <= instruction (7 downto 4) when enable = '1';
    operation <= instruction (7 downto 4) when enable = '1';
    
    reg_x1 <= "11" when (operation = JMP or operation = JEQ or operation = JGR or operation = WAITT) and enable = '1' else 
              instruction (3 downto 2) when enable = '1';
    
    reg_x2 <= instruction (1 downto 0) when (operation = NOTT or operation = INN or operation = OUTT) and enable = '1' else 
              "11" when enable = '1';
    
    imidiate <= '0' when (operation =  NOTT or operation = INN or operation = OUTT) and enable = '1' else 
                instruction(0) when enable = '1';
    
end architecture Behaviour;