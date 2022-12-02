
import sys

def example(lines):
    # TODO
    pass

def part1(lines):
    # TODO
    pass

def part2(lines):
    # TODO
    pass

def parse_file(file):
    with open(file) as fd:
        text = fd.read()
    lines = text.split("\n")
    return lines

def main(argv):
    file = argv[0]
    part = argv[1]
    lines = parse_file(file)
    if part == "example":
        example(lines)
    elif part == "part1":
        part1(lines)
    elif part == "part2":
        part2(lines)

if __name__ == "__main__":
    main(sys.args[1:])
