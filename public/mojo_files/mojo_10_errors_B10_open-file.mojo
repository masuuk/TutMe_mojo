from std.utils import Variant

# @fieldwise_init structs NotFoundError(path)
#   and PermissionError(path, required_role) defined here...

comptime FileError = Variant[NotFoundError, PermissionError]

def open_file(path: String) raises FileError -> String:
    if not path:
        raise FileError(NotFoundError(path))
    if path == "/secret":
        raise FileError(PermissionError(path, "admin"))
    return "Contents of " + path

try:
    print(open_file("/secret"))
except e:
    if e.isa[PermissionError]():
        print("Access denied:", e[PermissionError])
