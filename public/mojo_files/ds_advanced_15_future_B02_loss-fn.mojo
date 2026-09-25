// Compiler-generated autodiff -- no runtime graph overhead
@autodiff
def loss_fn(params: Parameters, data: Batch) -> Float32:
    var pred = model.forward(data.inputs, params)
    return mse_loss(pred, data.labels)

// The compiler generates:
// - Forward pass: as written above
// - Backward pass: analytically differentiated, fused
// - No tape, no graph replay, no Python dispatch

var grad = autodiff(loss_fn)(params, batch)
// Gradients computed at native speed
