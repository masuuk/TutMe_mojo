def bubble_sort[
    T: ImplicitlyCopyable & Deinitable,
    F: def(T, T) -> Bool,   //
](compare_fn: F, mut values: List[T]):
    for end in reversed(range(len(values))):
        for i in range(end):
            if compare_fn(values[i], values[i + 1]):
                values[i], values[i + 1] = values[i + 1], values[i]

def main():
    var values: List[Int] = [3, 1, 4, 1, 5, 9]
    bubble_sort(lambda (a: Int, b: Int) -> Bool: a > b, values)
    print(values.__str__())
