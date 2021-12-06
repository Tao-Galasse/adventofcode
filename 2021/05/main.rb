# frozen_string_literal: true

def count_covered_points(ignore_diagonal_lines: true)
  covered_points = Hash.new(0)
  @segments.each do |p1, p2|
    x1, y1 = p1.split(',').map(&:to_i)
    x2, y2 = p2.split(',').map(&:to_i)
    next if ignore_diagonal_lines && x1 != x2 && y1 != y2

    while x1 != x2 || y1 != y2
      covered_points["#{x1},#{y1}"] += 1
      x1 += x1 < x2 ? 1 : -1 if x1 != x2
      y1 += y1 < y2 ? 1 : -1 if y1 != y2
    end
    covered_points["#{x1},#{y1}"] += 1 # count last point of the segment
  end
  covered_points
end

@segments = File.open('input.txt').readlines(chomp: true).map { |line| line.split(' -> ') }
covered_points = count_covered_points
puts "part 1: points where at least two lines overlap = #{covered_points.values.select { |n| n > 1 }.count}"
covered_points = count_covered_points(ignore_diagonal_lines: false)
puts "part 2: points where at least two lines overlap = #{covered_points.values.select { |n| n > 1 }.count}"
