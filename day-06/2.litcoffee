# Part Two

Suppose the lanternfish live forever and have unlimited food and space. Would they take over the entire ocean?

After 256 days in the example above, there would be a total of 26984457539 lanternfish!

How many lanternfish would there be after 256 days?

## Defs

    { log } = console
    assert  = require 'assert'
    { readFileSync } = require 'fs'
    { countBy } = require 'underscore'

    parse = (text='')->
      ret = new Array(9).fill 0
      for key, val of countBy text.split(','), parseFloat
        ret[parseFloat(key)] = val
      ret

    run = (iterations=1, pop=[])->
      for i in [0...iterations]
        [breeding, pop...] = pop
        pop.push breeding
        pop[6] += breeding
      pop

    sum = (arr=[])->
      arr.reduce (memo, val)-> memo + val


## Tests

    input = """
      3,4,3,1,2
    """

    assert.equal 26984457539, sum run 256, parse input


## Run

    input = readFileSync './input', encoding: 'utf8'

    log sum run 256, parse input
