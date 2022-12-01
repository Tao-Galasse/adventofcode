# frozen_string_literal: true

lines = File.readlines('input.txt', chomp: true)

calories = []
total = 0

lines.each do |line|
  if line.empty?
    calories << total
    total = 0
  else
    total += line.to_i
  end
end

puts "part 1: The elf carrying the most calories has #{calories.max} calories"
puts "part 2: The three elves carrying the most calories has a sum of #{calories.max(3).sum} calories"
