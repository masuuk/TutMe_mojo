try:
    var name = validate_username("")
except e:
    # e is a ValidationError — fields accessed directly, no casting:
    print("Error in field '" + e.field + "': " + e.reason)

# Output: Error in field 'username': cannot be empty
