from std.memory import Pointer

def use_pointer():
    var a = 10
    var ptr = Pointer(to=a)   # origin inferred from 'a'

# Derived origin ties a returned pointer's lifetime to self:
def as_ptr(mut self) -> Pointer[String, origin_of(self.o_ptr)]:
    return Pointer(to=self.o_ptr[])
