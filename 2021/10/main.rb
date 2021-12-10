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

def parse_lines
  @illegal_chars = []
  @missing_chars = []
  @lines.each { |line| parse_line(line) }
  [@illegal_chars, @missing_chars]
end

def parse_line(line)
  opened_chunks = []
  line.chars.each do |chunk|
    if CHUNKS.keys.include?(chunk)
      opened_chunks << chunk
    elsif CHUNKS[opened_chunks[-1]] == chunk # `chunk` is a closing chunk and should match the last opened chunk
      opened_chunks.pop
    else
      return @illegal_chars << chunk # corrupted line
    end
  end
  @missing_chars << opened_chunks.reverse.map { |c| CHUNKS[c] } # return missing chars of incomplete line
end

def syntax_error_score(illegal_chars)
  illegal_chars.map { |c| ILLEGAL_CHAR_SCORE[c] }.sum
end

def middle_score(missing_chars)
  missing_chars.map { |chars| autocomplete_line_score(chars) }.sort[missing_chars.length / 2]
end

def autocomplete_line_score(chars)
  score = 0
  chars.map { |char| score = score * 5 + AUTOCOMPLETE_CHAR_SCORE[char] }.last
end

@lines = File.readlines('input.txt', chomp: true)
illegal_chars, missing_chars = parse_lines
puts "part 1: syntax error score = #{syntax_error_score(illegal_chars)}"
puts "part 2: middle score = #{middle_score(missing_chars)}"
