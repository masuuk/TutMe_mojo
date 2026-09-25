var count = 0
var ptr = Pointer(to=count)   # point at an owned value

ptr[] += 100                 # dereference-write
print(ptr[])                  # dereference-read → 100
