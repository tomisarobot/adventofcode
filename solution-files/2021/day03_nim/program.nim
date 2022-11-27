
import std/algorithm
import std/bitops
import std/os
import std/parseopt
import std/sequtils
import std/strutils
import std/sugar
import std/math

assert paramCount() == 2

let path = paramStr(1)
let part = paramStr(2)

let content = strip(readFile(path))
let lines = splitLines(content)

let len = lines[0].len
let high = lines[0].high
var counts = newSeq[int](len)
for line in lines:
    for i in 0..high:
        if line[i] == '1':
            counts[i] = counts[i] + 1
let bits = counts.map(x => (if x < (lines.len / 2).int: 0 else: 1)).reversed()
let gamma = foldl(0..high, a + pow(2, b.float).int * bits[b], 0).uint
let epsilon = gamma.bitnot().bitsliced(0..high)

if part == "part1":
    echo gamma * epsilon

elif part == "part2":
    let nums = lines.map(x => parseInt(x).uint)
    echo nums



