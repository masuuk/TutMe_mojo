def external_call[
    callee: StaticString,
    return_type: RegisterPassable,
    *types: AnyType,
    num_fixed_args: OptionalReg[Int] = None,
](*args: *types) -> return_type
