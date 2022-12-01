# frozen_string_literal: true

# A player is represented by its position and its score
class Player
  attr_accessor :position, :score

  def initialize(position, score = 0)
    @position = position
    @score = score
  end
end

# A game is represented by two players
class Game
  attr_accessor :p1, :p2

  def initialize(p1_pos, p2_pos, p1_score = 0, p2_score = 0)
    @p1 = Player.new(p1_pos, p1_score)
    @p2 = Player.new(p2_pos, p2_score)
  end
end

# Play the deterministic game until a player wins & return the state of the game
def play_deterministic_game(p1_pos, p2_pos)
  game = Game.new(p1_pos, p2_pos)
  dice = 0
  p1_turn = true

  while game.p1.score < 1000 && game.p2.score < 1000
    roll = 3.times.map { dice = roll_deterministic_dice(dice) }.sum

    player = p1_turn ? game.p1 : game.p2
    player.position, player.score = new_position_and_score(player.position, player.score, roll)

    p1_turn = !p1_turn
  end

  game
end

# Increment the number of total rolls, roll the deterministic dice & return its new value
def roll_deterministic_dice(dice)
  @rolls += 1
  ((dice + 1) % 100).then { |d| d == 0 ? 100 : d }
end

# For a given position, score and roll, returns the new position & score of the player
def new_position_and_score(position, score, roll)
  new_position = ((position + roll) % 10).then { |pos| pos == 0 ? 10 : pos }
  [new_position, new_position + score]
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

# Play one turn of all the existing quantum games & return the new unfinished games.
# If a player won during this turn, increment its wins counter by the number of similar universes where it won.
def play_one_quantum_turn(games, p1_turn)
  next_games = Hash.new(0)

  games.each do |game, count|
    DIRAC_DICE_DISTRIBUTION.each do |roll, occurrence|
      new_count = count * occurrence

      if p1_turn
        new_position, new_score = new_position_and_score(game.p1.position, game.p1.score, roll)
        if new_score >= 21
          @p1_wins += new_count
        else
          new_game = Game.new(new_position, game.p2.position, new_score, game.p2.score)
          next_games[new_game] += new_count
        end
      else
        new_position, new_score = new_position_and_score(game.p2.position, game.p2.score, roll)
        if new_score >= 21
          @p2_wins += new_count
        else
          new_game = Game.new(game.p1.position, new_position, game.p1.score, new_score)
          next_games[new_game] += new_count
        end
      end
    end
  end

  next_games
end

# Play the quantum game while all games in all universes are not finished.
# We memorize each game & the number of universes where it exists.
def play_quantum_game(p1_pos, p2_pos)
  # in the beggining, there is only 1 game existing in 1 universe
  games = { Game.new(p1_pos, p2_pos) => 1 }
  p1_turn = true

  # while there is at least 1 unfinished game, we roll the dirac dice and split the universe!
  while games.any?
    games = play_one_quantum_turn(games, p1_turn)
    p1_turn = !p1_turn
  end
end

p1_pos, p2_pos = File.readlines('input.txt', chomp: true).map { |l| l[-1].to_i }

@rolls = 0
game = play_deterministic_game(p1_pos, p2_pos)
losing_score = [game.p1.score, game.p2.score].min
puts "part 1: losing_score * dice rolls = #{losing_score * @rolls}"

@p1_wins = @p2_wins = 0
play_quantum_game(p1_pos, p2_pos)
puts "part 2: the more successful player wins in #{[@p1_wins, @p2_wins].max} universes"
# Takes around ~2min to get results!
