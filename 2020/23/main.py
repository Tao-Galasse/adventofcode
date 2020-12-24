#!/usr/bin/env python

# Parse an input file and return the labels of the cups
def parse_input(filename):
    return open(filename, "r").read().strip()


# Do a move and return the new cups arrangement with the next current cup
def do_move(cups, current_cup):
    cups_to_move = ''
    for i in range(1, 4):  # select the cups to move
        cups_to_move += cups[(cups.index(current_cup)+i) % NB_CUPS]
    for cup_to_move in cups_to_move:  # remove them from the circle
        cups = cups.replace(cup_to_move, '')

    destination_cup = int(current_cup) - 1  # find the destination cup
    while str(destination_cup) not in cups:
        if str(destination_cup) > min(cups):
            destination_cup -= 1
        else:
            destination_cup = max(cups)

    # place the cups immediately clockwise of the destination cup
    destination_idx = cups.index(str(destination_cup))
    cups = cups[:destination_idx+1] + cups_to_move + cups[destination_idx+1:]
    return cups, cups[(cups.index(current_cup)+1) % NB_CUPS]


# Do a move "moves_number" times and return the last cups arrangement
def do_moves(cups, current_cup, moves_number):
    for i in range(moves_number):
        cups, current_cup = do_move(cups, current_cup)
    return cups


# Return the labels on the cups after cup 1
def labels_after_1(cups):
    return cups[cups.index('1')+1:] + cups[:cups.index('1')]


cups = parse_input("input.txt")
NB_CUPS = len(cups)
# Puzzle 1
cups = do_moves(cups, cups[0], 100)
print("After 100 moves: labels on the cups after cup 1:", labels_after_1(cups))
