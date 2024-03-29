def set_intcode():
    intcode = []

    with open("input.txt", "r") as file:
        for value in file.read().split(","):
            intcode.append(int(value))

    return intcode

def decrypt_instruction(intcode, index):
    instructions = "{0:0=5d}".format(intcode[index])

    opcode = instructions[-2:]  
    address1 = address2 = 0 # defaut value

    # Following instructions avoid a `list index out of range` error
    if len(intcode) > index+1:
        address1 = index+1 if int(instructions[2]) else intcode[index+1]
    if len(intcode) > index+2:
        address2 = index+2 if int(instructions[1]) else intcode[index+2]

    return (opcode, address1, address2)

def compute(intcode):
    index = 0

    while index < len(intcode):
        opcode, address1, address2 = decrypt_instruction(intcode, index)

        if opcode == "01":
            intcode[intcode[index+3]] = intcode[address1] + intcode[address2]
            index += 4
        elif opcode == "02":
            intcode[intcode[index+3]] = intcode[address1] * intcode[address2]
            index += 4
        elif opcode == "03":
            intcode[intcode[index+1]] = input("Please provide the system ID:")
            index += 2
        elif opcode == "04":
            print(intcode[address1])
            index += 2
        elif opcode == "05":
            index = intcode[address2] if intcode[address1] != 0 else index+3
        elif opcode == "06":
            index = intcode[address2] if intcode[address1] == 0 else index+3
        elif opcode == "07":
            intcode[intcode[index+3]] = 1 if intcode[address1] < intcode[address2] else 0
            index += 4
        elif opcode == "08":
            intcode[intcode[index+3]] = 1 if intcode[address1] == intcode[address2] else 0
            index += 4
        elif opcode == "99":
            break
        else:
            print("wtf?")

intcode = set_intcode()
compute(intcode)
