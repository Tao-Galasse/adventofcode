# frozen_string_literal: true

def count_full_overlaps(pairs)
  pairs.inject(0) do |total, (p1_min, p1_max, p2_min, p2_max)|
    (p1_min >= p2_min && p1_max <= p2_max) || (p2_min >= p1_min && p2_max <= p1_max) ? total + 1 : total
  end
end

def count_all_overlaps(pairs)
  pairs.inject(0) do |total, (p1_min, p1_max, p2_min, p2_max)|
    (p1_min <= p2_max && p2_min <= p1_max) || (p2_min <= p1_max && p1_min <= p2_max) ? total + 1 : total
  end
end

pairs = File.readlines('input.txt', chomp: true).map { |p| p.match('^(\d+)-(\d+),(\d+)-(\d+)')[1..].map(&:to_i) }
puts "part 1: #{count_full_overlaps(pairs)}"
puts "part 2: #{count_all_overlaps(pairs)}"
