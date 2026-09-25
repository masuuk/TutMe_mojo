def npv(rate: Float64, cash_flows: List[Float64]) -> Float64:
    var total: Float64 = 0.0
    for t in range(len(cash_flows)):
        total += cash_flows[t] / (1.0 + rate) ** Float64(t)
    return total

def main():
    var flows: List[Float64] = [-1000.0, 300.0, 420.0, 680.0]
    var result = npv(0.08, flows)
    print("NPV =", result)
