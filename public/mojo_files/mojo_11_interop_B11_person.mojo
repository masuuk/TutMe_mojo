@fieldwise_init
struct Person(Movable, Writable):
    var name: String
    var age: Int

    @staticmethod
    def py_init(out self: Person, args: PythonObject, kwargs: PythonObject) raises:
        if len(args) != 2:
            raise Error("Person() takes exactly 2 arguments")
        var name = String(args[0])
        var age = Int(args[1])
        self = Self(name, age)

    @staticmethod
    def get_name(py_self: PythonObject) raises -> PythonObject:
        var self_ptr = py_self.downcast_value_ptr[Self]()
        return self_ptr[].name

    @staticmethod
    def set_age(self_ptr: Pointer[mut=True, Self], new_age: PythonObject) raises:
        self_ptr[].age = Int(new_age)

    def write_to(self, mut writer: Some[Writer]):
        t"Person({self.name}, {self.age})".write_to(writer)

@export
def PyInit_mojo_module() abi("C") -> PythonObject:
    try:
        var mb = PythonModuleBuilder("mojo_module")
        _ = mb.add_type[Person]("Person")
            .def_py_init[Person.py_init]("__init__")
            .def_method[Person.get_name]("get_name")
            .def_method[Person.set_age]("set_age")
        return mb.finalize()
    except e:
        abort("error creating Mojo module")
