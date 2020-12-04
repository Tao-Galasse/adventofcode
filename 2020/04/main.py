#!/usr/bin/env python

import copy
from fields_validations import *

REQUIRED_FIELDS = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]


# Parse lines from an input file to get the list of passports
def parse_input(filename):
    passports = []
    passport = {}
    with open(filename, "r") as file:
        for line in file.read().splitlines():
            build_passport(passports, passport, line)
    # we append one last time after reading the file,
    # because the final blank line is skipped by `splitlines`
    passports.append(passport)
    return passports


# Parse a given line to add its elements to the current passport
# e.g. of line format: "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd"
def build_passport(passports, passport, line):
    if line:
        for couple in line.split():
            key, value = couple.split(":")
            passport[key] = value
    else:
        passports.append(copy.deepcopy(passport))
        # a passport can be written in multiple lines,
        # so we reset its value only when we encounter an empty line
        passport.clear()


# Return true if all required fields in a passport are present
def is_passport_valid(passport):
    for field in REQUIRED_FIELDS:
        if not passport.get(field):
            return False
    return True


# Return true if a passport is valid, following extra data validation rules
def is_passport_data_valid(passport):
    for field in REQUIRED_FIELDS:
        method_name = f"is_{field}_valid"
        if not eval(method_name)(passport[field]):
            return False
    return True


# Return the number of passports with all required fields and valid passports
def count_valid_passports(passports):
    passports_with_all_fields = 0
    valid_passports = 0
    for passport in passports:
        if is_passport_valid(passport):
            passports_with_all_fields += 1
            if is_passport_data_valid(passport):
                valid_passports += 1
    return (passports_with_all_fields, valid_passports)


passports = parse_input("input.txt")
passports_with_all_fields, valid_passports = count_valid_passports(passports)
# Puzzle 1
print("number of passports with all fields:", passports_with_all_fields)
# Puzzle 2
print("number of valid passports:", valid_passports)
