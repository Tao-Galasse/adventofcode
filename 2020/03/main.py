#!/usr/bin/env python

from functools import reduce


# Parse lines from an input file to get the map of the area
def parse_input(filename):
    map = []
    with open(filename, "r") as file:
        for line in file.read().splitlines():
            map.append(list(line))
    return map


# Return true if there is a tree at a given position,
# defined by its x and y coordinates
def is_tree(map, x, y):
    return map[x][y % len(map[0])] == '#'


# Return the number of encountered trees following a given slope
def count_encountered_trees(map, x_slope, y_slope):
    current_x = 0
    current_y = 0
    count = 0

    while (current_x + x_slope) < len(map):
        current_x += x_slope
        current_y += y_slope
        if is_tree(map, current_x, current_y):
            count += 1
    return count


# Return a list of the number of encountered trees for each given slope
def count_encountered_trees_for_each_slope(map, slopes):
    results = []
    for slope in slopes:
        results.append(count_encountered_trees(map, slope[0], slope[1]))
    return results


map = parse_input("input.txt")
# Puzzle 1
print("Tree encountered with a slope of right 3 and down 1:",
      count_encountered_trees(map, 1, 3))
# Puzzle 2
slopes = [
    [1, 1],  # Right 1, down 1
    [1, 3],  # Right 3, down 1
    [1, 5],  # Right 5, down 1
    [1, 7],  # Right 7, down 1
    [2, 1],  # Right 1, down 2
]
trees_by_slope = count_encountered_trees_for_each_slope(map, slopes)
print("Multiplication of all encountered trees with each slope:",
      reduce((lambda x, y: x * y), trees_by_slope))
