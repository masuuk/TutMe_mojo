from bench import Benchmark, PerfCounter

// Microbenchmark with statistical rigor
var bench = Benchmark(
    name="matmul_4096x4096",
    warmup=100,
    iterations=10000,
    counters=[PerfCounter.FLOPS, PerfCounter.BANDWIDTH_GB]
)

bench.run(def():
    var c = a @ b
)
bench.report()
// → 12.3 TFLOPS (78% of peak)
// → 487 GB/s memory bandwidth (65% of peak)
// → p50: 0.42ms, p99: 0.48ms, p999: 0.51ms
