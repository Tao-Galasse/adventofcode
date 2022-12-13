# frozen_string_literal: true

require 'json'

def parse_input(filename)
  File.read(filename).split("\n\n").map do |pair|
    pair.split("\n").map { |packet| JSON.parse(packet) }
  end
end

def find_ordered_pairs(pairs)
  indices = []
  pairs.each_with_index do |(p1, p2), i|
    indices << (i + 1) if compare_packets(p1, p2) # indices start at 1
  end
  indices
end

def compare_packets(p1, p2)
  return nil if p1 == p2

  loop.with_index do |_, i|
    return true if p1[i].nil?
    return false if p2[i].nil?

    if p1[i].is_a?(Integer) && p2[i].is_a?(Integer)
      p1[i] == p2[i] ? next : (return p1[i] < p2[i])
    end

    next_p1 = p1[i].is_a?(Array) ? p1[i] : [p1[i]]
    next_p2 = p2[i].is_a?(Array) ? p2[i] : [p2[i]]
    res = compare_packets(next_p1, next_p2)
    res.nil? ? next : (return res)
  end
end

def organize_packets(pairs)
  packets = pairs.inject([]) { |packet, (p1, p2)| packet + [p1, p2] }
  packets += [[[2]], [[6]]] # add the divider packets
  packets.sort! { |p1, p2| compare_packets(p1, p2) ? -1 : 1 }
end

pairs = parse_input('input.txt')
indices = find_ordered_pairs(pairs)
puts "part 1: #{indices.sum}"

packets = organize_packets(pairs)
dividers_indices = [packets.index([[2]]) + 1, packets.index([[6]]) + 1] # indices start at 1
puts "part 2: #{dividers_indices.inject(:*)}"
