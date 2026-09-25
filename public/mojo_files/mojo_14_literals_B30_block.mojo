try:
    operation()
except e:
    handle_error(e)   # Runs if an error occurs
else:
    on_success()      # Runs only if NO error occurred
finally:
    cleanup()         # Always runs last

# Typed errors: the bound variable's type is inferred
try:
    var result = fetch()
except e:            # e is inferred as the declared error type
    print(e.message)
