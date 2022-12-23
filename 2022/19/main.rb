# frozen_string_literal: true

def find_best_geode_production(blueprint, time)
  queue = [{
    time:, ore: 0, clay: 0, obsi: 0, geode: 0, ore_bots: 1, clay_bots: 0, obsi_bots: 0,
    can_build_obsi_bot: true, can_build_clay_bot: true, can_build_ore_bot: true
  }]
  max_ore_bots = [blueprint[0], blueprint[1], blueprint[2], blueprint[4]].max
  max_geodes = 0

  until queue.empty?
    resources = queue.pop

    # if the counter reached 0, we could have found a new best!
    if resources[:time] == 0
      max_geodes = [max_geodes, resources[:geode]].max
      next
    end

    # if even in the best scenario (where we build a geode bot every minute),
    # we could not reach the current max, there is no need to continue in this path.
    next if resources[:geode] + (1..resources[:time] - 1).sum < max_geodes

    next_resources = next_resources(resources)

    # if we build a geode bot, it will start creating geodes in 1 minute until the end
    if can_build_geode_bot?(blueprint, resources)
      queue << next_resources.merge(
        geode: resources[:geode] + resources[:time] - 1,
        ore: next_resources[:ore] - blueprint[4], obsi: next_resources[:obsi] - blueprint[5]
      )
    else # we will never build another bot if we can build a geode bot
      can_build_obsi_bot = can_build_obsi_bot?(blueprint, resources)
      if can_build_obsi_bot
        queue << next_resources.merge(obsi_bots: resources[:obsi_bots] + 1, ore: next_resources[:ore] - blueprint[2],
                                      clay: next_resources[:clay] - blueprint[3])
      end

      can_build_clay_bot = can_build_clay_bot?(blueprint, resources)
      if can_build_clay_bot
        queue << next_resources.merge(clay_bots: resources[:clay_bots] + 1, ore: next_resources[:ore] - blueprint[1])
      end

      can_build_ore_bot = can_build_ore_bot?(blueprint, resources, max_ore_bots)
      if can_build_ore_bot
        queue << next_resources.merge(ore_bots: resources[:ore_bots] + 1, ore: next_resources[:ore] - blueprint[0])
      end

      # we could choose to build nothing in order to save our resources;
      # however, if we do so even if we could have built a bot, it would be useless to build this bot later.
      queue << next_resources.merge(
        can_build_obsi_bot: !can_build_obsi_bot, can_build_clay_bot: !can_build_clay_bot,
        can_build_ore_bot: !can_build_ore_bot
      )
    end
  end

  max_geodes
end

def next_resources(resources)
  resources.dup.merge(
    time: resources[:time] - 1,
    ore: resources[:ore] + resources[:ore_bots],
    clay: resources[:clay] + resources[:clay_bots],
    obsi: resources[:obsi] + resources[:obsi_bots],
    can_build_obsi_bot: true,
    can_build_clay_bot: true,
    can_build_ore_bot: true
  )
end

def can_build_geode_bot?(blueprint, resources)
  resources[:ore] >= blueprint[4] && resources[:obsi] >= blueprint[5]
end

# We don't need more obsi bots than the number of obsidians required to build a geode bot.
# We don't need more obsi bots if we can't consume more than what we have already in stock.
def can_build_obsi_bot?(blueprint, resources)
  return false unless resources[:can_build_obsi_bot]
  return false if resources[:obsi_bots] == blueprint[5]
  return false if resources[:obsi] > blueprint[5] * resources[:time]

  resources[:ore] >= blueprint[2] && resources[:clay] >= blueprint[3]
end

# We don't need more clay bots than the number of clay required to build an obsidian bot.
# We don't need more clay bots if we can't consume more than what we have already in stock.
def can_build_clay_bot?(blueprint, resources)
  return false unless resources[:can_build_clay_bot]
  return false if resources[:clay_bots] == blueprint[3]
  return false if resources[:clay] > blueprint[3] * resources[:time]

  resources[:ore] >= blueprint[1]
end

# We don't need more ore bots than the maximum ore we can use in one minute (aka the ore-costlier bot)
# We don't need more ore bots if we can't consume more than what we have already in stock.
def can_build_ore_bot?(blueprint, resources, max_ore_bots)
  return false unless resources[:can_build_ore_bot]
  return false if resources[:ore_bots] == max_ore_bots
  return false if resources[:ore] > max_ore_bots * resources[:time]

  resources[:ore] >= blueprint[0]
end

def find_max_geodes(blueprints, time)
  blueprints.map { |blueprint| find_best_geode_production(blueprint, time) }
end

# Blueprint format:
# [ore_cost_for_ore, ore_cost_for_clay, ore_cost_for_obsidian,
#  clay_cost_for_obsi, ore_cost_for_geode, obsi_cost_for_geode]
blueprints = File.readlines('input.txt', chomp: true).map do |line|
  line.scan(/\d+/)[1..].map(&:to_i)
end

quality_levels = find_max_geodes(blueprints, 24).map.with_index { |geodes, i| geodes * (i + 1) }
puts "part 1: #{quality_levels.sum}" # takes ~3min on my machine (MacBook Pro 2019 2,6 GHz)

three_first_max = find_max_geodes(blueprints[0..2], 32)
puts "part 2: #{three_first_max.inject(:*)}" # takes ~2min on my machine (MacBook Pro 2019 2,6 GHz)
