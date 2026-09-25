def read_file(path: String) raises -> String:
    if not path:
        raise "path cannot be empty"
    return "contents of " + path

# These two raises are equivalent:
#   raise Error("file not found")
#   raise "file not found"

def main() raises:
    print(read_file("data.txt"))
