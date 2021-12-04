# Part Two

On the other hand, it might be wise to try a different strategy: let the giant squid win.

You aren't sure how many bingo boards a giant squid could play at once, so rather than waste time counting its arms, the safe thing to do is to figure out which board will win last and choose that one. That way, no matter which boards it picks, it will win for sure.

In the above example, the second board is the last to win, which happens after 13 is eventually called and its middle column is completely marked. If you were to keep playing until this point, the second board would have a sum of unmarked numbers equal to 148 for a final score of 148 * 13 = 1924.

Figure out which board will win last. Once it wins, what would its final score be?

## Defs

    { log } = console
    assert  = require 'assert'
    { readFileSync } = require 'fs'
    { zip, flatten } = require 'underscore'

    parse = (text='')->
      [numbers, boards...] = text.split "\n\n"

      numbers = \
      numbers
      .split ','
      .map parseFloat

      boards = \
      boards
      .map (board)->
        board
        .split "\n"
        .map (line)->
          line
          .split /\s+/
          .map parseFloat
          .filter Number.isInteger
        .filter (line)-> line.length

      [numbers, boards...]

    play = (numbers=[], boards...)->
      for num in numbers
        boards = stamp num, boards...
        if boards.length is 1 and boardWon boards[0]
          return score boards[0], num
        boards = boards.filter (b)-> !boardWon b

    stamp = (num=0, boards...)->
      for board in boards
        for row in board
          for cell, idx in row
            if cell is num
              row[idx] = null
      boards

    boardWon = (board=[])->
      for lines in [board, zip board...]
        for line in lines
          return true if line.every (n)-> n is null
      false

    score = (board=[], num=0)->
      num * \
      flatten board
      .filter Number.isInteger
      .reduce (memo, val)-> memo + val


## Tests

    input = """
      7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

      22 13 17 11  0
       8  2 23  4 24
      21  9 14 16  7
       6 10  3 18  5
       1 12 20 15 19

       3 15  0  2 22
       9 18 13 17  5
      19  8  7 25 23
      20 11 10 24  4
      14 21 16 12  6

      14 21 17 24  4
      10 16 15  9 19
      18  8 23 26 20
      22 11 13  6  5
       2  0 12  3  7
    """

    assert.equal 1924, play ...parse input


## Run

    input = readFileSync './input', encoding: 'utf8'

    log play ...parse input
