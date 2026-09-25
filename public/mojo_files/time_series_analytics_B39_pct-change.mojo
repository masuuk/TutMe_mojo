# Percentage change between two consecutive values
def pct_change(current: Float64,
               previous: Float64) -> Float64:
    return (current - previous) / previous
