library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control_unit is
    port (
        instruction : in STD_LOGIC_VECTOR (7 downto 0);
        clk : in STD_LOGIC;
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

    signal op : STD_LOGIC_VECTOR (3 downto 0);

    signal bitmask : STD_LOGIC_VECTOR (14 downto 0);
    --Os e's representams se uma registradora estatra abilitada
    --Os enables tab�m ser�o a forma de de controlar quem recebe dado ou n�o numa opera��o de mov por exemple
    alias eA : STD_LOGIC is bitmask(14);
    alias eB : STD_LOGIC is bitmask(13);
    alias eR : STD_LOGIC is bitmask(12);

    --Enable das registradoras de flags
    alias eF : STD_LOGIC is bitmask(11);

    --Memory write enable � o bit q permite a ram ser escrita naquela endere�o
    alias Mwe : STD_LOGIC is bitmask(10);

    --� um bit q significa se a memoria sera endere�ada pelo program counter (0) ou pela propria mem�ria(1)
    alias addr : STD_LOGIC is bitmask(9);

    --Os i's representam se a registradora estara lendo de outra outra registradora (0) ou do input (1)
    alias iA : STD_LOGIC is bitmask(8);
    alias iB : STD_LOGIC is bitmask(7);
    --O iR � um pouco diferente pois nele tamb�m se abilita ler da ula (10)
    alias iR : STD_LOGIC is bitmask(6 downto 5);

    --Sao os dois bits que representam qual registradora q deve ser selecionada em uma instru��o em que xA � a operadora a a ser selecionada e
    --xB a segunda registradora (nas opera�oes que podem receber duas)
    alias xA : STD_LOGIC is bitmask(4 downto 3);
    alias xB : STD_LOGIC is bitmask(2 downto 1);

    --� o bit q representa q � um immidiate e tem q ir para o pr�ximo endere�o da memoria para saber o valor a somar
    alias imm : STD_LOGIC is bitmask(0);

    --O memory read enable esta implicitamente em selecionar a xB como 11 para q ele selecione q a registradora 
begin
    
    decoder_inst: decoder
     port map(
        instruction => instruction,
        op => op,
        reg_x1 => xA,
        reg_x2 => xB
    );
    
    --Em qualquer uma das opera��es da linha 1 (come�ando do when ) abaixo dessa n�o sera necessario abilitar a registradora pois ela n�o vai receber nada
    --A segunda linha representa as opera��es em que a registradora recebe algo LOAD STORE MOV IN
    --A terceira � o default
    eA <= '0' when (op = JMP or op = JEQ or op = JGR or op = WAITT or op = ADD or op = SUB or op = ANDD or op = ORR or op = NOTT or op = CMP or op = OUTT) else 
          '1' when xA = "00" else
          '0';
    
    --Essa registradora � igual a A
    eB <= '0' when (op = JMP or op = JEQ or op = JGR or op = WAITT or op = ADD or op = SUB or op = ANDD or op = ORR or op = NOTT or op = CMP or op = OUTT) else 
        '1' when xA = "01" else
        '0';
    
    --A difere�a da reg R para a A e B � que ela sempre recebera quando for opera��o da ULA q n seja o CMP
    --Um detalhe importante � de que a registradora de resultado n�o atualiza quando � um CMP, s� a registradora de flags
    --Na terceira linha novamente estara as opera��es de movimenta��o
    eR <= '0' when (op = JMP or op = JEQ or op = JGR or op = WAITT or op = CMP or op = OUTT) else
          '1' when (op = ADD or op = SUB or op = ANDD or op = ORR or op = NOTT) else
          '1' when xA = "10" else 
          '0';

    --As registradoras de flag s� estar�o ativadas quando for uma opera��o de ula ou uma opera��o de compara��o
    eF <= '1' when (op = ADD or op = SUB or op = ANDD or op = ORR or op = NOTT or op = CMP) else 
          '0';    
    
    --S� se escrevera numa posi��o da mem�ria quando for load
    Mwe <= '1' when op = LOAD else 
           '0'; 
    
    addr <= '1' when (op = LOAD or op = STORE) else 
            '0';
    
    --Para a iB elas s� receberam input qnd for a oper�ao for IN se n�o elas sempre receberam de outra registradora
    --TODO: colocar iA e iB para um unico sinal
    iA <= '1' when op = INN else 
          '0';
    
    iB <= '1' when op = INN else 
          '0';
    
    --iR s� recebera input quando for 01 recebera o valor da ula quando for 10 e de resto sempre recebera o valor de outra registradora
    iR <= "01" when op = INN else
          "10" when (op = ADD or op = SUB or op = ANDD or op = ORR or op = NOTT) else 
          "00"; 
        
    --S� sera um valor imediato quando xB for 11 pois foi o especificado pela ISA
    imm <= '1' when xB = "11" else 
           '0';

    process (clk)
        type cpu_stages is (FETCH, DECODE_IMIDIATE, DECODE_LOAD_STORE, EXECUTE);
        variable 
    begin
        if rising_edge(clk) then

        end if;    
    end process;

end architecture Behaviour;