def sum_args(py_self: PythonObject, args_tuple: PythonObject) raises:
    var total = args_tuple[0]
    for i in range(1, len(args_tuple)):
        total += args_tuple[i]
    return total

# registered with: b.def_py_function[sum_args]("sum_args")
