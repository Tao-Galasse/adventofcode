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
def valid_password_sled_rental_place(dictionary):
    occurrences = dictionary["password"].count(dictionary["letter"])
    return (occurrences >= dictionary["min"] and
            occurrences <= dictionary["max"])


# Return true if a password is valid,
# following the Official Toboggan Corporate Policy
def valid_password_toboggan_corporate(dictionary):
    letter1 = dictionary["password"][dictionary["min"] - 1]
    letter2 = dictionary["password"][dictionary["max"] - 1]

    return ((letter1 == dictionary["letter"]) !=
            (letter2 == dictionary["letter"]))


# Call the correct valid_password method following the given policy
def valid_password(dictionary, policy):
    if policy == "sled_rental_place":
        return valid_password_sled_rental_place(dictionary)
    if policy == "toboggan_corporate":
        return valid_password_toboggan_corporate(dictionary)
    print("invalid policy!")
    return 0


# Return the number of valid passwords in a list of dictionaries,
# following a policy: "sled_rental_place" or "toboggan_corporate"
def number_of_valid_passwords(dictionaries, policy):
    count = 0
    for dictionary in dictionaries:
        if valid_password(dictionary, policy):
            count += 1
    return count


dictionaries = parse_input("input.txt")
# Puzzle 1
print("Puzzle 1 answer:",
      number_of_valid_passwords(dictionaries, "sled_rental_place"))
# Puzzle 2
print("Puzzle 2 answer:",
      number_of_valid_passwords(dictionaries, "toboggan_corporate"))
