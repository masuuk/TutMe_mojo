# Reading binary formats with zero-copy
from sys.io import FileHandle

# Binary tensor format: [num_elements: u32][data: f32 * N]
def read_binary_tensor(path: String) raises -> Tensor[Float32]:
    var f = FileHandle(path, "rb")

    # Read header (4 bytes for element count)
    var header = f.read_bytes(4)
    var n = header[0] | (header[1] << 8) | (header[2] << 16) | (header[3] << 24)

    # Read raw float data directly into tensor
    var tensor = Tensor[Float32](n)
    var raw = f.read_bytes(n * 4)
    f.close()

    # Zero-copy reinterpret
    for i in range(n):
        tensor[i] = bitcast[Float32, Int32](
            raw[i*4] | (raw[i*4+1] << 8) |
            (raw[i*4+2] << 16) | (raw[i*4+3] << 24)
        )

    return tensor

# Format detection by magic bytes
def detect_format(path: String) raises -> String:
    var f = FileHandle(path, "rb")
    var magic = f.read_bytes(4)
    f.close()

    if magic[0] == 0x50 and magic[1] == 0x41:  # "PA"
        return "parquet"
    elif magic[0] == 0x1F and magic[1] == 0x8B:
        return "gzip"
    else:
        return "unknown"
