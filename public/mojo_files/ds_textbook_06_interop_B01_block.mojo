# Mojo — call Python directly
from python import Python

# Import any Python module
var os = Python.import_module("os")
var sys = Python.import_module("sys")
print(os.getcwd())           # works!
print(sys.version)           # Python version string

# Call Python functions
var math = Python.import_module("math")
var pi = math.pi
var root = math.sqrt(144.0)
print(root)                  # 12.0

# Use Python's json module
var json = Python.import_module("json")
var data = json.loads('{"name": "Mojo", "version": 1}')
print(data["name"])        # Mojo

# Python exceptions become Mojo errors
try:
    var result = json.loads("not json")
except e:
    print(f"Python error: {e}")
