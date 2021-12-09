# Part Two

Next, you need to find the largest basins so you know what areas are most important to avoid.

A basin is all locations that eventually flow downward to a single low point. Therefore, every low point has a basin, although some basins are very small. Locations of height 9 do not count as being in any basin, and all other locations will always be part of exactly one basin.

The size of a basin is the number of locations within the basin, including the low point. The example above has four basins.

The top-left basin, size 3:

```plain
2199943210
3987894921
9856789892
8767896789
9899965678
```

The top-right basin, size 9:

```plain
2199943210
3987894921
9856789892
8767896789
9899965678
```

The middle basin, size 14:

```plain
2199943210
3987894921
9856789892
8767896789
9899965678
```

The bottom-right basin, size 9:

```plain
2199943210
3987894921
9856789892
8767896789
9899965678
```

Find the three largest basins and multiply their sizes together. In the above example, this is 9 * 14 * 9 = 1134.

What do you get if you multiply together the sizes of the three largest basins?


## Defs

    { log } = console
    assert  = require 'assert'
    { readFileSync } = require 'fs'

    parse = (text='')->
      text
      .split "\n"
      .map (line)->
        line
        .split ''
        .map parseFloat

    lowPoints = (map=[], lows=[])->
      for row, idy in map
        for cell, idx in row
          if [
            row[idx-1]
            row[idx+1]
            map[idy-1]?[idx]
            map[idy+1]?[idx]
          ]
          .filter (n)-> n?
          .every  (n)-> cell < n
            lows.push [idy, idx]
      lows

    explore = (map=[], y=0, x=0, seen={})->
      # mark as seen
      seen["#{y},#{x}"] = map[y]?[x]

      # for each neighbouring cell
      [
        [y,x-1] # left
        [y,x+1] # right
        [y-1,x] # up
        [y+1,x] # down
      ]
      .filter ([y,x])->
        # without previously explored cells
        not seen["#{y},#{x}"]?
      .filter ([y,x])->
        # stay on the map
        map[y]?[x]?
      .filter ([y,x])->
        # ignore 9's
        map[y]?[x] < 9
      .forEach ([y,x])->
        # recursively explore from this cell
        seen = explore map, y, x, seen

      seen

    # multiply all args together
    product = (arr...)->
      arr.reduce (memo, val)->
        memo * val
      , 1

    basinProduct = (map=[])->
      sizes = \
      lowPoints map
      .map ([y,x])->
        explore map, y, x
      .map (seen={})->
        Object.keys(seen).length

      # ugh JS why is sort so awkwardddddd
      sizes.sort (a,b)-> b-a

      product sizes[0...3]...


## Tests

    input = """
      2199943210
      3987894921
      9856789892
      8767896789
      9899965678
    """

    assert.equal 1134, basinProduct parse input


## Run

    input = readFileSync './input', encoding: 'utf8'

    log basinProduct parse input
