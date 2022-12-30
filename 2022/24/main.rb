# frozen_string_literal: true

require 'set'

def parse_input(filename)
  File.readlines(filename, chomp: true).each_with_object({}).with_index do |(line, map), i|
    line.chars.each_with_index do |char, j|
      map[[i - 1, j - 1]] = char if ['^', 'v', '<', '>'].include?(char) # -1 because we don't want to count the walls
    end
  end
end

def solve(map, time, start, goal)
  positions = Set.new([start])

  loop do
    positions = positions.each_with_object(Set.new) do |(row, col), next_positions|
      [[row, col], [row - 1, col], [row + 1, col], [row, col - 1], [row, col + 1]].each do |x, y|
        return time if goal == [x, y] # we found a way out of the maze!

        # if the next possible position is outside the map or will be occupied by wind, we skip it
        next unless x >= 0 && x < X_MAX && y >= 0 && y < Y_MAX &&
                    map[[(x - time) % X_MAX, y]] != 'v' && map[[(x + time) % X_MAX, y]] != '^' &&
                    map[[x, (y - time) % Y_MAX]] != '>' && map[[x, (y + time) % Y_MAX]] != '<'

        next_positions << [x, y]
      end
    end

    positions << start if positions.empty? # in case we couldn't move and have to stay at the starting position
    time += 1
  end
end

map = parse_input('input.txt')
X_MAX = map.keys.max_by { |x, _| x }[0] + 1
Y_MAX = map.keys.max_by { |_, y| y }[1] + 1
start = [-1, 0]
goal = [X_MAX, Y_MAX - 1]

time = solve(map, 0, start, goal)
puts "part 1: #{time}"

time = solve(map, time, goal, start)
time = solve(map, time, start, goal)
puts "part 2: #{time}"
