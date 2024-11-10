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
    component mux2to1 is
        generic (
            in_out_size : INTEGER := 8
        );
        port (
            selector : in STD_LOGIC;
            a : in STD_LOGIC_VECTOR(in_out_size - 1 downto 0);
            b : in STD_LOGIC_VECTOR(in_out_size - 1 downto 0);
            mux_out : out STD_LOGIC_VECTOR(in_out_size - 1 downto 0)  
        );
    end component;

    component mux4to1 is
        generic (
            in_out_size : INTEGER := 8
        );
        port (
            selector : in STD_LOGIC_VECTOR(1 downto 0);
            a : in STD_LOGIC_VECTOR(in_out_size - 1 downto 0);
            b : in STD_LOGIC_VECTOR(in_out_size - 1 downto 0);
            c : in STD_LOGIC_VECTOR(in_out_size - 1 downto 0);
            d : in STD_LOGIC_VECTOR(in_out_size - 1 downto 0);
            mux_out : out STD_LOGIC_VECTOR(in_out_size - 1 downto 0) 
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

    component control_unit is
        port (
            instruction : in STD_LOGIC_VECTOR (7 downto 0);
            clk : in STD_LOGIC;
            control_mask : out STD_LOGIC_VECTOR (18 downto 0)
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

    component alu is
        port (
            a : in STD_LOGIC_VECTOR (7 downto 0);
            b : in STD_LOGIC_VECTOR (7 downto 0);
            op : in STD_LOGIC_VECTOR (2 downto 0);
            r : out STD_LOGIC_VECTOR (7 downto 0);
            flags : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    component reg1bit is
        port (
            clk : in STD_LOGIC;
            enable : in STD_LOGIC;
            reset : in STD_LOGIC;
            d : in STD_LOGIC;
            q : out STD_LOGIC
        );
    end component;

    --Barramentos da cpu
    --É o barramento do endereço que esta saindo do program counter
    signal pc_address : STD_LOGIC_VECTOR(7 downto 0);
    --É o barramento do valor da instruction register
    signal IR_val : STD_LOGIC_VECTOR(7 downto 0);
    --Os seguintes são os barramentos dos dados das registradoras
    signal A_val : STD_LOGIC_VECTOR(7 downto 0);
    signal B_val : STD_LOGIC_VECTOR(7 downto 0);
    signal R_val : STD_LOGIC_VECTOR(7 downto 0);
    --É o barramento do valor que sai da memória
    signal MEM_val : STD_LOGIC_VECTOR(7 downto 0);

    --Sinal da unidade de input
    signal INPUT_val : STD_LOGIC_VECTOR(7 downto 0);

    --Os seguintes são os valores intermediarios do MUX de seleção de cada componente
    signal A_mux_data_select : STD_LOGIC_VECTOR(7 downto 0);
    signal A_mux_data_or_input : STD_LOGIC_VECTOR(7 downto 0);
    signal B_mux_data_select : STD_LOGIC_VECTOR(7 downto 0);
    signal B_mux_data_or_input : STD_LOGIC_VECTOR(7 downto 0);
    signal R_mux_data_select : STD_LOGIC_VECTOR(7 downto 0);
    --A registradora R possui além de ser input ou data também tem opção da ula
    signal R_mux_dat_inp_ula : STD_LOGIC_VECTOR(7 downto 0);

    --Esses sinais são os inputs da ULA depois de serem selecionados pelo mux
    signal ALU_input_a : STD_LOGIC_VECTOR(7 downto 0);
    signal ALU_input_b : STD_LOGIC_VECTOR(7 downto 0);
    --Saida da ULA
    signal ALU_out : STD_LOGIC_VECTOR(7 downto 0);
    signal ALU_flag_out : STD_LOGIC_VECTOR(3 downto 0);
    
    alias ZERO_flag : STD_LOGIC is ALU_flag_out(0);
    alias SIGN_flag : STD_LOGIC is ALU_flag_out(1);
    alias CARRY_flag : STD_LOGIC is ALU_flag_out(2);
    alias OVERFLOW_flag : STD_LOGIC is ALU_flag_out(3);

    signal ZERO_flag_out : STD_LOGIC;
    signal SIGN_flag_out : STD_LOGIC;
    signal CARRY_flag_out : STD_LOGIC;
    signal OVERFLOW_flag_out : STD_LOGIC;

    --O barramento de controle abilita e seleciona as registradoras e ula dependendo da instrução com base na bitmask feita na unidade de controle
    signal bitmask : STD_LOGIC_VECTOR (18 downto 0);

    --É a operação a ser feita na ula, mesmo se n for uma operação de ula não trara erros pois as registradoras e outros estarão dewsabilitados
    alias alu_select : STD_LOGIC_VECTOR is bitmask(18 downto 15);

    --Os e's representams se uma registradora estatra abilitada
    --Os enables tabém serão a forma de de controlar quem recebe dado ou não numa operação de mov por exemple
    alias ePC : STD_LOGIC is bitmask(14);
    alias eIR : STD_LOGIC is bitmask(13);
    alias eA : STD_LOGIC is bitmask(12);
    alias eB : STD_LOGIC is bitmask(11);
    alias eR : STD_LOGIC is bitmask(10);

    --Enable das registradoras de flags
    alias eF : STD_LOGIC is bitmask(9);

    --Memory write enable é o bit q permite a ram ser escrita naquela endereço
    alias Mwe : STD_LOGIC is bitmask(8);

    --É um bit q significa se a memoria sera endereçada pelo program counter (0) ou pela propria memória(1)
    alias addr : STD_LOGIC is bitmask(7);

    --Os i's representam se a registradora estara lendo de outra outra registradora (0) ou do input (1)
    alias inp_reg : STD_LOGIC is bitmask(6);

    --O iR é um pouco diferente pois nele também se abilita ler da ula (10)
    alias iR : STD_LOGIC_VECTOR is bitmask(5 downto 4);

    --Sao os dois bits que representam qual registradora q deve ser selecionada em uma instrução em que xA é a operadora a a ser selecionada e
    --xB a segunda registradora (nas operaçoes que podem receber duas)
    alias xA : STD_LOGIC_VECTOR is bitmask(3 downto 2);
    alias xB : STD_LOGIC_VECTOR is bitmask(1 downto 0);
begin
    
    ---------------------------------------------------------------------
    -----------------UNIDADE DE CONTROLE---------------------------------
    ---------------------------------------------------------------------

    cu: control_unit
     port map(
        instruction => IR_val,
        clk => clk,
        control_mask => bitmask
    );

    program_counter: pc
     port map(
        clk => clk,
        enable => ePC,
        reset => reset,
        jump_enable => '0',
        jump_addres => "00000000",
        adrres_out => pc_address
    );
    
    ---------------------------------------------------------------------
    -----------------REGISTRADORAS---------------------------------------
    ---------------------------------------------------------------------
    
    --Instruction register que recebe diretamente da ram controlada pelo program counter
    instruction_register: reg
    generic map(
       number_of_bits => 8
    )
    port map(
       clk => clk,
       enable => eIR,
       reset => reset,
       d => MEM_val,
       q => IR_val
    );

    --Registradora a em que ela recebe como dado o bus selecionado pelo mux de A
    --O xB seleciona qual data path sera selecionado
    --E o inp_reg ira selecionar se o valor vindo e de um dos caminhos de dado do barramento ou da unidade de input
    A_data_mux: mux4to1
     generic map(
        in_out_size => 8
    )
     port map(
        selector => xB,
        a => A_val,
        b => B_val,
        c => R_val,
        d => MEM_val,
        mux_out => A_mux_data_select
    );

    A_data_or_insert_mux: mux2to1
     generic map(
        in_out_size => 8
    )
     port map(
        selector => inp_reg,
        a => A_mux_data_select,
        b => INPUT_val,
        mux_out => A_mux_data_or_input
    );

    A_reg: reg
     generic map(
        number_of_bits => 8
    )
     port map(
        clk => clk,
        enable => eA,
        reset => reset,
        d => A_mux_data_or_input,
        q => A_val
    );
    
    --A registradora tem o mesmo comportamento da A
    B_data_mux: mux4to1
    generic map(
       in_out_size => 8
    )
    port map(
       selector => xB,
       a => A_val,
       b => B_val,
       c => R_val,
       d => MEM_val,
       mux_out => B_mux_data_select
    );
    

    B_data_or_insert_mux: mux2to1
    generic map(
       in_out_size => 8
    )
    port map(
       selector => inp_reg,
       a => B_mux_data_select,
       b => INPUT_val,
       mux_out => B_mux_data_or_input
    );
   
    B_reg: reg
    generic map(
       number_of_bits => 8
    )
    port map(
       clk => clk,
       enable => eB,
       reset => reset,
       d => B_mux_data_or_input,
       q => B_val
    );
    
    --A registradora R é analoga as outras duas tendo de diferença a registradora de selecion
    --Qual sera o input (bus de dados ou input ou ula)
    R_data_mux: mux4to1
    generic map(
       in_out_size => 8
    )
    port map(
       selector => xB,
       a => A_val,
       b => B_val,
       c => R_val,
       d => MEM_val,
       mux_out => R_mux_data_select
    );
    
    R_data_input_alu: mux4to1
     generic map(
        in_out_size => 8
    )
     port map(
        selector => iR,
        a => R_mux_data_select,
        b => INPUT_val,
        c => ALU_out,
        d => "00000000",
        mux_out => R_mux_dat_inp_ula
    );
   
    R_reg: reg
    generic map(
       number_of_bits => 8
    )
    port map(
       clk => clk,
       enable => eR,
       reset => reset,
       d => R_mux_dat_inp_ula,
       q => R_val
    );

    --Registradoras de flags

    Zero_flag_reg: reg1bit
     port map(
        clk => clk,
        enable => eF,
        reset => reset,
        d => ZERO_flag,
        q => ZERO_flag_out
    );

    Sign_flag_reg: reg1bit
     port map(
        clk => clk,
        enable => eF,
        reset => reset,
        d => SIGN_flag,
        q => SIGN_flag_out
    );

    Carry_flag_reg: reg1bit
     port map(
        clk => clk,
        enable => eF,
        reset => reset,
        d => CARRY_flag,
        q => CARRY_flag_out
    );

    Overflow_flag_reg: reg1bit
     port map(
        clk => clk,
        enable => eF,
        reset => reset,
        d => OVERFLOW_flag,
        q => OVERFLOW_flag_out
    );
    ---------------------------------------------------------------------
    ---------------------------Memória-----------------------------------
    ---------------------------------------------------------------------
    
    --É importante notar que a RAM utilizada para o quartus é diferente pois para
    --Inicializar no modelsim é necessario de uma função que não tem no IP do quartus
    ram256x8_main: ram256x8
    port map(
       address => pc_address,
       clk => clk,
       data => "00000000",
       Mwe => '0',
       q => MEM_val
    );

    ---------------------------------------------------------------------
    ---------------------------ULA---------------------------------------
    ---------------------------------------------------------------------
    
    --Selecionando o input A da ula
    alu_mux_a: mux4to1
     generic map(
        in_out_size => 8
    )
     port map(
        selector => xA,
        a => A_val,
        b => B_val,
        c => R_val,
        d => MEM_val,
        mux_out => ALU_input_a
    );

    alu_mux_b: mux4to1
     generic map(
        in_out_size => 8
    )
     port map(
        selector => xB,
        a => A_val,
        b => B_val,
        c => R_val,
        d => MEM_val,
        mux_out => ALU_input_b
    );

    alu_inst: alu
     port map(
        a => ALU_input_a,
        b => ALU_input_b,
        op => alu_select,
        r => ALU_out,
        flags => ALU_flag_out
    );
    
end architecture Behaviour;