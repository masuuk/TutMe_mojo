def npv(rate: Float64, cash_flows: List[Float64]) -> Float64:
    var total = 0.0
    for i in range(cash_flows.len()):
        total += cash_flows[i] / (1.0 + rate) ** float(i)
    return total

def main():
    var flows = List[Float64](1000.0, 2000.0, 3000.0, 4000.0)
    var result = npv(0.08, flows)
    print("NPV: $", result)
    # NPV: $8012.25
