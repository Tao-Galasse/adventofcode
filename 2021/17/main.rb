# frozen_string_literal: true

def valid_velocity?(x_slope, y_slope)
  x = y = steps = 0
  highest_y = -Float::INFINITY
  until x > @x_max || y < @y_min
    highest_y = y if y > highest_y
    x += (x_slope - steps).positive? ? x_slope - steps : 0
    y += y_slope - steps
    steps += 1
    return highest_y if (@x_min..@x_max).include?(x) && (@y_min..@y_max).include?(y)
  end
  false # we're not in the target area
end

def y_vertices
  highest_y_values = []
  (1..@x_max).each do |x|
    (@y_min..@y_min.abs).each do |y|
      highest_y_values << valid_velocity?(x, y)
    end
  end
  highest_y_values.select(&:itself) # remove the `false` values
end

@x_min, @x_max, @y_min, @y_max = File.read('input.txt').delete("\n").match(
  '^target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)'
)[1..].map(&:to_i)

highest_y_values = y_vertices
puts "part 1: highest y position = #{highest_y_values.max}"
puts "part 2: number of valid velocities = #{highest_y_values.count}"
