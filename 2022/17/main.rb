# frozen_string_literal: true

require 'set'

ROCKS = [ # each rock appears so that its left edge is two units away from the left wall
  [[0, 2], [0, 3], [0, 4], [0, 5]],
  [[0, 3], [1, 2], [1, 3], [1, 4], [2, 3]],
  [[0, 2], [0, 3], [0, 4], [1, 4], [2, 4]],
  [[0, 2], [1, 2], [2, 2], [3, 2]],
  [[0, 2], [0, 3], [1, 2], [1, 3]]
].freeze

def all_rocks_fall(quantity)
  jet_index = 0
  quantity.times do |rock_index|
    jet_index += one_rock_fall(rock_index, jet_index)
  end
end

def one_rock_fall(rock_index, jet_index)
  current_rock = ROCKS[rock_index % 5]
  # each rock appears so its bottom edge is three units above the highest rock in the room
  current_rock = current_rock.map { |x, y| [x + @highest_rock + 4, y] }

  loop.with_index do |_, i|
    current_rock = move_horizontally(current_rock, @jets[(jet_index + i) % @jets.size])
    next_rock = move_downward(current_rock)
    if current_rock == next_rock # the rock stopped falling
      @highest_rock = [@highest_rock, current_rock.max_by { |x, _y| x }[0]].max
      @stopped_rocks += current_rock
      return i + 1
    else
      current_rock = next_rock
    end
  end
end

def move_horizontally(rock, direction)
  if direction == '>'
    next_rock = rock.map { |x, y| [x, y + 1] }
    next_rock.any? { |x, y| @stopped_rocks.include?([x, y]) || y > 6 } ? rock : next_rock
  else
    next_rock = rock.map { |x, y| [x, y - 1] }
    next_rock.any? { |x, y| @stopped_rocks.include?([x, y]) || y < 0 } ? rock : next_rock
  end
end

def move_downward(rock)
  next_rock = rock.map { |x, y| [x - 1, y] }
  next_rock.any? { |x, y| @stopped_rocks.include?([x, y]) } ? rock : next_rock
end

@jets = File.read('input.txt').chars[..-2] # remove the final \n
@stopped_rocks = Set.new([[0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6]]) # initialized with the floor
@highest_rock = 0

all_rocks_fall(2022)
puts "part 1: #{@highest_rock}"
