def add_two(y: Int):
    # y += 2  # ERROR: y is immutable
    var z = y   # explicit copy
    z += 2
    print("z:", z)

def main():
    var x = 1
    add_two(x)
    print("x:", x)   # caller unaffected
