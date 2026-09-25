from ci import ArtifactCache, CacheKey

var cache = ArtifactCache(
    backend=CacheBackend.S3,
    prefix="ml-pipeline",
    ttl_days=30
)

// Hash-based caching: skip if inputs unchanged
var key = CacheKey.from_files([
    "data/raw.parquet",
    "src/preprocess.mojo",
    "config/hyperparams.yaml"
])

if cache.exists(key):
    var dataset = cache.load(key)
    print("Cache hit -- skipping preprocessing")
else:
    var dataset = preprocess(raw_data)
    cache.save(key, dataset)
    print("Cache miss -- preprocessing and storing")

// Model compilation cache
var model_key = CacheKey.from_config({
    "model": "transformer_v3",
    "precision": "fp16",
    "target": "cuda",
    "weights_hash": weights.sha256()
})

var compiled = cache.get_or_compile(model_key, def():
    compile_model(model, CompileConfig(precision=Float16))
)
