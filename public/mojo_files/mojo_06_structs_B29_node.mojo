struct Node[ElementType: ImplicitlyCopyable & Writable & Deinitable](
    Movable
):
    comptime NodePointer = Pointer[Self, MutUntrackedOrigin]
    var value: Optional[Self.ElementType]
    var next: Optional[Self.NodePointer]   # Optional = nullable

    @staticmethod
    def make_node(value: Self.ElementType) -> Self.NodePointer:
        var node_ptr = alloc[Self](1)        # 1. allocate space
        node_ptr.unsafe_write(Self(value))  # 2-3. init & move in
        return node_ptr                     # 4. return pointer

    def free_chain(self):
        var current = self.next
        while current:
            var cur_ptr = current.value()
            var next_node = cur_ptr[].next
            cur_ptr.unsafe_deinit_pointee()   # destroy value
            cur_ptr.unsafe_free()             # release memory
            current = next_node
