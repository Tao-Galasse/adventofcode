#!/usr/bin/env python

import math


# Parse lines from an input file to get the notes
def parse_input(filename):
    lines = open(filename, "r").read().splitlines()
    return int(lines[0]), lines[1].split(',')


# Return the list of the first possible departures timestamps for each bus
def first_departures_timestamps(timestamp, bus_ids):
    return [math.ceil(timestamp/bus_id) * bus_id for bus_id in bus_ids]


# Return the earliest timestamp such that all bus IDs depart at offsets
# matching their positions in the list
def find_t(valid_bus_ids):
    t = valid_bus_ids[0]
    common_den = valid_bus_ids[0]  # common denominator of bus ids
    for bus_id in valid_bus_ids[1:]:
        while (t+BUS_IDS.index(str(bus_id))) % bus_id != 0:
            t += common_den
        common_den *= bus_id
    return t


depart_timestamp, BUS_IDS = parse_input('input.txt')
# Puzzle 1
valid_bus_ids = [int(id) for id in BUS_IDS if id != 'x']
timestamps = first_departures_timestamps(depart_timestamp, valid_bus_ids)
first_bus_id = valid_bus_ids[timestamps.index(min(timestamps))]
minutes_to_wait = min(timestamps) - depart_timestamp
print("Puzzle 1 answer:", first_bus_id * minutes_to_wait)
# Puzzle 2
print("Puzzle 2 answer:", find_t(valid_bus_ids))
