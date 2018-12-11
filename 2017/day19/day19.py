#!/bin/env python 3
# AoC2017 Day 19

import numpy as np

with open("input.txt") as f:
    s = [list(x.strip()) for x in f.readlines()]

pos = [np.array([0,s[0].index("|")]),"s"]
print(s[0].index("|"))

print([2,7,6,5,55,5,5,5].index(55))

class Packet():
    def _init_(self,v,d):
        self.pos = np.array(v)
        self.dir = d
    
    def move