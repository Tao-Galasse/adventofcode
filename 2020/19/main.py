#!/usr/bin/env python

# Parse lines from an input file to get the rules and the messages
def parse_input(filename):
    rules = {}
    lines = open(filename, "r").read().splitlines()
    i = 0
    while lines[i]:  # the file starts with the rules
        number, rule = lines[i].split(': ')
        rules[number] = rule.split(' | ')
        i += 1
    messages = lines[i+1:]
    return rules, messages


# Check if a message is matching a list of rules (identified by their number)
def match_rule(message, rules_nums=['0']):
    # The message should exactly match the rules: it must not be too long with
    # pending chars in the end, or too short when iterating over rules-loops
    if rules_nums == [] or message == '':
        return rules_nums == [] and message == ''

    rule = RULES[rules_nums[0]]  # is an array like ['2 3', '3 2'], ['"a"'], …
    if any(map(str.isdigit, rule[0])):  # there is a number in the current rule
        # we want to return True if any of the possibilities match our message
        return any(
            match_rule(message, poss.split() + rules_nums[1:]) for poss in rule
        )

    if message[0] == rule[0][1]:  # current rule is "atomic" : a or b
        # first char is matching, let's see the rest of the message and rules!
        return match_rule(message[1:], rules_nums[1:])
    return False


# Return the number of messages matching the rule 0
def count_matching_messages(messages):
    return sum([match_rule(message) for message in messages])


RULES, messages = parse_input("input.txt")
# Puzzle 1
print("Number of messages matching the rule 0:",
      count_matching_messages(messages))
# Puzzle 2
RULES['8'] = ["42", "42 8"]
RULES['11'] = ["42 31", "42 11 31"]
print("Number of messages matching the rule 0 after updating rules 8 and 11:",
      count_matching_messages(messages))
