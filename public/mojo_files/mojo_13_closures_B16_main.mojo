def main():
    # The `Intable` trait supports `Int` conversion
    def double[T: Intable](x: T) {} -> Int:
        return Int(x) * 2
    print(double[Int](5))         # 10
    print(double[Float64](3.4))   # 6
