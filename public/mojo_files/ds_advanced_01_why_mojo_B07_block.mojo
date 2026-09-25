from std.python import Python, PythonObject
from std.python.numpy import copy_to_numpy_array

var np = Python.import_module("numpy")
var pytemps = copy_to_numpy_array(temps)   # zero-copy handoff
var std_dev = np.std(pytemps)
print("Temperature standard deviation:", std_dev)
