# Mojo — Tensor is parameterized by dtype
from tensor import Tensor

# 1D tensor of zeros
var t1 = Tensor[DType.float32](5)     # shape: (5,)

# 2D tensor (matrix) of zeros
var t2 = Tensor[DType.float32](3, 4)  # shape: (3, 4)

# 3D tensor (batch of images)
var t3 = Tensor[DType.float32](32, 224, 224)

# From a filled value
var ones = Tensor[DType.float32](1.0, 4, 4)

# From existing data
var data = Tensor[DType.float32](
    [1.0, 2.0, 3.0, 4.0,
     5.0, 6.0, 7.0, 8.0]
)
data = data.reshape(2, 4)

# Identity matrix
var eye = Tensor[DType.float32](eye=4)

# Random tensor
var rng = Tensor[DType.float32](random=True, 3, 3)

# BFloat16 for ML
var weights = Tensor[DType.bfloat16](512, 256)

# Inspect shape
print(data.shape)          # (2, 4)
print(data.num_elements()) # 8
