# frozen_string_literal: true

# I couldn't implement a solution for this puzzle by myself and I was able to solve it by hand;
# but I was disappointed to not have an algorithmic solution for this day, so here it is.
# A lot of this code has been made with the help of the solution posted by u/ephemient on Reddit, thanks a lot to him!
# Source: https://github.com/ephemient/aoc2021/blob/main/py/aoc2021/day23.py

ALPHA = { 'A' => 1, 'B' => 2, 'C' => 3, 'D' => 4 }.freeze

def solve(lines)
  state = Array.new(11) { |_| Array.new(1, 0) }

  lines[2..-2].each do |line|
    (2..8).step(2) { |i| state[i] << ALPHA[line[i + 1]] }
  end

  visited = { state => 0 }
  queue = [{ cost: 0, state: state }]

  while queue
    # remove the first element from the queue (which has the minimal cost) & assign it to the `state` variable
    state = queue.shift[:state]
    cost = visited[state]
    return cost if (1..4).flat_map { |a| state[2 * a][1..].map { |b| a == b } }.all?

    priority_moves = []
    other_moves = []
    state.each_with_index do |src, i|
      a, x = src.map.with_index { |a, x| break a, x if a != 0 }
      next unless a.is_a?(Integer)
      next if i == 2 * a && src.map { |b| b != 0 && b != a }.none?

      state.each_with_index do |dst, j|
        next if i == j

        range = i < j ? (i + 1..j - 1) : (j + 1..i - 1)
        next if range.map { |k| state[k][0] }.any?(&:positive?)

        y = (dst.size - 1).downto(0).map { |d| break d if dst[d] == 0 }
        next unless y.is_a?(Integer)

        if j == 2 * a
          priority_moves << [a, i, x, j, y] if dst.map { |b| b == 0 || b == a }.all?
        elsif !(2..8).step(2).include?(j)
          other_moves << [a, i, x, j, y] if (2..8).step(2).include?(i) && dst[0] == 0
        end
      end
    end
    moves = priority_moves.empty? ? other_moves : [priority_moves[0]]
    moves.each do |a, i, x, j, y|
      cost2 = cost + 10**(a - 1) * ((i - j).abs + x + y)
      state2 = state.clone.map(&:clone) # deep copy
      state2[i][x] = 0
      state2[j][y] = a
      next if visited[state2] && visited[state2] <= cost2

      visited[state2] = cost2
      # insert the new path in the queue at the correct position (ordered by ascending costs)
      insert_at = queue.bsearch_index { |path| path[:cost] >= cost2 } || queue.length
      queue.insert(insert_at, { cost: cost2, state: state2 })
    end
  end
end

lines = File.readlines('input.txt', chomp: true)
puts "part 1: #{solve(lines)}"

lines.insert(3, '  #D#C#B#A#', '  #D#B#A#C#')
puts "part 2: #{solve(lines)}"
