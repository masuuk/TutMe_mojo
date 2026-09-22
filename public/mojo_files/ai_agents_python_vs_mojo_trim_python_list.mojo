# ============================================================================
#  Mojo 1.x program extracted from the TutMe🔥 tutorial site.
#
#  Source:  public/data_science/ai_agents_python_vs_mojo.html
#  File:    ai_agents_python_vs_mojo_trim_python_list.mojo
#
#  Extracted verbatim from the page code block (see the tutorial for prose
#  that explains each part). Run with:   mojo ai_agents_python_vs_mojo_trim_python_list.mojo
# ============================================================================
from std.python import Python

# Trim a Python list from the front until it fits under the limit
def trim(history: PythonObject, max_history: Int):
    while len(history) > max_history:
        history.pop(0)

def main() raises:
    var openai = Python.import_module("openai")
    var client = openai.OpenAI()
    var max_history: Int = 10

    var messages = Python.list(
        Python.dict(
            role="system",
            content="You are a pithy assistant. Answer in one or two sentences.",
        )
    )

    while True:
        var user_input = input("You: ")
        var cleaned = user_input.strip().lower()
        if cleaned == "exit" or cleaned == "quit":
            break

        messages.append(Python.dict(role="user", content=user_input))
        trim(messages, max_history)

        var response = client.chat.completions.create(
            model="gpt-5-mini",
            messages=messages,
        )
        var reply = response.choices[0].message.content

        messages.append(Python.dict(role="assistant", content=reply))
        trim(messages, max_history)

        print("Bot:", reply)
