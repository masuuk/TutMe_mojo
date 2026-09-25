var x = 5
print(1 < x < 10)        # True — 1 < x and x < 10
print(1 < x <= 5 < 9)    # True

var items = [1, 2, 3, 4, 5]
var ok = 0 < len(items) <= 10   # len() called once
print(ok)                 # True
