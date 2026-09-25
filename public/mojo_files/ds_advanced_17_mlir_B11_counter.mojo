struct Counter:
    """A counter with addition, backed by a raw MLIR index."""
    var _mlir_value: __mlir_type.index

    def __init__(out self):
        self._mlir_value = __mlir_attr.`0 : index`

    def __init__(out self, *, mlir_value: __mlir_type.index):
        self._mlir_value = mlir_value

    def increment(mut self):
        var one: __mlir_type.index = __mlir_attr.`1 : index`
        self._mlir_value = __mlir_op.`index.add`(self._mlir_value, one)

    def __add__(self, rhs: Counter) -> Counter:
        return Counter(mlir_value=__mlir_op.`index.add`(
            self._mlir_value, rhs._mlir_value))

    def value(self) -> Int:
        return Int(mlir_value=self._mlir_value)

def main():
    var a = Counter()
    a.increment()   # 1
    a.increment()   # 2
    var b = Counter()
    b.increment()   # 1
    var c = a + b
    print(c.value())   # 3
