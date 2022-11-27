
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

echo lines
