# frozen_string_literal: true

DIM = 10
ADJACENTS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].freeze

def process_step
  @steps += 1
  (0..DIM - 1).each do |x|
    (0..DIM - 1).each do |y|
      @octopuses[x][y] += 1
      flash(x, y) if @octopuses[x][y] == 10
    end
  end
  reset_octopuses_energy
end

def flash(x, y)
  @flash_count += 1
  adjacent_octopuses(x, y).each do |i, j|
    @octopuses[i][j] += 1
    flash(i, j) if @octopuses[i][j] == 10
  end
end

def adjacent_octopuses(x, y)
  ADJACENTS.map { |a| [a, [x, y]].transpose.map(&:sum) }.reject { |i, j| i < 0 || j < 0 || i > DIM - 1 || j > DIM - 1 }
end

def reset_octopuses_energy
  (0..DIM - 1).each do |x|
    (0..DIM - 1).each do |y|
      @octopuses[x][y] = 0 if @octopuses[x][y] > 9
    end
  end
end

@octopuses = File.readlines('input.txt', chomp: true).map { |line| line.chars.map(&:to_i) }
@flash_count = 0
@steps = 0
100.times { process_step }
puts "part 1: flashes count after 100 steps = #{@flash_count}"
process_step until @octopuses.flatten.all?(&:zero?)
puts "part 2: final step until synchronized flashes = #{@steps}"
