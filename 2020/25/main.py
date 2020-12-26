#!/usr/bin/env python

# Parse an input file and return the card_public_key and door_public_key
def parse_input(filename):
    return [int(i) for i in open(filename, "r").read().splitlines()]


# Find the secret loop size thanks to a public key
def find_loop_size(public_key):
    loop_size = 1
    value = 7
    while value != public_key:
        value = value * 7 % 20201227
        loop_size += 1
    return loop_size


# Find the encryption key thanks to a public key and a loop size
def find_encryption_key(subject_number, loop_size):
    value = 1
    for _ in range(loop_size):
        value = value * subject_number % 20201227
    return value


card_public_key, door_public_key = parse_input("input.txt")
card_loop_size = find_loop_size(card_public_key)
print("Encryption_key:", find_encryption_key(door_public_key, card_loop_size))
