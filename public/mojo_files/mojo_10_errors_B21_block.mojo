# FileHandle is a context manager — close() is automatic:
with open(input_file, "r") as f:
    var content = f.read()

# Multiple managers in one statement:
with open(input_file, "r") as f_in, open(output_file, "w") as f_out:
    var output_text = f_in.read().upper()
    f_out.write(output_text)
