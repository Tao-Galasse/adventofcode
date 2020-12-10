#!/usr/bin/env python

# Return values from an input file as a list of integers
def read_numbers_from_file(filename):
    return [int(i) for i in open(filename, "r").read().splitlines()]


# NB: copied from day 1
# Find two values in a list giving a sum equal to the one given in param
def find_sum_of_two_values(report, sum):
    for i in range(0, len(report)):
        for j in range(i+1, len(report)):
            if report[i] + report[j] == sum:
                return (report[i], report[j])


# Return the first invalid number in the list of XMAS numbers
def find_invalid_number(preamble):
    for idx in range(preamble, len(NUMBERS)):
        if not find_sum_of_two_values(NUMBERS[idx-preamble:idx], NUMBERS[idx]):
            return NUMBERS[idx]


# Return the list of contiguous numbers equal to the one given in param
def find_contiguous_numbers_equal_to(number):
    for start_index in range(len(NUMBERS)):
        sum = 0
        for current_index in range(start_index, len(NUMBERS)):
            sum += NUMBERS[current_index]
            if sum > number:
                break
            if sum == number:
                return NUMBERS[start_index:current_index+1]


NUMBERS = read_numbers_from_file("input.txt")
# Puzzle 1
invalid_number = find_invalid_number(25)
print("The first invalid number is:", invalid_number)
# Puzzle 2
contiguous_set = find_contiguous_numbers_equal_to(invalid_number)
print("The encryption weakness is:", min(contiguous_set) + max(contiguous_set))
