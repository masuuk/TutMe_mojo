def print_first[size: Int](l: Array[Int, size]) where size >= 1: ...

def print_first_two[size: Int](l: Array[Int, size]) where size >= 2:
    # Knowing `size >= 2` doesn't auto-prove the callee's exact proposition,
    # so introduce evidence explicitly:
    comptime assert size >= 1   # add `size >= 1` to the knowledge base
    print_first[size](l)         # now compiles
