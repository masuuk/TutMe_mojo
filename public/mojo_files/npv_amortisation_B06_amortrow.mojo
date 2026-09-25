from math import pow
from collections import List

struct AmortRow:
    var period: Int
    var payment: Float64
    var interest: Float64
    var principal: Float64
    var balance: Float64

def amortization_schedule(principal: Float64, annual_rate: Float64, years: Int) -> List[AmortRow]:
    var r = annual_rate / 12.0
    var n = years * 12
    var payment = principal * (r * pow(1.0 + r, Float64(n))) / (pow(1.0 + r, Float64(n)) - 1.0)
    var balance = principal
    var schedule = List[AmortRow]()
    for month in range(1, n + 1):
        var interest = balance * r
        var principal_paid = payment - interest
        balance -= principal_paid
        schedule.push_back(AmortRow(month, payment, interest, principal_paid, balance))
    return schedule
