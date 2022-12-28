# frozen_string_literal: true

FACING = {
  'right' => 0,
  'down' => 1,
  'left' => 2,
  'up' => 3
}.freeze

def parse_input(filename)
  map, path = File.read(filename).split("\n\n")

  @map = {}
  map.split("\n").each_with_index do |line, i|
    line.chars.each_with_index do |char, j|
      @map[[i + 1, j + 1]] = char if char != ' '
    end
  end
  @path = path.scan(/\d+|R|L/)
end

def turn(facing, direction)
  case facing
  when 'up' then direction == 'R' ? 'right' : 'left'
  when 'down' then direction == 'R' ? 'left' : 'right'
  when 'left' then direction == 'R' ? 'up' : 'down'
  when 'right' then direction == 'R' ? 'down' : 'up'
  end
end

# if we are on an edge, we have to wrap around to the other side of the board.
def walk_2d(position, facing, steps)
  case facing
  when 'up'
    min_position, max_position = @map.keys.select { |_row, col| col == position[1] }.minmax_by { |row, _col| row }

    steps.times do
      next_position = position == min_position ? max_position : [position[0] - 1, position[1]]
      return position if @map[next_position] == '#' # if we are facing a wall, we can't go forward

      position = next_position
    end
  when 'down'
    min_position, max_position = @map.keys.select { |_row, col| col == position[1] }.minmax_by { |row, _col| row }

    steps.times do
      next_position = position == max_position ? min_position : [position[0] + 1, position[1]]
      return position if @map[next_position] == '#' # if we are facing a wall, we can't go forward

      position = next_position
    end
  when 'left'
    min_position, max_position = @map.keys.select { |row, _col| row == position[0] }.minmax_by { |_row, col| col }

    steps.times do
      next_position = position == min_position ? max_position : [position[0], position[1] - 1]
      return position if @map[next_position] == '#' # if we are facing a wall, we can't go forward

      position = next_position
    end
  when 'right'
    min_position, max_position = @map.keys.select { |row, _col| row == position[0] }.minmax_by { |_row, col| col }

    steps.times do
      next_position = position == max_position ? min_position : [position[0], position[1] + 1]
      return position if @map[next_position] == '#' # if we are facing a wall, we can't go forward

      position = next_position
    end
  end

  position
end

# Cube pattern:
#  BA
#  C
# ED
# F
#
# if we are on an edge, we have to wrap around to an other side of the cube, and could change our facing direction.
def walk_3d(position, facing)
  x, y = position

  case facing
  when 'up' # 3 special cases: E->C, B->F, A->F
    if x == 101 && y < 51 # special case E->C
      next_position = [y + 50, 51]
      next_facing = 'right'
    elsif x == 1 && y < 101 # special case B->F
      next_position = [y + 100, 1]
      next_facing = 'right'
    elsif x == 1 && y > 100 # special case A->F
      next_position = [200, y - 100]
    else # general case
      next_position = [x - 1, y] # general case
    end
  when 'down' # 3 special cases: A->C, D->F, F->A
    if x == 50 && y > 100 # special case A->C
      next_position = [y - 50, 100]
      next_facing = 'left'
    elsif x == 150 && y > 50 # special case D->F
      next_position = [y + 100, 50]
      next_facing = 'left'
    elsif x == 200 # special case F->A
      next_position = [1, y + 100]
    else
      next_position = [x + 1, y] # general case
    end
  when 'left' # 4 special cases: B->E, C->E, E->B, F->B
    if x < 51 && y == 51 # special case B->E
      next_position = [151 - x, 1]
      next_facing = 'right'
    elsif x < 101 && y == 51 # special case C->E
      next_position = [101, x - 50]
      next_facing = 'down'
    elsif x < 151 && y == 1 # special case E->B
      next_position = [151 - x, 51]
      next_facing = 'right'
    elsif x > 150 && y == 1 # special case F->B
      next_position = [1, x - 100]
      next_facing = 'down'
    else
      next_position = [x, y - 1] # general case
    end
  when 'right' # 4 special cases: A->D, C->A, D->A, F->D
    if y == 150 # special case A->D
      next_position = [151 - x, 100]
      next_facing = 'left'
    elsif x > 100 && y == 100 # special case D->A
      next_position = [151 - x, 150]
      next_facing = 'left'
    elsif x > 50 && y == 100 # special case C->A
      next_position = [50, x + 50]
      next_facing = 'up'
    elsif x > 150 && y == 50 # special case F->D
      next_position = [150, x - 100]
      next_facing = 'up'
    else
      next_position = [x, y + 1] # general case
    end
  end

  return [position, facing] if @map[next_position] == '#' # if we are facing a wall, we can't go forward

  [next_position, next_facing || facing]
end

def follow_path(map_dim: '2d')
  position = @map.keys.select { |x, _y| x == 1 }.min_by { |_x, y| y }
  facing = 'right'

  @path.each do |value|
    if value.to_i.to_s == value # it's a number
      if map_dim == '2d'
        position = walk_2d(position, facing, value.to_i)
      else
        value.to_i.times { position, facing = walk_3d(position, facing) }
      end
    else # we turn to the left or to the right
      facing = turn(facing, value)
    end
  end

  [position, facing]
end

def final_password((x, y), facing)
  (1000 * x) + (4 * y) + FACING[facing]
end

parse_input('input.txt')
position, facing = follow_path
puts "part 1: #{final_password(position, facing)}"

position, facing = follow_path(map_dim: '3d')
puts "part 2: #{final_password(position, facing)}"
