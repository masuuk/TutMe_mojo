# ============================================================================
#  Mojo 1.x program extracted from the TutMe🔥 tutorial site.
#
#  Source:  public/data_science/ai_agents_python_vs_mojo.html
#  File:    ai_agents_python_vs_mojo_import_python_openai.mojo
#
#  Extracted verbatim from the page code block (see the tutorial for prose
#  that explains each part). Run with:   mojo ai_agents_python_vs_mojo_import_python_openai.mojo
# ============================================================================
from std.python import Python

def main() raises:
    # Import the Python OpenAI package
    var openai = Python.import_module("openai")

  from std.python import Python

def main():
    def main() raises:
        # Import the Python OpenAI package
        var openai = Python.import_module("openai")

        # Create the OpenAI client with explicit API key
        var client = openai.OpenAI(
            api_key="YOUR_API_KEY"
        )

        # Initialize an empty Python list for conversation history
        var messages = Python.list()

        while True:
            # Read a line from stdin using Mojo's builtin input()
            var user_input = input("You: ")

            # Check for exit commands
            var cleaned = user_input.strip().lower()
            if cleaned == "exit" or cleaned == "quit":
                break

            # Add user message using Python.dict()
            messages.append(
                Python.dict(
                    role="user",
                    content=user_input
                )
            )

            # Send conversation to OpenAI
            var response = client.chat.completions.create(
                model="gpt-5-mini",
                messages=messages
            )

            # Extract assistant response
            var reply = response.choices[0].message.content

            # Add assistant response to conversation history
            messages.append(
                Python.dict(
                    role="assistant",
                    content=reply
                )
            )

            # Display response
            print("Bot:", reply)
