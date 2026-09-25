# Z-score: standard deviations away from the mean (used for anomalies)
def zscore(x: Float64,
           mean: Float64,
           std: Float64) -> Float64:
    return (x - mean) / std
