@fieldwise_init
struct FileError(Equatable, ImplicitlyCopyable, Writable):
    var _variant: Int

    comptime not_found = FileError(_variant=1)
    comptime permission_denied = FileError(_variant=2)
    comptime already_exists = FileError(_variant=3)

    # ...variant_name()/write_to() produce readable messages...

def open_file(path: String) raises FileError -> String:
    if not path:
        raise FileError.not_found
    if path == "/secret":
        raise FileError.permission_denied
    return "Contents of " + path
