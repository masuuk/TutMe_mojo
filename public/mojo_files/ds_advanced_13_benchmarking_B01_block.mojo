from profiler import Profiler, FlameGraphConfig

// Start profiling with flame graph output
var profiler = Profiler(
    FlameGraphConfig(
        output="train_flame.svg",
        sample_rate_us=100,  // 100μs sampling
        include_memory=True,
        track_allocations=True
    )
)

profiler.start()
train_model(model, data, epochs=10)
profiler.stop()

// Generate HTML report with interactive flame graph
profiler.report()
// → train_flame.svg + train_report.html
