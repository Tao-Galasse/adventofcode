# frozen_string_literal: true

class Board
  def initialize(raw_board)
    @lines = raw_board.split("\n").map(&:split)
    @columns = (0..4).map { |i| @lines.map { |line| line[i] } }
  end

  def win?(numbers)
    @lines.each { |line| return true if (line - numbers).empty? }
    @columns.each { |column| return true if (column - numbers).empty? }
    false
  end

  def score(numbers)
    @lines.flat_map { |line| line - numbers }.map(&:to_i).sum * numbers.last.to_i
  end
end

def parse_input(filename)
  @numbers = File.open(filename).read.split("\n\n")[0].split(',')
  @boards = File.open(filename).read.split("\n\n")[1..].map { |board| Board.new(board) }
end

def find_winning_board
  (4..@numbers.count).each do |i|
    @boards.each { |board| return [board, @numbers[..i]] if board.win?(@numbers[..i]) }
  end
end

def find_losing_board
  remaining_boards = @boards.dup
  i = 4
  while remaining_boards.count > 1
    remaining_boards.each { |board| remaining_boards.delete(board) if board.win?(@numbers[..i]) }
    i += 1
  end
  [remaining_boards[0], @numbers[..i]]
end

parse_input('input.txt')
winning_board, drawn_numbers = find_winning_board
puts "part 1: final score of winning board = #{winning_board.score(drawn_numbers)}"
losing_board, drawn_numbers = find_losing_board
puts "part 2: final score of losing board = #{losing_board.score(drawn_numbers)}"
