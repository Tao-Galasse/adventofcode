#!/usr/bin/env python

# Return values from an input file as a list of integers
def read_numbers_from_file(filename):
    return [int(i) for i in open(filename, "r").read().splitlines()]


# Find two values in a list giving a sum equal to the one given in param
def find_sum_of_two_values(report, sum):
    for i in range(0, len(report)):
        for j in range(i+1, len(report)):
            if report[i] + report[j] == sum:
                return (report[i], report[j])


# Find three values in a list giving a sum equal to the one given in param
def find_sum_of_three_values(report, sum):
    for i in range(0, len(report)):
        for j in range(i+1, len(report)):
            for k in range(j+1, len(report)):
                if report[i] + report[j] + report[k] == sum:
                    return (report[i], report[j], report[k])


# Puzzle 1
expense_report = read_numbers_from_file("input.txt")
expense1, expense2 = find_sum_of_two_values(expense_report, 2020)
print("Puzzle 1 answer is:", expense1 * expense2)

# Puzzle 2
expense1, expense2, expense3 = find_sum_of_three_values(expense_report, 2020)
print("Puzzle 2 answer is:", expense1 * expense2 * expense3)
