# frozen_string_literal: true

require 'set'

def parse_input(filename)
  File.readlines(filename, chomp: true).map do |line|
    valve, flow, next_valves = line.match('Valve (.*?) has flow rate=(\d+); tunnels? leads? to valves? (...*)')[1..]
    flow = flow.to_i
    next_valves = next_valves.split(', ')
    [valve, flow, next_valves]
  end
end

# Implementation of the Floyd–Warshall algorithm: we compute the distance between every valve to every other valve
def compute_all_distances
  valves = @valves.map(&:first)
  valves.product(valves).each_with_object({}) do |(v1, v2), distances|
    distances[[v1, v2]] = compute_distance(v1, v2)
  end
end

# Get the shortest distance between 2 valves
def compute_distance(from, to)
  path = Set.new([to])

  loop.inject(0) do |distance, _index|
    return distance if path.include?(from)

    path = path.each_with_object(Set.new) do |node, path_to_node|
      @valves.each { |valve, _flow, next_valves| path_to_node << valve if next_valves.include?(node) }
    end

    distance + 1
  end
end

def solve(current_valve, countdown, pressure = 0, paths = {}, opened = Set.new)
  paths[opened] = [paths.fetch(opened, 0), pressure].max

  @positive_valves.each do |next_valve, flow, _|
    next if opened.include?(next_valve)

    remaining_time = countdown - @distances[[current_valve, next_valve]] - 1
    next if remaining_time < 0

    solve(next_valve, remaining_time, pressure + (remaining_time * flow), paths, opened + [next_valve])
  end

  paths
end

def solve_with_elephant(current_valve, countdown)
  max_pressures = solve(current_valve, countdown)

  # There is 2 people going through the cave,
  # and if one of them opened a valve, the other one can't open it too.
  # So, we have to exclude solutions where the two people opened at least one common valve.
  max_pressures.flat_map do |opened1, pressure1|
    max_pressures.map do |opened2, pressure2|
      opened1.intersect?(opened2) ? 0 : pressure1 + pressure2
    end
  end.max
end

@valves = parse_input('input.txt')
@positive_valves = @valves.select { |_, flow, _| flow > 0 }
@distances = compute_all_distances

max_pressures = solve('AA', 30)
puts "part 1: #{max_pressures.values.max}"
puts "part 2: #{solve_with_elephant('AA', 26)}" # takes ~80s on my machine (MacBook Pro 2019 2,6 GHz)
