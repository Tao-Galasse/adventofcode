#!/usr/bin/env python

from functools import reduce
import math


# Parse lines from an input file to get the list of tiles
def parse_input(filename):
    tiles = {}
    lines = open(filename, "r").read().splitlines()
    tile = []
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
def top_border(tile):
    return tile[0]


# Return the bottom border of a tile
def bottom_border(tile):
    return tile[-1]


# Return the left border of a tile
def left_border(tile):
    return ''.join([line[0] for line in tile])


# Return the right border of a tile
def right_border(tile):
    return ''.join([line[-1] for line in tile])


# Return all 4 borders of a tile
def borders_side1(tile):
    top = top_border(tile)
    bottom = bottom_border(tile)
    right = right_border(tile)
    left = left_border(tile)
    return set({top, bottom, right, left})


# Return all 8 borders of a tile (4 borders, normal and flipped)
def all_borders(tile):
    borders = borders_side1(tile)
    return borders.union(set(line[::-1] for line in borders))


# Turn a tile clockwise
def turn(id):
    TILES[id] = list(map(''.join, zip(*reversed(TILES[id]))))


# Flip a tile
def flip(id):
    TILES[id] = [line[::-1] for line in TILES[id]]


# Return the ID of the first corner found and place it in the top left
def find_first_corner():
    for current_id in TILES.keys():
        tile = TILES[current_id]
        unique_borders = list(borders_side1(tile))
        for next_id in TILES.keys():
            if current_id == next_id:  # don't want to compare the same tile
                continue
            for border in unique_borders:
                if border in all_borders(TILES[next_id]):  # is a common border
                    unique_borders.remove(border)  # this border is not unique
                    break
            if len(unique_borders) < 2:
                break  # we don't need to continue if we had 3 matches
        if len(unique_borders) == 2:  # we have 2 unique borders: it's a corner
            # unique borders should be on top and left sides
            turn_first_corner(current_id, unique_borders)
            return current_id


# Oriente a corner tile to have the unique borders on the top and left sides
def turn_first_corner(id, unique_borders):
    tile = TILES[id]
    top = top_border(tile)
    right = right_border(tile)
    if top in unique_borders:
        if right in unique_borders:  # top-right: needs 3 clockwise turns
            for _ in range(3):
                turn(id)
    else:
        if right in unique_borders:  # bottom-right: needs 2 clockwise turns
            for _ in range(2):
                turn(id)
        else:
            turn(id)  # bottom-left: needs 1 clockwise turn


# Solve the puzzle by orienting each tile in a valid position
# and return the list of ordered ids, from left to right and top to bottom
def solve_puzzle(corner_id):
    # We start from the top-left corner
    ordered_ids = [corner_id]
    remaining_tiles = list(TILES.keys())
    remaining_tiles.remove(corner_id)
    border_to_find = right_border(TILES[corner_id])

    while remaining_tiles:
        for id in remaining_tiles:
            if border_to_find in all_borders(TILES[id]):  # next tile found!
                orientate_tile(id, border_to_find, ordered_ids)  # position it
                ordered_ids.append(id)
                border_to_find = next_border_to_find(id, ordered_ids)
                remaining_tiles.remove(id)
                break
    return ordered_ids


# Orientate a given tile to match the position of a previous tile
def orientate_tile(id, border_to_find, ordered_ids):
    while True:
        for _ in range(3):  # we turn our tile a maximum of 3 times
            if border_to_compare(id, ordered_ids) == border_to_find:
                break  # we found the good position, stop turning!
            turn(id)
        if border_to_compare(id, ordered_ids) == border_to_find:
            break
        flip(id)  # if any of the 4 borders works, we flip the tile & try again


# Return the border to compare depending on our position in the puzzle:
# if the beggining of a line, we compare the top border of the current tile;
# anywhere else, we compare the left border of the courrent tile
def border_to_compare(id, ordered_ids):
    if len(ordered_ids) % PUZZLE_DIM == 0:
        return top_border(TILES[id])
    else:
        return left_border(TILES[id])


# Return the next border to find after orienting a tile:
# if we completed a line, we'll have to find
# the same border than the bottom of the first tile of our line;
# otherwise, we'll have to find the same border than the right of our tile
def next_border_to_find(id, ordered_ids):
    if len(ordered_ids) % PUZZLE_DIM == 0:
        first_tile_of_line = TILES[ordered_ids[len(ordered_ids)-PUZZLE_DIM]]
        return bottom_border(first_tile_of_line)
    else:
        return right_border(TILES[id])


# Return the corner tiles IDs of the puzzle
def get_corner_ids(ordered_ids):
    return [
        ordered_ids[0],
        ordered_ids[PUZZLE_DIM-1],
        ordered_ids[-PUZZLE_DIM],
        ordered_ids[len(TILES)-1]
    ]


# Build the image by removing borders of each tile
def build_image(ordered_ids):
    image = []
    for row in range(PUZZLE_DIM):
        for _ in range(TILE_LENGTH-2):
            image.append('')  # add new lines to the image
        for col in range(PUZZLE_DIM):
            tile = TILES[ordered_ids[row*PUZZLE_DIM+col]]
            for i in range(TILE_LENGTH-2):
                image[row*(TILE_LENGTH-2)+i] += tile[i+1][1:-1]
    return image


# Count and return the total of sea monsters seen in the image
def count_sea_monsters_on(image):
    height_monster = len(SEA_MONSTER)
    width_monster = len(SEA_MONSTER[0])
    count = 0
    for row in range(len(image)-height_monster):
        for col in range(len(image)-width_monster):
            seen = True
            for sub_row in range(height_monster):
                for sub_col in range(width_monster):
                    if (SEA_MONSTER[sub_row][sub_col] == '#' and
                       image[row+sub_row][col+sub_col] != '#'):
                        seen = False
                        break
                if not seen:
                    break
            if seen:
                count += 1
    return count


# Turn and flip an image until we can see at least one sea monster,
# and return the total of sea monsters seen
def count_sea_monsters(image):
    while True:
        for _ in range(4):   # we turn our image a maximum of 4 times
            count = count_sea_monsters_on(image)
            if count:
                return count
            image = list(map(''.join, zip(*reversed(image))))  # turn the image
        image = [line[::-1] for line in image]  # flip the image


# Initialization
TILES = parse_input("input.txt")
PUZZLE_DIM = int(math.sqrt(len(TILES)))
TILE_LENGTH = len(TILES[list(TILES.keys())[0]])

# Puzzle 1
corner_id = find_first_corner()
ordered_ids = solve_puzzle(corner_id)
corner_ids = get_corner_ids(ordered_ids)
print("Multiplication of IDs from the four corner tiles:",
      reduce((lambda x, y: int(x) * int(y)), corner_ids))

# Puzzle 2
image = build_image(ordered_ids)
SEA_MONSTER = "\
                  # \n\
#    ##    ##    ###\n\
 #  #  #  #  #  #   ".split('\n')
sea_monsters_count = count_sea_monsters(image)
hash_in_sea_monster = ''.join(SEA_MONSTER).count('#')
hash_in_image = ''.join(image).count('#')
print("Water roughness (number of `#` that are not part of a sea monster):",
      hash_in_image - hash_in_sea_monster * sea_monsters_count)
