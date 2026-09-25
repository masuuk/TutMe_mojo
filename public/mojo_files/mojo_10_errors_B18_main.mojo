def main() raises:
    try:
        func1()
    except e:
        print(e)
        var stack_trace = e.get_stack_trace()
        if stack_trace:
            print(stack_trace.value())
        else:
            print("No stack trace available")
