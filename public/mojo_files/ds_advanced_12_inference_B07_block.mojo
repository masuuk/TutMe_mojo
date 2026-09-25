from export import export_model, ExportFormat

// Export to Mojo's native format
export_model(
    model,
    path="./model.mojomodel",
    format=ExportFormat.MOJO,
    sample_input=example_batch
)

// Export to ONNX for cross-framework compatibility
export_model(
    model,
    path="./model.onnx",
    format=ExportFormat.ONNX,
    opset_version=17
)

// Export weights only (SafeTensors)
export_model(
    model,
    path="./weights.safetensors",
    format=ExportFormat.SAFETENSORS
)
