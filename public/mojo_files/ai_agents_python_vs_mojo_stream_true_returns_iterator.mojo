# ============================================================================
#  Mojo 1.x program extracted from the TutMe🔥 tutorial site.
#
#  Source:  public/data_science/ai_agents_python_vs_mojo.html
#  File:    ai_agents_python_vs_mojo_stream_true_returns_iterator.mojo
#
#  Extracted verbatim from the page code block (see the tutorial for prose
#  that explains each part). Run with:   mojo ai_agents_python_vs_mojo_stream_true_returns_iterator.mojo
# ============================================================================
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
            print(from std.python import Python

def main():
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
