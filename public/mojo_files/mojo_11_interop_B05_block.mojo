# No Mojo literal for sets? Evaluate one:
var py_set = Python.evaluate('{2, 3, 2, 7, 11, 3}')
print(len(py_set), "items in the set.")   # 4 items in the set.

var contained = 7 in py_set
print("Is 7 in the set:", contained)       # True
