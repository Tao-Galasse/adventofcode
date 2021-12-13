# frozen_string_literal: true

def fold(instructions)
  instructions.each do |inst|
    inst[0] == 'x' ? fold_left(inst.split('=')[1].to_i) : fold_up(inst.split('=')[1].to_i)
  end
end

def fold_left(line)
  @points.map! do |x, y|
    x > line ? [2 * line - x, y] : [x, y]
  end.uniq!
end

def fold_up(line)
  @points.map! do |x, y|
    y > line ? [x, 2 * line - y] : [x, y]
  end.uniq!
end

def display_image
  x_max, y_max = [@points.map(&:first).max, @points.map(&:last).max]

  (0..y_max).each do |y|
    line = ''
    (0..x_max).each do |x|
      line += @points.include?([x, y]) ? '#' : ' '
    end
    puts line
  end
end

@points, @instructions = File.read('input.txt').split("\n\n")
@points = @points.split("\n").map { |l| l.split(',').map(&:to_i) }
@instructions = @instructions.split("\n").map { |l| l.split('fold along ')[1] }

fold([@instructions[0]])
puts "part 1: visible dots after the first fold = #{@points.count}"
fold(@instructions[1..])
puts 'part 2: code ='
display_image
