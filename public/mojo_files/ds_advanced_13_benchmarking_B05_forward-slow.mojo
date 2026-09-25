from memory import ArenaAllocator, arena_scope

// Before: 1000 small allocations per forward pass
def forward_slow(x: Tensor[Float32]) -> Tensor[Float32]:
    var a = x[:, :d_model]       // alloc 1
    var b = self.W_q(a)          // alloc 2
    var c = self.W_k(a)          // alloc 3
    var d = b @ c.transpose()     // alloc 4
    var e = softmax(d)           // alloc 5
    return e @ self.W_v(a)       // alloc 6

// After: single arena allocation, freed at scope end
def forward_fast(x: Tensor[Float32]) -> Tensor[Float32]:
    with arena_scope():
        var a = x[:, :d_model]
        var b = self.W_q(a)
        var c = self.W_k(a)
        var d = b @ c.transpose()
        var e = softmax(d)
        return e @ self.W_v(a)
    // All temporaries freed here
