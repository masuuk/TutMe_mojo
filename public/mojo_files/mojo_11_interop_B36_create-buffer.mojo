from std.ffi import external_call, c_size_t

def create_buffer(n: c_size_t) -> Optional[Pointer[UInt8, MutUntrackedOrigin]]:
    return external_call[
        "malloc", Optional[Pointer[UInt8, MutUntrackedOrigin]]
    ](n)

def main() raises:
    var buf = create_buffer(c_size_t(16))
    if not buf:
        raise Error("malloc failed")
    var ptr = buf.value()

    ptr[unsafe_offset=0] = 42
    print(ptr[unsafe_offset=0])

    external_call["free", NoneType](ptr.unsafe_bitcast[NoneType]())
