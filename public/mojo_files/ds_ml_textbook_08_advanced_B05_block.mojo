from onnx import ONNXModel

# Load a pre-trained ONNX model
var model = ONNXModel.load("resnet50.onnx")

# Run inference
var input_tensor = preprocess_image("photo.jpg")
var output = model.run(input_tensor)

# Get top-5 predictions
var predictions = softmax(output)
for i in range(5):
    var idx = argmax(predictions)
    print("Class", idx, ":", predictions[idx])
    predictions[idx] = 0.0
