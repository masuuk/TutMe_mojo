# alias creates compile-time constants
comptime BATCH_SIZE = 64
comptime N_FEATURES = 784
comptime DTYPE = DType.float32

# Parameterized struct — one compilation per DType
struct Tensor[dt: DType, rows: Int, cols: Int]:
    var data: SIMD[dt, rows * cols]

    def matmul(self, other: Tensor[dt, cols, Int(1)])
            -> Tensor[dt, rows, Int(1)]:
        var result = Tensor[dt, rows, Int(1)]()
        for i in range(rows):
            var sum: SIMD[dt, 1] = 0.0
            for j in range(cols):
                sum += self.data[i * cols + j] * other.data[j]
            result.data[i] = sum
        return result

# Compile-time if for type-specific optimization
def fast_exp[T: DType](x: SIMD[T, 1]) -> SIMD[T, 1]:
    comptime:
        if T == DType.float32:
            return Intrinsic.exp_f32(x)
        elif T == DType.float64:
            return Intrinsic.exp_f64(x)
        else:
            return generic_exp(x)
