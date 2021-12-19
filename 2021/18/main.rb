# frozen_string_literal: true

def add_numbers
  current_number = @numbers[0]
  @numbers[1..].map { |next_number| current_number = sum(current_number, next_number) }.last
end

def sum(nb1, nb2)
  reduce(['[', *nb1, ',', *nb2, ']'])
end

# `index` is the index of the start of the pair (which is a `[`)
def explode(chars, index)
  (index - 1).downto(0).each do |i|
    chars[i] = (chars[i] + chars[index + 1]) and break if chars[i].is_a?(Integer)
  end
  (index + 5..chars.length - 1).each do |i|
    chars[i] = (chars[i] + chars[index + 3]) and break if chars[i].is_a?(Integer)
  end
  chars[index..index + 4] = 0
end

# `index` is the index of the regular number to split
def split(chars, index)
  chars[index] = ['[', chars[index] / 2, ',', (chars[index] / 2.0).ceil, ']']
  chars.flatten!
end

def reduce(chars)
  opened_pairs = 0
  chars.each_with_index do |char, i|
    case char
    when '[' then opened_pairs += 1
    when ']' then opened_pairs -= 1
    end
    explode(chars, i) and raise if opened_pairs > 4
  end
  # we re-interate over the chars because exploding has priority over splitting
  chars.each_with_index { |char, i| split(chars, i) and raise if char.to_i >= 10 } # %w[, [ ]].map(&:to_i) => [0, 0, 0]
rescue StandardError
  retry # re-parse string from start if we did an explode or a split
end

def magnitude(chars)
  eval(chars.join.gsub('[', '(3*').gsub(',', ' + 2*').gsub(']', ')'))
end

def magnitude_of_each_pair
  (0..@numbers.count - 1).flat_map do |i|
    (0..@numbers.count - 1).map do |j|
      next if i == j

      magnitude(sum(@numbers[i], @numbers[j]))
    end.compact
  end
end

@numbers = File.readlines('input.txt', chomp: true).map(&:chars)
@numbers.map! { |number| number.map { |c| c.to_i.to_s == c ? c.to_i : c } } # convert numbers from char to int
sum = add_numbers
puts "part 1: magnitude of the final sum = #{magnitude(sum)}"
magnitudes = magnitude_of_each_pair
puts "part 2: largest magnitude of any sum of two pairs = #{magnitudes.max}"
