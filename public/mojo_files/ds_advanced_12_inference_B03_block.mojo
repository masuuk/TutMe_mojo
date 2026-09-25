// The compiler sees this sequence:
var x = matmul(q, k_transposed)
var x = x / sqrt(d_k)
var x = softmax(x, axis=-1)
var x = matmul(x, v)

// And compiles it into a single fused attention kernel
// No intermediate tensors allocated on the heap

// You can inspect the fusion report:
compiled.fusion_report()
// → "Fused 4 ops into 1 kernel (attention)
//    Memory saved: 3 allocations eliminated
//    Speedup: 2.3x vs unfused"
