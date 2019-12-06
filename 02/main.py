def set_opcode(noun, verb):
  opcode = []

  with open("input.txt", "r") as file:
    for value in file.read().split(","):
      opcode.append(int(value))

  opcode[1] = noun
  opcode[2] = verb

  return opcode

def compute(opcode):
  index = 0

  while index < len(opcode):
    if opcode[index] == 1:
      opcode[opcode[index+3]] = opcode[opcode[index+1]] + opcode[opcode[index+2]]
    elif opcode[index] == 2:
      opcode[opcode[index+3]] = opcode[opcode[index+1]] * opcode[opcode[index+2]]
    elif opcode[index] == 99:
      break
    else:
      print("wtf?")

    index += 4

def find(value):
  for noun in range(100):
    for verb in range(100):
      opcode = set_opcode(noun, verb)
      compute(opcode)
      if opcode[0] == value:
        return (noun, verb)

noun, verb = find(19690720)

print(100 * noun + verb)
