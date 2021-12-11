# Part 2

It seems like the individual flashes aren't bright enough to navigate. However, you might have a better option: the flashes seem to be synchronizing!

In the example above, the first time all octopuses flash simultaneously is step 195:

After step 193:

```plain
5877777777
8877777777
7777777777
7777777777
7777777777
7777777777
7777777777
7777777777
7777777777
7777777777
```

After step 194:

```plain
6988888888
9988888888
8888888888
8888888888
8888888888
8888888888
8888888888
8888888888
8888888888
8888888888
```

After step 195:

```plain
0000000000
0000000000
0000000000
0000000000
0000000000
0000000000
0000000000
0000000000
0000000000
0000000000
```

If you can calculate the exact moments when the octopuses will all flash simultaneously, you should be able to navigate through the cavern. What is the first step during which all octopuses flash?


## Defs

    { log } = console
    assert  = require 'assert'
    { readFileSync } = require 'fs'
    { flatten } = require 'underscore'

    parse = (text='')->
      text
      .split "\n"
      .map (line)->
        line
        .split ''
        .map parseFloat

    step = (board=[], flashes=0)->
      # increment all by 1
      for row in board
        for cell, idx in row
          row[idx] += 1

      # flash all the 10+'s until
      # there are no more 10+'s to flash
      while flatten(board).find (n)-> n > 9
        for row, idy in board
          for cell, idx in row
            if cell >= 10
              row[idx] = 0
              flashes += 1

              # inc the neighbours
              for y in [-1, 0, 1]
                for x in [-1, 0, 1]
                  # ignore the center cell (this cell)
                  continue if x is y is 0

                  val = board[idy+y]?[idx+x]
                  # inc+ unless it's OOB or was
                  # already reset to 0 this step
                  if val? and val
                    board[idy+y][idx+x] += 1

      # return the modified board
      # and the number of flashes
      # we've recorded during this step
      [board, flashes]

    syncStep = (board=[], flashes=0, iter=0)->
      num_octopi = flatten(board).length
      until flashes is num_octopi
        iter += 1
        [board, flashes] = step board
      iter


## Tests

    input = """
      5483143223
      2745854711
      5264556173
      6141336146
      6357385478
      4167524645
      2176841721
      6882881134
      4846848554
      5283751526
    """

    assert.equal 195, syncStep parse input


## Run

    input = readFileSync './input', encoding: 'utf8'

    log syncStep parse input
