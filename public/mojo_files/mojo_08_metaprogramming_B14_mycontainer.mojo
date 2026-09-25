# Conditional trait conformance:
# MyContainer is Copyable only when its elements are.
struct MyContainer[T: AnyType](
    Copyable where conforms_to(T, Copyable)
): ...
