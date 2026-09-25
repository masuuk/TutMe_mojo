from std.python import Python

def main() raises:
    var py_dict = Python.dict()
    py_dict["item_name"] = "whizbang"
    py_dict["price"] = 11.75
    py_dict["inventory"] = 100
    print(py_dict)
