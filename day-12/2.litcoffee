# Part 2

After reviewing the available paths, you realize you might have time to visit a single small cave twice. Specifically, big caves can be visited any number of times, a single small cave can be visited at most twice, and the remaining small caves can be visited at most once. However, the caves named start and end can only be visited exactly once each: once you leave the start cave, you may not return to it, and once you reach the end cave, the path must end immediately.

Now, the 36 possible paths through the first example above are:

```plain
start,A,b,A,b,A,c,A,end
start,A,b,A,b,A,end
start,A,b,A,b,end
start,A,b,A,c,A,b,A,end
start,A,b,A,c,A,b,end
start,A,b,A,c,A,c,A,end
start,A,b,A,c,A,end
start,A,b,A,end
start,A,b,d,b,A,c,A,end
start,A,b,d,b,A,end
start,A,b,d,b,end
start,A,b,end
start,A,c,A,b,A,b,A,end
start,A,c,A,b,A,b,end
start,A,c,A,b,A,c,A,end
start,A,c,A,b,A,end
start,A,c,A,b,d,b,A,end
start,A,c,A,b,d,b,end
start,A,c,A,b,end
start,A,c,A,c,A,b,A,end
start,A,c,A,c,A,b,end
start,A,c,A,c,A,end
start,A,c,A,end
start,A,end
start,b,A,b,A,c,A,end
start,b,A,b,A,end
start,b,A,b,end
start,b,A,c,A,b,A,end
start,b,A,c,A,b,end
start,b,A,c,A,c,A,end
start,b,A,c,A,end
start,b,A,end
start,b,d,b,A,c,A,end
start,b,d,b,A,end
start,b,d,b,end
start,b,end
```

The slightly larger example above now has 103 paths through it, and the even larger example now has 3509 paths through it.

Given these new rules, how many paths through this cave system are there?


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
        .split '-'

    edges = (node_pairs=[])->
      ret = {}
      for [n1, n2] in node_pairs
        ret[n1] ?= []
        ret[n1].push n2
        ret[n2] ?= []
        ret[n2].push n1
      ret

    findPaths = (edges, path=['start'], dupeUsed=false)->
      paths = []
      [..., last] = path
      seen = path.filter (node)-> node.match /[a-z]+/

      nexts = \
      edges[last]
      .filter (node)->
        not dupeUsed or node not in seen

      return null unless nexts.length

      for next in nexts
        p = [path..., next]
        switch next
          when 'start'
            continue
          when 'end'
            paths.push p.join ','
          else
            paths.push findPaths edges, p, dupeUsed or next in seen

      flatten paths.filter (p)-> p

    numPaths = (edges=[])->
      findPaths edges
      .length


## Tests

    input = """
      start-A
      start-b
      A-c
      A-b
      b-d
      A-end
      b-end
    """

    assert.equal 36, numPaths edges parse input


## Run

    input = readFileSync './input', encoding: 'utf8'

    log numPaths edges parse input
