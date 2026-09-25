# (3, 4) + (4,) → (3, 4) — vector broadcasts across rows
var matrix = Tensor[DType.float32](
    [1.0, 2.0, 3.0, 4.0,
     5.0, 6.0, 7.0, 8.0,
     9.0, 10.0, 11.0, 12.0]
).reshape(3, 4)

var bias = Tensor[DType.float32]([100.0, 200.0, 300.0, 400.0])

# Each row gets the bias added
var result = matrix + bias
# [[101, 202, 303, 404],
#  [105, 206, 307, 408],
#  [109, 210, 311, 412]]

# (3, 1) + (1, 4) → (3, 4) — outer expansion
var col = Tensor[DType.float32]([1.0, 2.0, 3.0]).reshape(3, 1)
var row = Tensor[DType.float32]([10.0, 20.0, 30.0, 40.0]).reshape(1, 4)
var product = col + row  # (3, 4)
