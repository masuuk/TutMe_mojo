struct Pair[T: Movable](Writable):
    var first: Self.T
    var second: Self.T

    def __init__(out self, first: Self.T, second: Self.T):
        self.first = first^
        self.second = second^

    def write_to[W: Writer](self, mut writer: W):
        writer.write("(", self.first, ", ", self.second, ")")

def main():
    var p = Pair(1, 2)   # Pair[Int] inferred from the arguments
    print(p)
