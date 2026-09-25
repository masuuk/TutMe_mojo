# 2) VGC-style bootstrap debias, 1-D newsvendor:
#    perturb the sample, re-solve, measure sensitivity.
def vgc_debias(samples: List[Float64],
                   c_u: Float64, c_o: Float64,
                   delta: Float64) -> Float64:
    var q0 = quantile(samples, c_u/(c_u+c_o))
    var n = len(samples)
    var bias: Float64 = 0.0
    for i in range(n):
        samples[i] += delta              # perturb one sample
        var q1 = quantile(samples, c_u/(c_u+c_o))
        samples[i] -= delta              # restore
        # dC/dZ_i ≈ Δobjective / Δsample; accumulate squared sensitivities
        bias += (cost(q1, samples[i], c_u, c_o)
               - cost(q0, samples[i], c_u, c_o)) ** 2
    return bias * delta / Float64(n) / 2.0

# debiased estimate = in-sample cost + vgc_debias(...)
