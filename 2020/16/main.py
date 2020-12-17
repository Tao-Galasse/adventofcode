#!/usr/bin/env python

import re
from itertools import chain


# Parse lines from an input file to get the rules, my ticket and nearby tickets
def parse_input(filename):
    rules = {}
    lines = open(filename, 'r').read().splitlines()
    i = 0
    while lines[i]:  # the file starts with the rules
        rule = lines[i].split(':')[0]
        ranges = []
        for a, b in re.findall(r'(\d+)-(\d+)', lines[i]):
            ranges.append(range(int(a), int(b) + 1))
        rules[rule] = ranges
        i += 1
    my_ticket = [int(n) for n in lines[i+2].split(',')]
    nearby_tickets = []
    i += 5
    while i < len(lines):  # the file ends with the nearby tickets
        nearby_tickets.append([int(n) for n in lines[i].split(',')])
        i += 1
    return rules, my_ticket, nearby_tickets


# Return invalid tickets and error rate from nearby tickets following the rules
def find_invalid_tickets(rules, nearby_tickets):
    invalid_tickets = []
    error_rate = 0
    for ticket in nearby_tickets:
        for value in ticket:
            ranges = list(chain.from_iterable(rules.values()))  # concat ranges
            if True not in [value in r for r in ranges]:
                invalid_tickets.append(ticket)
                error_rate += value
    return invalid_tickets, error_rate


# Return a dictionary of rules with their positions
def get_rules_positions(rules, nearby_tickets):
    rules_positions = {}
    for rule in rules:  # init rules_positions with all possible positions
        rules_positions[rule] = list(range(len(rules)))

    for ticket in nearby_tickets:
        for value in ticket:
            for rule, ranges in rules.items():
                if True not in [value in r for r in ranges]:
                    rules_positions[rule].remove(ticket.index(value))

    remove_impossible_values(rules_positions)
    return rules_positions


# Remove impossible values from a dictionary of rules_positions
# e.g. {"row": [0, 1], "col": [1]}  => {"row": 0, "col": 1}
def remove_impossible_values(rules_pos):
    while len(list(chain.from_iterable(rules_pos.values()))) > len(rules_pos):
        for rule, pos in rules_pos.items():
            if(len(pos) == 1):  # this position can't be anywhere else…
                [rules_pos[r].remove(pos[0]) for r in rules_pos
                 if r != rule and pos[0] in rules_pos[r]]  # …so we remove it

    # Finaly, we transform 1-length lists of positions into integers
    for rule, pos in rules_pos.items():
        rules_pos[rule] = pos[0]


# Multiply values from my ticket that start with the word "departure"
def mult_departure_values(rules_positions, my_ticket):
    product = 1
    for rule, position in rules_positions.items():
        if rule.startswith("departure"):
            product *= my_ticket[position]
    return product


rules, my_ticket, nearby_tickets = parse_input("input.txt")
# Puzzle 1
invalid_tickets, error_rate = find_invalid_tickets(rules, nearby_tickets)
print("Ticket scanning error rate:", error_rate)
# Puzzle 2
[nearby_tickets.remove(t) for t in invalid_tickets]
# nearby_tickets only contains valid tickets now
rules_positions = get_rules_positions(rules, nearby_tickets)
print("Multiplication of departure values from my ticket:",
      mult_departure_values(rules_positions, my_ticket))
