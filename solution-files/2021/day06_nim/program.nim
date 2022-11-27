
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


proc compute_generation(start_fish: seq, days: int): int =
    var fish = start_fish
    for i in 1..days:
        let born = foldl(fish, a + (if b == 0: 1 else: 0), 0)
        fish = fish
            .map(x => x - 1)
            .map(x => (if x < 0: 6 else: x))
        fish
            .add(repeat(8, born))
    return fish.len

proc lanternfish(days: int): int =
    var fish = lines[0]
        .split(",")
        .map(x => parseInt(x))
    compute_generation(fish, days)

if part == "part1":
    echo lanternfish(80)

if part == "part2":
    for i in 1..20:
        echo i, ": ", compute_generation(@[1], i)
    #echo lanternfish(256)


