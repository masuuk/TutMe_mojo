# ============================================================================
#  Mojo 1.x program extracted from the TutMe🔥 tutorial site.
#
#  Source:  public/data_science/ai_agents_python_vs_mojo.html
#  File:    ai_agents_python_vs_mojo_tool.mojo
#
#  Extracted verbatim from the page code block (see the tutorial for prose
#  that explains each part). Run with:   mojo ai_agents_python_vs_mojo_tool.mojo
# ============================================================================
from std.python import Python

# A tool: a plain Mojo function. Swap the body for a real weather API in production.
def get_weather(city: String) -> String:
    return "Current conditions in " + city + ": 21°C, partly cloudy, 10% chance of rain."

def main() raises:
    var openai = Python.import_module("openai")
    var json = Python.import_module("json")
    var client = openai.OpenAI()

    # 1) Describe the tool so the model knows it exists and how to call it
    var tools = Python.list(
        Python.dict(
            type="function",
            function=Python.dict(
                name="get_weather",
                description="Get the current weather for a city",
                parameters=Python.dict(
                    type="object",
                    properties=Python.dict(
                        city=Python.dict(
                            type="string",
                            descrfrom std.python import Python

def main():
    # A tool: a plain Mojo function. Swap the body for a real weather API in production.
    def get_weather(city: String) -> String:
        return "Current conditions in " + city + ": 21°C, partly cloudy, 10% chance of rain."

    def main() raises:
        var openai = Python.import_module("openai")
        var json = Python.import_module("json")
        var client = openai.OpenAI()

        # 1) Describe the tool so the model knows it exists and how to call it
        var tools = Python.list(
            Python.dict(
                type="function",
                function=Python.dict(
                    name="get_weather",
                    description="Get the current weather for a city",
                    parameters=Python.dict(
                        type="object",
                        properties=Python.dict(
                            city=Python.dict(
                                type="string",
                                description="City name",
                            )
                        ),
                        required=Python.list("city"),
                    ),
                ),
            )
        )

        var messages = Python.list(
            Python.dict(
                role="user",
                content="Should I bring an umbrella in Berlin tomorrow?",
            )
        )

        # 2) Ask, letting the model decide when to use the tool ("auto")
        var response = client.chat.completions.create(
            model="gpt-5-mini",
            messages=messages,
            tools=tools,
            tool_choice="auto",
        )

        var message = response.choices[0].message

        if message.tool_calls:
            # 3) The model requested a call — execute it locally...
            for var call in message.tool_calls:
                var args = json.loads(call.function.arguments)
                var result = get_weather(String(py=args["city"]))

                # 4) ...and feed the result back as a "tool" message
                messages.append(
                    Python.dict(
                        role="tool",
                        tool_call_id=call.id,
                        content=result,
                    )
                )

            # 5) Ask again with the tool result in context for the final answer
            var final = client.chat.completions.create(
                model="gpt-5-mini",
                messages=messages,
                tools=tools,
            )
            print(final.choices[0].message.content)
        else:
            print(message.content)
