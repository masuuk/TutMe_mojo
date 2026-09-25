import std.time

@fieldwise_init
struct Timer(ImplicitlyCopyable):
    var start_time: Int

    def __enter__(mut self) -> Self:
        self.start_time = Int(time.perf_counter_ns())
        return self

    def __exit__(mut self):
        var elapsed_ms = round(
            Float64(time.perf_counter_ns() - self.start_time) / 1e6, 3
        )
        print("Elapsed time:", elapsed_ms, "milliseconds")

def main() raises:
    with Timer():
        print("Beginning execution")
        time.sleep(1.0)
        print("Ending execution")
