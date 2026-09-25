def inplace_transform[
    T: ImplicitlyCopyable & Deinitable,
    //, f: def(T) thin -> T   # compile-time function pointer
](mut list: List[T]):
    for index in range(len(list)):
        list[index] = f(list[index])

def main():
    var numbers: List[Int] = [1, 2, 3, 4, 5]
    inplace_transform[lambda (x: Int) -> Int: x * 2](numbers)
    print(numbers.__str__())

    # var factor = 3
    # inplace_transform[lambda (x: Int): x ** factor](numbers)
    # ERROR: capturing 'factor' makes this a closure — not allowed as a parameter
