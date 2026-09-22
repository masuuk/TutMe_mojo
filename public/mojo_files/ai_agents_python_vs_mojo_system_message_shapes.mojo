# ============================================================================
#  Mojo 1.x program extracted from the TutMe🔥 tutorial site.
#
#  Source:  public/data_science/ai_agents_python_vs_mojo.html
#  File:    ai_agents_python_vs_mojo_system_message_shapes.mojo
#
#  Extracted verbatim from the page code block (see the tutorial for prose
#  that explains each part). Run with:   mojo ai_agents_python_vs_mojo_system_message_shapes.mojo
# ============================================================================
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

    # same generation parameters, passed straight through the interop layerfrom std.python import Python

def main():
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
