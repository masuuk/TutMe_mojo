from testing import TestCase, assert_close, assert_no_nan

class AttentionTest(TestCase):
    def test_output_shape(self):
        var attn = MultiHeadAttention(n_heads=8, d_model=512)
        var x = Tensor[Float32](1, 10, 512)
        var out = attn(x)
        assert_close(out.shape, TensorShape(1, 10, 512))

    def test_no_nan(self):
        var x = Tensor[Float32](random_floats(shape=(4, 128, 768)))
        var out = model.forward(x)
        assert_no_nan(out)

    def test_numerical_stability(self):
        // Test with extreme values
        var x = Tensor[Float32](1e6, shape=(1, 1, 512))
        var out = model.forward(x)
        assert_no_nan(out)
        // Output should be finite even with large inputs
        assert all(out.to_list().map(is_finite))
