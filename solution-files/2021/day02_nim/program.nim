
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

if part == "part1":
    var position = 0
    var depth = 0

    for line in lines:
        let cells = split(line, " ")
        let direction = cells[0]
        let magnitude = parseInt(cells[1])

        case direction
        of "forward":
            position = position + magnitude
        of "up":
            depth = depth - magnitude
        of "down":
            depth = depth + magnitude

    echo position * depth

elif part == "part2":
    var position = 0
    var depth = 0
    var aim = 0

    for line in lines:
        let cells = split(line, " ")
        let direction = cells[0]
        let magnitude = parseInt(cells[1])

        case direction
        of "forward":
            position = position + magnitude
            depth = depth + (aim * magnitude)
        of "up":
            aim = aim - magnitude
        of "down":
            aim = aim + magnitude

    echo position * depth


