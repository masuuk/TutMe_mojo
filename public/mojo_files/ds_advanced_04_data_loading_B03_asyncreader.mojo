# Async file reading with double buffering
from sys.io import FileHandle
from collections import Dict

struct AsyncReader:
    var path: String
    var chunk_size: Int

    def __init__(out self, path: String, chunk_size: Int = 65536):
        self.path = path
        self.chunk_size = chunk_size

    def read_all(self) raises -> List[UInt8]:
        var f = FileHandle(self.path, "r")
        var result = List[UInt8]()
        while True:
            var chunk = f.read_bytes(self.chunk_size)
            if len(chunk) == 0:
                break
            for b in chunk:
                result.append(b)
        f.close()
        return result

# Parallel read + process pipeline
def pipeline_load(path: String) raises -> List[Float64]:
    var reader = AsyncReader(path)
    var raw = reader.read_all()

    # Parse float values from raw bytes
    var values = List[Float64]()
    var current = String()

    for byte in raw:
        if byte == 44 or byte == 10:  # comma or newline
            if len(current) > 0:
                values.append(atof(current))
            current = String()
        else:
            current += chr(byte)

    return values
