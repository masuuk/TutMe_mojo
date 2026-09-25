# Extracted from tutorials on this site (source: praxis/drill_09.html)
# https://github.com/masuuk/TutMe/blob/main/tui/public/praxis/drill_09.html

def add(mut x: Int, y: Int):
    x += y               # mut: caller sees the change

def consume(var s: String):
    print(s)             # owned - may transfer/mutate freely

def double() -> Int:
    var c = 21
    ref r = c            # ref binding aliases c
    r *= 2
    return c             # 42

def main():
    var a = 1
    add(a, 2)            # a becomes 3 (mut)
    print(a)             # 3

    var s = String("owned value")
    consume(s^)          # s is transferred out
    # print(s)           # ERROR - no longer owned here

    var r = double()
    print(r)

    # origin_of(b) (ch07) is a compile-time helper for threading
    # lifetimes through signatures - not a printable runtime value.
