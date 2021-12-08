# Part Two

Through a little deduction, you should now be able to determine the remaining digits. Consider again the first example above:

```plain
acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf
```

After some careful analysis, the mapping between signal wires and segments only make sense in the following configuration:

```plain
 dddd
e    a
e    a
 ffff
g    b
g    b
 cccc
```

So, the unique signal patterns would correspond to the following digits:

```plain
acedgfb: 8
cdfbe: 5
gcdfa: 2
fbcad: 3
dab: 7
cefabd: 9
cdfgeb: 6
eafb: 4
cagedb: 0
ab: 1
```

Then, the four digits of the output value can be decoded:

```plain
cdfeb: 5
fcadb: 3
cdfeb: 5
cdbaf: 3
```

Therefore, the output value for this entry is 5353.

Following this same process for each entry in the second, larger example above, the output value of each entry can be determined:

```plain
fdgacbe cefdb cefbgd gcbe: 8394
fcgedb cgb dgebacf gc: 9781
cg cg fdcagb cbg: 1197
efabcd cedba gadfec cb: 9361
gecf egdcabf bgf bfgea: 4873
gebdcfa ecba ca fadegcb: 8418
cefg dcbef fcge gbcadfe: 4548
ed bcgafe cdgba cbgef: 1625
gbdfcae bgc cg cgb: 8717
fgae cfgab fg bagce: 4315
```

Adding all of the output values in this larger example produces 61229.

For each entry, determine all of the wire/segment connections and decode the four-digit output values. What do you get if you add up all of the output values?


## Defs

    { log } = console
    assert  = require 'assert'
    { readFileSync } = require 'fs'
    { difference } = require 'underscore'

    includes = (a1, a2)-> a2.every (el)-> a1.includes el
    sort = (arr=[])-> arr.sort() and arr

    parse = (text='')->
      text
      .split "\n"
      .filter (line)-> line.length
      .map (line)->
        line
        .split ' | '
        .map (put)->
          put
          .split ' '
          .map (digit)->
            sort digit.split ''

    mapDigits = (line)->
      # the easy digits
      one   = line.find (x)-> x.length is 2
      seven = line.find (x)-> x.length is 3
      four  = line.find (x)-> x.length is 4
      eight = line.find (x)-> x.length is 7

      [a] = difference seven, one

      # 9 is six segments and contains a 4
      [nine]  = line
                .filter (x)-> x.length is 6
                .filter (x)-> includes x, four

      # 6 is six segments and does not contain a 4 or a one
      [six]   = line
                .filter (x)-> x.length is 6
                .filter (x)-> not includes x, four
                .filter (x)-> not includes x, one

      # 3 is five segments and contains a 1
      [three] = line
                .filter (x)-> x.length is 5
                .filter (x)-> includes x, one

      # compute a bunch of segments...
      [g] = difference nine, four, [a]
      [e] = difference eight, nine
      [c] = difference eight, six
      [d] = difference three, one, [a], [g]
      [b] = difference nine, three

      # zero is just an 8 without the middle bit
      zero = difference eight, [d]

      # 5 is five segments and is contained in 6
      [five]  = line
                .filter (x)-> x.length is 5
                .filter (x)-> includes six, x

      [f] = difference eight, [a,b,c,d,e,g]

      two  = difference eight, [b,f]

      # return the stringified digits as an array
      [ zero, one, two, three, four, five, six, seven, eight, nine ]
      .map (d)-> d.join ''

    sumOutputs = (lines=[])->
      lines
      .map outputValue
      .map parseFloat
      .reduce (memo, val)-> memo + val

    outputValue = ([input, output])->
      digits = mapDigits input

      output
      .map (d)-> digits.indexOf d.join ''
      .reduce (memo, val)-> "#{memo}#{val}"


## Tests

    input = """
      be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
      edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
      fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
      fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
      aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
      fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
      dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
      bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
      egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
      gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
    """

    assert.equal 61229, sumOutputs parse input


## Run

    input = readFileSync './input', encoding: 'utf8'

    log sumOutputs parse input
