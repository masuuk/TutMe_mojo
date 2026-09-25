# Origin inferred from caller:
def add_ref(ref a: Int, b: Int) -> Int:
    return a + b

# Named origin clause: ref[origin] — ties return to argument:
from std.collections import Span

def to_byte_span[
    is_mutable: Bool,
    //,
    origin: Origin[mut=is_mutable],
](ref[origin] list: List[Byte]) -> Span[Byte, origin]:
    return Span(list)
# span lives as long as list; mutable iff list is mutable
