# constant by convention — declared once, never reassigned
var name = "Mojo"

# var — mutable binding
var counter = 0
counter += 1  # OK

# mut — pass-by-reference with mutation
def increment(mut x: Int):
    x += 1

var val = 10
increment(val)
print(val)  # 11
