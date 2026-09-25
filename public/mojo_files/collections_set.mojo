# Extracted from tutorials on this site (source: praxis/drill_16.html)
# https://github.com/masuuk/TutMe/blob/main/tui/public/praxis/drill_16.html

from std.collections import Set

def compute() -> Int:
    return 5

def main():
    var name = "ada"
    print(t"Hello {name} · 1+1 = {1 + 1} · {{literal}}")

    if (n := compute()) > 0:
        print("computed", n)          # computed 5

    var squares = [x * x for x in range(10)]  # [0, 1, 4, ..., 81]
    for v in squares:                # print elements, not the List
        print(v, end=" ")
    print("")

    var evens_set = {x for x in squares if x % 2 == 0}  # {0, 4, 16, 36, 64}
    for v in evens_set:
        print(v, end=" ")
    print("")

    var sliced = squares[1:4]         # [1, 4, 9]
    for v in sliced:
        print(v, end=" ")
    print("")
