# frozen_string_literal: true

# e.g.: '1111' => 'F'
def bin_to_hex(bits)
  bits.to_i(2).to_s(16).upcase
end

# e.g.: '3' => '0011'
def hex_to_bin(char)
  format('%04d', char.hex.to_s(2))
end

def literal_value
  i = 0
  value = ''
  loop do
    value += @bits[(i + 1)..(i + 4)]
    break if @bits[i] == '0'

    i += 5
  end
  @bits = @bits[(i + 5)..] # remove all parsed bits
  value.to_i(2)
end

def operator
  length_type_id = @bits[0]
  if length_type_id == '0' # the next 15 bits are the total length in bits of the sub-packets
    subpacket_bits_length = @bits[1..15].to_i(2)
    @bits = @bits[16..] # remove the 16 first bits
    ending_bits_length = @bits.length - subpacket_bits_length
    values = []
    values << parse_packet while @bits.length > ending_bits_length
    values
  else # the next 11 bits are the number of sub-packets
    number_of_packets = @bits[1..11].to_i(2)
    @bits = @bits[12..] # remove the 12 first bits
    number_of_packets.times.map { parse_packet }
  end
end

def parse_packet
  @versions_sum += bin_to_hex(@bits[0..2]).to_i
  type_id = bin_to_hex(@bits[3..5])
  @bits = @bits[6..] # remove the 6 first bits

  case type_id
  when '0'
    operator.map(&:to_i).sum
  when '1'
    operator.map(&:to_i).inject(:*)
  when '2'
    operator.map(&:to_i).min
  when '3'
    operator.map(&:to_i).max
  when '4'
    literal_value
  when '5'
    operator.map(&:to_i).inject(:>) ? 1 : 0
  when '6'
    operator.map(&:to_i).inject(:<) ? 1 : 0
  when '7'
    operator.map(&:to_i).inject(:==) ? 1 : 0
  end
end

hexa = File.read('input.txt').split("\n")[0]
@bits = hexa.chars.map { |char| hex_to_bin(char) }.join
@versions_sum = 0
result = parse_packet
puts "part 1: sum of versions = #{@versions_sum}"
puts "part 2: result = #{result}"
