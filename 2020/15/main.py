#!/usr/bin/env python

# Parse lines from an input file to get the list of starting numbers
def parse_input(filename):
    return [int(n) for n in open(filename, "r").read().split(',')]


# Return the until-th number spoken from a list of starting numbers
def complete_list_until(numbers, until):
    numbers_dict = {}
    # init a dictionary with n-1 starting numbers,
    # associated to their turn of last occurrence
    for n in range(len(numbers) - 1):
        numbers_dict[numbers[n]] = n + 1
    last = numbers[-1]  # the last starting number is not in the dictionary yet

    for turn in range(len(numbers), until):
        if last in numbers_dict:
            numbers_dict[last], last = turn, turn - numbers_dict[last]
        else:
            numbers_dict[last], last = turn, 0
    return last


numbers = parse_input('input.txt')
# Puzzle 1
print("2020th number spoken:", complete_list_until(numbers, 2020))
# Puzzle 2
print("30000000th number spoken:", complete_list_until(numbers, 30000000))
