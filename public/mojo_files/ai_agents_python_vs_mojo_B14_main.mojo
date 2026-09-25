from std.python import Python

def main() raises:
    var openai = Python.import_module("openai")
    var json = Python.import_module("json")
    var client = openai.OpenAI()

    var response = client.chat.completions.create(
        model="gpt-5-mini",
        messages=Python.list(
            Python.dict(role="system", content="You output valid JSON only. No markdown, no prose."),
            Python.dict(role="user", content="List 3 fruits with a color and a price each."),
        ),
        response_format=Python.dict(type="json_object"),   # guarantee valid JSON output
    )

    # Parse via interop and work with the data programmatically
    var data = json.loads(response.choices[0].message.content)

    for var fruit in data["fruits"]:
        print(String(py=fruit["name"]) + " — " + String(py=fruit["color"]) + " — $" + String(py=fruit["price"]))
