# Part 2

Now that you have the structure of your transmission decoded, you can calculate the value of the expression it represents.

Literal values (type ID `4`) represent a single number as described above. The remaining type IDs are more interesting:

- Packets with type ID `0` are sum packets - their value is the sum of the values of their sub-packets. If they only have a single sub-packet, their value is the value of the sub-packet.
- Packets with type ID `1` are product packets - their value is the result of multiplying together the values of their sub-packets. If they only have a single sub-packet, their value is the value of the sub-packet.
- Packets with type ID `2` are minimum packets - their value is the minimum of the values of their sub-packets.
- Packets with type ID `3` are maximum packets - their value is the maximum of the values of their sub-packets.
- Packets with type ID `5` are greater than packets - their value is 1 if the value of the first sub-packet is greater than the value of the second sub-packet; otherwise, their value is 0. These packets always have exactly two sub-packets.
- Packets with type ID `6` are less than packets - their value is 1 if the value of the first sub-packet is less than the value of the second sub-packet; otherwise, their value is 0. These packets always have exactly two sub-packets.
- Packets with type ID `7` are equal to packets - their value is 1 if the value of the first sub-packet is equal to the value of the second sub-packet; otherwise, their value is 0. These packets always have exactly two sub-packets.

Using these rules, you can now work out the value of the outermost packet in your BITS transmission.

For example:

- `C200B40A82` finds the sum of 1 and 2, resulting in the value 3.
- `04005AC33890` finds the product of 6 and 9, resulting in the value 54.
- `880086C3E88112` finds the minimum of 7, 8, and 9, resulting in the value 7.
- `CE00C43D881120` finds the maximum of 7, 8, and 9, resulting in the value 9.
- `D8005AC2A8F0` produces 1, because 5 is less than 15.
- `F600BC2D8F` produces 0, because 5 is not greater than 15.
- `9C005AC2F8F0` produces 0, because 5 is not equal to 15.
- `9C0141080250320F1802104A08` produces 1, because 1 + 3 = 2 * 2.

What do you get if you evaluate the expression represented by your hexadecimal-encoded BITS transmission?


## Defs

    { log } = console
    assert  = require 'assert'
    { readFileSync } = require 'fs'

    hexToBin = (hex='')->
      hex
      .split ''
      .map (x)->
        parseInt x, 16
        .toString 2
      .map (s)->
        '0000'.substr(s.length) + s
      .join ''

    binToDec = (bin='')->
      parseInt bin, 2

    consume = (str='', chars=1, transform)->
      val = str[0...chars]
      rest = str[chars...]
      val = transform val if transform
      [ val, rest ]

    parse = (hex='')->
      [p, s] = parsePacket hexToBin hex
      p

    parseLiteral = (s='')->
      val = ''
      loop
        [chunk, s] = consume s, 5
        [more, bin] = consume chunk, 1, binToDec
        val += bin
        break unless more
      [binToDec(val), s]

    parsePacket = (s='', p={})->
      [p.version, s] = consume s, 3, binToDec
      [p.type, s] = consume s, 3, binToDec
      p.packets = []

      # parse packets
      switch p.type
        when 4 # literal
          [p.value, s] = parseLiteral s
        else # 6, 3 # operator
          [p.length_type_id, s] = consume s, 1, binToDec
          switch p.length_type_id
            when 0 # number of bits
              [length_of_bits, s] = consume s, 15, binToDec
              [packet_data, s] = consume s, length_of_bits
              while parseFloat packet_data
                [packet, packet_data] = parsePacket packet_data
                p.packets.push packet
            when 1 # number of packets
              [num_packets, s] = consume s, 11, binToDec
              for x in [0...num_packets]
                [packet, s] = parsePacket s
                p.packets.push packet

      # compute operator values
      switch p.type
        when 0 # sum
          p.value = \
          p.packets
          .reduce (memo, p)->
            memo + p.value
          , 0
        when 1 # product
          p.value = \
          p.packets
          .reduce (memo, p)->
            memo * p.value
          , 1
        when 2 # minimum
          p.value = \
          p.packets
          .reduce (memo, p)->
            Math.min memo, p.value
          , Infinity
        when 3 # maximum
          p.value = \
          p.packets
          .reduce (memo, p)->
            Math.max memo, p.value
          , 0
        when 5 # greater than
          p.value = \
          if p.packets[0].value > p.packets[1].value then 1 else 0
        when 6 # less than
          p.value = \
          if p.packets[0].value < p.packets[1].value then 1 else 0
        when 7 # equal
          p.value = \
          if p.packets[0].value == p.packets[1].value then 1 else 0

      [p, s]

    versionSum = (p={})->
      p.version +
      p
      .packets
      .map versionSum
      .reduce (memo, val)->
        memo + parseFloat val
      , 0

    valueOf = (p={})-> p.value


## Tests

    assert.equal 3,   valueOf parse 'C200B40A82'
    assert.equal 54,  valueOf parse '04005AC33890'
    assert.equal 7,   valueOf parse '880086C3E88112'
    assert.equal 9,   valueOf parse 'CE00C43D881120'
    assert.equal 1,   valueOf parse 'D8005AC2A8F0'
    assert.equal 0,   valueOf parse 'F600BC2D8F'
    assert.equal 0,   valueOf parse '9C005AC2F8F0'
    assert.equal 1,   valueOf parse '9C0141080250320F1802104A08'


## Run

    input = readFileSync './input', encoding: 'utf8'

    log valueOf parse input
