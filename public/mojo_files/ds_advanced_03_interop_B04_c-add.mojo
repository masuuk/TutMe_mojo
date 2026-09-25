# Declare the external C functions
def c_add(a: Int32, b: Int32) -> Int32
    "libc_math".add

def c_sort(ptr: Pointer[Int32], length: Int32)
    "libc_math".sort_in_place

def main():
    # Call native functions directly
    var result = c_add(21, 21)
    print("C says:", result)  # 42

    # Pass Mojo pointers to native code
    var buf = Pointer[Int32].alloc(5)
    buf[0] = 5; buf[1] = 3; buf[2] = 1; buf[3] = 4; buf[4] = 2
    c_sort(buf, 5)
    print(buf[0], buf[1], buf[2], buf[3], buf[4])  # 1 2 3 4 5
    buf.free()
