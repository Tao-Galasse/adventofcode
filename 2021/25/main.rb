# frozen_string_literal: true

def move_east(cucumbers)
  next_cucumbers = cucumbers.clone.map(&:clone) # deep copy

  (0..@height - 1).each do |row|
    (0..@width - 1).each do |col|
      next unless cucumbers[row][col] == '>'

      if cucumbers[row][(col + 1) % @width] == '.'
        next_cucumbers[row][(col + 1) % @width] = '>'
        next_cucumbers[row][col] = '.'
      end
    end
  end

  move_south(next_cucumbers)
end

def move_south(cucumbers)
  next_cucumbers = cucumbers.clone.map(&:clone) # deep copy

  (0..@height - 1).each do |row|
    (0..@width - 1).each do |col|
      next unless cucumbers[row][col] == 'v'

      if cucumbers[(row + 1) % @height][col] == '.'
        next_cucumbers[(row + 1) % @height][col] = 'v'
        next_cucumbers[row][col] = '.'
      end
    end
  end

  next_cucumbers
end

def move_cucumbers(cucumbers)
  steps = 0

  loop do
    steps += 1
    next_cucumbers = move_east(cucumbers)
    return steps if next_cucumbers == cucumbers

    cucumbers = next_cucumbers
  end
end

cucumbers = File.readlines('input.txt', chomp: true)
@height = cucumbers.size
@width = cucumbers[0].size
puts "part 1: #{move_cucumbers(cucumbers)}"
puts 'part 2: Merry Christmas! 🎅🎄🎁🛷🌟'
