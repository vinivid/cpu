import sys
import os
from .dicts import *
from typing import TextIO

def print_error_colored(line_words : list, line_number: int):
    print(f'{sys.argv[1]} na linha {line_number}')
    print(f'{'\033[0;31m'}{line_words[0]}', end=' ')

    for i in range(1, len(line_words) - 1):
        print(f'{line_words[i]}', end=' ')
    
    print('\n')

def mif_init(output_file : TextIO):
    output_file.write('DEPTH = 256;\n')
    output_file.write('WIDTH = 8;\n')
    output_file.write('ADDRESS_RADIX = HEX;\n')
    output_file.write('DATA_RADIX = BIN;\n')
    output_file.write('CONTENT\nBEGIN\n\n')

def bitwise_not(n : int):
    return n ^ ((1 << 8) - 1)

def checksum(program_position : int, instruction : str) -> str:
    sum_of_values = 1 + program_position + int(instruction, 2)
    #Complemento de dois da soma dos valores da representação em hex
    checksum = bitwise_not(sum_of_values) + 1
    checksum_hex = hex(checksum).removeprefix('0x').zfill(2).upper()
    if len(checksum_hex) == 3:
        checksum_hex = checksum_hex[1:3]
    return checksum_hex

def pos_to_hex(program_position : int) -> str:
    return hex(program_position).removeprefix('0x').zfill(4).upper()

def instruction_to_hex(instruction : str):
    return hex(int(instruction, 2)).removeprefix('0x').zfill(2).upper()

def write_hex_instruction(hex_file : TextIO, program_position : int, instruction : str):
    hex_file.write(f':01{pos_to_hex(program_position)}00{instruction_to_hex(instruction)}{checksum(program_position, instruction)}\n')

def write_mif_instruction(mif_file: TextIO, program_position : int, instruction : str):
    mif_file.write(f'{hex(program_position).removeprefix('0x').upper()} : {instruction};\n')

def line_to_instruction(line : str, mif_file : TextIO, hex_file : TextIO, program_position : int, line_number : int):
    words = line.split()
    checksum = int
    #Se não tiver nada na linha pula
    if len(words) == 0:
        return True, program_position
    #Erros dados pela quantidade de palavras nas linhas
    elif len(words) == 1 and words[0] != 'WAIT':
        print('ERRO::quantidade de palavras insuficiente para se exucutar algo')
        print_error_colored(words, line_number)
        return False, program_position
    elif len(words) > 3:
        print('ERRO::quantidade excede o maximo para uma instrução')
        print_error_colored(words, line_number)
        return False, program_position
    
    #A informação da operação sera dada como um vetor de 16 bits nos quais os 8 primeiros bits estarão
    #O código de operação (4 bits) e a primeira registradora (2 bits) os ultimos dois bits são reservados para
    #Flags do próximo tipo de dado (Se é uma registradora ou inteiro ou endereço)
    #Os ultimos 8 bits são reservados para um inteiro ou uma registradora ou nada. 
    # INTEL HEX
    # duas primeiras posições são o hex da tipo quantidade de bytes, vai ser sempre 01 tirando no final 
    # depois delas vem um hex de 4 casas que é a posição do programa
    # depois um hex de duas casas do tipo de dado, vai ser sempre 00, 
    # depois vem o byte sendo escrito em hex
    # depois vem o o checksum q é o complemento de dois da instrução dada
    if words[0] in operations_dict:
        #Caso especial para o wait que recebe nenhum argumento
        if words[0] == 'WAIT':
            if len(words) != 1:
                print('ERRO::A instrução WAIT nao deve receber nenhum argumento')
                print_error_colored(words, line_number)
                return False, program_position
            
            instruction = f'{operations_dict[words[0]]}0000'
            write_mif_instruction(mif_file, program_position, instruction)
            write_hex_instruction(hex_file, program_position, instruction)

        #São os comando que recebem apenas um argumento
        elif words[0] in ('NOT', 'JMP', 'JEQ', 'JGR', 'IN', 'OUT'):
            if len(words) > 2:
                print(f'ERRO::A instrução {words[0]} não recebe mais de um argumento')
                print_error_colored(words, line_number)
                return False, program_position
            
            #Pode receber apenas uma registradora
            if words[0] in ('NOT', 'IN', 'OUT'):
                instruction = f'{operations_dict[words[0]]}{register_dict[words[1]]}00'
                write_mif_instruction(mif_file, program_position, instruction)
                write_hex_instruction(hex_file, program_position, instruction)
            
            #Instruções JMP JEQ JGR
            #Como um endereço é sempre o que se espera nessas instruções ela não recebe nenhuma flag
            else:
                #Se o endereço dado for um binario
                if words[1].isdecimal():
                    instruction_p1 = f'{operations_dict[words[0]]}0000'
                    instruction_p2 = f'{words[1]}'
                    write_mif_instruction(mif_file, program_position, instruction_p1)
                    write_hex_instruction(hex_file, program_position, instruction_p1)
                    program_position += 1
                    write_mif_instruction(mif_file, program_position, instruction_p2)
                    write_hex_instruction(hex_file, program_position, instruction_p2)
                
                #Se o endereço dado for um hex
                else:
                    instruction_p1 = f'{operations_dict[words[0]]}0000'
                    instruction_p2 = f'{int(words[1], 16):08b}'
                    write_mif_instruction(mif_file, program_position, instruction_p1)
                    write_hex_instruction(hex_file, program_position, instruction_p1)
                    program_position += 1
                    write_mif_instruction(mif_file, program_position, instruction_p2)
                    write_hex_instruction(hex_file, program_position, instruction_p2)

        #São todos os comandos que recebem dois argumentos
        else:
            #Essas operações só podem receber reg ou inteiro como segundo paramentro
            if words[0] in ('MOV', 'ADD', 'CMP', 'SUB', 'AND', 'OR'):
                #Se for receber um inteiro como segunda parte da instrução
                if words[2].isdecimal():
                    instruction_p1 = f'{operations_dict[words[0]]}{register_dict[words[1]]}01'
                    instruction_p2 = f'{int(words[2]):08b}'
                    write_mif_instruction(mif_file, program_position, instruction_p1)
                    write_hex_instruction(hex_file, program_position, instruction_p1)
                    program_position += 1
                    write_mif_instruction(mif_file, program_position, instruction_p2)
                    write_hex_instruction(hex_file, program_position, instruction_p2)
                
                #Se for receber uma reg como segunda parte da instrução
                else:
                    instruction_p1 = f'{operations_dict[words[0]]}{register_dict[words[1]]}00'
                    instruction_p2 = f'{register_dict[words[2]]}000000'
                    write_mif_instruction(mif_file, program_position, instruction_p1)
                    write_hex_instruction(hex_file, program_position, instruction_p1)
                    program_position += 1
                    write_mif_instruction(mif_file, program_position, instruction_p2)
                    write_hex_instruction(hex_file, program_position, instruction_p2)

            #São as instruções de laod e de store
            else:
                #O endereço dado para o load/sotre é um binario
                if words[1].isdecimal():
                    instruction_p1 = f'{operations_dict[words[0]]}{register_dict[1]}00'
                    instruction_p2 = f'{register_dict[words[2]]}000000'
                    write_mif_instruction(mif_file, program_position, instruction_p1)
                    write_hex_instruction(hex_file, program_position, instruction_p1)
                    program_position += 1
                    write_mif_instruction(mif_file, program_position, instruction_p2)
                    write_hex_instruction(hex_file, program_position, instruction_p2)
                
                #O endereço dado para o load/sotre é um hex
                else:
                    instruction_p1 = f'{operations_dict[words[0]]}{register_dict[1]}00'
                    instruction_p2 = f'{int(words[2], 16):08b}'
                    write_mif_instruction(mif_file, program_position, instruction_p1)
                    write_hex_instruction(hex_file, program_position, instruction_p1)
                    program_position += 1
                    write_mif_instruction(mif_file, program_position, instruction_p2)
                    write_hex_instruction(hex_file, program_position, instruction_p2)

        return True, program_position
    
    elif words[0].endswith(':'):
        #TODO: Adicionar labels
        return True, program_position
    
    else:
        print('ERRO::primeira palavra de uma linha não instrução nem label valida\n')
        print_error_colored(words, line_number)
        print('\n\nTalvez você tenha esquecido o \':\' da label')
        print('Talvez você não tenha feito a palavra inteira em upper case\n')

        return False, program_position

def assemble_file(input_file : TextIO, mif_file : TextIO, hex_file : TextIO):
    ENDING_NUMBER = 255

    program_position = 0
    line_number = 1
    error = bool
    for line in input_file:
        error, program_position = line_to_instruction(line, mif_file, hex_file, program_position, line_number)
        line_number += 1
        program_position += 1

        if not error:
            return
        
        if program_position > ENDING_NUMBER + 1:
            print(f'{'\033[0;31m'}ERRO::O programa escrito excede o maximo de memória de programa permitida pelo processador\n\n')
            return
    
    #Marca as posiçoes não inicializada com uma instrução não executavel
    if (ENDING_NUMBER - program_position) == 0:
        mif_file.write(f'{hex(255).removeprefix('0x').upper()} : 11110000;\n')
    elif (ENDING_NUMBER - program_position) == 1:
        mif_file.write(f'{hex(254).removeprefix('0x').upper()} : 11110000;\n')
        mif_file.write(f'{hex(255).removeprefix('0x').upper()} : 11110000;\n')
    elif (program_position < ENDING_NUMBER):
        mif_file.write(f'[{hex(program_position).removeprefix('0x').upper()}..{hex(255).removeprefix('0x').upper()}] : 11110000;\n')
    
    mif_file.write('\nEND;')

    while program_position < 256:
        write_hex_instruction(hex_file, program_position, '11110000')
        program_position += 1
    
    #Escrevendo EOF
    hex_file.write(':00000001FF\n')