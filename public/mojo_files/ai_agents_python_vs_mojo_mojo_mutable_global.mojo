# ============================================================================
#  Mojo 1.x program extracted from the TutMe🔥 tutorial site.
#
#  Source:  public/data_science/ai_agents_python_vs_mojo.html
#  File:    ai_agents_python_vs_mojo_mojo_mutable_global.mojo
#
#  Extracted verbatim from the page code block (see the tutorial for prose
#  that explains each part). Run with:   mojo ai_agents_python_vs_mojo_mojo_mutable_global.mojo
# ============================================================================
from std.python import Python

# Mojo has no mutable global scope, so import modules and build the
# client inside main() and pass them into the helper as arguments.

def get_reply(
    client: PythonObject,
    time: PythonObject,
    messages: PythonObject,
    max_retries: Int = 3,
) raises -> String:
    # Safe send with retry for flaky networks / rate limits
    var attempt: Int = 0
    while attempt < max_retries:
        try:
            var response = client.chat.completions.create(
                model="gpt-5-mini",
                messages=messages,
            )
            return String(py=response.choices[0].message.content)
        except:
            # Bare except: interop surfaces Python exceptions as Mojo errors.
            # Exponential backoff: 1s, 2s, 4s
            var wait: Float64 = 2.0 ** Float64(attempt)
            print("Error — retrying in " + str(wait) + "s")
            time.sleep(wait)
            attempt += 1
    raise Error("Exceeded max retries")

def main() raises:
    var openai = Python.import_module("openai")
    var time = Python.import_module("time")
    var client = openai.OpenAI()

    var messages = Python.list(
        Python.dict(role="user", content="Why is the sky blue?")
    )
    print(get_reply(client, time, messages))
