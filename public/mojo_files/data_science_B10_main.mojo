def main():
    var r: Float64 = 0.8
    var K: Float64 = 100.0
    var dt: Float64 = 0.01
    var y: Float64 = 5.0          # initial population

    for _ in range(2000):
        var dydt = r * y * (1.0 - y / K)
        y += dt * dydt               # Euler step

    print("plateau ≈", y)            # → 100.0, the carrying capacity
