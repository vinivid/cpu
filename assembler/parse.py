import sys
from typing import TextIO

def mif_init(file : TextIO):
    file.write('DEPTH = 256;\n')
    file.write('WIDTH = 8;\n')
    file.write('ADDRESS_RADIX = HEX;\n')
    file.write('DATA_RADIX = BIN;\n')
    file.write('CONTENT\nBEGIN\n')

def create_mif():
    if len(sys.argv) < 2:
        print('Nenhum arquivo para gerar um mif for passado')
        exit()

    if len(sys.argv) == 3:
        file = open('{}.mif'.format(sys.argv[2]), 'w')
        mif_init(file)
        return file

    else:
        file = open('a.mif', 'w')
        mif_init(file)
        return file
    
