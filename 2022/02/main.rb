# frozen_string_literal: true

# [A, X] => Rock, [B, Y] => Paper, [C, Z] => Scissors
LOSE = { 'A' => 'Z', 'B' => 'X', 'C' => 'Y' }.freeze
DRAW = { 'A' => 'X', 'B' => 'Y', 'C' => 'Z' }.freeze
WIN = { 'A' => 'Y', 'B' => 'Z', 'C' => 'X' }.freeze

SCORES = { 'X' => 1, 'Y' => 2, 'Z' => 3 }.freeze

# The second param of a round is what I have to play : X = Rock, Y = Paper, Z = Scissors
def play_part1(rounds)
  score = 0

  rounds.each do |opponent, me|
    case me
    when WIN[opponent] then score += 6
    when DRAW[opponent] then score += 3
    end

    score += SCORES[me]
  end

  score
end

# The second param of a round is how it must end for me : X = lose, Y = draw, Z = win
def play_part2(rounds)
  score = 0

  rounds.each do |opponent, result|
    case result
    when 'X' then score += SCORES[LOSE[opponent]]
    when 'Y' then score += SCORES[DRAW[opponent]] + 3
    when 'Z' then score += SCORES[WIN[opponent]] + 6
    end
  end

  score
end

rounds = File.readlines('input.txt', chomp: true).map(&:split)
puts "part 1: My final score is #{play_part1(rounds)}"
puts "part 2: My final score is #{play_part2(rounds)}"
