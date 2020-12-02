#!/usr/bin/env python

import re


# Parse lines from an input file to get a list of dictionaries
def parse_input(filename):
    dictionaries = []

    with open(filename, "r") as file:
        for line in file.read().splitlines():
            dictionaries.append(build_dictionary(line))

    return dictionaries


# Build a dictionary containing a corporate policy and a password
def build_dictionary(line):
    min, max, letter, password = re.split("[- :]+", line)
    return {
        "min": int(min),
        "max": int(max),
        "letter": letter,
        "password": password
    }


# Return true if a password is valid, following the sled rental place policy
def valid_password1(dictionary):
    occurrences = dictionary["password"].count(dictionary["letter"])
    return (occurrences >= dictionary["min"] and
            occurrences <= dictionary["max"])


# Return true if a password is valid,
# following the Official Toboggan Corporate Policy
def valid_password2(dictionary):
    letter1 = dictionary["password"][dictionary["min"] - 1]
    letter2 = dictionary["password"][dictionary["max"] - 1]

    if letter1 == letter2:
        return False

    return letter1 == dictionary["letter"] or letter2 == dictionary["letter"]


# Call the correct valid_password method following the given policy
def valid_password(dictionary, policy):
    if policy == 1:
        return valid_password1(dictionary)
    return valid_password2(dictionary)


# Return the number of valid passwords in a list of dictionaries,
# following a policy: 1 for the sled rental place, 2 for the Toboggan Corporate
def number_of_valid_passwords(dictionaries, policy):
    count = 0
    for dictionary in dictionaries:
        if valid_password(dictionary, policy):
            count += 1
    return count


dictionaries = parse_input("input.txt")
# Puzzle 1
print("Puzzle 1 answer:", number_of_valid_passwords(dictionaries, 1))
# Puzzle 2
print("Puzzle 2 answer:", number_of_valid_passwords(dictionaries, 2))
