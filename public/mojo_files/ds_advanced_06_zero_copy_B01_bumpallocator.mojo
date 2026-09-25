# Memory Arena — bump-allocate, bulk-free
from memory import Arena

struct BumpAllocator:
    var arena: Arena
    var offset: Int

    def __init__(out self, size: Int):
        self.arena = Arena(size)
        self.offset = 0

    def alloc(mut self, bytes: Int) -> Pointer:
        var ptr = Pointer(self.arena + self.offset)
        self.offset += bytes
        return ptr

    def reset(mut self):
        self.offset = 0  # O(1) bulk free

# Usage: process a full pipeline, then free everything at once
def pipeline(data: Tensor[Float32]) raises:
    var alloc = BumpAllocator(1024 * 1024 * 16)  # 16MB arena

    # Stage 1: allocate intermediates from arena
    var normalized = alloc.alloc(data.size * 4)
    normalize(data, normalized)

    # Stage 2: reuse same arena
    var features = alloc.alloc(data.size * 4)
    extract_features(normalized, features)

    # Stage 3: allocate output
    var result = alloc.alloc(1024 * 4)
    aggregate(features, result)

    # Everything freed at once — O(1)
    alloc.reset()
