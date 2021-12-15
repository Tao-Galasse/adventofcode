# frozen_string_literal: true

def process_step
  next_pairs = Hash.new(0)
  @pairs_count.each do |pair, count|
    middle_letter = @rules[pair]
    next_pairs["#{pair[0]}#{middle_letter}"] += count
    next_pairs["#{middle_letter}#{pair[1]}"] += count
    @letters_count[middle_letter] += count
  end
  @pairs_count = next_pairs
end

def max_min_difference
  @letters_count.values.max - @letters_count.values.min
end

polymer, @rules = File.read('input.txt').split("\n\n")
@rules = @rules.split("\n").map { |r| r.split(' -> ') }.to_h
@pairs_count = Hash.new(0).merge(polymer.chars.each_cons(2).map { |a, b| "#{a}#{b}" }.tally)
@letters_count = Hash.new(0).merge(polymer.chars.tally)

10.times { process_step }
puts "part 1: difference between most and least common elements after 10 steps = #{max_min_difference}"
30.times { process_step } # 40 - 10 = 30
puts "part 2: difference between most and least common elements after 40 steps = #{max_min_difference}"
