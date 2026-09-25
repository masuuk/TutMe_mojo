def my_pow(base: Int, exp: Int = 2) -> Int:
    return base ** exp

var x = my_pow(3)              # Uses default exp=2 → 9
var y = my_pow(exp=3, base=2)  # Keywords, any order → 8
