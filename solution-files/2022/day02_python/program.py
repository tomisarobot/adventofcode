
import sys

scores = {
    "A": 1, "X": 1, # rock
    "B": 2, "Y": 2, # paper
    "C": 3, "Z": 3  # scissor
}

outcomes1 = {
    "AX": 3, "BY": 3, "CZ": 3,
    "AY": 6, "BZ": 6, "CX": 6,
    "AZ": 0, "BX": 0, "CY": 0
}

outcomes2 = {
    # rock   paper   scissor
    "AX": 3, "BX": 1, "CX": 2, # lose
    "AY": 4, "BY": 5, "CY": 6, # draw
    "AZ": 8, "BZ": 9, "CZ": 7  # win
}

def calc1(them, us):
    score = scores[us]
    outcome = outcomes1[them + us]
    return score + outcome

def calc2(them, us):
    outcome = outcomes2[them + us]
    return outcome

def simulate(plays):
    scores = list(map(lambda x: calc1(x[0], x[1]), plays))
    return sum(scores)

def simulate2(plays):
    scores = list(map(lambda x: calc2(x[0], x[1]), plays))
    return sum(scores)


def parse(lines):
    plays = list(map(lambda x: x.split(" "), lines))
    return plays

def example(lines):
    print(simulate(parse(lines)))
    print(simulate2(parse(lines)))
    pass

def part1(lines):
    print(simulate(parse(lines)))
    pass

def part2(lines):
    print(simulate2(parse(lines)))
    pass

def parse_file(file):
    with open(file) as fd:
        text = fd.read().strip()
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
