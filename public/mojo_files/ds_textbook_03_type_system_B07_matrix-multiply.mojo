# Mojo — comptime values and parameters

# Compile-time constant
comptime PI: Float64 = 3.14159265358979
comptime BUFFER_SIZE = 1024

# comptime blocks run during compilation
comptime:
    print("This prints during compilation!")
    if sys.arch == "x86_64":
        alias SIMD_WIDTH = 8
    else:
        alias SIMD_WIDTH = 4

# comptime parameters in functions
def matrix_multiply[M: Int, N: Int, K: Int](
    A: TensorSpec[DType.float32, M, K],
    B: TensorSpec[DType.float32, K, N]
) -> Tensor[DType.float32, M, N]:
    # M, N, K are known at compile time
    # Compiler can unroll loops, pick optimal instructions
    ...

# comptime string manipulation
comptime msg = "Hello" + ", " + "World"  # resolved at compile time

# Conditional compilation
@parameter
if DType.float32.is_floating_point():
    alias default_dt = DType.float32
else:
    alias default_dt = DType.float64

# Compile-time loop unrolling
def unrolled_sum[N: Int](data: Tensor[DType.float32, N]) -> Float32:
    var total: Float32 = 0
    alias UNROLL = 4
    for i in range(0, N, UNROLL):
        for j in range(UNROLL):
            total += data[i + j]
    return total
