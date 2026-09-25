var count = 3
var items = "apples"
var template = t"Give me {count} {items}."
print(template)            # Give me 3 apples.

var x = 41
print(t"The answer is {x + 1}")   # No allocation!

var list = [1, 2, 3]
print(t"{list[0] + list[1]}")      # 3 — arbitrary expressions OK

var name = "Nate"
var s = String(t"Hello, {name}!")  # Explicit allocation only here
