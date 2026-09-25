struct CBuffer:
    var ptr: Pointer[UInt8, MutUntrackedOrigin]
    var size: c_size_t

    def __init__(out self, n: c_size_t) raises:
        self.size = n
        var allocated = external_call[
            "malloc", Optional[Pointer[UInt8, MutUntrackedOrigin]]
        ](n)
        if not allocated:
            raise Error("malloc failed")
        self.ptr = allocated.value()

    def __enter__(self) -> Pointer[UInt8, MutUntrackedOrigin]:
        return self.ptr

    def __exit__(self):
        external_call["free", NoneType](self.ptr.unsafe_bitcast[NoneType]())

def main() raises:
    with CBuffer(c_size_t(1024)) as buf:
        buf[unsafe_offset=0] = 42
        print(buf[unsafe_offset=0])   # 42
    # The buffer is freed here.
