# Part 2

Finish folding the transparent paper according to the instructions. The manual says the code is always eight capital letters.

What code do you use to activate the infrared thermal imaging camera system?


## Defs

    { log } = console
    assert  = require 'assert'
    { readFileSync } = require 'fs'
    { uniq } = require 'underscore'

    parse = (text='')->
      [dots, dirs] = text.split "\n\n"

      [
        dots
        .split "\n"
        .map (coords)->
          coords
          .split ','
          .map parseFloat
      ,
        dirs
        .split "\n"
        .filter (l)-> l.length
        .map (dir)->
          [_, axis, foldIdx] = dir.match /([xy])=(\d+)/
          [axis, parseFloat foldIdx]
      ]

    fold = (dots=[], dirs=[])->
      for [axis, foldIdx] in dirs
        axisIdx = ['x','y'].indexOf axis

        # apply fold
        for dot, idx in dots
          if dot[axisIdx] > foldIdx
            dots[idx][axisIdx] = foldIdx - (dot[axisIdx] - foldIdx)

      uniq dots, (dot)-> JSON.stringify dot

    print = (dots=[])->
      max_x = Math.max ...dots.map ([x,y])-> x
      max_y = Math.max ...dots.map ([x,y])-> y

      ret = ''
      for y in [0..max_y]
        for x in [0..max_x]
          if dots.find ([dx,dy])-> dx is x and dy is y
            ret += '#'
          else
            ret += ' '
        ret += "\n"
      log ret


## Tests

    input = """
      6,10
      0,14
      9,10
      0,3
      10,4
      4,11
      6,0
      6,12
      4,1
      0,13
      10,12
      3,4
      3,0
      8,4
      1,10
      2,14
      8,10
      9,0

      fold along y=7
      fold along x=5
    """

    log 'this should print a square:'
    print fold ...parse input


## Run

    input = readFileSync './input', encoding: 'utf8'

    log '8 uppercase chars:'
    print fold ...parse input
