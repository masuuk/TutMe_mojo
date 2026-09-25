# Mojo — explicit numeric types
var a: Int = 42
var b: Float32 = 3.14
var c: Float64 = 2.718281828
var d: BFloat16 = 1.5

# Type conversions are explicit
var widened: Float64 = Float64(b)
var truncated: Int = Int(c)  # 2 — truncates

# Overflow is a compile-time or runtime error
var big: UInt8 = 255
# var over: UInt8 = big + 1  # runtime error in debug mode

# BFloat16 for ML inference
var weight: BFloat16 = 0.75
print(f"Weight type: {typeof(weight)}")
