# frozen_string_literal: true

def find_marker(signal, length)
  loop.with_index do |_, i|
    return i + length if signal[i..(i + length - 1)].chars.uniq.count == length
  end
end

signal = File.read('input.txt')
puts "part 1: #{find_marker(signal, 4)}"
puts "part 2: #{find_marker(signal, 14)}"
