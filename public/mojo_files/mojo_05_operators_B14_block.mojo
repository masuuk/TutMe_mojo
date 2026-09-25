var full = "Mo" + "jo"       # concatenation → "Mojo"
var rule = "=" * 20          # repetition

# Prefer the constructor when joining many pieces:
var path = String("/home", "/", "user", "/notes")
print(path)
