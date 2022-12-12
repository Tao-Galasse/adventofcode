# frozen_string_literal: true

require 'set'

DIRECTIONS = [[-1, 0], [1, 0], [0, -1], [0, 1]].freeze

def shortest_path(start, goal)
  queue = [{ x: start[0], y: start[1], length: 0 }]
  visited = Set.new([[0, 0]])

  loop do
    return if queue.empty? # there was no path to the goal from the given start

    x, y, length = queue.shift.values_at(:x, :y, :length)
    return length if x == goal[0] && y == goal[1]

    DIRECTIONS.each do |dx, dy|
      next_x = x + dx
      next_y = y + dy
      next if next_x.negative? || next_x >= @map.size || next_y.negative? || next_y >= @map[0].size # outside the map
      next if visited.include?([next_x, next_y]) # point already explored
      next if @map[next_x][next_y].bytes.first > @map[x][y].bytes.first + 1 # next point is too high

      visited << [next_x, next_y]
      queue << { x: next_x, y: next_y, length: length + 1 }
    end

    queue.sort_by! { |hash| hash[:length] }
  end
end

def find_start_and_final_points
  start_x = @map.index { |line| line.include?('S') }
  start_y = @map[start_x].index('S')
  final_x = @map.index { |line| line.include?('E') }
  final_y = @map[final_x].index('E')
  # We know where are the start and the end: we replace S and E by their values
  @map[start_x][start_y] = 'a'
  @map[final_x][final_y] = 'z'

  [[start_x, start_y], [final_x, final_y]]
end

def find_shortest_start(goal)
  shortest_start = Float::INFINITY

  (0..@map.size - 1).each do |row|
    (0..@map[0].size - 1).each do |col|
      next unless @map[row][col] == 'a'

      length = shortest_path([row, col], goal)
      next if length.nil? # there was no path to the goal from this start

      shortest_start = length if length < shortest_start
    end
  end

  shortest_start
end

@map = File.readlines('input.txt', chomp: true).map(&:chars)
start, goal = find_start_and_final_points
puts "part 1: #{shortest_path(start, goal)}"
puts "part 2: #{find_shortest_start(goal)}"
