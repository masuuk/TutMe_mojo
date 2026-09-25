from std.python import Python

def main() raises:
    var openai = Python.import_module("openai")
    var client = openai.OpenAI()

    var messages = Python.list(
        Python.dict(role="user", content="Explain why 'cloud' is a misnomer, in exactly 5 sentences."),
    )

    # stream=True returns an SSE iterator instead of a single whole response
    var stream = client.chat.completions.create(
        model="gpt-5-mini",
        messages=messages,
        stream=True,
    )

    # Iterate the Python iterator from Mojo and print deltas as they arrive
    for var chunk in stream:
        var delta = chunk.choices[0].delta.content
        if delta:
            print(delta, end="")   # accumulate on one line, token by token
    print()
