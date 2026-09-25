def diff_fields[T: AnyType](a: T, b: T) -> List[String]:
    comptime names = reflect[T].field_names()
    comptime types = reflect[T].field_types()
    var diffs = List[String]()

    comptime for idx in range(reflect[T].field_count()):
        comptime if conforms_to(types[idx], Equatable):
            ref a_val = reflect[T].field_ref[idx](a)
            ref b_val = reflect[T].field_ref[idx](b)
            if a_val != b_val:
                diffs.append(String(comptime (names[idx])))
    return diffs^

@fieldwise_init
struct Config(Equatable):
    var host: String
    var port: Int
    var verbose: Bool

def main():
    var old = Config("localhost", 8080, False)
    var new = Config("localhost", 9090, True)
    for name in diff_fields(old, new):
        print("changed:", name)
