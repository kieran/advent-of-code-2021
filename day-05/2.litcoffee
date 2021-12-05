# Part Two

Unfortunately, considering only horizontal and vertical lines doesn't give you the full picture; you need to also consider diagonal lines.

Because of the limits of the hydrothermal vent mapping system, the lines in your list will only ever be horizontal, vertical, or a diagonal line at exactly 45 degrees. In other words:

- An entry like 1,1 -> 3,3 covers points 1,1, 2,2, and 3,3.
- An entry like 9,7 -> 7,9 covers points 9,7, 8,8, and 7,9.

Considering all lines from the above example would now produce the following diagram:

```plain
1.1....11.
.111...2..
..2.1.111.
...1.2.2..
.112313211
...1.2....
..1...1...
.1.....1..
1.......1.
222111....
```

You still need to determine the number of points where at least two lines overlap. In the above example, this is still anywhere in the diagram with a 2 or larger - now a total of 12 points.

Consider all of the lines. At how many points do at least two lines overlap?


## Defs

    { log } = console
    assert  = require 'assert'
    { readFileSync } = require 'fs'

    parse = (text='')->
      text
      .split "\n"
      .filter (line)-> line.length
      .map (line)->
        line
        .split ' -> '
        .map (coords)->
          coords
          .split ','
          .map parseFloat
      .map (coords)->
        new Line coords...

    class Line
      constructor: ([@x1, @y1], [@x2, @y2])->
      points: =>
        xs = [@x1..@x2]
        ys = [@y1..@y2]
        len = Math.max xs.length, ys.length
        ([xs[idx] ?= @x1, ys[idx] ?= @y1] for _, idx in ([0...len]))
      coords: =>
        @points()
        .map (point)->
          point.join ','

    collisions = (lines=[])->
      map = {}
      for line in lines
        for coord in line.coords()
          map[coord] ?= 0
          map[coord] += 1
      (key for key, val of map when val >= 2)

    numCollisions = (lines=[])->
      collisions(lines).length


## Tests

    input = """
      0,9 -> 5,9
      8,0 -> 0,8
      9,4 -> 3,4
      2,2 -> 2,1
      7,0 -> 7,4
      6,4 -> 2,0
      0,9 -> 2,9
      3,4 -> 1,4
      0,0 -> 8,8
      5,5 -> 8,2
    """

    assert.equal 12, numCollisions parse input


## Run

    input = readFileSync './input', encoding: 'utf8'

    log numCollisions parse input
