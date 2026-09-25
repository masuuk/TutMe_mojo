from kernel import fused_kernel

// Write a custom fused kernel
@fused_kernel
def bias_gelu_fused(
    output: Tensor[Float32],
    input: Tensor[Float32],
    bias: Tensor[Float32]
):
    var idx = thread_idx_x() + block_idx_x() * block_dim_x()
    if idx < input.size:
        var val = input[idx] + bias[idx % bias.size]
        output[idx] = 0.5 * val * (1.0 + tanh(0.7978845608 * (val + 0.044715 * val ** 3)))

// 3x faster than separate bias + gelu kernels
