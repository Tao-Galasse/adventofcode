# frozen_string_literal: true

def follow_simple_instructions(position = 0, depth = 0)
  @instructions.each do |direction, value|
    case direction
    when 'forward'
      position += value
    when 'down'
      depth += value
    when 'up'
      depth -= value
    end
  end

  [position, depth]
end

def follow_complex_instructions(position = 0, depth = 0, aim = 0)
  @instructions.each do |direction, value|
    case direction
    when 'forward'
      position += value
      depth += aim * value
    when 'down'
      aim += value
    when 'up'
      aim -= value
    end
  end

  [position, depth]
end

@instructions = File.readlines('input.txt', chomp: true).map { |line| line.split(' ') }.map { |x, y| [x, y.to_i] }
position, depth = follow_simple_instructions
puts("Part 1: final horizontal position * final depth = #{position * depth}")

position, depth = follow_complex_instructions
puts("Part 2 (with aim): final horizontal position * final depth = #{position * depth}")
