# Mojo — type conversions at the boundary
var np = Python.import_module("numpy")

# NumPy array → Mojo Tensor (shares memory!)
var py_array = np.array([1.0, 2.0, 3.0], dtype=np.float32)
var tensor = Tensor[DType.float32](py_array)

# Mojo Tensor → NumPy array
var mojo_tensor = Tensor[DType.float32]([4.0, 5.0, 6.0])
var back_to_python = mojo_tensor.to_numpy()

# PythonObject for opaque handles
var pd = Python.import_module("pandas")
var df: PythonObject = pd.read_csv("data.csv")
var shape = df.shape  # Python tuple, access as PythonObject
print(shape[0], shape[1])

# Passing lists across the boundary
var py_list = Python.list()
py_list.append(42)
py_list.append("hello")
print(Python.len(py_list))  # 2
