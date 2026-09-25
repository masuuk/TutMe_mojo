from std.collections import StringDict

def sum_kwargs_ints(kwargs: StringDict[PythonObject]) raises -> PythonObject:
    var total = 0
    for entry in kwargs.items():
        total += Int(entry.value)
    return PythonObject(total)
