# frozen_string_literal: true

def parse_input(filename)
  instructions = File.readlines(filename, chomp: true).map(&:split)

  instructions.map do |switch, coordinates|
    x_min, x_max, y_min, y_max, z_min, z_max = coordinates.match(
      '^x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)'
    )[1..].map(&:to_i)

    [switch, [x_min..x_max, y_min..y_max, z_min..z_max]]
  end
end

# For each instruction, we only want to count the final volume added by the "on" cuboids.
def reboot(instructions, restricted_region: true)
  instructions.each_with_index.map do |(switch, cuboid), index|
    next 0 if switch == 'off'
    next 0 if restricted_region && outside_of_restricted_region(cuboid)

    final_cuboid_volume(cuboid, instructions[index + 1..].map(&:last))
  end.sum
end

# Return true if a cuboid is outside of the restricted region (-50..50)
def outside_of_restricted_region(cuboid)
  return true if cuboid.map(&:begin).any? { |coord| coord < -50 }
  return true if cuboid.map(&:end).any? { |coord| coord > 50 }

  false
end

# Returns the volume added by a cuboid after the end of all instructions.
# It could be less than its total volume if next cuboids share some coordinates;
# so we only count the coordinates of the current cuboid which do not overlap with the next cuboids.
def final_cuboid_volume(cuboid, next_cuboids)
  overlapping_cuboids = overlapping_cuboids(cuboid, next_cuboids)
  overlapping_volumes = overlapping_cuboids.each_with_index.map do |next_cuboid, index|
    final_cuboid_volume(next_cuboid, overlapping_cuboids[index + 1..])
  end

  # The final volume added by our cuboid is its volume minus the final volumes of the next overlapping cuboids
  cuboid_volume(cuboid) - overlapping_volumes.sum
end

# Return a list of cuboids overlapping the current cuboid
def overlapping_cuboids(cuboid, next_cuboids)
  next_cuboids.each_with_object([]) do |next_cuboid, overlapping_cuboids|
    overlapping_cuboid = overlapping_cuboid(cuboid, next_cuboid)
    next if cuboid_volume(overlapping_cuboid) == 0 # there is no overlap

    overlapping_cuboids << overlapping_cuboid
  end
end

# The overlap of two cuboids is another cuboid ; this method returns it.
def overlapping_cuboid(cuboid1, cuboid2)
  cuboid1.zip(cuboid2).map do |coord1, coord2|
    ([coord1.begin, coord2.begin].max..[coord1.end, coord2.end].min)
  end
end

# Return the total volume of a cuboid
def cuboid_volume(cuboid)
  cuboid.map(&:size).inject(&:*)
end

instructions = parse_input('input.txt')
puts "part 1: after the reboot, #{reboot(instructions)} cubes are on in the initialization procedure region"
puts "part 2: after the reboot, #{reboot(instructions, restricted_region: false)} cubes are on"
