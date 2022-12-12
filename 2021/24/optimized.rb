# frozen_string_literal: true

# Optimized version found on Reddit which uses a stack.
# I couldn't have figured out myself how the input works exactly to end with this solution,
# but I wanted a fast implementation which doesn't required 30+ minutes to run for the sake of completeness.
#
# Credit to u/DrShts, source (in Python): https://www.reddit.com/r/adventofcode/comments/rnejv5/comment/hpuxf5l

def solve(instructions, inp)
  stack = []
  14.times do |i|
    div, chk, add = [4, 5, 15].map { |x| instructions[i * 18 + x][-1].to_i }
    stack << [i, add] and next if div == 1

    j, add = stack.pop
    inp[i] = inp[j] + add + chk
    if inp[i] > 9
      inp[j] -= inp[i] - 9
      inp[i] = 9
    elsif inp[i] < 1
      inp[j] += 1 - inp[i]
      inp[i] = 1
    end
  end
  inp.join
end

instructions = File.readlines('input.txt', chomp: true).map(&:split)
puts "part 1: largest model number = #{solve(instructions, [9] * 14)}"
puts "part 2: smallest model number = #{solve(instructions, [1] * 14)}"
