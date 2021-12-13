# frozen_string_literal: true

# Extend the `String` class to add useful methods
class String
  def big_cave?
    upcase == self
  end

  def small_cave?
    downcase == self
  end
end

def add_path(current_path, destination, twice: false)
  current_path << destination

  @paths_count += 1 and return if destination == 'end'

  next_destinations(current_path, twice: twice).each { |dest| add_path(current_path.dup, dest, twice: twice) }
end

def next_destinations(current_path, twice:)
  @connections.map do |k, v|
    if v == current_path[-1]
      k if valid_destination?(k, current_path, twice: twice)
    elsif k == current_path[-1]
      v if valid_destination?(v, current_path, twice: twice)
    end
  end.compact
end

def valid_destination?(dest, current_path, twice:)
  return true if dest.big_cave?

  if twice
    dest != 'start' && !(small_cave_visited_twice?(current_path) && current_path.include?(dest))
  else
    !current_path.include?(dest)
  end
end

def small_cave_visited_twice?(current_path)
  current_path.select(&:small_cave?).tally.values.include?(2)
end

@connections = File.readlines('input.txt', chomp: true).map { |l| l.split('-') }
@paths_count = 0
add_path([], 'start')
puts "part 1: number of paths when visiting small caves once = #{@paths_count}"
@paths_count = 0
add_path([], 'start', twice: true)
puts "part 2: number of paths when visiting small caves twice = #{@paths_count}"
