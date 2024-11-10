import sys
import argparse
from assembler import parse

argparser = argparse.ArgumentParser(prog="Assembler")
argparser.add_argument('-m', action='store_true', help='assebla o programa diretamente para a pasta do modelsim (./msim)')
argparser.add_argument('asm_file')

arguments = argparser.parse_args(sys.argv[1:])

with open(f'{sys.argv[1]}', 'r') as input_file:
    with open('programa.mif', 'w') as mif_file:
        if arguments.__dict__['m'] == True:
            with open('./msim/programa.hex', 'w') as hex_file:
                parse.mif_init(mif_file)
                parse.assemble_file(input_file, mif_file, hex_file)

        else: 
            with open('programa.hex', 'w') as hex_file:
                parse.mif_init(mif_file)
                parse.assemble_file(input_file, mif_file, hex_file)