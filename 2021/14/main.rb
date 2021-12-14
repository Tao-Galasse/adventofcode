# frozen_string_literal: true

# def process_step(polymer)
#   next_polymer = polymer[0]
#   polymer.chars.each_cons(2) { |elem1, elem2| next_polymer += "#{@rules["#{elem1}#{elem2}"]}#{elem2}" }
#   next_polymer
# end

# def process_steps(polymer, steps)
#   steps.times.map { polymer = process_step(polymer) }.last
# end

# def difference(polymer)
#   occurrences = polymer.chars.tally.values
#   occurrences.max - occurrences.min
# end

def process_step(elem1, elem2, remaining_steps)
  return if remaining_steps.zero?

  middle_letter = @rules["#{elem1}#{elem2}"]
  @occurrences[middle_letter] += 1
  process_step(elem1, middle_letter, remaining_steps - 1)
  process_step(middle_letter, elem2, remaining_steps - 1)
end

def process_steps(polymer, steps)
  polymer.chars.each { |c| @occurrences[c] += 1 }
  polymer.chars.each_cons(2) { |elem1, elem2| process_step(elem1, elem2, steps) }
end

def difference
  @occurrences.values.max - @occurrences.values.min
end

polymer, @rules = File.read('input.txt').split("\n\n")
@rules = @rules.split("\n").map { |r| r.split(' -> ') }.to_h

@occurrences = Hash.new(0)
process_steps(polymer, 10)
puts "part 1: difference between most and least common elements after 10 steps = #{difference}"
process_steps(polymer, 40)
puts "part 2: difference between most and least common elements after 40 steps = #{difference}"
