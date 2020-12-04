#!/usr/bin/env python

import re


# byr (Birth Year) - four digits; at least 1920 and at most 2002.
def is_byr_valid(byr):
    return len(byr) == 4 and 1920 <= int(byr) <= 2002


# iyr (Issue Year) - four digits; at least 2010 and at most 2020.
def is_iyr_valid(iyr):
    return len(iyr) == 4 and 2010 <= int(iyr) <= 2020


# eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
def is_eyr_valid(eyr):
    return len(eyr) == 4 and 2020 <= int(eyr) <= 2030


# hgt (Height) - a number followed by either cm or in:
#     If cm, the number must be at least 150 and at most 193.
#     If in, the number must be at least 59 and at most 76.
def is_hgt_valid(hgt):
    if hgt[-2:] == "cm":
        cm = int(hgt.split("cm")[0])
        return 150 <= cm <= 193
    else:
        inches = int(hgt.split("in")[0])
        return 59 <= inches <= 76


# hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
def is_hcl_valid(hcl):
    return bool(re.match("#[0-9a-f]{6}$", hcl))


# ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
def is_ecl_valid(ecl):
    return ecl in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]


# pid (Passport ID) - a nine-digit number, including leading zeroes.
def is_pid_valid(pid):
    return bool(re.match("[0-9]{9}$", pid))
