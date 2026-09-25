# Nth-order differencing: each pass replaces the series with its first difference
def difference(data: List[Float64], order: Int) -> List[Float64]:
    var result = data
    for d in range(order):
        var temp = List[Float64]()
        for i in range(1, len(result)):
            temp.append(result[i] - result[i - 1])
        result = temp                  # each pass drops one observation
    return result

def main():
    var sales = load_sales_data()
    var diff1 = difference(sales, 1)   # 23 values
    var diff2 = difference(sales, 2)   # 22 values
    print("First differences:", diff1[0], diff1[1], diff1[2], diff1[3], diff1[4])
