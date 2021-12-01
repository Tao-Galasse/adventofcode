# frozen_string_literal: true

def depth_increases_count
  @depths.each_cons(2).count { |a, b| a < b }
end

def sums_increases_count
  @depths.each_cons(3).map(&:sum).each_cons(2).count { |a, b| a < b }
end

@depths = File.readlines('input.txt', chomp: true).map(&:to_i)
puts("Part 1: #{depth_increases_count} measurements increases")
puts("Part 2: #{sums_increases_count} sums of measurements increases")
