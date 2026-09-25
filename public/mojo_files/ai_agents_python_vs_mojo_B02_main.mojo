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
