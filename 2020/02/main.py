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


# Return true if a password is valid, following its corporate policy
def valid_password(dictionary):
    occurrences = dictionary["password"].count(dictionary["letter"])
    return (occurrences >= dictionary["min"] and
            occurrences <= dictionary["max"])


# Return the number of valid password in a list of dictionaries
def number_of_valid_password(dictionaries):
    count = 0
    for dictionary in dictionaries:
        if valid_password(dictionary):
            count += 1
    return count


# Puzzle 1
dictionaries = parse_input("input.txt")
print(number_of_valid_password(dictionaries))
