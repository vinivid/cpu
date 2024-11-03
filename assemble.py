import sys
from assembler import parse

if len(sys.argv) < 2:
    print('Nenhum arquivo para gerar um mif foi passado')
    exit()

with open(f'{sys.argv[1]}', 'r') as input_file:
    with open('programa.mif', 'w') as mif_file:
        with open('programa.hex', 'w') as hex_file:
            parse.mif_init(mif_file)
            parse.assemble_file(input_file, mif_file, hex_file)