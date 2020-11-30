def set_intcode(noun, verb):
    intcode = []

    with open("input.txt", "r") as file:
        for value in file.read().split(","):
            intcode.append(int(value))

    intcode[1] = noun
    intcode[2] = verb

    return intcode

def compute(intcode):
    index = 0

    while index < len(intcode):
        if intcode[index] == 1:
            intcode[intcode[index+3]] = intcode[intcode[index+1]] + intcode[intcode[index+2]]
        elif intcode[index] == 2:
            intcode[intcode[index+3]] = intcode[intcode[index+1]] * intcode[intcode[index+2]]
        elif intcode[index] == 99:
            break
        else:
            print("wtf?")

        index += 4

def find(value):
    for noun in range(100):
        for verb in range(100):
            intcode = set_intcode(noun, verb)
            compute(intcode)
            if intcode[0] == value:
                return (noun, verb)


noun, verb = find(19690720)
print(100 * noun + verb)
