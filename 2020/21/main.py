#!/usr/bin/env python

from collections import Counter


# Parse lines from an input file to get the list of foods
def parse_input(filename):
    foods = {}
    for line in open(filename, 'r').read().splitlines():
        ingredients, allergens = line.split(' (contains ')
        foods[ingredients] = allergens[:-1].split(', ')
    return foods


# Get all the unique ingredients in the list of FOODS
def get_ingredients():
    ingredients_list = set()  # we use a set to avoid duplicated ingredients
    for ingredients in FOODS.keys():
        for ingredient in ingredients.split():
            ingredients_list.add(ingredient)
    return ingredients_list


# Get all the unique allergens in the list of FOODS
def get_allergens():
    allergens_list = set()  # we use a set to avoid duplicated allergens
    for allergens in FOODS.values():
        for allergen in allergens:
            allergens_list.add(allergen)
    return allergens_list


# Get a list of foods (a list of lists of ingredients) containing an allergen
# e.g. [['mxmxvkd', 'kfcds', 'sqjhc', 'nhms'], ['sqjhc', 'mxmxvkd', 'sbzzf']]
def get_foods_containing(allergen):
    foods = []
    for ingredients, allergens in FOODS.items():
        if allergen in allergens:
            foods.append(ingredients.split())
    return foods


# Return a dictionary of unsafe ingredients with their possible allergens
def get_unsafe_ingredients():
    unsafe_ingredients = {}
    for allergen in get_allergens():
        foods = get_foods_containing(allergen)
        for ingredient in foods[0]:
            # an ingredient is unsafe when present in all the involving foods
            if all(ingredient in arr for arr in foods[1:]):
                if unsafe_ingredients.get(ingredient):
                    unsafe_ingredients[ingredient].append(allergen)
                else:
                    unsafe_ingredients[ingredient] = [allergen]
    return unsafe_ingredients


# Return the list of safe ingredients, thanks to a dictionary of unsafe ones
def get_safe_ingredients_list(unsafe_ingredients):
    return [ingredient for ingredient in get_ingredients()
            if ingredient not in unsafe_ingredients.keys()]


# Count the total number of occurrences of a list of ingredients in the foods
def count_ingredients_occurrences(ingredients):
    # we start by getting all ingredients, with duplications
    all_ingredients = [i for ingrdts in FOODS.keys() for i in ingrdts.split()]
    counters = Counter(all_ingredients)  # e.g. {'mxmxvkd': 3, 'nhms': 1}
    return sum([counters[ingredient] for ingredient in ingredients])


# Return a dictionary of ingredients associated to their allergen
def get_ingredients_allergens(unsafe_ingredients):
    # while any unsafe ingredient has many possibles allergens:
    while any(count > 1 for count in map(len, unsafe_ingredients.values())):
        for allergens in unsafe_ingredients.values():
            if len(allergens) == 1:
                [v.remove(allergens[0]) for v in unsafe_ingredients.values()
                    if allergens[0] in v and v != allergens]
    # Here, the allergens are stored in arrays; we mute it to string
    for ingredient, allergen in unsafe_ingredients.items():
        unsafe_ingredients[ingredient] = allergen[0]


# Return the canonical dangerous ingredient list
def get_canonical_dangerous_ingredients_list(unsafe_ingredients):
    # We sort the ingredients alphabetically by their allergen
    order = dict(sorted(unsafe_ingredients.items(), key=lambda item: item[1]))
    # We separate these ordered ingredients by commas
    return ','.join(order)


FOODS = parse_input("input.txt")
# Puzzle 1
unsafe_ingredients = get_unsafe_ingredients()
safe_ingredients = get_safe_ingredients_list(unsafe_ingredients)
print("Occurrences of safe ingredients in the list of foods:",
      count_ingredients_occurrences(safe_ingredients))
# Puzzle 2
get_ingredients_allergens(unsafe_ingredients)
# Now, unsafe_ingredients associate each ingredient with its unique allergen
canonical_list = get_canonical_dangerous_ingredients_list(unsafe_ingredients)
print("My canonical dangerous ingredient list is:", canonical_list)
