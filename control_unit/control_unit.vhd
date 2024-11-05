library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control_unit is
    port (
        instruction : in STD_LOGIC_VECTOR (7 downto 0);
        control_mask : out STD_LOGIC_VECTOR (17 downto 0)
    );
end entity control_unit;

architecture Behaviour of control_unit is
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

    component decoder is
        port (
            instruction : in STD_LOGIC_VECTOR (7 downto 0);
            op : out STD_LOGIC_VECTOR (3 downto 0);
            reg_x1 : out STD_LOGIC_VECTOR (1 downto 0);
            reg_x2 : out STD_LOGIC_VECTOR (1 downto 0)
        );
    end component;

    signal operation : STD_LOGIC_VECTOR (3 downto 0);
    signal reg1 : STD_LOGIC_VECTOR (1 downto 0);
    signal reg2 : STD_LOGIC_VECTOR (1 downto 0);
    signal out_op : STD_LOGIC_VECTOR (7 downto 0);

    signal bitmask : STD_LOGIC_VECTOR (11 downto 0);
    --Os i's representam se uma das 3 registradoras receberam os dados q estavam na memomoria ram
    alias iA : STD_LOGIC is bitmask(11);
    alias iB : STD_LOGIC is bitmask(10);
    alias iR : STD_LOGIC is bitmask(11);

    --Os e's representams se uma registradora estatra abilitada
    alias eA : STD_LOGIC is bitmask(10);
    alias eB : STD_LOGIC is bitmask(9);
    alias eR : STD_LOGIC is bitmask(8);

    --Memory write enable é o bit q permite a ram ser escrita naquela endereço
    alias Mwe : STD_LOGIC is bitmask(7);
    --Memory write select sao os dois bits q selecionam qual registradora sera lida para o write

    --Sao os dois bits que representam qual registradora q deve ser selecionada em uma instrução em que xA é a operadora a a ser selecionada e
    --xB a segunda registradora (nas operaçoes que podem receber duas)
    alias xA : STD_LOGIC is bitmask(4 downto 3);
    alias xB : STD_LOGIC is bitmask(2 downto 1);

    --É o bit q representa q é um immidiate e tem q ir para o próximo endereço da memoria para saber o valor a somar
    alias imm : STD_LOGIC is bitmask(0);
begin
    
    decoder_inst: decoder
     port map(
        instruction => out_op,
        op => operation,
        reg_x1 => reg1,
        reg_x2 => reg2
    );

    
    
end architecture Behaviour;