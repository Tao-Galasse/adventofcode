#!/usr/bin/env python

import re


# Parse lines from an input file to get the list of bags rules
def rules(filename):
    return open(filename, "r").read().splitlines()


# Return a set of bags which can contain at least one given kind of bag
def find_bags_which_can_contain(possible_bags, bag):
    for rule in RULES:
        current_bag, rule_detail = rule.split(' bags contain')
        if bag in rule_detail:
            possible_bags.add(current_bag)
            find_bags_which_can_contain(possible_bags, current_bag)


# Return the rule starting with the given bag
def find_rule(bag):
    return [rule for rule in RULES if rule.startswith(bag)][0]


# Build a dictionary of bags associated to their quantity in a given rule
# e.g. {'bright black': 2, 'shiny tomato': 5, 'mirrored brown': 3}
def get_bags_dict_from_rule(rule):
    bags_dict = {}
    for fragment in rule.split(','):
        quantity = re.findall(r'\d+', fragment)
        if quantity:
            current_bag = fragment.split(f'{quantity[0]} ')[1].split(' bag')[0]
            bags_dict[current_bag] = int(quantity[0])
    return bags_dict


# Count the number of bags contained in the given one
def count_bags_contained_in(bag):
    total = 0
    bags_dict = get_bags_dict_from_rule(find_rule(bag))
    for current_bag, quantity in bags_dict.items():
        total += quantity + quantity * count_bags_contained_in(current_bag)
    return total


RULES = rules("input.txt")
possible_bags = set()  # we use a set to avoid duplicated bags
# Puzzle 1
find_bags_which_can_contain(possible_bags, "shiny gold")
print("number of bags which can contain at least one shiny gold bag:",
      len(possible_bags))
# Puzzle 2
print("number of bags contained in one shiny gold bag:",
      count_bags_contained_in("shiny gold"))
