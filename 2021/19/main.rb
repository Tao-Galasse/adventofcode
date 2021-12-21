# frozen_string_literal: true

TRANSFORMATIONS = [
  ->(x, y, z) { [x, y, z]    },
  ->(x, y, z) { [x, z, -y]   },
  ->(x, y, z) { [x, -y, -z]  },
  ->(x, y, z) { [x, -z, y]   },
  ->(x, y, z) { [-x, y, -z]  },
  ->(x, y, z) { [-x, z, y]   },
  ->(x, y, z) { [-x, -y, z]  },
  ->(x, y, z) { [-x, -z, -y] },
  ->(x, y, z) { [y, x, -z]   },
  ->(x, y, z) { [y, z, x]    },
  ->(x, y, z) { [y, -x, z]   },
  ->(x, y, z) { [y, -z, -x]  },
  ->(x, y, z) { [-y, x, z]   },
  ->(x, y, z) { [-y, z, -x]  },
  ->(x, y, z) { [-y, -x, -z] },
  ->(x, y, z) { [-y, -z, x]  },
  ->(x, y, z) { [z, x, y]    },
  ->(x, y, z) { [z, y, -x]   },
  ->(x, y, z) { [z, -x, -y]  },
  ->(x, y, z) { [z, -y, x]   },
  ->(x, y, z) { [-z, x, -y]  },
  ->(x, y, z) { [-z, y, x]   },
  ->(x, y, z) { [-z, -x, y]  },
  ->(x, y, z) { [-z, -y, -x] }
].freeze

def compute_absolute_positions
  @scanners_found = [0]
  @remaining_scanners = (1..@scanners.length - 1).to_a
  @scanners_positions = [[0, 0, 0]]
  while @scanners_found.any?
    sc1 = @scanners_found.pop
    @remaining_scanners.dup.each { |sc2| overlap_scanners(sc1, sc2) }
  end
end

# We always consider scanner 1 as "well oriented", and we're looking for the matching orientation of scanner 2
# sc1 and sc2 are indexes
def overlap_scanners(sc1, sc2)
  TRANSFORMATIONS.each do |trans|
    orientation = @scanners[sc2].map { |points| trans.call(*points) }
    @scanners[sc1].each do |x1, y1, z1|
      orientation.each do |x2, y2, z2|
        dx, dy, dz = x1 - x2, y1 - y2, z1 - z2
        points = orientation.map { |x, y, z| [x + dx, y + dy, z + dz] }
        next unless (@scanners[sc1] & points).count >= 12

        @scanners[sc2] = points
        @scanners_found << sc2
        @remaining_scanners.delete(sc2)
        @scanners_positions << [dx, dy, dz]
        return
      end
    end
  end
end

def largest_manhattan_distance
  max = 0
  @scanners_positions.each do |x1, y1, z1|
    @scanners_positions.each do |x2, y2, z2|
      max = [max, (x1 - x2).abs + (y1 - y2).abs + (z1 - z2).abs].max
    end
  end
  max
end

t1 = Time.now
@scanners = File.read('input.txt', chomp: true).split("\n\n").map do |scanner|
  scanner.split("\n")[1..].map { |coords| coords.split(',').map(&:to_i) }
end
compute_absolute_positions
puts "part 1: number of different beacons = #{@scanners.inject(&:union).count}"
puts "part 2: largest manhattan distance between two scanners = #{largest_manhattan_distance}"
t2 = Time.now
puts "execution time = #{t2 - t1} seconds" # Takes around ~2min30 to get results!
