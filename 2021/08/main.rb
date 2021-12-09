# frozen_string_literal: true

EASY_DIGITS_SIGNAL_LENGTHS = [2, 3, 4, 7].freeze

def count_easy_digits_in_outputs
  @parsed_input.values.flat_map { |o| o.map(&:size) }.count { |v| EASY_DIGITS_SIGNAL_LENGTHS.include?(v) }
end

def identify_easy_digits(input)
  input.select { |i| EASY_DIGITS_SIGNAL_LENGTHS.include?(i.size) }.sort_by(&:size)
end

# A 9 is a 6-segments digit with the same segments than 4
def identify_nine(segments_four)
  nine = @remaining_signals.select { |s| s.size == 6 && segments_four.chars.map { |c| s.include?(c) }.all? }[0]
  @remaining_signals.delete(nine)
end

# If there is no 9 anymore in signals, a 0 is a 6-segments digit with the same segments than 1
def identify_zero(segments_one)
  zero = @remaining_signals.select { |s| s.size == 6 && segments_one.chars.map { |c| s.include?(c) }.all? }[0]
  @remaining_signals.delete(zero)
end

# 6 is the only 6-segments digit if there is no more 0 or 9 in the remaining signals.
def identify_six
  six = @remaining_signals.select { |s| s.size == 6 }[0]
  @remaining_signals.delete(six)
end

# A 3 is a 5-segments digit with the same segments than 1 ;
# we don't need to check for the signal's length if there is only 5-long signals remaining.
def identify_three(segments_one)
  three = @remaining_signals.select { |s| segments_one.chars.map { |c| s.include?(c) }.all? }[0]
  @remaining_signals.delete(three)
end

# If there is no 3 anymore in signals, a 5 is a 5-segments digit where all segments are included in 9.
def identify_five(segments_nine)
  five = @remaining_signals.select { |s| s.chars.map { |c| segments_nine.chars.include?(c) }.all? }[0]
  @remaining_signals.delete(five)
end

def wires_segments_mapping(input)
  segments = [1, 7, 4, 8].zip(identify_easy_digits(input)).to_h
  @remaining_signals = input - segments.values
  # 6-segments digits
  segments[9] = identify_nine(segments[4])
  segments[0] = identify_zero(segments[1])
  segments[6] = identify_six
  # 5-segments digits
  segments[3] = identify_three(segments[1])
  segments[5] = identify_five(segments[9])
  segments[2] = @remaining_signals[0] # 2 is the only signal remaining when all others have been found.
  segments.transform_values { |signal| signal.chars.sort.join } # we order letters in signals
end

def decode_output(output, segments_mapping)
  output.map { |signal| segments_mapping.key(signal.chars.sort.join) }.join.to_i
end

def sum_output_values
  @parsed_input.map { |input, output| decode_output(output, wires_segments_mapping(input)) }.sum
end

@parsed_input = File.readlines('input.txt').map { |l| l.split('|').map(&:split) }.to_h
puts "part 1: number of easy digits in the outputs = #{count_easy_digits_in_outputs}"
puts "part 2: sum of all of the output values = #{sum_output_values}"
