# Everything before / is positional-only
def minimum(a: Int, b: Int, /) -> Int:
    return a if a < b else b
# min(1, 2) OK — min(a=1, b=2) NOT OK

# Everything after * is keyword-only
def kw_only(a1: Int, a2: Int, *, double: Bool) -> Int:
    var product = a1 * a2
    return product * 2 if double else product
