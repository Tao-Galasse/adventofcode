# frozen_string_literal: true

require 'set'

def move_rope(motions)
  head = [0, 0]
  tail = [0, 0]

  motions.each_with_object(Set.new) do |(direction, steps), visited|
    steps.to_i.times do
      case direction
      when 'U' then head[0] += 1
      when 'D' then head[0] -= 1
      when 'R' then head[1] += 1
      when 'L' then head[1] -= 1
      end
      tail = adjust_tail(head, tail)
      visited.add(tail.dup)
    end
  end
end

def adjust_tail(head, tail)
  tail = [tail[0] + 1, head[1]] if head[0] - 2 == tail[0]
  tail = [tail[0] - 1, head[1]] if head[0] + 2 == tail[0]
  tail = [head[0], tail[1] + 1] if head[1] - 2 == tail[1]
  tail = [head[0], tail[1] - 1] if head[1] + 2 == tail[1]
  tail
end

motions = File.readlines('input.txt', chomp: true).map(&:split)
visited_positions = move_rope(motions)

puts "part 1: #{visited_positions.count}"
