# frozen_string_literal: true

CHUNKS = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>'
}.freeze

ILLEGAL_CHAR_SCORE = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25_137
}.freeze

AUTOCOMPLETE_CHAR_SCORE = {
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4
}.freeze

# Part 1
def find_corrupted_lines
  @lines.map { |line| find_illegal_char(line) }.compact
end

def find_illegal_char(line)
  opened_chunks = []
  line.chars.each do |chunk|
    if CHUNKS.keys.include?(chunk)
      opened_chunks << chunk
    elsif CHUNKS[opened_chunks[-1]] == chunk # `chunk` is a closing chunk and should match the last opened chunk
      opened_chunks.pop
    else
      return chunk
    end
  end
  nil
end

def syntax_error_score(illegal_chars)
  illegal_chars.map { |c| ILLEGAL_CHAR_SCORE[c] }.sum
end

# Part 2
def find_incomplete_lines
  @lines.map { |line| find_missing_chars(line) }.compact
end

def find_missing_chars(line)
  opened_chunks = []
  line.chars.each do |chunk|
    if CHUNKS.keys.include?(chunk)
      opened_chunks << chunk
    elsif CHUNKS[opened_chunks[-1]] == chunk # `chunk` is a closing chunk and should match the last opened chunk
      opened_chunks.pop
    else
      return nil # this is a corrupted line ; we ignore it
    end
  end
  opened_chunks.reverse.map { |c| CHUNKS[c] }
end

def middle_score(missing_chars)
  missing_chars.map { |chars| autocomplete_line_score(chars) }.sort[missing_chars.length / 2]
end

def autocomplete_line_score(chars)
  score = 0
  chars.map { |char| score = score * 5 + AUTOCOMPLETE_CHAR_SCORE[char] }.last
end

@lines = File.readlines('input.txt', chomp: true)
illegal_chars = find_corrupted_lines
puts "part 1: syntax error score = #{syntax_error_score(illegal_chars)}"
missing_chars = find_incomplete_lines
puts "part 2: middle score = #{middle_score(missing_chars)}"
