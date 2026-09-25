# Extracted from tutorials on this site (source: operations_research.html #26)
# https://github.com/masuuk/TutMe/blob/main/tui/public/applications/operations_research/operations_research.html

from std.random import random_float64, seed
from std.math import log

def expovariate(rate: Float64) -> Float64:
    return -log(1.0 - random_float64(0.0, 1.0)) / rate

def sim_mm1(lam: Float64, mu: Float64, hours: Float64) -> Float64:
    var t: Float64 = 0.0
    var busy_until: Float64 = 0.0
    var n_served = 0
    var total_wait: Float64 = 0.0
    var arrival = expovariate(lam)
    while t < hours:
        t = arrival
        var service = expovariate(mu)
        if t >= busy_until:          # server idle — no wait
            busy_until = t + service
        else:                        # customer waits
            total_wait += busy_until - t
            busy_until += service
        n_served += 1
        arrival = t + expovariate(lam)
    return total_wait / Float64(n_served)

def main():
    seed(42)
    print(sim_mm1(6.0, 8.0, 2000.0))  # ~0.375 h — converges to Wq
