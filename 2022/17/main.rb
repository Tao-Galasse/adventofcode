# frozen_string_literal: true

require 'set'

ROCKS = [ # each rock appears so that its left edge is two units away from the left wall
  [[0, 2], [0, 3], [0, 4], [0, 5]],
  [[0, 3], [1, 2], [1, 3], [1, 4], [2, 3]],
  [[0, 2], [0, 3], [0, 4], [1, 4], [2, 4]],
  [[0, 2], [1, 2], [2, 2], [3, 2]],
  [[0, 2], [0, 3], [1, 2], [1, 3]]
].freeze

def detect_cycle
  @stopped_rocks = Set.new([[0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6]]) # initialized with the floor
  highest_rock = jet_index = 0
  cycle_keys = {}
  loop.with_index do |_, rock_index|
    highest_rock, jet_index = one_rock_fall(highest_rock, rock_index, jet_index)
    cycle_data = compute_cycle_data(cycle_keys, rock_index, jet_index)
    return cycle_data if cycle_data
  end
end

def compute_cycle_data(cycle_keys, rock_index, jet_index)
  rocks_absolute_heights = (0..6).each.map do |i|
    @stopped_rocks.select { |_x, y| y == i }.max_by { |x, _y| x }[0]
  end
  rocks_relative_heights = rocks_absolute_heights.map { |height| height - rocks_absolute_heights.min }
  cycle_key = [rock_index % 5, jet_index % @jets.size, rocks_relative_heights]

  # A cycle is found when we get the same heights on the seven columns, with the same rock index & jet_index
  if cycle_keys.include?(cycle_key)
    loop_start_index, loop_start_max_height = cycle_keys[cycle_key]
    rock_diff = rock_index - loop_start_index # on each cycle, there are `rock_diff` rocks falling
    height_diff = rocks_absolute_heights.max - loop_start_max_height # on each cycle, increment the heights with this
    [loop_start_index, rock_diff, height_diff]
  else
    cycle_keys[cycle_key] = [rock_index, rocks_absolute_heights.max]
    false
  end
end

def all_rocks_fall(quantity, loop_start_index, rock_diff, height_diff)
  loop_count, loop_remainder = (quantity - loop_start_index - 1).divmod(rock_diff)

  @stopped_rocks = Set.new([[0, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6]]) # initialized with the floor
  highest_rock = jet_index = 0
  (loop_start_index + loop_remainder + 1).times do |rock_index|
    highest_rock, jet_index = one_rock_fall(highest_rock, rock_index, jet_index)
  end
  (height_diff * loop_count) + highest_rock
end

def one_rock_fall(highest_rock, rock_index, jet_index)
  current_rock = ROCKS[rock_index % 5]
  # each rock appears so its bottom edge is three units above the highest rock in the room
  current_rock = current_rock.map { |x, y| [x + highest_rock + 4, y] }

  loop.with_index do |_, i|
    current_rock = move_horizontally(current_rock, @jets[(jet_index + i) % @jets.size])
    next_rock = move_downward(current_rock)
    if current_rock == next_rock # the rock stopped falling
      highest_rock = [highest_rock, current_rock.max_by { |x, _y| x }[0]].max
      @stopped_rocks += current_rock
      return [highest_rock, jet_index + i + 1]
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
loop_start_index, rock_diff, height_diff = detect_cycle
puts "part 1: #{all_rocks_fall(2022, loop_start_index, rock_diff, height_diff)}"
puts "part 2: #{all_rocks_fall(1_000_000_000_000, loop_start_index, rock_diff, height_diff)}" # NOTE: 1568513119571
