# frozen_string_literal: true

def get_root_tree(lines)
  get_directory_tree(lines[1..])[0]
end

def get_directory_tree(lines)
  current_dir_sizes = [0]
  index = 0

  while lines[index]
    if lines[index].match?('(\d+) ') # it's a file: we add its size to the current dir
      current_dir_sizes[0] += lines[index].match('(\d+) ')[1].to_i
    elsif lines[index] == '$ cd ..' # we're going up: the current dir is fully explored, we can return it
      return [current_dir_sizes, index + 1]
    elsif lines[index].start_with?('$ cd ') # we're going down: we get the sub dir size and add it to the current dir
      dir, instructions_executed = get_directory_tree(lines[index + 1..])
      current_dir_sizes << dir
      index += instructions_executed # we need to skip every instruction until we go back to the current dir
    end
    index += 1
  end

  [current_dir_sizes, index]
end

def get_all_directories_sizes(current_dir_sizes)
  all_sizes = [get_directory_size(current_dir_sizes)]

  current_dir_sizes.map do |dir|
    next if dir.is_a?(Integer)

    if dir.any?(Array) # if the current directory contains another directory, we need to add its size
      all_sizes += get_all_directories_sizes(dir)
    else
      all_sizes << get_directory_size(dir)
    end
  end

  all_sizes
end

def get_directory_size(current_dir_sizes)
  current_dir_sizes.flatten.sum
end

def find_smallest_directory_greater_than(limit, sizes)
  sizes.select { |size| size >= limit }.min
end

lines = File.readlines('input.txt', chomp: true)
tree = get_root_tree(lines)
sizes = get_all_directories_sizes(tree)
puts "part 1: #{sizes.select { |size| size <= 100_000 }.sum}"

space_to_save = 30_000_000 - (70_000_000 - sizes[0]) # sizes[0] == root size
puts "part 2: #{find_smallest_directory_greater_than(space_to_save, sizes)}"
