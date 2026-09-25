def npv(rate: Float64, cashflows: List[Float64]) -> Float64:
    var total: Float64 = 0.0
    for i in range(len(cashflows)):
        total += cashflows[i] / pow(1.0 + rate, Float64(i))
    return total

def main():
    var flows = List[Float64](-1000.0, 300.0, 420.0, 680.0)
    var result = npv(0.10, flows)
    print("NPV = $", result)
