#!/usr/bin/env python

import copy


# Parse lines from an input file to get the deck of each player
def parse_input(filename):
    deck1 = []
    deck2 = []
    current_deck = deck1
    for line in open(filename, 'r').read().splitlines():
        if line.isdigit():
            current_deck.append(int(line))
        if not line:
            current_deck = deck2
    return deck1, deck2


# Play a Combat round
def play_combat_round(deck1, deck2):
    if deck1[0] > deck2[0]:
        update_decks(deck1, deck2)
    else:
        update_decks(deck2, deck1)


# Update winner's and loser's deck after a round
def update_decks(winner_deck, loser_deck):
    winner_deck.append(winner_deck[0])
    winner_deck.append(loser_deck[0])
    winner_deck.pop(0)
    loser_deck.pop(0)


# Play the Combat game and return the winner's deck
def play_combat_game(deck1, deck2):
    while len(deck1) > 0 and len(deck2) > 0:
        play_combat_round(deck1, deck2)
    return deck1 if len(deck1) > 0 else deck2


# Calculate and return the winner's score
def get_winner_score(winner_deck):
    total = 0
    for i in range(len(winner_deck)):
        total += winner_deck[i] * (len(winner_deck) - i)
    return total


# Play a Recursive Combat round and update decks
def play_recursive_combat_round(deck1, deck2):
    if len(deck1) > deck1[0] and len(deck2) > deck2[0]:
        sub_deck1 = copy.deepcopy(deck1[1:deck1[0]+1])
        sub_deck2 = copy.deepcopy(deck2[1:deck2[0]+1])
        play_recursive_combat_game(sub_deck1, sub_deck2)
        if len(sub_deck1) > 0:
            winner_deck, loser_deck = deck1, deck2
        else:
            winner_deck, loser_deck = deck2, deck1
        update_decks(winner_deck, loser_deck)
    else:
        play_combat_round(deck1, deck2)


# Play the Recursive Combat game and return the winner's and loser's decks
def play_recursive_combat_game(deck1, deck2):
    memoized_decks = []
    while len(deck1) > 0 and len(deck2) > 0:
        if (deck1, deck2) in memoized_decks:  # anti infinite loop rule
            return deck1
        memoized_decks.append((copy.deepcopy(deck1), copy.deepcopy(deck2)))
        play_recursive_combat_round(deck1, deck2)
    return deck1 if len(deck1) > 0 else deck2


# Puzzle 1
deck1, deck2 = parse_input("input.txt")
winner_deck = play_combat_game(deck1, deck2)
print("winner score =", get_winner_score(winner_deck))
# Puzzle 2
deck1, deck2 = parse_input("input.txt")  # we reinitialize the players' decks
winner_deck = play_recursive_combat_game(deck1, deck2)
print("winner score =", get_winner_score(winner_deck))
