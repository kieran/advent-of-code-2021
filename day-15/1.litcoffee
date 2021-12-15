# Day 15: Chiton

You've almost reached the exit of the cave, but the walls are getting closer together. Your submarine can barely still fit, though; the main problem is that the walls of the cave are covered in chitons, and it would be best not to bump any of them.

The cavern is large, but has a very low ceiling, restricting your motion to two dimensions. The shape of the cavern resembles a square; a quick scan of chiton density produces a map of risk level throughout the cave (your puzzle input). For example:

    input = """
      1163751742
      1381373672
      2136511328
      3694931569
      7463417111
      1319128137
      1359912421
      3125421639
      1293138521
      2311944581
    """

You start in the top left position, your destination is the bottom right position, and you cannot move diagonally. The number at each position is its risk level; to determine the total risk of an entire path, add up the risk levels of each position you enter (that is, don't count the risk level of your starting position unless you enter it; leaving it adds no risk to your total).

Your goal is to find a path with the lowest total risk. In this example, a path with the lowest total risk is highlighted here:

<pre><code><em>1</em>163751742
<em>1</em>381373672
<em>2136511</em>328
369493<em>15</em>69
7463417<em>1</em>11
1319128<em>13</em>7
13599124<em>2</em>1
31254216<em>3</em>9
12931385<em>21</em>
231194458<em>1</em>
</code></pre>

The total risk of this path is 40 (the starting position is never entered, so its risk is not counted).

What is the lowest total risk of any path from the top left to the bottom right?


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
        .split ''
        .map parseFloat

    safestPath = (map=[])->
      goal_y = map.length - 1
      goal_x = map[0].length - 1

      open = [
        y: 0
        x: 0
        risk: 0
      ]
      opened = {'0,0': 0}
      closed = {}

      while true
        {y, x, risk} = open.shift()
        closed["#{y},#{x}"] = risk

        return risk if y is goal_y and x is goal_x

        # search the  neighbouring cells
        neighbours = [
          [y, x+1]
          [y, x-1]
          [y+1, x]
          [y-1, x]
        ]

        next = \
        neighbours
        .filter ([ny, nx])->
          map[ny]?[nx]
        .filter ([ny, nx])->
          not closed["#{ny},#{nx}"]?
        .filter ([ny, nx])->
          not opened["#{ny},#{nx}"]?
        .forEach ([ny, nx])->
          opened["#{ny},#{nx}"] = risk + map[ny][nx]
          open.push y: ny, x: nx, risk: risk + map[ny][nx]

        open.sort (a,b)-> a.risk - b.risk


## Tests

    assert.equal 40, safestPath parse input


## Run

    input = readFileSync './input', encoding: 'utf8'

    log safestPath parse input
