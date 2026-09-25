# Mojo — export functions for Python
from python import Python
from python import PythonObject

# Define a fast function
def fast_normalize(
    data: Tensor[DType.float32]
) -> Tensor[DType.float32]:
    var mean = data.reduce_add() / Float32(data.num_elements())
    var result = data - mean
    var std = sqrt((result * result).reduce_add()
                  / Float32(data.num_elements()))
    return result / std

# Mojo can also expose a Python module
def register():
    var mojo_module = Python.import_module("mojo_fast")
    mojo_module.normalize = fast_normalize
