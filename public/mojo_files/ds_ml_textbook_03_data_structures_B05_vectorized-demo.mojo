from tensor import Tensor

def vectorized_demo():
    var n = 1000

    # Create two tensors
    var a = Tensor[Float32](n)
    var b = Tensor[Float32](n)
    var result = Tensor[Float32](n)

    # Initialize
    for i in range(n):
        a[i] = Float32(i)
        b[i] = Float32(i) * 2.0

    # Element-wise addition — auto-vectorized
    result = a + b

    # Element-wise multiplication
    result = a * b

    # Scalar operations broadcast automatically
    result = a * 3.14 + 1.0

    print("result[0] =", result[0])
    print("result[999] =", result[999])
