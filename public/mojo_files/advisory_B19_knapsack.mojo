def knapsack(values: List[Int],
             weights: List[Int],
             W: Int) -> Int:
    # dp[cap] = best value with budget 'cap'
    var dp = List[Int](W + 1, 0)
    for i in range(len(values)):
        var v = values[i]
        var w = weights[i]
        # right-to-left: keeps row i−1 intact
        @parameter
        for cap in range(W, w - 1, -1):
            dp[cap] = max(dp[cap],
                          v + dp[cap - w])
    return dp[W]
