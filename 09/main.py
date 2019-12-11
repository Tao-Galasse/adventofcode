def set_intcode():
    intcode = []

    with open("input.txt", "r") as file:
        for value in file.read().split(","):
            intcode.append(int(value))
        intcode.extend([0] * 1000) # Add additional memory

    return intcode

class Amplifier:
    def __init__(self, intcode, setting = None):
        self.intcode = intcode
        self.index = 0
        self.setting = setting
        self.setting_used = 0
        self.output = None
        self.halted = 0
        self.relative_base = 0

    def decrypt_instruction(self, intcode, index):
        instructions = "{0:0=5d}".format(intcode[index])

        opcode = instructions[-2:]  
        address1 = address2 = address3 = 0 # defaut value

        # Following instructions avoid a `list index out of range` error
        if len(intcode) > index+1:
            if int(instructions[2]) == 0: # position mode
                address1 = intcode[index+1]
            elif int(instructions[2]) == 1: # immediate mode
                address1 = index+1
            elif int(instructions[2]) == 2: # relative mode
                address1 = intcode[index+1] + self.relative_base

        if len(intcode) > index+2:
            if int(instructions[1]) == 0: # position mode
                address2 = intcode[index+2]
            elif int(instructions[1]) == 1: # immediate mode
                address2 = index+2
            elif int(instructions[1]) == 2: # relative mode
                address2 = intcode[index+2] + self.relative_base

        if len(intcode) > index+3:
            if int(instructions[0]) == 0: # position mode
                address3 = intcode[index+3]
            elif int(instructions[0]) == 1: # immediate mode
                address3 = index+3
            elif int(instructions[0]) == 2: # relative mode
                address3 = intcode[index+3] + self.relative_base

        return (opcode, address1, address2, address3)

    def compute(self, previous_output = None, mode = "standard"):
        intcode = self.intcode
        index = self.index

        while index < len(intcode):
            opcode, address1, address2, address3 = self.decrypt_instruction(intcode, index)

            if opcode == "01":
                intcode[address3] = intcode[address1] + intcode[address2]
                index += 4
            elif opcode == "02":
                intcode[address3] = intcode[address1] * intcode[address2]
                index += 4
            elif opcode == "03":
                if mode == "standard":
                    intcode[address1] = input("Please provide the system ID:")
                elif mode == "output":
                    if not self.setting_used:
                        intcode[address1] = self.setting
                        self.setting_used = 1
                    else:
                        self.intcode[address1] = previous_output
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
                intcode[address3] = 1 if intcode[address1] < intcode[address2] else 0
                index += 4
            elif opcode == "08":
                intcode[address3] = 1 if intcode[address1] == intcode[address2] else 0
                index += 4
            elif opcode == "09":
                self.relative_base += intcode[address1]
                index += 2
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

amplifier = Amplifier(set_intcode())
amplifier.compute()
