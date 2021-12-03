# frozen_string_literal: true

def most_common_bit(numbers, bit_position)
  numbers.map { |number| number[bit_position] }.count('0') > numbers.count / 2 ? '0' : '1'
end

def compute_gamma_rate
  (0..@report[0].length - 1).map { |bit_position| most_common_bit(@report, bit_position) }.join
end

def flip_binary(binary)
  binary.gsub(/./, '0' => '1', '1' => '0')
end

def bit_criteria(numbers, bit_position, type)
  most_common_bit = most_common_bit(numbers, bit_position)
  return most_common_bit if type == :oxygen

  most_common_bit == '0' ? '1' : '0' # returns the least common bit
end

def compute_rating(type)
  kept_numbers = @report.dup
  bit_position = 0

  while kept_numbers.length > 1
    bit_criteria = bit_criteria(kept_numbers, bit_position, type)
    kept_numbers.select! { |n| n[bit_position] == bit_criteria }
    bit_position += 1
  end

  kept_numbers.first
end

@report = File.readlines('input.txt', chomp: true)
gamma_rate = compute_gamma_rate
epsilon_rate = flip_binary(gamma_rate)
puts("Part 1: power consumption = #{gamma_rate.to_i(2) * epsilon_rate.to_i(2)}")

oxygen_generator_rating = compute_rating(:oxygen)
co2_scrubber_rating = compute_rating(:co2)
puts("Part 2: life support rating = #{oxygen_generator_rating.to_i(2) * co2_scrubber_rating.to_i(2)}")
