from std.memory.alloc import alloc, dealloc

var allocation = alloc[Int](1)   # space for one Int (untracked origin)
var ptr = allocation.unsafe_ptr()
ptr.unsafe_write(42)              # initialize the memory
print(ptr[])                      # 42
dealloc(allocation^)              # free it — ptr now dangles!
