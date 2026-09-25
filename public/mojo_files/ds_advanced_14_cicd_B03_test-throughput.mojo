from testing import PerformanceTest, baseline

class AttentionPerfTest(PerformanceTest):
    def test_throughput(self):
        var attn = MultiHeadAttention(n_heads=8, d_model=512)
        var x = Tensor[Float32](32, 128, 512)

        // Baseline from last commit (auto-loaded)
        var prev = baseline("attention_throughput")

        // Measure current performance
        var current = self.benchmark(
            def(): attn.forward(x),
            iterations=1000
        )

        // Fail if greater than 5% regression
        self.assert_within_pct(current, prev, tolerance=5.0)
