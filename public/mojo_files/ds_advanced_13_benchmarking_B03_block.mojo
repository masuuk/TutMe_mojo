from profiler import MemoryTracer, MemoryReport

var tracer = MemoryTracer(
    snapshot_interval=1000,  // Every 1000 allocations
    track_lifetime=True,
    detect_leaks=True
)

tracer.start()
var result = model.forward(batch)
tracer.stop()

// Analyze allocation patterns
var report = tracer.report()
print(report.peak_memory_bytes())    // Peak RSS
print(report.allocation_count())      // Total allocations
print(report.temporary_count())       // Allocations freed within 1 step
print(report.leak_count())            // Potential memory leaks

// Show top 10 allocation hotspots
report.top_allocators(n=10)
// → attention.bmm: 847 allocations (2.1 GB)
// → layer_norm.reduce: 512 allocations (128 MB)
