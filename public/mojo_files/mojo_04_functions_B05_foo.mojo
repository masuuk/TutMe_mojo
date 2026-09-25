def foo(value: Int):
    value += 1   # Error: expression must be mutable

def foo_mut(mut value: Int):
    value += 1   # Works — declared mutable with `mut`
