# Part Two

The resulting polymer isn't nearly strong enough to reinforce the submarine. You'll need to run more steps of the pair insertion process; a total of 40 steps should do it.

In the above example, the most common element is B (occurring 2192039569602 times) and the least common element is H (occurring 3849876073 times); subtracting these produces 2188189693529.

Apply 40 steps of pair insertion to the polymer template and find the most and least common elements in the result. What do you get if you take the quantity of the most common element and subtract the quantity of the least common element?


## Defs

    { log } = console
    assert  = require 'assert'
    { readFileSync } = require 'fs'

    # safely increment a key in obj by val
    inc = (obj={}, key, val)->
      obj[key] ?= 0
      obj[key] += val
      obj

    parse = (text='')->
      [template, rules] = text.split "\n\n"

      tMap = {}
      for char, idx in template
        if char2 = template[idx+1]
          inc tMap, char+char2, 1

      counts = {}
      for char in template
        inc counts, char, 1

      rules = \
      rules
      .split "\n"
      .map (rule)->
        rule.split ' -> '
      .reduce (memo, [key, val])->
        memo[key] = val
        memo
      , {}

      [tMap, counts, rules]

    polymerize = (template={}, counts={}, rules={})->
      ret = {}
      for key, val of template
        insert = rules[key]
        [left, right] = key.split ''

        inc ret, "#{left}#{insert}", val
        inc ret, "#{insert}#{right}", val
        inc counts, insert, val

      [ret, counts]

    polymerizeMany = (times=1, template={}, counts={}, rules={})->
      for i in [0...times]
        [template, counts] = polymerize template, counts, rules
      counts

    measure = (counts)->
      [min, ..., max] = \
      Object
      .values counts
      .sort (a,b)-> a - b

      max - min


## Tests

    input = """
      NNCB

      CH -> B
      HH -> N
      CB -> H
      NH -> C
      HB -> C
      HC -> B
      HN -> C
      NN -> C
      BH -> H
      NC -> B
      NB -> B
      BN -> B
      BB -> N
      BC -> B
      CC -> N
      CN -> C
    """

    assert.equal 1588, measure polymerizeMany 10, ...parse input
    assert.equal 2188189693529, measure polymerizeMany 40, ...parse input


## Run

    input = readFileSync './input', encoding: 'utf8'

    log measure polymerizeMany 40, ...parse input
