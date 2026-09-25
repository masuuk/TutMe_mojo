from math import pow
from collections import List

def npv(rate: Float64, cash_flows: List[Float64]) -> Float64:
    var total: Float64 = 0.0
    for t in range(len(cash_flows)):
        total += cash_flows[t] / pow(1.0 + rate, Float64(t))   # exponent must be a Float64
    return total

def main():
    var cf = List[Float64](-1000.0, 300.0, 400.0, 500.0, 600.0)
    print("NPV = ", npv(0.10, cf))     # NPV = 388.77
