#!/usr/bin/env python

import re


# Parse an input file and return a list of tiles represented as coordinates
def get_tiles(filename):
    tiles = []
    for tile in open(filename, 'r').read().splitlines():
        directions = re.findall('e|se|sw|w|nw|ne', tile)
        x = y = 0
        for direction in directions:
            coordinates = direction_to_coordinates(direction)
            x += coordinates[0]
            y += coordinates[1]
        tiles.append((x, y))

    return tiles


# Convert a direction into a tuple of spatial coordinates
# nw ne
# w  #  e
#    sw se
def direction_to_coordinates(direction):
    return {
        'e': (1, 0),
        'se': (1, -1),
        'sw': (0, -1),
        'w': (-1, 0),
        'nw': (-1, 1),
        'ne': (0, 1)
    }[direction]


# Flip the tiles from white to black and return the black tiles
def flip_tiles(tiles):
    black_tiles = set()
    for tile in tiles:
        if tile in black_tiles:
            black_tiles.remove(tile)
        else:
            black_tiles.add(tile)
    return black_tiles


# The only interesting tiles are the ones adjacent to a black tile,
# so we update the tiles list by adding these to it.
def update_tiles_list(tiles, black_tiles):
    for tile in black_tiles:
        for direction in [(1, 0), (1, -1), (0, -1), (-1, 0), (-1, 1), (0, 1)]:
            x = tile[0]+direction[0]
            y = tile[1]+direction[1]
            tiles.add((x, y))


# Return the number of black tiles immediately adjacent to a given one
def count_adjacent_blacks(tile, black_tiles):
    count = 0
    for direction in [(1, 0), (1, -1), (0, -1), (-1, 0), (-1, 1), (0, 1)]:
        x = tile[0]+direction[0]
        y = tile[1]+direction[1]
        if (x, y) in black_tiles:
            count += 1
    return count


# Apply rules one time to every tile,
# and return the updated lists of tiles and black tiles
def apply_rules(tiles, black_tiles):
    update_tiles_list(tiles, black_tiles)
    next_black_tiles = set(black_tiles)
    for tile in tiles:
        if tile in black_tiles:
            if count_adjacent_blacks(tile, black_tiles) not in (1, 2):
                next_black_tiles.remove(tile)
        else:
            if count_adjacent_blacks(tile, black_tiles) == 2:
                next_black_tiles.add(tile)
    return next_black_tiles


tiles = get_tiles("input.txt")
# Puzzle 1
black_tiles = flip_tiles(tiles)
print("Number of black tiles after flipping them:", len(black_tiles))
# Puzzle 2
tiles = set(tiles)  # to avoid duplicated tiles in the list
for _ in range(100):
    black_tiles = apply_rules(tiles, black_tiles)
print("Number of black tiles after 100 days:", len(black_tiles))
