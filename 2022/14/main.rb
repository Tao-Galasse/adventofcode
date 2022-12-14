# frozen_string_literal: true

def parse_input(filename)
  File.readlines(filename, chomp: true).each_with_object({}) do |path, map|
    lines = path.split(' -> ').map { |coords| coords.split(',').map(&:to_i) }
    lines.each_cons(2) do |(x1, y1), (x2, y2)|
      if x1 == x2
        ([y1, y2].min..[y1, y2].max).each { |y| map[[x1, y]] = '#' }
      else
        ([x1, x2].min..[x1, x2].max).each { |x| map[[x, y1]] = '#' }
      end
    end
  end
end

# Return true if the sand unit stopped;
# Return false if the sand unit falls forever
def move_one_sand_unit(with_floor: false)
  x = 500
  y = 0

  loop do
    can_move = false

    [[0, 1], [-1, 1], [1, 1]].each do |dx, dy|
      next if @map[[x + dx, y + dy]] # the next possible position is already taken

      if y + 1 == @y_max # we reached the moment where the sand falls forever OR the floor
        with_floor ? next : (return false)
      end

      x += dx
      y += dy

      can_move = true
      break
    end

    unless can_move
      @map[[x, y]] = 'o' # the sand unit reached its final position: we add it to the map
      [x, y] == [500, 0] ? (return false) : (return true)
    end
  end
end

def move_all_sand_units(with_floor: false)
  nil while move_one_sand_unit(with_floor:)
end

@map = parse_input('input.txt')
@y_max = @map.keys.map(&:last).max
move_all_sand_units
puts "part1: #{@map.values.count('o')}"

@y_max += 2
move_all_sand_units(with_floor: true)
puts "part2: #{@map.values.count('o')}"
