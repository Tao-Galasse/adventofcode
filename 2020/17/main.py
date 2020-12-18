#!/usr/bin/env python

import copy


# Parse lines from an input file to get the initial state of the 3D grid
def parse_input_3d(filename):
    grid = {}
    x = 0
    for line in open(filename, 'r').read().splitlines():
        y = 0
        for char in line:
            grid[(x, y, 0)] = 1 if char == '#' else 0
            y += 1
        x += 1
    return grid


# Return the next state of a given 3D grid after a full cycle
def next_3d_grid(grid):
    next_grid = copy.deepcopy(grid)
    min_x = min(k[0] for k in grid.keys())
    max_x = max(k[0] for k in grid.keys())
    min_y = min(k[1] for k in grid.keys())
    max_y = max(k[1] for k in grid.keys())
    min_z = min(k[2] for k in grid.keys())
    max_z = max(k[2] for k in grid.keys())
    for x in range(min_x - 1, max_x + 2):
        for y in range(min_y - 1, max_y + 2):
            for z in range(min_z - 1, max_z + 2):
                next_grid[(x, y, z)] = next_3d_cube(grid, x, y, z)
    return next_grid


# Return the next state of a given 3D cube, identified by its coordinates
def next_3d_cube(grid, x, y, z):
    active_neighbors = 0
    for xx in range(x-1, x+2):
        for yy in range(y-1, y+2):
            for zz in range(z-1, z+2):
                if x == xx and y == yy and z == zz:
                    continue
                if grid.get((xx, yy, zz)):
                    active_neighbors += 1
    if grid.get((x, y, z)):
        return 1 if active_neighbors in [2, 3] else 0
    else:
        return 1 if active_neighbors == 3 else 0


# Puzzle 1
grid = parse_input_3d("input.txt")
for _ in range(6):
    grid = next_3d_grid(grid)
print("Number of 3D cubes left in the active state after the sixth cycle:",
      list(grid.values()).count(1))


###############################################################################


# Parse lines from an input file to get the initial state of the 4D grid
def parse_input_4d(filename):
    grid = {}
    x = 0
    for line in open(filename, 'r').read().splitlines():
        y = 0
        for char in line:
            grid[(x, y, 0, 0)] = 1 if char == '#' else 0
            y += 1
        x += 1
    return grid


# Return the next state of a given 4D grid after a full cycle
def next_4d_grid(grid):
    next_grid = copy.deepcopy(grid)
    min_x = min(k[0] for k in grid.keys())
    max_x = max(k[0] for k in grid.keys())
    min_y = min(k[1] for k in grid.keys())
    max_y = max(k[1] for k in grid.keys())
    min_z = min(k[2] for k in grid.keys())
    max_z = max(k[2] for k in grid.keys())
    min_w = min(k[3] for k in grid.keys())
    max_w = max(k[3] for k in grid.keys())
    for x in range(min_x - 1, max_x + 2):
        for y in range(min_y - 1, max_y + 2):
            for z in range(min_z - 1, max_z + 2):
                for w in range(min_w - 1, max_w + 2):
                    next_grid[(x, y, z, w)] = next_4d_cube(grid, x, y, z, w)
    return next_grid


# Return the next state of a given 4D cube, identified by its coordinates
def next_4d_cube(grid, x, y, z, w):
    active_neighbors = 0
    for xx in range(x-1, x+2):
        for yy in range(y-1, y+2):
            for zz in range(z-1, z+2):
                for ww in range(w-1, w+2):
                    if x == xx and y == yy and z == zz and w == ww:
                        continue
                    if grid.get((xx, yy, zz, ww)):
                        active_neighbors += 1
    if grid.get((x, y, z, w)):
        return 1 if active_neighbors in [2, 3] else 0
    else:
        return 1 if active_neighbors == 3 else 0


# Puzzle 2
grid = parse_input_4d("input.txt")
for _ in range(6):
    grid = next_4d_grid(grid)
print("Number of 4D cubes left in the active state after the sixth cycle:",
      list(grid.values()).count(1))
