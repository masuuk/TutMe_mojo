from std.python.numpy import from_numpy_array, copy_to_numpy_array

var np = Python.import_module("numpy")
var py_array = np.arange(1_000_000, dtype=np.float32)
var view = from_numpy_array(py_array)   # Span[Float32], zero-copy
var fresh = copy_to_numpy_array(view)      # independent NumPy array
