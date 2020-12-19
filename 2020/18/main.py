#!/usr/bin/env python

import re


# Parse lines from an input file to get the operations of the homework
def parse_input(filename):
    return open(filename, "r").read().splitlines()


# Evaluate an operation with basic "math"
def eval_basic_operation(operation):
    while '(' in operation:
        begin = operation.rfind('(')
        end = operation.find(')', begin)
        value = eval_basic_operation(operation[begin+1:end])
        operation = operation[:begin] + str(value) + operation[end+1:]

    operation = re.split('([+*])', operation)
    value = int(operation[0])
    for i in range(1, len(operation), 2):
        value = eval(f'{value}{operation[i]}{operation[i+1]}')

    return value


# Evaluate an operation with advanced "math"
def eval_advanced_operation(operation):
    while '(' in operation:
        begin = operation.rfind('(')
        end = operation.find(')', begin)
        value = eval_advanced_operation(operation[begin+1:end])
        operation = operation[:begin] + str(value) + operation[end+1:]

    while '+' in operation:
        index = operation.find('+')  # index of the operator
        first = operation[:index-1].split()[-1]  # first member to add
        second = operation[index+2:].split()[0]  # second member to add
        # we replace first and second members by the result of the addition
        operation = operation[:index-1-len(first)] \
            + str(int(first) + int(second)) \
            + operation[index+2+len(second):]

    # Finaly, operation only contains '*' operator: we can evaluate it
    return eval(operation)


# Evaluate a list of operations and return the sum of them,
# following a given mode ("basic" or "advanced")
def eval_operations(operations, mode="basic"):
    total = 0
    for operation in operations:
        total += eval(f"eval_{mode}_operation")(operation)
    return total


operations = parse_input("input.txt")
# Puzzle 1
print("total with basic math:", eval_operations(operations))
# Puzzle 2
print("total with advanced math:", eval_operations(operations, "advanced"))
