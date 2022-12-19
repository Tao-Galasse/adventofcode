# frozen_string_literal: true

require 'set'

def count_uncovered_sides(cubes)
  cubes_array = cubes.to_a
  total_faces = cubes.size * 6

  (0..cubes.size - 2).each do |i|
    (i + 1..cubes.size - 1).each do |j|
      x1, y1, z1 = cubes_array[i]
      x2, y2, z2 = cubes_array[j]
      total_faces -= 2 if (x1 == x2 && y1 == y2 && (z1 - z2).abs == 1) ||
                          (x1 == x2 && z1 == z2 && (y1 - y2).abs == 1) ||
                          (y1 == y2 && z1 == z2 && (x1 - x2).abs == 1)
    end
  end
  total_faces
end

def count_exterior_surface(cubes)
  x_min, x_max = cubes.minmax_by { |x, _, _| x }.map { _1[0] }
  y_min, y_max = cubes.minmax_by { |_, y, _| y }.map { _1[1] }
  z_min, z_max = cubes.minmax_by { |_, _, z| z }.map { _1[2] }
  x_min, y_min, z_min = [x_min, y_min, z_min].map { _1 - 1 }
  x_max, y_max, z_max = [x_max, y_max, z_max].map { _1 + 1 }

  fill_with_steam(cubes, x_min, x_max, y_min, y_max, z_min, z_max)
end

def fill_with_steam(lava_cubes, x_min, x_max, y_min, y_max, z_min, z_max)
  surface = 0
  steam_cubes = Set.new([[x_min, y_min, z_min]])
  queue = [[x_min, y_min, z_min]]

  until queue.empty?
    x, y, z = queue.pop

    [[-1, 0, 0], [1, 0, 0], [0, -1, 0], [0, 1, 0], [0, 0, -1], [0, 0, 1]].each do |dx, dy, dz|
      nx = x + dx
      ny = y + dy
      nz = z + dz
      surface += 1 and next if lava_cubes.include?([nx, ny, nz]) # next block is lava: we add 1 to the exterior surface
      next if steam_cubes.include?([nx, ny, nz]) # next block is already filled with steam
      next if nx < x_min || nx > x_max || ny < y_min || ny > y_max || nz < z_min || nz > z_max # next block not in range

      steam_cubes << [nx, ny, nz]
      queue << [nx, ny, nz]
    end
  end

  surface
end

cubes = File.readlines('input.txt', chomp: true).map { |line| line.split(',').map(&:to_i) }.to_set
puts "part 1: #{count_uncovered_sides(cubes)}"
puts "part 2: #{count_exterior_surface(cubes)}"
