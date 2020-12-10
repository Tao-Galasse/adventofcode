#!/usr/bin/env python

from itertools import groupby
from operator import itemgetter


# Return sorted values from an input file as a list of integers
def read_numbers_from_file(filename):
    return sorted([int(i) for i in open(filename, "r").read().splitlines()])


# Return a list of the distribution of joltage differences
def get_jolt_differences():
    jolt_differences = [0, 0, 1]  # We count the device's built-in joltage
    current_jolt = 0
    while current_jolt < max(JOLTAGES):
        if current_jolt + 1 in JOLTAGES:
            jolt_differences[0] += 1
            current_jolt += 1
        elif current_jolt + 2 in JOLTAGES:
            jolt_differences[1] += 1
            current_jolt += 2
        else:
            jolt_differences[2] += 1
            current_jolt += 3
    return jolt_differences


# Return a list of successive numbers in the list of joltages
# Took from https://docs.python.org/3.0/library/itertools.html#examples
def find_successive_numbers():
    successives = []
    for k, g in groupby(enumerate(JOLTAGES), lambda t: t[0] - t[1]):
        successives.append(list(map(itemgetter(1), g)))
    return successives


# Count the total number of distinct ways to arrange the adapters
def count_permutations(successive_numbers_list):
    count = 1
    # number of possible permutations for successives numbers
    # I found it manually; how could I have calculate it?
    permutations_for_successives = {1: 1, 2: 1, 3: 2, 4: 4, 5: 7}
    for successive_numbers in successive_numbers_list:
        count *= permutations_for_successives[len(successive_numbers)]
    return count


JOLTAGES = [0] + read_numbers_from_file("input.txt")
# Puzzle 1
jolt_differences = get_jolt_differences()
print("Puzzle 1 answer:", jolt_differences[0] * jolt_differences[2])
# Puzzle 2
successives = find_successive_numbers()
print("Puzzle 2 answer:", count_permutations(successives))
