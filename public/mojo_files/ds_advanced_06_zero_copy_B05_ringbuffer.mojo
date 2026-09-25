# Ring Buffer — fixed-size circular buffer
from std.memory import alloc

struct RingBuffer[T: AnyType]:
    var data: Pointer[T]
    var capacity: Int
    var head: Int  # write position
    var tail: Int  # read position
    var count: Int

    def __init__(out self, capacity: Int):
        self.capacity = capacity
        self.head = 0
        self.tail = 0
        self.count = 0
        self.data = alloc[T](capacity)

    def push(mut self, value: T):
        if self.count == self.capacity:
            raise "Buffer overflow"
        self.data[self.head] = value
        self.head = (self.head + 1) % self.capacity
        self.count += 1

    def pop(mut self) -> T:
        if self.count == 0:
            raise "Buffer underflow"
        var value = self.data[self.tail]
        self.tail = (self.tail + 1) % self.capacity
        self.count -= 1
        return value

# Double Buffering — overlap I/O and compute
struct DoubleBuffer:
    var buffers: Tensor[Float32][2]
    var active: Int

    def __init__(out self, size: Int):
        self.buffers[0] = Tensor[Float32](size)
        self.buffers[1] = Tensor[Float32](size)
        self.active = 0

    def swap(mut self):
        self.active = 1 - self.active

    def read_buffer(ref self) -> Tensor[Float32]:
        return self.buffers[self.active]

    def write_buffer(mut self) -> ref Tensor[Float32]:
        return self.buffers[1 - self.active]

# Pipeline with double buffering
def streaming_pipeline(data: Tensor[Float32]):
    var db = DoubleBuffer(data.size)

    for chunk_idx in range(0, data.size, db.read_buffer().size):
        # Read into write buffer (background I/O)
        var write_buf = db.write_buffer()
        load_chunk(data, chunk_idx, write_buf)

        # Process the read buffer (current active data)
        var read_buf = db.read_buffer()
        transform(read_buf)

        # Swap buffers
        db.swap()
