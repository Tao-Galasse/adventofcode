# frozen_string_literal: true

def run_cpu(instructions)
  x = 1
  cycle = 0
  signal_strength = 0
  drawing = ''

  instructions.each do |command, value|
    case command
    when 'noop'
      cycle, signal_strength, drawing = update_clock(cycle, x, signal_strength, drawing)
    when 'addx'
      2.times { cycle, signal_strength, drawing = update_clock(cycle, x, signal_strength, drawing) }
      x += value
    end
  end

  [signal_strength, drawing]
end

def update_clock(cycle, x, signal_strength, drawing)
  drawing += (x - 1..x + 1).include?(cycle % 40) ? '#' : ' '
  cycle += 1
  signal_strength += x * cycle if [20, 60, 100, 140, 180, 220].include?(cycle)

  [cycle, signal_strength, drawing]
end

def crt_display(drawing)
  drawing.chars.each_slice(40) { |line| puts line.join }
end

instructions = File.readlines('input.txt', chomp: true).map(&:split).map { [_1, _2.to_i] }
signal_strength, drawing = run_cpu(instructions)
puts "part 1: #{signal_strength}"
puts 'part 2:'
crt_display(drawing)
