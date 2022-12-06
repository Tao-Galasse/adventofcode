# frozen_string_literal: true

def find_marker(signal, length)
  index = 0
  loop do
    return index + length if signal[index..(index + length - 1)].chars.uniq.count == length

    index += 1
  end
end

signal = File.read('input.txt')
puts "part 1: #{find_marker(signal, 4)}"
puts "part 2: #{find_marker(signal, 14)}"
