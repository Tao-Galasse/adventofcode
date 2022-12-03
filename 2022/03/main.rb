# frozen_string_literal: true

def find_duplicated_items(rucksacks)
  rucksacks.flat_map do |sack|
    sack.chars.each_slice(sack.size / 2).map(&:to_a).inject(&:&)
  end
end

def find_badges(rucksacks)
  rucksacks.each_slice(3).flat_map do |sacks|
    sacks.map(&:chars).inject(&:&)
  end
end

def sum_priorities(items)
  # priorities start with 0 because we want indexes to start at 1
  priorities = '0abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
  items.map { |item| priorities.index(item) }.sum
end

rucksacks = File.readlines('input.txt', chomp: true)

items = find_duplicated_items(rucksacks)
puts "part 1: #{sum_priorities(items)}"
badges = find_badges(rucksacks)
puts "part 2: #{sum_priorities(badges)}"
