# frozen_string_literal: true

require 'set'

DIRECTIONS = [[-1, 0], [1, 0], [0, -1], [0, 1]].freeze

def shortest_path(start = [0, 0])
  queue = [{ x: start[0], y: start[1], cost: 0 }]
  visited = Set.new
  size = @map.length

  loop do
    x, y, cost = queue.shift.values_at(:x, :y, :cost)
    return cost if x == size - 1 && y == size - 1

    DIRECTIONS.each do |dx, dy|
      next_x = x + dx
      next_y = y + dy
      next if next_x < 0 || next_x >= size || next_y < 0 || next_y >= size || visited.include?([next_x, next_y])

      visited << [next_x, next_y]
      queue << { x: next_x, y: next_y, cost: cost + @map[next_x][next_y] }
    end

    queue.sort_by! { |hash| hash[:cost] }
  end
end

def extend_map
  5.times.flat_map do |nx| # extend to the bottom
    @map.map do |row|
      5.times.flat_map do |ny| # extend to the right
        row.map do |risk|
          ((risk + nx + ny) % 9).then { |v| v.zero? ? 9 : v }
        end
      end
    end
  end
end

@map = File.readlines('input.txt', chomp: true).map { |row| row.chars.map(&:to_i) }
puts "part 1: lowest total risk = #{shortest_path}"
@map = extend_map
puts "part 2: lowest total risk on extended map = #{shortest_path}"
