#!/usr/bin/env python3

import sys
from typing import List

qwerty_order = "`1234567890-=~!@#$%^&*()_+qwertyuiop[]\\{}|asdfghjkl;':\"zxcvbnm,./<>? "


def qwerty_bubble_sort(arr: List[str]):
    # if i>j return True
    def should_swap(item1: str, item2: str):
        item1 = item1.lower()
        item2 = item2.lower()
        for i, c1 in enumerate(item1):
            # item1 is bigger than item2
            # as no letter is always smaller than some letter
            if i >= len(item2):
                return True
            c2 = item2[i]
            if c1 == c2:
                continue
            c1Pos = qwerty_order.index(c1)
            c2Pos = qwerty_order.index(c2)
            if c1Pos > c2Pos:
                return True
            else:
                return False
        return False

    is_sorted = False
    while not is_sorted:
        is_sorted = True
        for i in range(len(arr)-1):
            j = i + 1
            node_i = arr[i]
            node_j = arr[j]
            if should_swap(node_i, node_j):
                # swap them
                arr[i] = node_j
                arr[j] = node_i
                is_sorted = False


def main():
    data = sys.stdin.read()
    lines = data.splitlines()
    qwerty_bubble_sort(lines)
    for l in lines:
        print(l)


main()
