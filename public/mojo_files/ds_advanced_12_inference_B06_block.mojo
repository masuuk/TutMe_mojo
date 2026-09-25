from serve import Server, ModelConfig, BatchingConfig

// Load and serve a compiled model
var model_cfg = ModelConfig(
    path="./compiled_model.mojomodel",
    max_batch_size=32,
    timeout_ms=50
)

var server = Server(
    models=[model_cfg],
    port=8080,
    batching=BatchingConfig(
        strategy=Strategy.DYNAMIC,
        max_wait_ms=5
    ),
    auth=AuthConfig(api_keys=["sk-..."])
)

// Start serving — OpenAI-compatible API
server.start()
// POST /v1/chat/completions
// POST /v1/embeddings
// GET  /v1/models
