# AR(1) model: Y(t) = c + phi * Y(t-1) + eps(t), fitted by least squares
def fit_ar1(data: List[Float64]) -> Tuple[Float64, Float64]:
    var n = len(data)
    var sum_x: Float64 = 0.0
    var sum_y: Float64 = 0.0
    var sum_xy: Float64 = 0.0
    var sum_xx: Float64 = 0.0
    for i in range(1, n):
        var x = data[i - 1]           # lagged value
        var y = data[i]               # current value
        sum_x += x
        sum_y += y
        sum_xy += x * y
        sum_xx += x * x
    var count = Float64(n - 1)
    # slope (phi) and intercept (c) from the normal equations
    var phi = (count * sum_xy - sum_x * sum_y) / (count * sum_xx - sum_x * sum_x)
    var c = (sum_y - phi * sum_x) / count
    return (c, phi)

# Iterate the fitted recursion one step at a time into the future
def forecast_ar1(data: List[Float64], steps: Int) -> List[Float64]:
    var c, phi = fit_ar1(data)        # destructure the returned pair
    var last = data[len(data) - 1]
    var result = List[Float64]()
    var prev = last
    for i in range(steps):
        var next_val = c + phi * prev
        result.append(next_val)
        prev = next_val               # each step consumes the previous forecast
    return result

def main():
    var sales = load_sales_data()
    var c, phi = fit_ar1(sales)
    print("AR(1) model: c =", c, ", phi =", phi)
    var fc = forecast_ar1(sales, 6)
    print("6-step forecast:", fc[0], fc[1], fc[2], fc[3], fc[4], fc[5])
