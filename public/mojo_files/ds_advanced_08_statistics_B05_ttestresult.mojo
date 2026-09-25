from math import sqrt, abs

struct TTestResult:
    var t_statistic: Float64
    var p_value: Float64
    var df: Int
    var significant: Bool


def one_sample_ttest(
    data: List[Float64],
    mu0: Float64,
    alpha: Float64 = 0.05
) -> TTestResult:
    var n = len(data)
    var x_bar = sum(data) / Float64(n)

    var ss = 0.0
    for x in data:
        ss += (x - x_bar) ** 2.0
    var s = sqrt(ss / Float64(n - 1))

    var t = (x_bar - mu0) / (s / sqrt(Float64(n)))

    // Approximate p-value using t-distribution
    var p = approximate_t_pvalue(abs(t), n - 1)

    return TTestResult(
        t_statistic=t,
        p_value=p * 2.0,  // two-tailed
        df=n - 1,
        significant=(p * 2.0) < alpha
    )


// Example: test if sample mean differs from 50
var data = List[Float64]()
for i in range(100):
    data.append(Normal(52.0, 10.0).sample())

var result = one_sample_ttest(data, 50.0)
print("t =", result.t_statistic)
print("p =", result.p_value)
print("significant:", result.significant)
