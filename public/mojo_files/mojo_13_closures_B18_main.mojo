def main():
    def make_adder(n: Int):
        def add(x: Int) {var n} -> Int:
            return x + n
        def twice(x: Int) {var add} -> Int:
            return add(add(x))
        print(twice(5))   # add(add(5)) = add(8) = 11
    make_adder(3)
