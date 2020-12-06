#!/usr/bin/env python

import copy
from functools import reduce


# Parse lines from an input file to get a list of unique answers by group
def get_groups(filename):
    groups = []
    group = []
    for line in open(filename, "r").read().splitlines():
        if line:
            group.append(line)
        else:
            groups.append(copy.deepcopy(group))
            group.clear()
    # we append one last time after reading the file,
    # because the final blank line is skipped by `splitlines`
    groups.append(group)
    return groups


# Concat answers from group, remove duplicates and count remaining ones
def count_anyone_positive_answers(group):
    return len(set(''.join(group)))


# Apply intersection on answers of a group, then count the result
def count_everyone_positive_answers(group):
    return len(reduce((lambda x, y: set(x) & set(y)), group))


# Count the number of answers for each group, following a given strategy:
# "anyone" answered yes or "everyone" answered yes
def positive_answers_counts(groups, strategy):
    counts = []
    for group in groups:
        counts.append(eval(f"count_{strategy}_positive_answers")(group))
    return counts


groups = get_groups("input.txt")
# Puzzle 1
anyone_counts = positive_answers_counts(groups, "anyone")
print("Puzzle 1 answer:", sum(anyone_counts))
# Puzzle 2
everyone_counts = positive_answers_counts(groups, "everyone")
print("Puzzle 2 answer:", sum(everyone_counts))
