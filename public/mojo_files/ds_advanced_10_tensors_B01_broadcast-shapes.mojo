from tensor import Tensor, TensorSpec, TensorShape

def broadcast_shapes(a: TensorShape, b: TensorShape) raises -> TensorShape:
    // Align dimensions from the right
    var ndim = max(a.rank(), b.rank())
    var result = List[Int]()

    for i in range(ndim):
        var dim_a = 1 if i < a.rank() else a[i]
        var dim_b = 1 if i < b.rank() else b[i]

        if dim_a != dim_b and dim_a != 1 and dim_b != 1:
            raise "Cannot broadcast shapes"

        result.append(max(dim_a, dim_b))

    return TensorShape(result)


// Example: (3, 1) + (1, 4) -> (3, 4)
var a = Tensor[Float32](TensorShape(3, 1))
var b = Tensor[Float32](TensorShape(1, 4))
var c = a + b  // shape: (3, 4) -- broadcast automatically


// Reshape with compile-time dimensions
def flatten_batch[N: Int, C: Int, H: Int, W: Int](
    t: Tensor[Float32]
) -> Tensor[Float32]:
    return t.reshape(N, C * H * W)
