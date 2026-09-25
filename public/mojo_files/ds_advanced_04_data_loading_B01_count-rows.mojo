# Stream-parse a large CSV without loading it all into memory
from sys.io import FileHandle

def count_rows(path: String) raises -> Int:
    var f = FileHandle(path, "r")
    var count = 0
    var buffer = String()

    while True:
        var chunk = f.read(8192)
        if chunk == "":
            break
        buffer += chunk
        while "\n" in buffer:
            buffer = buffer.split("\n", 1)[1]
            count += 1

    f.close()
    return count

# Process chunks lazily
def process_csv(path: String) raises:
    var f = FileHandle(path, "r")
    var row_idx = 0

    for line in f:
        var fields = line.split(",")
        # Process each row immediately
        if Float64(fields[3]) > 100.0:
            print("Row", row_idx, ": high value")
        row_idx += 1

    f.close()
