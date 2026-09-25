"Hello"  'world'
"""Multi-line string
"""                  # Includes final newline
"""\
No leading newline.""" # Backslash at end of line joins the next line

# Adjacent literals are joined into one string
var x = "Hello, " "World"       # "Hello, World"

# Raw strings: r or R disables escape processing
var path = r"C:\path\to\file"     # Backslashes literal
