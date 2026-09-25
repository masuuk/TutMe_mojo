def show_type[T: AnyType]():
    comptime type_name = reflect[T].name()
    comptime field_count = reflect[T].field_count()
    comptime field_names = reflect[T].field_names()
    comptime field_types = reflect[T].field_types()

    print("struct", type_name)
    comptime for idx in range(field_count):
        comptime field_type = reflect[field_types[idx]].name()
        var intro = "├──" if idx < (field_count - 1) else "└──"
        print(intro, " var ", field_names[idx], ": ", field_type)

@fieldwise_init
struct MyStruct:
    var x: String
    var y: Optional[Int]

def main():
    show_type[MyStruct]()
