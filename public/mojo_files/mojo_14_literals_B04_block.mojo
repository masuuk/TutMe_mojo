var name = "World"
var greeting = t"Hello, {name}!"     # "Hello, World!"
var result = t"1 + 1 = {1 + 1}"       # "1 + 1 = 2"
print(greeting)

# A t-string is its own type; cast to use it as a String
var greeting_str = String(greeting)

# Literal braces: {{ and }}
print(t"Use {{braces}} in t-strings")   # Use {braces} in t-strings
