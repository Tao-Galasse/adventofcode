import itertools

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

def compute(intcode, input1, input2, mode = "standard"):
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
            intcode[intcode[index+1]] = input1 if input1 is not None else input2
            input1 = None
            index += 2
        elif opcode == "04":
            if mode == "standard":
                print(intcode[address1])
            elif mode == "output":
                return intcode[address1]
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

def final_amplifier_output(settings_sequence):
    amplifier_output = 0

    for setting in settings_sequence:
        intcode = set_intcode()
        amplifier_output = compute(intcode, setting, amplifier_output, "output")

    return amplifier_output

def get_max_thruster_signal():
    settings_sequences = list(itertools.permutations([0, 1, 2, 3, 4]))
    max = 0

    for settings_sequence in settings_sequences:
        output = final_amplifier_output(settings_sequence)
        if output > max: max = output

    return max

print(get_max_thruster_signal())
