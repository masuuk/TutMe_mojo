from std.ffi import external_call, c_char, c_int, c_size_t

def main():
    # int snprintf(char *buf, size_t size, const char *fmt, ...);
    # Three fixed arguments, so num_fixed_args=3.
    var buf = Array[c_char, 64](uninitialized=True)
    var written = external_call["snprintf", c_int, num_fixed_args=3](
        buf.unsafe_ptr(),
        c_size_t(64),
        "score: %d/%d".as_c_string_slice().unsafe_ptr(),
        c_int(7),
        c_int(10),
    )
    print(t"wrote {written}: {String(unsafe_from_utf8_ptr=buf.unsafe_ptr())}")
