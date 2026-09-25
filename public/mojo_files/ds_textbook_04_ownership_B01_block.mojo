# Mojo — values have a single owner
var a = [1, 2, 3]   # a owns the list
var b = a              # COMPILE ERROR — can't copy implicitly
var c = a^             # OK — moves ownership from a to c
# a is now invalid — can't use it
print(c)                # [1, 2, 3]

# Explicit copy when you need both
var d = [4, 5, 6]
var e = d.copy()       # deep copy — both d and e own their data
d.append(7)            # only affects d
print(e)                # [4, 5, 6] — unchanged
