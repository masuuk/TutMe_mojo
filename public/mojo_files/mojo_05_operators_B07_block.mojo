from std.math import isclose

var total: Float64 = 0.0
for _ in range(10):
    total += 0.1

print(total == 1.0)       # False!
print(isclose(total, 1.0)) # True
