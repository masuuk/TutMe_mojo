def foo(x: PythonObject, y: PythonObject, z: PythonObject) -> PythonObject:
    x[y] = Python.int(z)
    x = y + z
