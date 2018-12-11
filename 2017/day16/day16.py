#!/usr/bin/env python3
#
#  Advent of Code 2017 - Day 16
#

INPUTFILE = 'input.txt'

def sample_input():
    return ""

# Utility functions

def load_input(infile):
    lines = []
    with open(infile, 'r') as fp:
        for line in fp:
            line = line.strip()
            if line:
                lines.append(line)
        return lines

def split_nonblank_lines(text):
    lines = []
    for line in text.splitlines():
        line = line.strip()
        if line:
            lines.append(line)
    return lines

# Solution

class DanceLine():
    def __init__(self, size=16):
        self.size = size
        self.line = [chr(ord('a') + i) for i in range(size)]

    def __str__(self):
        return "".join(self.line)

    def move(self, desc):
        if desc.startswith('s'):
            nmove = int(desc[1:])
            self.line = self.line[-nmove:] + self.line[:-nmove]
        elif desc.startswith('x'):
            i, j = [int(v) for v in desc[1:].split('/')]
            self.line[i], self.line[j] = self.line[j], self.line[i]
        elif desc.startswith('p'):
            a, b = desc[1], desc[3]
            i, j = self.line.index(a), self.line.index(b)
            self.line[i], self.line[j] = b, a
        return self

    def repeat(self, lines, n):
        sequence = self.find_cycle(lines)
        self.line = [ch for ch in sequence[(n-1) % len(sequence)]]
        return self
    
    def find_cycle(self, lines):
        seen_at = set()
        sequence = []
        for i in range(1000000000):
            self.moves(lines)
            print(i, str(self))
            if str(self) in seen_at:
                return sequence
            seen_at.add(str(self))
            sequence.append(str(self))

    def moves(self, moves):
        for line in moves:
            self.move(line)
        return self

# PART 1

def example():
    text = """
s1
x3/4
pe/b
"""
    expected = "baedc"
    lines = split_nonblank_lines(text)
    result = str(DanceLine(5).moves(lines))
    print("result is '{}' (expected '{}')".format(result, expected))
    assert result == expected
    print('= ' * 32)

def part1(text):
    lines = text.split(',')
    result = DanceLine().moves(lines)
    print("result is {}".format(result))
    print('= ' * 32)


# PART 2

def example2():
    text = """
s1
x3/4
pe/b
"""
    expected = "ceadb"
    lines = split_nonblank_lines(text)
    dance_line = DanceLine(5).moves(lines)
    result = str(dance_line.repeat(lines, 1))
    print("result is '{}' (expected '{}')".format(result, expected))
    assert result == expected
    print('= ' * 32)

def part2(text):
    lines = text.split(',')
    count = 1000000000
    # dance_line = DanceLine()
    # for i in range(count):
    #     dance_line.moves(lines)
    # expected = str(dance_line)
    dance_line = DanceLine().repeat(lines, count)
    result = str(dance_line)
    expected = result
    print("result is '{}' (expected '{}')".format(result, expected))
    # assert result == expected
    print('= ' * 32)

if __name__ == '__main__':
    example()
    lines = load_input(INPUTFILE)
    part1(lines[0])
    example2()
    part2(lines[0])
