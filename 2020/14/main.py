#!/usr/bin/env python

import copy
from itertools import chain


# Parse lines from an input file to execute the initialization program
# following a version of the decoder chip
def parse_input(filename, version):
    memory = {}
    with open(filename, "r") as file:
        for line in file.read().splitlines():
            if line.startswith('mask'):
                mask = line.split(' = ')[1]
            else:
                address = int(line[4:].split(']')[0])
                value = int(line.split('= ')[1])
                if version == 'v1':
                    memory[address] = apply_mask(value, mask)
                else:
                    addresses = apply_mask_v2(address, mask)
                    for address in addresses:
                        memory[int(''.join(address), 2)] = value
    return memory


# Apply a given mask to a value and return the result in base 10
def apply_mask(value, mask):
    # format value to a 36-length list of its binary representation
    # (we have to convert value into a list because strings are immutable)
    value = list(format(value, '036b'))
    for i in range(len(mask)):
        if mask[i] != 'X':
            value[i] = mask[i]
    return int(''.join(value), 2)  # format value to an int


# Apply a given mask to an address and return the list of addresses in base 2
def apply_mask_v2(address, mask):
    # format address to a 36-length list of its binary representation
    # (we have to convert address into a list because strings are immutable)
    address = list(format(address, '036b'))
    for i in range(len(mask)):
        if mask[i] != '0':
            address[i] = mask[i]
    addresses = get_addresses(address)
    return addresses


# Return a list of exact addresses in base 2 from an address with floating bits
def get_addresses(address):
    addresses = [address]
    while 'X' in list(chain.from_iterable(addresses)):  # concat addresses
        for address in addresses:
            if 'X' not in address:
                continue
            index = address.index('X')
            address[index] = '0'
            addresses.append(copy.deepcopy(address))
            address[index] = '1'
            addresses.append(copy.deepcopy(address))
            addresses.remove(address)
    return addresses


# Puzzle 1
memory = parse_input('input.txt', 'v1')
print("sum of values left in memory in the end (v1):", sum(memory.values()))
# Puzzle 2
memory = parse_input('input.txt', 'v2')
print("sum of values left in memory in the end (v2):", sum(memory.values()))
