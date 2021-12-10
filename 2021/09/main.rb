# frozen_string_literal: true

def low_point?(row, col)
  point = @map[row][col]
  return false if row.positive? && @map[row - 1][col] <= point
  return false if row < @map.length - 1 && @map[row + 1][col] <= point
  return false if col.positive? && @map[row][col - 1] <= point
  return false if col < @map[0].length - 1 && @map[row][col + 1] <= point

  true
end

def find_bassin(row, col)
  return if @visited_points.include?([row, col])
  return if @map[row][col] == 9

  @visited_points << [row, col]

  if row.positive? && !@visited_points.include?([row - 1, col])
    point_above = @map[row - 1][col]
    @bassin << point_above if point_above < 9
    find_bassin(row - 1, col)
  end

  if row < @map.length - 1 && !@visited_points.include?([row + 1, col])
    point_below = @map[row + 1][col]
    @bassin << point_below if point_below < 9
    find_bassin(row + 1, col)
  end

  if col.positive? && !@visited_points.include?([row, col - 1])
    left_point = @map[row][col - 1]
    @bassin << left_point if left_point < 9
    find_bassin(row, col - 1)
  end

  if col < @map[0].length - 1 && !@visited_points.include?([row, col + 1])
    right_point = @map[row][col + 1]
    @bassin << right_point if right_point < 9
    find_bassin(row, col + 1)
  end
end

def find_low_points_and_basins
  low_points = []
  basins = []
  (0..@map.length - 1).each do |row|
    (0..@map[0].length - 1).each do |col|
      next unless low_point?(row, col)

      low_points << @map[row][col]
      @bassin = [@map[row][col]]
      @visited_points = []
      find_bassin(row, col)
      basins << @bassin
    end
  end
  [low_points, basins]
end

@map = File.readlines('input.txt', chomp: true).map { |line| line.chars.map(&:to_i) }
low_points, basins = find_low_points_and_basins
puts "part 1: risk levels = #{low_points.sum + low_points.count}"
puts "part 2: product of three largest basins = #{basins.map(&:size).sort.last(3).inject(:*)}"
