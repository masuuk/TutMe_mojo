from quantize import QuantConfig, quantize_model, CalibrationData

// INT8 dynamic quantization with calibration
var qcfg = QuantConfig(
    dtype=Int8,
    method=Method.DYNAMIC,
    calibration=CalibrationData.from_dataset(
        val_data, num_samples=1000
    )
)

// Quantize — preserves accuracy with calibration
var quantized = quantize_model(model, qcfg)
print(quantized.size_bytes())  // ~75% reduction

// Mixed precision: keep sensitive layers at FP16
quantized.set_precision("attention.qkv", Float16)
quantized.set_precision("output_head", Float32)
