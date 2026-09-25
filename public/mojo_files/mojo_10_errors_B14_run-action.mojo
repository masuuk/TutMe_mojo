def run_action[
    ErrorType: AnyType
](action: def() thin raises ErrorType -> Int) raises ErrorType -> Int:
    return action()

# fetch_data() raises NetworkError → run_action raises NetworkError
# parse_config() raises ParseError  → run_action raises ParseError

# A non-raising argument infers Never — run_action becomes
# non-raising, and no try block is needed:
var result = run_action(get_value)
print("Got value:", result)
