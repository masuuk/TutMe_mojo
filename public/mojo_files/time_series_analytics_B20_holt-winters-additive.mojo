# Holt-Winters additive triple exponential smoothing, written from scratch
def holt_winters_additive(data: List[Float64], period: Int,
                          alpha: Float64, beta: Float64, gamma: Float64
                          ) -> List[Float64]:
    var n = len(data)
    var level = List[Float64]()
    var trend = List[Float64]()
    var seasonal = List[Float64]()
    var fitted = List[Float64]()
    for i in range(n):                 # preallocate for later indexed writes
        level.append(0.0)
        trend.append(0.0)
        seasonal.append(0.0)
        fitted.append(0.0)
    # initialize level and trend from the first two observations
    level[0] = data[0]
    trend[0] = data[1] - data[0]
    # initialize one seasonal index per position in the period
    for i in range(period):
        seasonal[i] = data[i] - level[0]
    for t in range(n):
        if t >= period:
            var prev_seasonal = seasonal[t - period]
            var prev_level = level[t - 1]
            var prev_trend = trend[t - 1]
            # the three smoothing equations: level, trend, seasonal
            level[t] = alpha * (data[t] - prev_seasonal) + (1.0 - alpha) * (prev_level + prev_trend)
            trend[t] = beta * (level[t] - prev_level) + (1.0 - beta) * prev_trend
            seasonal[t] = gamma * (data[t] - level[t]) + (1.0 - gamma) * prev_seasonal
            fitted[t] = level[t] + trend[t] + seasonal[t - period]
    return fitted

def main():
    var sales = load_sales_data()
    var fitted = holt_winters_additive(sales, 12, 0.3, 0.1, 0.1)
    print("Fitted values (M13-M18):", fitted[12], fitted[13], fitted[14],
          fitted[15], fitted[16], fitted[17])
