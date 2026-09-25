# Mirrors C div_t: two ints, 8 bytes total.
@fieldwise_init
struct DivT(RegisterPassable):
    var quot: c_int
    var rem: c_int

def main() raises:
    var proc = OwnedDLHandle()   # No path: opens the current process
    var div = proc.get_function[DivT]("div")
    var d = div(c_int(7), c_int(3))
    print(t"div(7, 3): quot {d.quot} rem {d.rem}")
