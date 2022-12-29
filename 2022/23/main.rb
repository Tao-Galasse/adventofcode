# frozen_string_literal: true

require 'set'

DIRECTIONS = %w[north south west east].freeze

def parse_input(filename)
  File.readlines(filename, chomp: true).each_with_object(Set.new).with_index do |(line, elves), i|
    line.chars.each_with_index { |char, j| elves << [i, j] if char == '#' }
  end
end

def round(direction_index)
  propositions = {}

  @elves.each do |elf|
    position = consider_direction(elf, direction_index)

    if propositions[position]
      propositions[position] << elf
    else
      propositions[position] = [elf]
    end
  end

  move_elves(propositions)
end

def consider_direction((x, y), direction_index)
  # If no other elves are in one of the eight adjacent positions, the elf does not do anything during this round
  return [x, y] if [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].map do |dx, dy|
    @elves.include?([x + dx, y + dy])
  end.none?

  4.times do |dir|
    direction = DIRECTIONS[(direction_index + dir) % 4]
    case direction
    when 'north'
      return [x - 1, y] if [[-1, -1], [-1, 0], [-1, 1]].map { |dx, dy| @elves.include?([x + dx, y + dy]) }.none?
    when 'south'
      return [x + 1, y] if [[1, -1], [1, 0], [1, 1]].map { |dx, dy| @elves.include?([x + dx, y + dy]) }.none?
    when 'west'
      return [x, y - 1] if [[-1, -1], [0, -1], [1, -1]].map { |dx, dy| @elves.include?([x + dx, y + dy]) }.none?
    when 'east'
      return [x, y + 1] if [[-1, 1], [0, 1], [1, 1]].map { |dx, dy| @elves.include?([x + dx, y + dy]) }.none?
    end
  end

  [x, y] # the elf couldn't move anywhere
end

def move_elves(propositions)
  propositions.inject(Set.new) do |next_elves, (next_position, elves)|
    next_elves + if elves.count > 1 # many elves want to move to the same location...
                   elves # ...so they stay where they are
                 else
                   [next_position]
                 end
  end
end

def count_empty_ground_tiles
  x_min, x_max = @elves.minmax_by { |x, _y| x }.map(&:first)
  y_min, y_max = @elves.minmax_by { |_x, y| y }.map(&:last)

  count = ((x_max - x_min + 1) * (y_max - y_min + 1)) - @elves.count
  puts "part 1: #{count}"
end

def find_last_round(check_at_round:)
  loop.with_index do |_, i|
    next_elves = round(i)
    return (i + 1) if next_elves == @elves # the elves don't move anymore

    @elves = next_elves
    count_empty_ground_tiles if (i + 1) == check_at_round # we do a check at a certain round on part 1
  end
end

@elves = parse_input('input.txt')
puts "part 2: #{find_last_round(check_at_round: 10)}" # takes ~2min on my machine (MacBook Pro 2019 2,6 GHz)
