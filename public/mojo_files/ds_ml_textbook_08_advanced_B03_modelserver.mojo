from inference import serve, Request, Response

struct ModelServer:
    var model: TwoLayerNet

    def __init__(out self, path: String):
        self.model = load_model(path)

    def handle(self, req: Request) -> Response:
        var input = parse_input(req.body)
        var prediction = self.model.forward(input)
        return Response(
            status=200,
            body=to_json(prediction),
        )

def main():
    var server = ModelServer("model.bin")
    serve(server.handle, port=8080)
    print("Server running on port 8080")
