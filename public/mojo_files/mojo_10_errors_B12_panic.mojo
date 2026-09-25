# Always raises, never returns:
def panic(msg: String) raises -> Never:
    raise Error(msg)

def get_value_or_panic(maybe: Optional[Int]) raises -> Int:
    if maybe:
        return maybe.value()
    panic("value is missing")   # Never substitutes for Int here
