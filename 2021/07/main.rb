# frozen_string_literal: true

def minimal_fuel_cost
  (@positions.min..@positions.max).map do |target|
    @positions.map { |position| (position - target).abs }.sum
  end.min
end

def minimal_fuel_cost_with_crab_engine
  (@positions.min..@positions.max).map do |target|
    @positions.map { |position| (1..(position - target).abs).sum }.sum
  end.min
end

@positions = File.read('input.txt').split(',').map(&:to_i)
puts "part 1: at least #{minimal_fuel_cost} fuel is required"
puts "part 2: at least #{minimal_fuel_cost_with_crab_engine} fuel is required"
