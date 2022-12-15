# frozen_string_literal: true

require 'set'

def parse_input(filename)
  File.readlines(filename).map do |line|
    sx, sy, bx, by = line.scan(/-?\d+/).map(&:to_i)
    [[sx, sy], manhattan_distance(sx, sy, bx, by)]
  end
end

def manhattan_distance(sx, sy, bx, by)
  (sx - bx).abs + (sy - by).abs
end

def covered_points_on_line(coordinates, target_y)
  coordinates.each_with_object(Set.new) do |((sx, sy), distance), points|
    x_distance_to_target = distance - (sy - target_y).abs
    (0..x_distance_to_target).each do |dx|
      next if target_y == sx + dx || target_y == sx - dx

      points << [sx + dx, target_y]
      points << [sx - dx, target_y]
    end
  end
end

# Find the points on the border of the square formed by the range of the sensor in position [x, y].
# The points have to be in the visible area, delimited by 0 and MAX.
def find_border_points(x, y, distance)
  border_points = Set.new

  (0..distance).each do |dx|
    next_x = x + dx
    break if next_x > MAX

    border_points << [x + dx, y + (distance - dx)]
    border_points << [x + dx, y - (distance - dx)]
  end

  (0..distance).each do |dx| # rubocop: disable Style/CombinableLoops
    next_x = x - dx
    break if next_x < 0

    border_points << [x - dx, y + (distance - dx)]
    border_points << [x - dx, y - (distance - dx)]
  end

  border_points.reject { |_, row| row < 0 || row > MAX }
end

# The distress beacon is on the external border of a square formed by the range of a sensor.
# So, we need to get these points before being able to find the distress beacon;
# then, we just have to find the point which is not visible by any other sensor.
def find_distress_beacon(coordinates)
  coordinates.each_with_index do |((sx, sy), distance), i|
    border_points = find_border_points(sx, sy, distance + 1)
    border_points.each do |x, y|
      return [x, y] unless point_seen_by_sensors(coordinates, x, y, i)
    end
  end
end

# i is the index of a sensor which cannot see the point [x, y] for sure, so we can skip it
def point_seen_by_sensors(coordinates, x, y, i)
  coordinates.each_with_index do |((sx, sy), distance), j|
    next if i == j

    return true if manhattan_distance(sx, sy, x, y) <= distance
  end
  false
end

MAX = 4_000_000
coordinates = parse_input('input.txt')

points = covered_points_on_line(coordinates, 2_000_000) # takes ~12s on my machine (MacBook Pro 2019 2,6 GHz)
puts "part 1: #{points.count}"

x, y = find_distress_beacon(coordinates) # takes ~65s on my machine (MacBook Pro 2019 2,6 GHz)
puts "part 2: #{(x * MAX) + y}"
