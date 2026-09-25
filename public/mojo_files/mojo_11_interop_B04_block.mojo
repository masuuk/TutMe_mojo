# Python.list() is mutable:
var py_list = Python.list("cat", 2, 3.14159, 4)
py_list.append(5)
py_list[0] = "aardvark"
print(py_list)   # ['aardvark', 2, 3.14159, 4, 5]

# Python.tuple() is immutable, but supports count():
var py_tuple = Python.tuple("cat", 2, 3.1415, "cat")
print("Number of cats:", py_tuple.count("cat"))   # 2
