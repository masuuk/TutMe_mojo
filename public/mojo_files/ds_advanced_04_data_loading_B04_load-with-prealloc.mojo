# Pre-allocate a fixed buffer for zero-allocation parsing
def load_with_prealloc(path: String, expected_rows: Int) raises -> Tensor[Float32]:
    # Allocate the exact amount of memory upfront
    var t = Tensor[Float32](expected_rows)
    var f = FileHandle(path, "r")

    var idx = 0
    var buffer = String()

    while True:
        var line = f.readline()
        if len(line) == 0:
            break

        # Direct write into tensor — no intermediate allocation
        t[idx] = atof(line.strip())
        idx += 1

    f.close()

    # Free unused portion if we read fewer rows than expected
    if idx < expected_rows:
        return t[:idx]  # slice to actual size
    return t

# Memory-mapped file access
def mmap_read(path: String):
    # Map file into virtual address space
    # OS loads pages on-demand — no upfront copy
    var f = FileHandle(path, "r")
    var mapped = f.mmap()
    f.close()

    # Access bytes lazily — OS handles page faults
    for i in range(0, len(mapped), 4096):
        var page = mapped[i:i+4096]
        process_page(page)
