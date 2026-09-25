from std.ffi import external_call, c_char, c_size_t

def main() raises:
    # char *getcwd(char *buf, size_t size);
    comptime CAPACITY = 256
    var buf = Array[c_char, CAPACITY](uninitialized=True)

    var filled = external_call[
        "getcwd", Optional[Pointer[c_char, origin_of(buf)]]
    ](buf.unsafe_ptr(), c_size_t(CAPACITY))
    if not filled:
        raise Error("getcwd failed")

    # C reports no length, so ask for it, then wrap in a Span:
    var length = external_call["strlen", c_size_t](buf.unsafe_ptr())
    var span = Span(
        unsafe_ptr=buf.unsafe_ptr().unsafe_bitcast[Byte](),
        length=Int(length),
    )
    print(t"{len(span)} bytes: {String(from_utf8=span)}")
