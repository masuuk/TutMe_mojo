from pipeline import Pipeline, stage
from io import FileSource, BatchedSource

struct InferencePipeline:
    var model: TwoLayerNet
    var preprocessor: StandardScaler

    def __init__(out self, model_path: String):
        self.model = load_model(model_path)
        self.preprocessor = load_scaler(model_path)

    def run(self, source: FileSource) -> Tensor[Float32]:
        var pipe = Pipeline()
        pipe.add(stage("read", source.read_csv))
        pipe.add(stage("preprocess",
                       self.preprocessor.transform))
        pipe.add(stage("batch",
                       BatchedSource[64].batch))
        pipe.add(stage("predict",
                       self.model.forward_batch))
        return pipe.execute()

# Run end-to-end pipeline
var pipeline = InferencePipeline("model.bin")
var results = pipeline.run(FileSource("data.csv"))
