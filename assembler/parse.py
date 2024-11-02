import sys
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

def line_to_instruction(line : str, output_file : TextIO, program_position : int, line_number : int):
    words = line.split()

    #Se não tiver nada na linha pula
    if len(words) == 0:
        return True, program_position
    #Erros dados pela quantidade de palavras nas linhas
    elif len(words) == 1 and words[0] != 'WAIT':
        print('ERRO quantidade de palavras insuficiente para se exucutar algo')
        print_error_colored(words, line_number)
        return False, program_position
    elif len(words) > 3:
        print('ERRO quantidade excede o maximo para uma instrução')
        print_error_colored(words, line_number)
        return False, program_position
    
    #A informação da operação sera dada como um vetor de 16 bits nos quais os 8 primeiros bits estarão
    #O código de operação (4 bits) e a primeira registradora (2 bits) os ultimos dois bits são reservados para
    # Flags do próximo tipo de dado (Se é uma registradora ou inteiro ou endereço)
    # Os ultimos 8 bits são reservados para um inteiro ou uma registradora ou nada. 
    if words[0] in operations_dict:
        if words[0] == 'WAIT':
            if len(words) != 1:
                print('ERRO A instrução WAIT nao deve receber nenhum argumento')
                print_error_colored(words, line_number)
                return False, program_position
            
            output_file.write(f'{hex(program_position).removeprefix('0x').upper()} : {operations_dict[words[0]]}0000;\n')
        elif words[0] in ('NOT', 'JMP', 'JEQ', 'JGR', 'IN', 'OUT'):
            if len(words) > 2:
                print(f'ERRO A instrução {words[0]} não recebe mais de um argumento')
                print_error_colored(words, line_number)
                return False, program_position
            
            if words[0] in ('NOT', 'IN', 'OUT'):
                output_file.write(f'{hex(program_position).removeprefix('0x').upper()} : {operations_dict[words[0]]}{register_dict[words[1]]}00;\n')
            else:
                #Como um endereço é sempre o que se espera nessas instruções ela não recebe nenhuma flag
                if words[1].isdecimal():
                    output_file.write(f'{hex(program_position).removeprefix('0x').upper()} : {operations_dict[words[0]]}0000;\n')
                    program_position += 1
                    output_file.write(f'{hex(program_position).removeprefix('0x').upper()} : {words[1]};\n')
                
                else:
                    output_file.write(f'{hex(program_position).removeprefix('0x').upper()} : {operations_dict[words[0]]}0000;\n')
                    program_position += 1
                    output_file.write(f'{hex(program_position).removeprefix('0x').upper()} : {int(words[1], 16):08b};\n')
                
        else:
            #Essas operações só podem receber reg ou inteiro como segundo paramentro
            if words[0] in ('MOV', 'ADD', 'CMP', 'SUB', 'AND', 'OR'):
                if words[2].isdecimal():
                    output_file.write(f'{hex(program_position).removeprefix('0x').upper()} : {operations_dict[words[0]]}{register_dict[words[1]]}01;\n')
                    program_position += 1
                    output_file.write(f'{hex(program_position).removeprefix('0x').upper()} : {int(words[2]):08b};\n')
                    
                else:
                    output_file.write(f'{hex(program_position).removeprefix('0x').upper()} : {operations_dict[words[0]]}{register_dict[words[1]]}00;\n')
                    program_position += 1
                    output_file.write(f'{hex(program_position).removeprefix('0x').upper()} : {register_dict[words[2]]}000000;\n')

            else:
                if words[1].isdecimal():
                    output_file.write(f'{hex(program_position).removeprefix('0x').upper()} : {operations_dict[words[0]]}{register_dict[1]}00;\n')
                    program_position += 1
                    output_file.write(f'{hex(program_position).removeprefix('0x').upper()} : {words[2]};\n')
                
                else:
                    output_file.write(f'{hex(program_position).removeprefix('0x').upper()} : {operations_dict[words[0]]}{register_dict[1]}00;\n')
                    program_position += 1
                    output_file.write(f'{hex(program_position).removeprefix('0x').upper()} : {int(words[2], 16):08b};\n')

        return True, program_position
    
    elif words[0].endswith(':'):
        #TODO: Adicionar labels
        return True, program_position
    
    else:
        print('ERRO primeira palavra de uma linha não instrução nem label valida\n')
        print_error_colored(words, line_number)
        print('\n\nTalvez você tenha esquecido o \':\' da label')
        print('Talvez você não tenha feito a palavra inteira em upper case\n')

        return False, program_position

def assemble_file(input_file : TextIO, output_file : TextIO):
    ENDING_NUMBER = 255

    program_position = 0
    line_number = 1
    error = bool
    for line in input_file:
        error, program_position = line_to_instruction(line, output_file, program_position, line_number)
        line_number += 1
        program_position += 1

        if not error:
            return
    
    if (ENDING_NUMBER - program_position) == 0:
        output_file.write(f'{hex(255).removeprefix('0x').upper()} : 11110000;\n\n')
    elif (ENDING_NUMBER - program_position) == 1:
        output_file.write(f'{hex(254).removeprefix('0x').upper()} : 11110000;\n')
        output_file.write(f'{hex(255).removeprefix('0x').upper()} : 11110000;\n\n')
    else:
        output_file.write(f'[{hex(program_position).removeprefix('0x').upper()}..{hex(255).removeprefix('0x').upper()}] : 11110000;\n\n')
    
    output_file.write('END;')