
import std/os
import std/parseopt
import std/sequtils
import std/strutils
import std/sugar

assert paramCount() == 2

let path = paramStr(1)
let part = paramStr(2)

let content = strip(readFile(path))
let lines = splitLines(content)

let nums = lines.map(x => parseInt(x))

proc part1Measure(i: int): int =
    return nums[i]

proc part2Measure(i: int): int =
    return nums[i] + nums[i+1] + nums[i+2]

proc countTo(n: int): iterator(): int =
  return iterator(): int =
    var i = 0
    while i <= n:
      yield i
      inc i

proc doMeasure(len: int, measure: (int) -> int): int =
    var total = 0
    var prev = measure(0)
    var i = 1
    while i < len:
        let curr = measure(i)
        if prev < curr:
            total = total + 1
        prev = curr
        i = i + 1
    return total

if part == "part1":
    echo doMeasure(nums.len, part1Measure)

elif part == "part2":
    echo doMeasure(nums.len - 2, part2Measure)



