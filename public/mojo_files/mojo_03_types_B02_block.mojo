var float1 = 3.3          # float1 is type Float64
var float2: Float32 = 7.5
var int1 = 5              # int1 is type Int
var int2: Int8 = 4

# Compile-time: exact, arbitrary precision
var arbitrary_precision = 3.0 * (4.0 / 3.0 - 1.0)

# Force runtime evaluation with a variable: rounding appears
var three = 3.0
var finite_precision = three * (4.0 / three - 1.0)
print(arbitrary_precision, finite_precision)
# 1.0 0.99999999999999978
