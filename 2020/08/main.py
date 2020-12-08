#!/usr/bin/env python

import copy


# Parse lines from an input file to get the list of instructions
def get_instructions(filename):
    return open(filename, "r").read().splitlines()


# Return the list of possible instructions variations,
# by replacing every "jmp" by a "nop" and vice versa
def get_instructions_variations(instructions):
    instructions_variations = []
    for index in range(len(instructions)):
        operation, argument = instructions[index].split()
        if operation == "jmp":
            instructions[index] = "nop " + argument
        elif operation == "nop":
            instructions[index] = "jmp " + argument
        else:
            continue
        instructions_variations.append(copy.deepcopy(instructions))
        instructions[index] = ' '.join([operation, argument])
    return instructions_variations


# Read an instruction to return the new values of the index and the accumulator
def read_instruction(instruction, index, acc):
    operation, argument = instruction.split()
    if operation == "acc":
        return (index + 1, acc + int(argument))
    if operation == "jmp":
        return (index + int(argument), acc)
    else:
        return (index + 1, acc)


# Parse the instructions to return the value of the accumulator
# just before entering in the infinite loop
def parse_instructions(instructions):
    index_visited = []
    index = 0
    acc = 0
    while index not in index_visited:
        index_visited.append(index)
        index, acc = read_instruction(instructions[index], index, acc)
    return acc


# Parse the list of instructions variations to find the one which terminates
# the program, and return the value of the accumulator
def parse_instructions_variations(instructions_variations):
    for instructions in instructions_variations:
        index_visited = []
        index = 0
        acc = 0
        while index not in index_visited:
            if index == len(instructions):
                return acc
            index_visited.append(index)
            index, acc = read_instruction(instructions[index], index, acc)


# Puzzle 1
instructions = get_instructions("input.txt")
print("accumulator value before looping:", parse_instructions(instructions))
# Puzzle 2
instructions_variations = get_instructions_variations(instructions)
print("accumulator value after the program terminates:",
      parse_instructions_variations(instructions_variations))
