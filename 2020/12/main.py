#!/usr/bin/env python

# Parse lines from an input file to get the list of instructions
def parse_input(file):
    return [(s[0], int(s[1:])) for s in open(file, "r").read().splitlines()]


# Execute an instruction and return the new position and direction of the boat
def read_instruction(position, direction, instruction):
    x, y = position
    action, value = instruction

    if action == 'N' or (action == 'F' and direction == 'N'):
        return (x, y+value), direction
    if action == 'S' or (action == 'F' and direction == 'S'):
        return (x, y-value), direction
    if action == 'E' or (action == 'F' and direction == 'E'):
        return (x+value, y), direction
    if action == 'W' or (action == 'F' and direction == 'W'):
        return (x-value, y), direction

    # If we are here, we have to turn the boat: it's time to use our compass!
    compass = ['N', 'E', 'S', 'W']
    if action == 'L':
        return (x, y), compass[(compass.index(direction) - int(value/90)) % 4]
    return (x, y), compass[(compass.index(direction) + int(value/90)) % 4]


# Execute a waypoint-based instruction
# and return the new position and waypoint value of the boat
def read_waypoint_instruction(position, waypoint, instruction):
    x_pos, y_pos = position
    action, value = instruction
    x_wp, y_wp = waypoint

    if action == 'N':
        waypoint = (x_wp, y_wp+value)
    elif action == 'S':
        waypoint = (x_wp, y_wp-value)
    elif action == 'E':
        waypoint = (x_wp+value, y_wp)
    elif action == 'W':
        waypoint = (x_wp-value, y_wp)
    elif action == 'F':
        position = (x_pos+value*x_wp, y_pos+value*y_wp)
    elif action == 'L':
        while value > 0:
            x_wp, y_wp = -y_wp, x_wp
            value -= 90
        waypoint = (x_wp, y_wp)
    elif action == 'R':
        while value > 0:
            x_wp, y_wp = y_wp, -x_wp
            value -= 90
        waypoint = (x_wp, y_wp)

    return position, waypoint


# Follow a list of instructions from a starting position and direction;
# then return the final position of the boat
def follow_instructions(instructions, position, direction):
    for instr in instructions:
        position, direction = read_instruction(position, direction, instr)
    return position


# Follow a list of waypoint-based instructions from a starting position
# and waypoint; then return the final position of the boat
def follow_waypoint_instructions(instructions, pos, waypoint):
    for instr in instructions:
        pos, waypoint = read_waypoint_instruction(pos, waypoint, instr)
    return pos


instructions = parse_input("input.txt")
# Puzzle 1
x, y = follow_instructions(instructions, (0, 0), 'E')
print("Manhattan distance between start and final positions:",
      abs(x) + abs(y))
# Puzzle 2
x, y = follow_waypoint_instructions(instructions, (0, 0), (10, 1))
print("Manhattan distance between start and final positions with waypoint:",
      abs(x) + abs(y))
