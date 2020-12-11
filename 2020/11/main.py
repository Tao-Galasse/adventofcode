#!/usr/bin/env python

import copy


# Parse lines from an input file to get the map of the seat layout
def parse_input(filename):
    seats = []
    for line in open(filename, "r").read().splitlines():
        seats.append(list(line))
    return seats


# Return the number of occupied seats adjacent to a given one
def count_occupied_adjacent_seats(seats, row, col):
    adjacents = ""
    for c in (col-1, col, col+1):
        if c < 0 or c >= len(seats[0]):
            continue  # do not try to add out of range seats
        if row > 0:
            adjacents += seats[row-1][c]  # add seats on previous row
        if row < len(seats) - 1:
            adjacents += seats[row+1][c]  # add seats on next row
        if c != col:
            adjacents += seats[row][c]  # add seats on left and right columns
    return adjacents.count("#")


# Return the number of occupied first seen seats from a given one
def count_occupied_first_seen_seats(seats, row, col):
    first_seen_seats = ""
    for x in (-1, 0, 1):
        for y in (-1, 0, 1):
            step = 1
            if x == y == 0:
                continue
            while(0 <= row+x*step < len(seats) and
                  0 <= col+y*step < len(seats[0])):
                if seats[row+x*step][col+y*step] != '.':
                    first_seen_seats += seats[row+x*step][col+y*step]
                    break
                step += 1  # did not see a seat on this line, look further
    return first_seen_seats.count("#")


# Return the next layout after one round of the given rule
def get_next_layout(seats, visibility_rule):
    max_occupied = 4 if visibility_rule == "adjacent" else 5
    next_layout = copy.deepcopy(seats)
    for row in range(len(seats)):
        for col in range(len(seats[0])):
            occupied_seats = eval(f"count_occupied_{visibility_rule}_seats")(
                seats, row, col
            )
            if seats[row][col] == "L" and occupied_seats == 0:
                next_layout[row][col] = "#"
            elif seats[row][col] == "#" and occupied_seats >= max_occupied:
                next_layout[row][col] = "L"
    return next_layout


# Apply given rule on a given seat layout until it does not change anymore,
# and return the last layout
def get_last_layout(seats, visibility_rule):
    current_layout = copy.deepcopy(seats)
    next_layout = get_next_layout(current_layout, visibility_rule)
    while next_layout != current_layout:
        current_layout = next_layout
        next_layout = get_next_layout(current_layout, visibility_rule)
    return next_layout


# Return the number of occupied seats in a seat layout
def count_occupied_seat(seats):
    return sum([seat.count("#") for seat in seats])


seats = parse_input("input.txt")
# Puzzle 1
last_layout = get_last_layout(seats, "adjacent")
print("Number of occupied seats in the end, following the 'adjacent' rule:",
      count_occupied_seat(last_layout))
# Puzzle 2
last_layout = get_last_layout(seats, "first_seen")
print("Number of occupied seats in the end, following the 'first seen' rule:",
      count_occupied_seat(last_layout))
