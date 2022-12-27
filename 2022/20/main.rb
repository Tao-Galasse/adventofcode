# frozen_string_literal: true

def mixing(original_file, file_to_mix)
  original_file.each_with_object(file_to_mix.dup) do |number, next_file|
    index = next_file.index { |e| number.object_id.equal?(e.object_id) }
    next_index = (index + number[0]) % (SIZE - 1)
    next_file.insert(next_index, next_file.delete_at(index))
  end
end

def grove_coordinates(file)
  [1000, 2000, 3000].flat_map do |number|
    file[(file.index([0]) + number) % SIZE]
  end
end

file = File.readlines('input.txt').map { |e| [e.to_i] }
SIZE = file.size

next_file = mixing(file, file)
puts "part 1: #{grove_coordinates(next_file).sum}"

file.map! { |number| [number[0] * 811_589_153] }
next_file = file.dup
10.times { next_file = mixing(file, next_file) }  # takes ~17s on my machine (MacBook Pro 2019 2,6 GHz)
puts "part 2: #{grove_coordinates(next_file).sum}"
