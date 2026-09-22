# ============================================================================
#  Mojo 1.x program extracted from the TutMe🔥 tutorial site.
#
#  Source:  public/data_science/time_series_analytics.html
#  File:    time_series_analytics_feature_engineering_pure.mojo
#
#  Extracted verbatim from the page code block (see the tutorial for prose
#  that explains each part). Run with:   mojo time_series_analytics_feature_engineering_pure.mojo
# ============================================================================
# Feature engineering in pure Mojo.
# The lag matrix is stored flat (row-major): element [i, j] of the matrix
# lives at flat index i * max_lag + j.
def create_lag_features(data: List[Float64], max_lag: Int) -> List[Float64]:
    var n = len(data)
    var rows = n - max_lag
    var result = List[Float64]()
    for i in range(rows * max_lag):
        result.append(0.0)             # preallocate, then write below
    for i in range(max_lag, n):
        for lag in range(1, max_lag + 1):
            result[(i - max_lag) * max_lag + (lag - 1)] = data[i - lag]
    return result

# Rolling mean feature over a fixed window
def create_rolling_mean(data: List[Float64], window: Int) -> List[Float64]:
    var n = len(data)
    var result = List[Float64]()
    for i in range(window, n + 1):
        var sum: Float64 = 0.0
        for j in range(i - window, i):
            sum += data[j]
        result.append(sum / Float64(window))
    return result

def main():
    var sales = load_sales_data()
    var lags = create_lag_features(sales, 3)
    var roll_mean = create_rolling_mean(sales, 3)
    print("Lag features length:", len(lags))
    # first flat row (indexes 0..2) = data[2], data[1], data[0] (the three
    # values that precede the first fully-populated row)
    print("First lag row (lags 1,2,3):", lags[0], lags[1], lags[2])
