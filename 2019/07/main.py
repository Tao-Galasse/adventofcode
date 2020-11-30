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

class Amplifier:
    def __init__(self, intcode, setting = None):
        self.intcode = intcode
        self.index = 0
        self.setting = setting
        self.setting_used = 0
        self.output = None
        self.halted = 0

    def compute(self, previous_output = None, mode = "standard"):
        intcode = self.intcode
        index = self.index

        while index < len(intcode):
            opcode, address1, address2 = decrypt_instruction(intcode, index)

            if opcode == "01":
                intcode[intcode[index+3]] = intcode[address1] + intcode[address2]
                index += 4
            elif opcode == "02":
                intcode[intcode[index+3]] = intcode[address1] * intcode[address2]
                index += 4
            elif opcode == "03":
                if mode == "standard":
                    intcode[intcode[index+1]] = input("Please provide the system ID:")
                elif mode == "output":
                    if not self.setting_used:
                        intcode[intcode[index+1]] = self.setting
                        self.setting_used = 1
                    else:
                        self.intcode[intcode[index+1]] = previous_output
                index += 2
            elif opcode == "04":
                index += 2
                if mode == "standard":
                    print(intcode[address1])
                elif mode == "output":
                    self.output = intcode[address1]
                    self.intcode = intcode
                    self.index = index
                    return self.output
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
                if mode == "standard":
                    break
                elif mode == "output":
                    self.halted = 1
                    self.intcode = intcode
                    self.index = index
                    return self.output
            else:
                print("wtf?")

def final_amplifier_output(settings_sequence):
    output = 0

    for setting in settings_sequence:
        amplifier = Amplifier(set_intcode(), setting)
        output = amplifier.compute(output, "output")

    return output

def get_max_thruster_signal():
    settings_sequences = list(itertools.permutations([0, 1, 2, 3, 4]))
    max = 0

    for settings_sequence in settings_sequences:
        output = final_amplifier_output(settings_sequence)
        if output > max: max = output

    return max

def get_max_thruster_signal_fallback_loop():
    settings_sequences = list(itertools.permutations([5, 6, 7, 8, 9]))
    max = 0

    for settings_sequence in settings_sequences:
        output = 0
        amplifiers = []

        for setting in settings_sequence:
            amplifiers.append(Amplifier(set_intcode(), setting))
        
        while not amplifiers[-1].halted:
            for amplifier in amplifiers:
                output = amplifier.compute(output, "output")

        if output > max: max = output

    return max

max_part1 = get_max_thruster_signal()
max_part2 = get_max_thruster_signal_fallback_loop()

print("Max thruster signal without fallback loop is %s" % max_part1)
print("Max thruster signal with fallback loop is %s" % max_part2)
