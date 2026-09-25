from std.python import Python

def main() raises:
    var openai = Python.import_module("openai")
    var client = openai.OpenAI()

    # The system message shapes behaviour for the whole conversation
    var messages = Python.list(
        Python.dict(
            role="system",
            content="You are a coding mentor. Be brief, use short examples, and never assume the reader has prior knowledge.",
        ),
        Python.dict(role="user", content="What is a closure?"),
    )

    # same generation parameters, passed straight through the interop layer
    var response = client.chat.completions.create(
        model="gpt-5-mini",
        messages=messages,
        temperature=0.7,
        max_tokens=250,
        top_p=0.9,
    )

    print(response.choices[0].message.content)
