# ============================================================================
#  Mojo 1.x program extracted from the TutMe🔥 tutorial site.
#
#  Source:  public/data_science/time_series_analytics.html
#  File:    time_series_analytics_manual_additive_decomposition.mojo
#
#  Extracted verbatim from the page code block (see the tutorial for prose
#  that explains each part). Run with:   mojo time_series_analytics_manual_additive_decomposition.mojo
# ============================================================================
# Manual additive decomposition:
#   trend    = centered moving average (of length `period`)
#   seasonal = average detrended value for each position inside the period
#   residual = data - trend - seasonal
def decompose_trend_seasonal(data: List[Float64], period: Int) -> Tuple[
    List[Float64], List[Float64], List[Float64]]:
    var n = len(data)
    var half = period # 2
    # Step 1: trend via centered moving average
    var trend = List[Float64]()
    var detrended = List[Float64]()
    var seasonal = List[Float64]()
    var residual = List[Float64]()
    for i in range(n):                  # preallocate with zeros for later writes
        trend.append(0.0)
        detrended.append(0.0)
        seasonal.append(0.0)
        residual.append(0.0)
    for i in range(half, n - half):
        var sum: Float64 = 0.0
        for j in range(i - half, i + half + 1):
            sum += data[j]
        trend[i] = sum / Float64(2 * half + 1)
    # Step 2: detrended series = data - trend
    for i in range(n):
        detrended[i] = data[i] - trend[i]
    # Step 3: seasonal component = average detrended value per period position
    for p in range(period):
        var sum: Float64 = 0.0
        var count = 0
        var i = p
        while i < n:                    # step by `period` with a while loop
            if trend[i] != 0.0:
                sum += detrended[i]
                count += 1
            i += period
        var avg = 0.0
        if count > 0:                   # avoid division by zero
            avg = sum / Float64(count)
        var k = p
        while k < n:
            seasonal[k] = avg
            k += period
    # Step 4: residual = data - trend - seasonal
    for i in range(n):
        residual[i] = data[i] - trend[i] - seasonal[i]
    return (trend, seasonal, residual)

def main():
    var sales = load_sales_data()
    var trend, seasonal, resid = decompose_trend_seasonal(sales, 12)
    print("Trend M1-M6:", trend[0], trend[1], trend[2], trend[3], trend[4], trend[5])
    print("Seasonal M1-M4:", seasonal[0], seasonal[1], seasonal[2], seasonal[3])
