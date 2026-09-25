from math import sqrt

def softmax_simd(mut logits: Tensor[Float32]):
    var n = logits.num_elements()
    # Find max for numerical stability
    var max_val: Float32 = logits[0]
    for i in range(1, n):
        if logits[i] > max_val:
            max_val = logits[i]

    # Vectorized exp using SIMD
    comptime S = simdwidthof[Float32]()
    var exp_sum: Float32 = 0.0
    var max_vec = SIMD[Float32, S](max_val)
    var i = 0
    while i + S <= n:
        var v = logits.load[0](i) - max_vec
        var ev = exp(v)
        logits.store(i, ev)
        exp_sum += ev.reduce_add()
        i += S
    # Scalar remainder
    while i < n:
        var e = exp(logits[i] - max_val)
        logits[i] = e
        exp_sum += e
        i += 1
    # Normalize
    var inv_sum = 1.0 / exp_sum
    i = 0
    while i + S <= n:
        logits.store(i, logits.load[0](i) * inv_sum)
        i += S
    while i < n:
        logits[i] *= inv_sum
        i += 1
