var s: String = "Testing"
s += " Mojo strings"
print(s)   # Testing Mojo strings

# Explicit conversion with String(...)
var s1 = "Items in list: " + String(5)
# Variadic construction — no per-value String() needed
var s2 = String("Items in list: ", 5)
