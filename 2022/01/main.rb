# frozen_string_literal: true

calories = File.read('input.txt').split("\n\n").map { |values| values.split("\n").map(&:to_i).sum }

puts "part 1: The elf carrying the most calories has #{calories.max} calories"
puts "part 2: The three elves carrying the most calories have a sum of #{calories.max(3).sum} calories"
