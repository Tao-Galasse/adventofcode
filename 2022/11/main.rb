# frozen_string_literal: true

def parse_input(filename)
  monkeys = File.read(filename).split("\n\n")
  monkeys.map do |monkey|
    lines = monkey.split("\n")
    items = lines[1].scan(/\d+/).map(&:to_i)
    operation = lines[2].delete_prefix('  Operation: new = ')
    test = lines[3].scan(/\d+/).first.to_i
    test_true = lines[4].scan(/\d+/).first.to_i
    test_false = lines[5].scan(/\d+/).first.to_i
    [items, operation, test, test_true, test_false, 0] # last parameter == number of items inspected
  end
end

def monkey_turn(monkeys, monkey, relief: true)
  items, operation, test, test_true, test_false, = monkey
  items.each do |old| # rubocop: disable Lint/UnusedBlockArgument
    new_level = relief ? (eval(operation) / 3).floor : (eval(operation) % COMMON_DENOMINATOR)
    (new_level % test).zero? ? monkeys[test_true][0] << new_level : monkeys[test_false][0] << new_level
  end
  monkey[5] += items.count # all the items hold by the monkey have been inspected
  monkey[0] = [] # the items have been thrown: we remove them from the current monkey
end

def monkeys_round(monkeys, relief: true)
  monkeys.each { |monkey| monkey_turn(monkeys, monkey, relief:) }
end

def monkey_business(monkeys)
  monkeys.map(&:last).max(2).inject(&:*)
end

monkeys = parse_input('input.txt')
20.times { monkeys_round(monkeys) }
puts "part 1: #{monkey_business(monkeys)}"

monkeys = parse_input('input.txt')
COMMON_DENOMINATOR = monkeys.map { |m| m[2] }.inject(&:*)
10_000.times { monkeys_round(monkeys, relief: false) }
puts "part 2: #{monkey_business(monkeys)}"
