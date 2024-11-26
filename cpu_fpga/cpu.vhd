library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cpu is
    port (
        clk : IN STD_LOGIC;
        confirm_button : IN STD_LOGIC;
        input_fpga : IN STD_LOGIC_VECTOR (7 downto 0); --Em essencia o sinal da unidade de input
        reset_n : IN STD_LOGIC;
        ir_disp : OUT STD_LOGIC_VECTOR(13 downto 0);
        mem_val_disp : OUT STD_LOGIC_VECTOR(13 downto 0);
        r_disp : OUT STD_LOGIC_VECTOR(13 downto 0);
        data_out : OUT STD_LOGIC_VECTOR (7 downto 0)
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

    component mux4to1b is
        port (
            selector : in STD_LOGIC_VECTOR (1 downto 0);
            a : in STD_LOGIC;
            b : in STD_LOGIC;
            c : in STD_LOGIC;
            d : in STD_LOGIC;
            mux_out : out STD_LOGIC
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
            reset : in STD_LOGIC;
            clk : in STD_LOGIC;
            break_loop : in STD_LOGIC;
            control_mask : out STD_LOGIC_VECTOR (21 downto 0)
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

    --component ram256x8 is
    --    port (
    --        address	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    --        clk : IN STD_LOGIC;
    --        data : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
    --        Mwe : IN STD_LOGIC;
    --        q : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
    --   );
    --end component;

    component mem256x8mif is
        port (
            address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            clock		: IN STD_LOGIC  := '1';
            data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            wren		: IN STD_LOGIC ;
            q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
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

    component input_unit is
        port (
            clk : in STD_LOGIC;
            send_push : in STD_LOGIC;
            inp : in STD_LOGIC_VECTOR(7 downto 0);
            go_next : out STD_LOGIC := '0';
            inp_v : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component output_unit is
        port (
            output_enable : in STD_LOGIC;
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            data_to_output : in STD_LOGIC_VECTOR (7 downto 0);
            data_output : OUT STD_LOGIC_VECTOR (7 downto 0)
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

    component display_7seg is
        port (
            input_disp : in STD_LOGIC_VECTOR (3 downto 0);
            out_disp : out STD_LOGIC_VECTOR (6 downto 0)
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

    --Os seguintes são os valores intermediarios do MUX de seleção de cada componente
    signal A_mux_data_select : STD_LOGIC_VECTOR(7 downto 0);
    signal A_mux_data_or_input : STD_LOGIC_VECTOR(7 downto 0);
    signal B_mux_data_select : STD_LOGIC_VECTOR(7 downto 0);
    signal B_mux_data_or_input : STD_LOGIC_VECTOR(7 downto 0);
    signal R_mux_data_select : STD_LOGIC_VECTOR(7 downto 0);
    --A registradora R possui além de ser input ou data também tem opção da ula
    signal R_mux_dat_inp_ula : STD_LOGIC_VECTOR(7 downto 0);

    --Sinal intermediaro do valor selecionado pelo mux da output unit
    signal OUT_mux_dat_inp : STD_LOGIC_VECTOR(7 downto 0);

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

    --É o valor faz com que a unidade de controle va para a próxima instrução depois da operação de in
    signal next_instruction : STD_LOGIC;

    --Valor que vem da unidade de input
    signal INPUT_val : STD_LOGIC_VECTOR(7 downto 0);

    signal jmp_enable : STD_LOGIC;
    signal jmp_addres : STD_LOGIC_VECTOR(7 downto 0);
    --O not sign flag é um sinal especial do program counter que é o not da flag de sinal
    --Se a flag de sinal for 0 no CMP significa q o operador da esquerda é maior do
    --que o da direita e portanto tem que ativar o JGR
    signal not_sign_flag : STD_LOGIC;

    --É o valor de saida após o mux de endereço selecionar se a memória sera endereça pelo program counter
    --ou um valor da memório ou registradora
    signal ADDR_mux_inp_mem : STD_LOGIC_VECTOR(7 downto 0);

    --Valor intermediario de selecionar qual dado vai ser usado quando a memória não esta sendo
    --endereçada pelo program counter
    signal NPC_mux_inp_mem : STD_LOGIC_VECTOR(7 downto 0);

    --É o valor de saida aós o mux de data selecionar um valor
    signal DATA_mux_inp_mem : STD_LOGIC_VECTOR(7 downto 0);

    --Valor da registradora feita para receber o imediato de forma a não se ter erros na operação de load um jump
    signal IMM_val : STD_LOGIC_VECTOR (7 downto 0);

    ---------------------------------------------------------------------
    -----------------BARRAMENTOS DA UNIDADE DE CONTROLE------------------
    ---------------------------------------------------------------------
    --O barramento de controle abilita e seleciona as registradoras e ula dependendo da instrução com base na bitmask feita na unidade de controle
    signal bitmask : STD_LOGIC_VECTOR (21 downto 0);
    
    --Select jmp enable é o que seleciona qual fator o jmp enable recebera para abilitar
    --00 é disabled
    --01 é jump incondicional
    --10 é jump se for igual
    --11 é jump se for maior
    alias select_jmp_enbale : STD_LOGIC_VECTOR is bitmask(21 downto 20);

    --É a operação a ser feita na ula, mesmo se n for uma operação de ula não trara erros pois as registradoras e outros estarão dewsabilitados
    alias alu_select : STD_LOGIC_VECTOR is bitmask(19 downto 17);

    --Os e's representams se uma registradora estatra abilitada
    --Os enables tabém serão a forma de de controlar quem recebe dado ou não numa operação de mov por exemple
    alias ePC : STD_LOGIC is bitmask(16);
    alias eIR : STD_LOGIC is bitmask(15);
    alias eA : STD_LOGIC is bitmask(14);
    alias eB : STD_LOGIC is bitmask(13);
    alias eR : STD_LOGIC is bitmask(12);

    --Enable imediato abilita a registradora que esta conectada na memória que guarda o seu valor
    alias eImm : STD_LOGIC is bitmask(11);

    --Enable das registradoras de flags
    alias eF : STD_LOGIC is bitmask(10);

    --Abilita a unidade de output
    alias eOut : STD_LOGIC is bitmask(9);

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

    ------------------------------------------------------------------------
    --Sinal especial do quartus, abilitar descomenar quando for colocar na FPGA
    signal not_confirm_button : STD_LOGIC;
    --O reset também precisa ser notado
    signal reset : STD_LOGIC;
begin
    
    reset <= not reset_n;

    ------------------------------------Debug----------------------------
    dsp_1_ir: display_7seg
     port map(
        input_disp => IR_val(3 downto 0),
        out_disp => ir_disp(6 downto 0)
    );

    disp_2_ir: display_7seg
     port map(
        input_disp => IR_val(7 downto 4),
        out_disp => ir_disp(13 downto 7)
    );

    dsp_1_mem_val: display_7seg
     port map(
        input_disp => MEM_val(3 downto 0),
        out_disp => mem_val_disp(6 downto 0)
    );

    dsp_2_mem_val: display_7seg
     port map(
        input_disp => MEM_val(7 downto 4),
        out_disp => mem_val_disp(13 downto 7)
    );

    dsp_1_reg_r: display_7seg
     port map(
        input_disp => R_val(3 downto 0),
        out_disp => r_disp(6 downto 0)
    );

    dsp_2_reg_r: display_7seg
     port map(
        input_disp => R_val(7 downto 4),
        out_disp => r_disp(13 downto 7)
    );

    ---------------------------------------------------------------------
    -----------------UNIDADE DE CONTROLE---------------------------------
    ---------------------------------------------------------------------

    cu: control_unit
     port map(
        instruction => IR_val,
        reset => reset,
        clk => clk,
        break_loop => next_instruction,
        control_mask => bitmask
    );

    ---------------------------------------------------------------------
    -----------------PROGRAM COUNTER-------------------------------------
    ---------------------------------------------------------------------
    
    not_sign_flag <= not SIGN_flag_out;

    --Mux que seleciona se tera jump enable ou não
    jmp_selct: mux4to1b
     port map(
        selector => select_jmp_enbale,
        a => '0',
        b => '1',
        c => ZERO_flag_out,
        d => not_sign_flag,
        mux_out => jmp_enable
    );

    --Seleciona de onde sera lido o addres para da o jump
    adrres_from_where: mux4to1
     generic map(
        in_out_size => 8
    )
     port map(
        selector => xB,
        a => A_val,
        b => B_val,
        c => R_val,
        d => IMM_val,
        mux_out => jmp_addres
    );

    program_counter: pc
     port map(
        clk => clk,
        enable => ePC,
        reset => reset,
        jump_enable => jmp_enable,
        jump_addres => jmp_addres,
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
    
    --Registradora que salva o valor do imediato para que não se tenham problemas no load e jmp
    reg_inst: reg
     generic map(
        number_of_bits => 8
    )
     port map(
        clk => clk,
        enable => eImm,
        reset => reset,
        d => MEM_val,
        q => IMM_val
    );
    
    --Mux que seleciona qual endereço alternativo ao program counter para usar
    addres_no_pc: mux4to1
     generic map(
        in_out_size => 8
    )
     port map(
        selector => xB,
        a => A_val,
        b => B_val,
        c => R_val,
        d => IMM_val,
        mux_out => NPC_mux_inp_mem
    );

    --Mux que seleciona se a memoria sera enderaçada pelo program counter ou por outra fonte
    pc_or_other: mux2to1
     generic map(
        in_out_size => 8
    )
     port map(
        selector => addr,
        a => pc_address,
        b => NPC_mux_inp_mem,
        mux_out => ADDR_mux_inp_mem
    );

    --Seleciocina qual sera o data input
    write_data_select: mux4to1
     generic map(
        in_out_size => 8
    )
     port map(
        selector => xA,
        a => A_val,
        b => B_val,
        c => R_val,
        d => IMM_val,
        mux_out => DATA_mux_inp_mem
    );

    --Na pasta cpu FPGA tem a versão para colocar na FPGA
    --NAO COMPILAR COM ESSA VERSAO SE NAO NAO VAI FUNCIONAR

    --É importante notar que a RAM utilizada para o quartus é diferente pois para
    --Inicializar no modelsim é necessario de uma função que não tem no IP do quartus só 
    --no quartus também n funciona inicializar a memória com textIO ent tem q comentar
    --e descomentar com base no que vc ta testando
    --ram256x8_main: ram256x8
    --port map(
    --   address => ADDR_mux_inp_mem,
    --   clk => clk,
    --   data => DATA_mux_inp_mem,
    --   Mwe => Mwe,
    --   q => MEM_val
    --);

    qrt_mem: mem256x8mif
     port map(
        address => ADDR_mux_inp_mem,
        clock => clk,
        data => DATA_mux_inp_mem,
        wren => Mwe,
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

    ---------------------------------------------------------------------
    ---------------------------UNIDADE DE INPUT--------------------------
    ---------------------------------------------------------------------

    --Na pasta cpu FPGA tem a versão para colocar na FPGA
    --NAO COMPILAR COM ESSA VERSAO SE NAO NAO VAI FUNCIONAR

    not_confirm_button <= not confirm_button;

    input_unit_inst: input_unit
     port map(
        clk => clk,
        send_push => not_confirm_button,
        inp => input_fpga,
        go_next => next_instruction,
        inp_v => INPUT_val
    );
    
    ---------------------------------------------------------------------
    ---------------------------UNIDADE DE OUTPUT-------------------------
    ---------------------------------------------------------------------
    
    --A unica diferença da unidade de output para uma registradora é que a unidade
    --de output é inicializada com 0 e de que o input dela é controla por xA e não por xB
    data_to_output_select: mux4to1
     generic map(
        in_out_size => 8
    )
     port map(
        selector => xA,
        a => A_val,
        b => B_val,
        c => R_val,
        d => MEM_val,
        mux_out => OUT_mux_dat_inp
    );

    output_unit_main: output_unit
     port map(
        output_enable => eOut,
        clk => clk,
        reset => reset,
        data_to_output => OUT_mux_dat_inp,
        data_output => data_out
    );
end architecture Behaviour;