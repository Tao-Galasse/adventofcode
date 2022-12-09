# frozen_string_literal: true

require 'set'

def move_2knots_rope(motions)
  head = [0, 0]
  tail = [0, 0]

  motions.each_with_object(Set.new) do |(direction, steps), visited|
    steps.to_i.times do
      move_head(head, direction)
      tail = move_tail(head, tail)
      visited.add(tail)
    end
  end
end

def move_10knots_rope(motions)
  knots = 10.times.map { [0, 0] }

  motions.each_with_object(Set.new) do |(direction, steps), visited|
    steps.to_i.times do
      move_head(knots[0], direction)
      knots[1..9] = (0..9).each_cons(2).map do |prev_knot, next_knot|
        knots[next_knot] = move_tail(knots[prev_knot], knots[next_knot])
      end
      visited.add(knots[-1])
    end
  end
end

def move_head(head, direction)
  case direction
  when 'U' then head[0] += 1
  when 'D' then head[0] -= 1
  when 'R' then head[1] += 1
  when 'L' then head[1] -= 1
  end
end

def move_tail(head, tail)
  diff = head.each_with_index.map { |elem, index| elem - tail[index] }
  case diff
  when [2, -2], [2, -1], [1, -2] then [tail[0] + 1, tail[1] - 1] # move to the top-left
  when [2, 0] then [tail[0] + 1, tail[1]] # move to the top
  when [2, 1], [2, 2], [1, 2] then [tail[0] + 1, tail[1] + 1] # move to the top-right
  when [0, -2] then [tail[0], tail[1] - 1] # move to the left
  when [0, 2] then [tail[0], tail[1] + 1] # move to the right
  when [-2, -2], [-2, -1], [-1, -2] then [tail[0] - 1, tail[1] - 1] # move to the bottom-left
  when [-2, 0] then [tail[0] - 1, tail[1]] # move to the bottom
  when [-2, 1], [-2, 2], [-1, 2] then [tail[0] - 1, tail[1] + 1] # move to the bottom-right
  else tail
  end
end

motions = File.readlines('input.txt', chomp: true).map(&:split)
puts "part 1: #{move_2knots_rope(motions).count}"
puts "part 2: #{move_10knots_rope(motions).count}"
