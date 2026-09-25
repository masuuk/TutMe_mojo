# Z-score normalization: (x - mean) / std
def standardize(x: Float64,
                mean: Float64,
                std: Float64) -> Float64:
    return (x - mean) / std
