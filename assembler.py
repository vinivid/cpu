import sys
from assembler import parse

if len(sys.argv) < 2:
    print('Nenhum arquivo para gerar um mif foi passado')
    exit()

if len(sys.argv) == 3:
    with open(f'{sys.argv[1]}', 'r') as input_file:
        with open(f'{sys.argv[2]}.mif', 'w') as output_file:
            parse.mif_init(output_file)
            parse.assemble_file(input_file, output_file)
else:
    file = open('a.mif', 'w')
