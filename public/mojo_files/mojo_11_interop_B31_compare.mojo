from std.ffi import external_call, c_int, c_size_t
from std.sys import size_of

def compare(
    a: OpaquePointer[mut=False, _],
    b: OpaquePointer[mut=False, _],
) abi("C") -> c_int:
    var a_value = a.unsafe_bitcast[c_int]()[]
    var b_value = b.unsafe_bitcast[c_int][]
    # Compare values, don't subtract them — large differences
    # overflow and produce the wrong sort order.
    if a_value < b_value:
        return c_int(-1)
    return c_int(a_value > b_value)

def main() raises:
    var numbers: List[c_int] = [5, 2, 9, 1, 5, 6]
    external_call["qsort", NoneType](
        numbers.unsafe_ptr(),
        c_size_t(len(numbers)),
        c_size_t(size_of[c_int]()),
        compare,
    )
    print("Sorted numbers:", numbers)
