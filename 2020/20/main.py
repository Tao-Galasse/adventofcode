#!/usr/bin/env python

from functools import reduce


# Parse lines from an input file to get the list of tiles
def parse_input(filename):
    tiles = {}
    lines = open(filename, "r").read().splitlines()
    tile = []  # DELETE ME?
    for i in range(0, len(lines)):
        if lines[i]:
            if lines[i].startswith("Tile"):
                current_id = lines[i].split("Tile ")[1][:-1]
            else:
                tile.append(lines[i])
        else:
            tiles[current_id] = tile
            tile = []
    # we add the last tile after reading the file,
    # because the final blank line is skipped by `splitlines`
    tiles[current_id] = tile
    return tiles


# Return the top border of a tile
def get_top_border(tile):
    return ''.join([char for char in tile[0]])


# Return the bottom border of a tile
def get_bottom_border(tile):
    return ''.join([char for char in tile[-1]])


# Return the left border of a tile
def get_left_border(tile):
    return ''.join([tile[i][0] for i in range(len(tile))])


# Return the right border of a tile
def get_right_border(tile):
    return ''.join([tile[i][-1] for i in range(len(tile))])


# Return all 8 borders of a tile (4 borders, normal and flipped)
def get_all_borders(tile):
    t = get_top_border(tile)
    b = get_bottom_border(tile)
    r = get_right_border(tile)
    l = get_left_border(tile)
    return [t, t[::-1], b, b[::-1], l, l[::-1], r, r[::-1]]


# A corner is a tile with 2 "unique" borders, matching none other border;
# we're looking for them and return them
def get_corner_ids(tiles):
    corner_ids = []
    for current_key in tiles.keys():
        tile_borders = get_all_borders(tiles.get(current_key))
        matching_borders = 0
        for next_key in tiles.keys():
            if current_key == next_key:  # don't want to compare the same tile
                continue
            next_tile_borders = get_all_borders(tiles.get(next_key))
            if any((border in next_tile_borders) for border in tile_borders):
                matching_borders += 1
        if matching_borders == 2:
            corner_ids.append(current_key)
    return corner_ids


tiles = parse_input("input.txt")
# Puzzle 1
corner_ids = get_corner_ids(tiles)
print("Multiplication of IDs from the four corner tiles:",
      reduce((lambda x, y: int(x) * int(y)), corner_ids))
