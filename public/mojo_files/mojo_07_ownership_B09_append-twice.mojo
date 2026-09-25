def append_twice(mut s: String, other: String):
    s += other
    s += other

var my_string = "o"
append_twice(my_string, my_string)
# ERROR: passing 'my_string' mut is invalid since it's
# also passed as an immutable reference
