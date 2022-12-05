# frozen_string_literal: true

def parse_input(filename)
  stacks, instructions = File.read(filename).split("\n\n")

  stacks = parse_stacks(stacks)
  instructions = instructions.lines.map { |i| i.match('^move (\d+) from (\d+) to (\d+)')[1..].map(&:to_i) }

  [stacks, instructions]
end

def parse_stacks(stacks)
  stacks = stacks.split("\n").map do |line|
    (1..line.length).step(4).map { |index| line[index] }
  end

  stacks[..-2].transpose.map { |s| s.map(&:strip).reject(&:empty?).reverse }
end

def execute_crate_mover9000(stacks, instructions)
  instructions.each do |quantity, from, to|
    quantity.times { stacks[to - 1].push(stacks[from - 1].pop) }
  end
end

def execute_crate_mover9001(stacks, instructions)
  instructions.each do |quantity, from, to|
    stacks[to - 1].push(*stacks[from - 1].pop(quantity))
  end
end

stacks, instructions = parse_input('input.txt')
execute_crate_mover9000(stacks, instructions)
puts "part 1: #{stacks.map(&:last).join}"

# we re-parse the input to go back to the starting positions without having to deep clone the object `stacks`
stacks, instructions = parse_input('input.txt')
execute_crate_mover9001(stacks, instructions)
puts "part 2: #{stacks.map(&:last).join}"
