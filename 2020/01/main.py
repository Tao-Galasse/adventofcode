#!/usr/bin/env python

# Return values from an input file as an array of integers
def expenses(filename):
    expenses = []

    with open(filename, "r") as file:
        for expense in file.read().splitlines():
            expenses.append(int(expense))

    return expenses


# Find the two values giving a sum equal to 2020 from report
def find_sum_of_two_values(report):
    for i in range(0, len(report)):
        for j in range(i+1, len(report)):
            if report[i] + report[j] == 2020:
                return (report[i], report[j])


# Find the three values giving a sum equal to 2020 from report
def find_sum_of_three_values(report):
    for i in range(0, len(report)):
        for j in range(i+1, len(report)):
            for k in range(j+1, len(report)):
                if report[i] + report[j] + report[k] == 2020:
                    return (report[i], report[j], report[k])


# Puzzle 1
expense_report = expenses("input.txt")
expense1, expense2 = find_sum_of_two_values(expense_report)
print("Puzzle 1 answer is:", expense1 * expense2)

# Puzzle 2
expense1, expense2, expense3 = find_sum_of_three_values(expense_report)
print("Puzzle 2 answer is:", expense1 * expense2 * expense3)
