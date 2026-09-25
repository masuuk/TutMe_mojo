# Mojo — comptime generates specialized code

# Compile-time loop unrolling
def dot_product[N: Int](a: SIMD[float32, N],
                          b: SIMD[float32, N]) -> Float32:
    var result: Float32 = 0.0
    comptime:
        for i in range(N):
            result += a[i] * b[i]
    return result

# Compile-time type dispatch
def to_string[T: DType](val: SIMD[T, 1]) -> String:
    comptime:
        if T == DType.float32:
            return f"Float32({val})"
        elif T == DType.int32:
            return f"Int32({val})"
        else:
            return f"Unknown({val})"

# Compile-time table generation
struct LookupTable[N: Int]:
    var values: SIMD[float64, N]

    def __init__(out self):
        comptime:
            var table = SIMD[float64, N]()
            for i in range(N):
                table[i] = Float64(i) * 0.1
            self.values = table

var lut4 = LookupTable[4]()
var lut16 = LookupTable[16]()
# lut4.values is literally [0.0, 0.1, 0.2, 0.3]
# lut16 is [0.0, 0.1, ..., 1.5] computed at compile time
