# Simple moving average implemented over List[Float64]
def sma(data: List[Float64], window: Int) -> List[Float64]:
    var n = len(data)
    var result = List[Float64]()              # will hold n - window + 1 values
    for i in range(window, n + 1):
        var sum: Float64 = 0.0
        for j in range(i - window, i):        # window ending at index i
            sum += data[j]
        result.append(sum / Float64(window))
    return result

def main():
    var sales = load_sales_data()
    var sma3 = sma(sales, 3)     # 22 values
    var sma6 = sma(sales, 6)     # 19 values
    var sma12 = sma(sales, 12)   # 13 values
    print("SMA(3) first:", sma3[0], sma3[1], sma3[2])
    print("SMA(6) first:", sma6[0])
    print("SMA(12) first:", sma12[0], sma12[1])
