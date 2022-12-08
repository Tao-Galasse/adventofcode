# frozen_string_literal: true

def explore_tree_map
  visible_trees = highest_score = 0

  (0..@tree_map.size - 1).each do |row|
    (0..@tree_map.size - 1).each do |col|
      next unless visible?(row, col)

      visible_trees += 1
      score = scenic_score(row, col)
      highest_score = score if score > highest_score
    end
  end

  [visible_trees, highest_score]
end

def visible?(row, col)
  height = @tree_map[row][col]
  visible_from_top?(row, col, height) || visible_from_bottom?(row, col, height) ||
    visible_from_left?(row, col, height) || visible_from_right?(row, col, height)
end

def visible_from_top?(row, col, height)
  (row - 1).downto(0).each { |x| return false if @tree_map[x][col] >= height }
  true
end

def visible_from_bottom?(row, col, height)
  ((row + 1)..(@tree_map.size - 1)).each { |x| return false if @tree_map[x][col] >= height }
  true
end

def visible_from_left?(row, col, height)
  (col - 1).downto(0).each { |y| return false if @tree_map[row][y] >= height }
  true
end

def visible_from_right?(row, col, height)
  ((col + 1)..(@tree_map.size - 1)).each { |y| return false if @tree_map[row][y] >= height }
  true
end

def scenic_score(row, col)
  h = @tree_map[row][col]
  score_up(row, col, h) * score_down(row, col, h) * score_left(row, col, h) * score_right(row, col, h)
end

def score_up(row, col, height)
  (row - 1).downto(0).inject(0) { |score, x| @tree_map[x][col] < height ? score + 1 : (break score + 1) }
end

def score_down(row, col, height)
  ((row + 1)..(@tree_map.size - 1)).inject(0) { |score, x| @tree_map[x][col] < height ? score + 1 : (break score + 1) }
end

def score_left(row, col, height)
  (col - 1).downto(0).inject(0) { |score, y| @tree_map[row][y] < height ? score + 1 : (break score + 1) }
end

def score_right(row, col, height)
  ((col + 1)..(@tree_map.size - 1)).inject(0) { |score, y| @tree_map[row][y] < height ? score + 1 : (break score + 1) }
end

@tree_map = File.readlines('input.txt', chomp: true).map { |line| line.chars.map(&:to_i) }
count, score = explore_tree_map
puts "part 1: #{count}"
puts "part 2: #{score}"
