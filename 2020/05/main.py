#!/usr/bin/env python

import math


# Parse lines from an input file to get the list of boarding passes
def get_passes(filename):
    file = open(filename)
    passes = file.read().splitlines()
    file.close()
    return passes


# Return the number of the row corresponding to a given boarding pass
def get_row(boarding_pass):
    min = 0
    max = 127
    for letter in boarding_pass[:-3]:
        if letter == "F":  # Front, we take the lower half
            max -= math.ceil((max - min) / 2)
        else:  # Back, we take the upper half
            min += math.ceil((max - min) / 2)
    return min


# Return the number of the column corresponding to a given boarding pass
def get_column(boarding_pass):
    min = 0
    max = 7
    for letter in boarding_pass[-3:]:
        if letter == "L":  # Left, we take the lower half
            max -= math.ceil((max - min) / 2)
        else:  # Right, we take the upper half
            min += math.ceil((max - min) / 2)
    return min


# Return the seat ID corresponding to a given boarding pass
def get_seat_id(boarding_pass):
    return get_row(boarding_pass) * 8 + get_column(boarding_pass)


# NB: This function was my first implementation for the puzzle 1 answer ;
# it has been replaced by the one below after I had to order the seat IDs.
#
# Return the higher seat ID from a list of boarding passes
# def get_max_seat_id(passes):
#     max = 0
#     for boarding_pass in passes:
#         id = get_seat_id(boarding_pass)
#         if id > max:
#             max = id
#     return max

# Return the higher value of an ordered list, so basically the last item
def get_max_seat_id(ordered_ids):
    return ordered_ids[-1]


# Return an ordered list of seat IDs from a list of boarding passes
def get_ordered_seat_ids(passes):
    ids = []
    for boarding_pass in passes:
        ids.append(get_seat_id(boarding_pass))
    return sorted(ids)


# Return the missing ID (mine!) from an ordered list of seat IDs
def find_missing_id(ordered_ids):
    # My place is not the first nor the last, so we skip them in the loop
    for id in range(ordered_ids[1], ordered_ids[-1]):
        if id not in ordered_ids:
            return id


passes = get_passes("input.txt")
# Puzzle 1
ordered_ids = get_ordered_seat_ids(passes)
print("max seat ID:", get_max_seat_id(ordered_ids))
# Puzzle 2
missing_id = find_missing_id(ordered_ids)
print("my seat ID:", missing_id)
