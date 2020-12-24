#!/usr/bin/env python

# Parse an input file and return a dictionary
# associating the label of a cup with the label of the next cup
def get_cups(filename):
    labels = open(filename, 'r').read().strip()
    cups = {}
    for i in range(len(labels)):
        cups[int(labels[i])] = int(labels[(i+1) % len(labels)])
    return cups


# Do a move and return the next current cup
def do_move(cups, current_cup):
    cups_to_move = [cups[current_cup]]  # select the cups to move
    for _ in range(2):
        cups_to_move.append(cups[cups_to_move[-1]])
    # attach the current cup to the one after them and remove them
    cups[current_cup] = cups[cups_to_move[-1]]
    for cup_to_move in cups_to_move:
        del cups[cup_to_move]

    destination_cup = current_cup - 1  # find the destination cup
    while destination_cup not in cups:
        destination_cup -= 1
        if destination_cup < 0:
            destination_cup = max(cups)

    # place the cups to move immediately clockwise of the destination cup
    next_cup = cups[destination_cup]
    for cup_to_move in cups_to_move:
        cups[destination_cup] = cup_to_move
        destination_cup = cup_to_move
    cups[destination_cup] = next_cup  # rattach them to the rest of the circle

    return cups[current_cup]


# Do a move "moves_number" times and return the last cups arrangement
def do_moves(cups, current_cup, moves_number):
    for _ in range(moves_number):
        current_cup = do_move(cups, current_cup)


# Return the labels on the cups after cup 1
def labels_after_1(cups):
    labels = str(cups[1])
    while cups[int(labels[-1])] != 1:
        labels += str(cups[int(labels[-1])])
    return labels


# Parse an input file and return a dictionary
# associating the label of a cup with the label of the next cup until 1 million
def get_cups_to_one_million(filename):
    labels = open(filename, 'r').read().strip()
    cups = {}
    for i in range(len(labels)-1):
        cups[int(labels[i])] = int(labels[i+1])
    cups[int(labels[-1])] = len(labels)+1
    for i in range(len(labels)+1, 1000000+1):
        cups[i] = i+1
    cups[i] = int(labels[0])
    return cups


# Puzzle 1
filename = "input.txt"
cups = get_cups(filename)
first_cup = int(open(filename, 'r').read()[0])
do_moves(cups, first_cup, 100)
print("After 100 moves: labels on the cups after cup 1:", labels_after_1(cups))
# Puzzle 2
cups = get_cups_to_one_million(filename)
do_moves(cups, first_cup, 10000000)
print("Multiplication of the two cups immediately clockwise of cup 1:",
      cups[1] * cups[cups[1]])
