# frozen_string_literal: true

require 'set'

def alu(instructions, w, z)
  x = y = 0

  instructions.each do |instruction, a, b|
    b = b.to_i.to_s == b ? b.to_i : binding.local_variable_get(b) if b

    case instruction
    when 'inp'
      binding.local_variable_set(a, w)
    when 'add'
      binding.local_variable_set(a, binding.local_variable_get(a) + b)
    when 'mul'
      binding.local_variable_set(a, binding.local_variable_get(a) * b)
    when 'div'
      binding.local_variable_set(a, (binding.local_variable_get(a).to_f / b).to_i)
    when 'mod'
      binding.local_variable_set(a, binding.local_variable_get(a) % b)
    when 'eql'
      binding.local_variable_set(a, binding.local_variable_get(a) == b ? 1 : 0)
    end
  end

  z
end

# The input is built with 14 blocks of 18 lines each,
# where w is the input, x & y are always reset to 0, and z is kept between each block.
# So, we can start by the last block, looking for the z starting values resulting in "z = 0" in the end,
# for each possible input (w in 1..9).
# Then, we use each possible z starting value as the target for the previous block, and so on until the begin.
def find_target_z(instructions)
  target_z = Array.new(13, 0) + [Set.new([0])]

  # we can skip the block 0, because we know z starts at 0
  instructions[18..].each_slice(18).with_index.reverse_each do |sub_instructions, index|
    starting_z_values = Set.new
    1_000_000.times do |z| # brute-forcing like hell!
      (1..9).each do |w|
        end_z = alu(sub_instructions, w, z)
        starting_z_values << z if target_z[index + 1].include?(end_z)
      end
    end
    target_z[index] = starting_z_values
  end

  target_z
end

def find_extremum_model_number(instructions, target_z, maximum: true)
  start_z = 0
  model_number = ''
  range = maximum ? 9.downto(1) : (1..9)

  instructions.each_slice(18).with_index do |sub_instructions, index|
    range.each do |w|
      end_z = alu(sub_instructions, w, start_z)
      next unless target_z[index].include?(end_z)

      model_number += w.to_s
      start_z = end_z
      break
    end
  end

  model_number
end

instructions = File.readlines('input.txt', chomp: true).map(&:split)
target_z = find_target_z(instructions) # takes approximately ~39min on my machine (MacBook Pro 2019 2,6 GHz)
puts "part 1: largest model number = #{find_extremum_model_number(instructions, target_z)}"
puts "part 2: smallest model number = #{find_extremum_model_number(instructions, target_z, maximum: false)}"
