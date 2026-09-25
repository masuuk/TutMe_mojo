@fieldwise_init
struct Matrix(Copyable):
    var rows: Int
    var cols: Int
    var data: List[Float64]

    def __getitem__(self, r: Int, c: Int) -> Float64:
        return self.data[r * self.cols + c]

    def __setitem__(mut self, r: Int, c: Int, value: Float64):
        self.data[r * self.cols + c] = value

    @staticmethod
    def zeros(rows: Int, cols: Int) -> Matrix:
        return Matrix(rows, cols, List[Float64](rows * cols, 0.0))

    @staticmethod
    def uniform(rows: Int, cols: Int, seed: UInt64 = 42, scale: Float64 = 1.0) -> Matrix:
        var rng = Prng(seed)
        var data = List[Float64]()
        for _ in range(rows * cols):
            data.append(rng.lower(scale))
        return Matrix(rows, cols, data)
