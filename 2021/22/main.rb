# frozen_string_literal: true

def reboot_part1(instructions)
  # A grid is a hash where the key is an array of the 3 coordinates (x, y, z) and the value is "on" or "off"
  grid = Hash.new(0)

  instructions.each do |instruction, coordinates|
    x_min, x_max, y_min, y_max, z_min, z_max = coordinates.match(
      '^x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)'
    )[1..].map(&:to_i)

    (x_min..x_max).each do |x|
      break if x < -50 || x > 50

      (y_min..y_max).each do |y|
        break if y < -50 || y > 50

        (z_min..z_max).each do |z|
          break if z < -50 || z > 50

          grid[[x, y, z]] = instruction == 'on' ? 1 : 0
        end
      end
    end
  end

  grid
end

instructions = File.readlines('input.txt', chomp: true).map(&:split)
grid = reboot_part1(instructions)
puts "part 1: after the reboot, #{grid.values.reject(&:zero?).count} cubes are on"
