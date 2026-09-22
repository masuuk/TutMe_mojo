# ============================================================================
#  Mojo 1.x program extracted from the TutMe🔥 tutorial site.
#
#  Source:  public/data_science/ai_agents_python_vs_mojo.html
#  File:    ai_agents_python_vs_mojo_import_python_interop.mojo
#
#  Extracted verbatim from the page code block (see the tutorial for prose
#  that explains each part). Run with:   mojo ai_agents_python_vs_mojo_import_python_interop.mojo
# ============================================================================
def main():
    # Import the Python interop standard library
    from std.python import Python

    # Mojo requires an explicit main function with a 'raises' trait for error handling
    def main() raises:
        # Import the Python OpenAI package
        var openai = Python.import_module("openai")

        # Create the OpenAI client
        var client = openai.OpenAI()

        # Build the request using Python's list and dict constructors via interop
        var messages = Python.list(
            Python.dict(
                role="user",
                content="Explain what an AI agent is in one sentence."
            )
        )

        # Send the request (calls the Python API directly)
        var response = client.chat.completions.create(
            model="gpt-5-mini",
            messages=messages
        )

        # Print the answer
        print(response.choices[0].message.content)
