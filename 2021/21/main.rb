# frozen_string_literal: true

# Play the game until a player wins, and returns the score of the losing one
def play_deterministic_game(p1_pos, p2_pos)
  p1_score = p2_score = 0
  player1_turn = true

  while p1_score < 1000 && p2_score < 1000
    roll = 3.times.map { roll_deterministic_dice }.sum

    if player1_turn
      p1_pos, p1_score = new_pos_and_score(p1_pos, p1_score, roll)
    else
      p2_pos, p2_score = new_pos_and_score(p2_pos, p2_score, roll)
    end

    player1_turn = !player1_turn
  end

  [p1_score, p2_score].min
end

# Roll the deterministic dice & increment the number of total rolls
def roll_deterministic_dice
  @rolls += 1
  @dice = ((@dice + 1) % 100).then { |d| d == 0 ? 100 : d }
end

# For a given position, score and roll, return the new position & the new score
def new_pos_and_score(pos, score, roll)
  new_pos = ((pos + roll) % 10).then { |position| position == 0 ? 10 : position }
  [new_pos, score + new_pos]
end

# Represents the number of possible universes for each sum of values of the Dirac dice
DIRAC_DICE_DISTRIBUTION = {
  3 => 1, # [1, 1, 1]
  4 => 3, # [1, 1, 2], [1, 2, 1], [2, 1, 1]
  5 => 6, # [1, 1, 3], [1, 3, 1], [3, 1, 1], [1, 2, 2], [2, 1, 2], [2, 2, 1]
  6 => 7, # [1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 2, 2], [2, 3, 1], [3, 1, 2], [3, 2, 1]
  7 => 6, # [1, 3, 3], [3, 1, 3], [3, 3, 1], [2, 2, 3], [2, 3, 2], [3, 2, 2]
  8 => 3, # [2, 3, 3], [3, 2, 3], [3, 3, 2]
  9 => 1  # [3, 3, 3]
}.freeze

# We represent a game as an aggregate of positions & scores of each player
class Game
  attr_accessor :p1_pos, :p2_pos, :p1_score, :p2_score

  def initialize(p1_pos, p2_pos, p1_score = 0, p2_score = 0)
    @p1_pos = p1_pos
    @p2_pos = p2_pos
    @p1_score = p1_score
    @p2_score = p2_score
  end
end

# Play one turn of all the existing quantum games & return the new unfinished games
def play_one_quantum_turn(games, player1_turn)
  next_games = Hash.new(0)

  games.each do |game, count|
    DIRAC_DICE_DISTRIBUTION.each do |roll, occurrence|
      new_count = count * occurrence

      if player1_turn
        new_pos, new_score = new_pos_and_score(game.p1_pos, game.p1_score, roll)
        new_game = Game.new(new_pos, game.p2_pos, new_score, game.p2_score)
        if new_score >= 21
          @p1_wins += new_count
        else
          next_games[new_game] += new_count
        end
      else
        new_pos, new_score = new_pos_and_score(game.p2_pos, game.p2_score, roll)
        new_game = Game.new(game.p1_pos, new_pos, game.p1_score, new_score)
        if new_score >= 21
          @p2_wins += new_count
        else
          next_games[new_game] += new_count
        end
      end
    end
  end

  next_games
end

# Play the quantum game while all games in all universes are not finished.
# We memorize each game & its number of universes where it exists.
def play_quantum_game(p1_pos, p2_pos)
  # in the beggining, there is only 1 game existing with a given configuration (positions & scores)
  games = { Game.new(p1_pos, p2_pos) => 1 }
  player1_turn = true

  # while there is at least 1 unfinished game, we roll the dirac dice!
  while games.values.reject(&:zero?).any?
    games = play_one_quantum_turn(games, player1_turn)
    player1_turn = !player1_turn
  end
end

p1_pos, p2_pos = File.readlines('input.txt', chomp: true).map { |l| l[-1].to_i }

@dice = 0
@rolls = 0
losing_score = play_deterministic_game(p1_pos, p2_pos)
puts "part 1: losing_score * dice rolls = #{losing_score * @rolls}"

@p1_wins = @p2_wins = 0
play_quantum_game(p1_pos, p2_pos)
puts "part 2: the more successful player wins in #{[@p1_wins, @p2_wins].max} universes"
# Takes around ~2min40 to get results!
