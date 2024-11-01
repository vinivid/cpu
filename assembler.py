import sys
from assembler import parse

out_file = parse.create_mif()

with open('{}'.format(sys.argv[1]), 'r') as file:
    for line in file:
        for word in line.split():
            print('{}'.format(word))
            out_file.write(word)

out_file.close()