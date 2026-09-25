def heavy_calculation() -> Int:
    var sum = 0
    for i in range(1_000_000):
        sum += i
    return sum

# var x = comptime heavy_calculation()   # Error: requires parentheses
var x = comptime (heavy_calculation())  # O(1) at runtime
print(x)   # 499999500000
