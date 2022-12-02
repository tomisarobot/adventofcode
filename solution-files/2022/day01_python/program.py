
import sys

def parse_lines(lines):
    groups = "@".join(lines).strip("@").split("@@")
    buckets = list(map(lambda x: x.split("@"), groups))
    numbers = list(map(lambda x: list(map(lambda y: int(y), x)), buckets))
    return numbers

def find_totals(numbers):
    totals = list(map(lambda x: sum(x), numbers))
    return totals

def find_top(numbers, count):
    totals = find_totals(numbers)
    totals.sort(reverse=True)
    return sum(totals[:count])

def example(lines):
    numbers = parse_lines(lines)
    top = find_top(numbers)
    print(max_)
    pass

def part1(lines):
    numbers = parse_lines(lines)
    top = find_top(numbers, 1)
    print(top)
    pass

def part2(lines):
    numbers = parse_lines(lines)
    top = find_top(numbers, 3)
    print(top)
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
    main(sys.argv[1:])
