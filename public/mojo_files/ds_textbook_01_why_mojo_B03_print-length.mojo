def print_length(values: List[Float64]):
    # default convention: read-only borrow, no copy
    print("length =", len(values))

def main():
    var data = List[Float64](1.0, 2.0, 3.0)
    print_length(data)       # read-only, still usable below
    print(len(data))         # fine — ownership never left `main`
