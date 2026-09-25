from math import exp

@differentiable
def vector_relu[N: Int](x: SIMD[float32, N]) -> SIMD[float32, N]:
    return max(x, 0.0)

@differentiable
def softmax[N: Int](x: SIMD[float32, N]) -> SIMD[float32, N]:
    var exp_x = exp(x)
    return exp_x / exp_x.reduce_add()

# grad computes the Jacobian for vector inputs
var inputs = SIMD[float32, 8](1.0, 2.0, 3.0, 0.0,
                        -1.0, 0.5, 4.0, -2.0)
var grad_relu = grad(vector_relu)
var grad_input = grad_relu(inputs)
# grad_input = SIMD[1,1,1,0,0,1,1,0]
