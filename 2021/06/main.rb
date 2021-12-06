# frozen_string_literal: true

def iterate
  timer_to_zero = @timers[0]
  @timers.transform_keys! { |k| k.zero? ? 8 : k - 1 }
  @timers[6] += timer_to_zero
end

@timers = Hash.new(0).merge(File.read('input.txt').split(',').map(&:to_i).tally)
80.times { iterate }
puts "part 1: #{@timers.values.sum} lanternfish would be there after 80 days"
176.times { iterate } # 256 - 80 = 176
puts "part 2: #{@timers.values.sum} lanternfish would be there after 256 days"
