# frozen_string_literal: true

def find_monkey_number(name)
  if @monkeys[name].to_i.to_s == @monkeys[name]
    @monkeys[name]
  else
    monkey1, op, monkey2 = @monkeys[name].split
    eval(find_monkey_number(monkey1) + " #{op} " + find_monkey_number(monkey2)).to_s
  end
end

def find_humn_value
  @monkeys['root'] = @monkeys['root'].gsub(%r{\+|\*|/}, '-') # replace +, * or / by -
  left = -100_000_000_000_000
  right = 100_000_000_000_000
  valids = [] # multiple results could be the correct answer, but we are looking for the smallest one.

  while (right - left).abs > 1
    humn = (right + left).abs / 2
    @monkeys['humn'] = humn.to_s

    number = find_monkey_number('root').to_i
    if number < 0
      left = humn
    elsif number > 0
      right = humn
    else
      left < right ? right = humn : left = humn
      valids << humn
    end
  end

  valids.min
end

@monkeys = File.readlines('input.txt', chomp: true).to_h { |line| line.split(': ') }
puts "part 1: #{find_monkey_number('root')}"
puts "part 2: #{find_humn_value}"
