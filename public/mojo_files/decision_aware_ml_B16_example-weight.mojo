def example_weight(p_severe: Float64,
                     c_fp: Float64, c_fn: Float64) -> Float64:
    return p_severe*c_fn + (1.0 - p_severe)*c_fp

# weights for 1M training rows: one compiled pass, shipped to the
# Python trainer as a NumPy array across the interop bridge.
