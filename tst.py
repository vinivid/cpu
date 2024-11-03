def bitwise_not(n : int):
    return n ^ ((1 << 8) - 1)

def checksum(program_position : int, instruction : str) -> str:
    sum_of_values = 1 + program_position + int(instruction, 2)
    print(f'Soma dos {sum_of_values}')
    #Complemento de dois da soma dos valores da representação em hex
    checksum = bitwise_not(sum_of_values) + 1
    checksum_hex = hex(checksum).removeprefix('0x').zfill(2).upper()
    if len(checksum_hex) == 3:
        checksum_hex = checksum_hex[1:3]
    print(checksum_hex)
    return checksum_hex

def pos_to_hex(program_position : int) -> str:
    return hex(program_position).removeprefix('0x').zfill(4).upper()

def instruction_to_hex(instruction : str):
    return hex(int(instruction, 2)).removeprefix('0x').zfill(2).upper()

programe_position = 16
instruction = '11110000'
print(f'{checksum(programe_position, instruction)}')
print(f':01{pos_to_hex(programe_position)}00{instruction_to_hex(instruction)}{checksum(programe_position, instruction)}')
