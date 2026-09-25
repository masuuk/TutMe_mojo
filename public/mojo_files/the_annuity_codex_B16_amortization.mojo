from std.math import pow

def amortization(pv: Float64, annual_rate: Float64, years: Int, freq: Int = 12):
    var r = annual_rate / Float64(freq)
    var n = years * freq
    var pmt = pv * r / (1.0 - pow(1.0 + r, -Float64(n)))
    var balance = pv
    for i in range(1, n + 1):
        var interest = balance * r
        var principal = pmt - interest
        balance -= principal
        print(i, pmt, interest, principal, balance)

def main():
    amortization(250000.0, 0.06, 30)
