from time import now

def benchmark():
    var N = 1000000
    var A = Tensor[Float32](N)
    var B = Tensor[Float32](N)
    # Initialize with random data
    for i in range(N):
        A[i] = randn_float32()
        B[i] = randn_float32()

    # Time the dot product
    var start = now()
    var result = dot_product_simd(A, B)
    var elapsed = now() - start
    print("Result:", result)
    print("Time:", elapsed / 1e6, "ms")

# Use --baseline for statistical benchmarking
# mojo run --baseline bench.mojo
