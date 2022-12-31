# frozen_string_literal: true

SNAFU_DIGIT_TO_DECIMAL = {
  '2' => 2,
  '1' => 1,
  '0' => 0,
  '-' => -1,
  '=' => -2
}.freeze

DECIMAL_DIGIT_TO_SNAFU = {
  2 => '2',
  1 => '1',
  0 => '0',
  -1 => '-',
  -2 => '='
}.freeze

def snafu_to_decimal(number)
  number.reverse.chars.each_with_index.inject(0) do |total, (digit, index)|
    total + ((5**index) * SNAFU_DIGIT_TO_DECIMAL[digit])
  end
end

def decimal_to_snafu(number)
  snafu_digits = []
  while number > 0
    number += 2
    snafu_digits << (number % 5)
    number /= 5
  end
  snafu_digits.map { |digit| DECIMAL_DIGIT_TO_SNAFU[digit - 2] }.join.reverse
end

snafu_numbers = File.readlines('input.txt', chomp: true)
sum = snafu_numbers.sum { |number| snafu_to_decimal(number) }
puts "part 1: #{decimal_to_snafu(sum)}"
puts 'part 2: Merry Christmas! 🎅🎄🎁🦌🌟'
