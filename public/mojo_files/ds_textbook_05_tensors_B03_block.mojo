# Mojo — element-wise tensor operations
var a = Tensor[DType.float32]([1.0, 2.0, 3.0, 4.0])
var b = Tensor[DType.float32]([10.0, 20.0, 30.0, 40.0])

# Arithmetic
var c = a + b       # [11, 22, 33, 44]
var d = b - a       # [9, 18, 27, 36]
var e = a * b       # [10, 40, 90, 160]
var f = b / a       # [10, 10, 10, 10]

# Scalar broadcast
var g = a + 100    # [101, 102, 103, 104]
var h = a * 0.5    # [0.5, 1.0, 1.5, 2.0]

# Math functions
var j = sqrt(a)
var k = exp(a)
var l = log(b)
var m = tanh(a)

# Aggregations
var total = a.reduce_add()   # 10.0
var maximum = a.reduce_max() # 4.0

# In-place operations
a += b
a *= 2
