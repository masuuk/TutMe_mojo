# Simple exponential smoothing:
#   s[t] = alpha * x[t] + (1 - alpha) * s[t-1]
def exponential_smoothing(data: List[Float64], alpha: Float64) -> List[Float64]:
    var n = len(data)
    var result = List[Float64]()
    result.append(data[0])                    # seed with the first observation
    for i in range(1, n):
        result.append(alpha * data[i] + (1.0 - alpha) * result[i - 1])
    return result

def main():
    var sales = load_sales_data()
    var ses = exponential_smoothing(sales, 0.3)
    print("SES with alpha=0.3:", ses[0], ses[1], ses[2], ses[3], ses[4])
