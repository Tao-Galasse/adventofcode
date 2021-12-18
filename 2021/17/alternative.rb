# frozen_string_literal: true

# Clever formula found on Reddit (https://www.reddit.com/r/adventofcode/comments/ri9kdq/2021_day_17_solutions)
def highest_y_value
  @y_min * (@y_min + 1) / 2
end

def valid_velocity?(x_slope, y_slope)
  x = y = steps = 0
  until x > @x_max || y < @y_min
    x += (x_slope - steps).positive? ? x_slope - steps : 0
    y += y_slope - steps
    steps += 1
    return true if (@x_min..@x_max).include?(x) && (@y_min..@y_max).include?(y)
  end
  false # we're not in the target area
end

def count_valid_velocities
  velocities_count = 0
  (1..@x_max).each do |x|
    (@y_min..@y_min.abs).each do |y|
      velocities_count += 1 if valid_velocity?(x, y)
    end
  end
  velocities_count
end

@x_min, @x_max, @y_min, @y_max = File.read('input.txt').delete("\n").match(
  '^target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)'
)[1..].map(&:to_i)

puts "part 1: highest y position = #{highest_y_value}"
puts "part 2: number of valid velocities = #{count_valid_velocities}"
